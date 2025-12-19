// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ui_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<UIState> _$uIStateSerializer = new _$UIStateSerializer();

class _$UIStateSerializer implements StructuredSerializer<UIState> {
  @override
  final Iterable<Type> types = const [UIState, _$UIState];
  @override
  final String wireName = 'UIState';

  @override
  Iterable<Object?> serialize(Serializers serializers, UIState object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'selectedCompanyIndex',
      serializers.serialize(object.selectedCompanyIndex,
          specifiedType: const FullType(int)),
      'currentRoute',
      serializers.serialize(object.currentRoute,
          specifiedType: const FullType(String)),
      'previousRoute',
      serializers.serialize(object.previousRoute,
          specifiedType: const FullType(String)),
      'dismissedFlutterWebWarning',
      serializers.serialize(object.dismissedFlutterWebWarning,
          specifiedType: const FullType(bool)),
      'previewStack',
      serializers.serialize(object.previewStack,
          specifiedType:
              const FullType(BuiltList, const [const FullType(EntityType)])),
      'filterStack',
      serializers.serialize(object.filterStack,
          specifiedType:
              const FullType(BuiltList, const [const FullType(BaseEntity)])),
      'filterClearedAt',
      serializers.serialize(object.filterClearedAt,
          specifiedType: const FullType(int)),
      'lastActivityAt',
      serializers.serialize(object.lastActivityAt,
          specifiedType: const FullType(int)),
      'dashboardUIState',
      serializers.serialize(object.dashboardUIState,
          specifiedType: const FullType(DashboardUIState)),
      'paymentUIState',
      serializers.serialize(object.paymentUIState,
          specifiedType: const FullType(PaymentUIState)),
      'productUIState',
      serializers.serialize(object.productUIState,
          specifiedType: const FullType(ProductUIState)),
      'socialUIState',
      serializers.serialize(object.socialUIState,
          specifiedType: const FullType(SocialUIState)),
      'photoUIState',
      serializers.serialize(object.photoUIState,
          specifiedType: const FullType(PhotoUIState)),
      'workoutUIState',
      serializers.serialize(object.workoutUIState,
          specifiedType: const FullType(WorkoutUIState)),
      'notificationUIState',
      serializers.serialize(object.notificationUIState,
          specifiedType: const FullType(NotificationUIState)),
      'profileOperationUIState',
      serializers.serialize(object.profileOperationUIState,
          specifiedType: const FullType(ProfileOperationUIState)),
      'profileUIState',
      serializers.serialize(object.profileUIState,
          specifiedType: const FullType(ProfileUIState)),
      'eventUIState',
      serializers.serialize(object.eventUIState,
          specifiedType: const FullType(EventUIState)),
      'chatUIState',
      serializers.serialize(object.chatUIState,
          specifiedType: const FullType(ChatUIState)),
      'designUIState',
      serializers.serialize(object.designUIState,
          specifiedType: const FullType(DesignUIState)),
      'userUIState',
      serializers.serialize(object.userUIState,
          specifiedType: const FullType(UserUIState)),
      'settingsUIState',
      serializers.serialize(object.settingsUIState,
          specifiedType: const FullType(SettingsUIState)),
    ];
    Object? value;
    value = object.loadingEntityType;
    if (value != null) {
      result
        ..add('loadingEntityType')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(EntityType)));
    }
    value = object.filter;
    if (value != null) {
      result
        ..add('filter')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  UIState deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new UIStateBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'selectedCompanyIndex':
          result.selectedCompanyIndex = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'currentRoute':
          result.currentRoute = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'previousRoute':
          result.previousRoute = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'dismissedFlutterWebWarning':
          result.dismissedFlutterWebWarning = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
        case 'loadingEntityType':
          result.loadingEntityType = serializers.deserialize(value,
              specifiedType: const FullType(EntityType)) as EntityType?;
          break;
        case 'previewStack':
          result.previewStack.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(EntityType)]))!
              as BuiltList<Object?>);
          break;
        case 'filterStack':
          result.filterStack.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(BaseEntity)]))!
              as BuiltList<Object?>);
          break;
        case 'filter':
          result.filter = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'filterClearedAt':
          result.filterClearedAt = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'lastActivityAt':
          result.lastActivityAt = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'dashboardUIState':
          result.dashboardUIState.replace(serializers.deserialize(value,
                  specifiedType: const FullType(DashboardUIState))!
              as DashboardUIState);
          break;
        case 'paymentUIState':
          result.paymentUIState.replace(serializers.deserialize(value,
                  specifiedType: const FullType(PaymentUIState))!
              as PaymentUIState);
          break;
        case 'productUIState':
          result.productUIState.replace(serializers.deserialize(value,
                  specifiedType: const FullType(ProductUIState))!
              as ProductUIState);
          break;
        case 'socialUIState':
          result.socialUIState.replace(serializers.deserialize(value,
              specifiedType: const FullType(SocialUIState))! as SocialUIState);
          break;
        case 'photoUIState':
          result.photoUIState.replace(serializers.deserialize(value,
              specifiedType: const FullType(PhotoUIState))! as PhotoUIState);
          break;
        case 'workoutUIState':
          result.workoutUIState.replace(serializers.deserialize(value,
                  specifiedType: const FullType(WorkoutUIState))!
              as WorkoutUIState);
          break;
        case 'notificationUIState':
          result.notificationUIState.replace(serializers.deserialize(value,
                  specifiedType: const FullType(NotificationUIState))!
              as NotificationUIState);
          break;
        case 'profileOperationUIState':
          result.profileOperationUIState.replace(serializers.deserialize(value,
                  specifiedType: const FullType(ProfileOperationUIState))!
              as ProfileOperationUIState);
          break;
        case 'profileUIState':
          result.profileUIState.replace(serializers.deserialize(value,
                  specifiedType: const FullType(ProfileUIState))!
              as ProfileUIState);
          break;
        case 'eventUIState':
          result.eventUIState.replace(serializers.deserialize(value,
              specifiedType: const FullType(EventUIState))! as EventUIState);
          break;
        case 'chatUIState':
          result.chatUIState.replace(serializers.deserialize(value,
              specifiedType: const FullType(ChatUIState))! as ChatUIState);
          break;
        case 'designUIState':
          result.designUIState.replace(serializers.deserialize(value,
              specifiedType: const FullType(DesignUIState))! as DesignUIState);
          break;
        case 'userUIState':
          result.userUIState.replace(serializers.deserialize(value,
              specifiedType: const FullType(UserUIState))! as UserUIState);
          break;
        case 'settingsUIState':
          result.settingsUIState.replace(serializers.deserialize(value,
                  specifiedType: const FullType(SettingsUIState))!
              as SettingsUIState);
          break;
      }
    }

    return result.build();
  }
}

