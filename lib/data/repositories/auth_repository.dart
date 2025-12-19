import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_boilerplate/data/mock/mock_login.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/data/repositories/clients/client_base.dart';
import 'package:flutter_boilerplate/data/repositories/clients/firebase_client.dart';
import 'package:flutter_boilerplate/project_config.dart';
import 'package:flutter_boilerplate/utils/serialization.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';

class AuthRepository {
  const AuthRepository();

  static final ClientBase client = FirebaseClient();

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<AuthLoginResult> signUp({
    required String email,
    required String password,
  }) async {
    final response = await client.signUp(email, password);
    final signedUpUserProfile = await client.currentUserProfile();

    var loginResponse = await getLoginResponse(response);

    return AuthLoginResult(
      loginResponse: loginResponse,
      userName: response.displayName,
      email: response.email,
      signedUpUserProfile: signedUpUserProfile,
      isEmailVerified: true,
    );
  }

  Future<dynamic> getLoginResponse(dynamic response) async {
    logInfo('login response received');
    final mockData = json.decode(kMockLogin) as Map<String, dynamic>;

    if (mockData['data'] != null && (mockData['data'] as List).isNotEmpty) {
      final userData = mockData['data'][0]['user'] as Map<String, dynamic>;
      if (response is AuthResult) {
        userData['firstName'] = response.displayName;
        userData['email'] = response.email;
        userData['id'] = response.uid;
      } else if (response is SignUpResult) {
        userData['firstName'] = response.displayName;
        userData['email'] = response.email;
        userData['id'] = response.uid;
      } else if (response is PhoneAuthResult) {
        userData['firstName'] = response.displayName;
        userData['email'] = response.email;
        userData['id'] = response.uid;
      }
    }

    final loginResponse = await compute<dynamic, dynamic>(
      SerializationUtils.deserializeWith,
      <dynamic>[LoginResponse.serializer, mockData],
    );
    return loginResponse;
  }

  Future<AuthLoginResult> login({
    required String email,
    required String password,
  }) async {
    final response = await client.login(email, password);
    final loggedInUserProfile = await client.currentUserProfile();

    Map<String, dynamic>? user;
    if (email.isNotEmpty) {
      user = await client.getUserByEmail(email);
    }

    if (user == null) {
      logWarning('user is null');
      return _createEmptyLoginResult();
    }

    if (user['is_deleted'] == true) {
      await logout();
      return _createEmptyLoginResult(isDeleted: true);
    }

    return await _processLoginResponse(
      user: user,
      loggedInUserProfile: loggedInUserProfile,
      isEmailVerified: response.isEmailVerified,
    );
  }

  Future<AuthLoginResult> emailLinkLogin({
    required String email,
    required String emailLink,
  }) async {
    final response = await client.signInWithEmailLink(email, emailLink);
    final loggedInUserProfile = await client.currentUserProfile();

    Map<String, dynamic>? user;
    if (email.isNotEmpty) {
      user = await client.getUserByEmail(email);
    }

    if (user == null) {
      logWarning('user is null for email link login');
      return _createEmptyLoginResult();
    }

    if (user['is_deleted'] == true) {
      await logout();
      return _createEmptyLoginResult(isDeleted: true);
    }

    return await _processLoginResponse(
      user: user,
      loggedInUserProfile: loggedInUserProfile,
      isEmailVerified: response.isEmailVerified,
    );
  }

