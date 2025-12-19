// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<ProfileState> _$profileStateSerializer =
    new _$ProfileStateSerializer();
Serializer<ProfileUIState> _$profileUIStateSerializer =
    new _$ProfileUIStateSerializer();

class _$ProfileStateSerializer implements StructuredSerializer<ProfileState> {
  @override
  final Iterable<Type> types = const [ProfileState, _$ProfileState];
  @override
  final String wireName = 'ProfileState';

  @override
  Iterable<Object?> serialize(Serializers serializers, ProfileState object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'map',
      serializers.serialize(object.map,
          specifiedType: const FullType(BuiltMap,
              const [const FullType(String), const FullType(ProfileEntity)])),
      'list',
      serializers.serialize(object.list,
          specifiedType:
              const FullType(BuiltList, const [const FullType(String)])),
      'filter',
      serializers.serialize(object.filter,
          specifiedType: const FullType(ProfileFilter)),
      'loggedInUserProfile',
      serializers.serialize(object.loggedInUserProfile,
          specifiedType: const FullType(ProfileEntity)),
      'attendeeProfileMap',
      serializers.serialize(object.attendeeProfileMap,
          specifiedType: const FullType(BuiltMap,
              const [const FullType(String), const FullType(String)])),
    ];
    Object? value;
    value = object.lastDocument;
    if (value != null) {
      result
        ..add('lastDocument')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(
                DocumentSnapshot, const [const FullType.nullable(Object)])));
    }
    return result;
  }

  @override
  ProfileState deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ProfileStateBuilder();

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
                const FullType(ProfileEntity)
              ]))!);
          break;
        case 'list':
          result.list.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(String)]))!
              as BuiltList<Object?>);
          break;
        case 'lastDocument':
          result.lastDocument = serializers.deserialize(value,
              specifiedType: const FullType(DocumentSnapshot, const [
                const FullType.nullable(Object)
              ])) as DocumentSnapshot<Object?>?;
          break;
        case 'filter':
          result.filter.replace(serializers.deserialize(value,
              specifiedType: const FullType(ProfileFilter))! as ProfileFilter);
          break;
        case 'loggedInUserProfile':
          result.loggedInUserProfile.replace(serializers.deserialize(value,
              specifiedType: const FullType(ProfileEntity))! as ProfileEntity);
          break;
        case 'attendeeProfileMap':
          result.attendeeProfileMap.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltMap,
                  const [const FullType(String), const FullType(String)]))!);
          break;
      }
    }

    return result.build();
  }
}

class _$ProfileUIStateSerializer
    implements StructuredSerializer<ProfileUIState> {
  @override
  final Iterable<Type> types = const [ProfileUIState, _$ProfileUIState];
  @override
  final String wireName = 'ProfileUIState';

  @override
  Iterable<Object?> serialize(Serializers serializers, ProfileUIState object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'dynamicFields',
      serializers.serialize(object.dynamicFields,
          specifiedType: const FullType(BuiltMap,
              const [const FullType(String), const FullType(dynamic)])),
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
            specifiedType: const FullType(ProfileEntity)));
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
  ProfileUIState deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ProfileUIStateBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'editing':
          result.editing.replace(serializers.deserialize(value,
              specifiedType: const FullType(ProfileEntity))! as ProfileEntity);
          break;
        case 'dynamicFields':
          result.dynamicFields.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltMap,
                  const [const FullType(String), const FullType(dynamic)]))!);
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

class _$ProfileState extends ProfileState {
  @override
  final BuiltMap<String, ProfileEntity> map;
  @override
  final BuiltList<String> list;
  @override
  final DocumentSnapshot<Object?>? lastDocument;
  @override
  final ProfileFilter filter;
  @override
  final ProfileEntity loggedInUserProfile;
  @override
  final BuiltMap<String, String> attendeeProfileMap;

  factory _$ProfileState([void Function(ProfileStateBuilder)? updates]) =>
      (new ProfileStateBuilder()..update(updates))._build();

