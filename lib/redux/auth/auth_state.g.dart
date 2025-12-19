// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<AuthState> _$authStateSerializer = new _$AuthStateSerializer();

class _$AuthStateSerializer implements StructuredSerializer<AuthState> {
  @override
  final Iterable<Type> types = const [AuthState, _$AuthState];
  @override
  final String wireName = 'AuthState';

  @override
  Iterable<Object?> serialize(Serializers serializers, AuthState object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'email',
      serializers.serialize(object.email,
          specifiedType: const FullType(String)),
      'currentUserName',
      serializers.serialize(object.currentUserName,
          specifiedType: const FullType(String)),
      'currentUserId',
      serializers.serialize(object.currentUserId,
          specifiedType: const FullType(String)),
      'url',
      serializers.serialize(object.url, specifiedType: const FullType(String)),
      'isInitialized',
      serializers.serialize(object.isInitialized,
          specifiedType: const FullType(bool)),
      'isAdmin',
      serializers.serialize(object.isAdmin,
          specifiedType: const FullType(bool)),
      'isAuthenticated',
      serializers.serialize(object.isAuthenticated,
          specifiedType: const FullType(bool)),
      'lastEnteredPasswordAt',
      serializers.serialize(object.lastEnteredPasswordAt,
          specifiedType: const FullType(int)),
      'referralCode',
      serializers.serialize(object.referralCode,
          specifiedType: const FullType(String)),
      'phoneVerified',
      serializers.serialize(object.phoneVerified,
          specifiedType: const FullType(bool)),
      'isEmailVerified',
      serializers.serialize(object.isEmailVerified,
          specifiedType: const FullType(bool)),
      'setProfileCompleted',
      serializers.serialize(object.setProfileCompleted,
          specifiedType: const FullType(bool)),
      'isArchived',
      serializers.serialize(object.isArchived,
          specifiedType: const FullType(bool)),
      'phoneVerificationId',
      serializers.serialize(object.phoneVerificationId,
          specifiedType: const FullType(String)),
      'isDialogLogin',
      serializers.serialize(object.isDialogLogin,
          specifiedType: const FullType(bool)),
      'emailLinkAuthEmail',
      serializers.serialize(object.emailLinkAuthEmail,
          specifiedType: const FullType(String)),
      'isEmailLinkAuth',
      serializers.serialize(object.isEmailLinkAuth,
          specifiedType: const FullType(bool)),
      'originator',
      serializers.serialize(object.originator,
          specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  AuthState deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new AuthStateBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'email':
          result.email = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'currentUserName':
          result.currentUserName = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'currentUserId':
          result.currentUserId = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'url':
          result.url = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'isInitialized':
          result.isInitialized = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
        case 'isAdmin':
          result.isAdmin = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
        case 'isAuthenticated':
          result.isAuthenticated = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
        case 'lastEnteredPasswordAt':
          result.lastEnteredPasswordAt = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'referralCode':
          result.referralCode = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'phoneVerified':
          result.phoneVerified = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
        case 'isEmailVerified':
          result.isEmailVerified = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
        case 'setProfileCompleted':
          result.setProfileCompleted = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
        case 'isArchived':
          result.isArchived = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
        case 'phoneVerificationId':
          result.phoneVerificationId = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'isDialogLogin':
          result.isDialogLogin = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
        case 'emailLinkAuthEmail':
          result.emailLinkAuthEmail = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'isEmailLinkAuth':
          result.isEmailLinkAuth = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
        case 'originator':
          result.originator = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$AuthState extends AuthState {
  @override
  final String email;
  @override
  final String currentUserName;
  @override
  final String currentUserId;
  @override
  final String url;
  @override
  final bool isInitialized;
  @override
  final bool isAdmin;
  @override
  final bool isAuthenticated;
  @override
  final int lastEnteredPasswordAt;
  @override
  final String referralCode;
  @override
  final bool phoneVerified;
  @override
  final bool isEmailVerified;
  @override
  final bool setProfileCompleted;
  @override
  final bool isArchived;
  @override
  final String phoneVerificationId;
  @override
  final bool isDialogLogin;
  @override
  final String emailLinkAuthEmail;
  @override
  final bool isEmailLinkAuth;
  @override
  final String originator;

  factory _$AuthState([void Function(AuthStateBuilder)? updates]) =>
      (new AuthStateBuilder()..update(updates))._build();

  _$AuthState._(
      {required this.email,
      required this.currentUserName,
      required this.currentUserId,
      required this.url,
      required this.isInitialized,
      required this.isAdmin,
      required this.isAuthenticated,
      required this.lastEnteredPasswordAt,
      required this.referralCode,
      required this.phoneVerified,
      required this.isEmailVerified,
      required this.setProfileCompleted,
      required this.isArchived,
      required this.phoneVerificationId,
      required this.isDialogLogin,
      required this.emailLinkAuthEmail,
      required this.isEmailLinkAuth,
      required this.originator})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(email, r'AuthState', 'email');
    BuiltValueNullFieldError.checkNotNull(
        currentUserName, r'AuthState', 'currentUserName');
    BuiltValueNullFieldError.checkNotNull(
        currentUserId, r'AuthState', 'currentUserId');
    BuiltValueNullFieldError.checkNotNull(url, r'AuthState', 'url');
    BuiltValueNullFieldError.checkNotNull(
        isInitialized, r'AuthState', 'isInitialized');
    BuiltValueNullFieldError.checkNotNull(isAdmin, r'AuthState', 'isAdmin');
    BuiltValueNullFieldError.checkNotNull(
        isAuthenticated, r'AuthState', 'isAuthenticated');
    BuiltValueNullFieldError.checkNotNull(
        lastEnteredPasswordAt, r'AuthState', 'lastEnteredPasswordAt');
    BuiltValueNullFieldError.checkNotNull(
        referralCode, r'AuthState', 'referralCode');
    BuiltValueNullFieldError.checkNotNull(
        phoneVerified, r'AuthState', 'phoneVerified');
    BuiltValueNullFieldError.checkNotNull(
        isEmailVerified, r'AuthState', 'isEmailVerified');
    BuiltValueNullFieldError.checkNotNull(
        setProfileCompleted, r'AuthState', 'setProfileCompleted');
    BuiltValueNullFieldError.checkNotNull(
        isArchived, r'AuthState', 'isArchived');
    BuiltValueNullFieldError.checkNotNull(
        phoneVerificationId, r'AuthState', 'phoneVerificationId');
    BuiltValueNullFieldError.checkNotNull(
        isDialogLogin, r'AuthState', 'isDialogLogin');
    BuiltValueNullFieldError.checkNotNull(
        emailLinkAuthEmail, r'AuthState', 'emailLinkAuthEmail');
    BuiltValueNullFieldError.checkNotNull(
        isEmailLinkAuth, r'AuthState', 'isEmailLinkAuth');
    BuiltValueNullFieldError.checkNotNull(
        originator, r'AuthState', 'originator');
  }

  @override
  AuthState rebuild(void Function(AuthStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AuthStateBuilder toBuilder() => new AuthStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AuthState &&
        email == other.email &&
        currentUserName == other.currentUserName &&
        currentUserId == other.currentUserId &&
        url == other.url &&
        isInitialized == other.isInitialized &&
        isAdmin == other.isAdmin &&
        isAuthenticated == other.isAuthenticated &&
        lastEnteredPasswordAt == other.lastEnteredPasswordAt &&
        referralCode == other.referralCode &&
        phoneVerified == other.phoneVerified &&
        isEmailVerified == other.isEmailVerified &&
        setProfileCompleted == other.setProfileCompleted &&
        isArchived == other.isArchived &&
        phoneVerificationId == other.phoneVerificationId &&
        isDialogLogin == other.isDialogLogin &&
        emailLinkAuthEmail == other.emailLinkAuthEmail &&
        isEmailLinkAuth == other.isEmailLinkAuth &&
        originator == other.originator;
  }

  int? __hashCode;
  @override
  int get hashCode {
    if (__hashCode != null) return __hashCode!;
    var _$hash = 0;
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, currentUserName.hashCode);
    _$hash = $jc(_$hash, currentUserId.hashCode);
    _$hash = $jc(_$hash, url.hashCode);
    _$hash = $jc(_$hash, isInitialized.hashCode);
    _$hash = $jc(_$hash, isAdmin.hashCode);
    _$hash = $jc(_$hash, isAuthenticated.hashCode);
    _$hash = $jc(_$hash, lastEnteredPasswordAt.hashCode);
    _$hash = $jc(_$hash, referralCode.hashCode);
    _$hash = $jc(_$hash, phoneVerified.hashCode);
    _$hash = $jc(_$hash, isEmailVerified.hashCode);
    _$hash = $jc(_$hash, setProfileCompleted.hashCode);
    _$hash = $jc(_$hash, isArchived.hashCode);
    _$hash = $jc(_$hash, phoneVerificationId.hashCode);
    _$hash = $jc(_$hash, isDialogLogin.hashCode);
    _$hash = $jc(_$hash, emailLinkAuthEmail.hashCode);
    _$hash = $jc(_$hash, isEmailLinkAuth.hashCode);
    _$hash = $jc(_$hash, originator.hashCode);
    _$hash = $jf(_$hash);
    return __hashCode ??= _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AuthState')
          ..add('email', email)
          ..add('currentUserName', currentUserName)
          ..add('currentUserId', currentUserId)
          ..add('url', url)
          ..add('isInitialized', isInitialized)
          ..add('isAdmin', isAdmin)
          ..add('isAuthenticated', isAuthenticated)
          ..add('lastEnteredPasswordAt', lastEnteredPasswordAt)
          ..add('referralCode', referralCode)
          ..add('phoneVerified', phoneVerified)
          ..add('isEmailVerified', isEmailVerified)
          ..add('setProfileCompleted', setProfileCompleted)
          ..add('isArchived', isArchived)
          ..add('phoneVerificationId', phoneVerificationId)
          ..add('isDialogLogin', isDialogLogin)
          ..add('emailLinkAuthEmail', emailLinkAuthEmail)
          ..add('isEmailLinkAuth', isEmailLinkAuth)
          ..add('originator', originator))
        .toString();
  }
}

class AuthStateBuilder implements Builder<AuthState, AuthStateBuilder> {
  _$AuthState? _$v;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _currentUserName;
  String? get currentUserName => _$this._currentUserName;
  set currentUserName(String? currentUserName) =>
      _$this._currentUserName = currentUserName;

