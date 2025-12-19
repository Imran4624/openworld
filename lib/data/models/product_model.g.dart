// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<ProductFilter> _$productFilterSerializer =
    new _$ProductFilterSerializer();
Serializer<ProductListResponse> _$productListResponseSerializer =
    new _$ProductListResponseSerializer();
Serializer<ProductItemResponse> _$productItemResponseSerializer =
    new _$ProductItemResponseSerializer();
Serializer<ProductEntity> _$productEntitySerializer =
    new _$ProductEntitySerializer();

class _$ProductFilterSerializer implements StructuredSerializer<ProductFilter> {
  @override
  final Iterable<Type> types = const [ProductFilter, _$ProductFilter];
  @override
  final String wireName = 'ProductFilter';

  @override
  Iterable<Object?> serialize(Serializers serializers, ProductFilter object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'searchTerm',
      serializers.serialize(object.searchTerm,
          specifiedType: const FullType(String)),
      'stateFilter',
      serializers.serialize(object.stateFilter,
          specifiedType: const FullType(EntityState)),
      'sortField',
      serializers.serialize(object.sortField,
          specifiedType: const FullType(String)),
      'sortAscending',
      serializers.serialize(object.sortAscending,
          specifiedType: const FullType(bool)),
      'limit',
      serializers.serialize(object.limit, specifiedType: const FullType(int)),
      'dynamicFieldsFilters',
      serializers.serialize(object.dynamicFieldsFilters,
          specifiedType: const FullType(BuiltMap,
              const [const FullType(String), const FullType(dynamic)])),
    ];

    return result;
  }

  @override
  ProductFilter deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ProductFilterBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'searchTerm':
          result.searchTerm = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'stateFilter':
          result.stateFilter = serializers.deserialize(value,
              specifiedType: const FullType(EntityState))! as EntityState;
          break;
        case 'sortField':
          result.sortField = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'sortAscending':
          result.sortAscending = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
        case 'limit':
          result.limit = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'dynamicFieldsFilters':
          result.dynamicFieldsFilters.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltMap,
                  const [const FullType(String), const FullType(dynamic)]))!);
          break;
      }
    }

    return result.build();
  }
}

class _$ProductListResponseSerializer
    implements StructuredSerializer<ProductListResponse> {
  @override
  final Iterable<Type> types = const [
    ProductListResponse,
    _$ProductListResponse
  ];
  @override
  final String wireName = 'ProductListResponse';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, ProductListResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'data',
      serializers.serialize(object.data,
          specifiedType:
              const FullType(BuiltList, const [const FullType(ProductEntity)])),
    ];

    return result;
  }

  @override
  ProductListResponse deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ProductListResponseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'data':
          result.data.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(ProductEntity)]))!
              as BuiltList<Object?>);
          break;
      }
    }

    return result.build();
  }
}

class _$ProductItemResponseSerializer
    implements StructuredSerializer<ProductItemResponse> {
  @override
  final Iterable<Type> types = const [
    ProductItemResponse,
    _$ProductItemResponse
  ];
  @override
  final String wireName = 'ProductItemResponse';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, ProductItemResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'data',
      serializers.serialize(object.data,
          specifiedType: const FullType(ProductEntity)),
    ];

    return result;
  }

  @override
  ProductItemResponse deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ProductItemResponseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'data':
          result.data.replace(serializers.deserialize(value,
              specifiedType: const FullType(ProductEntity))! as ProductEntity);
          break;
      }
    }

    return result.build();
  }
}

class _$ProductEntitySerializer implements StructuredSerializer<ProductEntity> {
  @override
  final Iterable<Type> types = const [ProductEntity, _$ProductEntity];
  @override
  final String wireName = 'ProductEntity';

