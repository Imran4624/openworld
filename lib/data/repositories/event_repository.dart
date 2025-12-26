import 'dart:core';
import 'dart:typed_data';
import 'package:built_collection/built_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_boilerplate/data/repositories/firebase_repository.dart';
import 'package:flutter_boilerplate/data/models/serializers.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/data/models/event_model_helper.dart';
import 'package:flutter_boilerplate/project_config.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';

class EventRepository {
  const EventRepository();

  static final FirebaseStorage _storage = FirebaseStorage.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseRepository _firebaseRepository =
      FirebaseRepository('events');

  Future<EventEntity> loadItem(Credentials credentials, String entityId) async {
    final data = await _firebaseRepository.getItem(entityId);

    if (data != null) {
      if (data.containsKey('createdByObj') && data['createdByObj'] is Map) {
        final createdByObj = Map<String, dynamic>.from(data['createdByObj'] as Map);
        
        if (createdByObj.containsKey('thumbnail')) {
          final thumbnail = createdByObj['thumbnail'];
          if (thumbnail is String) {
            createdByObj['thumbnail'] = {
              'url': thumbnail,
              'name': '',
              'action': 'existing'
            };
          } else if (thumbnail is Map<String, dynamic>) {
            createdByObj['thumbnail'] = thumbnail;
          } else if (thumbnail is Map) {
            createdByObj['thumbnail'] = Map<String, dynamic>.from(thumbnail);
          }
        }
        
        data['createdByObj'] = createdByObj;
      }

      if (data.containsKey('views')) {
        if (data['views'] is Map && (data['views'] as Map).isEmpty) {
          data['views'] = <Map<String, dynamic>>[];
        } else if (data['views'] is List) {
          List<dynamic> viewsList = data['views'] as List<dynamic>;
          data['views'] = viewsList
              .where((item) => item is Map)
              .map((item) => Map<String, dynamic>.from(item as Map))
              .toList();
        } else {
          data['views'] = <Map<String, dynamic>>[];
        }
      }

      if (data.containsKey('favourites')) {
        if (data['favourites'] is Map && (data['favourites'] as Map).isEmpty) {
          data['favourites'] = <Map<String, dynamic>>[];
        } else if (data['favourites'] is List) {
          List<dynamic> favouritesList = data['favourites'] as List<dynamic>;
          data['favourites'] = favouritesList
              .where((item) => item is Map)
              .map((item) => Map<String, dynamic>.from(item as Map))
              .toList();
        } else {
          data['favourites'] = <Map<String, dynamic>>[];
        }
      }

      final event = serializers.deserializeWith(EventEntity.serializer, data)!;

      List<Map<String, dynamic>>? views;
      List<Map<String, dynamic>>? favourites;
      List<Map<String, dynamic>>? joinRequests;

      if (data['views'] is List) {
        views = (data['views'] as List).cast<Map<String, dynamic>>();
      }
      if (data['favourites'] is List) {
        favourites = (data['favourites'] as List).cast<Map<String, dynamic>>();
      }
      if (data['joinRequests'] is List) {
        joinRequests =
            (data['joinRequests'] as List).cast<Map<String, dynamic>>();
      }

      Map<String, dynamic>? locationData =
          data['locationData'] as Map<String, dynamic>?;
      Map<String, dynamic>? dynamicFieldsData;

      if (data['dynamicFields'] != null) {
        dynamicFieldsData =
            Map<String, dynamic>.from(data['dynamicFields'] as Map);
        locationData ??=
            dynamicFieldsData['locationData'] as Map<String, dynamic>?;
      }

      if (views != null ||
          favourites != null ||
          joinRequests != null ||
          locationData != null ||
          dynamicFieldsData != null) {
        return event.rebuild((b) {
          if (views != null) {
            b.views = _mapListToEventInteractions(views);
          }
          if (favourites != null) {
            b.favourites = _mapListToEventInteractions(favourites);
          }
          if (joinRequests != null) {
            b.joinRequests = _mapListToJoinRequests(joinRequests);
          }
          if (locationData != null) {
            final convertedLocationData = _mapToEventLocationData(locationData);
            if (convertedLocationData != null) {
              b.locationData.replace(convertedLocationData);
            }
          }
          if (dynamicFieldsData != null) {
            b.dynamicFields = MapBuilder<String, dynamic>(dynamicFieldsData);
          }
        });
      }

      return event;
    }

    logError('Event with ID $entityId not found');
    return EventEntity(id: entityId);
  }

