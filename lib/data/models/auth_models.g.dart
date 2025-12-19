// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_models.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<AuthLoginResult> _$authLoginResultSerializer =
    new _$AuthLoginResultSerializer();
Serializer<ProfileCheckResult> _$profileCheckResultSerializer =
    new _$ProfileCheckResultSerializer();
Serializer<PhoneLoginResult> _$phoneLoginResultSerializer =
    new _$PhoneLoginResultSerializer();
Serializer<OAuthResult> _$oAuthResultSerializer = new _$OAuthResultSerializer();

class _$AuthLoginResultSerializer
    implements StructuredSerializer<AuthLoginResult> {
  @override
  final Iterable<Type> types = const [AuthLoginResult, _$AuthLoginResult];
  @override
  final String wireName = 'AuthLoginResult';

  @override
  Iterable<Object?> serialize(Serializers serializers, AuthLoginResult object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'loginResponse',
      serializers.serialize(object.loginResponse,
          specifiedType: const FullType(LoginResponse)),
      'userName',
      serializers.serialize(object.userName,
          specifiedType: const FullType(String)),
      'email',
      serializers.serialize(object.email,
          specifiedType: const FullType(String)),
      'signedUpUserProfile',
      serializers.serialize(object.signedUpUserProfile,
          specifiedType: const FullType(ProfileEntity)),
      'isEmailVerified',
      serializers.serialize(object.isEmailVerified,
          specifiedType: const FullType(bool)),
      'isAdmin',
      serializers.serialize(object.isAdmin,
          specifiedType: const FullType(bool)),
      'isDeleted',
      serializers.serialize(object.isDeleted,
          specifiedType: const FullType(bool)),
      'isNewUser',
      serializers.serialize(object.isNewUser,
          specifiedType: const FullType(bool)),
    ];

    return result;
  }

  @override
  AuthLoginResult deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new AuthLoginResultBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'loginResponse':
          result.loginResponse.replace(serializers.deserialize(value,
              specifiedType: const FullType(LoginResponse))! as LoginResponse);
          break;
        case 'userName':
          result.userName = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'email':
          result.email = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'signedUpUserProfile':
          result.signedUpUserProfile.replace(serializers.deserialize(value,
              specifiedType: const FullType(ProfileEntity))! as ProfileEntity);
          break;
        case 'isEmailVerified':
          result.isEmailVerified = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
        case 'isAdmin':
          result.isAdmin = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
        case 'isDeleted':
          result.isDeleted = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
        case 'isNewUser':
          result.isNewUser = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
      }
    }

    return result.build();
  }
}

class _$ProfileCheckResultSerializer
    implements StructuredSerializer<ProfileCheckResult> {
  @override
  final Iterable<Type> types = const [ProfileCheckResult, _$ProfileCheckResult];
  @override
  final String wireName = 'ProfileCheckResult';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, ProfileCheckResult object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'hasProfile',
      serializers.serialize(object.hasProfile,
          specifiedType: const FullType(bool)),
    ];
    Object? value;
    value = object.userData;
    if (value != null) {
      result
        ..add('userData')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(
                Map, const [const FullType(String), const FullType(dynamic)])));
    }
    value = object.profile;
    if (value != null) {
      result
        ..add('profile')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(ProfileEntity)));
    }
    value = object.error;
    if (value != null) {
      result
        ..add('error')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  ProfileCheckResult deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ProfileCheckResultBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'hasProfile':
          result.hasProfile = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
        case 'userData':
          result.userData = serializers.deserialize(value,
              specifiedType: const FullType(Map, const [
                const FullType(String),
                const FullType(dynamic)
              ])) as Map<String, dynamic>?;
          break;
        case 'profile':
          result.profile.replace(serializers.deserialize(value,
              specifiedType: const FullType(ProfileEntity))! as ProfileEntity);
          break;
        case 'error':
          result.error = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
      }
    }

    return result.build();
  }
}

