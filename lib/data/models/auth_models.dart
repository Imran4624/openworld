import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:flutter_boilerplate/data/models/models.dart';

part 'auth_models.g.dart';

abstract class AuthLoginResult implements Built<AuthLoginResult, AuthLoginResultBuilder> {
  factory AuthLoginResult({
    required LoginResponse loginResponse,
    String? userName,
    String? email,
    ProfileEntity? signedUpUserProfile,
    bool? isEmailVerified,
    bool? isAdmin,
    bool? isDeleted,
    bool? isNewUser,
  }) {
    return _$AuthLoginResult._(
      loginResponse: loginResponse,
      userName: userName ?? '',
      email: email ?? '',
      signedUpUserProfile: signedUpUserProfile ?? ProfileEntity(),
      isEmailVerified: isEmailVerified ?? false,
      isAdmin: isAdmin ?? false,
      isDeleted: isDeleted ?? false,
      isNewUser: isNewUser ?? false,
    );
  }

  AuthLoginResult._();

  LoginResponse get loginResponse;
  String get userName;
  String get email;
  ProfileEntity get signedUpUserProfile;
  bool get isEmailVerified;
  bool get isAdmin;
  bool get isDeleted;
  bool get isNewUser;

  static Serializer<AuthLoginResult> get serializer => _$authLoginResultSerializer;
}

abstract class ProfileCheckResult implements Built<ProfileCheckResult, ProfileCheckResultBuilder> {
  factory ProfileCheckResult({
    bool? hasProfile,
    Map<String, dynamic>? userData,
    ProfileEntity? profile,
    String? error,
  }) {
    return _$ProfileCheckResult._(
      hasProfile: hasProfile ?? false,
      userData: userData,
      profile: profile,
      error: error,
    );
  }

  ProfileCheckResult._();

  bool get hasProfile;
  Map<String, dynamic>? get userData;
  ProfileEntity? get profile;
  String? get error;

  static Serializer<ProfileCheckResult> get serializer => _$profileCheckResultSerializer;
}

abstract class PhoneLoginResult implements Built<PhoneLoginResult, PhoneLoginResultBuilder> {
  factory PhoneLoginResult({
    required LoginResponse loginResponse,
    String? userName,
    String? email,
    ProfileEntity? signedUpUserProfile,
    bool? isNewUser,
    bool? isAdmin,
  }) {
    return _$PhoneLoginResult._(
      loginResponse: loginResponse,
      userName: userName ?? '',
      email: email ?? '',
      signedUpUserProfile: signedUpUserProfile ?? ProfileEntity(),
      isNewUser: isNewUser ?? false,
      isAdmin: isAdmin ?? false,
    );
  }

  PhoneLoginResult._();

  LoginResponse get loginResponse;
  String get userName;
  String get email;
  ProfileEntity get signedUpUserProfile;
  bool get isNewUser;
  bool get isAdmin;

  static Serializer<PhoneLoginResult> get serializer => _$phoneLoginResultSerializer;
}

abstract class OAuthResult implements Built<OAuthResult, OAuthResultBuilder> {
  factory OAuthResult({
    required LoginResponse loginResponse,
    String? userName,
    String? email,
    ProfileEntity? loggedInUserProfile,
    bool? isAdmin,
    bool? isEmailVerified,
  }) {
    return _$OAuthResult._(
      loginResponse: loginResponse,
      userName: userName ?? '',
      email: email ?? '',
      loggedInUserProfile: loggedInUserProfile ?? ProfileEntity(),
      isAdmin: isAdmin ?? false,
      isEmailVerified: isEmailVerified ?? true,
    );
  }

  OAuthResult._();

  LoginResponse get loginResponse;
  String get userName;
  String get email;
  ProfileEntity get loggedInUserProfile;
  bool get isAdmin;
  bool get isEmailVerified;

  static Serializer<OAuthResult> get serializer => _$oAuthResultSerializer;
}