class _$UIState extends UIState {
  @override
  final int selectedCompanyIndex;
  @override
  final String currentRoute;
  @override
  final String previousRoute;
  @override
  final bool dismissedFlutterWebWarning;
  @override
  final EntityType? loadingEntityType;
  @override
  final BuiltList<EntityType> previewStack;
  @override
  final BuiltList<BaseEntity> filterStack;
  @override
  final String? filter;
  @override
  final int filterClearedAt;
  @override
  final int lastActivityAt;
  @override
  final DashboardUIState dashboardUIState;
  @override
  final PaymentUIState paymentUIState;
  @override
  final ProductUIState productUIState;
  @override
  final SocialUIState socialUIState;
  @override
  final PhotoUIState photoUIState;
  @override
  final WorkoutUIState workoutUIState;
  @override
  final NotificationUIState notificationUIState;
  @override
  final ProfileOperationUIState profileOperationUIState;
  @override
  final ProfileUIState profileUIState;
  @override
  final EventUIState eventUIState;
  @override
  final ChatUIState chatUIState;
  @override
  final DesignUIState designUIState;
  @override
  final UserUIState userUIState;
  @override
  final SettingsUIState settingsUIState;

  factory _$UIState([void Function(UIStateBuilder)? updates]) =>
      (new UIStateBuilder()..update(updates))._build();