  Future<AuthLoginResult> loginOrCreateFromEmailLink({
    required String email,
  }) async {
    try {
      Map<String, dynamic>? user;

      if (email.isNotEmpty) {
        user = await client.getUserByEmail(email);
      }

      if (user == null) {
        final sanitizedEmail = email.trim().toLowerCase();
        final userId = sanitizedEmail.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
        final userName = sanitizedEmail.split('@')[0].trim();

        user = {
          'id': userId,
          'email': sanitizedEmail,
          'userName': userName,
          'isAdmin': false,
          'is_deleted': false,
        };
        await client.saveProfile(
          userId: userId,
          profileData: {
            'email': sanitizedEmail,
            'userName': userName,
            'isAdmin': false,
            'is_deleted': false,
          },
          isNewProfile: true,
        );
      }

      if (user['is_deleted'] == true) {
        await logout();
        return _createEmptyLoginResult(isDeleted: true);
      }

      final loggedInUserProfile = ProfileEntity();
      return await _processLoginResponse(
        user: user,
        loggedInUserProfile: loggedInUserProfile,
        isEmailVerified: true,
      );
    } catch (error) {
      logError('Error in loginOrCreateFromEmailLink: $error');
      return _createEmptyLoginResult();
    }
  }

  Future<void> sendEmailLink({
    required String email,
  }) async {
    await client.sendSignInLinkToEmail(email);
  }