  String? _currentUserId;
  String? get currentUserId => _$this._currentUserId;
  set currentUserId(String? currentUserId) =>
      _$this._currentUserId = currentUserId;

  String? _url;
  String? get url => _$this._url;
  set url(String? url) => _$this._url = url;

  bool? _isInitialized;
  bool? get isInitialized => _$this._isInitialized;
  set isInitialized(bool? isInitialized) =>
      _$this._isInitialized = isInitialized;

  bool? _isAdmin;
  bool? get isAdmin => _$this._isAdmin;
  set isAdmin(bool? isAdmin) => _$this._isAdmin = isAdmin;

  bool? _isAuthenticated;
  bool? get isAuthenticated => _$this._isAuthenticated;
  set isAuthenticated(bool? isAuthenticated) =>
      _$this._isAuthenticated = isAuthenticated;

  int? _lastEnteredPasswordAt;
  int? get lastEnteredPasswordAt => _$this._lastEnteredPasswordAt;
  set lastEnteredPasswordAt(int? lastEnteredPasswordAt) =>
      _$this._lastEnteredPasswordAt = lastEnteredPasswordAt;

  String? _referralCode;
  String? get referralCode => _$this._referralCode;
  set referralCode(String? referralCode) => _$this._referralCode = referralCode;

  bool? _phoneVerified;
  bool? get phoneVerified => _$this._phoneVerified;
  set phoneVerified(bool? phoneVerified) =>
      _$this._phoneVerified = phoneVerified;