  _$UIState._(
      {required this.selectedCompanyIndex,
      required this.currentRoute,
      required this.previousRoute,
      required this.dismissedFlutterWebWarning,
      this.loadingEntityType,
      required this.previewStack,
      required this.filterStack,
      this.filter,
      required this.filterClearedAt,
      required this.lastActivityAt,
      required this.dashboardUIState,
      required this.paymentUIState,
      required this.productUIState,
      required this.socialUIState,
      required this.photoUIState,
      required this.workoutUIState,
      required this.notificationUIState,
      required this.profileOperationUIState,
      required this.profileUIState,
      required this.eventUIState,
      required this.chatUIState,
      required this.designUIState,
      required this.userUIState,
      required this.settingsUIState})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        selectedCompanyIndex, r'UIState', 'selectedCompanyIndex');
    BuiltValueNullFieldError.checkNotNull(
        currentRoute, r'UIState', 'currentRoute');
    BuiltValueNullFieldError.checkNotNull(
        previousRoute, r'UIState', 'previousRoute');
    BuiltValueNullFieldError.checkNotNull(
        dismissedFlutterWebWarning, r'UIState', 'dismissedFlutterWebWarning');
    BuiltValueNullFieldError.checkNotNull(
        previewStack, r'UIState', 'previewStack');
    BuiltValueNullFieldError.checkNotNull(
        filterStack, r'UIState', 'filterStack');
    BuiltValueNullFieldError.checkNotNull(
        filterClearedAt, r'UIState', 'filterClearedAt');
    BuiltValueNullFieldError.checkNotNull(
        lastActivityAt, r'UIState', 'lastActivityAt');
    BuiltValueNullFieldError.checkNotNull(
        dashboardUIState, r'UIState', 'dashboardUIState');
    BuiltValueNullFieldError.checkNotNull(
        paymentUIState, r'UIState', 'paymentUIState');
    BuiltValueNullFieldError.checkNotNull(
        productUIState, r'UIState', 'productUIState');
    BuiltValueNullFieldError.checkNotNull(
        socialUIState, r'UIState', 'socialUIState');
    BuiltValueNullFieldError.checkNotNull(
        photoUIState, r'UIState', 'photoUIState');
    BuiltValueNullFieldError.checkNotNull(
        workoutUIState, r'UIState', 'workoutUIState');
    BuiltValueNullFieldError.checkNotNull(
        notificationUIState, r'UIState', 'notificationUIState');
    BuiltValueNullFieldError.checkNotNull(
        profileOperationUIState, r'UIState', 'profileOperationUIState');
    BuiltValueNullFieldError.checkNotNull(
        profileUIState, r'UIState', 'profileUIState');
    BuiltValueNullFieldError.checkNotNull(
        eventUIState, r'UIState', 'eventUIState');
    BuiltValueNullFieldError.checkNotNull(
        chatUIState, r'UIState', 'chatUIState');
    BuiltValueNullFieldError.checkNotNull(
        designUIState, r'UIState', 'designUIState');
    BuiltValueNullFieldError.checkNotNull(
        userUIState, r'UIState', 'userUIState');
    BuiltValueNullFieldError.checkNotNull(
        settingsUIState, r'UIState', 'settingsUIState');
  }

  @override
  UIState rebuild(void Function(UIStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UIStateBuilder toBuilder() => new UIStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UIState &&
        selectedCompanyIndex == other.selectedCompanyIndex &&
        currentRoute == other.currentRoute &&
        previousRoute == other.previousRoute &&
        dismissedFlutterWebWarning == other.dismissedFlutterWebWarning &&
        loadingEntityType == other.loadingEntityType &&
        previewStack == other.previewStack &&
        filterStack == other.filterStack &&
        filter == other.filter &&
        filterClearedAt == other.filterClearedAt &&
        lastActivityAt == other.lastActivityAt &&
        dashboardUIState == other.dashboardUIState &&
        paymentUIState == other.paymentUIState &&
        productUIState == other.productUIState &&
        socialUIState == other.socialUIState &&
        photoUIState == other.photoUIState &&
        workoutUIState == other.workoutUIState &&
        notificationUIState == other.notificationUIState &&
        profileOperationUIState == other.profileOperationUIState &&
        profileUIState == other.profileUIState &&
        eventUIState == other.eventUIState &&
        chatUIState == other.chatUIState &&
        designUIState == other.designUIState &&
        userUIState == other.userUIState &&
        settingsUIState == other.settingsUIState;
  }

  int? __hashCode;
  @override
  int get hashCode {
    if (__hashCode != null) return __hashCode!;
    var _$hash = 0;
    _$hash = $jc(_$hash, selectedCompanyIndex.hashCode);
    _$hash = $jc(_$hash, currentRoute.hashCode);
    _$hash = $jc(_$hash, previousRoute.hashCode);
    _$hash = $jc(_$hash, dismissedFlutterWebWarning.hashCode);
    _$hash = $jc(_$hash, loadingEntityType.hashCode);
    _$hash = $jc(_$hash, previewStack.hashCode);
    _$hash = $jc(_$hash, filterStack.hashCode);
    _$hash = $jc(_$hash, filter.hashCode);
    _$hash = $jc(_$hash, filterClearedAt.hashCode);
    _$hash = $jc(_$hash, lastActivityAt.hashCode);
    _$hash = $jc(_$hash, dashboardUIState.hashCode);
    _$hash = $jc(_$hash, paymentUIState.hashCode);
    _$hash = $jc(_$hash, productUIState.hashCode);
    _$hash = $jc(_$hash, socialUIState.hashCode);
    _$hash = $jc(_$hash, photoUIState.hashCode);
    _$hash = $jc(_$hash, workoutUIState.hashCode);
    _$hash = $jc(_$hash, notificationUIState.hashCode);
    _$hash = $jc(_$hash, profileOperationUIState.hashCode);
    _$hash = $jc(_$hash, profileUIState.hashCode);
    _$hash = $jc(_$hash, eventUIState.hashCode);
    _$hash = $jc(_$hash, chatUIState.hashCode);
    _$hash = $jc(_$hash, designUIState.hashCode);
    _$hash = $jc(_$hash, userUIState.hashCode);
    _$hash = $jc(_$hash, settingsUIState.hashCode);
    _$hash = $jf(_$hash);
    return __hashCode ??= _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UIState')
          ..add('selectedCompanyIndex', selectedCompanyIndex)
          ..add('currentRoute', currentRoute)
          ..add('previousRoute', previousRoute)
          ..add('dismissedFlutterWebWarning', dismissedFlutterWebWarning)
          ..add('loadingEntityType', loadingEntityType)
          ..add('previewStack', previewStack)
          ..add('filterStack', filterStack)
          ..add('filter', filter)
          ..add('filterClearedAt', filterClearedAt)
          ..add('lastActivityAt', lastActivityAt)
          ..add('dashboardUIState', dashboardUIState)
          ..add('paymentUIState', paymentUIState)
          ..add('productUIState', productUIState)
          ..add('socialUIState', socialUIState)
          ..add('photoUIState', photoUIState)
          ..add('workoutUIState', workoutUIState)
          ..add('notificationUIState', notificationUIState)
          ..add('profileOperationUIState', profileOperationUIState)
          ..add('profileUIState', profileUIState)
          ..add('eventUIState', eventUIState)
          ..add('chatUIState', chatUIState)
          ..add('designUIState', designUIState)
          ..add('userUIState', userUIState)
          ..add('settingsUIState', settingsUIState))
        .toString();
  }
}

