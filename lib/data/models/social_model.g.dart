// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<SocialFilter> _$socialFilterSerializer =
    new _$SocialFilterSerializer();
Serializer<SocialListResponse> _$socialListResponseSerializer =
    new _$SocialListResponseSerializer();
Serializer<SocialItemResponse> _$socialItemResponseSerializer =
    new _$SocialItemResponseSerializer();
Serializer<SocialEntity> _$socialEntitySerializer =
    new _$SocialEntitySerializer();

class _$SocialFilterSerializer implements StructuredSerializer<SocialFilter> {
  @override
  final Iterable<Type> types = const [SocialFilter, _$SocialFilter];
  @override
  final String wireName = 'SocialFilter';

  @override
  Iterable<Object?> serialize(Serializers serializers, SocialFilter object,
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
  SocialFilter deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new SocialFilterBuilder();

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

class _$SocialListResponseSerializer
    implements StructuredSerializer<SocialListResponse> {
  @override
  final Iterable<Type> types = const [SocialListResponse, _$SocialListResponse];
  @override
  final String wireName = 'SocialListResponse';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, SocialListResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'data',
      serializers.serialize(object.data,
          specifiedType:
              const FullType(BuiltList, const [const FullType(SocialEntity)])),
    ];

    return result;
  }

  @override
  SocialListResponse deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new SocialListResponseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'data':
          result.data.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(SocialEntity)]))!
              as BuiltList<Object?>);
          break;
      }
    }

    return result.build();
  }
}

class _$SocialItemResponseSerializer
    implements StructuredSerializer<SocialItemResponse> {
  @override
  final Iterable<Type> types = const [SocialItemResponse, _$SocialItemResponse];
  @override
  final String wireName = 'SocialItemResponse';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, SocialItemResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'data',
      serializers.serialize(object.data,
          specifiedType: const FullType(SocialEntity)),
    ];

    return result;
  }

  @override
  SocialItemResponse deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new SocialItemResponseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'data':
          result.data.replace(serializers.deserialize(value,
              specifiedType: const FullType(SocialEntity))! as SocialEntity);
          break;
      }
    }

    return result.build();
  }
}

class _$SocialEntitySerializer implements StructuredSerializer<SocialEntity> {
  @override
  final Iterable<Type> types = const [SocialEntity, _$SocialEntity];
  @override
  final String wireName = 'SocialEntity';

  @override
  Iterable<Object?> serialize(Serializers serializers, SocialEntity object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'userDisplayName',
      serializers.serialize(object.userDisplayName,
          specifiedType: const FullType(String)),
      'userPhotoUrl',
      serializers.serialize(object.userPhotoUrl,
          specifiedType: const FullType(String)),
      'content',
      serializers.serialize(object.content,
          specifiedType: const FullType(String)),
      'photos',
      serializers.serialize(object.photos,
          specifiedType: const FullType(String)),
      'category',
      serializers.serialize(object.category,
          specifiedType: const FullType(String)),
      'likeCount',
      serializers.serialize(object.likeCount,
          specifiedType: const FullType(int)),
      'commentCount',
      serializers.serialize(object.commentCount,
          specifiedType: const FullType(int)),
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
  SocialEntity deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new SocialEntityBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'userDisplayName':
          result.userDisplayName = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'userPhotoUrl':
          result.userPhotoUrl = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'content':
          result.content = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'photos':
          result.photos = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'category':
          result.category = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'likeCount':
          result.likeCount = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'commentCount':
          result.commentCount = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
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

class _$SocialFilter extends SocialFilter {
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

  factory _$SocialFilter([void Function(SocialFilterBuilder)? updates]) =>
      (new SocialFilterBuilder()..update(updates))._build();

  _$SocialFilter._(
      {required this.searchTerm,
      required this.stateFilter,
      required this.sortField,
      required this.sortAscending,
      required this.limit})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        searchTerm, r'SocialFilter', 'searchTerm');
    BuiltValueNullFieldError.checkNotNull(
        stateFilter, r'SocialFilter', 'stateFilter');
    BuiltValueNullFieldError.checkNotNull(
        sortField, r'SocialFilter', 'sortField');
    BuiltValueNullFieldError.checkNotNull(
        sortAscending, r'SocialFilter', 'sortAscending');
    BuiltValueNullFieldError.checkNotNull(limit, r'SocialFilter', 'limit');
  }

