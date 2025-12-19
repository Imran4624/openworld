// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<ProductState> _$productStateSerializer =
    new _$ProductStateSerializer();
Serializer<ProductUIState> _$productUIStateSerializer =
    new _$ProductUIStateSerializer();

class _$ProductStateSerializer implements StructuredSerializer<ProductState> {
  @override
  final Iterable<Type> types = const [ProductState, _$ProductState];
  @override
  final String wireName = 'ProductState';

  @override
  Iterable<Object?> serialize(Serializers serializers, ProductState object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'map',
      serializers.serialize(object.map,
          specifiedType: const FullType(BuiltMap,
              const [const FullType(String), const FullType(ProductEntity)])),
      'list',
      serializers.serialize(object.list,
          specifiedType:
              const FullType(BuiltList, const [const FullType(String)])),
      'filter',
      serializers.serialize(object.filter,
          specifiedType: const FullType(ProductFilter)),
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
  ProductState deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ProductStateBuilder();

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
                const FullType(ProductEntity)
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
              specifiedType: const FullType(ProductFilter))! as ProductFilter);
          break;
      }
    }

    return result.build();
  }
}

class _$ProductUIStateSerializer
    implements StructuredSerializer<ProductUIState> {
  @override
  final Iterable<Type> types = const [ProductUIState, _$ProductUIState];
  @override
  final String wireName = 'ProductUIState';

  @override
  Iterable<Object?> serialize(Serializers serializers, ProductUIState object,
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
            specifiedType: const FullType(ProductEntity)));
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
  ProductUIState deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ProductUIStateBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'editing':
          result.editing.replace(serializers.deserialize(value,
              specifiedType: const FullType(ProductEntity))! as ProductEntity);
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

class _$ProductState extends ProductState {
  @override
  final BuiltMap<String, ProductEntity> map;
  @override
  final BuiltList<String> list;
  @override
  final DocumentSnapshot<Object?>? lastDocument;
  @override
  final ProductFilter filter;

  factory _$ProductState([void Function(ProductStateBuilder)? updates]) =>
      (new ProductStateBuilder()..update(updates))._build();

  _$ProductState._(
      {required this.map,
      required this.list,
      this.lastDocument,
      required this.filter})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(map, r'ProductState', 'map');
    BuiltValueNullFieldError.checkNotNull(list, r'ProductState', 'list');
    BuiltValueNullFieldError.checkNotNull(filter, r'ProductState', 'filter');
  }

  @override
  ProductState rebuild(void Function(ProductStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProductStateBuilder toBuilder() => new ProductStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProductState &&
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
    return (newBuiltValueToStringHelper(r'ProductState')
          ..add('map', map)
          ..add('list', list)
          ..add('lastDocument', lastDocument)
          ..add('filter', filter))
        .toString();
  }
}

class ProductStateBuilder
    implements Builder<ProductState, ProductStateBuilder> {
  _$ProductState? _$v;

  MapBuilder<String, ProductEntity>? _map;
  MapBuilder<String, ProductEntity> get map =>
      _$this._map ??= new MapBuilder<String, ProductEntity>();
  set map(MapBuilder<String, ProductEntity>? map) => _$this._map = map;

  ListBuilder<String>? _list;
  ListBuilder<String> get list => _$this._list ??= new ListBuilder<String>();
  set list(ListBuilder<String>? list) => _$this._list = list;

  DocumentSnapshot<Object?>? _lastDocument;
  DocumentSnapshot<Object?>? get lastDocument => _$this._lastDocument;
  set lastDocument(DocumentSnapshot<Object?>? lastDocument) =>
      _$this._lastDocument = lastDocument;

  ProductFilterBuilder? _filter;
  ProductFilterBuilder get filter =>
      _$this._filter ??= new ProductFilterBuilder();
  set filter(ProductFilterBuilder? filter) => _$this._filter = filter;

  ProductStateBuilder();

  ProductStateBuilder get _$this {
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
  void replace(ProductState other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ProductState;
  }

  @override
  void update(void Function(ProductStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProductState build() => _build();

  _$ProductState _build() {
    _$ProductState _$result;
    try {
      _$result = _$v ??
          new _$ProductState._(
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
            r'ProductState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$ProductUIState extends ProductUIState {
  @override
  final ProductEntity? editing;
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

  factory _$ProductUIState([void Function(ProductUIStateBuilder)? updates]) =>
      (new ProductUIStateBuilder()..update(updates))._build();

  _$ProductUIState._(
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
        dynamicFields, r'ProductUIState', 'dynamicFields');
    BuiltValueNullFieldError.checkNotNull(
        listUIState, r'ProductUIState', 'listUIState');
    BuiltValueNullFieldError.checkNotNull(
        tabIndex, r'ProductUIState', 'tabIndex');
  }

  @override
  ProductUIState rebuild(void Function(ProductUIStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProductUIStateBuilder toBuilder() =>
      new ProductUIStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProductUIState &&
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
    return (newBuiltValueToStringHelper(r'ProductUIState')
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

class ProductUIStateBuilder
    implements Builder<ProductUIState, ProductUIStateBuilder> {
  _$ProductUIState? _$v;

  ProductEntityBuilder? _editing;
  ProductEntityBuilder get editing =>
      _$this._editing ??= new ProductEntityBuilder();
  set editing(ProductEntityBuilder? editing) => _$this._editing = editing;

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

  ProductUIStateBuilder();

  ProductUIStateBuilder get _$this {
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
  void replace(ProductUIState other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ProductUIState;
  }

  @override
  void update(void Function(ProductUIStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProductUIState build() => _build();

  _$ProductUIState _build() {
    _$ProductUIState _$result;
    try {
      _$result = _$v ??
          new _$ProductUIState._(
              editing: _editing?.build(),
              dynamicFields: dynamicFields.build(),
              listUIState: listUIState.build(),
              selectedId: selectedId,
              forceSelected: forceSelected,
              tabIndex: BuiltValueNullFieldError.checkNotNull(
                  tabIndex, r'ProductUIState', 'tabIndex'),
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
            r'ProductUIState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
