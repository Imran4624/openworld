// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<SocialState> _$socialStateSerializer = new _$SocialStateSerializer();
Serializer<SocialUIState> _$socialUIStateSerializer =
    new _$SocialUIStateSerializer();

class _$SocialStateSerializer implements StructuredSerializer<SocialState> {
  @override
  final Iterable<Type> types = const [SocialState, _$SocialState];
  @override
  final String wireName = 'SocialState';

  @override
  Iterable<Object?> serialize(Serializers serializers, SocialState object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'map',
      serializers.serialize(object.map,
          specifiedType: const FullType(BuiltMap,
              const [const FullType(String), const FullType(SocialEntity)])),
      'list',
      serializers.serialize(object.list,
          specifiedType:
              const FullType(BuiltList, const [const FullType(String)])),
      'filter',
      serializers.serialize(object.filter,
          specifiedType: const FullType(SocialFilter)),
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
  SocialState deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new SocialStateBuilder();

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
                const FullType(SocialEntity)
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
              specifiedType: const FullType(SocialFilter))! as SocialFilter);
          break;
      }
    }

    return result.build();
  }
}

class _$SocialUIStateSerializer implements StructuredSerializer<SocialUIState> {
  @override
  final Iterable<Type> types = const [SocialUIState, _$SocialUIState];
  @override
  final String wireName = 'SocialUIState';

  @override
  Iterable<Object?> serialize(Serializers serializers, SocialUIState object,
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
            specifiedType: const FullType(SocialEntity)));
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
  SocialUIState deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new SocialUIStateBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'editing':
          result.editing.replace(serializers.deserialize(value,
              specifiedType: const FullType(SocialEntity))! as SocialEntity);
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

class _$SocialState extends SocialState {
  @override
  final BuiltMap<String, SocialEntity> map;
  @override
  final BuiltList<String> list;
  @override
  final DocumentSnapshot<Object?>? lastDocument;
  @override
  final SocialFilter filter;

  factory _$SocialState([void Function(SocialStateBuilder)? updates]) =>
      (new SocialStateBuilder()..update(updates))._build();

  _$SocialState._(
      {required this.map,
      required this.list,
      this.lastDocument,
      required this.filter})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(map, r'SocialState', 'map');
    BuiltValueNullFieldError.checkNotNull(list, r'SocialState', 'list');
    BuiltValueNullFieldError.checkNotNull(filter, r'SocialState', 'filter');
  }

  @override
  SocialState rebuild(void Function(SocialStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SocialStateBuilder toBuilder() => new SocialStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SocialState &&
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
    return (newBuiltValueToStringHelper(r'SocialState')
          ..add('map', map)
          ..add('list', list)
          ..add('lastDocument', lastDocument)
          ..add('filter', filter))
        .toString();
  }
}

class SocialStateBuilder implements Builder<SocialState, SocialStateBuilder> {
  _$SocialState? _$v;

  MapBuilder<String, SocialEntity>? _map;
  MapBuilder<String, SocialEntity> get map =>
      _$this._map ??= new MapBuilder<String, SocialEntity>();
  set map(MapBuilder<String, SocialEntity>? map) => _$this._map = map;

  ListBuilder<String>? _list;
  ListBuilder<String> get list => _$this._list ??= new ListBuilder<String>();
  set list(ListBuilder<String>? list) => _$this._list = list;

  DocumentSnapshot<Object?>? _lastDocument;
  DocumentSnapshot<Object?>? get lastDocument => _$this._lastDocument;
  set lastDocument(DocumentSnapshot<Object?>? lastDocument) =>
      _$this._lastDocument = lastDocument;

  SocialFilterBuilder? _filter;
  SocialFilterBuilder get filter =>
      _$this._filter ??= new SocialFilterBuilder();
  set filter(SocialFilterBuilder? filter) => _$this._filter = filter;

  SocialStateBuilder();

  SocialStateBuilder get _$this {
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
  void replace(SocialState other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$SocialState;
  }

  @override
  void update(void Function(SocialStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SocialState build() => _build();

  _$SocialState _build() {
    _$SocialState _$result;
    try {
      _$result = _$v ??
          new _$SocialState._(
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
            r'SocialState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$SocialUIState extends SocialUIState {
  @override
  final SocialEntity? editing;
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

  factory _$SocialUIState([void Function(SocialUIStateBuilder)? updates]) =>
      (new SocialUIStateBuilder()..update(updates))._build();

  _$SocialUIState._(
      {this.editing,
      required this.listUIState,
      this.selectedId,
      this.forceSelected,
      required this.tabIndex,
      this.saveCompleter,
      this.cancelCompleter})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        listUIState, r'SocialUIState', 'listUIState');
    BuiltValueNullFieldError.checkNotNull(
        tabIndex, r'SocialUIState', 'tabIndex');
  }

  @override
  SocialUIState rebuild(void Function(SocialUIStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SocialUIStateBuilder toBuilder() => new SocialUIStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SocialUIState &&
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
    return (newBuiltValueToStringHelper(r'SocialUIState')
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

class SocialUIStateBuilder
    implements Builder<SocialUIState, SocialUIStateBuilder> {
  _$SocialUIState? _$v;

  SocialEntityBuilder? _editing;
  SocialEntityBuilder get editing =>
      _$this._editing ??= new SocialEntityBuilder();
  set editing(SocialEntityBuilder? editing) => _$this._editing = editing;

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

  SocialUIStateBuilder();

  SocialUIStateBuilder get _$this {
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
  void replace(SocialUIState other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$SocialUIState;
  }

  @override
  void update(void Function(SocialUIStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SocialUIState build() => _build();

  _$SocialUIState _build() {
    _$SocialUIState _$result;
    try {
      _$result = _$v ??
          new _$SocialUIState._(
              editing: _editing?.build(),
              listUIState: listUIState.build(),
              selectedId: selectedId,
              forceSelected: forceSelected,
              tabIndex: BuiltValueNullFieldError.checkNotNull(
                  tabIndex, r'SocialUIState', 'tabIndex'),
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
            r'SocialUIState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