  @override
  SocialFilter rebuild(void Function(SocialFilterBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SocialFilterBuilder toBuilder() => new SocialFilterBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SocialFilter &&
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
    return (newBuiltValueToStringHelper(r'SocialFilter')
          ..add('searchTerm', searchTerm)
          ..add('stateFilter', stateFilter)
          ..add('sortField', sortField)
          ..add('sortAscending', sortAscending)
          ..add('limit', limit))
        .toString();
  }
}

class SocialFilterBuilder
    implements Builder<SocialFilter, SocialFilterBuilder> {
  _$SocialFilter? _$v;

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

  SocialFilterBuilder();

  SocialFilterBuilder get _$this {
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
  void replace(SocialFilter other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$SocialFilter;
  }

  @override
  void update(void Function(SocialFilterBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SocialFilter build() => _build();

  _$SocialFilter _build() {
    final _$result = _$v ??
        new _$SocialFilter._(
            searchTerm: BuiltValueNullFieldError.checkNotNull(
                searchTerm, r'SocialFilter', 'searchTerm'),
            stateFilter: BuiltValueNullFieldError.checkNotNull(
                stateFilter, r'SocialFilter', 'stateFilter'),
            sortField: BuiltValueNullFieldError.checkNotNull(
                sortField, r'SocialFilter', 'sortField'),
            sortAscending: BuiltValueNullFieldError.checkNotNull(
                sortAscending, r'SocialFilter', 'sortAscending'),
            limit: BuiltValueNullFieldError.checkNotNull(
                limit, r'SocialFilter', 'limit'));
    replace(_$result);
    return _$result;
  }
}

class _$SocialListResponse extends SocialListResponse {
  @override
  final BuiltList<SocialEntity> data;

  factory _$SocialListResponse(
          [void Function(SocialListResponseBuilder)? updates]) =>
      (new SocialListResponseBuilder()..update(updates))._build();

  _$SocialListResponse._({required this.data}) : super._() {
    BuiltValueNullFieldError.checkNotNull(data, r'SocialListResponse', 'data');
  }

  @override
  SocialListResponse rebuild(
          void Function(SocialListResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SocialListResponseBuilder toBuilder() =>
      new SocialListResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SocialListResponse && data == other.data;
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
    return (newBuiltValueToStringHelper(r'SocialListResponse')
          ..add('data', data))
        .toString();
  }
}

class SocialListResponseBuilder
    implements Builder<SocialListResponse, SocialListResponseBuilder> {
  _$SocialListResponse? _$v;

  ListBuilder<SocialEntity>? _data;
  ListBuilder<SocialEntity> get data =>
      _$this._data ??= new ListBuilder<SocialEntity>();
  set data(ListBuilder<SocialEntity>? data) => _$this._data = data;

  SocialListResponseBuilder();

  SocialListResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SocialListResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$SocialListResponse;
  }

  @override
  void update(void Function(SocialListResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SocialListResponse build() => _build();

  _$SocialListResponse _build() {
    _$SocialListResponse _$result;
    try {
      _$result = _$v ?? new _$SocialListResponse._(data: data.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'SocialListResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$SocialItemResponse extends SocialItemResponse {
  @override
  final SocialEntity data;

  factory _$SocialItemResponse(
          [void Function(SocialItemResponseBuilder)? updates]) =>
      (new SocialItemResponseBuilder()..update(updates))._build();

  _$SocialItemResponse._({required this.data}) : super._() {
    BuiltValueNullFieldError.checkNotNull(data, r'SocialItemResponse', 'data');
  }

  @override
  SocialItemResponse rebuild(
          void Function(SocialItemResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SocialItemResponseBuilder toBuilder() =>
      new SocialItemResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SocialItemResponse && data == other.data;
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
    return (newBuiltValueToStringHelper(r'SocialItemResponse')
          ..add('data', data))
        .toString();
  }
}

class SocialItemResponseBuilder
    implements Builder<SocialItemResponse, SocialItemResponseBuilder> {
  _$SocialItemResponse? _$v;

  SocialEntityBuilder? _data;
  SocialEntityBuilder get data => _$this._data ??= new SocialEntityBuilder();
  set data(SocialEntityBuilder? data) => _$this._data = data;

  SocialItemResponseBuilder();

  SocialItemResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SocialItemResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$SocialItemResponse;
  }

  @override
  void update(void Function(SocialItemResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SocialItemResponse build() => _build();

  _$SocialItemResponse _build() {
    _$SocialItemResponse _$result;
    try {
      _$result = _$v ?? new _$SocialItemResponse._(data: data.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'SocialItemResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$SocialEntity extends SocialEntity {
  @override
  final String userDisplayName;
  @override
  final String userPhotoUrl;
  @override
  final String content;
  @override
  final String photos;
  @override
  final String category;
  @override
  final int likeCount;
  @override
  final int commentCount;
  @override
  final String tags;
  @override
  final Map<String, dynamic>? likesMap;
  @override
  final Map<String, dynamic>? commentsMap;
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

  factory _$SocialEntity([void Function(SocialEntityBuilder)? updates]) =>
      (new SocialEntityBuilder()..update(updates))._build();

  _$SocialEntity._(
      {required this.userDisplayName,
      required this.userPhotoUrl,
      required this.content,
      required this.photos,
      required this.category,
      required this.likeCount,
      required this.commentCount,
      required this.tags,
      this.likesMap,
      this.commentsMap,
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
    BuiltValueNullFieldError.checkNotNull(
        userDisplayName, r'SocialEntity', 'userDisplayName');
    BuiltValueNullFieldError.checkNotNull(
        userPhotoUrl, r'SocialEntity', 'userPhotoUrl');
    BuiltValueNullFieldError.checkNotNull(content, r'SocialEntity', 'content');
    BuiltValueNullFieldError.checkNotNull(photos, r'SocialEntity', 'photos');
    BuiltValueNullFieldError.checkNotNull(
        category, r'SocialEntity', 'category');
    BuiltValueNullFieldError.checkNotNull(
        likeCount, r'SocialEntity', 'likeCount');
    BuiltValueNullFieldError.checkNotNull(
        commentCount, r'SocialEntity', 'commentCount');
    BuiltValueNullFieldError.checkNotNull(tags, r'SocialEntity', 'tags');
    BuiltValueNullFieldError.checkNotNull(
        createdAt, r'SocialEntity', 'createdAt');
    BuiltValueNullFieldError.checkNotNull(
        updatedAt, r'SocialEntity', 'updatedAt');
    BuiltValueNullFieldError.checkNotNull(
        archivedAt, r'SocialEntity', 'archivedAt');
    BuiltValueNullFieldError.checkNotNull(id, r'SocialEntity', 'id');
  }

  @override
  SocialEntity rebuild(void Function(SocialEntityBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SocialEntityBuilder toBuilder() => new SocialEntityBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SocialEntity &&
        userDisplayName == other.userDisplayName &&
        userPhotoUrl == other.userPhotoUrl &&
        content == other.content &&
        photos == other.photos &&
        category == other.category &&
        likeCount == other.likeCount &&
        commentCount == other.commentCount &&
        tags == other.tags &&
        likesMap == other.likesMap &&
        commentsMap == other.commentsMap &&
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
    _$hash = $jc(_$hash, userDisplayName.hashCode);
    _$hash = $jc(_$hash, userPhotoUrl.hashCode);
    _$hash = $jc(_$hash, content.hashCode);
    _$hash = $jc(_$hash, photos.hashCode);
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, likeCount.hashCode);
    _$hash = $jc(_$hash, commentCount.hashCode);
    _$hash = $jc(_$hash, tags.hashCode);
    _$hash = $jc(_$hash, likesMap.hashCode);
    _$hash = $jc(_$hash, commentsMap.hashCode);
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
    return (newBuiltValueToStringHelper(r'SocialEntity')
          ..add('userDisplayName', userDisplayName)
          ..add('userPhotoUrl', userPhotoUrl)
          ..add('content', content)
          ..add('photos', photos)
          ..add('category', category)
          ..add('likeCount', likeCount)
          ..add('commentCount', commentCount)
          ..add('tags', tags)
          ..add('likesMap', likesMap)
          ..add('commentsMap', commentsMap)
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

class SocialEntityBuilder
    implements Builder<SocialEntity, SocialEntityBuilder> {
  _$SocialEntity? _$v;

  String? _userDisplayName;
  String? get userDisplayName => _$this._userDisplayName;
  set userDisplayName(String? userDisplayName) =>
      _$this._userDisplayName = userDisplayName;

  String? _userPhotoUrl;
  String? get userPhotoUrl => _$this._userPhotoUrl;
  set userPhotoUrl(String? userPhotoUrl) => _$this._userPhotoUrl = userPhotoUrl;

  String? _content;
  String? get content => _$this._content;
  set content(String? content) => _$this._content = content;

  String? _photos;
  String? get photos => _$this._photos;
  set photos(String? photos) => _$this._photos = photos;

  String? _category;
  String? get category => _$this._category;
  set category(String? category) => _$this._category = category;

  int? _likeCount;
  int? get likeCount => _$this._likeCount;
  set likeCount(int? likeCount) => _$this._likeCount = likeCount;

  int? _commentCount;
  int? get commentCount => _$this._commentCount;
  set commentCount(int? commentCount) => _$this._commentCount = commentCount;

  String? _tags;
  String? get tags => _$this._tags;
  set tags(String? tags) => _$this._tags = tags;

  Map<String, dynamic>? _likesMap;
  Map<String, dynamic>? get likesMap => _$this._likesMap;
  set likesMap(Map<String, dynamic>? likesMap) => _$this._likesMap = likesMap;

  Map<String, dynamic>? _commentsMap;
  Map<String, dynamic>? get commentsMap => _$this._commentsMap;
  set commentsMap(Map<String, dynamic>? commentsMap) =>
      _$this._commentsMap = commentsMap;

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

  SocialEntityBuilder();

  SocialEntityBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _userDisplayName = $v.userDisplayName;
      _userPhotoUrl = $v.userPhotoUrl;
      _content = $v.content;
      _photos = $v.photos;
      _category = $v.category;
      _likeCount = $v.likeCount;
      _commentCount = $v.commentCount;
      _tags = $v.tags;
      _likesMap = $v.likesMap;
      _commentsMap = $v.commentsMap;
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
  void replace(SocialEntity other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$SocialEntity;
  }

  @override
  void update(void Function(SocialEntityBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SocialEntity build() => _build();

  _$SocialEntity _build() {
    final _$result = _$v ??
        new _$SocialEntity._(
            userDisplayName: BuiltValueNullFieldError.checkNotNull(
                userDisplayName, r'SocialEntity', 'userDisplayName'),
            userPhotoUrl: BuiltValueNullFieldError.checkNotNull(
                userPhotoUrl, r'SocialEntity', 'userPhotoUrl'),
            content: BuiltValueNullFieldError.checkNotNull(
                content, r'SocialEntity', 'content'),
            photos: BuiltValueNullFieldError.checkNotNull(
                photos, r'SocialEntity', 'photos'),
            category: BuiltValueNullFieldError.checkNotNull(
                category, r'SocialEntity', 'category'),
            likeCount: BuiltValueNullFieldError.checkNotNull(
                likeCount, r'SocialEntity', 'likeCount'),
            commentCount: BuiltValueNullFieldError.checkNotNull(
                commentCount, r'SocialEntity', 'commentCount'),
            tags: BuiltValueNullFieldError.checkNotNull(
                tags, r'SocialEntity', 'tags'),
            likesMap: likesMap,
            commentsMap: commentsMap,
            reportsMap: reportsMap,
            reported: reported,
            isChanged: isChanged,
            createdAt:
                BuiltValueNullFieldError.checkNotNull(createdAt, r'SocialEntity', 'createdAt'),
            updatedAt: BuiltValueNullFieldError.checkNotNull(updatedAt, r'SocialEntity', 'updatedAt'),
            archivedAt: BuiltValueNullFieldError.checkNotNull(archivedAt, r'SocialEntity', 'archivedAt'),
            isDeleted: isDeleted,
            isReported: isReported,
            createdUserId: createdUserId,
            assignedUserId: assignedUserId,
            id: BuiltValueNullFieldError.checkNotNull(id, r'SocialEntity', 'id'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