class UIStateBuilder implements Builder<UIState, UIStateBuilder> {
  _$UIState? _$v;

  int? _selectedCompanyIndex;
  int? get selectedCompanyIndex => _$this._selectedCompanyIndex;
  set selectedCompanyIndex(int? selectedCompanyIndex) =>
      _$this._selectedCompanyIndex = selectedCompanyIndex;

  String? _currentRoute;
  String? get currentRoute => _$this._currentRoute;
  set currentRoute(String? currentRoute) => _$this._currentRoute = currentRoute;

  String? _previousRoute;
  String? get previousRoute => _$this._previousRoute;
  set previousRoute(String? previousRoute) =>
      _$this._previousRoute = previousRoute;

  bool? _dismissedFlutterWebWarning;
  bool? get dismissedFlutterWebWarning => _$this._dismissedFlutterWebWarning;
  set dismissedFlutterWebWarning(bool? dismissedFlutterWebWarning) =>
      _$this._dismissedFlutterWebWarning = dismissedFlutterWebWarning;

  EntityType? _loadingEntityType;
  EntityType? get loadingEntityType => _$this._loadingEntityType;
  set loadingEntityType(EntityType? loadingEntityType) =>
      _$this._loadingEntityType = loadingEntityType;

  ListBuilder<EntityType>? _previewStack;
  ListBuilder<EntityType> get previewStack =>
      _$this._previewStack ??= new ListBuilder<EntityType>();
  set previewStack(ListBuilder<EntityType>? previewStack) =>
      _$this._previewStack = previewStack;

  ListBuilder<BaseEntity>? _filterStack;
  ListBuilder<BaseEntity> get filterStack =>
      _$this._filterStack ??= new ListBuilder<BaseEntity>();
  set filterStack(ListBuilder<BaseEntity>? filterStack) =>
      _$this._filterStack = filterStack;

  String? _filter;
  String? get filter => _$this._filter;
  set filter(String? filter) => _$this._filter = filter;

  int? _filterClearedAt;
  int? get filterClearedAt => _$this._filterClearedAt;
  set filterClearedAt(int? filterClearedAt) =>
      _$this._filterClearedAt = filterClearedAt;

