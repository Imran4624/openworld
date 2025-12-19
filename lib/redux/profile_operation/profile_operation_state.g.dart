// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_operation_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<ProfileOperationState> _$profileOperationStateSerializer =
    new _$ProfileOperationStateSerializer();
Serializer<ProfileOperationUIState> _$profileOperationUIStateSerializer =
    new _$ProfileOperationUIStateSerializer();

class _$ProfileOperationStateSerializer
    implements StructuredSerializer<ProfileOperationState> {
  @override
  final Iterable<Type> types = const [
    ProfileOperationState,
    _$ProfileOperationState
  ];
  @override
  final String wireName = 'ProfileOperationState';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, ProfileOperationState object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'map',
      serializers.serialize(object.map,
          specifiedType: const FullType(BuiltMap, const [
            const FullType(String),
            const FullType(ProfileOperationEntity)
          ])),
      'list',
      serializers.serialize(object.list,
          specifiedType:
              const FullType(BuiltList, const [const FullType(String)])),
      'lastDocumentMap',
      serializers.serialize(object.lastDocumentMap,
          specifiedType: const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(
                DocumentSnapshot, const [const FullType.nullable(Object)])
          ])),
      'filter',
      serializers.serialize(object.filter,
          specifiedType: const FullType(ProfileOperationFilter)),
      'activeTab',
      serializers.serialize(object.activeTab,
          specifiedType: const FullType(String)),
      'likesProfileMap',
      serializers.serialize(object.likesProfileMap,
          specifiedType: const FullType(BuiltMap, const [
            const FullType(String),
            const FullType(ProfileOperationEntity)
          ])),
      'likedMeProfileMap',
      serializers.serialize(object.likedMeProfileMap,
          specifiedType: const FullType(BuiltMap, const [
            const FullType(String),
            const FullType(ProfileOperationEntity)
          ])),
      'matchesProfileMap',
      serializers.serialize(object.matchesProfileMap,
          specifiedType: const FullType(BuiltMap, const [
            const FullType(String),
            const FullType(ProfileOperationEntity)
          ])),
      'passesProfileMap',
      serializers.serialize(object.passesProfileMap,
          specifiedType: const FullType(BuiltMap, const [
            const FullType(String),
            const FullType(ProfileOperationEntity)
          ])),
      'likesProfileList',
      serializers.serialize(object.likesProfileList,
          specifiedType:
              const FullType(BuiltList, const [const FullType(String)])),
      'likedMeProfileList',
      serializers.serialize(object.likedMeProfileList,
          specifiedType:
              const FullType(BuiltList, const [const FullType(String)])),
      'matchesProfileList',
      serializers.serialize(object.matchesProfileList,
          specifiedType:
              const FullType(BuiltList, const [const FullType(String)])),
      'passesProfileList',
      serializers.serialize(object.passesProfileList,
          specifiedType:
              const FullType(BuiltList, const [const FullType(String)])),
      'isLoading',
      serializers.serialize(object.isLoading,
          specifiedType: const FullType(bool)),
    ];

    return result;
  }

  @override
  ProfileOperationState deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ProfileOperationStateBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'map':
          result.map.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltMap, const [
                const FullType(String),
                const FullType(ProfileOperationEntity)
              ]))!);
          break;
        case 'list':
          result.list.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(String)]))!
              as BuiltList<Object?>);
          break;
        case 'lastDocumentMap':
          result.lastDocumentMap.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltMap, const [
                const FullType(String),
                const FullType.nullable(
                    DocumentSnapshot, const [const FullType.nullable(Object)])
              ]))!);
          break;
        case 'filter':
          result.filter.replace(serializers.deserialize(value,
                  specifiedType: const FullType(ProfileOperationFilter))!
              as ProfileOperationFilter);
          break;
        case 'activeTab':
          result.activeTab = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'likesProfileMap':
          result.likesProfileMap.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltMap, const [
                const FullType(String),
                const FullType(ProfileOperationEntity)
              ]))!);
          break;
        case 'likedMeProfileMap':
          result.likedMeProfileMap.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltMap, const [
                const FullType(String),
                const FullType(ProfileOperationEntity)
              ]))!);
          break;
        case 'matchesProfileMap':
          result.matchesProfileMap.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltMap, const [
                const FullType(String),
                const FullType(ProfileOperationEntity)
              ]))!);
          break;
        case 'passesProfileMap':
          result.passesProfileMap.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltMap, const [
                const FullType(String),
                const FullType(ProfileOperationEntity)
              ]))!);
          break;
        case 'likesProfileList':
          result.likesProfileList.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(String)]))!
              as BuiltList<Object?>);
          break;
        case 'likedMeProfileList':
          result.likedMeProfileList.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(String)]))!
              as BuiltList<Object?>);
          break;
        case 'matchesProfileList':
          result.matchesProfileList.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(String)]))!
              as BuiltList<Object?>);
          break;
        case 'passesProfileList':
          result.passesProfileList.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(String)]))!
              as BuiltList<Object?>);
          break;
        case 'isLoading':
          result.isLoading = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
      }
    }

    return result.build();
  }
}

