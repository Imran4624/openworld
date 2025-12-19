// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<EventState> _$eventStateSerializer = new _$EventStateSerializer();
Serializer<EventUIState> _$eventUIStateSerializer =
    new _$EventUIStateSerializer();

class _$EventStateSerializer implements StructuredSerializer<EventState> {
  @override
  final Iterable<Type> types = const [EventState, _$EventState];
  @override
  final String wireName = 'EventState';

  @override
  Iterable<Object?> serialize(Serializers serializers, EventState object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'map',
      serializers.serialize(object.map,
          specifiedType: const FullType(BuiltMap,
              const [const FullType(String), const FullType(EventEntity)])),
      'list',
      serializers.serialize(object.list,
          specifiedType:
              const FullType(BuiltList, const [const FullType(String)])),
      'lastUpdated',
      serializers.serialize(object.lastUpdated,
          specifiedType: const FullType(int)),
      'filter',
      serializers.serialize(object.filter,
          specifiedType: const FullType(EventFilter)),
      'showMyEventsOnly',
      serializers.serialize(object.showMyEventsOnly,
          specifiedType: const FullType(bool)),
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
  EventState deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new EventStateBuilder();

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
                const FullType(EventEntity)
              ]))!);
          break;
        case 'list':
          result.list.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(String)]))!
              as BuiltList<Object?>);
          break;
        case 'lastUpdated':
          result.lastUpdated = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'lastDocument':
          result.lastDocument = serializers.deserialize(value,
              specifiedType: const FullType(DocumentSnapshot, const [
                const FullType.nullable(Object)
              ])) as DocumentSnapshot<Object?>?;
          break;
        case 'filter':
          result.filter.replace(serializers.deserialize(value,
              specifiedType: const FullType(EventFilter))! as EventFilter);
          break;
        case 'showMyEventsOnly':
          result.showMyEventsOnly = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
      }
    }

    return result.build();
  }
}

class _$EventUIStateSerializer implements StructuredSerializer<EventUIState> {
  @override
  final Iterable<Type> types = const [EventUIState, _$EventUIState];
  @override
  final String wireName = 'EventUIState';

  @override
  Iterable<Object?> serialize(Serializers serializers, EventUIState object,
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
            specifiedType: const FullType(EventEntity)));
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
  EventUIState deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new EventUIStateBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'editing':
          result.editing.replace(serializers.deserialize(value,
              specifiedType: const FullType(EventEntity))! as EventEntity);
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

class _$EventState extends EventState {
  @override
  final BuiltMap<String, EventEntity> map;
  @override
  final BuiltList<String> list;
  @override
  final int lastUpdated;
  @override
  final DocumentSnapshot<Object?>? lastDocument;
  @override
  final EventFilter filter;
  @override
  final bool showMyEventsOnly;

  factory _$EventState([void Function(EventStateBuilder)? updates]) =>
      (new EventStateBuilder()..update(updates))._build();

  _$EventState._(
      {required this.map,
      required this.list,
      required this.lastUpdated,
      this.lastDocument,
      required this.filter,
      required this.showMyEventsOnly})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(map, r'EventState', 'map');
    BuiltValueNullFieldError.checkNotNull(list, r'EventState', 'list');
    BuiltValueNullFieldError.checkNotNull(
        lastUpdated, r'EventState', 'lastUpdated');
    BuiltValueNullFieldError.checkNotNull(filter, r'EventState', 'filter');
    BuiltValueNullFieldError.checkNotNull(
        showMyEventsOnly, r'EventState', 'showMyEventsOnly');
  }

  @override
  EventState rebuild(void Function(EventStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EventStateBuilder toBuilder() => new EventStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EventState &&
        map == other.map &&
        list == other.list &&
        lastUpdated == other.lastUpdated &&
        lastDocument == other.lastDocument &&
        filter == other.filter &&
        showMyEventsOnly == other.showMyEventsOnly;
  }

  int? __hashCode;
  @override
  int get hashCode {
    if (__hashCode != null) return __hashCode!;
    var _$hash = 0;
    _$hash = $jc(_$hash, map.hashCode);
    _$hash = $jc(_$hash, list.hashCode);
    _$hash = $jc(_$hash, lastUpdated.hashCode);
    _$hash = $jc(_$hash, lastDocument.hashCode);
    _$hash = $jc(_$hash, filter.hashCode);
    _$hash = $jc(_$hash, showMyEventsOnly.hashCode);
    _$hash = $jf(_$hash);
    return __hashCode ??= _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EventState')
          ..add('map', map)
          ..add('list', list)
          ..add('lastUpdated', lastUpdated)
          ..add('lastDocument', lastDocument)
          ..add('filter', filter)
          ..add('showMyEventsOnly', showMyEventsOnly))
        .toString();
  }
}