  @override
  Iterable<Object?> serialize(Serializers serializers, ProductEntity object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'dynamicFields',
      serializers.serialize(object.dynamicFields,
          specifiedType: const FullType(BuiltMap,
              const [const FullType(String), const FullType(dynamic)])),
      'isProductCompleted',
      serializers.serialize(object.isProductCompleted,
          specifiedType: const FullType(bool)),
      'created_at',
      serializers.serialize(object.createdAt,
          specifiedType: const FullType(int)),
      'updated_at',
      serializers.serialize(object.updatedAt,
          specifiedType: const FullType(int)),
      'archived_at',
      serializers.serialize(object.archivedAt,
          specifiedType: const FullType(int)),
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
    ];
    Object? value;
    value = object.isChanged;
    if (value != null) {
      result
        ..add('isChanged')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.isDeleted;
    if (value != null) {
      result
        ..add('is_deleted')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.isReported;
    if (value != null) {
      result
        ..add('reported')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.createdUserId;
    if (value != null) {
      result
        ..add('user_id')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.assignedUserId;
    if (value != null) {
      result
        ..add('assigned_user_id')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  ProductEntity deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ProductEntityBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'dynamicFields':
          result.dynamicFields.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltMap,
                  const [const FullType(String), const FullType(dynamic)]))!);
          break;
        case 'isProductCompleted':
          result.isProductCompleted = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
        case 'isChanged':
          result.isChanged = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'created_at':
          result.createdAt = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'updated_at':
          result.updatedAt = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'archived_at':
          result.archivedAt = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'is_deleted':
          result.isDeleted = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'reported':
          result.isReported = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'user_id':
          result.createdUserId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'assigned_user_id':
          result.assignedUserId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$ProductFilter extends ProductFilter {
  @override
  final String searchTerm;
  @override
  final EntityState stateFilter;
  @override
  final String sortField;
  @override
  final bool sortAscending;
  @override
  final int limit;
  @override
  final BuiltMap<String, dynamic> dynamicFieldsFilters;

  factory _$ProductFilter([void Function(ProductFilterBuilder)? updates]) =>
      (new ProductFilterBuilder()..update(updates))._build();

  _$ProductFilter._(
      {required this.searchTerm,
      required this.stateFilter,
      required this.sortField,
      required this.sortAscending,
      required this.limit,
      required this.dynamicFieldsFilters})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        searchTerm, r'ProductFilter', 'searchTerm');
    BuiltValueNullFieldError.checkNotNull(
        stateFilter, r'ProductFilter', 'stateFilter');
    BuiltValueNullFieldError.checkNotNull(
        sortField, r'ProductFilter', 'sortField');
    BuiltValueNullFieldError.checkNotNull(
        sortAscending, r'ProductFilter', 'sortAscending');
    BuiltValueNullFieldError.checkNotNull(limit, r'ProductFilter', 'limit');
    BuiltValueNullFieldError.checkNotNull(
        dynamicFieldsFilters, r'ProductFilter', 'dynamicFieldsFilters');
  }

  @override
  ProductFilter rebuild(void Function(ProductFilterBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProductFilterBuilder toBuilder() => new ProductFilterBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProductFilter &&
        searchTerm == other.searchTerm &&
        stateFilter == other.stateFilter &&
        sortField == other.sortField &&
        sortAscending == other.sortAscending &&
        limit == other.limit &&
        dynamicFieldsFilters == other.dynamicFieldsFilters;
  }

  int? __hashCode;
  @override
  int get hashCode {
    if (__hashCode != null) return __hashCode!;
    var _$hash = 0;
    _$hash = $jc(_$hash, searchTerm.hashCode);
    _$hash = $jc(_$hash, stateFilter.hashCode);
    _$hash = $jc(_$hash, sortField.hashCode);
    _$hash = $jc(_$hash, sortAscending.hashCode);
    _$hash = $jc(_$hash, limit.hashCode);
    _$hash = $jc(_$hash, dynamicFieldsFilters.hashCode);
    _$hash = $jf(_$hash);
    return __hashCode ??= _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProductFilter')
          ..add('searchTerm', searchTerm)
          ..add('stateFilter', stateFilter)
          ..add('sortField', sortField)
          ..add('sortAscending', sortAscending)
          ..add('limit', limit)
          ..add('dynamicFieldsFilters', dynamicFieldsFilters))
        .toString();
  }
}

class ProductFilterBuilder
    implements Builder<ProductFilter, ProductFilterBuilder> {
  _$ProductFilter? _$v;

  String? _searchTerm;
  String? get searchTerm => _$this._searchTerm;
  set searchTerm(String? searchTerm) => _$this._searchTerm = searchTerm;

  EntityState? _stateFilter;
  EntityState? get stateFilter => _$this._stateFilter;
  set stateFilter(EntityState? stateFilter) =>
      _$this._stateFilter = stateFilter;

  String? _sortField;
  String? get sortField => _$this._sortField;
  set sortField(String? sortField) => _$this._sortField = sortField;

  bool? _sortAscending;
  bool? get sortAscending => _$this._sortAscending;
  set sortAscending(bool? sortAscending) =>
      _$this._sortAscending = sortAscending;

  int? _limit;
  int? get limit => _$this._limit;
  set limit(int? limit) => _$this._limit = limit;

  MapBuilder<String, dynamic>? _dynamicFieldsFilters;
  MapBuilder<String, dynamic> get dynamicFieldsFilters =>
      _$this._dynamicFieldsFilters ??= new MapBuilder<String, dynamic>();
  set dynamicFieldsFilters(MapBuilder<String, dynamic>? dynamicFieldsFilters) =>
      _$this._dynamicFieldsFilters = dynamicFieldsFilters;

  ProductFilterBuilder();

  ProductFilterBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _searchTerm = $v.searchTerm;
      _stateFilter = $v.stateFilter;
      _sortField = $v.sortField;
      _sortAscending = $v.sortAscending;
      _limit = $v.limit;
      _dynamicFieldsFilters = $v.dynamicFieldsFilters.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProductFilter other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ProductFilter;
  }