class _$ProfileOperationUIStateSerializer
    implements StructuredSerializer<ProfileOperationUIState> {
  @override
  final Iterable<Type> types = const [
    ProfileOperationUIState,
    _$ProfileOperationUIState
  ];
  @override
  final String wireName = 'ProfileOperationUIState';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, ProfileOperationUIState object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'listUIState',
      serializers.serialize(object.listUIState,
          specifiedType: const FullType(ListUIState)),
      'tabIndex',
      serializers.serialize(object.tabIndex,
          specifiedType: const FullType(int)),
    ];
    Object? value;
    value = object.editing;
    if (value != null) {
      result
        ..add('editing')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(ProfileOperationEntity)));
    }
    value = object.selectedId;
    if (value != null) {
      result
        ..add('selectedId')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.forceSelected;
    if (value != null) {
      result
        ..add('forceSelected')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    return result;
  }

  @override
  ProfileOperationUIState deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ProfileOperationUIStateBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'editing':
          result.editing.replace(serializers.deserialize(value,
                  specifiedType: const FullType(ProfileOperationEntity))!
              as ProfileOperationEntity);
          break;
        case 'listUIState':
          result.listUIState.replace(serializers.deserialize(value,
              specifiedType: const FullType(ListUIState))! as ListUIState);
          break;
        case 'selectedId':
          result.selectedId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'forceSelected':
          result.forceSelected = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'tabIndex':
          result.tabIndex = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
      }
    }

    return result.build();
  }
}

class _$ProfileOperationState extends ProfileOperationState {
  @override
  final BuiltMap<String, ProfileOperationEntity> map;
  @override
  final BuiltList<String> list;
  @override
  final BuiltMap<String, DocumentSnapshot<Object?>?> lastDocumentMap;
  @override
  final ProfileOperationFilter filter;
  @override
  final String activeTab;
  @override
  final BuiltMap<String, ProfileOperationEntity> likesProfileMap;
  @override
  final BuiltMap<String, ProfileOperationEntity> likedMeProfileMap;
  @override
  final BuiltMap<String, ProfileOperationEntity> matchesProfileMap;
  @override
  final BuiltMap<String, ProfileOperationEntity> passesProfileMap;
  @override
  final BuiltList<String> likesProfileList;
  @override
  final BuiltList<String> likedMeProfileList;
  @override
  final BuiltList<String> matchesProfileList;
  @override
  final BuiltList<String> passesProfileList;
  @override
  final bool isLoading;

  factory _$ProfileOperationState(
          [void Function(ProfileOperationStateBuilder)? updates]) =>
      (new ProfileOperationStateBuilder()..update(updates))._build();

