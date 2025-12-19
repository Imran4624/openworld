// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<UserCompanyState> _$userCompanyStateSerializer =
    new _$UserCompanyStateSerializer();

class _$UserCompanyStateSerializer
    implements StructuredSerializer<UserCompanyState> {
  @override
  final Iterable<Type> types = const [UserCompanyState, _$UserCompanyState];
  @override
  final String wireName = 'UserCompanyState';

  @override
  Iterable<Object?> serialize(Serializers serializers, UserCompanyState object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'lastUpdated',
      serializers.serialize(object.lastUpdated,
          specifiedType: const FullType(int)),
      'selectedCompanyId',
      serializers.serialize(object.selectedCompanyId,
          specifiedType: const FullType(String)),
      'userCompany',
      serializers.serialize(object.userCompany,
          specifiedType: const FullType(UserCompanyEntity)),
      'paymentState',
      serializers.serialize(object.paymentState,
          specifiedType: const FullType(PaymentState)),
      'productState',
      serializers.serialize(object.productState,
          specifiedType: const FullType(ProductState)),
      'socialState',
      serializers.serialize(object.socialState,
          specifiedType: const FullType(SocialState)),
      'photoState',
      serializers.serialize(object.photoState,
          specifiedType: const FullType(PhotoState)),
      'workoutState',
      serializers.serialize(object.workoutState,
          specifiedType: const FullType(WorkoutState)),
      'notificationState',
      serializers.serialize(object.notificationState,
          specifiedType: const FullType(NotificationState)),
      'profileOperationState',
      serializers.serialize(object.profileOperationState,
          specifiedType: const FullType(ProfileOperationState)),
      'profileState',
      serializers.serialize(object.profileState,
          specifiedType: const FullType(ProfileState)),
      'eventState',
      serializers.serialize(object.eventState,
          specifiedType: const FullType(EventState)),
      'chatState',
      serializers.serialize(object.chatState,
          specifiedType: const FullType(ChatState)),
      'dynamicFieldState',
      serializers.serialize(object.dynamicFieldState,
          specifiedType: const FullType(DynamicFieldState)),
      'designState',
      serializers.serialize(object.designState,
          specifiedType: const FullType(DesignState)),
      'userState',
      serializers.serialize(object.userState,
          specifiedType: const FullType(UserState)),
    ];

    return result;
  }

  @override
  UserCompanyState deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new UserCompanyStateBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'lastUpdated':
          result.lastUpdated = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'selectedCompanyId':
          result.selectedCompanyId = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'userCompany':
          result.userCompany.replace(serializers.deserialize(value,
                  specifiedType: const FullType(UserCompanyEntity))!
              as UserCompanyEntity);
          break;
        case 'paymentState':
          result.paymentState.replace(serializers.deserialize(value,
              specifiedType: const FullType(PaymentState))! as PaymentState);
          break;
        case 'productState':
          result.productState.replace(serializers.deserialize(value,
              specifiedType: const FullType(ProductState))! as ProductState);
          break;
        case 'socialState':
          result.socialState.replace(serializers.deserialize(value,
              specifiedType: const FullType(SocialState))! as SocialState);
          break;
        case 'photoState':
          result.photoState.replace(serializers.deserialize(value,
              specifiedType: const FullType(PhotoState))! as PhotoState);
          break;
        case 'workoutState':
          result.workoutState.replace(serializers.deserialize(value,
              specifiedType: const FullType(WorkoutState))! as WorkoutState);
          break;
        case 'notificationState':
          result.notificationState.replace(serializers.deserialize(value,
                  specifiedType: const FullType(NotificationState))!
              as NotificationState);
          break;
        case 'profileOperationState':
          result.profileOperationState.replace(serializers.deserialize(value,
                  specifiedType: const FullType(ProfileOperationState))!
              as ProfileOperationState);
          break;
        case 'profileState':
          result.profileState.replace(serializers.deserialize(value,
              specifiedType: const FullType(ProfileState))! as ProfileState);
          break;
        case 'eventState':
          result.eventState.replace(serializers.deserialize(value,
              specifiedType: const FullType(EventState))! as EventState);
          break;
        case 'chatState':
          result.chatState.replace(serializers.deserialize(value,
              specifiedType: const FullType(ChatState))! as ChatState);
          break;
        case 'dynamicFieldState':
          result.dynamicFieldState.replace(serializers.deserialize(value,
                  specifiedType: const FullType(DynamicFieldState))!
              as DynamicFieldState);
          break;
        case 'designState':
          result.designState.replace(serializers.deserialize(value,
              specifiedType: const FullType(DesignState))! as DesignState);
          break;
        case 'userState':
          result.userState.replace(serializers.deserialize(value,
              specifiedType: const FullType(UserState))! as UserState);
          break;
      }
    }

    return result.build();
  }
}

