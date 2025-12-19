import 'dart:convert';
import 'dart:core';
import 'dart:typed_data';
import 'package:built_collection/built_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_boilerplate/.env.dart';
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/data/repositories/firebase_repository.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/project_config.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/ui/dynamic_fields/dynamic_fields_presenter.dart';
import 'package:flutter_boilerplate/utils/completers.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'package:http/http.dart' as http;

class ProfileRepository {
  const ProfileRepository();

  static final FirebaseRepository _firebaseRepository =
      FirebaseRepository(ProjectConfig.usersProfileCollectionName);
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static final FirebaseStorage _storage = FirebaseStorage.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const String filterProfilesCloudFunctionUrl =
      Config.CLOUDFUNCTION_FILTERPROFILES;
  static const String deleteUserCloudFunctionUrl =
      Config.CLOUDFUNCTION_DELETEUSER;
  Future<ProfileEntity> loadItem(
      Credentials credentials, String entityId) async {
    final data = await _firebaseRepository.getItem(entityId);

    if (data != null) {
      return ProfileMapper.dbToEntity(data, entityId);
    }

    logError('Profile with ID $entityId not found');
    return ProfileEntity(id: entityId);
  }

  Future<ProfilePaginationResponse> loadListWithPagination({
    DocumentSnapshot? lastDocument,
    int limit = 10,
    ProfileFilter? filter,
    bool isAdmin = false,
    bool excludeLikedMatchedProfiles = false,
    String? selectedCompanyId,
  }) async {
    try {
      final queryParams = {
        'limit': limit.toString(),
        if (lastDocument != null) 'lastDocId': lastDocument.id,
        if (filter?.currentUserId != null && filter!.currentUserId.isNotEmpty)
          'currentUserId': filter.currentUserId,
        'excludeLikedMatchedProfiles': excludeLikedMatchedProfiles.toString(),
        if (selectedCompanyId != null && selectedCompanyId.isNotEmpty)
          'selectedCompanyId': selectedCompanyId,
      };

      final uri = Uri.parse(filterProfilesCloudFunctionUrl).replace(
        queryParameters: queryParams,
      );

      final dynamicFieldsMap = <String, dynamic>{};
      filter?.dynamicFieldsFilters.forEach((key, value) {
        dynamicFieldsMap[key] = value;
      });

      final requestBody = {
        'filters': {
          'dynamicFields': dynamicFieldsMap,
          'state': _getStateFilter(filter),
          'searchTerm': filter?.searchTerm ?? '',
          if (filter?.preferredGender != null &&
              filter!.preferredGender.isNotEmpty)
            'preferredGender': filter.preferredGender,
          if (filter?.currentUserId != null && filter!.currentUserId.isNotEmpty)
            'currentUserId': filter.currentUserId,
          'isAdmin': isAdmin,
        },
        'excludeLikedMatchedProfiles': excludeLikedMatchedProfiles,
        if (selectedCompanyId != null && selectedCompanyId.isNotEmpty)
          'selectedCompanyId': selectedCompanyId,
      };

      final idToken = await _auth.currentUser?.getIdToken();

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          if (idToken != null) 'Authorization': 'Bearer $idToken',
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final List<ProfileEntity> profiles = [];

        for (final profileData in data['profiles']) {
          final profile = ProfileMapper.dbToEntity(
              Map<String, dynamic>.from(profileData), profileData['id']);
          profiles.add(profile);
        }

        DocumentSnapshot? newLastDocument;
        if (data['lastDocument'] != null) {
          try {
            final docRef =
                _firestore.collection('users').doc(data['lastDocument']);
            newLastDocument = await docRef.get();
          } catch (e) {
            logError(' Error getting lastDocument: $e');
          }
        }

        return ProfilePaginationResponse(
          profiles: BuiltList<ProfileEntity>(profiles),
          lastDocument: newLastDocument,
        );
      } else {
        logError(
            ' Cloud Function call failed with status: ${response.statusCode} Response: ${response.body}');
        return _loadFromFirestoreBasic(
            lastDocument: lastDocument, limit: limit, filter: filter);
      }
    } catch (e) {
      logError(' Error calling Cloud Function: $e');
      return _loadFromFirestoreBasic(
          lastDocument: lastDocument, limit: limit, filter: filter);
    }
  }

  String _getStateFilter(ProfileFilter? filter) {
    if (filter == null) return kEntityStateActive;

    switch (filter.stateFilter) {
      case EntityState.active:
        return kEntityStateActive;
      case EntityState.archived:
        return kEntityStateArchived;
      case EntityState.deleted:
        return kEntityStateDeleted;
      case EntityState.reported:
        return kEntityStateReported;
      default:
        return kEntityStateActive;
    }
  }

  Future<ProfileSingleResponse> loadSingleProfile({
    DocumentSnapshot? lastDocument,
    int limit = 1,
    ProfileFilter? filter,
    bool excludeLikedMatchedProfiles = false,
    String? selectedCompanyId,
    bool isAdmin = false,
  }) async {
    try {
      final response = await loadListWithPagination(
        lastDocument: lastDocument,
        limit: 1,
        filter: filter,
        excludeLikedMatchedProfiles: excludeLikedMatchedProfiles,
        selectedCompanyId: selectedCompanyId,
        isAdmin: isAdmin,
      );

      final profiles = response.profiles;
      final newLastDocument = response.lastDocument;
      if (profiles.isEmpty) {
        snackBarCompleter<void>('No more profiles available').complete();
      }
      return ProfileSingleResponse(
        profile: profiles.isNotEmpty ? profiles.first : null,
        lastDocument: newLastDocument,
      );
    } catch (e) {
      logError(' Error loading single profile: $e');
      return ProfileSingleResponse(
        profile: null,
        lastDocument: null,
      );
    }
  }

  Future<ProfilePaginationResponse> _loadFromFirestoreBasic({
    DocumentSnapshot? lastDocument,
    int limit = 10,
    ProfileFilter? filter,
  }) async {
    try {
      Query query =
          _firestore.collection(ProjectConfig.usersProfileCollectionName);

      if (filter != null) {
        switch (filter.stateFilter) {
          case EntityState.active:
            query = query
                .where('archived_at', isEqualTo: 0)
                .where('is_deleted', isEqualTo: false);
            break;
          case EntityState.archived:
            query = query
                .where('archived_at', isGreaterThan: 0)
                .where('is_deleted', isEqualTo: false);
            break;
          case EntityState.deleted:
            query = query.where('is_deleted', isEqualTo: true);
            break;
        }

        if (filter.sortField.isNotEmpty) {
          query = query.orderBy(filter.sortField,
              descending: !filter.sortAscending);
        }
      }

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      final querySnapshot = await query.limit(limit).get();

      final profiles = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return ProfileMapper.dbToEntity(data, doc.id);
      }).toList();

      return ProfilePaginationResponse(
        profiles: BuiltList<ProfileEntity>(profiles),
        lastDocument:
            querySnapshot.docs.isNotEmpty ? querySnapshot.docs.last : null,
      );
    } catch (e) {
      logError(' Error in _loadFromFirestoreBasic: $e');
      rethrow;
    }
  }

  Future<List<ProfileEntity>> bulkAction(
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
      await _firebaseRepository.deleteUsers(
          userIds: ids, url: deleteUserCloudFunctionUrl);
    }

    return ids.map((id) => ProfileEntity(id: id)).toList();
  }

  Future<String> _uploadImageToStorage(
      List<int> imageData, String userId, String imageName) async {
    try {
      final String path = 'users/$userId/images/$imageName';

      final ref = _storage.ref().child(path);

      final UploadTask uploadTask = ref.putData(
        Uint8List.fromList(imageData),
        SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {
            'userId': userId,
            'uploadedAt': DateTime.now().toIso8601String(),
          },
        ),
      );

      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      logError(' Error uploading image: $e');
      return '';
    }
  }

  Future<ProfileEntity> saveData(String userId, ProfileEntity profile) async {
    try {
      final dynamicFields =
          Map<String, dynamic>.from(profile.dynamicFields.toMap());

      if (dynamicFields.containsKey('images') &&
          dynamicFields['images'] is List) {
        final imagesList = dynamicFields['images'] as List;
        final processedImages = [];

        for (var image in imagesList) {
          if (image is Map &&
              image.containsKey('bytes') &&
              image.containsKey('name')) {
            final bytes = image['bytes'] as List<int>;
            final name = image['name'] as String;
            final type = image['type'] as String?;
            final size = image['size'] as int? ?? bytes.length;
            final action = image['action'] as String?;

            if (action != 'added' || bytes.isEmpty) {
              processedImages.add(image);
              continue;
            }

            final imageUrl = await _uploadImageToStorage(bytes, userId, name);

            processedImages.add({
              'name': name,
              'url': imageUrl,
              'size': size,
              'type': type,
              'action': action
            });
          } else if (image is Map && image.containsKey('url')) {
            processedImages.add(image);
          } else if (image is String && image.startsWith('http')) {
            processedImages.add({
              'url': image,
              'name': _getFileNameFromUrl(image),
              'action': 'existing'
            });
          }
        }

        dynamicFields['images'] = processedImages;
      }

      final profileToSave = profile.rebuild((b) => b
        ..dynamicFields.clear()
        ..dynamicFields.addAll(dynamicFields));

      Map<String, dynamic> data = ProfileMapper.entityToDb(profileToSave);

      if (profile.isNew) {
        final newId = userId;
        data['id'] = newId;
        data['name'] = dynamicFieldProfileNameField(dynamicFields).trim();
        data['created_at'] = DateTime.now().millisecondsSinceEpoch;
        data['updated_at'] = DateTime.now().millisecondsSinceEpoch;
        data['archived_at'] =
            ProjectConfig.defaultNewUserStatus() == kEntityStateActive
                ? 0
                : DateTime.now().millisecondsSinceEpoch;

        await _firebaseRepository.saveItem(newId, data);
        final savedProfile = profile.rebuild((b) => b
          ..id = newId
          ..archivedAt = data['archived_at']
          ..dynamicFields.clear()
          ..dynamicFields.addAll(dynamicFields));
        return savedProfile;
      } else {
        data['updated_at'] = DateTime.now().millisecondsSinceEpoch;
        data['name'] = dynamicFieldProfileNameField(dynamicFields).trim();
        await _firebaseRepository.saveItem(profile.id, data);
        return profile.rebuild((b) => b
          ..dynamicFields.clear()
          ..dynamicFields.addAll(dynamicFields));
      }
    } catch (e) {
      logError(' Error saving profile: $e');
      return profile;
    }
  }

  // Helper function to extract filename from URL
  String _getFileNameFromUrl(String url) {
    try {
      final Uri uri = Uri.parse(url);
      final String path = uri.path;
      final String fileName = path.split('/').last;

      // Handle URL-encoded filenames
      if (fileName.contains('%')) {
        return Uri.decodeComponent(fileName).split('?').first;
      }

      return fileName.split('?').first;
    } catch (e) {
      return 'file_${DateTime.now().millisecondsSinceEpoch}';
    }
  }

  Future<List<String>> assignCompanyToProfiles({
    required String companyId,
    required List<String> emails,
  }) async {
    try {
      final companyDoc =
          await _firestore.collection('companies').doc(companyId).get();

      if (!companyDoc.exists) {
        logError('Company not found with ID: $companyId');
        return [];
      }

      final companyData = companyDoc.data()!;
      final companyName = companyData['name'] ?? 'Unknown Company';

      final userCompany = UserCompany(
        companyId: companyId,
        companyName: companyName,
      );

      final List<String> updatedProfileIds = [];

      for (final email in emails) {
        await addUserCompanyToProfile(
          userEmail: email,
          company: userCompany,
        );

        final query = _firestore
            .collection(ProjectConfig.usersProfileCollectionName)
            .where('email', isEqualTo: email.trim().toLowerCase())
            .limit(1);

        final querySnapshot = await query.get();
        if (querySnapshot.docs.isNotEmpty) {
          updatedProfileIds.add(querySnapshot.docs.first.id);
        }
      }

      return updatedProfileIds;
    } catch (e) {
      logError('Error assigning company to profiles: $e');
      return [];
    }
  }

  Future<List<CompanyEntity>> loadAllCompanies() async {
    try {
      final companiesQuery =
          _firestore.collection('companies').orderBy('settings.name');

      final querySnapshot = await companiesQuery.get();

      final List<CompanyEntity> companies = [];

      for (final doc in querySnapshot.docs) {
        try {
          final data = doc.data();
          data['id'] = doc.id;

          final company = CompanyEntity().rebuild((b) => b
            ..id = doc.id
            ..settings.replace(SettingsEntity().rebuild((settingsBuilder) {
              final settings = data['settings'] as Map<String, dynamic>? ?? {};
              settingsBuilder.name = settings['name'] ?? '';
            })));

          companies.add(company);
        } catch (e) {
          logError('Error parsing company ${doc.id}: $e');
        }
      }

      return companies;
    } catch (e) {
      logError('Error loading companies: $e');
      return [];
    }
  }

  Future<List<CompanyEntity>> loadCompaniesByIds(
      List<String> companyIds) async {
    try {
      if (companyIds.isEmpty) {
        return [];
      }

      final List<CompanyEntity> companies = [];

      const batchSize = 10;
      for (int i = 0; i < companyIds.length; i += batchSize) {
        final batch = companyIds.skip(i).take(batchSize).toList();

        final querySnapshot = await _firestore
            .collection('companies')
            .where(FieldPath.documentId, whereIn: batch)
            .get();

        for (final doc in querySnapshot.docs) {
          try {
            final data = doc.data();

            final company = CompanyEntity().rebuild((b) => b
              ..id = doc.id
              ..createdAt = data['created_at'] ?? 0
              ..updatedAt = data['updated_at'] ?? 0
              ..archivedAt = data['archived_at'] ?? 0
              ..assignedUserId = data['assigned_user_id'] ?? ''
              ..createdUserId = data['created_user_id'] ?? ''
              ..isChanged = false
              ..isDeleted = data['is_deleted'] ?? false
              ..sizeId = data['size_id'] ?? ''
              ..industryId = data['industry_id'] ?? ''
              ..enabledModules = data['enabled_modules'] ?? 0
              ..firstMonthOfYear = data['first_month_of_year'] ?? '0'
              ..isLarge = data['is_large'] ?? false
              ..isDisabled = data['is_disabled'] ?? false
              ..sessionTimeout = data['session_timeout'] ?? 0
              ..passwordTimeout = data['password_timeout'] ?? (30 * 60 * 1000)
              ..oauthPasswordRequired = data['oauth_password_required'] ?? false
              ..markdownEnabled = data['markdown_enabled'] ?? true
              ..markdownEmailEnabled = data['markdown_email_enabled'] ?? true
              ..useCommaAsDecimalPlace =
                  data['use_comma_as_decimal_place'] ?? false
              ..smtpHost = data['smtp_host'] ?? ''
              ..smtpPort = data['smtp_port'] ?? 587
              ..smtpEncryption =
                  data['smtp_encryption'] ?? CompanyEntity.SMTP_ENCRYPTION_TLS
              ..smtpUsername = data['smtp_username'] ?? ''
              ..smtpPassword = data['smtp_password'] ?? ''
              ..smtpLocalDomain = data['smtp_local_domain'] ?? ''
              ..smtpVerifyPeer = data['smtp_verify_peer'] ?? true
              ..settings.replace(_buildSettingsFromData(data))
              ..customFields.replace(
                  Map<String, String>.from(data['custom_fields'] ?? {}))
              ..users.replace(BuiltList<UserEntity>())
              ..activities.replace(BuiltList<ActivityEntity>())
              ..designs.replace(BuiltList<DesignEntity>()));

            companies.add(company);
          } catch (e) {
            logError('Error parsing company ${doc.id}: $e');
          }
        }
      }

      return companies;
    } catch (e) {
      logError('Error loading companies by IDs: $e');
      return [];
    }
  }

  SettingsEntity _buildSettingsFromData(Map<String, dynamic> data) {
    final settings = data['settings'] as Map<String, dynamic>? ?? {};
    return SettingsEntity().rebuild((b) => b
      ..name = settings['name'] ?? ''
      ..companyLogo =
          settings['company_logo'] ?? settings['companyLogo'] ?? '');
  }

  Future<void> addCompanyToUserProfile({
    required String userId,
    required CompanyEntity company,
  }) async {
    try {
      final userDocRef = _firestore
          .collection(ProjectConfig.usersProfileCollectionName)
          .doc(userId);

      final userDoc = await userDocRef.get();

      if (!userDoc.exists) {
        logError('User document not found for userId: $userId');
        return;
      }

      final userData = userDoc.data() ?? {};
      List<dynamic> existingCompanies = userData['companies'] ?? [];

      bool companyExists = existingCompanies.any((existingCompany) {
        if (existingCompany is Map<String, dynamic>) {
          return existingCompany['companyId'] == company.id;
        }
        logError(
            'Invalid company data structure found in user $userId companies array: $existingCompany');
        return false;
      });

      if (!companyExists) {
        final companyName = company.displayName.isNotEmpty
            ? company.displayName
            : (company.settings.name ?? '');

        if (companyName.isEmpty) {
          logError(
              'Company ${company.id} has no name (displayName or settings.name)');
        }

        final newCompanyData = {
          'companyId': company.id,
          'companyName': companyName,
        };

        existingCompanies.add(newCompanyData);

        List<dynamic> existingCompanyIds = userData['companyIds'] ?? [];
        if (!existingCompanyIds.contains(company.id)) {
          existingCompanyIds.add(company.id);
        }

        await userDocRef.update({
          'companies': existingCompanies,
          'companyIds': existingCompanyIds,
          'updated_at': DateTime.now().millisecondsSinceEpoch,
        });
      }
    } catch (e) {
      logError(
          'Error adding company ${company.id} to user profile $userId: $e');
      if (e.toString().contains('permission-denied')) {
        logError(
            'Permission denied when trying to update user $userId. Check Firestore security rules.');
      } else if (e.toString().contains('not-found')) {
        logError(
            'User document $userId not found in collection ${ProjectConfig.usersProfileCollectionName}');
      } else if (e.toString().contains('network')) {
        logError(
            'Network error when updating user $userId: Check internet connection');
      }
    }
  }

  Future<void> addUserCompanyToProfile({
    required String userEmail,
    required UserCompany company,
  }) async {
    try {
      final normalizedEmail = userEmail.trim().toLowerCase();

      if (!normalizedEmail.contains('@') || normalizedEmail.length < 5) {
        logError(
            'Invalid email format: "$userEmail". Skipping company assignment.');
        return;
      }

      final usersSnapshot = await _firestore
          .collection(ProjectConfig.usersProfileCollectionName)
          .where('email', isEqualTo: normalizedEmail)
          .limit(1)
          .get();

      if (usersSnapshot.docs.isEmpty) {
        return;
      }

      final userDoc = usersSnapshot.docs.first;
      final userData = userDoc.data();

      List<dynamic> existingCompanies = userData['companies'] ?? [];

      bool companyExists = existingCompanies.any((existingCompany) {
        if (existingCompany is Map<String, dynamic>) {
          final existingCompanyId = existingCompany['companyId'];
          return existingCompanyId == company.companyId;
        }
        return false;
      });

      if (!companyExists) {
        final newCompanyData = company.toMap();
        existingCompanies.add(newCompanyData);

        List<dynamic> existingCompanyIds = userData['companyIds'] ?? [];
        if (!existingCompanyIds.contains(company.companyId)) {
          existingCompanyIds.add(company.companyId);
        }

        await _firestore
            .collection(ProjectConfig.usersProfileCollectionName)
            .doc(userDoc.id)
            .update({
          'companies': existingCompanies,
          'companyIds': existingCompanyIds,
          'updated_at': DateTime.now().millisecondsSinceEpoch,
        });

        logInfo('Successfully updated profile for ${normalizedEmail}');
      } else {
        logInfo(
            'Company ${company.companyName} already exists for user ${normalizedEmail}');
      }
    } catch (e) {
      logError('Error adding company to user profile by email: $e');
    }
  }

  Future<List<CompanyEntity>> loadUserCompanies(String userId) async {
    try {
      final userDocRef = _firestore
          .collection(ProjectConfig.usersProfileCollectionName)
          .doc(userId);

      final companiesQuery = userDocRef
          .collection('companies')
          .orderBy('created_at', descending: true);

      final querySnapshot = await companiesQuery.get();

      final List<CompanyEntity> companies = [];

      for (final doc in querySnapshot.docs) {
        try {
          final data = doc.data();

          final company = CompanyEntity().rebuild((b) => b
            ..id = data['id'] ?? doc.id
            ..settings.replace(SettingsEntity().rebuild((settingsBuilder) {
              final settings = data['settings'] as Map<String, dynamic>? ?? {};
              settingsBuilder.name = settings['name'] ?? data['name'] ?? '';
            })));

          companies.add(company);
        } catch (e) {
          logError('Error parsing user company ${doc.id}: $e');
        }
      }

      return companies;
    } catch (e) {
      logError('Error loading user companies: $e');
      return [];
    }
  }

  Future<void> removeCompanyFromUserProfile({
    required String userId,
    required String companyId,
  }) async {
    try {
      final userDocRef = _firestore
          .collection(ProjectConfig.usersProfileCollectionName)
          .doc(userId);

      final companyDocRef = userDocRef.collection('companies').doc(companyId);

      await companyDocRef.delete();
    } catch (e) {
      logError('Error removing company from user profile: $e');
    }
  }
}
