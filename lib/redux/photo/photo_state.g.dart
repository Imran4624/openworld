// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<PhotoState> _$photoStateSerializer = new _$PhotoStateSerializer();
Serializer<PhotoUIState> _$photoUIStateSerializer =
    new _$PhotoUIStateSerializer();

class _$PhotoStateSerializer implements StructuredSerializer<PhotoState> {
  @override
  final Iterable<Type> types = const [PhotoState, _$PhotoState];
  @override
  final String wireName = 'PhotoState';

  @override
  Iterable<Object?> serialize(Serializers serializers, PhotoState object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'map',
      serializers.serialize(object.map,
          specifiedType: const FullType(BuiltMap,
              const [const FullType(String), const FullType(PhotoEntity)])),
      'list',
      serializers.serialize(object.list,
          specifiedType:
              const FullType(BuiltList, const [const FullType(String)])),
      'filter',
      serializers.serialize(object.filter,
          specifiedType: const FullType(PhotoFilter)),
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
  PhotoState deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new PhotoStateBuilder();

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
                const FullType(PhotoEntity)
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
              specifiedType: const FullType(PhotoFilter))! as PhotoFilter);
          break;
      }
    }

    return result.build();
  }
}

class _$PhotoUIStateSerializer implements StructuredSerializer<PhotoUIState> {
  @override
  final Iterable<Type> types = const [PhotoUIState, _$PhotoUIState];
  @override
  final String wireName = 'PhotoUIState';

  @override
  Iterable<Object?> serialize(Serializers serializers, PhotoUIState object,
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
            specifiedType: const FullType(PhotoEntity)));
    }
    value = object.defaultImageData;
    if (value != null) {
      result
        ..add('defaultImageData')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(
                Map, const [const FullType(String), const FullType(dynamic)])));
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
  PhotoUIState deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new PhotoUIStateBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'editing':
          result.editing.replace(serializers.deserialize(value,
              specifiedType: const FullType(PhotoEntity))! as PhotoEntity);
          break;
        case 'defaultImageData':
          result.defaultImageData = serializers.deserialize(value,
              specifiedType: const FullType(Map, const [
                const FullType(String),
                const FullType(dynamic)
              ])) as Map<String, dynamic>?;
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

class _$PhotoState extends PhotoState {
  @override
  final BuiltMap<String, PhotoEntity> map;
  @override
  final BuiltList<String> list;
  @override
  final DocumentSnapshot<Object?>? lastDocument;
  @override
  final PhotoFilter filter;

  factory _$PhotoState([void Function(PhotoStateBuilder)? updates]) =>
      (new PhotoStateBuilder()..update(updates))._build();

  _$PhotoState._(
      {required this.map,
      required this.list,
      this.lastDocument,
      required this.filter})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(map, r'PhotoState', 'map');
    BuiltValueNullFieldError.checkNotNull(list, r'PhotoState', 'list');
    BuiltValueNullFieldError.checkNotNull(filter, r'PhotoState', 'filter');
  }

  @override
  PhotoState rebuild(void Function(PhotoStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PhotoStateBuilder toBuilder() => new PhotoStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PhotoState &&
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
    return (newBuiltValueToStringHelper(r'PhotoState')
          ..add('map', map)
          ..add('list', list)
          ..add('lastDocument', lastDocument)
          ..add('filter', filter))
        .toString();
  }
}

class PhotoStateBuilder implements Builder<PhotoState, PhotoStateBuilder> {
  _$PhotoState? _$v;

  MapBuilder<String, PhotoEntity>? _map;
  MapBuilder<String, PhotoEntity> get map =>
      _$this._map ??= new MapBuilder<String, PhotoEntity>();
  set map(MapBuilder<String, PhotoEntity>? map) => _$this._map = map;

  ListBuilder<String>? _list;
  ListBuilder<String> get list => _$this._list ??= new ListBuilder<String>();
  set list(ListBuilder<String>? list) => _$this._list = list;

