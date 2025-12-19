import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_boilerplate/data/models/profile_model.dart';
import 'package:flutter_boilerplate/data/models/auth_model.dart';

abstract class ClientBase {
  Future<SignUpResult> signUp(String email, String password);
  Future<AuthResult> login(String email, String password);
  Future<PhoneAuthResult> phoneLogin( String phoneNumber);
  Future<PhoneAuthResult> phoneSignUp( {
  required String phoneNumber,
  required String verificationId,  
  required String smsCode,        
});
  Future<AuthResult> signInWithGoogle(AuthCredential credential);
  Future<Map<String, dynamic>?> getUserByEmail(String email);
  Future<ProfileSaveResult> saveProfile({
    required String userId,
    required Map<String, dynamic> profileData,
    bool isNewProfile = false,
  });

  Future<void> changePassword(String currentPassword, String newPassword);
  Future<void> logout();
  Future<void> resetPassword(String email);
  Future<void> deleteAccount();
  Future<bool> isEmailConfirmed();
  Future<bool> sendConfirmationEmail();
  Future<void> markProfileComplete([String? userId]);
  Future<void> updatePhoneVerificationStatus({required bool isVerified});
  Future<UserCredential> verifyPhoneCode({
    required String verificationId,
    required String smsCode,
  });
  Future<void> sendPhoneVerificationCode({
    required String phoneNumber,
    required Function(String verificationId) onCodeSent,
    required Function(FirebaseAuthException) onVerificationFailed,
    required Function(PhoneAuthCredential) onVerificationCompleted,
  });
  Future<AuthResult> signInWithEmailLink(String email, String emailLink);
  Future<void> sendSignInLinkToEmail(String email);
  dynamic getCurrentUser();
  bool isUserLoggedIn();
  Future<ProfileEntity?> currentUserProfile([String? userId]);
}