class _$PhoneLoginResultSerializer
    implements StructuredSerializer<PhoneLoginResult> {
  @override
  final Iterable<Type> types = const [PhoneLoginResult, _$PhoneLoginResult];
  @override
  final String wireName = 'PhoneLoginResult';

  @override
  Iterable<Object?> serialize(Serializers serializers, PhoneLoginResult object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'loginResponse',
      serializers.serialize(object.loginResponse,
          specifiedType: const FullType(LoginResponse)),
      'userName',
      serializers.serialize(object.userName,
          specifiedType: const FullType(String)),
      'email',
      serializers.serialize(object.email,
          specifiedType: const FullType(String)),
      'signedUpUserProfile',
      serializers.serialize(object.signedUpUserProfile,
          specifiedType: const FullType(ProfileEntity)),
      'isNewUser',
      serializers.serialize(object.isNewUser,
          specifiedType: const FullType(bool)),
      'isAdmin',
      serializers.serialize(object.isAdmin,
          specifiedType: const FullType(bool)),
    ];

    return result;
  }

  @override
  PhoneLoginResult deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new PhoneLoginResultBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'loginResponse':
          result.loginResponse.replace(serializers.deserialize(value,
              specifiedType: const FullType(LoginResponse))! as LoginResponse);
          break;
        case 'userName':
          result.userName = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'email':
          result.email = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'signedUpUserProfile':
          result.signedUpUserProfile.replace(serializers.deserialize(value,
              specifiedType: const FullType(ProfileEntity))! as ProfileEntity);
          break;
        case 'isNewUser':
          result.isNewUser = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
        case 'isAdmin':
          result.isAdmin = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
      }
    }

    return result.build();
  }
}

class _$OAuthResultSerializer implements StructuredSerializer<OAuthResult> {
  @override
  final Iterable<Type> types = const [OAuthResult, _$OAuthResult];
  @override
  final String wireName = 'OAuthResult';

  @override
  Iterable<Object?> serialize(Serializers serializers, OAuthResult object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'loginResponse',
      serializers.serialize(object.loginResponse,
          specifiedType: const FullType(LoginResponse)),
      'userName',
      serializers.serialize(object.userName,
          specifiedType: const FullType(String)),
      'email',
      serializers.serialize(object.email,
          specifiedType: const FullType(String)),
      'loggedInUserProfile',
      serializers.serialize(object.loggedInUserProfile,
          specifiedType: const FullType(ProfileEntity)),
      'isAdmin',
      serializers.serialize(object.isAdmin,
          specifiedType: const FullType(bool)),
      'isEmailVerified',
      serializers.serialize(object.isEmailVerified,
          specifiedType: const FullType(bool)),
    ];

    return result;
  }

  @override
  OAuthResult deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new OAuthResultBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'loginResponse':
          result.loginResponse.replace(serializers.deserialize(value,
              specifiedType: const FullType(LoginResponse))! as LoginResponse);
          break;
        case 'userName':
          result.userName = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'email':
          result.email = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'loggedInUserProfile':
          result.loggedInUserProfile.replace(serializers.deserialize(value,
              specifiedType: const FullType(ProfileEntity))! as ProfileEntity);
          break;
        case 'isAdmin':
          result.isAdmin = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
        case 'isEmailVerified':
          result.isEmailVerified = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
      }
    }

    return result.build();
  }
}

class _$AuthLoginResult extends AuthLoginResult {
  @override
  final LoginResponse loginResponse;
  @override
  final String userName;
  @override
  final String email;
  @override
  final ProfileEntity signedUpUserProfile;
  @override
  final bool isEmailVerified;
  @override
  final bool isAdmin;
  @override
  final bool isDeleted;
  @override
  final bool isNewUser;

  factory _$AuthLoginResult([void Function(AuthLoginResultBuilder)? updates]) =>
      (new AuthLoginResultBuilder()..update(updates))._build();

