// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_response_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<OAuthLoginResponse> _$oAuthLoginResponseSerializer =
    new _$OAuthLoginResponseSerializer();
Serializer<SignupResponse> _$signupResponseSerializer =
    new _$SignupResponseSerializer();
Serializer<PhoneAuthResponse> _$phoneAuthResponseSerializer =
    new _$PhoneAuthResponseSerializer();
Serializer<ExistingProfileCheckResponse>
    _$existingProfileCheckResponseSerializer =
    new _$ExistingProfileCheckResponseSerializer();
Serializer<EmptyLoginResponse> _$emptyLoginResponseSerializer =
    new _$EmptyLoginResponseSerializer();

class _$OAuthLoginResponseSerializer
    implements StructuredSerializer<OAuthLoginResponse> {
  @override
  final Iterable<Type> types = const [OAuthLoginResponse, _$OAuthLoginResponse];
  @override
  final String wireName = 'OAuthLoginResponse';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, OAuthLoginResponse object,
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
      'isDeleted',
      serializers.serialize(object.isDeleted,
          specifiedType: const FullType(bool)),
    ];

    return result;
  }

  @override
  OAuthLoginResponse deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new OAuthLoginResponseBuilder();

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
        case 'isDeleted':
          result.isDeleted = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
      }
    }

    return result.build();
  }
}

class _$SignupResponseSerializer
    implements StructuredSerializer<SignupResponse> {
  @override
  final Iterable<Type> types = const [SignupResponse, _$SignupResponse];
  @override
  final String wireName = 'SignupResponse';

  @override
  Iterable<Object?> serialize(Serializers serializers, SignupResponse object,
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
      'isNewUser',
      serializers.serialize(object.isNewUser,
          specifiedType: const FullType(bool)),
    ];

    return result;
  }

  @override
  SignupResponse deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new SignupResponseBuilder();

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
        case 'isNewUser':
          result.isNewUser = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
      }
    }

    return result.build();
  }
}

class _$PhoneAuthResponseSerializer
    implements StructuredSerializer<PhoneAuthResponse> {
  @override
  final Iterable<Type> types = const [PhoneAuthResponse, _$PhoneAuthResponse];
  @override
  final String wireName = 'PhoneAuthResponse';

  @override
  Iterable<Object?> serialize(Serializers serializers, PhoneAuthResponse object,
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
      'isNewUser',
      serializers.serialize(object.isNewUser,
          specifiedType: const FullType(bool)),
    ];

    return result;
  }

  @override
  PhoneAuthResponse deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new PhoneAuthResponseBuilder();

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
        case 'isNewUser':
          result.isNewUser = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
      }
    }

    return result.build();
  }
}

class _$ExistingProfileCheckResponseSerializer
    implements StructuredSerializer<ExistingProfileCheckResponse> {
  @override
  final Iterable<Type> types = const [
    ExistingProfileCheckResponse,
    _$ExistingProfileCheckResponse
  ];
  @override
  final String wireName = 'ExistingProfileCheckResponse';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, ExistingProfileCheckResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'hasProfile',
      serializers.serialize(object.hasProfile,
          specifiedType: const FullType(bool)),
    ];
    Object? value;
    value = object.user;
    if (value != null) {
      result
        ..add('user')
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
  ExistingProfileCheckResponse deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ExistingProfileCheckResponseBuilder();

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
        case 'user':
          result.user = serializers.deserialize(value,
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

class _$EmptyLoginResponseSerializer
    implements StructuredSerializer<EmptyLoginResponse> {
  @override
  final Iterable<Type> types = const [EmptyLoginResponse, _$EmptyLoginResponse];
  @override
  final String wireName = 'EmptyLoginResponse';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, EmptyLoginResponse object,
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
      'isDeleted',
      serializers.serialize(object.isDeleted,
          specifiedType: const FullType(bool)),
    ];

    return result;
  }

  @override
  EmptyLoginResponse deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new EmptyLoginResponseBuilder();

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
        case 'isDeleted':
          result.isDeleted = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
      }
    }

    return result.build();
  }
}

class _$OAuthLoginResponse extends OAuthLoginResponse {
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
  @override
  final bool isDeleted;

