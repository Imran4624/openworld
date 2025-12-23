import 'dart:core';
import 'package:built_collection/built_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/data/repositories/firebase_repository.dart';
import 'package:flutter_boilerplate/data/models/serializers.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/project_config.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'package:flutter/foundation.dart';

class PhotoRepository {
  const PhotoRepository();

  static final FirebaseRepository _firebaseRepository =
      FirebaseRepository('photos');
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<PhotoEntity> loadItem(Credentials credentials, String entityId) async {
    final data = await _firebaseRepository.getItem(entityId);

    if (data != null) {
      return serializers.deserializeWith(PhotoEntity.serializer, data)!;
    }

    logError('Photo with ID $entityId not found');
    return PhotoEntity(id: entityId);
  }

  Future<BuiltList<PhotoEntity>> loadList(Credentials credentials) async {
    final response = await _firebaseRepository.getList();
    final dataList = response['data'] as List<Map<String, dynamic>>;

    final photos = dataList.map((data) {
      final cleanData = Map<String, dynamic>.from(data);
      final reportsMap =
          cleanData.remove('reportsMap') as Map<String, dynamic>?;
      final reported = cleanData.remove('reported') as bool?;

      var photo =
          serializers.deserializeWith(PhotoEntity.serializer, cleanData)!;

      photo = photo.rebuild((b) => b
        ..reportsMap = reportsMap
        ..reported = reported);

      return photo;
    }).toList();

    return BuiltList<PhotoEntity>(photos);
  }

