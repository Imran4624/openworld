import 'dart:core';
import 'package:built_collection/built_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/data/repositories/firebase_repository.dart';
import 'package:flutter_boilerplate/data/models/serializers.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';

class ProfileOperationRepository {
  const ProfileOperationRepository();

  static final FirebaseRepository _firebaseRepository =
      FirebaseRepository('profileOperations');

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<ProfileOperationEntity> loadItem(
      Credentials credentials, String entityId) async {
    final data = await _firebaseRepository.getItem(entityId);

    if (data != null) {
      final profileOperation =
          serializers.deserializeWith(ProfileOperationEntity.serializer, data)!;

      try {
        final ProfileEntity profile =
            await _fetchProfileForOperation(profileOperation);
        return profileOperation
            .rebuild((b) => b..profileEntity = profile.toBuilder());
      } catch (e) {
        logError(' Error fetching profile for operation: $e');
        return profileOperation;
      }
    }
    throw Exception('ProfileOperation with ID $entityId not found');
  }

  Future<ProfileEntity> _fetchProfileForOperation(
      ProfileOperationEntity operation) async {
    try {
      final String? profileId = operation.assignedUserId;

      if (profileId == null || profileId.isEmpty) {
        return ProfileEntity();
      }

      final docSnapshot =
          await _firestore.collection('users').doc(profileId).get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        return ProfileMapper.dbToEntity(data, profileId);
      } else {
        return ProfileEntity(id: profileId);
      }
    } catch (e) {
      logError(' Error fetching profile: $e');
      return ProfileEntity();
    }
  }

  Future<BuiltList<ProfileOperationEntity>> loadList(
      Credentials credentials) async {
    final response = await _firebaseRepository.getList();
    final dataList = response['data'] as List<Map<String, dynamic>>;
    final profileOperations = dataList
        .map((data) => serializers.deserializeWith(
            ProfileOperationEntity.serializer, data)!)
        .toList();

    return BuiltList<ProfileOperationEntity>(profileOperations);
  }

  Future<Map<String, dynamic>> loadListWithPagination({
    DocumentSnapshot? lastDocument,
    int limit = 10,
    ProfileOperationFilter? filter,
    String? tabType,
    String? currentUserId,
  }) async {
    if (currentUserId == null) {
      throw Exception('User not authenticated');
    }

    Query query;
    logInfo('tab type selected ==> $tabType');
    if (tabType != null) {
      switch (tabType) {
        case 'I Liked':
          query = _firestore
              .collection('users')
              .doc(currentUserId)
              .collection('likes');
          break;
        case 'Liked Me':
          query = _firestore
              .collection('users')
              .doc(currentUserId)
              .collection('matches')
              .where('status', isEqualTo: MatchStatus.pending);
          break;
        case 'Matches':
          query = _firestore
              .collection('users')
              .doc(currentUserId)
              .collection('matches')
              .where('status', isEqualTo: MatchStatus.matched);
          break;
        case 'Passes':
          query = _firestore
              .collection('users')
              .doc(currentUserId)
              .collection('passes');
          break;
        case 'Comments':
          query = _firestore
              .collection('users')
              .doc(currentUserId)
              .collection('comments');
          break;
        default:
          query = _firestore.collection('profileOperations');
      }
    } else {
      query = _firestore.collection('profileOperations');
    }

    if (filter != null) {
      final queryParams = filter.toFirebaseQuery();
      final filters = queryParams['filters'] as Map<String, dynamic>;

      if (tabType == null) {
        if (filter.stateFilter == EntityState.archived) {
          query = query
              .where('is_deleted', isEqualTo: false)
              .where('archived_at', isGreaterThan: 0)
              .orderBy('archived_at', descending: true);
        } else if (filter.stateFilter == EntityState.deleted) {
          query = query
              .where('is_deleted', isEqualTo: true)
              .orderBy('created_at', descending: true);
        } else {
          query = query
              .where('is_deleted', isEqualTo: false)
              .where('archived_at', isEqualTo: 0)
              .orderBy('created_at', descending: true);
        }

        if (filters['title'] != null) {
          query = query.where('title',
              isGreaterThanOrEqualTo: filters['title'],
              isLessThanOrEqualTo: filters['title'] + '\uf8ff');
        }
      }
    } else {
      if (tabType == null) {
        logError(' ##No Tab Selected');
        query = query.orderBy('created_at', descending: true);
      }
    }

    if (limit > 0) {
      query = query.limit(limit);
    }

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    try {
      final QuerySnapshot snapshot = await query.get();
      final List<ProfileOperationEntity> profileOperations = [];
      DocumentSnapshot? lastDocumentSnapshot;

      if (snapshot.docs.isEmpty) {
        return {
          'profileOperations': BuiltList<ProfileOperationEntity>([]),
          'lastDocument': null,
        };
      }

      lastDocumentSnapshot = snapshot.docs.last;

      final Set<String> targetUserIds = snapshot.docs
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return data['assigned_user_id'] as String? ?? '';
          })
          .where((id) => id.isNotEmpty)
          .toSet();

      final Map<String, ProfileEntity> profilesMap =
          await _fetchProfilesInBatch(targetUserIds.toList());

      for (final doc in snapshot.docs) {
        try {
          final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

          final String operationId = doc.id;

          final String targetUserId = data['assigned_user_id'] ?? '';

          final operation = ProfileOperationEntity().rebuild((b) => b
            ..id = operationId
            ..createdAt = data['created_at'] ?? 0
            ..updatedAt = data['updated_at'] ?? 0
            ..archivedAt = data['archived_at'] ?? 0
            ..isDeleted = data['is_deleted'] ?? false
            ..createdUserId = data['created_user_id'] ?? ''
            ..assignedUserId = targetUserId
            ..status = data['status'] ?? 0
            ..comment = data['comment'] ?? ''
            ..type = data['type'] ?? 0);

          if (targetUserId.isNotEmpty &&
              profilesMap.containsKey(targetUserId)) {
            final profileWithEntity = operation.rebuild((b) =>
                b..profileEntity = profilesMap[targetUserId]!.toBuilder());
            profileOperations.add(profileWithEntity);
          } else {
            final unknownProfile = ProfileEntity(id: targetUserId)
                .rebuild((pb) => pb..name = 'Unknown User');
            final profileWithEmptyEntity = operation
                .rebuild((b) => b..profileEntity = unknownProfile.toBuilder());
            profileOperations.add(profileWithEmptyEntity);
          }
        } catch (e) {
          logError(' Error processing profile operation document: $e');
        }
      }

      return {
        'profileOperations':
            BuiltList<ProfileOperationEntity>(profileOperations),
        'lastDocument': lastDocumentSnapshot,
      };
    } catch (e) {
      logError(' Error loading profile operations: $e');
      return {
        'profileOperations': BuiltList<ProfileOperationEntity>([]),
        'lastDocument': null,
      };
    }
  }

  Future<Map<String, ProfileEntity>> _fetchProfilesInBatch(
      List<String> userIds) async {
    final Map<String, ProfileEntity> profilesMap = {};

    if (userIds.isEmpty) {
      return profilesMap;
    }

    try {
      for (int i = 0; i < userIds.length; i += 10) {
        final int end = (i + 10 < userIds.length) ? i + 10 : userIds.length;
        final batchUserIds = userIds.sublist(i, end);

        try {
          final querySnapshot = await _firestore
              .collection('users')
              .where(FieldPath.documentId, whereIn: batchUserIds)
              .get();

          for (final doc in querySnapshot.docs) {
            final data = doc.data();
            final String userId = doc.id;

            try {
              final profile = ProfileMapper.dbToEntity(data, userId);
              profilesMap[userId] = profile;
            } catch (e) {
              logError(' Error creating profile for $userId: $e');
              profilesMap[userId] = ProfileEntity(id: userId)
                  .rebuild((b) => b..name = 'Error loading profile');
            }
          }
        } catch (e) {
          logError(' Error fetching batch of profiles: $e');
        }
      }

      return profilesMap;
    } catch (error) {
      logError(' Error in _fetchProfilesInBatch: $error');
      return profilesMap;
    }
  }

  Future<Map<String, dynamic>> loadListFromSubcollection({
    required String userId,
    required String subcollection,
    int? statusFilter,
    DocumentSnapshot? lastDocument,
    int limit = 10,
  }) async {
    try {
      final collectionRef =
          _firestore.collection('users').doc(userId).collection(subcollection);

      Query query = collectionRef
          .where('is_deleted', isEqualTo: false)
          .orderBy('created_at', descending: true);

      if (statusFilter != null) {
        query = query.where('status', isEqualTo: statusFilter);
      }

      // Apply pagination
      if (limit > 0) {
        query = query.limit(limit);
      }

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      final querySnapshot = await query.get();

      if (querySnapshot.docs.isEmpty) {
        return {
          'profileOperations': BuiltList<ProfileOperationEntity>([]),
          'lastDocument': null,
        };
      }

      final lastDocumentSnapshot =
          querySnapshot.docs.isNotEmpty ? querySnapshot.docs.last : null;

      final profileOperations = <ProfileOperationEntity>[];

      for (final doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;

        // Create the profile operation entity
        final profileOperation = ProfileOperationEntity().rebuild((b) => b
          ..id = doc.id
          ..createdAt = data['created_at'] ?? 0
          ..updatedAt = data['updated_at'] ?? 0
          ..archivedAt = data['archived_at'] ?? 0
          ..isDeleted = data['is_deleted'] ?? false
          ..createdUserId = data['created_user_id'] ?? ''
          ..assignedUserId = data['assigned_user_id'] ?? ''
          ..status = data['status'] ?? 0
          ..comment = data['comment'] ?? ''
          ..type = data['type'] ?? 0);

        profileOperations.add(profileOperation);
      }

      return {
        'profileOperations':
            BuiltList<ProfileOperationEntity>(profileOperations),
        'lastDocument': lastDocumentSnapshot,
      };
    } catch (error) {
      logError(' Error loading from subcollection $subcollection: $error');
      return {
        'profileOperations': BuiltList<ProfileOperationEntity>([]),
        'lastDocument': null,
      };
    }
  }

  Future<List<ProfileEntity>> loadProfilesForUserIds(
      List<String> userIds) async {
    if (userIds.isEmpty) {
      return [];
    }

    try {
      final Map<String, ProfileEntity> profilesMap =
          await _fetchProfilesInBatch(userIds);
      return profilesMap.values.toList();
    } catch (error) {
      logError(' Error in loadProfilesForUserIds: $error');
      return [];
    }
  }

  Future<List<ProfileOperationEntity>> bulkAction(
      Credentials credentials, List<String> ids, EntityAction action) async {
    if (action == EntityAction.delete) {
      for (var id in ids) {
        final data = {'is_deleted': true};
        await _firebaseRepository.updateItem(id, data);
      }
    } else if (action == EntityAction.archive) {
      final int currentTime = DateTime.now().millisecondsSinceEpoch;
      for (var id in ids) {
        final data = {'archived_at': currentTime};
        await _firebaseRepository.updateItem(id, data);
      }
    } else if (action == EntityAction.restore) {
      for (var id in ids) {
        final data = {'archived_at': 0, 'is_deleted': false};
        await _firebaseRepository.updateItem(id, data);
      }
    } else if (action == EntityAction.purge) {
      await _firebaseRepository.deleteItems(ids);
    }

    return ids.map((id) => ProfileOperationEntity(id: id)).toList();
  }

  Future<ProfileOperationEntity> saveData(
      Credentials credentials, ProfileOperationEntity profileOperation) async {
    final data = serializers.serializeWith(
            ProfileOperationEntity.serializer, profileOperation)
        as Map<String, dynamic>;

    if (profileOperation.id.isEmpty ||
        !(await _firebaseRepository.itemExists(profileOperation.id))) {
      final newId = _firestore.collection('profileOperations').doc().id;
      data['id'] = newId;

      await _firebaseRepository.saveItem(newId, data);
      return profileOperation.rebuild((b) => b..id = newId);
    } else {
      await _firebaseRepository.saveItem(profileOperation.id, data);
      return profileOperation;
    }
  }

  Future<ProfileOperationEntity> likeProfile({
    required String currentUserId,
    required String targetUserId,
    required int type,
  }) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    final existingLikeDoc = await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('likes')
        .doc(targetUserId)
        .get();

    if (existingLikeDoc.exists) {
      final data = existingLikeDoc.data() as Map<String, dynamic>;
      final existingLike = ProfileOperationEntity().rebuild((b) => b
        ..id = existingLikeDoc.id
        ..createdUserId = data['created_user_id'] ?? currentUserId
        ..assignedUserId = data['assigned_user_id'] ?? targetUserId
        ..type = data['type'] ?? 1
        ..status = data['status'] ?? type
        ..comment = data['comment'] ?? 'User liked this profile'
        ..createdAt = data['created_at'] ?? timestamp
        ..updatedAt = data['updated_at'] ?? timestamp
        ..archivedAt = data['archived_at'] ?? 0
        ..isDeleted = data['is_deleted'] ?? false);
      return existingLike;
    }

    final operationId = _firestore.collection('profileOperations').doc().id;

    final profileOperation = ProfileOperationEntity().rebuild((b) => b
      ..id = operationId
      ..createdUserId = currentUserId
      ..assignedUserId = targetUserId
      ..type = ProfileOperationType.like
      ..status = type
      ..comment = 'User liked this profile'
      ..createdAt = timestamp
      ..updatedAt = timestamp
      ..archivedAt = 0
      ..isDeleted = false);

    final Map<String, dynamic> profileOperationData = serializers.serializeWith(
            ProfileOperationEntity.serializer, profileOperation)
        as Map<String, dynamic>;

    WriteBatch batch = _firestore.batch();

    batch.set(
        _firestore
            .collection('users')
            .doc(currentUserId)
            .collection('likes')
            .doc(targetUserId),
        profileOperationData);
    batch.update(
      _firestore.collection('users').doc(currentUserId),
      {'likesProfileMap.$targetUserId': profileOperationData},
    );

    final matchOperation = profileOperation.rebuild((b) => b
      ..id = _firestore.collection('profileOperations').doc().id
      ..createdUserId = targetUserId
      ..assignedUserId = currentUserId
      ..type = ProfileOperationType.match
      ..status = MatchStatus.pending
      ..comment = 'Match request pending');

    final Map<String, dynamic> matchOperationData = serializers.serializeWith(
            ProfileOperationEntity.serializer, matchOperation)
        as Map<String, dynamic>;

    batch.set(
        _firestore
            .collection('users')
            .doc(targetUserId)
            .collection('matches')
            .doc(currentUserId),
        matchOperationData);
    batch.update(
      _firestore.collection('users').doc(targetUserId),
      {'likedMeProfileMap.$currentUserId': matchOperationData},
    );

    await batch.commit();

    return profileOperation;
  }

  Future<ProfileOperationEntity> acceptMatchRequest({
    required String currentUserId,
    required String targetUserId,
  }) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    // First verify the match request exists
    final pendingMatchDoc = await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('matches')
        .doc(targetUserId)
        .get();

    if (!pendingMatchDoc.exists) {
      throw Exception('No pending match request found from this user');
    }

    final operationId = _firestore.collection('profileOperations').doc().id;

    final matchOperation = ProfileOperationEntity().rebuild((b) => b
      ..id = operationId
      ..createdUserId = currentUserId
      ..assignedUserId = targetUserId
      ..type = ProfileOperationType.match
      ..status = MatchStatus.matched
      ..comment = 'Match accepted'
      ..createdAt = timestamp
      ..updatedAt = timestamp
      ..archivedAt = 0
      ..isDeleted = false);

    final Map<String, dynamic> matchOperationData = serializers.serializeWith(
            ProfileOperationEntity.serializer, matchOperation)
        as Map<String, dynamic>;

    WriteBatch batch = _firestore.batch();

    batch.set(
        _firestore
            .collection('users')
            .doc(currentUserId)
            .collection('matches')
            .doc(targetUserId),
        matchOperationData);
    batch.update(
      _firestore.collection('users').doc(currentUserId),
      {'matchesProfileMap.$targetUserId': matchOperationData},
    );

    final reciprocalOperationId =
        _firestore.collection('profileOperations').doc().id;
    final reciprocalMatch = matchOperation.rebuild((b) => b
      ..id = reciprocalOperationId
      ..createdUserId = targetUserId
      ..assignedUserId = currentUserId);

    final Map<String, dynamic> reciprocalMatchData = serializers.serializeWith(
            ProfileOperationEntity.serializer, reciprocalMatch)
        as Map<String, dynamic>;

    batch.set(
        _firestore
            .collection('users')
            .doc(targetUserId)
            .collection('matches')
            .doc(currentUserId),
        reciprocalMatchData);
    batch.update(
      _firestore.collection('users').doc(currentUserId),
      {'matchesProfileMap.$targetUserId': reciprocalMatchData},
    );

    batch.delete(_firestore
        .collection('users')
        .doc(targetUserId)
        .collection('likes')
        .doc(currentUserId));
    batch.update(_firestore.collection('users').doc(currentUserId),
        {'likedMeProfileMap.$targetUserId': FieldValue.delete()});

    await batch.commit();

    return matchOperation;
  }

  Future<ProfileOperationEntity> passProfile({
    required String currentUserId,
    required String targetUserId,
  }) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    final operationId = _firestore.collection('profileOperations').doc().id;

    final profileOperation = ProfileOperationEntity().rebuild((b) => b
      ..id = operationId
      ..createdUserId = currentUserId
      ..assignedUserId = targetUserId
      ..type = ProfileOperationType.pass
      ..status = 0
      ..comment = 'User passed on this profile'
      ..createdAt = timestamp
      ..updatedAt = timestamp
      ..archivedAt = 0
      ..isDeleted = false);

    final Map<String, dynamic> profileOperationData = serializers.serializeWith(
            ProfileOperationEntity.serializer, profileOperation)
        as Map<String, dynamic>;

    WriteBatch batch = _firestore.batch();

    batch.set(
        _firestore
            .collection('users')
            .doc(currentUserId)
            .collection('passes')
            .doc(targetUserId),
        profileOperationData);
    batch.update(
      _firestore.collection('users').doc(currentUserId),
      {'passesProfileMap.$targetUserId': profileOperationData},
    );

    batch.delete(_firestore
        .collection('users')
        .doc(currentUserId)
        .collection('likes')
        .doc(targetUserId));

    batch.update(_firestore.collection('users').doc(currentUserId),
        {'likesProfileMap.$targetUserId': FieldValue.delete()});
    batch.delete(_firestore
        .collection('users')
        .doc(currentUserId)
        .collection('matches')
        .doc(targetUserId));

    batch.update(_firestore.collection('users').doc(currentUserId),
        {'likedMeProfileMap.$targetUserId': FieldValue.delete()});

    batch.delete(_firestore
        .collection('users')
        .doc(targetUserId)
        .collection('matches')
        .doc(currentUserId));

    batch.update(_firestore.collection('users').doc(currentUserId),
        {'matchesProfileMap.$targetUserId': FieldValue.delete()});
    await batch.commit();

    return profileOperation;
  }

  Future<ProfileOperationEntity> blockProfile({
    required String currentUserId,
    required String targetUserId,
  }) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    final operationId = _firestore.collection('profileOperations').doc().id;

    final profileOperation = ProfileOperationEntity().rebuild((b) => b
      ..id = operationId
      ..createdUserId = currentUserId
      ..assignedUserId = targetUserId
      ..type = ProfileOperationType.block
      ..status = 0
      ..comment = 'User blocked this profile'
      ..createdAt = timestamp
      ..updatedAt = timestamp
      ..archivedAt = 0
      ..isDeleted = false);

    final Map<String, dynamic> profileOperationData = serializers.serializeWith(
            ProfileOperationEntity.serializer, profileOperation)
        as Map<String, dynamic>;

    WriteBatch batch = _firestore.batch();

    batch.set(
        _firestore
            .collection('users')
            .doc(currentUserId)
            .collection('blocks')
            .doc(targetUserId),
        profileOperationData);

    batch.delete(_firestore
        .collection('users')
        .doc(currentUserId)
        .collection('likes')
        .doc(targetUserId));

    batch.delete(_firestore
        .collection('users')
        .doc(currentUserId)
        .collection('matches')
        .doc(targetUserId));

    batch.delete(_firestore
        .collection('users')
        .doc(targetUserId)
        .collection('matches')
        .doc(currentUserId));

    batch.delete(_firestore
        .collection('users')
        .doc(targetUserId)
        .collection('likes')
        .doc(currentUserId));

    await batch.commit();

    return profileOperation;
  }

  Future<ProfileOperationEntity> favoriteProfile({
    required String currentUserId,
    required String targetUserId,
  }) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    // Generate a unique ID for the operation
    final operationId = _firestore.collection('profileOperations').doc().id;

    // Create the favorite operation entity
    final profileOperation = ProfileOperationEntity().rebuild((b) => b
      ..id = operationId
      ..createdUserId = currentUserId
      ..assignedUserId = targetUserId
      ..type = ProfileOperationType.favorite // Favorite operation type
      ..status = 0
      ..comment = 'User added this profile to favorites'
      ..createdAt = timestamp
      ..updatedAt = timestamp
      ..archivedAt = 0
      ..isDeleted = false);

    final Map<String, dynamic> profileOperationData = serializers.serializeWith(
            ProfileOperationEntity.serializer, profileOperation)
        as Map<String, dynamic>;

    // Save to favorites collection
    await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('favorites')
        .doc(targetUserId)
        .set(profileOperationData);

    return profileOperation;
  }

  Future<ProfileOperationEntity> reportProfile({
    required String currentUserId,
    required String targetUserId,
    required String comment,
  }) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    final operationId = _firestore.collection('profileOperations').doc().id;

    final profileOperation = ProfileOperationEntity().rebuild((b) => b
      ..id = operationId
      ..createdUserId = currentUserId
      ..assignedUserId = targetUserId
      ..type = ProfileOperationType.report
      ..status = 0
      ..comment = comment
      ..createdAt = timestamp
      ..updatedAt = timestamp
      ..archivedAt = 0
      ..isDeleted = false);

    final Map<String, dynamic> profileOperationData = serializers.serializeWith(
            ProfileOperationEntity.serializer, profileOperation)
        as Map<String, dynamic>;

    final batch = _firestore.batch();

    batch.set(
        _firestore
            .collection('users')
            .doc(currentUserId)
            .collection('reports')
            .doc(targetUserId),
        profileOperationData);

    batch.update(_firestore.collection('users').doc(targetUserId), {
      'reportedBy.$currentUserId': profileOperationData,
      'reported': true,
    });

    await batch.commit();

    return profileOperation;
  }

  Future<Map<String, ProfileOperationEntity>> getOperationsBetweenUsers({
    required String currentUserId,
    required String targetUserId,
  }) async {
    final Map<String, ProfileOperationEntity> results = {};

    final collections = [
      'likes',
      'matches',
      'blocks',
      'favorites',
      'passes',
      'reports'
    ];

    for (final collection in collections) {
      try {
        final docSnapshot = await _firestore
            .collection('users')
            .doc(currentUserId)
            .collection(collection)
            .doc(targetUserId)
            .get();

        if (docSnapshot.exists && docSnapshot.data() != null) {
          final data = docSnapshot.data()!;

          // Create the entity from the document data
          final entity = ProfileOperationEntity().rebuild((b) => b
            ..id = docSnapshot.id
            ..createdUserId = data['created_user_id'] ?? currentUserId
            ..assignedUserId = data['assigned_user_id'] ?? targetUserId
            ..type = data['type'] ?? 0
            ..status = data['status'] ?? 0
            ..comment = data['comment'] ?? ''
            ..createdAt = data['created_at'] ?? 0
            ..updatedAt = data['updated_at'] ?? 0
            ..archivedAt = data['archived_at'] ?? 0
            ..isDeleted = data['is_deleted'] ?? false);

          results[collection] = entity;
        }
      } catch (e) {
        logError(' Error getting $collection between users: $e');
      }
    }

    return results;
  }

  Future<Map<String, dynamic>> likeEntity({
    required String currentUserId,
    required String targetId,
    required EntityType entityType,
    required int type,
  }) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final entityCollectionName = entityType.toString().split('.').last + 's';

    final entityDoc =
        await _firestore.collection(entityCollectionName).doc(targetId).get();

    if (!entityDoc.exists) {
      throw Exception('Entity not found');
    }

    final entityData = entityDoc.data() as Map<String, dynamic>;
    final currentLikesMap =
        Map<String, dynamic>.from(entityData['likesMap'] ?? {});
    final currentLikeCount = entityData['likeCount'] ?? 0;

    if (currentLikesMap.containsKey(currentUserId)) {
      return {
        'targetId': targetId,
        'likesMap': currentLikesMap,
        'likeCount': currentLikeCount,
        'userId': currentUserId,
      };
    }

    currentLikesMap[currentUserId] = {
      'timestamp': timestamp,
      'type': type,
    };

    final newLikeCount = currentLikeCount + 1;

    // Update entity with new likes data
    await _firestore.collection(entityCollectionName).doc(targetId).update({
      'likesMap': currentLikesMap,
      'likeCount': newLikeCount,
    });

    return {
      'targetId': targetId,
      'likesMap': currentLikesMap,
      'likeCount': newLikeCount,
      'userId': currentUserId,
    };
  }

  Future<Map<String, dynamic>> commentEntity({
    required String currentUserId,
    required String currentUserName,
    required String targetId,
    required EntityType entityType,
    required String comment,
  }) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final entityCollectionName = entityType.toString().split('.').last + 's';
    final commentId =
        _firestore.collection('temp').doc().id; // Generate unique ID

    final entityDoc =
        await _firestore.collection(entityCollectionName).doc(targetId).get();

    if (!entityDoc.exists) {
      throw Exception('Entity not found');
    }

    final entityData = entityDoc.data() as Map<String, dynamic>;
    final currentCommentsMap =
        Map<String, dynamic>.from(entityData['commentsMap'] ?? {});
    final currentCommentCount = entityData['commentCount'] ?? 0;

    currentCommentsMap[commentId] = {
      'userId': currentUserId,
      'userName': currentUserName,
      'comment': comment,
      'timestamp': timestamp,
    };

    final newCommentCount = currentCommentCount + 1;

    await _firestore.collection(entityCollectionName).doc(targetId).update({
      'commentsMap': currentCommentsMap,
      'commentCount': newCommentCount,
    });

    return {
      'targetId': targetId,
      'commentsMap': currentCommentsMap,
      'commentCount': newCommentCount,
      'userId': currentUserId,
      'commentId': commentId,
      'comment': comment,
    };
  }

  Future<Map<String, dynamic>> reportEntity({
    required String currentUserId,
    required String targetId,
    required EntityType entityType,
    required String comment,
  }) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final entityCollectionName = entityType.toString().split('.').last + 's';

    final entityDoc =
        await _firestore.collection(entityCollectionName).doc(targetId).get();

    if (!entityDoc.exists) {
      throw Exception('Entity not found');
    }

    final entityData = entityDoc.data() as Map<String, dynamic>;
    final currentReportsMap =
        Map<String, dynamic>.from(entityData['reportsMap'] ?? {});

    currentReportsMap[currentUserId] = {
      'userId': currentUserId,
      'comment': comment,
      'timestamp': timestamp,
    };

    await _firestore.collection(entityCollectionName).doc(targetId).update({
      'reportsMap': currentReportsMap,
      'reported': true,
    });

    return {
      'targetId': targetId,
      'reportsMap': currentReportsMap,
      'reported': true,
      'userId': currentUserId,
      'comment': comment,
    };
  }
}
