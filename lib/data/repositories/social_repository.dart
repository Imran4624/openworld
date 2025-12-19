import 'dart:core';
import 'dart:typed_data';
import 'package:built_collection/built_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/data/repositories/firebase_repository.dart';
import 'package:flutter_boilerplate/data/models/serializers.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/project_config.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as p;
import 'package:flutter_boilerplate/ui/app/shared.dart';

class SocialRepository {
  const SocialRepository();

  static final FirebaseStorage _storage = FirebaseStorage.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseRepository _firebaseRepository =
      FirebaseRepository('socials');

  Future<SocialEntity> loadItem(
      Credentials credentials, String entityId) async {
    final data = await _firebaseRepository.getItem(entityId);

    if (data != null) {
      return serializers.deserializeWith(SocialEntity.serializer, data)!;
    }
    
    logError('Social with ID $entityId not found');
    return SocialEntity(id: entityId);
  }

  Future<BuiltList<SocialEntity>> loadList(Credentials credentials) async {
    final response = await _firebaseRepository.getList();
    final dataList = response['data'] as List<Map<String, dynamic>>;
    final socials = dataList
        .map((data) =>
            serializers.deserializeWith(SocialEntity.serializer, data)!)
        .toList();

    return BuiltList<SocialEntity>(socials);
  }

  Future<Map<String, dynamic>> loadListWithPagination({
    DocumentSnapshot? lastDocument,
    int limit = 10,
    SocialFilter? filter,
    EventEntity? selectedEvent,
    String? currentUserId,
  }) async {
    // Handle guest users - return empty results
    if (currentUserId == null || currentUserId.isEmpty) {
      return {
        'socials': BuiltList<SocialEntity>(),
        'lastDocument': null,
      };
    }

    Query query = _firestore.collection('socials');

    if (selectedEvent != null && selectedEvent.name.isNotEmpty) {
      query = query.where('category', isEqualTo: selectedEvent.name);
    }
    if (filter != null) {
      final queryParams = filter.toFirebaseQuery();
      final filters = queryParams['filters'] as Map<String, dynamic>;

      if (filter.stateFilter == EntityState.archived) {
        query = query
            .where('is_deleted', isEqualTo: false)
            .where('archived_at', isGreaterThan: 0)
            .orderBy('archived_at', descending: true);
      } else if (filter.stateFilter == EntityState.deleted) {
        query = query
            .where('is_deleted', isEqualTo: true)
            .orderBy('created_at', descending: true);
      } else if (filter.stateFilter == EntityState.myEntities) {
        query = query
            .where('user_id', isEqualTo: currentUserId)
            .orderBy('created_at', descending: true);
      } else if (filter.stateFilter == EntityState.reported) {
        query = query
            .where('reported', isEqualTo: true)
            .orderBy('created_at', descending: true);
      } else {
        query = query
            .where('is_deleted', isEqualTo: false)
            .where('archived_at', isEqualTo: 0)
            .orderBy('created_at', descending: true);
      }

      if (filters['title'] != null) {
        query = query.where('userDisplayName',
            isGreaterThanOrEqualTo: filters['title'],
            isLessThanOrEqualTo: filters['title'] + '\uf8ff');
      }
    }

    if (limit > 0) {
      query = query.limit(limit);
    }

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    final response = await _firebaseRepository.getList(
      customQuery: query,
      lastDocument: lastDocument,
      limit: limit,
    );

    final dataList = response['data'] as List<Map<String, dynamic>>;
    final lastDocumentSnapshot = response['lastDocument'] as DocumentSnapshot?;

    final socials = dataList.map((data) {
      final cleanData = Map<String, dynamic>.from(data);

      final likesMap = cleanData.remove('likesMap') as Map<String, dynamic>?;
      final commentsMap =
          cleanData.remove('commentsMap') as Map<String, dynamic>?;
      final reportsMap =
          cleanData.remove('reportsMap') as Map<String, dynamic>?;
      final reported = cleanData.remove('reported') as bool?;

      var social =
          serializers.deserializeWith(SocialEntity.serializer, cleanData)!;

      social = social.rebuild((b) => b
        ..likesMap = likesMap
        ..commentsMap = commentsMap
        ..reportsMap = reportsMap
        ..reported = reported);

      return social;
    }).toList();

    return {
      'socials': BuiltList<SocialEntity>(socials),
      'lastDocument': lastDocumentSnapshot,
    };
  }

