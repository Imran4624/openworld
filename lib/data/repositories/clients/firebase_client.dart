import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_boilerplate/.env.dart';
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/project_config.dart';
import 'package:flutter_boilerplate/ui/app/app_webview_url.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'package:flutter_boilerplate/utils/web_stub.dart'
    if (dart.library.html) 'package:flutter_boilerplate/utils/web.dart';
import 'client_base.dart';

class FirebaseClient implements ClientBase {
  factory FirebaseClient() {
    return _instance;
  }

  FirebaseClient._internal();
  static final FirebaseClient _instance = FirebaseClient._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<ProfileSaveResult> saveProfile({
    required String userId,
    required Map<String, dynamic> profileData,
    bool isNewProfile = false,
  }) async {
    try {
      final sanitizedData = Map<String, dynamic>.from(profileData);
      if (sanitizedData.containsKey('email') &&
          sanitizedData['email'] != null) {
        sanitizedData['email'] =
            sanitizedData['email'].toString().trim().toLowerCase();
      }
      if (sanitizedData.containsKey('name') && sanitizedData['name'] != null) {
        sanitizedData['name'] = sanitizedData['name'].toString().trim();
      }

      final DocumentReference profileRef = _firestore
          .collection(ProjectConfig.usersProfileCollectionName)
          .doc(userId);

      if (!isNewProfile) {
        final existingDoc = await profileRef.get();
        final existingData = existingDoc.data() as Map<String, dynamic>?;
        final currentCreatedAt = existingData?['created_at'];

        final updateData = {
          ...sanitizedData,
          'updated_at': DateTime.now().millisecondsSinceEpoch,
        };

        if (currentCreatedAt == null || currentCreatedAt == 0) {
          updateData['created_at'] = DateTime.now().millisecondsSinceEpoch;
        }

        await profileRef.update(updateData);
      } else {
        await profileRef.set({
          ...sanitizedData,
          'created_at': DateTime.now().millisecondsSinceEpoch,
          'updated_at': DateTime.now().millisecondsSinceEpoch,
        }, SetOptions(merge: true));
      }

      final DocumentSnapshot profileSnapshot = await profileRef.get();
      if (!profileSnapshot.exists) {
        logError('Failed to save profile - document does not exist after save');
        return ProfileSaveResult(id: userId, data: {'id': userId});
      }

      final data = {
        'id': profileSnapshot.id,
        ...profileSnapshot.data() as Map<String, dynamic>,
      };

      return ProfileSaveResult(
        id: profileSnapshot.id,
        data: data,
      );
    } catch (e) {
      logError(' Error saving profile: $e');
      return ProfileSaveResult(id: userId, data: {'id': userId});
    }
  }

  @override
  Future<SignUpResult> signUp(String email, String password) async {
    final UserCredential userCredential =
        await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final User? user = userCredential.user;

    if (user == null) {
      logError('SignUp failed: Unable to register user');
      return SignUpResult(uid: '', email: '', displayName: '');
    }

    if (ProjectConfig.emailConfirmationEnabled) {
      await user.sendEmailVerification();
    }

    final String userName = email.trim().split('@')[0].trim();

    final isProfileCompleted =
        ProjectConfig.onboardingQuestionsOnSignupDisabled;

    final profileData = await saveProfile(
      userId: user.uid,
      isNewProfile: true,
      profileData: {
        'uid': user.uid,
        'email': user.email!.trim().toLowerCase(),
        'userName': userName,
        'dynamicFields': {},
        'name': userName,
        'isDeleted': false,
        'isProfileCompleted': isProfileCompleted,
        'verified_phone_number': false,
        'phone': '',
      },
    );

    return SignUpResult(
      uid: user.uid,
      email: profileData.data['email'] ?? '',
      displayName: profileData.data['userName'] ?? userName,
    );
  }