  @override
  void update(void Function(ProductFilterBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProductFilter build() => _build();

  _$ProductFilter _build() {
    _$ProductFilter _$result;
    try {
      _$result = _$v ??
          new _$ProductFilter._(
              searchTerm: BuiltValueNullFieldError.checkNotNull(
                  searchTerm, r'ProductFilter', 'searchTerm'),
              stateFilter: BuiltValueNullFieldError.checkNotNull(
                  stateFilter, r'ProductFilter', 'stateFilter'),
              sortField: BuiltValueNullFieldError.checkNotNull(
                  sortField, r'ProductFilter', 'sortField'),
              sortAscending: BuiltValueNullFieldError.checkNotNull(
                  sortAscending, r'ProductFilter', 'sortAscending'),
              limit: BuiltValueNullFieldError.checkNotNull(
                  limit, r'ProductFilter', 'limit'),
              dynamicFieldsFilters: dynamicFieldsFilters.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'dynamicFieldsFilters';
        dynamicFieldsFilters.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'ProductFilter', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$ProductListResponse extends ProductListResponse {
  @override
  final BuiltList<ProductEntity> data;

  factory _$ProductListResponse(
          [void Function(ProductListResponseBuilder)? updates]) =>
      (new ProductListResponseBuilder()..update(updates))._build();

  _$ProductListResponse._({required this.data}) : super._() {
    BuiltValueNullFieldError.checkNotNull(data, r'ProductListResponse', 'data');
  }

  @override
  ProductListResponse rebuild(
          void Function(ProductListResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProductListResponseBuilder toBuilder() =>
      new ProductListResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProductListResponse && data == other.data;
  }

  int? __hashCode;
  @override
  int get hashCode {
    if (__hashCode != null) return __hashCode!;
    var _$hash = 0;
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jf(_$hash);
    return __hashCode ??= _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProductListResponse')
          ..add('data', data))
        .toString();
  }
}

class ProductListResponseBuilder
    implements Builder<ProductListResponse, ProductListResponseBuilder> {
  _$ProductListResponse? _$v;

  ListBuilder<ProductEntity>? _data;
  ListBuilder<ProductEntity> get data =>
      _$this._data ??= new ListBuilder<ProductEntity>();
  set data(ListBuilder<ProductEntity>? data) => _$this._data = data;

  ProductListResponseBuilder();

  ProductListResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProductListResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ProductListResponse;
  }

  @override
  void update(void Function(ProductListResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProductListResponse build() => _build();

  _$ProductListResponse _build() {
    _$ProductListResponse _$result;
    try {
      _$result = _$v ?? new _$ProductListResponse._(data: data.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'ProductListResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$ProductItemResponse extends ProductItemResponse {
  @override
  final ProductEntity data;

  factory _$ProductItemResponse(
          [void Function(ProductItemResponseBuilder)? updates]) =>
      (new ProductItemResponseBuilder()..update(updates))._build();

  _$ProductItemResponse._({required this.data}) : super._() {
    BuiltValueNullFieldError.checkNotNull(data, r'ProductItemResponse', 'data');
  }

  @override
  ProductItemResponse rebuild(
          void Function(ProductItemResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProductItemResponseBuilder toBuilder() =>
      new ProductItemResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProductItemResponse && data == other.data;
  }

  int? __hashCode;
  @override
  int get hashCode {
    if (__hashCode != null) return __hashCode!;
    var _$hash = 0;
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jf(_$hash);
    return __hashCode ??= _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProductItemResponse')
          ..add('data', data))
        .toString();
  }
}

class ProductItemResponseBuilder
    implements Builder<ProductItemResponse, ProductItemResponseBuilder> {
  _$ProductItemResponse? _$v;

  ProductEntityBuilder? _data;
  ProductEntityBuilder get data => _$this._data ??= new ProductEntityBuilder();
  set data(ProductEntityBuilder? data) => _$this._data = data;

  ProductItemResponseBuilder();

  ProductItemResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProductItemResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ProductItemResponse;
  }

  @override
  void update(void Function(ProductItemResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProductItemResponse build() => _build();

  _$ProductItemResponse _build() {
    _$ProductItemResponse _$result;
    try {
      _$result = _$v ?? new _$ProductItemResponse._(data: data.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'ProductItemResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$ProductEntity extends ProductEntity {
  @override
  final String name;
  @override
  final BuiltMap<String, dynamic> dynamicFields;
  @override
  final bool isProductCompleted;
  @override
  final bool? isChanged;
  @override
  final int createdAt;
  @override
  final int updatedAt;
  @override
  final int archivedAt;
  @override
  final bool? isDeleted;
  @override
  final bool? isReported;
  @override
  final String? createdUserId;
  @override
  final String? assignedUserId;
  @override
  final String id;

  factory _$ProductEntity([void Function(ProductEntityBuilder)? updates]) =>
      (new ProductEntityBuilder()..update(updates))._build();

  _$ProductEntity._(
      {required this.name,
      required this.dynamicFields,
      required this.isProductCompleted,
      this.isChanged,
      required this.createdAt,
      required this.updatedAt,
      required this.archivedAt,
      this.isDeleted,
      this.isReported,
      this.createdUserId,
      this.assignedUserId,
      required this.id})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(name, r'ProductEntity', 'name');
    BuiltValueNullFieldError.checkNotNull(
        dynamicFields, r'ProductEntity', 'dynamicFields');
    BuiltValueNullFieldError.checkNotNull(
        isProductCompleted, r'ProductEntity', 'isProductCompleted');
    BuiltValueNullFieldError.checkNotNull(
        createdAt, r'ProductEntity', 'createdAt');
    BuiltValueNullFieldError.checkNotNull(
        updatedAt, r'ProductEntity', 'updatedAt');
    BuiltValueNullFieldError.checkNotNull(
        archivedAt, r'ProductEntity', 'archivedAt');
    BuiltValueNullFieldError.checkNotNull(id, r'ProductEntity', 'id');
  }

  @override
  ProductEntity rebuild(void Function(ProductEntityBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProductEntityBuilder toBuilder() => new ProductEntityBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProductEntity &&
        name == other.name &&
        dynamicFields == other.dynamicFields &&
        isProductCompleted == other.isProductCompleted &&
        isChanged == other.isChanged &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        archivedAt == other.archivedAt &&
        isDeleted == other.isDeleted &&
        isReported == other.isReported &&
        createdUserId == other.createdUserId &&
        assignedUserId == other.assignedUserId &&
        id == other.id;
  }

  int? __hashCode;
  @override
  int get hashCode {
    if (__hashCode != null) return __hashCode!;
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, dynamicFields.hashCode);
    _$hash = $jc(_$hash, isProductCompleted.hashCode);
    _$hash = $jc(_$hash, isChanged.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, archivedAt.hashCode);
    _$hash = $jc(_$hash, isDeleted.hashCode);
    _$hash = $jc(_$hash, isReported.hashCode);
    _$hash = $jc(_$hash, createdUserId.hashCode);
    _$hash = $jc(_$hash, assignedUserId.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jf(_$hash);
    return __hashCode ??= _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProductEntity')
          ..add('name', name)
          ..add('dynamicFields', dynamicFields)
          ..add('isProductCompleted', isProductCompleted)
          ..add('isChanged', isChanged)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt)
          ..add('archivedAt', archivedAt)
          ..add('isDeleted', isDeleted)
          ..add('isReported', isReported)
          ..add('createdUserId', createdUserId)
          ..add('assignedUserId', assignedUserId)
          ..add('id', id))
        .toString();
  }
}

class ProductEntityBuilder
    implements Builder<ProductEntity, ProductEntityBuilder> {
  _$ProductEntity? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  MapBuilder<String, dynamic>? _dynamicFields;
  MapBuilder<String, dynamic> get dynamicFields =>
      _$this._dynamicFields ??= new MapBuilder<String, dynamic>();
  set dynamicFields(MapBuilder<String, dynamic>? dynamicFields) =>
      _$this._dynamicFields = dynamicFields;

  bool? _isProductCompleted;
  bool? get isProductCompleted => _$this._isProductCompleted;
  set isProductCompleted(bool? isProductCompleted) =>
      _$this._isProductCompleted = isProductCompleted;

  bool? _isChanged;
  bool? get isChanged => _$this._isChanged;
  set isChanged(bool? isChanged) => _$this._isChanged = isChanged;

  int? _createdAt;
  int? get createdAt => _$this._createdAt;
  set createdAt(int? createdAt) => _$this._createdAt = createdAt;

  int? _updatedAt;
  int? get updatedAt => _$this._updatedAt;
  set updatedAt(int? updatedAt) => _$this._updatedAt = updatedAt;

  int? _archivedAt;
  int? get archivedAt => _$this._archivedAt;
  set archivedAt(int? archivedAt) => _$this._archivedAt = archivedAt;

  bool? _isDeleted;
  bool? get isDeleted => _$this._isDeleted;
  set isDeleted(bool? isDeleted) => _$this._isDeleted = isDeleted;

  bool? _isReported;
  bool? get isReported => _$this._isReported;
  set isReported(bool? isReported) => _$this._isReported = isReported;

  String? _createdUserId;
  String? get createdUserId => _$this._createdUserId;
  set createdUserId(String? createdUserId) =>
      _$this._createdUserId = createdUserId;

  String? _assignedUserId;
  String? get assignedUserId => _$this._assignedUserId;
  set assignedUserId(String? assignedUserId) =>
      _$this._assignedUserId = assignedUserId;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  ProductEntityBuilder();

  ProductEntityBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _dynamicFields = $v.dynamicFields.toBuilder();
      _isProductCompleted = $v.isProductCompleted;
      _isChanged = $v.isChanged;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _archivedAt = $v.archivedAt;
      _isDeleted = $v.isDeleted;
      _isReported = $v.isReported;
      _createdUserId = $v.createdUserId;
      _assignedUserId = $v.assignedUserId;
      _id = $v.id;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProductEntity other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ProductEntity;
  }

  @override
  void update(void Function(ProductEntityBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProductEntity build() => _build();

  _$ProductEntity _build() {
    _$ProductEntity _$result;
    try {
      _$result = _$v ??
          new _$ProductEntity._(
              name: BuiltValueNullFieldError.checkNotNull(
                  name, r'ProductEntity', 'name'),
              dynamicFields: dynamicFields.build(),
              isProductCompleted: BuiltValueNullFieldError.checkNotNull(
                  isProductCompleted, r'ProductEntity', 'isProductCompleted'),
              isChanged: isChanged,
              createdAt: BuiltValueNullFieldError.checkNotNull(
                  createdAt, r'ProductEntity', 'createdAt'),
              updatedAt: BuiltValueNullFieldError.checkNotNull(
                  updatedAt, r'ProductEntity', 'updatedAt'),
              archivedAt: BuiltValueNullFieldError.checkNotNull(
                  archivedAt, r'ProductEntity', 'archivedAt'),
              isDeleted: isDeleted,
              isReported: isReported,
              createdUserId: createdUserId,
              assignedUserId: assignedUserId,
              id: BuiltValueNullFieldError.checkNotNull(
                  id, r'ProductEntity', 'id'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'dynamicFields';
        dynamicFields.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'ProductEntity', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