  _$AuthLoginResult._(
      {required this.loginResponse,
      required this.userName,
      required this.email,
      required this.signedUpUserProfile,
      required this.isEmailVerified,
      required this.isAdmin,
      required this.isDeleted,
      required this.isNewUser})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        loginResponse, r'AuthLoginResult', 'loginResponse');
    BuiltValueNullFieldError.checkNotNull(
        userName, r'AuthLoginResult', 'userName');
    BuiltValueNullFieldError.checkNotNull(email, r'AuthLoginResult', 'email');
    BuiltValueNullFieldError.checkNotNull(
        signedUpUserProfile, r'AuthLoginResult', 'signedUpUserProfile');
    BuiltValueNullFieldError.checkNotNull(
        isEmailVerified, r'AuthLoginResult', 'isEmailVerified');
    BuiltValueNullFieldError.checkNotNull(
        isAdmin, r'AuthLoginResult', 'isAdmin');
    BuiltValueNullFieldError.checkNotNull(
        isDeleted, r'AuthLoginResult', 'isDeleted');
    BuiltValueNullFieldError.checkNotNull(
        isNewUser, r'AuthLoginResult', 'isNewUser');
  }

  @override
  AuthLoginResult rebuild(void Function(AuthLoginResultBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AuthLoginResultBuilder toBuilder() =>
      new AuthLoginResultBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AuthLoginResult &&
        loginResponse == other.loginResponse &&
        userName == other.userName &&
        email == other.email &&
        signedUpUserProfile == other.signedUpUserProfile &&
        isEmailVerified == other.isEmailVerified &&
        isAdmin == other.isAdmin &&
        isDeleted == other.isDeleted &&
        isNewUser == other.isNewUser;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, loginResponse.hashCode);
    _$hash = $jc(_$hash, userName.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, signedUpUserProfile.hashCode);
    _$hash = $jc(_$hash, isEmailVerified.hashCode);
    _$hash = $jc(_$hash, isAdmin.hashCode);
    _$hash = $jc(_$hash, isDeleted.hashCode);
    _$hash = $jc(_$hash, isNewUser.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AuthLoginResult')
          ..add('loginResponse', loginResponse)
          ..add('userName', userName)
          ..add('email', email)
          ..add('signedUpUserProfile', signedUpUserProfile)
          ..add('isEmailVerified', isEmailVerified)
          ..add('isAdmin', isAdmin)
          ..add('isDeleted', isDeleted)
          ..add('isNewUser', isNewUser))
        .toString();
  }
}