  static List<EventInteraction> _mapListToEventInteractions(
      List<Map<String, dynamic>>? mapList) {
    if (mapList == null) return [];
    return mapList.map((map) {
      final adjustedMap = Map<String, dynamic>.from(map);
      if (adjustedMap['type'] is int) {
        adjustedMap['type'] = adjustedMap['type'].toString();
      }

      final interaction =
          serializers.deserializeWith(EventInteraction.serializer, adjustedMap);
      return interaction ??
          EventInteraction((b) => b
            ..time = map['time'] as int? ?? 0
            ..userId = map['userId'] as String? ?? ''
            ..type = map['type']?.toString() ?? '');
    }).toList();
  }

  static List<JoinRequest> _mapListToJoinRequests(
      List<Map<String, dynamic>>? mapList) {
    if (mapList == null) return [];
    return mapList.map((map) {
      final request = serializers.deserializeWith(JoinRequest.serializer, map);
      return request ??
          JoinRequest((b) => b
            ..userId = map['userId'] as String? ?? ''
            ..requestedAt = map['requestedAt'] as int? ?? 0
            ..status = map['status'] as String? ?? 'pending'
            ..message = map['message'] as String?
            ..approvedAt = map['approvedAt'] as int?
            ..approvedBy = map['approvedBy'] as String?);
    }).toList();
  }

  static EventLocationData? _mapToEventLocationData(Map<String, dynamic>? map) {
    if (map == null) return null;

    final adjustedMap = Map<String, dynamic>.from(map);

    if (adjustedMap['lng'] == null && adjustedMap['long'] != null) {
      adjustedMap['lng'] = adjustedMap['long'];
    }

    if (adjustedMap['lat'] != null && adjustedMap['lat'] is int) {
      adjustedMap['lat'] = (adjustedMap['lat'] as int).toDouble();
    }
    if (adjustedMap['lng'] != null && adjustedMap['lng'] is int) {
      adjustedMap['lng'] = (adjustedMap['lng'] as int).toDouble();
    }

    if (adjustedMap['lat'] == null) {
      adjustedMap['lat'] = 0.0;
    }
    if (adjustedMap['lng'] == null) {
      adjustedMap['lng'] = 0.0;
    }

    final locationData =
        serializers.deserializeWith(EventLocationData.serializer, adjustedMap);
    return locationData ??
        EventLocationData((b) => b
          ..lat = (map['lat'] as num?)?.toDouble() ?? 0.0
          ..lng = (map['lng'] as num?)?.toDouble() ??
              (map['long'] as num?)?.toDouble() ??
              0.0
          ..name = map['name']?.toString()
          ..placeId = map['placeId'] as String?
          ..address = map['address'] as String?
          ..city = map['city'] as String?
          ..country = map['country'] as String?);
  }

  static List<Map<String, dynamic>> _eventInteractionsToMapList(
      List<EventInteraction>? interactions) {
    if (interactions == null) return [];
    return interactions.map((interaction) {
      final map = serializers.serializeWith(
          EventInteraction.serializer, interaction) as Map<String, dynamic>?;
      return map ??
          {
            'time': interaction.time,
            'userId': interaction.userId,
            'type': interaction.type,
          };
    }).toList();
  }

