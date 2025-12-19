// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<WorkoutState> _$workoutStateSerializer =
    new _$WorkoutStateSerializer();
Serializer<WorkoutUIState> _$workoutUIStateSerializer =
    new _$WorkoutUIStateSerializer();

class _$WorkoutStateSerializer implements StructuredSerializer<WorkoutState> {
  @override
  final Iterable<Type> types = const [WorkoutState, _$WorkoutState];
  @override
  final String wireName = 'WorkoutState';

  @override
  Iterable<Object?> serialize(Serializers serializers, WorkoutState object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'map',
      serializers.serialize(object.map,
          specifiedType: const FullType(BuiltMap,
              const [const FullType(String), const FullType(WorkoutEntity)])),
      'list',
      serializers.serialize(object.list,
          specifiedType:
              const FullType(BuiltList, const [const FullType(String)])),
      'filter',
      serializers.serialize(object.filter,
          specifiedType: const FullType(WorkoutFilter)),
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
  WorkoutState deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new WorkoutStateBuilder();

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
                const FullType(WorkoutEntity)
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
              specifiedType: const FullType(WorkoutFilter))! as WorkoutFilter);
          break;
      }
    }

    return result.build();
  }
}

class _$WorkoutUIStateSerializer
    implements StructuredSerializer<WorkoutUIState> {
  @override
  final Iterable<Type> types = const [WorkoutUIState, _$WorkoutUIState];
  @override
  final String wireName = 'WorkoutUIState';

  @override
  Iterable<Object?> serialize(Serializers serializers, WorkoutUIState object,
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
            specifiedType: const FullType(WorkoutEntity)));
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
  WorkoutUIState deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new WorkoutUIStateBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'editing':
          result.editing.replace(serializers.deserialize(value,
              specifiedType: const FullType(WorkoutEntity))! as WorkoutEntity);
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

class _$WorkoutState extends WorkoutState {
  @override
  final BuiltMap<String, WorkoutEntity> map;
  @override
  final BuiltList<String> list;
  @override
  final DocumentSnapshot<Object?>? lastDocument;
  @override
  final WorkoutFilter filter;

  factory _$WorkoutState([void Function(WorkoutStateBuilder)? updates]) =>
      (new WorkoutStateBuilder()..update(updates))._build();

  _$WorkoutState._(
      {required this.map,
      required this.list,
      this.lastDocument,
      required this.filter})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(map, r'WorkoutState', 'map');
    BuiltValueNullFieldError.checkNotNull(list, r'WorkoutState', 'list');
    BuiltValueNullFieldError.checkNotNull(filter, r'WorkoutState', 'filter');
  }

  @override
  WorkoutState rebuild(void Function(WorkoutStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WorkoutStateBuilder toBuilder() => new WorkoutStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WorkoutState &&
        map == other.map &&
        list == other.list &&
        lastDocument == other.lastDocument &&
        filter == other.filter;
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
    _$hash = $jf(_$hash);
    return __hashCode ??= _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'WorkoutState')
          ..add('map', map)
          ..add('list', list)
          ..add('lastDocument', lastDocument)
          ..add('filter', filter))
        .toString();
  }
}

class WorkoutStateBuilder
    implements Builder<WorkoutState, WorkoutStateBuilder> {
  _$WorkoutState? _$v;

  MapBuilder<String, WorkoutEntity>? _map;
  MapBuilder<String, WorkoutEntity> get map =>
      _$this._map ??= new MapBuilder<String, WorkoutEntity>();
  set map(MapBuilder<String, WorkoutEntity>? map) => _$this._map = map;

  ListBuilder<String>? _list;
  ListBuilder<String> get list => _$this._list ??= new ListBuilder<String>();
  set list(ListBuilder<String>? list) => _$this._list = list;

  DocumentSnapshot<Object?>? _lastDocument;
  DocumentSnapshot<Object?>? get lastDocument => _$this._lastDocument;
  set lastDocument(DocumentSnapshot<Object?>? lastDocument) =>
      _$this._lastDocument = lastDocument;

  WorkoutFilterBuilder? _filter;
  WorkoutFilterBuilder get filter =>
      _$this._filter ??= new WorkoutFilterBuilder();
  set filter(WorkoutFilterBuilder? filter) => _$this._filter = filter;

  WorkoutStateBuilder();

  WorkoutStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _map = $v.map.toBuilder();
      _list = $v.list.toBuilder();
      _lastDocument = $v.lastDocument;
      _filter = $v.filter.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(WorkoutState other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$WorkoutState;
  }

  @override
  void update(void Function(WorkoutStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WorkoutState build() => _build();

  _$WorkoutState _build() {
    _$WorkoutState _$result;
    try {
      _$result = _$v ??
          new _$WorkoutState._(
              map: map.build(),
              list: list.build(),
              lastDocument: lastDocument,
              filter: filter.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'map';
        map.build();
        _$failedField = 'list';
        list.build();

        _$failedField = 'filter';
        filter.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'WorkoutState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$WorkoutUIState extends WorkoutUIState {
  @override
  final WorkoutEntity? editing;
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

  factory _$WorkoutUIState([void Function(WorkoutUIStateBuilder)? updates]) =>
      (new WorkoutUIStateBuilder()..update(updates))._build();

  _$WorkoutUIState._(
      {this.editing,
      required this.listUIState,
      this.selectedId,
      this.forceSelected,
      required this.tabIndex,
      this.saveCompleter,
      this.cancelCompleter})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        listUIState, r'WorkoutUIState', 'listUIState');
    BuiltValueNullFieldError.checkNotNull(
        tabIndex, r'WorkoutUIState', 'tabIndex');
  }

  @override
  WorkoutUIState rebuild(void Function(WorkoutUIStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WorkoutUIStateBuilder toBuilder() =>
      new WorkoutUIStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WorkoutUIState &&
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
    return (newBuiltValueToStringHelper(r'WorkoutUIState')
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

class WorkoutUIStateBuilder
    implements Builder<WorkoutUIState, WorkoutUIStateBuilder> {
  _$WorkoutUIState? _$v;

  WorkoutEntityBuilder? _editing;
  WorkoutEntityBuilder get editing =>
      _$this._editing ??= new WorkoutEntityBuilder();
  set editing(WorkoutEntityBuilder? editing) => _$this._editing = editing;

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

  WorkoutUIStateBuilder();

  WorkoutUIStateBuilder get _$this {
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
  void replace(WorkoutUIState other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$WorkoutUIState;
  }

  @override
  void update(void Function(WorkoutUIStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WorkoutUIState build() => _build();

  _$WorkoutUIState _build() {
    _$WorkoutUIState _$result;
    try {
      _$result = _$v ??
          new _$WorkoutUIState._(
              editing: _editing?.build(),
              listUIState: listUIState.build(),
              selectedId: selectedId,
              forceSelected: forceSelected,
              tabIndex: BuiltValueNullFieldError.checkNotNull(
                  tabIndex, r'WorkoutUIState', 'tabIndex'),
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
            r'WorkoutUIState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