class AuthLoginResultBuilder
    implements Builder<AuthLoginResult, AuthLoginResultBuilder> {
  _$AuthLoginResult? _$v;

  LoginResponseBuilder? _loginResponse;
  LoginResponseBuilder get loginResponse =>
      _$this._loginResponse ??= new LoginResponseBuilder();
  set loginResponse(LoginResponseBuilder? loginResponse) =>
      _$this._loginResponse = loginResponse;

  String? _userName;
  String? get userName => _$this._userName;
  set userName(String? userName) => _$this._userName = userName;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  ProfileEntityBuilder? _signedUpUserProfile;
  ProfileEntityBuilder get signedUpUserProfile =>
      _$this._signedUpUserProfile ??= new ProfileEntityBuilder();
  set signedUpUserProfile(ProfileEntityBuilder? signedUpUserProfile) =>
      _$this._signedUpUserProfile = signedUpUserProfile;

  bool? _isEmailVerified;
  bool? get isEmailVerified => _$this._isEmailVerified;
  set isEmailVerified(bool? isEmailVerified) =>
      _$this._isEmailVerified = isEmailVerified;

  bool? _isAdmin;
  bool? get isAdmin => _$this._isAdmin;
  set isAdmin(bool? isAdmin) => _$this._isAdmin = isAdmin;

  bool? _isDeleted;
  bool? get isDeleted => _$this._isDeleted;
  set isDeleted(bool? isDeleted) => _$this._isDeleted = isDeleted;

  bool? _isNewUser;
  bool? get isNewUser => _$this._isNewUser;
  set isNewUser(bool? isNewUser) => _$this._isNewUser = isNewUser;

  AuthLoginResultBuilder();

  AuthLoginResultBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _loginResponse = $v.loginResponse.toBuilder();
      _userName = $v.userName;
      _email = $v.email;
      _signedUpUserProfile = $v.signedUpUserProfile.toBuilder();
      _isEmailVerified = $v.isEmailVerified;
      _isAdmin = $v.isAdmin;
      _isDeleted = $v.isDeleted;
      _isNewUser = $v.isNewUser;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AuthLoginResult other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$AuthLoginResult;
  }

  @override
  void update(void Function(AuthLoginResultBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AuthLoginResult build() => _build();

  _$AuthLoginResult _build() {
    _$AuthLoginResult _$result;
    try {
      _$result = _$v ??
          new _$AuthLoginResult._(
              loginResponse: loginResponse.build(),
              userName: BuiltValueNullFieldError.checkNotNull(
                  userName, r'AuthLoginResult', 'userName'),
              email: BuiltValueNullFieldError.checkNotNull(
                  email, r'AuthLoginResult', 'email'),
              signedUpUserProfile: signedUpUserProfile.build(),
              isEmailVerified: BuiltValueNullFieldError.checkNotNull(
                  isEmailVerified, r'AuthLoginResult', 'isEmailVerified'),
              isAdmin: BuiltValueNullFieldError.checkNotNull(
                  isAdmin, r'AuthLoginResult', 'isAdmin'),
              isDeleted: BuiltValueNullFieldError.checkNotNull(
                  isDeleted, r'AuthLoginResult', 'isDeleted'),
              isNewUser: BuiltValueNullFieldError.checkNotNull(
                  isNewUser, r'AuthLoginResult', 'isNewUser'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'loginResponse';
        loginResponse.build();

        _$failedField = 'signedUpUserProfile';
        signedUpUserProfile.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'AuthLoginResult', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$ProfileCheckResult extends ProfileCheckResult {
  @override
  final bool hasProfile;
  @override
  final Map<String, dynamic>? userData;
  @override
  final ProfileEntity? profile;
  @override
  final String? error;

  factory _$ProfileCheckResult(
          [void Function(ProfileCheckResultBuilder)? updates]) =>
      (new ProfileCheckResultBuilder()..update(updates))._build();

  _$ProfileCheckResult._(
      {required this.hasProfile, this.userData, this.profile, this.error})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        hasProfile, r'ProfileCheckResult', 'hasProfile');
  }

  @override
  ProfileCheckResult rebuild(
          void Function(ProfileCheckResultBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProfileCheckResultBuilder toBuilder() =>
      new ProfileCheckResultBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProfileCheckResult &&
        hasProfile == other.hasProfile &&
        userData == other.userData &&
        profile == other.profile &&
        error == other.error;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, hasProfile.hashCode);
    _$hash = $jc(_$hash, userData.hashCode);
    _$hash = $jc(_$hash, profile.hashCode);
    _$hash = $jc(_$hash, error.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProfileCheckResult')
          ..add('hasProfile', hasProfile)
          ..add('userData', userData)
          ..add('profile', profile)
          ..add('error', error))
        .toString();
  }
}

class ProfileCheckResultBuilder
    implements Builder<ProfileCheckResult, ProfileCheckResultBuilder> {
  _$ProfileCheckResult? _$v;

  bool? _hasProfile;
  bool? get hasProfile => _$this._hasProfile;
  set hasProfile(bool? hasProfile) => _$this._hasProfile = hasProfile;

  Map<String, dynamic>? _userData;
  Map<String, dynamic>? get userData => _$this._userData;
  set userData(Map<String, dynamic>? userData) => _$this._userData = userData;

  ProfileEntityBuilder? _profile;
  ProfileEntityBuilder get profile =>
      _$this._profile ??= new ProfileEntityBuilder();
  set profile(ProfileEntityBuilder? profile) => _$this._profile = profile;

  String? _error;
  String? get error => _$this._error;
  set error(String? error) => _$this._error = error;

  ProfileCheckResultBuilder();

  ProfileCheckResultBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _hasProfile = $v.hasProfile;
      _userData = $v.userData;
      _profile = $v.profile?.toBuilder();
      _error = $v.error;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProfileCheckResult other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ProfileCheckResult;
  }

  @override
  void update(void Function(ProfileCheckResultBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProfileCheckResult build() => _build();

  _$ProfileCheckResult _build() {
    _$ProfileCheckResult _$result;
    try {
      _$result = _$v ??
          new _$ProfileCheckResult._(
              hasProfile: BuiltValueNullFieldError.checkNotNull(
                  hasProfile, r'ProfileCheckResult', 'hasProfile'),
              userData: userData,
              profile: _profile?.build(),
              error: error);
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'profile';
        _profile?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'ProfileCheckResult', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$PhoneLoginResult extends PhoneLoginResult {
  @override
  final LoginResponse loginResponse;
  @override
  final String userName;
  @override
  final String email;
  @override
  final ProfileEntity signedUpUserProfile;
  @override
  final bool isNewUser;
  @override
  final bool isAdmin;

  factory _$PhoneLoginResult(
          [void Function(PhoneLoginResultBuilder)? updates]) =>
      (new PhoneLoginResultBuilder()..update(updates))._build();

  _$PhoneLoginResult._(
      {required this.loginResponse,
      required this.userName,
      required this.email,
      required this.signedUpUserProfile,
      required this.isNewUser,
      required this.isAdmin})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        loginResponse, r'PhoneLoginResult', 'loginResponse');
    BuiltValueNullFieldError.checkNotNull(
        userName, r'PhoneLoginResult', 'userName');
    BuiltValueNullFieldError.checkNotNull(email, r'PhoneLoginResult', 'email');
    BuiltValueNullFieldError.checkNotNull(
        signedUpUserProfile, r'PhoneLoginResult', 'signedUpUserProfile');
    BuiltValueNullFieldError.checkNotNull(
        isNewUser, r'PhoneLoginResult', 'isNewUser');
    BuiltValueNullFieldError.checkNotNull(
        isAdmin, r'PhoneLoginResult', 'isAdmin');
  }

  @override
  PhoneLoginResult rebuild(void Function(PhoneLoginResultBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PhoneLoginResultBuilder toBuilder() =>
      new PhoneLoginResultBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PhoneLoginResult &&
        loginResponse == other.loginResponse &&
        userName == other.userName &&
        email == other.email &&
        signedUpUserProfile == other.signedUpUserProfile &&
        isNewUser == other.isNewUser &&
        isAdmin == other.isAdmin;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, loginResponse.hashCode);
    _$hash = $jc(_$hash, userName.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, signedUpUserProfile.hashCode);
    _$hash = $jc(_$hash, isNewUser.hashCode);
    _$hash = $jc(_$hash, isAdmin.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PhoneLoginResult')
          ..add('loginResponse', loginResponse)
          ..add('userName', userName)
          ..add('email', email)
          ..add('signedUpUserProfile', signedUpUserProfile)
          ..add('isNewUser', isNewUser)
          ..add('isAdmin', isAdmin))
        .toString();
  }
}

class PhoneLoginResultBuilder
    implements Builder<PhoneLoginResult, PhoneLoginResultBuilder> {
  _$PhoneLoginResult? _$v;

  LoginResponseBuilder? _loginResponse;
  LoginResponseBuilder get loginResponse =>
      _$this._loginResponse ??= new LoginResponseBuilder();
  set loginResponse(LoginResponseBuilder? loginResponse) =>
      _$this._loginResponse = loginResponse;

  String? _userName;
  String? get userName => _$this._userName;
  set userName(String? userName) => _$this._userName = userName;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  ProfileEntityBuilder? _signedUpUserProfile;
  ProfileEntityBuilder get signedUpUserProfile =>
      _$this._signedUpUserProfile ??= new ProfileEntityBuilder();
  set signedUpUserProfile(ProfileEntityBuilder? signedUpUserProfile) =>
      _$this._signedUpUserProfile = signedUpUserProfile;

  bool? _isNewUser;
  bool? get isNewUser => _$this._isNewUser;
  set isNewUser(bool? isNewUser) => _$this._isNewUser = isNewUser;

  bool? _isAdmin;
  bool? get isAdmin => _$this._isAdmin;
  set isAdmin(bool? isAdmin) => _$this._isAdmin = isAdmin;

  PhoneLoginResultBuilder();

  PhoneLoginResultBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _loginResponse = $v.loginResponse.toBuilder();
      _userName = $v.userName;
      _email = $v.email;
      _signedUpUserProfile = $v.signedUpUserProfile.toBuilder();
      _isNewUser = $v.isNewUser;
      _isAdmin = $v.isAdmin;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PhoneLoginResult other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$PhoneLoginResult;
  }

  @override
  void update(void Function(PhoneLoginResultBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PhoneLoginResult build() => _build();

  _$PhoneLoginResult _build() {
    _$PhoneLoginResult _$result;
    try {
      _$result = _$v ??
          new _$PhoneLoginResult._(
              loginResponse: loginResponse.build(),
              userName: BuiltValueNullFieldError.checkNotNull(
                  userName, r'PhoneLoginResult', 'userName'),
              email: BuiltValueNullFieldError.checkNotNull(
                  email, r'PhoneLoginResult', 'email'),
              signedUpUserProfile: signedUpUserProfile.build(),
              isNewUser: BuiltValueNullFieldError.checkNotNull(
                  isNewUser, r'PhoneLoginResult', 'isNewUser'),
              isAdmin: BuiltValueNullFieldError.checkNotNull(
                  isAdmin, r'PhoneLoginResult', 'isAdmin'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'loginResponse';
        loginResponse.build();

        _$failedField = 'signedUpUserProfile';
        signedUpUserProfile.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'PhoneLoginResult', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$OAuthResult extends OAuthResult {
  @override
  final LoginResponse loginResponse;
  @override
  final String userName;
  @override
  final String email;
  @override
  final ProfileEntity loggedInUserProfile;
  @override
  final bool isAdmin;
  @override
  final bool isEmailVerified;

  factory _$OAuthResult([void Function(OAuthResultBuilder)? updates]) =>
      (new OAuthResultBuilder()..update(updates))._build();

  _$OAuthResult._(
      {required this.loginResponse,
      required this.userName,
      required this.email,
      required this.loggedInUserProfile,
      required this.isAdmin,
      required this.isEmailVerified})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        loginResponse, r'OAuthResult', 'loginResponse');
    BuiltValueNullFieldError.checkNotNull(userName, r'OAuthResult', 'userName');
    BuiltValueNullFieldError.checkNotNull(email, r'OAuthResult', 'email');
    BuiltValueNullFieldError.checkNotNull(
        loggedInUserProfile, r'OAuthResult', 'loggedInUserProfile');
    BuiltValueNullFieldError.checkNotNull(isAdmin, r'OAuthResult', 'isAdmin');
    BuiltValueNullFieldError.checkNotNull(
        isEmailVerified, r'OAuthResult', 'isEmailVerified');
  }

  @override
  OAuthResult rebuild(void Function(OAuthResultBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OAuthResultBuilder toBuilder() => new OAuthResultBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OAuthResult &&
        loginResponse == other.loginResponse &&
        userName == other.userName &&
        email == other.email &&
        loggedInUserProfile == other.loggedInUserProfile &&
        isAdmin == other.isAdmin &&
        isEmailVerified == other.isEmailVerified;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, loginResponse.hashCode);
    _$hash = $jc(_$hash, userName.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, loggedInUserProfile.hashCode);
    _$hash = $jc(_$hash, isAdmin.hashCode);
    _$hash = $jc(_$hash, isEmailVerified.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OAuthResult')
          ..add('loginResponse', loginResponse)
          ..add('userName', userName)
          ..add('email', email)
          ..add('loggedInUserProfile', loggedInUserProfile)
          ..add('isAdmin', isAdmin)
          ..add('isEmailVerified', isEmailVerified))
        .toString();
  }
}

class OAuthResultBuilder implements Builder<OAuthResult, OAuthResultBuilder> {
  _$OAuthResult? _$v;

  LoginResponseBuilder? _loginResponse;
  LoginResponseBuilder get loginResponse =>
      _$this._loginResponse ??= new LoginResponseBuilder();
  set loginResponse(LoginResponseBuilder? loginResponse) =>
      _$this._loginResponse = loginResponse;

  String? _userName;
  String? get userName => _$this._userName;
  set userName(String? userName) => _$this._userName = userName;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  ProfileEntityBuilder? _loggedInUserProfile;
  ProfileEntityBuilder get loggedInUserProfile =>
      _$this._loggedInUserProfile ??= new ProfileEntityBuilder();
  set loggedInUserProfile(ProfileEntityBuilder? loggedInUserProfile) =>
      _$this._loggedInUserProfile = loggedInUserProfile;

  bool? _isAdmin;
  bool? get isAdmin => _$this._isAdmin;
  set isAdmin(bool? isAdmin) => _$this._isAdmin = isAdmin;

  bool? _isEmailVerified;
  bool? get isEmailVerified => _$this._isEmailVerified;
  set isEmailVerified(bool? isEmailVerified) =>
      _$this._isEmailVerified = isEmailVerified;

  OAuthResultBuilder();

  OAuthResultBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _loginResponse = $v.loginResponse.toBuilder();
      _userName = $v.userName;
      _email = $v.email;
      _loggedInUserProfile = $v.loggedInUserProfile.toBuilder();
      _isAdmin = $v.isAdmin;
      _isEmailVerified = $v.isEmailVerified;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OAuthResult other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$OAuthResult;
  }

  @override
  void update(void Function(OAuthResultBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OAuthResult build() => _build();

  _$OAuthResult _build() {
    _$OAuthResult _$result;
    try {
      _$result = _$v ??
          new _$OAuthResult._(
              loginResponse: loginResponse.build(),
              userName: BuiltValueNullFieldError.checkNotNull(
                  userName, r'OAuthResult', 'userName'),
              email: BuiltValueNullFieldError.checkNotNull(
                  email, r'OAuthResult', 'email'),
              loggedInUserProfile: loggedInUserProfile.build(),
              isAdmin: BuiltValueNullFieldError.checkNotNull(
                  isAdmin, r'OAuthResult', 'isAdmin'),
              isEmailVerified: BuiltValueNullFieldError.checkNotNull(
                  isEmailVerified, r'OAuthResult', 'isEmailVerified'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'loginResponse';
        loginResponse.build();

        _$failedField = 'loggedInUserProfile';
        loggedInUserProfile.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'OAuthResult', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