class _$UserCompanyState extends UserCompanyState {
  @override
  final int lastUpdated;
  @override
  final String selectedCompanyId;
  @override
  final UserCompanyEntity userCompany;
  @override
  final PaymentState paymentState;
  @override
  final ProductState productState;
  @override
  final SocialState socialState;
  @override
  final PhotoState photoState;
  @override
  final WorkoutState workoutState;
  @override
  final NotificationState notificationState;
  @override
  final ProfileOperationState profileOperationState;
  @override
  final ProfileState profileState;
  @override
  final EventState eventState;
  @override
  final ChatState chatState;
  @override
  final DynamicFieldState dynamicFieldState;
  @override
  final DesignState designState;
  @override
  final UserState userState;

  factory _$UserCompanyState(
          [void Function(UserCompanyStateBuilder)? updates]) =>
      (new UserCompanyStateBuilder()..update(updates))._build();

  _$UserCompanyState._(
      {required this.lastUpdated,
      required this.selectedCompanyId,
      required this.userCompany,
      required this.paymentState,
      required this.productState,
      required this.socialState,
      required this.photoState,
      required this.workoutState,
      required this.notificationState,
      required this.profileOperationState,
      required this.profileState,
      required this.eventState,
      required this.chatState,
      required this.dynamicFieldState,
      required this.designState,
      required this.userState})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        lastUpdated, r'UserCompanyState', 'lastUpdated');
    BuiltValueNullFieldError.checkNotNull(
        selectedCompanyId, r'UserCompanyState', 'selectedCompanyId');
    BuiltValueNullFieldError.checkNotNull(
        userCompany, r'UserCompanyState', 'userCompany');
    BuiltValueNullFieldError.checkNotNull(
        paymentState, r'UserCompanyState', 'paymentState');
    BuiltValueNullFieldError.checkNotNull(
        productState, r'UserCompanyState', 'productState');
    BuiltValueNullFieldError.checkNotNull(
        socialState, r'UserCompanyState', 'socialState');
    BuiltValueNullFieldError.checkNotNull(
        photoState, r'UserCompanyState', 'photoState');
    BuiltValueNullFieldError.checkNotNull(
        workoutState, r'UserCompanyState', 'workoutState');
    BuiltValueNullFieldError.checkNotNull(
        notificationState, r'UserCompanyState', 'notificationState');
    BuiltValueNullFieldError.checkNotNull(
        profileOperationState, r'UserCompanyState', 'profileOperationState');
    BuiltValueNullFieldError.checkNotNull(
        profileState, r'UserCompanyState', 'profileState');
    BuiltValueNullFieldError.checkNotNull(
        eventState, r'UserCompanyState', 'eventState');
    BuiltValueNullFieldError.checkNotNull(
        chatState, r'UserCompanyState', 'chatState');
    BuiltValueNullFieldError.checkNotNull(
        dynamicFieldState, r'UserCompanyState', 'dynamicFieldState');
    BuiltValueNullFieldError.checkNotNull(
        designState, r'UserCompanyState', 'designState');
    BuiltValueNullFieldError.checkNotNull(
        userState, r'UserCompanyState', 'userState');
  }

  @override
  UserCompanyState rebuild(void Function(UserCompanyStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserCompanyStateBuilder toBuilder() =>
      new UserCompanyStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserCompanyState &&
        lastUpdated == other.lastUpdated &&
        selectedCompanyId == other.selectedCompanyId &&
        userCompany == other.userCompany &&
        paymentState == other.paymentState &&
        productState == other.productState &&
        socialState == other.socialState &&
        photoState == other.photoState &&
        workoutState == other.workoutState &&
        notificationState == other.notificationState &&
        profileOperationState == other.profileOperationState &&
        profileState == other.profileState &&
        eventState == other.eventState &&
        chatState == other.chatState &&
        dynamicFieldState == other.dynamicFieldState &&
        designState == other.designState &&
        userState == other.userState;
  }

  int? __hashCode;
  @override
  int get hashCode {
    if (__hashCode != null) return __hashCode!;
    var _$hash = 0;
    _$hash = $jc(_$hash, lastUpdated.hashCode);
    _$hash = $jc(_$hash, selectedCompanyId.hashCode);
    _$hash = $jc(_$hash, userCompany.hashCode);
    _$hash = $jc(_$hash, paymentState.hashCode);
    _$hash = $jc(_$hash, productState.hashCode);
    _$hash = $jc(_$hash, socialState.hashCode);
    _$hash = $jc(_$hash, photoState.hashCode);
    _$hash = $jc(_$hash, workoutState.hashCode);
    _$hash = $jc(_$hash, notificationState.hashCode);
    _$hash = $jc(_$hash, profileOperationState.hashCode);
    _$hash = $jc(_$hash, profileState.hashCode);
    _$hash = $jc(_$hash, eventState.hashCode);
    _$hash = $jc(_$hash, chatState.hashCode);
    _$hash = $jc(_$hash, dynamicFieldState.hashCode);
    _$hash = $jc(_$hash, designState.hashCode);
    _$hash = $jc(_$hash, userState.hashCode);
    _$hash = $jf(_$hash);
    return __hashCode ??= _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UserCompanyState')
          ..add('lastUpdated', lastUpdated)
          ..add('selectedCompanyId', selectedCompanyId)
          ..add('userCompany', userCompany)
          ..add('paymentState', paymentState)
          ..add('productState', productState)
          ..add('socialState', socialState)
          ..add('photoState', photoState)
          ..add('workoutState', workoutState)
          ..add('notificationState', notificationState)
          ..add('profileOperationState', profileOperationState)
          ..add('profileState', profileState)
          ..add('eventState', eventState)
          ..add('chatState', chatState)
          ..add('dynamicFieldState', dynamicFieldState)
          ..add('designState', designState)
          ..add('userState', userState))
        .toString();
  }
}