  _$ProfileOperationState._(
      {required this.map,
      required this.list,
      required this.lastDocumentMap,
      required this.filter,
      required this.activeTab,
      required this.likesProfileMap,
      required this.likedMeProfileMap,
      required this.matchesProfileMap,
      required this.passesProfileMap,
      required this.likesProfileList,
      required this.likedMeProfileList,
      required this.matchesProfileList,
      required this.passesProfileList,
      required this.isLoading})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(map, r'ProfileOperationState', 'map');
    BuiltValueNullFieldError.checkNotNull(
        list, r'ProfileOperationState', 'list');
    BuiltValueNullFieldError.checkNotNull(
        lastDocumentMap, r'ProfileOperationState', 'lastDocumentMap');
    BuiltValueNullFieldError.checkNotNull(
        filter, r'ProfileOperationState', 'filter');
    BuiltValueNullFieldError.checkNotNull(
        activeTab, r'ProfileOperationState', 'activeTab');
    BuiltValueNullFieldError.checkNotNull(
        likesProfileMap, r'ProfileOperationState', 'likesProfileMap');
    BuiltValueNullFieldError.checkNotNull(
        likedMeProfileMap, r'ProfileOperationState', 'likedMeProfileMap');
    BuiltValueNullFieldError.checkNotNull(
        matchesProfileMap, r'ProfileOperationState', 'matchesProfileMap');
    BuiltValueNullFieldError.checkNotNull(
        passesProfileMap, r'ProfileOperationState', 'passesProfileMap');
    BuiltValueNullFieldError.checkNotNull(
        likesProfileList, r'ProfileOperationState', 'likesProfileList');
    BuiltValueNullFieldError.checkNotNull(
        likedMeProfileList, r'ProfileOperationState', 'likedMeProfileList');
    BuiltValueNullFieldError.checkNotNull(
        matchesProfileList, r'ProfileOperationState', 'matchesProfileList');
    BuiltValueNullFieldError.checkNotNull(
        passesProfileList, r'ProfileOperationState', 'passesProfileList');
    BuiltValueNullFieldError.checkNotNull(
        isLoading, r'ProfileOperationState', 'isLoading');
  }

  @override
  ProfileOperationState rebuild(
          void Function(ProfileOperationStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProfileOperationStateBuilder toBuilder() =>
      new ProfileOperationStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProfileOperationState &&
        map == other.map &&
        list == other.list &&
        lastDocumentMap == other.lastDocumentMap &&
        filter == other.filter &&
        activeTab == other.activeTab &&
        likesProfileMap == other.likesProfileMap &&
        likedMeProfileMap == other.likedMeProfileMap &&
        matchesProfileMap == other.matchesProfileMap &&
        passesProfileMap == other.passesProfileMap &&
        likesProfileList == other.likesProfileList &&
        likedMeProfileList == other.likedMeProfileList &&
        matchesProfileList == other.matchesProfileList &&
        passesProfileList == other.passesProfileList &&
        isLoading == other.isLoading;
  }

  int? __hashCode;
  @override
  int get hashCode {
    if (__hashCode != null) return __hashCode!;
    var _$hash = 0;
    _$hash = $jc(_$hash, map.hashCode);
    _$hash = $jc(_$hash, list.hashCode);
    _$hash = $jc(_$hash, lastDocumentMap.hashCode);
    _$hash = $jc(_$hash, filter.hashCode);
    _$hash = $jc(_$hash, activeTab.hashCode);
    _$hash = $jc(_$hash, likesProfileMap.hashCode);
    _$hash = $jc(_$hash, likedMeProfileMap.hashCode);
    _$hash = $jc(_$hash, matchesProfileMap.hashCode);
    _$hash = $jc(_$hash, passesProfileMap.hashCode);
    _$hash = $jc(_$hash, likesProfileList.hashCode);
    _$hash = $jc(_$hash, likedMeProfileList.hashCode);
    _$hash = $jc(_$hash, matchesProfileList.hashCode);
    _$hash = $jc(_$hash, passesProfileList.hashCode);
    _$hash = $jc(_$hash, isLoading.hashCode);
    _$hash = $jf(_$hash);
    return __hashCode ??= _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProfileOperationState')
          ..add('map', map)
          ..add('list', list)
          ..add('lastDocumentMap', lastDocumentMap)
          ..add('filter', filter)
          ..add('activeTab', activeTab)
          ..add('likesProfileMap', likesProfileMap)
          ..add('likedMeProfileMap', likedMeProfileMap)
          ..add('matchesProfileMap', matchesProfileMap)
          ..add('passesProfileMap', passesProfileMap)
          ..add('likesProfileList', likesProfileList)
          ..add('likedMeProfileList', likedMeProfileList)
          ..add('matchesProfileList', matchesProfileList)
          ..add('passesProfileList', passesProfileList)
          ..add('isLoading', isLoading))
        .toString();
  }
}