  factory _$OAuthLoginResponse(
          [void Function(OAuthLoginResponseBuilder)? updates]) =>
      (new OAuthLoginResponseBuilder()..update(updates))._build();

  _$OAuthLoginResponse._(
      {required this.loginResponse,
      required this.userName,
      required this.email,
      required this.loggedInUserProfile,
      required this.isAdmin,
      required this.isEmailVerified,
      required this.isDeleted})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        loginResponse, r'OAuthLoginResponse', 'loginResponse');
    BuiltValueNullFieldError.checkNotNull(
        userName, r'OAuthLoginResponse', 'userName');
    BuiltValueNullFieldError.checkNotNull(
        email, r'OAuthLoginResponse', 'email');
    BuiltValueNullFieldError.checkNotNull(
        loggedInUserProfile, r'OAuthLoginResponse', 'loggedInUserProfile');
    BuiltValueNullFieldError.checkNotNull(
        isAdmin, r'OAuthLoginResponse', 'isAdmin');
    BuiltValueNullFieldError.checkNotNull(
        isEmailVerified, r'OAuthLoginResponse', 'isEmailVerified');
    BuiltValueNullFieldError.checkNotNull(
        isDeleted, r'OAuthLoginResponse', 'isDeleted');
  }

  @override
  OAuthLoginResponse rebuild(
          void Function(OAuthLoginResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OAuthLoginResponseBuilder toBuilder() =>
      new OAuthLoginResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OAuthLoginResponse &&
        loginResponse == other.loginResponse &&
        userName == other.userName &&
        email == other.email &&
        loggedInUserProfile == other.loggedInUserProfile &&
        isAdmin == other.isAdmin &&
        isEmailVerified == other.isEmailVerified &&
        isDeleted == other.isDeleted;
  }

  int? __hashCode;
  @override
  int get hashCode {
    if (__hashCode != null) return __hashCode!;
    var _$hash = 0;
    _$hash = $jc(_$hash, loginResponse.hashCode);
    _$hash = $jc(_$hash, userName.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, loggedInUserProfile.hashCode);
    _$hash = $jc(_$hash, isAdmin.hashCode);
    _$hash = $jc(_$hash, isEmailVerified.hashCode);
    _$hash = $jc(_$hash, isDeleted.hashCode);
    _$hash = $jf(_$hash);
    return __hashCode ??= _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OAuthLoginResponse')
          ..add('loginResponse', loginResponse)
          ..add('userName', userName)
          ..add('email', email)
          ..add('loggedInUserProfile', loggedInUserProfile)
          ..add('isAdmin', isAdmin)
          ..add('isEmailVerified', isEmailVerified)
          ..add('isDeleted', isDeleted))
        .toString();
  }
}