  int? _lastActivityAt;
  int? get lastActivityAt => _$this._lastActivityAt;
  set lastActivityAt(int? lastActivityAt) =>
      _$this._lastActivityAt = lastActivityAt;

  DashboardUIStateBuilder? _dashboardUIState;
  DashboardUIStateBuilder get dashboardUIState =>
      _$this._dashboardUIState ??= new DashboardUIStateBuilder();
  set dashboardUIState(DashboardUIStateBuilder? dashboardUIState) =>
      _$this._dashboardUIState = dashboardUIState;

  PaymentUIStateBuilder? _paymentUIState;
  PaymentUIStateBuilder get paymentUIState =>
      _$this._paymentUIState ??= new PaymentUIStateBuilder();
  set paymentUIState(PaymentUIStateBuilder? paymentUIState) =>
      _$this._paymentUIState = paymentUIState;

  ProductUIStateBuilder? _productUIState;
  ProductUIStateBuilder get productUIState =>
      _$this._productUIState ??= new ProductUIStateBuilder();
  set productUIState(ProductUIStateBuilder? productUIState) =>
      _$this._productUIState = productUIState;

  SocialUIStateBuilder? _socialUIState;
  SocialUIStateBuilder get socialUIState =>
      _$this._socialUIState ??= new SocialUIStateBuilder();
  set socialUIState(SocialUIStateBuilder? socialUIState) =>
      _$this._socialUIState = socialUIState;

  PhotoUIStateBuilder? _photoUIState;
  PhotoUIStateBuilder get photoUIState =>
      _$this._photoUIState ??= new PhotoUIStateBuilder();
  set photoUIState(PhotoUIStateBuilder? photoUIState) =>
      _$this._photoUIState = photoUIState;

  WorkoutUIStateBuilder? _workoutUIState;
  WorkoutUIStateBuilder get workoutUIState =>
      _$this._workoutUIState ??= new WorkoutUIStateBuilder();
  set workoutUIState(WorkoutUIStateBuilder? workoutUIState) =>
      _$this._workoutUIState = workoutUIState;

  NotificationUIStateBuilder? _notificationUIState;
  NotificationUIStateBuilder get notificationUIState =>
      _$this._notificationUIState ??= new NotificationUIStateBuilder();
  set notificationUIState(NotificationUIStateBuilder? notificationUIState) =>
      _$this._notificationUIState = notificationUIState;

  ProfileOperationUIStateBuilder? _profileOperationUIState;
  ProfileOperationUIStateBuilder get profileOperationUIState =>
      _$this._profileOperationUIState ??= new ProfileOperationUIStateBuilder();
  set profileOperationUIState(
          ProfileOperationUIStateBuilder? profileOperationUIState) =>
      _$this._profileOperationUIState = profileOperationUIState;

  ProfileUIStateBuilder? _profileUIState;
  ProfileUIStateBuilder get profileUIState =>
      _$this._profileUIState ??= new ProfileUIStateBuilder();
  set profileUIState(ProfileUIStateBuilder? profileUIState) =>
      _$this._profileUIState = profileUIState;

  EventUIStateBuilder? _eventUIState;
  EventUIStateBuilder get eventUIState =>
      _$this._eventUIState ??= new EventUIStateBuilder();
  set eventUIState(EventUIStateBuilder? eventUIState) =>
      _$this._eventUIState = eventUIState;

  ChatUIStateBuilder? _chatUIState;
  ChatUIStateBuilder get chatUIState =>
      _$this._chatUIState ??= new ChatUIStateBuilder();
  set chatUIState(ChatUIStateBuilder? chatUIState) =>
      _$this._chatUIState = chatUIState;

  DesignUIStateBuilder? _designUIState;
  DesignUIStateBuilder get designUIState =>
      _$this._designUIState ??= new DesignUIStateBuilder();
  set designUIState(DesignUIStateBuilder? designUIState) =>
      _$this._designUIState = designUIState;

  UserUIStateBuilder? _userUIState;
  UserUIStateBuilder get userUIState =>
      _$this._userUIState ??= new UserUIStateBuilder();
  set userUIState(UserUIStateBuilder? userUIState) =>
      _$this._userUIState = userUIState;

  SettingsUIStateBuilder? _settingsUIState;
  SettingsUIStateBuilder get settingsUIState =>
      _$this._settingsUIState ??= new SettingsUIStateBuilder();
  set settingsUIState(SettingsUIStateBuilder? settingsUIState) =>
      _$this._settingsUIState = settingsUIState;

