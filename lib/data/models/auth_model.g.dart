// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<AuthResult> _$authResultSerializer = new _$AuthResultSerializer();
Serializer<SignUpResult> _$signUpResultSerializer =
    new _$SignUpResultSerializer();
Serializer<ProfileSaveResult> _$profileSaveResultSerializer =
    new _$ProfileSaveResultSerializer();
Serializer<PhoneAuthResult> _$phoneAuthResultSerializer =
    new _$PhoneAuthResultSerializer();

class _$AuthResultSerializer implements StructuredSerializer<AuthResult> {
  @override
  final Iterable<Type> types = const [AuthResult, _$AuthResult];
  @override
  final String wireName = 'AuthResult';

  @override
  Iterable<Object?> serialize(Serializers serializers, AuthResult object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'uid',
      serializers.serialize(object.uid, specifiedType: const FullType(String)),
      'email',
      serializers.serialize(object.email,
          specifiedType: const FullType(String)),
      'displayName',
      serializers.serialize(object.displayName,
          specifiedType: const FullType(String)),
      'isEmailVerified',
      serializers.serialize(object.isEmailVerified,
          specifiedType: const FullType(bool)),
    ];
    Object? value;
    value = object.loggedInUserProfile;
    if (value != null) {
      result
        ..add('loggedInUserProfile')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(ProfileEntity)));
    }
    return result;
  }

  @override
  AuthResult deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new AuthResultBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'uid':
          result.uid = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'email':
          result.email = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'displayName':
          result.displayName = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'isEmailVerified':
          result.isEmailVerified = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
        case 'loggedInUserProfile':
          result.loggedInUserProfile.replace(serializers.deserialize(value,
              specifiedType: const FullType(ProfileEntity))! as ProfileEntity);
          break;
      }
    }

    return result.build();
  }
}

class _$SignUpResultSerializer implements StructuredSerializer<SignUpResult> {
  @override
  final Iterable<Type> types = const [SignUpResult, _$SignUpResult];
  @override
  final String wireName = 'SignUpResult';

  @override
  Iterable<Object?> serialize(Serializers serializers, SignUpResult object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'uid',
      serializers.serialize(object.uid, specifiedType: const FullType(String)),
      'email',
      serializers.serialize(object.email,
          specifiedType: const FullType(String)),
      'displayName',
      serializers.serialize(object.displayName,
          specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  SignUpResult deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new SignUpResultBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'uid':
          result.uid = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'email':
          result.email = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'displayName':
          result.displayName = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$ProfileSaveResultSerializer
    implements StructuredSerializer<ProfileSaveResult> {
  @override
  final Iterable<Type> types = const [ProfileSaveResult, _$ProfileSaveResult];
  @override
  final String wireName = 'ProfileSaveResult';

  @override
  Iterable<Object?> serialize(Serializers serializers, ProfileSaveResult object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'data',
      serializers.serialize(object.data,
          specifiedType: const FullType(
              Map, const [const FullType(String), const FullType(dynamic)])),
    ];

    return result;
  }

  @override
  ProfileSaveResult deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ProfileSaveResultBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'data':
          result.data = serializers.deserialize(value,
              specifiedType: const FullType(Map, const [
                const FullType(String),
                const FullType(dynamic)
              ]))! as Map<String, dynamic>;
          break;
      }
    }

    return result.build();
  }
}

class _$PhoneAuthResultSerializer
    implements StructuredSerializer<PhoneAuthResult> {
  @override
  final Iterable<Type> types = const [PhoneAuthResult, _$PhoneAuthResult];
  @override
  final String wireName = 'PhoneAuthResult';

  @override
  Iterable<Object?> serialize(Serializers serializers, PhoneAuthResult object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'uid',
      serializers.serialize(object.uid, specifiedType: const FullType(String)),
      'displayName',
      serializers.serialize(object.displayName,
          specifiedType: const FullType(String)),
      'email',
      serializers.serialize(object.email,
          specifiedType: const FullType(String)),
      'isAdmin',
      serializers.serialize(object.isAdmin,
          specifiedType: const FullType(bool)),
      'isProfileCompleted',
      serializers.serialize(object.isProfileCompleted,
          specifiedType: const FullType(bool)),
    ];

    return result;
  }

  @override
  PhoneAuthResult deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new PhoneAuthResultBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'uid':
          result.uid = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'displayName':
          result.displayName = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'email':
          result.email = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'isAdmin':
          result.isAdmin = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
        case 'isProfileCompleted':
          result.isProfileCompleted = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
      }
    }

    return result.build();
  }
}