class ProfileOperationStateBuilder
    implements Builder<ProfileOperationState, ProfileOperationStateBuilder> {
  _$ProfileOperationState? _$v;

  MapBuilder<String, ProfileOperationEntity>? _map;
  MapBuilder<String, ProfileOperationEntity> get map =>
      _$this._map ??= new MapBuilder<String, ProfileOperationEntity>();
  set map(MapBuilder<String, ProfileOperationEntity>? map) => _$this._map = map;

  ListBuilder<String>? _list;
  ListBuilder<String> get list => _$this._list ??= new ListBuilder<String>();
  set list(ListBuilder<String>? list) => _$this._list = list;

  MapBuilder<String, DocumentSnapshot<Object?>?>? _lastDocumentMap;
  MapBuilder<String, DocumentSnapshot<Object?>?> get lastDocumentMap =>
      _$this._lastDocumentMap ??=
          new MapBuilder<String, DocumentSnapshot<Object?>?>();
  set lastDocumentMap(
          MapBuilder<String, DocumentSnapshot<Object?>?>? lastDocumentMap) =>
      _$this._lastDocumentMap = lastDocumentMap;

  ProfileOperationFilterBuilder? _filter;
  ProfileOperationFilterBuilder get filter =>
      _$this._filter ??= new ProfileOperationFilterBuilder();
  set filter(ProfileOperationFilterBuilder? filter) => _$this._filter = filter;

  String? _activeTab;
  String? get activeTab => _$this._activeTab;
  set activeTab(String? activeTab) => _$this._activeTab = activeTab;

  MapBuilder<String, ProfileOperationEntity>? _likesProfileMap;
  MapBuilder<String, ProfileOperationEntity> get likesProfileMap =>
      _$this._likesProfileMap ??=
          new MapBuilder<String, ProfileOperationEntity>();
  set likesProfileMap(
          MapBuilder<String, ProfileOperationEntity>? likesProfileMap) =>
      _$this._likesProfileMap = likesProfileMap;

  MapBuilder<String, ProfileOperationEntity>? _likedMeProfileMap;
  MapBuilder<String, ProfileOperationEntity> get likedMeProfileMap =>
      _$this._likedMeProfileMap ??=
          new MapBuilder<String, ProfileOperationEntity>();
  set likedMeProfileMap(
          MapBuilder<String, ProfileOperationEntity>? likedMeProfileMap) =>
      _$this._likedMeProfileMap = likedMeProfileMap;

  MapBuilder<String, ProfileOperationEntity>? _matchesProfileMap;
  MapBuilder<String, ProfileOperationEntity> get matchesProfileMap =>
      _$this._matchesProfileMap ??=
          new MapBuilder<String, ProfileOperationEntity>();
  set matchesProfileMap(
          MapBuilder<String, ProfileOperationEntity>? matchesProfileMap) =>
      _$this._matchesProfileMap = matchesProfileMap;

  MapBuilder<String, ProfileOperationEntity>? _passesProfileMap;
  MapBuilder<String, ProfileOperationEntity> get passesProfileMap =>
      _$this._passesProfileMap ??=
          new MapBuilder<String, ProfileOperationEntity>();
  set passesProfileMap(
          MapBuilder<String, ProfileOperationEntity>? passesProfileMap) =>
      _$this._passesProfileMap = passesProfileMap;

  ListBuilder<String>? _likesProfileList;
  ListBuilder<String> get likesProfileList =>
      _$this._likesProfileList ??= new ListBuilder<String>();
  set likesProfileList(ListBuilder<String>? likesProfileList) =>
      _$this._likesProfileList = likesProfileList;

  ListBuilder<String>? _likedMeProfileList;
  ListBuilder<String> get likedMeProfileList =>
      _$this._likedMeProfileList ??= new ListBuilder<String>();
  set likedMeProfileList(ListBuilder<String>? likedMeProfileList) =>
      _$this._likedMeProfileList = likedMeProfileList;

  ListBuilder<String>? _matchesProfileList;
  ListBuilder<String> get matchesProfileList =>
      _$this._matchesProfileList ??= new ListBuilder<String>();
  set matchesProfileList(ListBuilder<String>? matchesProfileList) =>
      _$this._matchesProfileList = matchesProfileList;

  ListBuilder<String>? _passesProfileList;
  ListBuilder<String> get passesProfileList =>
      _$this._passesProfileList ??= new ListBuilder<String>();
  set passesProfileList(ListBuilder<String>? passesProfileList) =>
      _$this._passesProfileList = passesProfileList;

  bool? _isLoading;
  bool? get isLoading => _$this._isLoading;
  set isLoading(bool? isLoading) => _$this._isLoading = isLoading;

  ProfileOperationStateBuilder();

  ProfileOperationStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _map = $v.map.toBuilder();
      _list = $v.list.toBuilder();
      _lastDocumentMap = $v.lastDocumentMap.toBuilder();
      _filter = $v.filter.toBuilder();
      _activeTab = $v.activeTab;
      _likesProfileMap = $v.likesProfileMap.toBuilder();
      _likedMeProfileMap = $v.likedMeProfileMap.toBuilder();
      _matchesProfileMap = $v.matchesProfileMap.toBuilder();
      _passesProfileMap = $v.passesProfileMap.toBuilder();
      _likesProfileList = $v.likesProfileList.toBuilder();
      _likedMeProfileList = $v.likedMeProfileList.toBuilder();
      _matchesProfileList = $v.matchesProfileList.toBuilder();
      _passesProfileList = $v.passesProfileList.toBuilder();
      _isLoading = $v.isLoading;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProfileOperationState other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ProfileOperationState;
  }

  @override
  void update(void Function(ProfileOperationStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProfileOperationState build() => _build();

  _$ProfileOperationState _build() {
    _$ProfileOperationState _$result;
    try {
      _$result = _$v ??
          new _$ProfileOperationState._(
              map: map.build(),
              list: list.build(),
              lastDocumentMap: lastDocumentMap.build(),
              filter: filter.build(),
              activeTab: BuiltValueNullFieldError.checkNotNull(
                  activeTab, r'ProfileOperationState', 'activeTab'),
              likesProfileMap: likesProfileMap.build(),
              likedMeProfileMap: likedMeProfileMap.build(),
              matchesProfileMap: matchesProfileMap.build(),
              passesProfileMap: passesProfileMap.build(),
              likesProfileList: likesProfileList.build(),
              likedMeProfileList: likedMeProfileList.build(),
              matchesProfileList: matchesProfileList.build(),
              passesProfileList: passesProfileList.build(),
              isLoading: BuiltValueNullFieldError.checkNotNull(
                  isLoading, r'ProfileOperationState', 'isLoading'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'map';
        map.build();
        _$failedField = 'list';
        list.build();
        _$failedField = 'lastDocumentMap';
        lastDocumentMap.build();
        _$failedField = 'filter';
        filter.build();

        _$failedField = 'likesProfileMap';
        likesProfileMap.build();
        _$failedField = 'likedMeProfileMap';
        likedMeProfileMap.build();
        _$failedField = 'matchesProfileMap';
        matchesProfileMap.build();
        _$failedField = 'passesProfileMap';
        passesProfileMap.build();
        _$failedField = 'likesProfileList';
        likesProfileList.build();
        _$failedField = 'likedMeProfileList';
        likedMeProfileList.build();
        _$failedField = 'matchesProfileList';
        matchesProfileList.build();
        _$failedField = 'passesProfileList';
        passesProfileList.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'ProfileOperationState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$ProfileOperationUIState extends ProfileOperationUIState {
  @override
  final ProfileOperationEntity? editing;
  @override
  final ListUIState listUIState;
  @override
  final String? selectedId;
  @override
  final bool? forceSelected;
  @override
  final int tabIndex;
  @override
  final Completer<SelectableEntity>? saveCompleter;
  @override
  final Completer<Null>? cancelCompleter;

  factory _$ProfileOperationUIState(
          [void Function(ProfileOperationUIStateBuilder)? updates]) =>
      (new ProfileOperationUIStateBuilder()..update(updates))._build();

  _$ProfileOperationUIState._(
      {this.editing,
      required this.listUIState,
      this.selectedId,
      this.forceSelected,
      required this.tabIndex,
      this.saveCompleter,
      this.cancelCompleter})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        listUIState, r'ProfileOperationUIState', 'listUIState');
    BuiltValueNullFieldError.checkNotNull(
        tabIndex, r'ProfileOperationUIState', 'tabIndex');
  }

  @override
  ProfileOperationUIState rebuild(
          void Function(ProfileOperationUIStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProfileOperationUIStateBuilder toBuilder() =>
      new ProfileOperationUIStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProfileOperationUIState &&
        editing == other.editing &&
        listUIState == other.listUIState &&
        selectedId == other.selectedId &&
        forceSelected == other.forceSelected &&
        tabIndex == other.tabIndex &&
        saveCompleter == other.saveCompleter &&
        cancelCompleter == other.cancelCompleter;
  }

  int? __hashCode;
  @override
  int get hashCode {
    if (__hashCode != null) return __hashCode!;
    var _$hash = 0;
    _$hash = $jc(_$hash, editing.hashCode);
    _$hash = $jc(_$hash, listUIState.hashCode);
    _$hash = $jc(_$hash, selectedId.hashCode);
    _$hash = $jc(_$hash, forceSelected.hashCode);
    _$hash = $jc(_$hash, tabIndex.hashCode);
    _$hash = $jc(_$hash, saveCompleter.hashCode);
    _$hash = $jc(_$hash, cancelCompleter.hashCode);
    _$hash = $jf(_$hash);
    return __hashCode ??= _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProfileOperationUIState')
          ..add('editing', editing)
          ..add('listUIState', listUIState)
          ..add('selectedId', selectedId)
          ..add('forceSelected', forceSelected)
          ..add('tabIndex', tabIndex)
          ..add('saveCompleter', saveCompleter)
          ..add('cancelCompleter', cancelCompleter))
        .toString();
  }
}

class ProfileOperationUIStateBuilder
    implements
        Builder<ProfileOperationUIState, ProfileOperationUIStateBuilder> {
  _$ProfileOperationUIState? _$v;

  ProfileOperationEntityBuilder? _editing;
  ProfileOperationEntityBuilder get editing =>
      _$this._editing ??= new ProfileOperationEntityBuilder();
  set editing(ProfileOperationEntityBuilder? editing) =>
      _$this._editing = editing;

  ListUIStateBuilder? _listUIState;
  ListUIStateBuilder get listUIState =>
      _$this._listUIState ??= new ListUIStateBuilder();
  set listUIState(ListUIStateBuilder? listUIState) =>
      _$this._listUIState = listUIState;

  String? _selectedId;
  String? get selectedId => _$this._selectedId;
  set selectedId(String? selectedId) => _$this._selectedId = selectedId;

  bool? _forceSelected;
  bool? get forceSelected => _$this._forceSelected;
  set forceSelected(bool? forceSelected) =>
      _$this._forceSelected = forceSelected;

  int? _tabIndex;
  int? get tabIndex => _$this._tabIndex;
  set tabIndex(int? tabIndex) => _$this._tabIndex = tabIndex;

  Completer<SelectableEntity>? _saveCompleter;
  Completer<SelectableEntity>? get saveCompleter => _$this._saveCompleter;
  set saveCompleter(Completer<SelectableEntity>? saveCompleter) =>
      _$this._saveCompleter = saveCompleter;

  Completer<Null>? _cancelCompleter;
  Completer<Null>? get cancelCompleter => _$this._cancelCompleter;
  set cancelCompleter(Completer<Null>? cancelCompleter) =>
      _$this._cancelCompleter = cancelCompleter;

  ProfileOperationUIStateBuilder();

  ProfileOperationUIStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _editing = $v.editing?.toBuilder();
      _listUIState = $v.listUIState.toBuilder();
      _selectedId = $v.selectedId;
      _forceSelected = $v.forceSelected;
      _tabIndex = $v.tabIndex;
      _saveCompleter = $v.saveCompleter;
      _cancelCompleter = $v.cancelCompleter;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProfileOperationUIState other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ProfileOperationUIState;
  }

  @override
  void update(void Function(ProfileOperationUIStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProfileOperationUIState build() => _build();

  _$ProfileOperationUIState _build() {
    _$ProfileOperationUIState _$result;
    try {
      _$result = _$v ??
          new _$ProfileOperationUIState._(
              editing: _editing?.build(),
              listUIState: listUIState.build(),
              selectedId: selectedId,
              forceSelected: forceSelected,
              tabIndex: BuiltValueNullFieldError.checkNotNull(
                  tabIndex, r'ProfileOperationUIState', 'tabIndex'),
              saveCompleter: saveCompleter,
              cancelCompleter: cancelCompleter);
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'editing';
        _editing?.build();
        _$failedField = 'listUIState';
        listUIState.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'ProfileOperationUIState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