  static List<Map<String, dynamic>> _joinRequestsToMapList(
      List<JoinRequest>? requests) {
    if (requests == null) return [];
    return requests.map((request) {
      final map = serializers.serializeWith(JoinRequest.serializer, request)
          as Map<String, dynamic>?;
      return map ??
          {
            'userId': request.userId,
            'requestedAt': request.requestedAt,
            'status': request.status,
            if (request.message != null) 'message': request.message,
            if (request.approvedAt != null) 'approvedAt': request.approvedAt,
            if (request.approvedBy != null) 'approvedBy': request.approvedBy,
          };
    }).toList();
  }

  static Map<String, dynamic>? _eventLocationDataToMap(
      EventLocationData? locationData) {
    if (locationData == null) return null;
    final map = serializers.serializeWith(
        EventLocationData.serializer, locationData) as Map<String, dynamic>?;
    return map ??
        {
          'lat': locationData.lat,
          'lng': locationData.lng,
          if (locationData.name != null) 'name': locationData.name,
          if (locationData.placeId != null) 'placeId': locationData.placeId,
          if (locationData.address != null) 'address': locationData.address,
          if (locationData.city != null) 'city': locationData.city,
          if (locationData.country != null) 'country': locationData.country,
        };
  }

  Future<Map<String, dynamic>> loadListWithPagination({
    DocumentSnapshot? lastDocument,
    int limit = 10,
    EventFilter? filter,
    bool myEventsOnly = false,
    String? currentUserId,
  }) async {
    final int currentTimestamp =
        (DateTime.now().millisecondsSinceEpoch / 1000).floor();
    Query query = _firestore.collection('events');

    if (ProjectConfig.getEventEditFields().contains('start') && !myEventsOnly) {
      query = query.where('start', isLessThan: currentTimestamp);
    }

    if (ProjectConfig.getEventEditFields().contains('end') && !myEventsOnly) {
      query = query.where('end', isGreaterThan: currentTimestamp);
    }

    if (filter != null) {
      final queryParams = filter.toFirebaseQuery();
      final filters = queryParams['filters'] as Map<String, dynamic>;

      if (filters['title'] != null) {
        query = query.where('title',
            isGreaterThanOrEqualTo: filters['title'],
            isLessThanOrEqualTo: filters['title'] + '\uf8ff');
      }
    }

    if (ProjectConfig.getEventEditFields().contains('end')) {
      query = query.orderBy('end', descending: false);
    }
    if (limit > 0) {
      if (myEventsOnly) {
        limit = limit * 100;
      }
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
    logInfo('Fetched ${dataList.length} events');

    List<EventEntity> events = [];

    for (final data in dataList) {
      try {
        if (data.containsKey('createdByObj') && data['createdByObj'] is Map) {
          final createdByObj = Map<String, dynamic>.from(data['createdByObj'] as Map);
          if (createdByObj.containsKey('thumbnail')) {
            final thumbnail = createdByObj['thumbnail'];
            if (thumbnail is String) {
              createdByObj['thumbnail'] = {
                'url': thumbnail,
                'name': '',
                'action': 'existing'
              };
            } else if (thumbnail is Map<String, dynamic>) {
              createdByObj['thumbnail'] = thumbnail;
            } else if (thumbnail is Map) {
              createdByObj['thumbnail'] = Map<String, dynamic>.from(thumbnail);
            }
          }
          
          data['createdByObj'] = createdByObj;
        }

        if (!data.containsKey('orders') || data['orders'] == null) {
          data['orders'] = [];
        }

        if (data['orders'] is List) {
          List<dynamic> orders = List.from(data['orders']);
          List<dynamic> validOrders = [];

          for (final order in orders) {
            if (order is Map &&
                order.containsKey('buyerDetails') &&
                order['buyerDetails'] != null) {
              var buyerDetails = order['buyerDetails'];

              if (buyerDetails is Map &&
                  buyerDetails.containsKey('name') &&
                  buyerDetails['name'] != null &&
                  buyerDetails.containsKey('email') &&
                  buyerDetails['email'] != null) {
                validOrders.add(order);
              }
            }
          }

          data['orders'] = validOrders;
        }

        if (data.containsKey('views')) {
          if (data['views'] is Map && (data['views'] as Map).isEmpty) {
            data['views'] = <Map<String, dynamic>>[];
          } else if (data['views'] is List) {
            List<dynamic> viewsList = data['views'] as List<dynamic>;
            data['views'] = viewsList
                .where((item) => item is Map)
                .map((item) => Map<String, dynamic>.from(item as Map))
                .toList();
          } else {
            data['views'] = <Map<String, dynamic>>[];
          }
        }

        if (data.containsKey('favourites')) {
          if (data['favourites'] is Map &&
              (data['favourites'] as Map).isEmpty) {
            data['favourites'] = <Map<String, dynamic>>[];
          } else if (data['favourites'] is List) {
            List<dynamic> favouritesList = data['favourites'] as List<dynamic>;
            data['favourites'] = favouritesList
                .where((item) => item is Map)
                .map((item) => Map<String, dynamic>.from(item as Map))
                .toList();
          } else {
            data['favourites'] = <Map<String, dynamic>>[];
          }
        }

        if (data.containsKey('joinRequests')) {
          if (data['joinRequests'] is Map &&
              (data['joinRequests'] as Map).isEmpty) {
            data['joinRequests'] = <Map<String, dynamic>>[];
          } else if (data['joinRequests'] is List) {
            List<dynamic> joinRequestsList =
                data['joinRequests'] as List<dynamic>;
            data['joinRequests'] = joinRequestsList
                .where((item) => item is Map)
                .map((item) => Map<String, dynamic>.from(item as Map))
                .toList();
          } else {
            data['joinRequests'] = <Map<String, dynamic>>[];
          }
        }
        final event = serializers.deserializeWith(EventEntity.serializer, data);
        if (event != null) {
          List<Map<String, dynamic>>? views;
          List<Map<String, dynamic>>? favourites;
          List<Map<String, dynamic>>? joinRequests;

          if (data['views'] is List) {
            views = (data['views'] as List).cast<Map<String, dynamic>>();
          }
          if (data['favourites'] is List) {
            favourites =
                (data['favourites'] as List).cast<Map<String, dynamic>>();
          }
          if (data['joinRequests'] is List) {
            joinRequests =
                (data['joinRequests'] as List).cast<Map<String, dynamic>>();
          }

          Map<String, dynamic>? locationData =
              data['locationData'] as Map<String, dynamic>?;
          Map<String, dynamic>? dynamicFieldsData;

          if (data['dynamicFields'] != null) {
            dynamicFieldsData =
                Map<String, dynamic>.from(data['dynamicFields'] as Map);
            locationData ??=
                dynamicFieldsData['locationData'] as Map<String, dynamic>?;
          }

          EventEntity updatedEvent = event;

          if (data['createdByObj'] != null ||
              views != null ||
              favourites != null ||
              joinRequests != null ||
              locationData != null ||
              dynamicFieldsData != null) {
            updatedEvent = event.rebuild((b) {
              if (data['createdByObj'] != null) {
                b.createdByObj = data['createdByObj'];
              }
              if (views != null) {
                b.views = _mapListToEventInteractions(views);
              }
              if (favourites != null) {
                b.favourites = _mapListToEventInteractions(favourites);
              }
              if (joinRequests != null) {
                b.joinRequests = _mapListToJoinRequests(joinRequests);
              }
              if (locationData != null) {
                final data = _mapToEventLocationData(locationData);
                if (data != null) {
                  b.locationData.replace(data);
                }
              }
              if (dynamicFieldsData != null) {
                b.dynamicFields =
                    MapBuilder<String, dynamic>(dynamicFieldsData);
              }
            });
          }

          events.add(updatedEvent);
        }
      } catch (e) {
        logError('Error deserializing event: data $data and error $e');
      }
    }

    return {
      'events': BuiltList<EventEntity>(events),
      'lastDocument': lastDocumentSnapshot,
    };
  }

  Future<List<EventEntity>> bulkAction(
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

    return ids.map((id) => EventEntity(id: id)).toList();
  }

  Future<EventEntity> saveData(Credentials credentials, EventEntity event,
      String userId, bool isPreview, Map<String, dynamic>? createdByObj) async {
    try {
      String headerUrl = event.images?.header ?? '';

      if (event.dynamicFields.containsKey('headerImages')) {
        final headerImages =
            event.dynamicFields['headerImages'] as List<dynamic>;

        for (int i = 0; i < headerImages.length; i++) {
          final image = headerImages[i];

          if (image is Map<String, dynamic> &&
              image.containsKey('bytes') &&
              image['action'] == 'added') {
            logInfo('Uploading new event image');

            final imageBytes = image['bytes'] as List<int>;
            final fileName = image['name'] as String;

            if (imageBytes.isNotEmpty) {
              headerUrl = await _uploadImageToStorage(
                  Uint8List.fromList(imageBytes), fileName);
              logInfo(' Event image uploaded successfully');
            }
          } else if (image is Map<String, dynamic> &&
              image.containsKey('url') &&
              image['action'] == 'existing') {
            logInfo('Using existing event image');
            if (headerUrl.isEmpty) {
              headerUrl = image['url'] as String;
            }
          }
        }
      }

      final updatedEvent = event.rebuild((b) => b
        ..images = Images((i) => i
          ..header = headerUrl
          ..thumbnail = '').toBuilder()
        ..dynamicFields = null
        ..createdByObj = createdByObj);

      final data = serializers.serializeWith(
          EventEntity.serializer, updatedEvent) as Map<String, dynamic>;

      if (event.joinRequests != null) {
        data['joinRequests'] = _joinRequestsToMapList(event.joinRequests);
      }

      if (event.locationData != null) {
        data['locationData'] = _eventLocationDataToMap(event.locationData);
      }

      if (event.views != null) {
        data['views'] = _eventInteractionsToMapList(event.views);
      }

      if (event.favourites != null) {
        data['favourites'] = _eventInteractionsToMapList(event.favourites);
      }

      if (event.dynamicFields.isNotEmpty) {
        logInfo('event has dynamic fields');
        final dynamicFields = <String, dynamic>{};
        for (var entry in event.dynamicFields.entries) {
          if (entry.key != 'headerImages') {
            dynamicFields[entry.key] = entry.value;
          }
        }
        logInfo('remaining dynamic fields: $dynamicFields');
        data['dynamicFields'] = dynamicFields;
      }

      final uuid = Uuid();
      if (event.isNew) {
        final guestEventId = event.id.contains('_isPreview')
            ? event.id
            : 'orphan_${uuid.v4()}_isPreview';
        final newId =
            isPreview ? guestEventId : _firestore.collection('events').doc().id;
        data['id'] = newId;
        data['created_at'] = DateTime.now().millisecondsSinceEpoch;
        data['updated_at'] = DateTime.now().millisecondsSinceEpoch;
        data['user_id'] = isPreview ? 'orphan' : userId;
        data['createdByObj'] = createdByObj;
        await _firebaseRepository.saveItem(newId, data);
        return updatedEvent.rebuild((b) => b
          ..id = newId
          ..dynamicFields = data['dynamicFields'] != null
              ? MapBuilder<String, dynamic>(
                  Map<String, dynamic>.from(data['dynamicFields']))
              : null
          ..createdUserId = isPreview ? 'orphan' : userId
          ..createdByObj = createdByObj);
      } else {
        if (isPreview) {
          final previewId = event.id.contains('_isPreview')
              ? event.id
              : '${event.id}_isPreview';
          data['id'] = previewId;
          data['created_at'] = DateTime.now().millisecondsSinceEpoch;
          data['updated_at'] = DateTime.now().millisecondsSinceEpoch;
          data['user_id'] = 'orphan';
          await _firebaseRepository.saveItem(previewId, data);
          return updatedEvent.rebuild((b) => b
            ..id = previewId
            ..createdUserId = 'orphan'
            ..createdByObj = createdByObj);
        } else {
          data['updated_at'] = DateTime.now().millisecondsSinceEpoch;
          if (event.createdUserId != null && event.createdUserId!.isNotEmpty) {
            data['user_id'] = event.createdUserId;
          }
          data['createdByObj'] = createdByObj;
          await _firebaseRepository.saveItem(event.id, data);
          
          MapBuilder<String, dynamic>? preservedDynamicFields;
          if (data['dynamicFields'] != null) {
            final dynamicFieldsMap = Map<String, dynamic>.from(data['dynamicFields'] as Map);
            preservedDynamicFields = MapBuilder<String, dynamic>(dynamicFieldsMap);
          } else {
            preservedDynamicFields = updatedEvent.dynamicFields.toBuilder();
          }
          
          return updatedEvent.rebuild((b) => b
            ..createdByObj = createdByObj
            ..createdUserId = event.createdUserId
            ..dynamicFields = preservedDynamicFields);
        }
      }
    } catch (e) {
      logError(' Error saving event: $e');
      return event;
    }
  }

  Future<String> _uploadImageToStorage(
      Uint8List imageData, String imageName) async {
    try {
      final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final String safeName = imageName.replaceAll(RegExp(r'[^\w\s\-\.]'), '_');
      final String path = 'events/images/${timestamp}_$safeName';

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
      logInfo('Event image uploaded to Firebase successfully');
      return downloadUrl;
    } catch (e) {
      logError(' Error uploading event image to Firebase: $e');
      return '';
    }
  }

  Future<String> uploadImage(XFile image, String path) async {
    final file = File(image.path);
    final ref = _storage.ref().child(path);

    try {
      await ref.putFile(file);
      return await ref.getDownloadURL();
    } catch (e) {
      logError(' Error uploading event image: $e');
      rethrow;
    }
  }

  Future<String> uploadImageBytes(
      List<int> imageBytes, String path, String fileName) async {
    final ref = _storage.ref().child(path);

    try {
      await ref.putData(Uint8List.fromList(imageBytes));
      return await ref.getDownloadURL();
    } catch (e) {
      logError(' Error uploading event image bytes: $e');
      rethrow;
    }
  }

  Future<EventEntity> updateEvent(
    Credentials credentials,
    EventEntity updatedEvent,
  ) async {
    try {
      final serializedData = serializers.serializeWith(
          EventEntity.serializer, updatedEvent) as Map<String, dynamic>;

      if (updatedEvent.views != null) {
        serializedData['views'] =
            _eventInteractionsToMapList(updatedEvent.views);
      }
      if (updatedEvent.favourites != null) {
        serializedData['favourites'] =
            _eventInteractionsToMapList(updatedEvent.favourites);
      }
      if (updatedEvent.joinRequests != null) {
        serializedData['joinRequests'] =
            _joinRequestsToMapList(updatedEvent.joinRequests);
      }
      if (updatedEvent.locationData != null) {
        serializedData['locationData'] =
            _eventLocationDataToMap(updatedEvent.locationData);
      }

      if (updatedEvent.dynamicFields.isNotEmpty) {
        final dynamicFields = <String, dynamic>{};
        for (var entry in updatedEvent.dynamicFields.entries) {
          if (entry.key != 'headerImages') {
            dynamicFields[entry.key] = entry.value;
          }
        }
        serializedData['dynamicFields'] = dynamicFields;
      }
      await _firebaseRepository.updateItem(updatedEvent.id, serializedData);
      return updatedEvent;
    } catch (e) {
      logError('Error updating event in Firebase: $e');
      rethrow;
    }
  }
}