  @override
  Future<ProfileEntity?> currentUserProfile([String? userId]) async {
    try {
      String? targetUserId = userId;

      if (targetUserId == null) {
        final User? currentUser = _auth.currentUser;
        if (currentUser != null) {
          targetUserId = currentUser.uid;
        }
      }

      if (targetUserId == null) {
        logError('User not authenticated');
        return null;
      }

      final Map<String, dynamic>? profileData = await getProfile(targetUserId);
      if (profileData == null) {
        return null;
      }

      final Map<String, dynamic> safeProfileData =
          Map<String, dynamic>.from(profileData);

      final currentUserData =
          ProfileMapper.dbToEntity(safeProfileData, targetUserId).rebuild((b) {
        if (safeProfileData['likesProfileMap'] != null) {
          final Map<String, dynamic> likesMap =
              safeProfileData['likesProfileMap'] as Map<String, dynamic>;
          b.likesProfileMap.clear();
          likesMap.forEach((key, value) {
            b.likesProfileMap[key] = _convertToProfileOperation(value);
          });
        }

        if (safeProfileData['likedMeProfileMap'] != null) {
          final Map<String, dynamic> likedMeMap =
              safeProfileData['likedMeProfileMap'] as Map<String, dynamic>;
          b.likedMeProfileMap.clear();
          likedMeMap.forEach((key, value) {
            b.likedMeProfileMap[key] = _convertToProfileOperation(value);
          });
        }

        if (safeProfileData['matchesProfileMap'] != null) {
          final Map<String, dynamic> matchesMap =
              safeProfileData['matchesProfileMap'] as Map<String, dynamic>;
          b.matchesProfileMap.clear();
          matchesMap.forEach((key, value) {
            b.matchesProfileMap[key] = _convertToProfileOperation(value);
          });
        }

        if (safeProfileData['passesProfileMap'] != null) {
          final Map<String, dynamic> passesMap =
              safeProfileData['passesProfileMap'] as Map<String, dynamic>;
          b.passesProfileMap.clear();
          passesMap.forEach((key, value) {
            b.passesProfileMap[key] = _convertToProfileOperation(value);
          });
        }
      });

      return currentUserData;
    } catch (e) {
      logError(' Error checking profile completion: $e');
      return null;
    }
  }

  ProfileOperationEntity _convertToProfileOperation(dynamic data) {
    if (data is Map<String, dynamic>) {
      return ProfileOperationEntity().rebuild((b) {
        b.id = data['id'] ?? '';
        b.comment = data['comment'] ?? '';
        b.status = data['status'] ?? 0;
        b.type = data['type'] ?? 0;

        if (data['profileEntity'] != null &&
            data['profileEntity'] is Map<String, dynamic>) {
          final profileData = data['profileEntity'] as Map<String, dynamic>;
          final profileEntity =
              ProfileMapper.dbToEntity(profileData, profileData['id'] ?? '');
          b.profileEntity = profileEntity.toBuilder();
        }
      });
    } else {
      return ProfileOperationEntity();
    }
  }