  bool? _isEmailVerified;
  bool? get isEmailVerified => _$this._isEmailVerified;
  set isEmailVerified(bool? isEmailVerified) =>
      _$this._isEmailVerified = isEmailVerified;

  bool? _setProfileCompleted;
  bool? get setProfileCompleted => _$this._setProfileCompleted;
  set setProfileCompleted(bool? setProfileCompleted) =>
      _$this._setProfileCompleted = setProfileCompleted;

  bool? _isArchived;
  bool? get isArchived => _$this._isArchived;
  set isArchived(bool? isArchived) => _$this._isArchived = isArchived;

  String? _phoneVerificationId;
  String? get phoneVerificationId => _$this._phoneVerificationId;
  set phoneVerificationId(String? phoneVerificationId) =>
      _$this._phoneVerificationId = phoneVerificationId;

  bool? _isDialogLogin;
  bool? get isDialogLogin => _$this._isDialogLogin;
  set isDialogLogin(bool? isDialogLogin) =>
      _$this._isDialogLogin = isDialogLogin;

  String? _emailLinkAuthEmail;
  String? get emailLinkAuthEmail => _$this._emailLinkAuthEmail;
  set emailLinkAuthEmail(String? emailLinkAuthEmail) =>
      _$this._emailLinkAuthEmail = emailLinkAuthEmail;