class OAuthLoginResponseBuilder
    implements Builder<OAuthLoginResponse, OAuthLoginResponseBuilder> {
  _$OAuthLoginResponse? _$v;

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

  bool? _isDeleted;
  bool? get isDeleted => _$this._isDeleted;
  set isDeleted(bool? isDeleted) => _$this._isDeleted = isDeleted;

  OAuthLoginResponseBuilder();

  OAuthLoginResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _loginResponse = $v.loginResponse.toBuilder();
      _userName = $v.userName;
      _email = $v.email;
      _loggedInUserProfile = $v.loggedInUserProfile.toBuilder();
      _isAdmin = $v.isAdmin;
      _isEmailVerified = $v.isEmailVerified;
      _isDeleted = $v.isDeleted;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OAuthLoginResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$OAuthLoginResponse;
  }

  @override
  void update(void Function(OAuthLoginResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OAuthLoginResponse build() => _build();

  _$OAuthLoginResponse _build() {
    _$OAuthLoginResponse _$result;
    try {
      _$result = _$v ??
          new _$OAuthLoginResponse._(
              loginResponse: loginResponse.build(),
              userName: BuiltValueNullFieldError.checkNotNull(
                  userName, r'OAuthLoginResponse', 'userName'),
              email: BuiltValueNullFieldError.checkNotNull(
                  email, r'OAuthLoginResponse', 'email'),
              loggedInUserProfile: loggedInUserProfile.build(),
              isAdmin: BuiltValueNullFieldError.checkNotNull(
                  isAdmin, r'OAuthLoginResponse', 'isAdmin'),
              isEmailVerified: BuiltValueNullFieldError.checkNotNull(
                  isEmailVerified, r'OAuthLoginResponse', 'isEmailVerified'),
              isDeleted: BuiltValueNullFieldError.checkNotNull(
                  isDeleted, r'OAuthLoginResponse', 'isDeleted'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'loginResponse';
        loginResponse.build();

        _$failedField = 'loggedInUserProfile';
        loggedInUserProfile.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'OAuthLoginResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$SignupResponse extends SignupResponse {
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
  final bool isNewUser;

  factory _$SignupResponse([void Function(SignupResponseBuilder)? updates]) =>
      (new SignupResponseBuilder()..update(updates))._build();

  _$SignupResponse._(
      {required this.loginResponse,
      required this.userName,
      required this.email,
      required this.signedUpUserProfile,
      required this.isEmailVerified,
      required this.isNewUser})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        loginResponse, r'SignupResponse', 'loginResponse');
    BuiltValueNullFieldError.checkNotNull(
        userName, r'SignupResponse', 'userName');
    BuiltValueNullFieldError.checkNotNull(email, r'SignupResponse', 'email');
    BuiltValueNullFieldError.checkNotNull(
        signedUpUserProfile, r'SignupResponse', 'signedUpUserProfile');
    BuiltValueNullFieldError.checkNotNull(
        isEmailVerified, r'SignupResponse', 'isEmailVerified');
    BuiltValueNullFieldError.checkNotNull(
        isNewUser, r'SignupResponse', 'isNewUser');
  }

  @override
  SignupResponse rebuild(void Function(SignupResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SignupResponseBuilder toBuilder() =>
      new SignupResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SignupResponse &&
        loginResponse == other.loginResponse &&
        userName == other.userName &&
        email == other.email &&
        signedUpUserProfile == other.signedUpUserProfile &&
        isEmailVerified == other.isEmailVerified &&
        isNewUser == other.isNewUser;
  }

  int? __hashCode;
  @override
  int get hashCode {
    if (__hashCode != null) return __hashCode!;
    var _$hash = 0;
    _$hash = $jc(_$hash, loginResponse.hashCode);
    _$hash = $jc(_$hash, userName.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, signedUpUserProfile.hashCode);
    _$hash = $jc(_$hash, isEmailVerified.hashCode);
    _$hash = $jc(_$hash, isNewUser.hashCode);
    _$hash = $jf(_$hash);
    return __hashCode ??= _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SignupResponse')
          ..add('loginResponse', loginResponse)
          ..add('userName', userName)
          ..add('email', email)
          ..add('signedUpUserProfile', signedUpUserProfile)
          ..add('isEmailVerified', isEmailVerified)
          ..add('isNewUser', isNewUser))
        .toString();
  }
}

class SignupResponseBuilder
    implements Builder<SignupResponse, SignupResponseBuilder> {
  _$SignupResponse? _$v;

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

  bool? _isNewUser;
  bool? get isNewUser => _$this._isNewUser;
  set isNewUser(bool? isNewUser) => _$this._isNewUser = isNewUser;

  SignupResponseBuilder();

  SignupResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _loginResponse = $v.loginResponse.toBuilder();
      _userName = $v.userName;
      _email = $v.email;
      _signedUpUserProfile = $v.signedUpUserProfile.toBuilder();
      _isEmailVerified = $v.isEmailVerified;
      _isNewUser = $v.isNewUser;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SignupResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$SignupResponse;
  }

  @override
  void update(void Function(SignupResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SignupResponse build() => _build();

  _$SignupResponse _build() {
    _$SignupResponse _$result;
    try {
      _$result = _$v ??
          new _$SignupResponse._(
              loginResponse: loginResponse.build(),
              userName: BuiltValueNullFieldError.checkNotNull(
                  userName, r'SignupResponse', 'userName'),
              email: BuiltValueNullFieldError.checkNotNull(
                  email, r'SignupResponse', 'email'),
              signedUpUserProfile: signedUpUserProfile.build(),
              isEmailVerified: BuiltValueNullFieldError.checkNotNull(
                  isEmailVerified, r'SignupResponse', 'isEmailVerified'),
              isNewUser: BuiltValueNullFieldError.checkNotNull(
                  isNewUser, r'SignupResponse', 'isNewUser'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'loginResponse';
        loginResponse.build();

        _$failedField = 'signedUpUserProfile';
        signedUpUserProfile.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'SignupResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$PhoneAuthResponse extends PhoneAuthResponse {
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
  final bool isNewUser;

  factory _$PhoneAuthResponse(
          [void Function(PhoneAuthResponseBuilder)? updates]) =>
      (new PhoneAuthResponseBuilder()..update(updates))._build();

  _$PhoneAuthResponse._(
      {required this.loginResponse,
      required this.userName,
      required this.email,
      required this.loggedInUserProfile,
      required this.isAdmin,
      required this.isNewUser})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        loginResponse, r'PhoneAuthResponse', 'loginResponse');
    BuiltValueNullFieldError.checkNotNull(
        userName, r'PhoneAuthResponse', 'userName');
    BuiltValueNullFieldError.checkNotNull(email, r'PhoneAuthResponse', 'email');
    BuiltValueNullFieldError.checkNotNull(
        loggedInUserProfile, r'PhoneAuthResponse', 'loggedInUserProfile');
    BuiltValueNullFieldError.checkNotNull(
        isAdmin, r'PhoneAuthResponse', 'isAdmin');
    BuiltValueNullFieldError.checkNotNull(
        isNewUser, r'PhoneAuthResponse', 'isNewUser');
  }

  @override
  PhoneAuthResponse rebuild(void Function(PhoneAuthResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PhoneAuthResponseBuilder toBuilder() =>
      new PhoneAuthResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PhoneAuthResponse &&
        loginResponse == other.loginResponse &&
        userName == other.userName &&
        email == other.email &&
        loggedInUserProfile == other.loggedInUserProfile &&
        isAdmin == other.isAdmin &&
        isNewUser == other.isNewUser;
  }

  int? __hashCode;
  @override
  int get hashCode {
    if (__hashCode != null) return __hashCode!;
    var _$hash = 0;
    _$hash = $jc(_$hash, loginResponse.hashCode);
    _$hash = $jc(_$hash, userName.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, loggedInUserProfile.hashCode);
    _$hash = $jc(_$hash, isAdmin.hashCode);
    _$hash = $jc(_$hash, isNewUser.hashCode);
    _$hash = $jf(_$hash);
    return __hashCode ??= _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PhoneAuthResponse')
          ..add('loginResponse', loginResponse)
          ..add('userName', userName)
          ..add('email', email)
          ..add('loggedInUserProfile', loggedInUserProfile)
          ..add('isAdmin', isAdmin)
          ..add('isNewUser', isNewUser))
        .toString();
  }
}

class PhoneAuthResponseBuilder
    implements Builder<PhoneAuthResponse, PhoneAuthResponseBuilder> {
  _$PhoneAuthResponse? _$v;

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

  bool? _isNewUser;
  bool? get isNewUser => _$this._isNewUser;
  set isNewUser(bool? isNewUser) => _$this._isNewUser = isNewUser;

  PhoneAuthResponseBuilder();

  PhoneAuthResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _loginResponse = $v.loginResponse.toBuilder();
      _userName = $v.userName;
      _email = $v.email;
      _loggedInUserProfile = $v.loggedInUserProfile.toBuilder();
      _isAdmin = $v.isAdmin;
      _isNewUser = $v.isNewUser;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PhoneAuthResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$PhoneAuthResponse;
  }

  @override
  void update(void Function(PhoneAuthResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PhoneAuthResponse build() => _build();

  _$PhoneAuthResponse _build() {
    _$PhoneAuthResponse _$result;
    try {
      _$result = _$v ??
          new _$PhoneAuthResponse._(
              loginResponse: loginResponse.build(),
              userName: BuiltValueNullFieldError.checkNotNull(
                  userName, r'PhoneAuthResponse', 'userName'),
              email: BuiltValueNullFieldError.checkNotNull(
                  email, r'PhoneAuthResponse', 'email'),
              loggedInUserProfile: loggedInUserProfile.build(),
              isAdmin: BuiltValueNullFieldError.checkNotNull(
                  isAdmin, r'PhoneAuthResponse', 'isAdmin'),
              isNewUser: BuiltValueNullFieldError.checkNotNull(
                  isNewUser, r'PhoneAuthResponse', 'isNewUser'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'loginResponse';
        loginResponse.build();

        _$failedField = 'loggedInUserProfile';
        loggedInUserProfile.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'PhoneAuthResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$ExistingProfileCheckResponse extends ExistingProfileCheckResponse {
  @override
  final bool hasProfile;
  @override
  final Map<String, dynamic>? user;
  @override
  final ProfileEntity? profile;
  @override
  final String? error;

  factory _$ExistingProfileCheckResponse(
          [void Function(ExistingProfileCheckResponseBuilder)? updates]) =>
      (new ExistingProfileCheckResponseBuilder()..update(updates))._build();

  _$ExistingProfileCheckResponse._(
      {required this.hasProfile, this.user, this.profile, this.error})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        hasProfile, r'ExistingProfileCheckResponse', 'hasProfile');
  }

  @override
  ExistingProfileCheckResponse rebuild(
          void Function(ExistingProfileCheckResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ExistingProfileCheckResponseBuilder toBuilder() =>
      new ExistingProfileCheckResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ExistingProfileCheckResponse &&
        hasProfile == other.hasProfile &&
        user == other.user &&
        profile == other.profile &&
        error == other.error;
  }

  int? __hashCode;
  @override
  int get hashCode {
    if (__hashCode != null) return __hashCode!;
    var _$hash = 0;
    _$hash = $jc(_$hash, hasProfile.hashCode);
    _$hash = $jc(_$hash, user.hashCode);
    _$hash = $jc(_$hash, profile.hashCode);
    _$hash = $jc(_$hash, error.hashCode);
    _$hash = $jf(_$hash);
    return __hashCode ??= _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ExistingProfileCheckResponse')
          ..add('hasProfile', hasProfile)
          ..add('user', user)
          ..add('profile', profile)
          ..add('error', error))
        .toString();
  }
}

class ExistingProfileCheckResponseBuilder
    implements
        Builder<ExistingProfileCheckResponse,
            ExistingProfileCheckResponseBuilder> {
  _$ExistingProfileCheckResponse? _$v;

  bool? _hasProfile;
  bool? get hasProfile => _$this._hasProfile;
  set hasProfile(bool? hasProfile) => _$this._hasProfile = hasProfile;

  Map<String, dynamic>? _user;
  Map<String, dynamic>? get user => _$this._user;
  set user(Map<String, dynamic>? user) => _$this._user = user;

  ProfileEntityBuilder? _profile;
  ProfileEntityBuilder get profile =>
      _$this._profile ??= new ProfileEntityBuilder();
  set profile(ProfileEntityBuilder? profile) => _$this._profile = profile;

  String? _error;
  String? get error => _$this._error;
  set error(String? error) => _$this._error = error;

  ExistingProfileCheckResponseBuilder();

  ExistingProfileCheckResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _hasProfile = $v.hasProfile;
      _user = $v.user;
      _profile = $v.profile?.toBuilder();
      _error = $v.error;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ExistingProfileCheckResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ExistingProfileCheckResponse;
  }

  @override
  void update(void Function(ExistingProfileCheckResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ExistingProfileCheckResponse build() => _build();

  _$ExistingProfileCheckResponse _build() {
    _$ExistingProfileCheckResponse _$result;
    try {
      _$result = _$v ??
          new _$ExistingProfileCheckResponse._(
              hasProfile: BuiltValueNullFieldError.checkNotNull(
                  hasProfile, r'ExistingProfileCheckResponse', 'hasProfile'),
              user: user,
              profile: _profile?.build(),
              error: error);
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'profile';
        _profile?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'ExistingProfileCheckResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$EmptyLoginResponse extends EmptyLoginResponse {
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
  final bool isDeleted;

  factory _$EmptyLoginResponse(
          [void Function(EmptyLoginResponseBuilder)? updates]) =>
      (new EmptyLoginResponseBuilder()..update(updates))._build();

  _$EmptyLoginResponse._(
      {required this.loginResponse,
      required this.userName,
      required this.email,
      required this.loggedInUserProfile,
      required this.isAdmin,
      required this.isDeleted})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        loginResponse, r'EmptyLoginResponse', 'loginResponse');
    BuiltValueNullFieldError.checkNotNull(
        userName, r'EmptyLoginResponse', 'userName');
    BuiltValueNullFieldError.checkNotNull(
        email, r'EmptyLoginResponse', 'email');
    BuiltValueNullFieldError.checkNotNull(
        loggedInUserProfile, r'EmptyLoginResponse', 'loggedInUserProfile');
    BuiltValueNullFieldError.checkNotNull(
        isAdmin, r'EmptyLoginResponse', 'isAdmin');
    BuiltValueNullFieldError.checkNotNull(
        isDeleted, r'EmptyLoginResponse', 'isDeleted');
  }

  @override
  EmptyLoginResponse rebuild(
          void Function(EmptyLoginResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EmptyLoginResponseBuilder toBuilder() =>
      new EmptyLoginResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EmptyLoginResponse &&
        loginResponse == other.loginResponse &&
        userName == other.userName &&
        email == other.email &&
        loggedInUserProfile == other.loggedInUserProfile &&
        isAdmin == other.isAdmin &&
        isDeleted == other.isDeleted;
  }

  int? __hashCode;
  @override
  int get hashCode {
    if (__hashCode != null) return __hashCode!;
    var _$hash = 0;
    _$hash = $jc(_$hash, loginResponse.hashCode);
    _$hash = $jc(_$hash, userName.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, loggedInUserProfile.hashCode);
    _$hash = $jc(_$hash, isAdmin.hashCode);
    _$hash = $jc(_$hash, isDeleted.hashCode);
    _$hash = $jf(_$hash);
    return __hashCode ??= _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EmptyLoginResponse')
          ..add('loginResponse', loginResponse)
          ..add('userName', userName)
          ..add('email', email)
          ..add('loggedInUserProfile', loggedInUserProfile)
          ..add('isAdmin', isAdmin)
          ..add('isDeleted', isDeleted))
        .toString();
  }
}

class EmptyLoginResponseBuilder
    implements Builder<EmptyLoginResponse, EmptyLoginResponseBuilder> {
  _$EmptyLoginResponse? _$v;

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

  bool? _isDeleted;
  bool? get isDeleted => _$this._isDeleted;
  set isDeleted(bool? isDeleted) => _$this._isDeleted = isDeleted;

  EmptyLoginResponseBuilder();

  EmptyLoginResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _loginResponse = $v.loginResponse.toBuilder();
      _userName = $v.userName;
      _email = $v.email;
      _loggedInUserProfile = $v.loggedInUserProfile.toBuilder();
      _isAdmin = $v.isAdmin;
      _isDeleted = $v.isDeleted;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EmptyLoginResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$EmptyLoginResponse;
  }

  @override
  void update(void Function(EmptyLoginResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EmptyLoginResponse build() => _build();

  _$EmptyLoginResponse _build() {
    _$EmptyLoginResponse _$result;
    try {
      _$result = _$v ??
          new _$EmptyLoginResponse._(
              loginResponse: loginResponse.build(),
              userName: BuiltValueNullFieldError.checkNotNull(
                  userName, r'EmptyLoginResponse', 'userName'),
              email: BuiltValueNullFieldError.checkNotNull(
                  email, r'EmptyLoginResponse', 'email'),
              loggedInUserProfile: loggedInUserProfile.build(),
              isAdmin: BuiltValueNullFieldError.checkNotNull(
                  isAdmin, r'EmptyLoginResponse', 'isAdmin'),
              isDeleted: BuiltValueNullFieldError.checkNotNull(
                  isDeleted, r'EmptyLoginResponse', 'isDeleted'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'loginResponse';
        loginResponse.build();

        _$failedField = 'loggedInUserProfile';
        loggedInUserProfile.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'EmptyLoginResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
