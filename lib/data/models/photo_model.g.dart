// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<PhotoFilter> _$photoFilterSerializer = new _$PhotoFilterSerializer();
Serializer<PhotoListResponse> _$photoListResponseSerializer =
    new _$PhotoListResponseSerializer();
Serializer<PhotoItemResponse> _$photoItemResponseSerializer =
    new _$PhotoItemResponseSerializer();
Serializer<PhotoEntity> _$photoEntitySerializer = new _$PhotoEntitySerializer();

class _$PhotoFilterSerializer implements StructuredSerializer<PhotoFilter> {
  @override
  final Iterable<Type> types = const [PhotoFilter, _$PhotoFilter];
  @override
  final String wireName = 'PhotoFilter';

  @override
  Iterable<Object?> serialize(Serializers serializers, PhotoFilter object,
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
    ];

    return result;
  }

  @override
  PhotoFilter deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new PhotoFilterBuilder();

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
      }
    }

    return result.build();
  }
}

class _$PhotoListResponseSerializer
    implements StructuredSerializer<PhotoListResponse> {
  @override
  final Iterable<Type> types = const [PhotoListResponse, _$PhotoListResponse];
  @override
  final String wireName = 'PhotoListResponse';

  @override
  Iterable<Object?> serialize(Serializers serializers, PhotoListResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'data',
      serializers.serialize(object.data,
          specifiedType:
              const FullType(BuiltList, const [const FullType(PhotoEntity)])),
    ];

    return result;
  }

  @override
  PhotoListResponse deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new PhotoListResponseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'data':
          result.data.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(PhotoEntity)]))!
              as BuiltList<Object?>);
          break;
      }
    }

    return result.build();
  }
}

class _$PhotoItemResponseSerializer
    implements StructuredSerializer<PhotoItemResponse> {
  @override
  final Iterable<Type> types = const [PhotoItemResponse, _$PhotoItemResponse];
  @override
  final String wireName = 'PhotoItemResponse';

  @override
  Iterable<Object?> serialize(Serializers serializers, PhotoItemResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'data',
      serializers.serialize(object.data,
          specifiedType: const FullType(PhotoEntity)),
    ];

    return result;
  }

  @override
  PhotoItemResponse deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new PhotoItemResponseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'data':
          result.data.replace(serializers.deserialize(value,
              specifiedType: const FullType(PhotoEntity))! as PhotoEntity);
          break;
      }
    }

    return result.build();
  }
}

class _$PhotoEntitySerializer implements StructuredSerializer<PhotoEntity> {
  @override
  final Iterable<Type> types = const [PhotoEntity, _$PhotoEntity];
  @override
  final String wireName = 'PhotoEntity';

  @override
  Iterable<Object?> serialize(Serializers serializers, PhotoEntity object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'category',
      serializers.serialize(object.category,
          specifiedType: const FullType(String)),
      'storageType',
      serializers.serialize(object.storageType,
          specifiedType: const FullType(int)),
      'url',
      serializers.serialize(object.url, specifiedType: const FullType(String)),
      'isProcessed',
      serializers.serialize(object.isProcessed,
          specifiedType: const FullType(bool)),
      'tags',
      serializers.serialize(object.tags, specifiedType: const FullType(String)),
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
    value = object.reported;
    if (value != null) {
      result
        ..add('reported')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
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
  PhotoEntity deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new PhotoEntityBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'category':
          result.category = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'storageType':
          result.storageType = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'url':
          result.url = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'isProcessed':
          result.isProcessed = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
        case 'tags':
          result.tags = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'reported':
          result.reported = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
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

class _$PhotoFilter extends PhotoFilter {
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

  factory _$PhotoFilter([void Function(PhotoFilterBuilder)? updates]) =>
      (new PhotoFilterBuilder()..update(updates))._build();

  _$PhotoFilter._(
      {required this.searchTerm,
      required this.stateFilter,
      required this.sortField,
      required this.sortAscending,
      required this.limit})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        searchTerm, r'PhotoFilter', 'searchTerm');
    BuiltValueNullFieldError.checkNotNull(
        stateFilter, r'PhotoFilter', 'stateFilter');
    BuiltValueNullFieldError.checkNotNull(
        sortField, r'PhotoFilter', 'sortField');
    BuiltValueNullFieldError.checkNotNull(
        sortAscending, r'PhotoFilter', 'sortAscending');
    BuiltValueNullFieldError.checkNotNull(limit, r'PhotoFilter', 'limit');
  }

  @override
  PhotoFilter rebuild(void Function(PhotoFilterBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PhotoFilterBuilder toBuilder() => new PhotoFilterBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PhotoFilter &&
        searchTerm == other.searchTerm &&
        stateFilter == other.stateFilter &&
        sortField == other.sortField &&
        sortAscending == other.sortAscending &&
        limit == other.limit;
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
    _$hash = $jf(_$hash);
    return __hashCode ??= _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PhotoFilter')
          ..add('searchTerm', searchTerm)
          ..add('stateFilter', stateFilter)
          ..add('sortField', sortField)
          ..add('sortAscending', sortAscending)
          ..add('limit', limit))
        .toString();
  }
}

class PhotoFilterBuilder implements Builder<PhotoFilter, PhotoFilterBuilder> {
  _$PhotoFilter? _$v;

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

