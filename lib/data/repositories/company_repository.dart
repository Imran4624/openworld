import 'dart:core';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/data/repositories/profile_repository.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'package:flutter_boilerplate/utils/completers.dart';

class CompanyRepository {
  const CompanyRepository();

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<CompanyEntity> createCompany({
    required Map<String, dynamic> companyData,
  }) async {
    try {
      final companyDocRef = _firestore.collection('companies').doc();
      final companyId = companyDocRef.id;

      String logoUrl = 'https://via.placeholder.com/150x150.png?text=Logo';
      if (companyData['logoFile'] != null) {
        final logoFile = companyData['logoFile'] as Map<String, dynamic>;
        logoUrl = await _uploadLogo(companyId, logoFile);
      }

      final companyEntity = CompanyEntity().rebuild((b) => b
        ..id = companyId
        ..settings.name = companyData['name'] as String
        ..settings.companyLogo = logoUrl
        ..createdUserId = companyData['createdUserId'] as String? ?? ''
        ..createdAt = DateTime.now().millisecondsSinceEpoch
        ..updatedAt = DateTime.now().millisecondsSinceEpoch
        ..archivedAt = 0
        ..isDeleted = false
        ..customFields.addAll({
          if (companyData['importFrom'] != null &&
              (companyData['importFrom'] as String).isNotEmpty)
            'importFrom': companyData['importFrom'] as String,
          if (companyData['apiKey'] != null &&
              (companyData['apiKey'] as String).isNotEmpty)
            'apiKey': companyData['apiKey'] as String,
        }));

      final companyFirestoreData = {
        'id': companyEntity.id,
        'name': companyEntity.settings.name,
        'logo': companyEntity.settings.companyLogo,
        'created_user_id': companyEntity.createdUserId,
        'created_at': companyEntity.createdAt,
        'updated_at': companyEntity.updatedAt,
        'archived_at': companyEntity.archivedAt,
        'is_deleted': companyEntity.isDeleted,
        'size_id': companyEntity.sizeId,
        'industry_id': companyEntity.industryId,
        'is_large': companyEntity.isLarge,
        'is_disabled': companyEntity.isDisabled,
        'first_month_of_year': companyEntity.firstMonthOfYear,
        'session_timeout': companyEntity.sessionTimeout,
        'default_password_timeout': companyEntity.passwordTimeout,
        'oauth_password_required': companyEntity.oauthPasswordRequired,
        'markdown_enabled': companyEntity.markdownEnabled,
        'markdown_email_enabled': companyEntity.markdownEmailEnabled,
        'use_comma_as_decimal_place': companyEntity.useCommaAsDecimalPlace,
        'enabled_modules': companyEntity.enabledModules,
        'settings': {
          'name': companyEntity.settings.name,
          'company_logo': companyEntity.settings.companyLogo,
        },
        'custom_fields': companyEntity.customFields.toMap(),
      };

      Map<String, dynamic>? importData;
      if (companyData['importFrom'] != null &&
          companyData['apiKey'] != null &&
          (companyData['apiKey'] as String).trim().isNotEmpty) {
        importData = {
          'importFrom': companyData['importFrom'],
          'apiKey': companyData['apiKey'],
          'createdAt': DateTime.now().millisecondsSinceEpoch,
        };
      }

      final batch = _firestore.batch();

      batch.set(companyDocRef, companyFirestoreData);

      if (importData != null) {
        final importDocRef = companyDocRef.collection('importData').doc();
        batch.set(importDocRef, importData);
        logInfo('Adding import data to subcollection');
      }

      await batch.commit();
      logInfo('Successfully created company in Firestore');

      if (companyData['createdUserId'] != null &&
          (companyData['createdUserId'] as String).isNotEmpty) {
        try {
          const profileRepository = ProfileRepository();
          await profileRepository.addCompanyToUserProfile(
            userId: companyData['createdUserId'] as String,
            company: companyEntity,
          );
          logInfo('Added company to user profile');
        } catch (e) {
          logError('Error adding company to user profile: $e');
        }
      }

      return companyEntity;
    } catch (e) {
      logError('Error creating company: $e');
      return CompanyEntity();
    }
  }