  @override
  Future<void> markProfileComplete([String? userId]) async {
    try {
      String? targetUserId = userId;

      if (targetUserId == null) {
        final User? currentUser = _auth.currentUser;
        if (currentUser != null) {
          targetUserId = currentUser.uid;
        }
      }

      if (targetUserId == null) {
        logError('No user ID available for marking profile complete');
        return;
      }

      await _firestore
          .collection(ProjectConfig.usersProfileCollectionName)
          .doc(targetUserId)
          .update({
        'isProfileCompleted': true,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      logError(' Error marking profile as complete: $e');
    }
  }

  Future<ProfileSaveResult> updateProfile(
      String userId, Map<String, dynamic> updates) async {
    final existingProfile = await getProfile(userId);
    final updatesWithPreservedFields = Map<String, dynamic>.from(updates);
    
    if (existingProfile != null && 
        !updatesWithPreservedFields.containsKey('isAdmin')) {
      updatesWithPreservedFields['isAdmin'] = existingProfile['isAdmin'] ?? false;
    }
    
    return await saveProfile(
      userId: userId,
      profileData: updatesWithPreservedFields,
      isNewProfile: false,
    );
  }

  Future<Map<String, dynamic>?> getProfile(String userId) async {
    try {
      final DocumentSnapshot doc = await _firestore
          .collection(ProjectConfig.usersProfileCollectionName)
          .doc(userId)
          .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        final result = {
          'id': doc.id,
          ...Map<String, dynamic>.from(data),
        };
        return result;
      }
      return null;
    } catch (e) {
      logError(' Error fetching profile: $e');
      return null;
    }
  }

  @override
  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    try {
      final querySnapshot = await _firestore
          .collection(ProjectConfig.usersProfileCollectionName)
          .where('email', isEqualTo: email.toLowerCase())
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        if (doc.exists) {
          final data = doc.data();

          return {
            'id': doc.id,
            ...Map<String, dynamic>.from(data),
          };
        } else {
          return null;
        }
      } else {
        logError(' User not found for email: $email');
        return null;
      }
    } catch (e) {
      logError('Error fetching user by email: $e');
      return null;
    }
  }

  @override
  Future<AuthResult> login(String email, String password) async {
    final UserCredential userCredential =
        await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final User? user = userCredential.user;

    final String userName = email.trim().split('@')[0].trim();
    if (user == null) {
      logError('Login failed: User not found');
      return AuthResult(
          uid: '', email: '', displayName: '', isEmailVerified: false);
    }

    return AuthResult(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName ?? userName,
      isEmailVerified: user.emailVerified,
    );
  }

  // New method to sign in with an AuthCredential
  @override
  Future<AuthResult> signInWithGoogle(AuthCredential credential) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user == null) {
        logError('Credential sign-in failed: User not found');
        return AuthResult(
            uid: '', email: '', displayName: '', isEmailVerified: false);
      }

      Map<String, dynamic>? existingProfile = await getProfile(user.uid);

      if (existingProfile == null) {
        final String userName =
            (user.displayName ?? user.email?.split('@')[0] ?? '').trim();
        final isProfileCompleted =
            ProjectConfig.onboardingQuestionsOnSignupDisabled;

        final profileData = {
          'uid': user.uid,
          'email': (user.email ?? '').trim().toLowerCase(),
          'userName': userName,
          'displayName': (user.displayName ?? userName).trim(),
          'dynamicFields': {
            'images': [user.photoURL ?? ''],
          },
          'name': userName,
          'is_deleted': false,
          'isAdmin': false,
          'archived_at':
              ProjectConfig.defaultNewUserStatus() == kEntityStateActive
                  ? 0
                  : DateTime.now().millisecondsSinceEpoch,
          'isProfileCompleted': isProfileCompleted,
        };

        await saveProfile(
          userId: user.uid,
          isNewProfile: true,
          profileData: profileData,
        );
      } else {
        final updates = <String, dynamic>{};
        final dynamicFieldsUpdates = <String, dynamic>{};

        if (existingProfile.containsKey('isAdmin')) {
          logInfo(  'Preserving existing isAdmin field for user ${existingProfile['isAdmin']}');
          updates['isAdmin'] = existingProfile['isAdmin'];
        } else {
          updates['isAdmin'] = false; 
        }

        if (user.displayName != null && user.displayName!.isNotEmpty) {
          updates['displayName'] = user.displayName!.trim();
          updates['name'] = user.displayName!.trim();
          updates['userName'] = user.displayName!.trim();
          updates['email'] = (user.email ?? '').trim().toLowerCase();
        }
        if (user.photoURL != null && user.photoURL!.isNotEmpty) {
          dynamicFieldsUpdates['images'] = [user.photoURL];
        }

        final existingCreatedAt = existingProfile['created_at'];
        if (existingCreatedAt == null || existingCreatedAt == 0) {
          updates['created_at'] = DateTime.now().millisecondsSinceEpoch;
        }

        if (updates.isNotEmpty || dynamicFieldsUpdates.isNotEmpty) {
          if (dynamicFieldsUpdates.isNotEmpty) {
            final existingDynamicFields =
                existingProfile['dynamicFields'] as Map<String, dynamic>? ?? {};
            final mergedDynamicFields = {
              ...existingDynamicFields,
              ...dynamicFieldsUpdates
            };
            updates['dynamicFields'] = mergedDynamicFields;
          }

          await saveProfile(
            userId: user.uid,
            profileData: updates,
            isNewProfile: false,
          );
        }
      }

      final ProfileEntity? loggedInUserProfile = await currentUserProfile();

      return AuthResult(
        uid: user.uid,
        email: user.email ?? '',
        displayName: user.displayName ?? '',
        isEmailVerified: user.emailVerified,
        loggedInUserProfile: loggedInUserProfile,
      );
    } catch (error) {
      logError('Error in signInWithGoogle: $error');
      return AuthResult(
          uid: '', email: '', displayName: '', isEmailVerified: false);
    }
  }

  @override
  Future<AuthResult> signInWithEmailLink(String email, String emailLink) async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailLink(
        email: email,
        emailLink: emailLink,
      );

      final User? user = userCredential.user;
      if (user == null) {
        logError('No user returned from email link authentication');
        return AuthResult(
            uid: '', email: '', displayName: '', isEmailVerified: false);
      }

      final loggedInUserProfile = await currentUserProfile();

      return AuthResult(
        uid: user.uid,
        email: user.email ?? '',
        displayName: user.displayName ?? email.split('@')[0],
        isEmailVerified: user.emailVerified,
        loggedInUserProfile: loggedInUserProfile,
      );
    } catch (error) {
      logError('Error in signInWithEmailLink: $error');
      return AuthResult(
          uid: '', email: '', displayName: '', isEmailVerified: false);
    }
  }

  @override
  Future<void> sendSignInLinkToEmail(String email) async {
    try {
      final actionCodeSettings = ActionCodeSettings(
        url: _buildEmailLinkUrl(email),
        handleCodeInApp: true,
        androidPackageName: Config.PACKAGE_NAME,
        androidInstallApp: false,
        androidMinimumVersion: '1.0.0',
        iOSBundleId: Config.PACKAGE_NAME,
        dynamicLinkDomain: null,
      );

      await _auth.sendSignInLinkToEmail(
        email: email,
        actionCodeSettings: actionCodeSettings,
      );
    } catch (error) {
      logError('Error sending email link: $error');
      return;
    }
  }

  @override
  Future<void> logout() async {
    await _auth.signOut();
  }

  @override
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    final user = _auth.currentUser;

    if (user == null) {
      logError('No user is currently logged in.');
      return;
    }

    // Reauthenticate the user
    final cred = EmailAuthProvider.credential(
      email: user.email!,
      password: currentPassword,
    );

    try {
      await user.reauthenticateWithCredential(cred);
      // After reauthentication, update the password
      await user.updatePassword(newPassword);
    } catch (e) {
      logError('Password change failed: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteAccount() async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.delete();
    } else {
      logError('No user is currently logged in.');
    }
  }

  @override
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  @override
  bool isUserLoggedIn() {
    return _auth.currentUser != null;
  }

  @override
  Future<void> sendPhoneVerificationCode({
    required String phoneNumber,
    required Function(String verificationId) onCodeSent,
    required Function(FirebaseAuthException) onVerificationFailed,
    required Function(PhoneAuthCredential) onVerificationCompleted,
  }) async {
    try {
      if (isWeb()) {
        final confirmationResult =
            await _auth.signInWithPhoneNumber(phoneNumber);
        logInfo('Verification code sent to $phoneNumber (web)');
        onCodeSent(confirmationResult.verificationId);
      } else {
        await _auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: onVerificationCompleted,
          verificationFailed: (FirebaseAuthException e) {
            logError('Phone verification failed: ${e.code} - ${e.message}');
            onVerificationFailed(e);
          },
          codeSent: (String verificationId, int? resendToken) {
            logInfo('Verification code sent to $phoneNumber');
            onCodeSent(verificationId);
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            logInfo('Auto-retrieval timeout for $phoneNumber');
          },
          timeout: const Duration(seconds: 60),
        );
      }
    } catch (e) {
      logError(' Error in sendPhoneVerificationCode: $e');
      final authException = FirebaseAuthException(
        code: 'unknown-error',
        message: e.toString(),
      );
      onVerificationFailed(authException);
    }
  }

  @override
  Future<UserCredential> verifyPhoneCode({
    required String verificationId,
    required String smsCode,
  }) async {
    // Create a PhoneAuthCredential with the code
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    // Sign in (or link) the user with the credential
    return await _auth.currentUser!.linkWithCredential(credential);
  }

  @override
  Future<void> updatePhoneVerificationStatus({required bool isVerified}) async {
    try {
      final User? currentUser = _auth.currentUser;

      if (currentUser == null) {
        logError('User not authenticated');
        return;
      }

      await _firestore
          .collection(ProjectConfig.usersProfileCollectionName)
          .doc(currentUser.uid)
          .update({
        'verified_phone_number': isVerified,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      logError(' Error updating phone verification status: $e');
    }
  }

// Add this method to check if phone is verified
  Future<bool> isPhoneVerified() async {
    try {
      final User? currentUser = _auth.currentUser;

      if (currentUser == null) {
        logError('User not authenticated');
        return false;
      }

      final DocumentSnapshot doc = await _firestore
          .collection(ProjectConfig.usersProfileCollectionName)
          .doc(currentUser.uid)
          .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return data['isPhoneVerified'] ?? false;
      }

      return false;
    } catch (e) {
      logError(' Error checking phone verification: $e');
      return false;
    }
  }

  @override
  Future<bool> isEmailConfirmed() async {
    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser == null) return false;

      await currentUser.reload();

      final User? refreshedUser = _auth.currentUser;
      logInfo('is email verified for user => $refreshedUser');

      return refreshedUser?.emailVerified ?? false;
    } catch (e) {
      print('Error checking email verification: $e');
      return false;
    }
  }

  @override
  Future<bool> sendConfirmationEmail() async {
    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser == null) return false;

      if (ProjectConfig.emailConfirmationEnabled) {
        await currentUser.sendEmailVerification();
        return true;
      }

      return false;
    } catch (e) {
      logError('Error Send email for verification: $e');
      return false;
    }
  }

  @override
  Future<PhoneAuthResult> phoneLogin(String phoneNumber) async {
    final User? currentUser = _auth.currentUser;

    if (currentUser == null) {
      logError('Phone login failed: User not authenticated');
      return PhoneAuthResult(
          uid: '', displayName: '', email: '', isAdmin: false);
    }

    final profileData = await getProfile(currentUser.uid);

    if (profileData == null) {
      logError('Phone login failed: User profile not found');
      return PhoneAuthResult(
          uid: '', displayName: '', email: '', isAdmin: false);
    }

    if (profileData['phone'] != phoneNumber) {
      logError('Phone login failed: Phone number mismatch');
      return PhoneAuthResult(
          uid: '', displayName: '', email: '', isAdmin: false);
    }

    return PhoneAuthResult(
      uid: currentUser.uid,
      displayName: profileData['userName'] ?? '',
      email: profileData['email'] ?? '',
      isAdmin: profileData['isAdmin'] ?? false,
    );
  }

  @override
  Future<PhoneAuthResult> phoneSignUp({
    required String phoneNumber,
    required String verificationId,
    required String smsCode,
  }) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    final UserCredential userCredential =
        await _auth.signInWithCredential(credential);

    final User? user = userCredential.user;

    if (user == null) {
      logError('Phone signup failed: Unable to register user');
      return PhoneAuthResult(uid: '', displayName: '', email: '');
    }

    final existingProfile = await getProfile(user.uid);

    if (existingProfile == null) {
      final userName = 'No Name';

      final isProfileCompleted =
          ProjectConfig.onboardingQuestionsOnSignupDisabled;

      final profileData = await saveProfile(
        userId: user.uid,
        isNewProfile: true,
        profileData: {
          'uid': user.uid,
          'phone': phoneNumber,
          'userName': userName,
          'email': '',
          'dynamicFields': {},
          'name': userName,
          'isDeleted': false,
          'isProfileCompleted': isProfileCompleted,
          'verified_phone_number': true,
        },
      );

      return PhoneAuthResult(
        uid: user.uid,
        displayName: profileData.data['userName'] ?? userName,
        email: '',
      );
    } else {
      return PhoneAuthResult(
        uid: user.uid,
        displayName: existingProfile['userName'] ?? '',
        email: existingProfile['email'] ?? '',
        isProfileCompleted: existingProfile['isProfileCompleted'] ?? false,
      );
    }
  }
}

String _buildEmailLinkUrl(String email) {
  String? baseUrl;

  if (kIsWeb) {
    baseUrl = WebUtils.apiUrl;
  } else {
    baseUrl = kDebugMode ? 'localhost:3000' : 'https://domain.co';
  }

  final params = {
    'email': email,
    'authType': 'opw',
    'action': 'signin',
    'utm_source': 'email',
    'utm_medium': 'authentication',
  };

  final paramString = params.entries
      .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
      .join('&');

  return '$baseUrl?$paramString';
}