  PhotoFilterBuilder();

  PhotoFilterBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _searchTerm = $v.searchTerm;
      _stateFilter = $v.stateFilter;
      _sortField = $v.sortField;
      _sortAscending = $v.sortAscending;
      _limit = $v.limit;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PhotoFilter other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$PhotoFilter;
  }

  @override
  void update(void Function(PhotoFilterBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PhotoFilter build() => _build();

  _$PhotoFilter _build() {
    final _$result = _$v ??
        new _$PhotoFilter._(
            searchTerm: BuiltValueNullFieldError.checkNotNull(
                searchTerm, r'PhotoFilter', 'searchTerm'),
            stateFilter: BuiltValueNullFieldError.checkNotNull(
                stateFilter, r'PhotoFilter', 'stateFilter'),
            sortField: BuiltValueNullFieldError.checkNotNull(
                sortField, r'PhotoFilter', 'sortField'),
            sortAscending: BuiltValueNullFieldError.checkNotNull(
                sortAscending, r'PhotoFilter', 'sortAscending'),
            limit: BuiltValueNullFieldError.checkNotNull(
                limit, r'PhotoFilter', 'limit'));
    replace(_$result);
    return _$result;
  }
}

class _$PhotoListResponse extends PhotoListResponse {
  @override
  final BuiltList<PhotoEntity> data;

  factory _$PhotoListResponse(
          [void Function(PhotoListResponseBuilder)? updates]) =>
      (new PhotoListResponseBuilder()..update(updates))._build();

  _$PhotoListResponse._({required this.data}) : super._() {
    BuiltValueNullFieldError.checkNotNull(data, r'PhotoListResponse', 'data');
  }

  @override
  PhotoListResponse rebuild(void Function(PhotoListResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PhotoListResponseBuilder toBuilder() =>
      new PhotoListResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PhotoListResponse && data == other.data;
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
    return (newBuiltValueToStringHelper(r'PhotoListResponse')
          ..add('data', data))
        .toString();
  }
}

class PhotoListResponseBuilder
    implements Builder<PhotoListResponse, PhotoListResponseBuilder> {
  _$PhotoListResponse? _$v;

  ListBuilder<PhotoEntity>? _data;
  ListBuilder<PhotoEntity> get data =>
      _$this._data ??= new ListBuilder<PhotoEntity>();
  set data(ListBuilder<PhotoEntity>? data) => _$this._data = data;

  PhotoListResponseBuilder();

  PhotoListResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PhotoListResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$PhotoListResponse;
  }

  @override
  void update(void Function(PhotoListResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PhotoListResponse build() => _build();

  _$PhotoListResponse _build() {
    _$PhotoListResponse _$result;
    try {
      _$result = _$v ?? new _$PhotoListResponse._(data: data.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'PhotoListResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$PhotoItemResponse extends PhotoItemResponse {
  @override
  final PhotoEntity data;

  factory _$PhotoItemResponse(
          [void Function(PhotoItemResponseBuilder)? updates]) =>
      (new PhotoItemResponseBuilder()..update(updates))._build();

  _$PhotoItemResponse._({required this.data}) : super._() {
    BuiltValueNullFieldError.checkNotNull(data, r'PhotoItemResponse', 'data');
  }

  @override
  PhotoItemResponse rebuild(void Function(PhotoItemResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PhotoItemResponseBuilder toBuilder() =>
      new PhotoItemResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PhotoItemResponse && data == other.data;
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
    return (newBuiltValueToStringHelper(r'PhotoItemResponse')
          ..add('data', data))
        .toString();
  }
}

class PhotoItemResponseBuilder
    implements Builder<PhotoItemResponse, PhotoItemResponseBuilder> {
  _$PhotoItemResponse? _$v;

  PhotoEntityBuilder? _data;
  PhotoEntityBuilder get data => _$this._data ??= new PhotoEntityBuilder();
  set data(PhotoEntityBuilder? data) => _$this._data = data;

  PhotoItemResponseBuilder();

  PhotoItemResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PhotoItemResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$PhotoItemResponse;
  }

  @override
  void update(void Function(PhotoItemResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PhotoItemResponse build() => _build();

  _$PhotoItemResponse _build() {
    _$PhotoItemResponse _$result;
    try {
      _$result = _$v ?? new _$PhotoItemResponse._(data: data.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'PhotoItemResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$PhotoEntity extends PhotoEntity {
  @override
  final String category;
  @override
  final int storageType;
  @override
  final String url;
  @override
  final bool isProcessed;
  @override
  final String tags;
  @override
  final Map<String, dynamic>? reportsMap;
  @override
  final bool? reported;
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

  factory _$PhotoEntity([void Function(PhotoEntityBuilder)? updates]) =>
      (new PhotoEntityBuilder()..update(updates))._build();

  _$PhotoEntity._(
      {required this.category,
      required this.storageType,
      required this.url,
      required this.isProcessed,
      required this.tags,
      this.reportsMap,
      this.reported,
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
    BuiltValueNullFieldError.checkNotNull(category, r'PhotoEntity', 'category');
    BuiltValueNullFieldError.checkNotNull(
        storageType, r'PhotoEntity', 'storageType');
    BuiltValueNullFieldError.checkNotNull(url, r'PhotoEntity', 'url');
    BuiltValueNullFieldError.checkNotNull(
        isProcessed, r'PhotoEntity', 'isProcessed');
    BuiltValueNullFieldError.checkNotNull(tags, r'PhotoEntity', 'tags');
    BuiltValueNullFieldError.checkNotNull(
        createdAt, r'PhotoEntity', 'createdAt');
    BuiltValueNullFieldError.checkNotNull(
        updatedAt, r'PhotoEntity', 'updatedAt');
    BuiltValueNullFieldError.checkNotNull(
        archivedAt, r'PhotoEntity', 'archivedAt');
    BuiltValueNullFieldError.checkNotNull(id, r'PhotoEntity', 'id');
  }

  @override
  PhotoEntity rebuild(void Function(PhotoEntityBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PhotoEntityBuilder toBuilder() => new PhotoEntityBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PhotoEntity &&
        category == other.category &&
        storageType == other.storageType &&
        url == other.url &&
        isProcessed == other.isProcessed &&
        tags == other.tags &&
        reportsMap == other.reportsMap &&
        reported == other.reported &&
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
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, storageType.hashCode);
    _$hash = $jc(_$hash, url.hashCode);
    _$hash = $jc(_$hash, isProcessed.hashCode);
    _$hash = $jc(_$hash, tags.hashCode);
    _$hash = $jc(_$hash, reportsMap.hashCode);
    _$hash = $jc(_$hash, reported.hashCode);
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
    return (newBuiltValueToStringHelper(r'PhotoEntity')
          ..add('category', category)
          ..add('storageType', storageType)
          ..add('url', url)
          ..add('isProcessed', isProcessed)
          ..add('tags', tags)
          ..add('reportsMap', reportsMap)
          ..add('reported', reported)
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

class PhotoEntityBuilder implements Builder<PhotoEntity, PhotoEntityBuilder> {
  _$PhotoEntity? _$v;

  String? _category;
  String? get category => _$this._category;
  set category(String? category) => _$this._category = category;

  int? _storageType;
  int? get storageType => _$this._storageType;
  set storageType(int? storageType) => _$this._storageType = storageType;

  String? _url;
  String? get url => _$this._url;
  set url(String? url) => _$this._url = url;

  bool? _isProcessed;
  bool? get isProcessed => _$this._isProcessed;
  set isProcessed(bool? isProcessed) => _$this._isProcessed = isProcessed;

  String? _tags;
  String? get tags => _$this._tags;
  set tags(String? tags) => _$this._tags = tags;

  Map<String, dynamic>? _reportsMap;
  Map<String, dynamic>? get reportsMap => _$this._reportsMap;
  set reportsMap(Map<String, dynamic>? reportsMap) =>
      _$this._reportsMap = reportsMap;

  bool? _reported;
  bool? get reported => _$this._reported;
  set reported(bool? reported) => _$this._reported = reported;

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

  PhotoEntityBuilder();

  PhotoEntityBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _category = $v.category;
      _storageType = $v.storageType;
      _url = $v.url;
      _isProcessed = $v.isProcessed;
      _tags = $v.tags;
      _reportsMap = $v.reportsMap;
      _reported = $v.reported;
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
  void replace(PhotoEntity other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$PhotoEntity;
  }

  @override
  void update(void Function(PhotoEntityBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PhotoEntity build() => _build();

  _$PhotoEntity _build() {
    final _$result = _$v ??
        new _$PhotoEntity._(
            category: BuiltValueNullFieldError.checkNotNull(
                category, r'PhotoEntity', 'category'),
            storageType: BuiltValueNullFieldError.checkNotNull(
                storageType, r'PhotoEntity', 'storageType'),
            url: BuiltValueNullFieldError.checkNotNull(
                url, r'PhotoEntity', 'url'),
            isProcessed: BuiltValueNullFieldError.checkNotNull(
                isProcessed, r'PhotoEntity', 'isProcessed'),
            tags: BuiltValueNullFieldError.checkNotNull(
                tags, r'PhotoEntity', 'tags'),
            reportsMap: reportsMap,
            reported: reported,
            isChanged: isChanged,
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'PhotoEntity', 'createdAt'),
            updatedAt: BuiltValueNullFieldError.checkNotNull(
                updatedAt, r'PhotoEntity', 'updatedAt'),
            archivedAt: BuiltValueNullFieldError.checkNotNull(
                archivedAt, r'PhotoEntity', 'archivedAt'),
            isDeleted: isDeleted,
            isReported: isReported,
            createdUserId: createdUserId,
            assignedUserId: assignedUserId,
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'PhotoEntity', 'id'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
