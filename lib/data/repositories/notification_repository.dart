import 'dart:convert';
import 'dart:core';
import 'package:built_collection/built_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_boilerplate/.env.dart';
import 'package:flutter_boilerplate/data/repositories/firebase_repository.dart';
import 'package:flutter_boilerplate/data/models/serializers.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:http/http.dart' as http;

class NotificationRepository {
  const NotificationRepository();

  static final FirebaseRepository _firebaseRepository =
      FirebaseRepository('notifications');
  
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const String sendEmailCloudFunctionUrl =
      Config.CLOUDFUNCTION_SENDEMAIL;

  Future<NotificationEntity> loadItem(
      Credentials credentials, String entityId) async {
    final data = await _firebaseRepository.getItem(entityId);

    if (data != null) {
      return serializers.deserializeWith(NotificationEntity.serializer, data)!;
    }
    throw Exception('Notification with ID $entityId not found');
  }

  Future<BuiltList<NotificationEntity>> loadList(
      Credentials credentials) async {
    final response = await _firebaseRepository.getList();
    final dataList = response['data'] as List<Map<String, dynamic>>;
    final notifications = dataList
        .map((data) =>
            serializers.deserializeWith(NotificationEntity.serializer, data)!)
        .toList();

    return BuiltList<NotificationEntity>(notifications);
  }

  Future<Map<String, dynamic>> loadListWithPagination({
    DocumentSnapshot? lastDocument,
    int limit = 10,
    NotificationFilter? filter,
  }) async {
    Query query = _firestore.collection('notifications');

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

    final response = await _firebaseRepository.getList(
      customQuery: query,
      lastDocument: lastDocument,
      limit: limit,
    );

    final dataList = response['data'] as List<Map<String, dynamic>>;
    final lastDocumentSnapshot = response['lastDocument'] as DocumentSnapshot?;

    final notifications = dataList
        .map((data) =>
            serializers.deserializeWith(NotificationEntity.serializer, data)!)
        .toList();

    return {
      'notifications': BuiltList<NotificationEntity>(notifications),
      'lastDocument': lastDocumentSnapshot,
    };
  }

  Future<List<NotificationEntity>> bulkAction(
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

    return ids.map((id) => NotificationEntity(id: id)).toList();
  }

  Future<NotificationEntity> saveData(
      Credentials credentials, NotificationEntity notification) async {
    final data = serializers.serializeWith(
        NotificationEntity.serializer, notification) as Map<String, dynamic>;

    if (!(await _firebaseRepository.itemExists(notification.id))) {
      final newId =
          _firestore.collection('notifications').doc().id;
      data['id'] = newId;

      await _firebaseRepository.saveItem(newId, data);
      return notification.rebuild((b) => b..id = newId);
    } else {
      await _firebaseRepository.saveItem(notification.id, data);
      return notification;
    }
  }

  Future<void> saveFcmToken(String userId, String fcmToken) async {
    try {
      final userDocRef =
          _firestore.collection('users').doc(userId);

      final docSnapshot = await userDocRef.get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        List<String> tokens = [];

        if (data != null && data.containsKey('fcm_tokens')) {
          tokens = List<String>.from(data['fcm_tokens'] ?? []);

          if (!tokens.contains(fcmToken)) {
            tokens.add(fcmToken);
          }
        } else {
          tokens = [fcmToken];
        }

        await userDocRef.update({
          'fcm_tokens': tokens,
        });
      } else {
        await userDocRef.set({
          'fcm_tokens': [fcmToken],
        });
      }
    } catch (error) {
      logError(' Error saving FCM token: $error');
      throw error;
    }
  }

  Future<List<String>> getUserFcmTokens(String userId) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .get();

      if (!doc.exists) {
        logError(' No user found for ID: $userId');
        return [];
      }

      final data = doc.data()!;

      if (data.containsKey('fcm_tokens')) {
        final tokenList = data['fcm_tokens'];
        if (tokenList is List) {
          return List<String>.from(tokenList);
        }
      }

      if (data.containsKey('fcm_token')) {
        final tokenData = data['fcm_token'];

        if (tokenData is List) {
          return List<String>.from(tokenData);
        } else if (tokenData is String && tokenData.isNotEmpty) {
          return [tokenData];
        } else if (tokenData is Map) {
          return [tokenData['token']?.toString() ?? jsonEncode(tokenData)];
        }
      }

      return [];
    } catch (error) {
      logError(' Error getting user FCM tokens: $error');
      return [];
    }
  }

  Future<void> removeFcmToken(String userId, String fcmToken) async {
    try {
      final userDocRef =
          _firestore.collection('users').doc(userId);
      final docSnapshot = await userDocRef.get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null && data.containsKey('fcm_tokens')) {
          List<String> tokens = List<String>.from(data['fcm_tokens'] ?? []);
          tokens.remove(fcmToken);

          await userDocRef.update({
            'fcm_tokens': tokens,
          });
        }
      }
    } catch (error) {
      logError(' Error removing FCM token: $error');
      throw error;
    }
  }

  Future<Map<String, dynamic>> sendEmail({
    required String toEmail,
    required String message,
    required String authToken,
    required String subject,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(sendEmailCloudFunctionUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode({
          'toEmail': toEmail,
          'message': message,
          'emailSubject': subject,
        }),
      );

      if (response.statusCode == 401) {
        throw Exception('Unauthorized: Invalid or expired token');
      }

      return {
        'statusCode': response.statusCode,
        'body': jsonDecode(response.body),
      };
    } catch (e) {
      throw Exception('Email sending failed: ${e.toString()}');
    }
  }
}