  Future<OAuthResult> oauthLogin({
    required String? idToken,
    required String? accessToken,
    required String url,
    required String secret,
    required String platform,
    required String provider,
    required String? email,
    required String? authCode,
  }) async {
    try {
      logEvent(
          ' Starting OAuth login with provider: $provider, idToken: ${idToken?.isNotEmpty} and access token:  ${accessToken?.isNotEmpty}');

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: accessToken,
        idToken: idToken?.isNotEmpty == true ? idToken : null,
      );

      final response = await client.signInWithGoogle(credential);
      final loggedInUserProfile = response.loggedInUserProfile;

      Map<String, dynamic>? user;
      if (email?.isNotEmpty == true) {
        user = await client.getUserByEmail(email!);
      }

      if (user == null && loggedInUserProfile != null) {
        user = {
          'id': loggedInUserProfile.id,
          'email': loggedInUserProfile.email,
          'userName': loggedInUserProfile.name,
          'isAdmin': loggedInUserProfile.isAdmin,
          'is_deleted': loggedInUserProfile.isDeleted,
        };
      } else if (user == null) {
        logWarning('user is null');
        return _createEmptyOAuthResult();
      }

      if (user['is_deleted'] == true) {
        return _createEmptyOAuthResult(isDeleted: true);
      }

      logEvent(' OAuth login successful for: ${response.displayName}');
      return await _processOAuthLoginResponse(
        user: user,
        response: response,
        loggedInUserProfile: loggedInUserProfile,
      );
    } catch (error) {
      logError('Error in oauthLogin: $error');
      return _createEmptyOAuthResult();
    }
  }

  Future<LoginResponse> refresh() async {
    final response = json.decode(kMockLogin);

    return await compute<dynamic, dynamic>(SerializationUtils.deserializeWith,
        <dynamic>[LoginResponse.serializer, response]);
  }

  Future<void> logout() async {
    return await client.logout();
  }

  Future<void> resetPassword({
    required String email,
  }) async {
    return await client.resetPassword(email);
  }

  Future<void> changePassword(
      {required String currentPassword, required String newPassword}) async {
    return await client.changePassword(currentPassword, newPassword);
  }

  Future<void> deleteAccount() async {
    return await client.deleteAccount();
  }

  Future<bool> isEmailConfirmed() async {
    return await client.isEmailConfirmed();
  }

  User? getCurrentUser() {
    return client.getCurrentUser();
  }

  Map<String, dynamic> userToMap(User? user) {
    if (user == null) return {};

    return {
      'uid': user.uid,
      'email': user.email,
      'displayName': user.displayName,
    };
  }

  bool isUserLoggedIn() {
    return client.isUserLoggedIn();
  }

  Future<ProfileEntity?> getCurrentUserProfile([String? userId]) async {
      return await client.currentUserProfile(userId);
  }


  Future<ProfileCheckResult> checkExistingProfileByEmail(String email) async {
    try {
      final existingUser =  await client.getUserByEmail(email);

      if (existingUser != null) {
        final userId = existingUser['id'] as String;
        final existingProfile = await client.currentUserProfile(userId);

        if (existingProfile != null) {
          return ProfileCheckResult(
            hasProfile: true,
            userData: existingUser,
            profile: existingProfile,
          );
        }
      }

      return ProfileCheckResult(
        hasProfile: false,
        userData: existingUser,
        profile: null,
      );
    } catch (error) {
      logError('Error checking existing profile: $error');
      return ProfileCheckResult(
        hasProfile: false,
        userData: null,
        profile: null,
        error: error.toString(),
      );
    }
  }

  Future<bool> checkPhoneVerificationStatus() async {
    User? user = client.getCurrentUser();
    if (user == null) {
      return false;
    }

    try {
      DocumentSnapshot doc = await _firestore
          .collection(ProjectConfig.usersProfileCollectionName)
          .doc(user.uid)
          .get();

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return data['verified_phone_number'] ?? false;
      }
      return false;
    } catch (e) {
      logError(' Error checking phone verification status: $e');
      return false;
    }
  }

  Future<bool> sendConfirmationEmail() async {
    return await client.sendConfirmationEmail();
  }

  Future<void> markProfileComplete([String? userId]) async {
    return await client.markProfileComplete(userId);
  }

  Future<void> sendPhoneVerificationCode({
    required String phoneNumber,
    required Function(String verificationId) onCodeSent,
    required Function(FirebaseAuthException) onVerificationFailed,
    required Function(PhoneAuthCredential) onVerificationCompleted,
  }) async {
    await client.sendPhoneVerificationCode(
      phoneNumber: phoneNumber,
      onCodeSent: onCodeSent,
      onVerificationFailed: onVerificationFailed,
      onVerificationCompleted: onVerificationCompleted,
    );
  }

  Future<UserCredential> verifyPhoneCode({
    required String verificationId,
    required String smsCode,
  }) async {
    return await client.verifyPhoneCode(
        verificationId: verificationId, smsCode: smsCode);
  }

  Future<void> updatePhoneVerificationStatus({required bool isVerified}) async {
    await client.updatePhoneVerificationStatus(isVerified: isVerified);
  }

  Future<String> verifyPhoneNumber(String phoneNumber) async {
    final completer = Completer<String>();

    await client.sendPhoneVerificationCode(
      phoneNumber: phoneNumber,
      onCodeSent: (verificationId) => completer.complete(verificationId),
      onVerificationFailed: (error) => completer.completeError(error),
      onVerificationCompleted: (credential) {},
    );

    return completer.future;
  }

  Future<PhoneLoginResult> phoneLogin({
    required String phoneNumber,
    required String url,
    required String secret,
  }) async {
    try {
      final response = await client.phoneLogin(phoneNumber);
      final loggedInUserProfile = await client.currentUserProfile();

      return PhoneLoginResult(
        loginResponse: await getLoginResponse(response),
        userName: response.displayName,
        email: response.email,
        signedUpUserProfile: loggedInUserProfile ?? ProfileEntity(),
        isAdmin: response.isAdmin,
      );
    } catch (error) {
      logError('Error in phoneLogin: $error');
      return _createEmptyPhoneLoginResult();
    }
  }

  Future<PhoneLoginResult> phoneSignUp({
    required String phoneNumber,
    required String verificationId,
    required String smsCode,
  }) async {
    final response = await client.phoneSignUp(
      phoneNumber: phoneNumber,
      verificationId: verificationId,
      smsCode: smsCode,
    );
    final signedUpUserProfile = await client.currentUserProfile();

    final mockData = json.decode(kMockLogin) as Map<String, dynamic>;

    if (mockData['data'] != null && (mockData['data'] as List).isNotEmpty) {
      final userData = mockData['data'][0]['user'] as Map<String, dynamic>;
      userData['firstName'] = response.displayName;
      userData['email'] = response.email;
      userData['id'] = response.uid;
    }

    final loginResponse = await compute<dynamic, dynamic>(
      SerializationUtils.deserializeWith,
      <dynamic>[LoginResponse.serializer, mockData],
    );

    final isNewUser = !response.isProfileCompleted;

    return PhoneLoginResult(
      loginResponse: loginResponse,
      userName: response.displayName,
      email: response.email,
      signedUpUserProfile: signedUpUserProfile ?? ProfileEntity(),
      isNewUser: isNewUser,
    );
  }

  AuthLoginResult _createEmptyLoginResult({bool isDeleted = false}) {
    return AuthLoginResult(
      loginResponse: LoginResponse(),
      userName: '',
      email: '',
      signedUpUserProfile: ProfileEntity(),
      isAdmin: false,
      isDeleted: isDeleted,
    );
  }

  OAuthResult _createEmptyOAuthResult({bool isDeleted = false}) {
    return OAuthResult(
      loginResponse: LoginResponse(),
      userName: '',
      email: '',
      loggedInUserProfile: ProfileEntity(),
      isAdmin: false,
      isEmailVerified: false,
    );
  }

  PhoneLoginResult _createEmptyPhoneLoginResult() {
    return PhoneLoginResult(
      loginResponse: LoginResponse(),
      userName: '',
      email: '',
      signedUpUserProfile: ProfileEntity(),
      isAdmin: false,
      isNewUser: false,
    );
  }

  void _updateMockDataWithUser(
      Map<String, dynamic> mockData, Map<String, dynamic> user) {
    if (mockData['data'] != null && (mockData['data'] as List).isNotEmpty) {
      final userData = mockData['data'][0]['user'] as Map<String, dynamic>;
      userData['firstName'] = user['userName'];
      userData['email'] = user['email'];
      userData['id'] = user['id'];
    }
  }

  Future<AuthLoginResult> _processLoginResponse({
    required Map<String, dynamic> user,
    required ProfileEntity? loggedInUserProfile,
    bool isEmailVerified = true,
  }) async {
    final mockData = json.decode(kMockLogin) as Map<String, dynamic>;
    _updateMockDataWithUser(mockData, user);

    final loginResponse = await compute<dynamic, dynamic>(
      SerializationUtils.deserializeWith,
      <dynamic>[LoginResponse.serializer, mockData],
    ) as LoginResponse;

    return AuthLoginResult(
      loginResponse: loginResponse,
      userName: user['userName'] ?? '',
      email: user['email'] ?? '',
      signedUpUserProfile: loggedInUserProfile ?? ProfileEntity(),
      isAdmin: user['isAdmin'] ?? false,
      isEmailVerified: isEmailVerified,
    );
  }

  Future<OAuthResult> _processOAuthLoginResponse({
    required Map<String, dynamic> user,
    required AuthResult response,
    required ProfileEntity? loggedInUserProfile,
  }) async {
    final mockData = json.decode(kMockLogin) as Map<String, dynamic>;

    if (mockData['data'] != null && (mockData['data'] as List).isNotEmpty) {
      final userData = mockData['data'][0]['user'] as Map<String, dynamic>;
      userData['firstName'] = response.displayName;
      userData['email'] = response.email;
      userData['oauth_provider_id'] = 'guid';
      
      userData['id'] = user['id'];
      
      final companyData = mockData['data'][0]['company'] as Map<String, dynamic>;
      companyData['id'] = user['id'];
      
      final tokenData = mockData['data'][0]['token'] as Map<String, dynamic>;
      tokenData['user_id'] = user['id'];
    }

    final loginResponse = await compute<dynamic, dynamic>(
      SerializationUtils.deserializeWith,
      <dynamic>[LoginResponse.serializer, mockData],
    ) as LoginResponse;

    return OAuthResult(
      loginResponse: loginResponse,
      userName: response.displayName,
      email: response.email,
      loggedInUserProfile: loggedInUserProfile ?? ProfileEntity(),
      isAdmin: user['isAdmin'] ?? false,
      isEmailVerified: true,
    );
  }
}