  Future<List<SocialEntity>> bulkAction(
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
      await _deleteImagesForEntities(ids);
      await _firebaseRepository.deleteItems(ids);
    }

    return ids.map((id) => SocialEntity(id: id)).toList();
  }

  Future<void> _deleteImagesForEntities(List<String> socialIds) async {
    try {
      for (final socialId in socialIds) {
        final data = await _firebaseRepository.getItem(socialId);
        if (data != null &&
            data['photos'] != null &&
            data['photos'].isNotEmpty) {
          final socialEntity =
              serializers.deserializeWith(SocialEntity.serializer, data);

          if (socialEntity != null && socialEntity.photos.isNotEmpty) {
            try {
              final List<dynamic> photoData = json.decode(socialEntity.photos);

              for (final item in photoData) {
                if (item is Map && item['type'] == 'url') {
                  final String url = item['data'];
                  if (url.contains('firebasestorage.googleapis.com')) {
                    final uri = Uri.parse(url);
                    final pathSegments = uri.pathSegments;

                    if (pathSegments.length > 1) {
                      final encodedPath = pathSegments.last;
                      final path = Uri.decodeComponent(encodedPath);

                      final storageRef =
                          _storage.ref().child(path);
                      await storageRef.delete();
                    }
                  }
                }
              }
            } catch (e) {
              print('Error deleting images for social $socialId: $e');
            }
          }
        }
      }
    } catch (e) {
      print('Error in _deleteImagesForEntities: $e');
    }
  }

  Future<List<String>> _processAndUploadImages(String photoData) async {
    List<String> uploadedUrls = [];

    try {
      final List<dynamic> parsedData = json.decode(photoData);

      for (final item in parsedData) {
        if (item is Map) {
          if (item['type'] == 'url') {
            uploadedUrls.add(item['data']);
          } else if (item['type'] == 'new') {
            final String base64Data = item['data'];
            final String mimeType = item['mime'];
            final String fileName = item['name'];

            final Uint8List bytes = base64Decode(base64Data);

            final uuid = Uuid();
            final String uniqueFileName =
                '${uuid.v4()}${p.extension(fileName)}';

            final storageRef = _storage
                .ref()
                .child('social_images')
                .child(uniqueFileName);

            final UploadTask uploadTask = storageRef.putData(
              bytes,
              SettableMetadata(contentType: mimeType),
            );

            final TaskSnapshot snapshot = await uploadTask;

            final String downloadUrl = await snapshot.ref.getDownloadURL();

            uploadedUrls.add(downloadUrl);
          }
        }
      }
    } catch (e) {
      logError(' Error processing and uploading images: $e');
    }

    return uploadedUrls;
  }

  Future<SocialEntity> saveData(
      Credentials credentials, SocialEntity social) async {
    List<String> photoUrls = [];
    if (social.photos.isNotEmpty) {
      try {
        photoUrls = await _processAndUploadImages(social.photos);
      } catch (e) {
        logError(' Error processing photos: $e');
      }
    }

    final updatedSocial =
        social.rebuild((b) => b..photos = json.encode(photoUrls));

    final data = serializers.serializeWith(
        SocialEntity.serializer, updatedSocial) as Map<String, dynamic>;

    if (social.isNew || social.createdAt == 0) {
      final int timestamp = DateTime.now().millisecondsSinceEpoch;
      data['created_at'] = timestamp;
      data['archived_at'] =
          ProjectConfig.defaultNewPostStatus() == kEntityStateActive
              ? 0
              : DateTime.now().millisecondsSinceEpoch;
    }

    data['updated_at'] = DateTime.now().millisecondsSinceEpoch;

    if (social.id.isEmpty ||
        !(await _firebaseRepository.itemExists(social.id))) {
      final newId = _firestore.collection('socials').doc().id;
      data['id'] = newId;

      await _firebaseRepository.saveItem(newId, data);
      return updatedSocial.rebuild((b) => b
        ..id = newId
        ..createdAt = data['created_at']
        ..updatedAt = data['updated_at']);
    } else {
      data['archived_at'] = social.archivedAt;
      await _firebaseRepository.saveItem(social.id, data);
      return updatedSocial.rebuild((b) => b..updatedAt = data['updated_at']);
    }
  }
}
