import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_boilerplate/project_config.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'package:http/http.dart' as http;

class FirebaseRepository {
  FirebaseRepository(this.collectionPath);
  final String collectionPath;
  
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Map<String, dynamic>?> getItem(String id) async {
    final doc = await _firestore
        .collection(collectionPath)
        .doc(id)
        .get();
    return doc.exists ? doc.data() : null;
  }

  // Future<List<Map<String, dynamic>>> getList() async {
  //   final querySnapshot =
  //       await _firestore.collection(collectionPath).get();
  //   return querySnapshot.docs.map((doc) => doc.data()).toList();
  // }
  Future<Map<String, dynamic>> getList({
    DocumentSnapshot? lastDocument,
    int limit = 10,
    Query? customQuery,
  }) async {
    Query query = customQuery ??
        _firestore
            .collection(collectionPath)
            .orderBy('start', descending: false);

    if (limit > 0) {
      query = query.limit(limit);
    }

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    final querySnapshot = await query.get();

    final List<Map<String, dynamic>> data = querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      if (!data.containsKey('id')) {
        data['id'] = doc.id;
      }
      return data;
    }).toList();

    DocumentSnapshot? nextLastDocument;
    if (querySnapshot.docs.isNotEmpty) {
      nextLastDocument = querySnapshot.docs.last;
    }

    logInfo(
        'Fetched ${data.length} records from Firestore from collection: $collectionPath');

    return {
      'data': data,
      'lastDocument': nextLastDocument,
    };
  }

  Query buildFilteredQuery({
    required Map<String, dynamic> queryParams,
  }) {
    Query query = _firestore.collection(collectionPath);

    final filters = queryParams['filters'] as Map<String, dynamic>?;
    if (filters != null) {
      filters.forEach((key, value) {
        if (value is Map<String, dynamic>) {
          if (value.containsKey('start') && value.containsKey('end')) {
            query = query.where(key,
                isGreaterThanOrEqualTo: value['start'],
                isLessThanOrEqualTo: value['end']);
          } else if (value.containsKey('greaterThan')) {
            query = query.where(key, isGreaterThan: value['greaterThan']);
          } else if (value.containsKey('lessThan')) {
            query = query.where(key, isLessThan: value['lessThan']);
          }
        } else {
          query = query.where(key, isEqualTo: value);
        }
      });
    }

    final sort = queryParams['sort'] as Map<String, dynamic>?;
    if (sort != null) {
      query = query.orderBy(
        sort['field'] as String,
        descending: !(sort['ascending'] as bool),
      );
    } else {
      query = query.orderBy('created_at', descending: true);
    }

    return query;
  }

  Future<void> saveItem(String id, Map<String, dynamic> data) async {
    await _firestore
        .collection(collectionPath)
        .doc(id)
        .set(data, SetOptions(merge: true));
  }

  Future<void> saveDynamicFieldsDetails(
      String id, Map<String, dynamic> data) async {
    await _firestore
        .collection(collectionPath)
        .doc(id)
        .set(data, SetOptions(merge: true));
  }

  Future<void> updateItem(String id, Map<String, dynamic> data) async {
    await _firestore
        .collection(collectionPath)
        .doc(id)
        .update(data);
  }

  Future<void> deleteUsers({
    required List<String> userIds,
    required String url,
    String collectionPath = ProjectConfig.usersProfileCollectionName,
  }) async {
    try {
      int successCount = 0;
      final errors = <String>[];

      for (final userId in userIds) {
        logInfo('delete this user ID ==> $userId');
        try {
          final response = await http.post(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
              'Authorization':
                  'Bearer ${await _auth.currentUser?.getIdToken()}'
            },
            body: jsonEncode({
              'userId': userId,
              'collectionName': collectionPath,
            }),
          );

          if (response.statusCode == 200) {
            successCount++;
            logInfo('Deleted $userId from $collectionPath');
          } else {
            errors.add('Failed to delete $userId: ${response.body}');
          }
        } catch (e) {
          errors.add('Error deleting $userId: $e');
        }
      }

      logInfo('Deleted $successCount/${userIds.length} users');
      if (errors.isNotEmpty) {
        throw Exception(errors.join('\n'));
      }
    } catch (e) {
      logError(' Batch deletion completed with errors: $e');
      rethrow;
    }
  }

  Future<void> deleteItems(List<String> ids) async {
    final batch = _firestore.batch();
    for (final id in ids) {
      batch.delete(
          _firestore.collection(collectionPath).doc(id));
    }
    await batch.commit();
  }

  Future<bool> itemExists(String id) async {
    final doc = await _firestore
        .collection(collectionPath)
        .doc(id)
        .get();
    return doc.exists;
  }

  Future<Map<String, dynamic>> getMessages(
    String chatId, {
    DocumentSnapshot? lastDocument,
    int limit = 20,
  }) async {
    Query query = _firestore
        .collection(collectionPath)
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .limit(limit);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    final querySnapshot = await query.get();
    final List<Map<String, dynamic>> data = querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return data;
    }).toList();

    DocumentSnapshot? nextLastDocument;
    if (querySnapshot.docs.isNotEmpty) {
      nextLastDocument = querySnapshot.docs.last;
    }

    return {
      'data': data,
      'lastDocument': nextLastDocument,
    };
  }

  Future<Map<String, dynamic>> saveMessage(
      String chatId, Map<String, dynamic> data) async {
    final chatRef =
        _firestore.collection(collectionPath).doc(chatId);
    final messagesRef = chatRef.collection('messages');
    final messageRef = messagesRef.doc();

    try {
      final messageData = Map<String, dynamic>.from(data)
        ..['messageId'] = messageRef.id
        ..['createdAt'] = DateTime.now().millisecondsSinceEpoch
        ..['updatedAt'] = DateTime.now().millisecondsSinceEpoch;

      final batch = _firestore.batch();

      batch.set(messageRef, messageData);

      await batch.commit();

      return messageData;
    } catch (error) {
      logError(' Error saving message: $error');
      throw Exception('Failed to save message: $error');
    }
  }

  Future<void> updateMessageStatus(
      String chatId, List<String> messageIds, String status) async {
    final batch = _firestore.batch();

    for (final messageId in messageIds) {
      final ref = _firestore
          .collection(collectionPath)
          .doc(chatId)
          .collection('messages')
          .doc(messageId);

      batch.update(ref, {
        'status': status,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      });
    }

    await batch.commit();
  }
}