  UIStateBuilder() {
    UIState._initializeBuilder(this);
  }

  UIStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _selectedCompanyIndex = $v.selectedCompanyIndex;
      _currentRoute = $v.currentRoute;
      _previousRoute = $v.previousRoute;
      _dismissedFlutterWebWarning = $v.dismissedFlutterWebWarning;
      _loadingEntityType = $v.loadingEntityType;
      _previewStack = $v.previewStack.toBuilder();
      _filterStack = $v.filterStack.toBuilder();
      _filter = $v.filter;
      _filterClearedAt = $v.filterClearedAt;
      _lastActivityAt = $v.lastActivityAt;
      _dashboardUIState = $v.dashboardUIState.toBuilder();
      _paymentUIState = $v.paymentUIState.toBuilder();
      _productUIState = $v.productUIState.toBuilder();
      _socialUIState = $v.socialUIState.toBuilder();
      _photoUIState = $v.photoUIState.toBuilder();
      _workoutUIState = $v.workoutUIState.toBuilder();
      _notificationUIState = $v.notificationUIState.toBuilder();
      _profileOperationUIState = $v.profileOperationUIState.toBuilder();
      _profileUIState = $v.profileUIState.toBuilder();
      _eventUIState = $v.eventUIState.toBuilder();
      _chatUIState = $v.chatUIState.toBuilder();
      _designUIState = $v.designUIState.toBuilder();
      _userUIState = $v.userUIState.toBuilder();
      _settingsUIState = $v.settingsUIState.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UIState other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$UIState;
  }

  @override
  void update(void Function(UIStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UIState build() => _build();

  _$UIState _build() {
    _$UIState _$result;
    try {
      _$result = _$v ??
          new _$UIState._(
              selectedCompanyIndex: BuiltValueNullFieldError.checkNotNull(
                  selectedCompanyIndex, r'UIState', 'selectedCompanyIndex'),
              currentRoute: BuiltValueNullFieldError.checkNotNull(
                  currentRoute, r'UIState', 'currentRoute'),
              previousRoute: BuiltValueNullFieldError.checkNotNull(
                  previousRoute, r'UIState', 'previousRoute'),
              dismissedFlutterWebWarning: BuiltValueNullFieldError.checkNotNull(
                  dismissedFlutterWebWarning,
                  r'UIState',
                  'dismissedFlutterWebWarning'),
              loadingEntityType: loadingEntityType,
              previewStack: previewStack.build(),
              filterStack: filterStack.build(),
              filter: filter,
              filterClearedAt: BuiltValueNullFieldError.checkNotNull(
                  filterClearedAt, r'UIState', 'filterClearedAt'),
              lastActivityAt: BuiltValueNullFieldError.checkNotNull(
                  lastActivityAt, r'UIState', 'lastActivityAt'),
              dashboardUIState: dashboardUIState.build(),
              paymentUIState: paymentUIState.build(),
              productUIState: productUIState.build(),
              socialUIState: socialUIState.build(),
              photoUIState: photoUIState.build(),
              workoutUIState: workoutUIState.build(),
              notificationUIState: notificationUIState.build(),
              profileOperationUIState: profileOperationUIState.build(),
              profileUIState: profileUIState.build(),
              eventUIState: eventUIState.build(),
              chatUIState: chatUIState.build(),
              designUIState: designUIState.build(),
              userUIState: userUIState.build(),
              settingsUIState: settingsUIState.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'previewStack';
        previewStack.build();
        _$failedField = 'filterStack';
        filterStack.build();

        _$failedField = 'dashboardUIState';
        dashboardUIState.build();
        _$failedField = 'paymentUIState';
        paymentUIState.build();
        _$failedField = 'productUIState';
        productUIState.build();
        _$failedField = 'socialUIState';
        socialUIState.build();
        _$failedField = 'photoUIState';
        photoUIState.build();
        _$failedField = 'workoutUIState';
        workoutUIState.build();
        _$failedField = 'notificationUIState';
        notificationUIState.build();
        _$failedField = 'profileOperationUIState';
        profileOperationUIState.build();
        _$failedField = 'profileUIState';
        profileUIState.build();
        _$failedField = 'eventUIState';
        eventUIState.build();
        _$failedField = 'chatUIState';
        chatUIState.build();
        _$failedField = 'designUIState';
        designUIState.build();
        _$failedField = 'userUIState';
        userUIState.build();
        _$failedField = 'settingsUIState';
        settingsUIState.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'UIState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