  _$ProfileState._(
      {required this.map,
      required this.list,
      this.lastDocument,
      required this.filter,
      required this.loggedInUserProfile,
      required this.attendeeProfileMap})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(map, r'ProfileState', 'map');
    BuiltValueNullFieldError.checkNotNull(list, r'ProfileState', 'list');
    BuiltValueNullFieldError.checkNotNull(filter, r'ProfileState', 'filter');
    BuiltValueNullFieldError.checkNotNull(
        loggedInUserProfile, r'ProfileState', 'loggedInUserProfile');
    BuiltValueNullFieldError.checkNotNull(
        attendeeProfileMap, r'ProfileState', 'attendeeProfileMap');
  }

  @override
  ProfileState rebuild(void Function(ProfileStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProfileStateBuilder toBuilder() => new ProfileStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProfileState &&
        map == other.map &&
        list == other.list &&
        lastDocument == other.lastDocument &&
        filter == other.filter &&
        loggedInUserProfile == other.loggedInUserProfile &&
        attendeeProfileMap == other.attendeeProfileMap;
  }

  int? __hashCode;
  @override
  int get hashCode {
    if (__hashCode != null) return __hashCode!;
    var _$hash = 0;
    _$hash = $jc(_$hash, map.hashCode);
    _$hash = $jc(_$hash, list.hashCode);
    _$hash = $jc(_$hash, lastDocument.hashCode);
    _$hash = $jc(_$hash, filter.hashCode);
    _$hash = $jc(_$hash, loggedInUserProfile.hashCode);
    _$hash = $jc(_$hash, attendeeProfileMap.hashCode);
    _$hash = $jf(_$hash);
    return __hashCode ??= _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProfileState')
          ..add('map', map)
          ..add('list', list)
          ..add('lastDocument', lastDocument)
          ..add('filter', filter)
          ..add('loggedInUserProfile', loggedInUserProfile)
          ..add('attendeeProfileMap', attendeeProfileMap))
        .toString();
  }
}