  Future<CompanyEntity> updateCompany({
    required String companyId,
    required Map<String, dynamic> companyData,
  }) async {
    try {
      final companyDocRef = _firestore.collection('companies').doc(companyId);

      final docSnapshot = await companyDocRef.get();
      if (!docSnapshot.exists) {
        logError('Company not found');
        return CompanyEntity();
      }

      String? logoUrl;
      if (companyData['logoFile'] != null) {
        final logoFile = companyData['logoFile'] as Map<String, dynamic>;
        logoUrl = await _uploadLogo(companyId, logoFile);
      }

      final companyEntity = CompanyEntity().rebuild((b) => b
        ..id = companyId
        ..settings.name = companyData['name'] as String
        ..settings.companyLogo = logoUrl ??
            (docSnapshot.data()!['settings']
                as Map<String, dynamic>?)?['company_logo'] ??
            'https://via.placeholder.com/150x150.png?text=Logo'
        ..createdAt = docSnapshot.data()!['created_at'] as int? ??
            DateTime.now().millisecondsSinceEpoch
        ..updatedAt = DateTime.now().millisecondsSinceEpoch
        ..customFields.addAll({
          if (companyData['importFrom'] != null &&
              (companyData['importFrom'] as String).isNotEmpty)
            'importFrom': companyData['importFrom'] as String,
          if (companyData['apiKey'] != null &&
              (companyData['apiKey'] as String).isNotEmpty)
            'apiKey': companyData['apiKey'] as String,
        }));

      final companyFirestoreData = {
        'id': companyEntity.id,
        'created_at': companyEntity.createdAt,
        'updated_at': companyEntity.updatedAt,
        'settings': {
          'name': companyEntity.settings.name,
          'company_logo': companyEntity.settings.companyLogo,
        },
        'custom_fields': companyEntity.customFields.toMap(),
      };

      Map<String, dynamic>? importData;
      if (companyData['importFrom'] != null &&
          companyData['apiKey'] != null &&
          (companyData['apiKey'] as String).trim().isNotEmpty) {
        importData = {
          'importFrom': companyData['importFrom'],
          'apiKey': companyData['apiKey'],
          'updatedAt': DateTime.now().millisecondsSinceEpoch,
        };
      }

      final batch = _firestore.batch();

      batch.update(companyDocRef, companyFirestoreData);

      if (importData != null) {
        final importCollectionRef = companyDocRef.collection('importData');
        final existingImportDocs = await importCollectionRef.get();

        if (existingImportDocs.docs.isNotEmpty) {
          final importDocRef = existingImportDocs.docs.first.reference;
          batch.update(importDocRef, importData);
        } else {
          final importDocRef = importCollectionRef.doc();
          batch.set(importDocRef, importData);
        }
      }

      await batch.commit();

      await _updateCompanyInAllUserProfiles(
          companyId, companyData['name'] as String);

      return companyEntity;
    } catch (e) {
      logError('Error updating company: $e');
      return CompanyEntity();
    }
  }

  Future<Map<String, dynamic>> getCompanyWithImportData({
    required String companyId,
  }) async {
    try {
      final companyDocRef = _firestore.collection('companies').doc(companyId);

      final docSnapshot = await companyDocRef.get();
      if (!docSnapshot.exists) {
        logError('Company not found');
        return <String, dynamic>{};
      }

      final companyData = docSnapshot.data()!;

      final importDataSnapshot =
          await companyDocRef.collection('importData').limit(1).get();

      Map<String, dynamic>? importData;
      if (importDataSnapshot.docs.isNotEmpty) {
        importData = importDataSnapshot.docs.first.data();
      }

      return {
        'companyId': companyId,
        'name': companyData['settings']?['name'] ?? '',
        'companyLogo': companyData['settings']?['company_logo'] ??
            'https://via.placeholder.com/150x150.png?text=Logo',
        'apiKey': importData?['apiKey'] ?? '',
        'importFrom': importData?['importFrom'] ?? '',
        'createdAt': companyData['created_at'] as int? ??
            DateTime.now().millisecondsSinceEpoch,
        'updatedAt': importData != null
            ? _convertTimestampToInt(importData['updatedAt'])
            : DateTime.now().millisecondsSinceEpoch,
      };
    } catch (e) {
      logError('Error fetching company with import data: $e');
      return <String, dynamic>{};
    }
  }

  Future<String> _uploadLogo(
      String companyId, Map<String, dynamic> logoFile) async {
    try {
      final storageRef =
          _storage.ref().child('companies').child(companyId).child('logo.jpg');

      final bytes = logoFile['bytes'] as List<int>;
      final uploadTask = await storageRef.putData(
        Uint8List.fromList(bytes),
        SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {
            'companyId': companyId,
            'uploadedAt': DateTime.now().toIso8601String(),
          },
        ),
      );

      final downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      logError('Error uploading logo for company $companyId: $e');
      return 'https://via.placeholder.com/150x150.png?text=Logo';
    }
  }

  Future<void> _updateCompanyInAllUserProfiles(
      String companyId, String newCompanyName) async {
    try {
      final usersSnapshot = await _firestore.collection('users').get();

      final batch = _firestore.batch();
      int updateCount = 0;

      for (final userDoc in usersSnapshot.docs) {
        final userData = userDoc.data();
        final companies = userData['companies'] as List?;

        if (companies != null) {
          bool hasCompany = false;
          final updatedCompanies = companies.map((company) {
            if (company is Map && company['companyId'] == companyId) {
              hasCompany = true;
              return {
                'companyId': companyId,
                'companyName': newCompanyName,
              };
            }
            return company;
          }).toList();

          if (hasCompany) {
            batch.update(userDoc.reference, {
              'companies': updatedCompanies,
              'updated_at': DateTime.now().millisecondsSinceEpoch,
            });
            updateCount++;
          }
        }
      }

      if (updateCount > 0) {
        await batch.commit();
      }
    } catch (e) {
      logError('Error updating company name in user profiles: $e');
    }
  }

  int _convertTimestampToInt(dynamic timestamp) {
    if (timestamp == null) {
      return DateTime.now().millisecondsSinceEpoch;
    } else if (timestamp is int) {
      return timestamp;
    } else if (timestamp is Timestamp) {
      return timestamp.millisecondsSinceEpoch;
    } else {
      return int.tryParse(timestamp.toString()) ??
          DateTime.now().millisecondsSinceEpoch;
    }
  }
}