  bool? _isEmailLinkAuth;
  bool? get isEmailLinkAuth => _$this._isEmailLinkAuth;
  set isEmailLinkAuth(bool? isEmailLinkAuth) =>
      _$this._isEmailLinkAuth = isEmailLinkAuth;

  String? _originator;
  String? get originator => _$this._originator;
  set originator(String? originator) => _$this._originator = originator;

  AuthStateBuilder() {
    AuthState._initializeBuilder(this);
  }

  AuthStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _email = $v.email;
      _currentUserName = $v.currentUserName;
      _currentUserId = $v.currentUserId;
      _url = $v.url;
      _isInitialized = $v.isInitialized;
      _isAdmin = $v.isAdmin;
      _isAuthenticated = $v.isAuthenticated;
      _lastEnteredPasswordAt = $v.lastEnteredPasswordAt;
      _referralCode = $v.referralCode;
      _phoneVerified = $v.phoneVerified;
      _isEmailVerified = $v.isEmailVerified;
      _setProfileCompleted = $v.setProfileCompleted;
      _isArchived = $v.isArchived;
      _phoneVerificationId = $v.phoneVerificationId;
      _isDialogLogin = $v.isDialogLogin;
      _emailLinkAuthEmail = $v.emailLinkAuthEmail;
      _isEmailLinkAuth = $v.isEmailLinkAuth;
      _originator = $v.originator;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AuthState other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$AuthState;
  }

  @override
  void update(void Function(AuthStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AuthState build() => _build();

  _$AuthState _build() {
    final _$result = _$v ??
        new _$AuthState._(
            email: BuiltValueNullFieldError.checkNotNull(
                email, r'AuthState', 'email'),
            currentUserName: BuiltValueNullFieldError.checkNotNull(
                currentUserName, r'AuthState', 'currentUserName'),
            currentUserId: BuiltValueNullFieldError.checkNotNull(
                currentUserId, r'AuthState', 'currentUserId'),
            url:
                BuiltValueNullFieldError.checkNotNull(url, r'AuthState', 'url'),
            isInitialized: BuiltValueNullFieldError.checkNotNull(
                isInitialized, r'AuthState', 'isInitialized'),
            isAdmin: BuiltValueNullFieldError.checkNotNull(
                isAdmin, r'AuthState', 'isAdmin'),
            isAuthenticated: BuiltValueNullFieldError.checkNotNull(
                isAuthenticated, r'AuthState', 'isAuthenticated'),
            lastEnteredPasswordAt: BuiltValueNullFieldError.checkNotNull(
                lastEnteredPasswordAt, r'AuthState', 'lastEnteredPasswordAt'),
            referralCode: BuiltValueNullFieldError.checkNotNull(
                referralCode, r'AuthState', 'referralCode'),
            phoneVerified: BuiltValueNullFieldError.checkNotNull(phoneVerified, r'AuthState', 'phoneVerified'),
            isEmailVerified: BuiltValueNullFieldError.checkNotNull(isEmailVerified, r'AuthState', 'isEmailVerified'),
            setProfileCompleted: BuiltValueNullFieldError.checkNotNull(setProfileCompleted, r'AuthState', 'setProfileCompleted'),
            isArchived: BuiltValueNullFieldError.checkNotNull(isArchived, r'AuthState', 'isArchived'),
            phoneVerificationId: BuiltValueNullFieldError.checkNotNull(phoneVerificationId, r'AuthState', 'phoneVerificationId'),
            isDialogLogin: BuiltValueNullFieldError.checkNotNull(isDialogLogin, r'AuthState', 'isDialogLogin'),
            emailLinkAuthEmail: BuiltValueNullFieldError.checkNotNull(emailLinkAuthEmail, r'AuthState', 'emailLinkAuthEmail'),
            isEmailLinkAuth: BuiltValueNullFieldError.checkNotNull(isEmailLinkAuth, r'AuthState', 'isEmailLinkAuth'),
            originator: BuiltValueNullFieldError.checkNotNull(originator, r'AuthState', 'originator'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