class ProfileStateBuilder
    implements Builder<ProfileState, ProfileStateBuilder> {
  _$ProfileState? _$v;

  MapBuilder<String, ProfileEntity>? _map;
  MapBuilder<String, ProfileEntity> get map =>
      _$this._map ??= new MapBuilder<String, ProfileEntity>();
  set map(MapBuilder<String, ProfileEntity>? map) => _$this._map = map;

  ListBuilder<String>? _list;
  ListBuilder<String> get list => _$this._list ??= new ListBuilder<String>();
  set list(ListBuilder<String>? list) => _$this._list = list;

  DocumentSnapshot<Object?>? _lastDocument;
  DocumentSnapshot<Object?>? get lastDocument => _$this._lastDocument;
  set lastDocument(DocumentSnapshot<Object?>? lastDocument) =>
      _$this._lastDocument = lastDocument;

  ProfileFilterBuilder? _filter;
  ProfileFilterBuilder get filter =>
      _$this._filter ??= new ProfileFilterBuilder();
  set filter(ProfileFilterBuilder? filter) => _$this._filter = filter;

  ProfileEntityBuilder? _loggedInUserProfile;
  ProfileEntityBuilder get loggedInUserProfile =>
      _$this._loggedInUserProfile ??= new ProfileEntityBuilder();
  set loggedInUserProfile(ProfileEntityBuilder? loggedInUserProfile) =>
      _$this._loggedInUserProfile = loggedInUserProfile;

  MapBuilder<String, String>? _attendeeProfileMap;
  MapBuilder<String, String> get attendeeProfileMap =>
      _$this._attendeeProfileMap ??= new MapBuilder<String, String>();
  set attendeeProfileMap(MapBuilder<String, String>? attendeeProfileMap) =>
      _$this._attendeeProfileMap = attendeeProfileMap;

  ProfileStateBuilder();

  ProfileStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _map = $v.map.toBuilder();
      _list = $v.list.toBuilder();
      _lastDocument = $v.lastDocument;
      _filter = $v.filter.toBuilder();
      _loggedInUserProfile = $v.loggedInUserProfile.toBuilder();
      _attendeeProfileMap = $v.attendeeProfileMap.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProfileState other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ProfileState;
  }

  @override
  void update(void Function(ProfileStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProfileState build() => _build();

  _$ProfileState _build() {
    _$ProfileState _$result;
    try {
      _$result = _$v ??
          new _$ProfileState._(
              map: map.build(),
              list: list.build(),
              lastDocument: lastDocument,
              filter: filter.build(),
              loggedInUserProfile: loggedInUserProfile.build(),
              attendeeProfileMap: attendeeProfileMap.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'map';
        map.build();
        _$failedField = 'list';
        list.build();

        _$failedField = 'filter';
        filter.build();
        _$failedField = 'loggedInUserProfile';
        loggedInUserProfile.build();
        _$failedField = 'attendeeProfileMap';
        attendeeProfileMap.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'ProfileState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$ProfileUIState extends ProfileUIState {
  @override
  final ProfileEntity? editing;
  @override
  final BuiltMap<String, dynamic> dynamicFields;
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

  factory _$ProfileUIState([void Function(ProfileUIStateBuilder)? updates]) =>
      (new ProfileUIStateBuilder()..update(updates))._build();

  _$ProfileUIState._(
      {this.editing,
      required this.dynamicFields,
      required this.listUIState,
      this.selectedId,
      this.forceSelected,
      required this.tabIndex,
      this.saveCompleter,
      this.cancelCompleter})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        dynamicFields, r'ProfileUIState', 'dynamicFields');
    BuiltValueNullFieldError.checkNotNull(
        listUIState, r'ProfileUIState', 'listUIState');
    BuiltValueNullFieldError.checkNotNull(
        tabIndex, r'ProfileUIState', 'tabIndex');
  }

  @override
  ProfileUIState rebuild(void Function(ProfileUIStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProfileUIStateBuilder toBuilder() =>
      new ProfileUIStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProfileUIState &&
        editing == other.editing &&
        dynamicFields == other.dynamicFields &&
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
    _$hash = $jc(_$hash, dynamicFields.hashCode);
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
    return (newBuiltValueToStringHelper(r'ProfileUIState')
          ..add('editing', editing)
          ..add('dynamicFields', dynamicFields)
          ..add('listUIState', listUIState)
          ..add('selectedId', selectedId)
          ..add('forceSelected', forceSelected)
          ..add('tabIndex', tabIndex)
          ..add('saveCompleter', saveCompleter)
          ..add('cancelCompleter', cancelCompleter))
        .toString();
  }
}

class ProfileUIStateBuilder
    implements Builder<ProfileUIState, ProfileUIStateBuilder> {
  _$ProfileUIState? _$v;

  ProfileEntityBuilder? _editing;
  ProfileEntityBuilder get editing =>
      _$this._editing ??= new ProfileEntityBuilder();
  set editing(ProfileEntityBuilder? editing) => _$this._editing = editing;

  MapBuilder<String, dynamic>? _dynamicFields;
  MapBuilder<String, dynamic> get dynamicFields =>
      _$this._dynamicFields ??= new MapBuilder<String, dynamic>();
  set dynamicFields(MapBuilder<String, dynamic>? dynamicFields) =>
      _$this._dynamicFields = dynamicFields;

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

  ProfileUIStateBuilder();

  ProfileUIStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _editing = $v.editing?.toBuilder();
      _dynamicFields = $v.dynamicFields.toBuilder();
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
  void replace(ProfileUIState other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ProfileUIState;
  }

  @override
  void update(void Function(ProfileUIStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProfileUIState build() => _build();

  _$ProfileUIState _build() {
    _$ProfileUIState _$result;
    try {
      _$result = _$v ??
          new _$ProfileUIState._(
              editing: _editing?.build(),
              dynamicFields: dynamicFields.build(),
              listUIState: listUIState.build(),
              selectedId: selectedId,
              forceSelected: forceSelected,
              tabIndex: BuiltValueNullFieldError.checkNotNull(
                  tabIndex, r'ProfileUIState', 'tabIndex'),
              saveCompleter: saveCompleter,
              cancelCompleter: cancelCompleter);
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'editing';
        _editing?.build();
        _$failedField = 'dynamicFields';
        dynamicFields.build();
        _$failedField = 'listUIState';
        listUIState.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'ProfileUIState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
