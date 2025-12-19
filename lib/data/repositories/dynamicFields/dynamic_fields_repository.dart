import 'dart:core';
import 'package:flutter_boilerplate/data/models/dynamic_fields/dynamic_fields_modal.dart';
import 'package:flutter_boilerplate/data/models/entities.dart';
import 'package:flutter_boilerplate/data/repositories/firebase_repository.dart';

class DynamicFieldRepository {
  const DynamicFieldRepository();

  static FirebaseRepository _firebaseRepository(dynamic type) {
    return FirebaseRepository(type is QuestionType ? type.getName() : type);
  }

  Future<dynamic> loadItem(String entityId, QuestionType type) async {
    final repository = _firebaseRepository(type);
    final data = await repository.getItem(entityId);
    if (data != null) {
      return data;
    }
    throw Exception('UserProfile Detail with ID $entityId not found');
  }

  Future<void> saveData(String userId, dynamic data, QuestionType type,
      EntityType entityType) async {
    if (entityType == EntityType.profile) {
      final repository = _firebaseRepository('profiles');
      await repository.saveDynamicFieldsDetails(userId, data);
    }

    final repository = _firebaseRepository(type);
    await repository.saveDynamicFieldsDetails(userId, data);
  }
}
