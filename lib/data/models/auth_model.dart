import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:flutter_boilerplate/data/models/profile_model.dart';

part 'auth_model.g.dart';

abstract class AuthResult implements Built<AuthResult, AuthResultBuilder> {
  factory AuthResult({
    required String uid,
    required String email,
    String? displayName,
    bool isEmailVerified = false,
    ProfileEntity? loggedInUserProfile,
  }) {
    return _$AuthResult._(
      uid: uid,
      email: email,
      displayName: displayName ?? email.split('@')[0],
      isEmailVerified: isEmailVerified,
      loggedInUserProfile: loggedInUserProfile,
    );
  }

  AuthResult._();

  @override
  @memoized
  int get hashCode;

  static Serializer<AuthResult> get serializer => _$authResultSerializer;

  String get uid;
  String get email;
  String get displayName;
  bool get isEmailVerified;
  ProfileEntity? get loggedInUserProfile;
}

abstract class SignUpResult implements Built<SignUpResult, SignUpResultBuilder> {
  factory SignUpResult({
    required String uid,
    required String email,
    String? displayName,
  }) {
    return _$SignUpResult._(
      uid: uid,
      email: email,
      displayName: displayName ?? email.split('@')[0],
    );
  }

  SignUpResult._();

  @override
  @memoized
  int get hashCode;

  static Serializer<SignUpResult> get serializer => _$signUpResultSerializer;

  String get uid;
  String get email;
  String get displayName;
}

abstract class ProfileSaveResult implements Built<ProfileSaveResult, ProfileSaveResultBuilder> {
  factory ProfileSaveResult({
    required String id,
    required Map<String, dynamic> data,
  }) {
    return _$ProfileSaveResult._(
      id: id,
      data: data,
    );
  }

  ProfileSaveResult._();

  @override
  @memoized
  int get hashCode;

  static Serializer<ProfileSaveResult> get serializer => _$profileSaveResultSerializer;

  String get id;
  Map<String, dynamic> get data;
}

abstract class PhoneAuthResult implements Built<PhoneAuthResult, PhoneAuthResultBuilder> {
  factory PhoneAuthResult({
    required String uid,
    required String displayName,
    required String email,
    bool isAdmin = false,
    bool isProfileCompleted = false,
  }) {
    return _$PhoneAuthResult._(
      uid: uid,
      displayName: displayName,
      email: email,
      isAdmin: isAdmin,
      isProfileCompleted: isProfileCompleted,
    );
  }

  PhoneAuthResult._();

  @override
  @memoized
  int get hashCode;

  static Serializer<PhoneAuthResult> get serializer => _$phoneAuthResultSerializer;

  String get uid;
  String get displayName;
  String get email;
  bool get isAdmin;
  bool get isProfileCompleted;
}