class EventStateBuilder implements Builder<EventState, EventStateBuilder> {
  _$EventState? _$v;

  MapBuilder<String, EventEntity>? _map;
  MapBuilder<String, EventEntity> get map =>
      _$this._map ??= new MapBuilder<String, EventEntity>();
  set map(MapBuilder<String, EventEntity>? map) => _$this._map = map;

  ListBuilder<String>? _list;
  ListBuilder<String> get list => _$this._list ??= new ListBuilder<String>();
  set list(ListBuilder<String>? list) => _$this._list = list;

  int? _lastUpdated;
  int? get lastUpdated => _$this._lastUpdated;
  set lastUpdated(int? lastUpdated) => _$this._lastUpdated = lastUpdated;

  DocumentSnapshot<Object?>? _lastDocument;
  DocumentSnapshot<Object?>? get lastDocument => _$this._lastDocument;
  set lastDocument(DocumentSnapshot<Object?>? lastDocument) =>
      _$this._lastDocument = lastDocument;

  EventFilterBuilder? _filter;
  EventFilterBuilder get filter => _$this._filter ??= new EventFilterBuilder();
  set filter(EventFilterBuilder? filter) => _$this._filter = filter;

  bool? _showMyEventsOnly;
  bool? get showMyEventsOnly => _$this._showMyEventsOnly;
  set showMyEventsOnly(bool? showMyEventsOnly) =>
      _$this._showMyEventsOnly = showMyEventsOnly;

  EventStateBuilder();

  EventStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _map = $v.map.toBuilder();
      _list = $v.list.toBuilder();
      _lastUpdated = $v.lastUpdated;
      _lastDocument = $v.lastDocument;
      _filter = $v.filter.toBuilder();
      _showMyEventsOnly = $v.showMyEventsOnly;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EventState other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$EventState;
  }

  @override
  void update(void Function(EventStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EventState build() => _build();

  _$EventState _build() {
    _$EventState _$result;
    try {
      _$result = _$v ??
          new _$EventState._(
              map: map.build(),
              list: list.build(),
              lastUpdated: BuiltValueNullFieldError.checkNotNull(
                  lastUpdated, r'EventState', 'lastUpdated'),
              lastDocument: lastDocument,
              filter: filter.build(),
              showMyEventsOnly: BuiltValueNullFieldError.checkNotNull(
                  showMyEventsOnly, r'EventState', 'showMyEventsOnly'));
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
            r'EventState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$EventUIState extends EventUIState {
  @override
  final EventEntity? editing;
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

  factory _$EventUIState([void Function(EventUIStateBuilder)? updates]) =>
      (new EventUIStateBuilder()..update(updates))._build();

  _$EventUIState._(
      {this.editing,
      required this.listUIState,
      this.selectedId,
      this.forceSelected,
      required this.tabIndex,
      this.saveCompleter,
      this.cancelCompleter})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        listUIState, r'EventUIState', 'listUIState');
    BuiltValueNullFieldError.checkNotNull(
        tabIndex, r'EventUIState', 'tabIndex');
  }

  @override
  EventUIState rebuild(void Function(EventUIStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EventUIStateBuilder toBuilder() => new EventUIStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EventUIState &&
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
    return (newBuiltValueToStringHelper(r'EventUIState')
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

class EventUIStateBuilder
    implements Builder<EventUIState, EventUIStateBuilder> {
  _$EventUIState? _$v;

  EventEntityBuilder? _editing;
  EventEntityBuilder get editing =>
      _$this._editing ??= new EventEntityBuilder();
  set editing(EventEntityBuilder? editing) => _$this._editing = editing;

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

  EventUIStateBuilder();

  EventUIStateBuilder get _$this {
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
  void replace(EventUIState other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$EventUIState;
  }

  @override
  void update(void Function(EventUIStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EventUIState build() => _build();

  _$EventUIState _build() {
    _$EventUIState _$result;
    try {
      _$result = _$v ??
          new _$EventUIState._(
              editing: _editing?.build(),
              listUIState: listUIState.build(),
              selectedId: selectedId,
              forceSelected: forceSelected,
              tabIndex: BuiltValueNullFieldError.checkNotNull(
                  tabIndex, r'EventUIState', 'tabIndex'),
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
            r'EventUIState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
