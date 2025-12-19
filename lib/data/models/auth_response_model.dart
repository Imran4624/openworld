import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:flutter_boilerplate/data/models/models.dart';

part 'auth_response_model.g.dart';

abstract class OAuthLoginResponse implements Built<OAuthLoginResponse, OAuthLoginResponseBuilder> {
  factory OAuthLoginResponse({
    required LoginResponse loginResponse,
    required String userName,
    required String email,
    required ProfileEntity loggedInUserProfile,
    required bool isAdmin,
    required bool isEmailVerified,
    bool isDeleted = false,
  }) {
    return _$OAuthLoginResponse._(
      loginResponse: loginResponse,
      userName: userName,
      email: email,
      loggedInUserProfile: loggedInUserProfile,
      isAdmin: isAdmin,
      isEmailVerified: isEmailVerified,
      isDeleted: isDeleted,
    );
  }

  OAuthLoginResponse._();

  @override
  @memoized
  int get hashCode;

  static Serializer<OAuthLoginResponse> get serializer => _$oAuthLoginResponseSerializer;

  LoginResponse get loginResponse;
  String get userName;
  String get email;
  ProfileEntity get loggedInUserProfile;
  bool get isAdmin;
  bool get isEmailVerified;
  bool get isDeleted;
}

abstract class SignupResponse implements Built<SignupResponse, SignupResponseBuilder> {
  factory SignupResponse({
    required LoginResponse loginResponse,
    required String userName,
    required String email,
    required ProfileEntity signedUpUserProfile,
    required bool isEmailVerified,
    bool isNewUser = true,
  }) {
    return _$SignupResponse._(
      loginResponse: loginResponse,
      userName: userName,
      email: email,
      signedUpUserProfile: signedUpUserProfile,
      isEmailVerified: isEmailVerified,
      isNewUser: isNewUser,
    );
  }

  SignupResponse._();

  @override
  @memoized
  int get hashCode;

  static Serializer<SignupResponse> get serializer => _$signupResponseSerializer;

  LoginResponse get loginResponse;
  String get userName;
  String get email;
  ProfileEntity get signedUpUserProfile;
  bool get isEmailVerified;
  bool get isNewUser;
}

abstract class PhoneAuthResponse implements Built<PhoneAuthResponse, PhoneAuthResponseBuilder> {
  factory PhoneAuthResponse({
    required LoginResponse loginResponse,
    required String userName,
    required String email,
    required ProfileEntity loggedInUserProfile,
    required bool isAdmin,
    bool isNewUser = false,
  }) {
    return _$PhoneAuthResponse._(
      loginResponse: loginResponse,
      userName: userName,
      email: email,
      loggedInUserProfile: loggedInUserProfile,
      isAdmin: isAdmin,
      isNewUser: isNewUser,
    );
  }

  PhoneAuthResponse._();

  @override
  @memoized
  int get hashCode;

  static Serializer<PhoneAuthResponse> get serializer => _$phoneAuthResponseSerializer;

  LoginResponse get loginResponse;
  String get userName;
  String get email;
  ProfileEntity get loggedInUserProfile;
  bool get isAdmin;
  bool get isNewUser;
}

abstract class ExistingProfileCheckResponse implements Built<ExistingProfileCheckResponse, ExistingProfileCheckResponseBuilder> {
  factory ExistingProfileCheckResponse({
    required bool hasProfile,
    Map<String, dynamic>? user,
    ProfileEntity? profile,
    String? error,
  }) {
    return _$ExistingProfileCheckResponse._(
      hasProfile: hasProfile,
      user: user,
      profile: profile,
      error: error,
    );
  }

  ExistingProfileCheckResponse._();

  @override
  @memoized
  int get hashCode;

  static Serializer<ExistingProfileCheckResponse> get serializer => _$existingProfileCheckResponseSerializer;

  bool get hasProfile;
  Map<String, dynamic>? get user;
  ProfileEntity? get profile;
  String? get error;
}

abstract class EmptyLoginResponse implements Built<EmptyLoginResponse, EmptyLoginResponseBuilder> {
  factory EmptyLoginResponse({
    bool isDeleted = false,
  }) {
    return _$EmptyLoginResponse._(
      loginResponse: LoginResponse(),
      userName: '',
      email: '',
      loggedInUserProfile: ProfileEntity(),
      isAdmin: false,
      isDeleted: isDeleted,
    );
  }

  EmptyLoginResponse._();

  @override
  @memoized
  int get hashCode;

  static Serializer<EmptyLoginResponse> get serializer => _$emptyLoginResponseSerializer;

  LoginResponse get loginResponse;
  String get userName;
  String get email;
  ProfileEntity get loggedInUserProfile;
  bool get isAdmin;
  bool get isDeleted;
}