  Future<Map<String, dynamic>> loadListWithPagination({
    DocumentSnapshot? lastDocument,
    String? continuationToken, // For Azure pagination
    int limit = 20,
    PhotoFilter? filter,
    EventEntity? selectedEvent,
    String? selectedEventId,
    String? currentUserId,
  }) async {
    // Firebase implementation only - photo entities are stored in Firebase
    Query query = _firestore.collection('photos');
    if (selectedEvent != null && selectedEvent.name.isNotEmpty) {
      query = query.where('category', isEqualTo: selectedEvent.name);
    }
    if (selectedEventId != null &&
        selectedEventId.isNotEmpty &&
        selectedEvent != null &&
        !selectedEvent.isNew) {
      query = query.where('assigned_user_id', isEqualTo: selectedEventId);
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
        query = query.where('title',
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

    if (filter?.stateFilter == EntityState.activeAndMineEntities &&
        currentUserId != null) {
      return await _handleActiveAndMineEntitiesQuery(
        selectedEvent: selectedEvent,
        selectedEventId: selectedEventId,
        filter: filter,
        currentUserId: currentUserId,
        lastDocument: lastDocument,
        limit: limit,
      );
    }

    final response = await _firebaseRepository.getList(
      customQuery: query,
      lastDocument: lastDocument,
      limit: limit,
    );

    final dataList = response['data'] as List<Map<String, dynamic>>;
    final lastDocumentSnapshot = response['lastDocument'] as DocumentSnapshot?;

    final photos = dataList.map((data) {
      final cleanData = Map<String, dynamic>.from(data);
      final reportsMap =
          cleanData.remove('reportsMap') as Map<String, dynamic>?;
      final reported = cleanData.remove('reported') as bool?;

      var photo =
          serializers.deserializeWith(PhotoEntity.serializer, cleanData)!;
      photo = photo.rebuild((b) => b
        ..reportsMap = reportsMap
        ..reported = reported);

      return photo;
    }).toList();

    return {
      'photos': BuiltList<PhotoEntity>(photos),
      'lastDocument': lastDocumentSnapshot,
    };
  }

  Future<bool> photoExists(String photoId) async {
    return await _firebaseRepository.itemExists(photoId);
  }

  Future<List<PhotoEntity>> bulkAction(
      Credentials credentials, List<String> ids, EntityAction action) async {
    final int currentTime = DateTime.now().millisecondsSinceEpoch;

    switch (action) {
      case EntityAction.delete:
        final List<Future<void>> deleteFutures = ids.map((id) async {
          final data = {'is_deleted': true};
          await _firebaseRepository.updateItem(id, data);
        }).toList();
        await Future.wait(deleteFutures);
        break;
      case EntityAction.archive:
        final List<Future<void>> archiveFutures = ids.map((id) async {
          final data = {'archived_at': currentTime};
          await _firebaseRepository.updateItem(id, data);
        }).toList();
        await Future.wait(archiveFutures);
        break;
      case EntityAction.restore:
        final List<Future<void>> restoreFutures = ids.map((id) async {
          final data = {'archived_at': 0, 'is_deleted': false};
          await _firebaseRepository.updateItem(id, data);
        }).toList();
        await Future.wait(restoreFutures);
        break;
      case EntityAction.purge:
        await _firebaseRepository.deleteItems(ids);
        break;
      default:
        logError(' Unsupported bulk action for photos: $action');
        return ids.map((id) => PhotoEntity(id: id)).toList();
    }

    return ids.map((id) => PhotoEntity(id: id)).toList();
  }

  Future<void> deletePhoto(String photoId) async {
    await _firebaseRepository.deleteItems([photoId]);
  }

  Future<void> updatePhotoMetadata(
      String photoId, Map<String, dynamic> metadata) async {
    metadata['updated_at'] = DateTime.now().millisecondsSinceEpoch;
    await _firebaseRepository.updateItem(photoId, metadata);
  }

  // Upload a single image to storage (Firebase or Azure based on config)
  Future<String> _uploadImageToStorage(
      Uint8List imageData, String imageName) async {
      try {
        final String timestamp =
            DateTime.now().millisecondsSinceEpoch.toString();
        final String safeName =
            imageName.replaceAll(RegExp(r'[^\w\s\-\.]'), '_');
        final String path = 'photos/images/${timestamp}_$safeName';

        final ref = _storage.ref().child(path);

        final UploadTask uploadTask = ref.putData(
          imageData,
          SettableMetadata(
            customMetadata: {
              'uploadedAt': DateTime.now().toIso8601String(),
              'originalName': safeName,
            },
          ),
        );

        final TaskSnapshot snapshot = await uploadTask;
        final String downloadUrl = await snapshot.ref.getDownloadURL();
        logInfo('Image uploaded to Firebase successfully');
        return downloadUrl;
      } catch (e) {
        logError(' Error uploading image to Firebase: $e');
        return '';
      }
  }

  Future<List<String>> _uploadMultipleImagesToStorage(
      List<Map<String, dynamic>> imagesData) async {
    imagesData.removeWhere((image) => image['action'] == 'existing');
    if (imagesData.isEmpty) {
      return [];
    }
      try {
        final List<Future<String>> uploadFutures = imagesData.map((imageData) {
          final bytes = imageData['bytes'] as Uint8List;
          final name = imageData['name'] as String? ?? 'photo.jpg';
          return _uploadImageToStorage(bytes, name);
        }).toList();

        final List<String> imageUrls = await Future.wait(uploadFutures);
        return imageUrls;
      } catch (e) {
        logError(' Error uploading multiple images: $e');
        return [];
      }
  }

  Future<PhotoEntity> saveData(Credentials credentials, PhotoEntity photo,
      Map<String, dynamic>? imageData,
      {String? currentUserEmail, EventEntity? selectedEvent}) async {
    try {
      String imageUrl = photo.url;

      if (imageData != null && imageData.containsKey('bytes')) {
        final bytes = imageData['bytes'] as Uint8List;
        final name = imageData['name'] as String? ?? 'photo.jpg';

        if (bytes.isNotEmpty) {
          imageUrl = await _uploadImageToStorage(bytes, name);
        }
      }

      final updatedPhoto = photo.rebuild((b) => b..url = imageUrl);

      final data = serializers.serializeWith(
          PhotoEntity.serializer, updatedPhoto) as Map<String, dynamic>;
      logInfo('updated photo data to update');

      if (photo.isNew) {
        final newId = _firestore.collection('photos').doc().id;

        data['id'] = newId;
        data['created_at'] = DateTime.now().millisecondsSinceEpoch;
        data['updated_at'] = DateTime.now().millisecondsSinceEpoch;

        bool shouldArchivePhoto =
            ProjectConfig.defaultNewPhotoStatus() != kEntityStateActive;

        if (!shouldArchivePhoto &&
            photo.assignedUserId?.isNotEmpty == true &&
            photo.createdUserId?.isNotEmpty == true &&
            currentUserEmail != null &&
            selectedEvent != null) {
            final isPrivateEvent = selectedEvent.privateEvent == true;
            final eventAuthorId = selectedEvent.createdUserId;
            final isAuthor = eventAuthorId == photo.createdUserId;

            if (isPrivateEvent && !isAuthor) {
              final orders = selectedEvent.orders.toList();

              for (final order in orders) {
                final buyerEmail = order.buyerDetails.email;
                final attendeeStatus = order.buyerDetails.attendeeStatus;

                if (buyerEmail.toLowerCase() ==
                        currentUserEmail.toLowerCase() &&
                    attendeeStatus == 'pending') {
                  shouldArchivePhoto = true;
                  break;
                }
              }
            }
          
        }

        data['archived_at'] =
            shouldArchivePhoto ? DateTime.now().millisecondsSinceEpoch : 0;
        logInfo('saved photo data');

        await _firebaseRepository.saveItem(newId, data);
        return updatedPhoto.rebuild((b) => b
          ..id = newId
          ..archivedAt =
              shouldArchivePhoto ? DateTime.now().millisecondsSinceEpoch : 0);
      } else {
        data['updated_at'] = DateTime.now().millisecondsSinceEpoch;
        data['archived_at'] = photo.archivedAt;

        await _firebaseRepository.saveItem(photo.id, data);
        return updatedPhoto;
      }
    } catch (e) {
      logError(' Error saving photo: $e');
      return photo;
    }
  }

  Future<List<PhotoEntity>> uploadMultiplePhotos(
      Credentials credentials,
      String category,
      String eventId,
      String tags,
      String currentUserId,
      List<Map<String, dynamic>> imagesData,
      {List<Map<String, dynamic>> existingPhotos = const [],
      bool isGuestOriginator = false,
      String? currentUserEmail,
      EventEntity? selectedEvent}) async {
    try {
      final List<String> imageUrls =
          await _uploadMultipleImagesToStorage(imagesData);
      final List<PhotoEntity> photoEntities = [];
      final int currentTime = DateTime.now().millisecondsSinceEpoch;

      bool shouldArchivePhoto = false;

      if (isGuestOriginator) {
        shouldArchivePhoto = true;
      } else {
        shouldArchivePhoto =
            ProjectConfig.defaultNewPhotoStatus() != kEntityStateActive;

        if (!shouldArchivePhoto &&
            eventId.isNotEmpty &&
            currentUserId.isNotEmpty &&
            currentUserEmail != null &&
            selectedEvent != null) {
            final isPrivateEvent = selectedEvent.privateEvent == true;
            final eventAuthorId = selectedEvent.createdUserId;
            final isAuthor = eventAuthorId == currentUserId;

            if (isPrivateEvent && !isAuthor) {
              final orders = selectedEvent.orders.toList();

              for (final order in orders) {
                final buyerEmail = order.buyerDetails.email;
                final attendeeStatus = order.buyerDetails.attendeeStatus;

                if (buyerEmail.toLowerCase() ==
                        currentUserEmail.toLowerCase() &&
                    attendeeStatus == 'pending') {
                  shouldArchivePhoto = true;
                  break;
                }
              }
            }
          
        }
      }

      if (imageUrls.isNotEmpty) {
        for (int i = 0; i < imageUrls.length; i++) {
          final photo = PhotoEntity().rebuild((b) => b
            ..category = category
            ..tags = tags
            ..createdUserId = currentUserId
            ..assignedUserId = eventId
            ..url = imageUrls[i]);

          final newId = _firestore.collection('photos').doc().id;

          final data = serializers.serializeWith(PhotoEntity.serializer, photo)
              as Map<String, dynamic>;

          data['id'] = newId;
          data['created_at'] = currentTime;
          data['updated_at'] = currentTime;
          data['archived_at'] = shouldArchivePhoto ? currentTime : 0;

          photoEntities.add(photo.rebuild((b) => b
            ..id = newId
            ..archivedAt = shouldArchivePhoto ? currentTime : 0));
        }
      }

      if (eventId.contains('_isPreview') && existingPhotos.isNotEmpty) {
        for (final photo in existingPhotos) {
          if (photo['url'] != null &&
              (photo['action'] == null || photo['action'] == 'existing')) {
            final existingPhoto = PhotoEntity().rebuild((b) => b
              ..category = category
              ..tags = tags
              ..createdUserId = currentUserId
              ..assignedUserId = eventId
              ..url = photo['url'] as String);

            final newId = _firestore.collection('photos').doc().id;
            final data = serializers.serializeWith(
                PhotoEntity.serializer, existingPhoto) as Map<String, dynamic>;
            data['id'] = newId;
            data['created_at'] = currentTime;
            data['updated_at'] = currentTime;
            // Archive photos automatically if conditions apply
            data['archived_at'] = shouldArchivePhoto ? currentTime : 0;
            photoEntities.add(existingPhoto.rebuild((b) => b
              ..id = newId
              ..archivedAt = shouldArchivePhoto ? currentTime : 0));
          }
        }
      }

      final batch = _firestore.batch();

      for (int i = 0; i < photoEntities.length; i++) {
        final data = serializers.serializeWith(
            PhotoEntity.serializer, photoEntities[i]) as Map<String, dynamic>;
        data['id'] = photoEntities[i].id;
        data['created_at'] = currentTime;
        data['updated_at'] = currentTime;
        // Archive photos automatically if conditions apply
        data['archived_at'] = shouldArchivePhoto ? currentTime : 0;
        final docRef = _firestore.collection('photos').doc(photoEntities[i].id);
        batch.set(docRef, data);
      }

      await batch.commit();

      return photoEntities;
    } catch (e) {
      logError(' Error during bulk upload: $e');
      return [];
    }
  }

  Future<void> updateMultiplePhotos(
      List<String> photoIds, Map<String, dynamic> updateData) async {
    final List<Future<void>> updateFutures = photoIds.map((photoId) async {
      final data = Map<String, dynamic>.from(updateData);
      data['updated_at'] = DateTime.now().millisecondsSinceEpoch;
      await _firebaseRepository.updateItem(photoId, data);
    }).toList();

    await Future.wait(updateFutures);
    logInfo('Updated ${photoIds.length} photos using concurrent operations');
  }

  Future<void> archiveMultiplePhotos(List<String> photoIds) async {
    final archiveData = {
      'archived_at': DateTime.now().millisecondsSinceEpoch,
      'updated_at': DateTime.now().millisecondsSinceEpoch,
    };
    await updateMultiplePhotos(photoIds, archiveData);
  }

  Future<void> restoreMultiplePhotos(List<String> photoIds) async {
    final restoreData = {
      'archived_at': 0,
      'is_deleted': false,
      'updated_at': DateTime.now().millisecondsSinceEpoch,
    };
    await updateMultiplePhotos(photoIds, restoreData);
  }

  Future<Map<String, dynamic>> _handleActiveAndMineEntitiesQuery({
    EventEntity? selectedEvent,
    String? selectedEventId,
    PhotoFilter? filter,
    required String currentUserId,
    DocumentSnapshot? lastDocument,
    int limit = 20,
  }) async {
    Query activeQuery = _firestore.collection('photos');
    if (selectedEvent != null && selectedEvent.name.isNotEmpty) {
      activeQuery =
          activeQuery.where('category', isEqualTo: selectedEvent.name);
    }
    if (selectedEventId != null &&
        selectedEventId.isNotEmpty &&
        selectedEvent != null &&
        !selectedEvent.isNew) {
      activeQuery =
          activeQuery.where('assigned_user_id', isEqualTo: selectedEventId);
    }
    activeQuery = activeQuery
        .where('is_deleted', isEqualTo: false)
        .where('archived_at', isEqualTo: 0)
        .orderBy('created_at', descending: true);

    Query myQuery = _firestore.collection('photos');
    if (selectedEvent != null && selectedEvent.name.isNotEmpty) {
      myQuery = myQuery.where('category', isEqualTo: selectedEvent.name);
    }
    if (selectedEventId != null &&
        selectedEventId.isNotEmpty &&
        selectedEvent != null &&
        !selectedEvent.isNew) {
      myQuery = myQuery.where('assigned_user_id', isEqualTo: selectedEventId);
    }
    myQuery = myQuery
        .where('is_deleted', isEqualTo: false)
        .where('user_id', isEqualTo: currentUserId)
        .orderBy('created_at', descending: true);

    if (limit > 0) {
      activeQuery = activeQuery.limit(limit);
      myQuery = myQuery.limit(limit);
    }

    if (lastDocument != null) {
      activeQuery = activeQuery.startAfterDocument(lastDocument);
      myQuery = myQuery.startAfterDocument(lastDocument);
    }

    final activeResponse = await _firebaseRepository.getList(
      customQuery: activeQuery,
      lastDocument: lastDocument,
      limit: limit,
    );

    final myResponse = await _firebaseRepository.getList(
      customQuery: myQuery,
      lastDocument: lastDocument,
      limit: limit,
    );

    final activeDataList = activeResponse['data'] as List<Map<String, dynamic>>;
    final myDataList = myResponse['data'] as List<Map<String, dynamic>>;

    final Map<String, Map<String, dynamic>> photoMap = {};

    for (final data in activeDataList) {
      photoMap[data['id']] = data;
    }

    for (final data in myDataList) {
      photoMap[data['id']] = data;
    }

    final mergedDataList = photoMap.values.toList();
    mergedDataList.sort((a, b) {
      final aTime = a['created_at'] as int? ?? 0;
      final bTime = b['created_at'] as int? ?? 0;
      return bTime.compareTo(aTime);
    });

    final limitedDataList = limit > 0 && mergedDataList.length > limit
        ? mergedDataList.take(limit).toList()
        : mergedDataList;

    final photos = limitedDataList.map((data) {
      final cleanData = Map<String, dynamic>.from(data);
      final reportsMap =
          cleanData.remove('reportsMap') as Map<String, dynamic>?;
      final reported = cleanData.remove('reported') as bool?;

      var photo =
          serializers.deserializeWith(PhotoEntity.serializer, cleanData)!;
      photo = photo.rebuild((b) => b
        ..reportsMap = reportsMap
        ..reported = reported);

      return photo;
    }).toList();

    final lastActiveDoc = activeResponse['lastDocument'] as DocumentSnapshot?;
    final lastMyDoc = myResponse['lastDocument'] as DocumentSnapshot?;

    return {
      'photos': BuiltList<PhotoEntity>(photos),
      'lastDocument': lastActiveDoc ?? lastMyDoc,
    };
  }
}