class _$AuthResult extends AuthResult {
  @override
  final String uid;
  @override
  final String email;
  @override
  final String displayName;
  @override
  final bool isEmailVerified;
  @override
  final ProfileEntity? loggedInUserProfile;

  factory _$AuthResult([void Function(AuthResultBuilder)? updates]) =>
      (new AuthResultBuilder()..update(updates))._build();

  _$AuthResult._(
      {required this.uid,
      required this.email,
      required this.displayName,
      required this.isEmailVerified,
      this.loggedInUserProfile})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(uid, r'AuthResult', 'uid');
    BuiltValueNullFieldError.checkNotNull(email, r'AuthResult', 'email');
    BuiltValueNullFieldError.checkNotNull(
        displayName, r'AuthResult', 'displayName');
    BuiltValueNullFieldError.checkNotNull(
        isEmailVerified, r'AuthResult', 'isEmailVerified');
  }

  @override
  AuthResult rebuild(void Function(AuthResultBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AuthResultBuilder toBuilder() => new AuthResultBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AuthResult &&
        uid == other.uid &&
        email == other.email &&
        displayName == other.displayName &&
        isEmailVerified == other.isEmailVerified &&
        loggedInUserProfile == other.loggedInUserProfile;
  }

  int? __hashCode;
  @override
  int get hashCode {
    if (__hashCode != null) return __hashCode!;
    var _$hash = 0;
    _$hash = $jc(_$hash, uid.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, isEmailVerified.hashCode);
    _$hash = $jc(_$hash, loggedInUserProfile.hashCode);
    _$hash = $jf(_$hash);
    return __hashCode ??= _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AuthResult')
          ..add('uid', uid)
          ..add('email', email)
          ..add('displayName', displayName)
          ..add('isEmailVerified', isEmailVerified)
          ..add('loggedInUserProfile', loggedInUserProfile))
        .toString();
  }
}

class AuthResultBuilder implements Builder<AuthResult, AuthResultBuilder> {
  _$AuthResult? _$v;

  String? _uid;
  String? get uid => _$this._uid;
  set uid(String? uid) => _$this._uid = uid;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  bool? _isEmailVerified;
  bool? get isEmailVerified => _$this._isEmailVerified;
  set isEmailVerified(bool? isEmailVerified) =>
      _$this._isEmailVerified = isEmailVerified;

  ProfileEntityBuilder? _loggedInUserProfile;
  ProfileEntityBuilder get loggedInUserProfile =>
      _$this._loggedInUserProfile ??= new ProfileEntityBuilder();
  set loggedInUserProfile(ProfileEntityBuilder? loggedInUserProfile) =>
      _$this._loggedInUserProfile = loggedInUserProfile;

  AuthResultBuilder();

  AuthResultBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _uid = $v.uid;
      _email = $v.email;
      _displayName = $v.displayName;
      _isEmailVerified = $v.isEmailVerified;
      _loggedInUserProfile = $v.loggedInUserProfile?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AuthResult other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$AuthResult;
  }

  @override
  void update(void Function(AuthResultBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AuthResult build() => _build();

  _$AuthResult _build() {
    _$AuthResult _$result;
    try {
      _$result = _$v ??
          new _$AuthResult._(
              uid: BuiltValueNullFieldError.checkNotNull(
                  uid, r'AuthResult', 'uid'),
              email: BuiltValueNullFieldError.checkNotNull(
                  email, r'AuthResult', 'email'),
              displayName: BuiltValueNullFieldError.checkNotNull(
                  displayName, r'AuthResult', 'displayName'),
              isEmailVerified: BuiltValueNullFieldError.checkNotNull(
                  isEmailVerified, r'AuthResult', 'isEmailVerified'),
              loggedInUserProfile: _loggedInUserProfile?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'loggedInUserProfile';
        _loggedInUserProfile?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'AuthResult', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$SignUpResult extends SignUpResult {
  @override
  final String uid;
  @override
  final String email;
  @override
  final String displayName;

  factory _$SignUpResult([void Function(SignUpResultBuilder)? updates]) =>
      (new SignUpResultBuilder()..update(updates))._build();

  _$SignUpResult._(
      {required this.uid, required this.email, required this.displayName})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(uid, r'SignUpResult', 'uid');
    BuiltValueNullFieldError.checkNotNull(email, r'SignUpResult', 'email');
    BuiltValueNullFieldError.checkNotNull(
        displayName, r'SignUpResult', 'displayName');
  }

  @override
  SignUpResult rebuild(void Function(SignUpResultBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SignUpResultBuilder toBuilder() => new SignUpResultBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SignUpResult &&
        uid == other.uid &&
        email == other.email &&
        displayName == other.displayName;
  }

  int? __hashCode;
  @override
  int get hashCode {
    if (__hashCode != null) return __hashCode!;
    var _$hash = 0;
    _$hash = $jc(_$hash, uid.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jf(_$hash);
    return __hashCode ??= _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SignUpResult')
          ..add('uid', uid)
          ..add('email', email)
          ..add('displayName', displayName))
        .toString();
  }
}

class SignUpResultBuilder
    implements Builder<SignUpResult, SignUpResultBuilder> {
  _$SignUpResult? _$v;

  String? _uid;
  String? get uid => _$this._uid;
  set uid(String? uid) => _$this._uid = uid;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  SignUpResultBuilder();

  SignUpResultBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _uid = $v.uid;
      _email = $v.email;
      _displayName = $v.displayName;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SignUpResult other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$SignUpResult;
  }

  @override
  void update(void Function(SignUpResultBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SignUpResult build() => _build();

  _$SignUpResult _build() {
    final _$result = _$v ??
        new _$SignUpResult._(
            uid: BuiltValueNullFieldError.checkNotNull(
                uid, r'SignUpResult', 'uid'),
            email: BuiltValueNullFieldError.checkNotNull(
                email, r'SignUpResult', 'email'),
            displayName: BuiltValueNullFieldError.checkNotNull(
                displayName, r'SignUpResult', 'displayName'));
    replace(_$result);
    return _$result;
  }
}

class _$ProfileSaveResult extends ProfileSaveResult {
  @override
  final String id;
  @override
  final Map<String, dynamic> data;

  factory _$ProfileSaveResult(
          [void Function(ProfileSaveResultBuilder)? updates]) =>
      (new ProfileSaveResultBuilder()..update(updates))._build();

  _$ProfileSaveResult._({required this.id, required this.data}) : super._() {
    BuiltValueNullFieldError.checkNotNull(id, r'ProfileSaveResult', 'id');
    BuiltValueNullFieldError.checkNotNull(data, r'ProfileSaveResult', 'data');
  }

  @override
  ProfileSaveResult rebuild(void Function(ProfileSaveResultBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProfileSaveResultBuilder toBuilder() =>
      new ProfileSaveResultBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProfileSaveResult && id == other.id && data == other.data;
  }

  int? __hashCode;
  @override
  int get hashCode {
    if (__hashCode != null) return __hashCode!;
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jf(_$hash);
    return __hashCode ??= _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProfileSaveResult')
          ..add('id', id)
          ..add('data', data))
        .toString();
  }
}

class ProfileSaveResultBuilder
    implements Builder<ProfileSaveResult, ProfileSaveResultBuilder> {
  _$ProfileSaveResult? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  Map<String, dynamic>? _data;
  Map<String, dynamic>? get data => _$this._data;
  set data(Map<String, dynamic>? data) => _$this._data = data;

  ProfileSaveResultBuilder();

  ProfileSaveResultBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _data = $v.data;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProfileSaveResult other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ProfileSaveResult;
  }

  @override
  void update(void Function(ProfileSaveResultBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProfileSaveResult build() => _build();

  _$ProfileSaveResult _build() {
    final _$result = _$v ??
        new _$ProfileSaveResult._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'ProfileSaveResult', 'id'),
            data: BuiltValueNullFieldError.checkNotNull(
                data, r'ProfileSaveResult', 'data'));
    replace(_$result);
    return _$result;
  }
}

class _$PhoneAuthResult extends PhoneAuthResult {
  @override
  final String uid;
  @override
  final String displayName;
  @override
  final String email;
  @override
  final bool isAdmin;
  @override
  final bool isProfileCompleted;

  factory _$PhoneAuthResult([void Function(PhoneAuthResultBuilder)? updates]) =>
      (new PhoneAuthResultBuilder()..update(updates))._build();

  _$PhoneAuthResult._(
      {required this.uid,
      required this.displayName,
      required this.email,
      required this.isAdmin,
      required this.isProfileCompleted})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(uid, r'PhoneAuthResult', 'uid');
    BuiltValueNullFieldError.checkNotNull(
        displayName, r'PhoneAuthResult', 'displayName');
    BuiltValueNullFieldError.checkNotNull(email, r'PhoneAuthResult', 'email');
    BuiltValueNullFieldError.checkNotNull(
        isAdmin, r'PhoneAuthResult', 'isAdmin');
    BuiltValueNullFieldError.checkNotNull(
        isProfileCompleted, r'PhoneAuthResult', 'isProfileCompleted');
  }

  @override
  PhoneAuthResult rebuild(void Function(PhoneAuthResultBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PhoneAuthResultBuilder toBuilder() =>
      new PhoneAuthResultBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PhoneAuthResult &&
        uid == other.uid &&
        displayName == other.displayName &&
        email == other.email &&
        isAdmin == other.isAdmin &&
        isProfileCompleted == other.isProfileCompleted;
  }

  int? __hashCode;
  @override
  int get hashCode {
    if (__hashCode != null) return __hashCode!;
    var _$hash = 0;
    _$hash = $jc(_$hash, uid.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, isAdmin.hashCode);
    _$hash = $jc(_$hash, isProfileCompleted.hashCode);
    _$hash = $jf(_$hash);
    return __hashCode ??= _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PhoneAuthResult')
          ..add('uid', uid)
          ..add('displayName', displayName)
          ..add('email', email)
          ..add('isAdmin', isAdmin)
          ..add('isProfileCompleted', isProfileCompleted))
        .toString();
  }
}

class PhoneAuthResultBuilder
    implements Builder<PhoneAuthResult, PhoneAuthResultBuilder> {
  _$PhoneAuthResult? _$v;

  String? _uid;
  String? get uid => _$this._uid;
  set uid(String? uid) => _$this._uid = uid;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  bool? _isAdmin;
  bool? get isAdmin => _$this._isAdmin;
  set isAdmin(bool? isAdmin) => _$this._isAdmin = isAdmin;

  bool? _isProfileCompleted;
  bool? get isProfileCompleted => _$this._isProfileCompleted;
  set isProfileCompleted(bool? isProfileCompleted) =>
      _$this._isProfileCompleted = isProfileCompleted;

  PhoneAuthResultBuilder();

  PhoneAuthResultBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _uid = $v.uid;
      _displayName = $v.displayName;
      _email = $v.email;
      _isAdmin = $v.isAdmin;
      _isProfileCompleted = $v.isProfileCompleted;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PhoneAuthResult other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$PhoneAuthResult;
  }

  @override
  void update(void Function(PhoneAuthResultBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PhoneAuthResult build() => _build();

  _$PhoneAuthResult _build() {
    final _$result = _$v ??
        new _$PhoneAuthResult._(
            uid: BuiltValueNullFieldError.checkNotNull(
                uid, r'PhoneAuthResult', 'uid'),
            displayName: BuiltValueNullFieldError.checkNotNull(
                displayName, r'PhoneAuthResult', 'displayName'),
            email: BuiltValueNullFieldError.checkNotNull(
                email, r'PhoneAuthResult', 'email'),
            isAdmin: BuiltValueNullFieldError.checkNotNull(
                isAdmin, r'PhoneAuthResult', 'isAdmin'),
            isProfileCompleted: BuiltValueNullFieldError.checkNotNull(
                isProfileCompleted, r'PhoneAuthResult', 'isProfileCompleted'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