class UserCompanyStateBuilder
    implements Builder<UserCompanyState, UserCompanyStateBuilder> {
  _$UserCompanyState? _$v;

  int? _lastUpdated;
  int? get lastUpdated => _$this._lastUpdated;
  set lastUpdated(int? lastUpdated) => _$this._lastUpdated = lastUpdated;

  String? _selectedCompanyId;
  String? get selectedCompanyId => _$this._selectedCompanyId;
  set selectedCompanyId(String? selectedCompanyId) =>
      _$this._selectedCompanyId = selectedCompanyId;

  UserCompanyEntityBuilder? _userCompany;
  UserCompanyEntityBuilder get userCompany =>
      _$this._userCompany ??= new UserCompanyEntityBuilder();
  set userCompany(UserCompanyEntityBuilder? userCompany) =>
      _$this._userCompany = userCompany;

  PaymentStateBuilder? _paymentState;
  PaymentStateBuilder get paymentState =>
      _$this._paymentState ??= new PaymentStateBuilder();
  set paymentState(PaymentStateBuilder? paymentState) =>
      _$this._paymentState = paymentState;

  ProductStateBuilder? _productState;
  ProductStateBuilder get productState =>
      _$this._productState ??= new ProductStateBuilder();
  set productState(ProductStateBuilder? productState) =>
      _$this._productState = productState;

  SocialStateBuilder? _socialState;
  SocialStateBuilder get socialState =>
      _$this._socialState ??= new SocialStateBuilder();
  set socialState(SocialStateBuilder? socialState) =>
      _$this._socialState = socialState;

  PhotoStateBuilder? _photoState;
  PhotoStateBuilder get photoState =>
      _$this._photoState ??= new PhotoStateBuilder();
  set photoState(PhotoStateBuilder? photoState) =>
      _$this._photoState = photoState;

  WorkoutStateBuilder? _workoutState;
  WorkoutStateBuilder get workoutState =>
      _$this._workoutState ??= new WorkoutStateBuilder();
  set workoutState(WorkoutStateBuilder? workoutState) =>
      _$this._workoutState = workoutState;

  NotificationStateBuilder? _notificationState;
  NotificationStateBuilder get notificationState =>
      _$this._notificationState ??= new NotificationStateBuilder();
  set notificationState(NotificationStateBuilder? notificationState) =>
      _$this._notificationState = notificationState;

  ProfileOperationStateBuilder? _profileOperationState;
  ProfileOperationStateBuilder get profileOperationState =>
      _$this._profileOperationState ??= new ProfileOperationStateBuilder();
  set profileOperationState(
          ProfileOperationStateBuilder? profileOperationState) =>
      _$this._profileOperationState = profileOperationState;

  ProfileStateBuilder? _profileState;
  ProfileStateBuilder get profileState =>
      _$this._profileState ??= new ProfileStateBuilder();
  set profileState(ProfileStateBuilder? profileState) =>
      _$this._profileState = profileState;

  EventStateBuilder? _eventState;
  EventStateBuilder get eventState =>
      _$this._eventState ??= new EventStateBuilder();
  set eventState(EventStateBuilder? eventState) =>
      _$this._eventState = eventState;

  ChatStateBuilder? _chatState;
  ChatStateBuilder get chatState =>
      _$this._chatState ??= new ChatStateBuilder();
  set chatState(ChatStateBuilder? chatState) => _$this._chatState = chatState;

  DynamicFieldStateBuilder? _dynamicFieldState;
  DynamicFieldStateBuilder get dynamicFieldState =>
      _$this._dynamicFieldState ??= new DynamicFieldStateBuilder();
  set dynamicFieldState(DynamicFieldStateBuilder? dynamicFieldState) =>
      _$this._dynamicFieldState = dynamicFieldState;

  DesignStateBuilder? _designState;
  DesignStateBuilder get designState =>
      _$this._designState ??= new DesignStateBuilder();
  set designState(DesignStateBuilder? designState) =>
      _$this._designState = designState;

  UserStateBuilder? _userState;
  UserStateBuilder get userState =>
      _$this._userState ??= new UserStateBuilder();
  set userState(UserStateBuilder? userState) => _$this._userState = userState;

  UserCompanyStateBuilder();

  UserCompanyStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lastUpdated = $v.lastUpdated;
      _selectedCompanyId = $v.selectedCompanyId;
      _userCompany = $v.userCompany.toBuilder();
      _paymentState = $v.paymentState.toBuilder();
      _productState = $v.productState.toBuilder();
      _socialState = $v.socialState.toBuilder();
      _photoState = $v.photoState.toBuilder();
      _workoutState = $v.workoutState.toBuilder();
      _notificationState = $v.notificationState.toBuilder();
      _profileOperationState = $v.profileOperationState.toBuilder();
      _profileState = $v.profileState.toBuilder();
      _eventState = $v.eventState.toBuilder();
      _chatState = $v.chatState.toBuilder();
      _dynamicFieldState = $v.dynamicFieldState.toBuilder();
      _designState = $v.designState.toBuilder();
      _userState = $v.userState.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserCompanyState other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$UserCompanyState;
  }

  @override
  void update(void Function(UserCompanyStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserCompanyState build() => _build();

  _$UserCompanyState _build() {
    _$UserCompanyState _$result;
    try {
      _$result = _$v ??
          new _$UserCompanyState._(
              lastUpdated: BuiltValueNullFieldError.checkNotNull(
                  lastUpdated, r'UserCompanyState', 'lastUpdated'),
              selectedCompanyId: BuiltValueNullFieldError.checkNotNull(
                  selectedCompanyId, r'UserCompanyState', 'selectedCompanyId'),
              userCompany: userCompany.build(),
              paymentState: paymentState.build(),
              productState: productState.build(),
              socialState: socialState.build(),
              photoState: photoState.build(),
              workoutState: workoutState.build(),
              notificationState: notificationState.build(),
              profileOperationState: profileOperationState.build(),
              profileState: profileState.build(),
              eventState: eventState.build(),
              chatState: chatState.build(),
              dynamicFieldState: dynamicFieldState.build(),
              designState: designState.build(),
              userState: userState.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'userCompany';
        userCompany.build();
        _$failedField = 'paymentState';
        paymentState.build();
        _$failedField = 'productState';
        productState.build();
        _$failedField = 'socialState';
        socialState.build();
        _$failedField = 'photoState';
        photoState.build();
        _$failedField = 'workoutState';
        workoutState.build();
        _$failedField = 'notificationState';
        notificationState.build();
        _$failedField = 'profileOperationState';
        profileOperationState.build();
        _$failedField = 'profileState';
        profileState.build();
        _$failedField = 'eventState';
        eventState.build();
        _$failedField = 'chatState';
        chatState.build();
        _$failedField = 'dynamicFieldState';
        dynamicFieldState.build();
        _$failedField = 'designState';
        designState.build();
        _$failedField = 'userState';
        userState.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'UserCompanyState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