  DocumentSnapshot<Object?>? _lastDocument;
  DocumentSnapshot<Object?>? get lastDocument => _$this._lastDocument;
  set lastDocument(DocumentSnapshot<Object?>? lastDocument) =>
      _$this._lastDocument = lastDocument;

  PhotoFilterBuilder? _filter;
  PhotoFilterBuilder get filter => _$this._filter ??= new PhotoFilterBuilder();
  set filter(PhotoFilterBuilder? filter) => _$this._filter = filter;

  PhotoStateBuilder();

  PhotoStateBuilder get _$this {
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
  void replace(PhotoState other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$PhotoState;
  }

  @override
  void update(void Function(PhotoStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PhotoState build() => _build();

  _$PhotoState _build() {
    _$PhotoState _$result;
    try {
      _$result = _$v ??
          new _$PhotoState._(
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
            r'PhotoState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$PhotoUIState extends PhotoUIState {
  @override
  final PhotoEntity? editing;
  @override
  final Map<String, dynamic>? defaultImageData;
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

  factory _$PhotoUIState([void Function(PhotoUIStateBuilder)? updates]) =>
      (new PhotoUIStateBuilder()..update(updates))._build();

  _$PhotoUIState._(
      {this.editing,
      this.defaultImageData,
      required this.listUIState,
      this.selectedId,
      this.forceSelected,
      required this.tabIndex,
      this.saveCompleter,
      this.cancelCompleter})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        listUIState, r'PhotoUIState', 'listUIState');
    BuiltValueNullFieldError.checkNotNull(
        tabIndex, r'PhotoUIState', 'tabIndex');
  }

  @override
  PhotoUIState rebuild(void Function(PhotoUIStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PhotoUIStateBuilder toBuilder() => new PhotoUIStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PhotoUIState &&
        editing == other.editing &&
        defaultImageData == other.defaultImageData &&
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
    _$hash = $jc(_$hash, defaultImageData.hashCode);
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
    return (newBuiltValueToStringHelper(r'PhotoUIState')
          ..add('editing', editing)
          ..add('defaultImageData', defaultImageData)
          ..add('listUIState', listUIState)
          ..add('selectedId', selectedId)
          ..add('forceSelected', forceSelected)
          ..add('tabIndex', tabIndex)
          ..add('saveCompleter', saveCompleter)
          ..add('cancelCompleter', cancelCompleter))
        .toString();
  }
}

class PhotoUIStateBuilder
    implements Builder<PhotoUIState, PhotoUIStateBuilder> {
  _$PhotoUIState? _$v;

  PhotoEntityBuilder? _editing;
  PhotoEntityBuilder get editing =>
      _$this._editing ??= new PhotoEntityBuilder();
  set editing(PhotoEntityBuilder? editing) => _$this._editing = editing;

  Map<String, dynamic>? _defaultImageData;
  Map<String, dynamic>? get defaultImageData => _$this._defaultImageData;
  set defaultImageData(Map<String, dynamic>? defaultImageData) =>
      _$this._defaultImageData = defaultImageData;

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

  PhotoUIStateBuilder();

  PhotoUIStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _editing = $v.editing?.toBuilder();
      _defaultImageData = $v.defaultImageData;
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
  void replace(PhotoUIState other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$PhotoUIState;
  }

  @override
  void update(void Function(PhotoUIStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PhotoUIState build() => _build();

  _$PhotoUIState _build() {
    _$PhotoUIState _$result;
    try {
      _$result = _$v ??
          new _$PhotoUIState._(
              editing: _editing?.build(),
              defaultImageData: defaultImageData,
              listUIState: listUIState.build(),
              selectedId: selectedId,
              forceSelected: forceSelected,
              tabIndex: BuiltValueNullFieldError.checkNotNull(
                  tabIndex, r'PhotoUIState', 'tabIndex'),
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
            r'PhotoUIState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
