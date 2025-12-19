// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_operation_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<ProfileOperationFilter> _$profileOperationFilterSerializer =
    new _$ProfileOperationFilterSerializer();
Serializer<ProfileOperationListResponse>
    _$profileOperationListResponseSerializer =
    new _$ProfileOperationListResponseSerializer();
Serializer<ProfileOperationItemResponse>
    _$profileOperationItemResponseSerializer =
    new _$ProfileOperationItemResponseSerializer();
Serializer<ProfileOperationEntity> _$profileOperationEntitySerializer =
    new _$ProfileOperationEntitySerializer();

class _$ProfileOperationFilterSerializer
    implements StructuredSerializer<ProfileOperationFilter> {
  @override
  final Iterable<Type> types = const [
    ProfileOperationFilter,
    _$ProfileOperationFilter
  ];
  @override
  final String wireName = 'ProfileOperationFilter';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, ProfileOperationFilter object,
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
  ProfileOperationFilter deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ProfileOperationFilterBuilder();

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

class _$ProfileOperationListResponseSerializer
    implements StructuredSerializer<ProfileOperationListResponse> {
  @override
  final Iterable<Type> types = const [
    ProfileOperationListResponse,
    _$ProfileOperationListResponse
  ];
  @override
  final String wireName = 'ProfileOperationListResponse';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, ProfileOperationListResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'data',
      serializers.serialize(object.data,
          specifiedType: const FullType(
              BuiltList, const [const FullType(ProfileOperationEntity)])),
    ];

    return result;
  }

  @override
  ProfileOperationListResponse deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ProfileOperationListResponseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'data':
          result.data.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltList, const [
                const FullType(ProfileOperationEntity)
              ]))! as BuiltList<Object?>);
          break;
      }
    }

    return result.build();
  }
}

class _$ProfileOperationItemResponseSerializer
    implements StructuredSerializer<ProfileOperationItemResponse> {
  @override
  final Iterable<Type> types = const [
    ProfileOperationItemResponse,
    _$ProfileOperationItemResponse
  ];
  @override
  final String wireName = 'ProfileOperationItemResponse';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, ProfileOperationItemResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'data',
      serializers.serialize(object.data,
          specifiedType: const FullType(ProfileOperationEntity)),
    ];

    return result;
  }

  @override
  ProfileOperationItemResponse deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ProfileOperationItemResponseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'data':
          result.data.replace(serializers.deserialize(value,
                  specifiedType: const FullType(ProfileOperationEntity))!
              as ProfileOperationEntity);
          break;
      }
    }

    return result.build();
  }
}

class _$ProfileOperationEntitySerializer
    implements StructuredSerializer<ProfileOperationEntity> {
  @override
  final Iterable<Type> types = const [
    ProfileOperationEntity,
    _$ProfileOperationEntity
  ];
  @override
  final String wireName = 'ProfileOperationEntity';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, ProfileOperationEntity object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'status',
      serializers.serialize(object.status, specifiedType: const FullType(int)),
      'comment',
      serializers.serialize(object.comment,
          specifiedType: const FullType(String)),
      'type',
      serializers.serialize(object.type, specifiedType: const FullType(int)),
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
  ProfileOperationEntity deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ProfileOperationEntityBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'status':
          result.status = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'comment':
          result.comment = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'type':
          result.type = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
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

class _$ProfileOperationFilter extends ProfileOperationFilter {
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

  factory _$ProfileOperationFilter(
          [void Function(ProfileOperationFilterBuilder)? updates]) =>
      (new ProfileOperationFilterBuilder()..update(updates))._build();

  _$ProfileOperationFilter._(
      {required this.searchTerm,
      required this.stateFilter,
      required this.sortField,
      required this.sortAscending,
      required this.limit})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        searchTerm, r'ProfileOperationFilter', 'searchTerm');
    BuiltValueNullFieldError.checkNotNull(
        stateFilter, r'ProfileOperationFilter', 'stateFilter');
    BuiltValueNullFieldError.checkNotNull(
        sortField, r'ProfileOperationFilter', 'sortField');
    BuiltValueNullFieldError.checkNotNull(
        sortAscending, r'ProfileOperationFilter', 'sortAscending');
    BuiltValueNullFieldError.checkNotNull(
        limit, r'ProfileOperationFilter', 'limit');
  }

  @override
  ProfileOperationFilter rebuild(
          void Function(ProfileOperationFilterBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProfileOperationFilterBuilder toBuilder() =>
      new ProfileOperationFilterBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProfileOperationFilter &&
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
    return (newBuiltValueToStringHelper(r'ProfileOperationFilter')
          ..add('searchTerm', searchTerm)
          ..add('stateFilter', stateFilter)
          ..add('sortField', sortField)
          ..add('sortAscending', sortAscending)
          ..add('limit', limit))
        .toString();
  }
}

class ProfileOperationFilterBuilder
    implements Builder<ProfileOperationFilter, ProfileOperationFilterBuilder> {
  _$ProfileOperationFilter? _$v;

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

  ProfileOperationFilterBuilder();

  ProfileOperationFilterBuilder get _$this {
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
  void replace(ProfileOperationFilter other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ProfileOperationFilter;
  }

  @override
  void update(void Function(ProfileOperationFilterBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProfileOperationFilter build() => _build();

  _$ProfileOperationFilter _build() {
    final _$result = _$v ??
        new _$ProfileOperationFilter._(
            searchTerm: BuiltValueNullFieldError.checkNotNull(
                searchTerm, r'ProfileOperationFilter', 'searchTerm'),
            stateFilter: BuiltValueNullFieldError.checkNotNull(
                stateFilter, r'ProfileOperationFilter', 'stateFilter'),
            sortField: BuiltValueNullFieldError.checkNotNull(
                sortField, r'ProfileOperationFilter', 'sortField'),
            sortAscending: BuiltValueNullFieldError.checkNotNull(
                sortAscending, r'ProfileOperationFilter', 'sortAscending'),
            limit: BuiltValueNullFieldError.checkNotNull(
                limit, r'ProfileOperationFilter', 'limit'));
    replace(_$result);
    return _$result;
  }
}

class _$ProfileOperationListResponse extends ProfileOperationListResponse {
  @override
  final BuiltList<ProfileOperationEntity> data;

  factory _$ProfileOperationListResponse(
          [void Function(ProfileOperationListResponseBuilder)? updates]) =>
      (new ProfileOperationListResponseBuilder()..update(updates))._build();

  _$ProfileOperationListResponse._({required this.data}) : super._() {
    BuiltValueNullFieldError.checkNotNull(
        data, r'ProfileOperationListResponse', 'data');
  }

  @override
  ProfileOperationListResponse rebuild(
          void Function(ProfileOperationListResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProfileOperationListResponseBuilder toBuilder() =>
      new ProfileOperationListResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProfileOperationListResponse && data == other.data;
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
    return (newBuiltValueToStringHelper(r'ProfileOperationListResponse')
          ..add('data', data))
        .toString();
  }
}

class ProfileOperationListResponseBuilder
    implements
        Builder<ProfileOperationListResponse,
            ProfileOperationListResponseBuilder> {
  _$ProfileOperationListResponse? _$v;

  ListBuilder<ProfileOperationEntity>? _data;
  ListBuilder<ProfileOperationEntity> get data =>
      _$this._data ??= new ListBuilder<ProfileOperationEntity>();
  set data(ListBuilder<ProfileOperationEntity>? data) => _$this._data = data;

  ProfileOperationListResponseBuilder();

  ProfileOperationListResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProfileOperationListResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ProfileOperationListResponse;
  }

  @override
  void update(void Function(ProfileOperationListResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProfileOperationListResponse build() => _build();

  _$ProfileOperationListResponse _build() {
    _$ProfileOperationListResponse _$result;
    try {
      _$result =
          _$v ?? new _$ProfileOperationListResponse._(data: data.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'ProfileOperationListResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$ProfileOperationItemResponse extends ProfileOperationItemResponse {
  @override
  final ProfileOperationEntity data;

  factory _$ProfileOperationItemResponse(
          [void Function(ProfileOperationItemResponseBuilder)? updates]) =>
      (new ProfileOperationItemResponseBuilder()..update(updates))._build();

  _$ProfileOperationItemResponse._({required this.data}) : super._() {
    BuiltValueNullFieldError.checkNotNull(
        data, r'ProfileOperationItemResponse', 'data');
  }

  @override
  ProfileOperationItemResponse rebuild(
          void Function(ProfileOperationItemResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProfileOperationItemResponseBuilder toBuilder() =>
      new ProfileOperationItemResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProfileOperationItemResponse && data == other.data;
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
    return (newBuiltValueToStringHelper(r'ProfileOperationItemResponse')
          ..add('data', data))
        .toString();
  }
}

class ProfileOperationItemResponseBuilder
    implements
        Builder<ProfileOperationItemResponse,
            ProfileOperationItemResponseBuilder> {
  _$ProfileOperationItemResponse? _$v;

  ProfileOperationEntityBuilder? _data;
  ProfileOperationEntityBuilder get data =>
      _$this._data ??= new ProfileOperationEntityBuilder();
  set data(ProfileOperationEntityBuilder? data) => _$this._data = data;

  ProfileOperationItemResponseBuilder();

  ProfileOperationItemResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProfileOperationItemResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ProfileOperationItemResponse;
  }

  @override
  void update(void Function(ProfileOperationItemResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProfileOperationItemResponse build() => _build();

  _$ProfileOperationItemResponse _build() {
    _$ProfileOperationItemResponse _$result;
    try {
      _$result =
          _$v ?? new _$ProfileOperationItemResponse._(data: data.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'ProfileOperationItemResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$ProfileOperationEntity extends ProfileOperationEntity {
  @override
  final int status;
  @override
  final String comment;
  @override
  final int type;
  @override
  final ProfileEntity? profileEntity;
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

  factory _$ProfileOperationEntity(
          [void Function(ProfileOperationEntityBuilder)? updates]) =>
      (new ProfileOperationEntityBuilder()..update(updates))._build();

  _$ProfileOperationEntity._(
      {required this.status,
      required this.comment,
      required this.type,
      this.profileEntity,
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
        status, r'ProfileOperationEntity', 'status');
    BuiltValueNullFieldError.checkNotNull(
        comment, r'ProfileOperationEntity', 'comment');
    BuiltValueNullFieldError.checkNotNull(
        type, r'ProfileOperationEntity', 'type');
    BuiltValueNullFieldError.checkNotNull(
        createdAt, r'ProfileOperationEntity', 'createdAt');
    BuiltValueNullFieldError.checkNotNull(
        updatedAt, r'ProfileOperationEntity', 'updatedAt');
    BuiltValueNullFieldError.checkNotNull(
        archivedAt, r'ProfileOperationEntity', 'archivedAt');
    BuiltValueNullFieldError.checkNotNull(id, r'ProfileOperationEntity', 'id');
  }

  @override
  ProfileOperationEntity rebuild(
          void Function(ProfileOperationEntityBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProfileOperationEntityBuilder toBuilder() =>
      new ProfileOperationEntityBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProfileOperationEntity &&
        status == other.status &&
        comment == other.comment &&
        type == other.type &&
        profileEntity == other.profileEntity &&
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
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, comment.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, profileEntity.hashCode);
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
    return (newBuiltValueToStringHelper(r'ProfileOperationEntity')
          ..add('status', status)
          ..add('comment', comment)
          ..add('type', type)
          ..add('profileEntity', profileEntity)
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

class ProfileOperationEntityBuilder
    implements Builder<ProfileOperationEntity, ProfileOperationEntityBuilder> {
  _$ProfileOperationEntity? _$v;

  int? _status;
  int? get status => _$this._status;
  set status(int? status) => _$this._status = status;

  String? _comment;
  String? get comment => _$this._comment;
  set comment(String? comment) => _$this._comment = comment;

  int? _type;
  int? get type => _$this._type;
  set type(int? type) => _$this._type = type;

  ProfileEntityBuilder? _profileEntity;
  ProfileEntityBuilder get profileEntity =>
      _$this._profileEntity ??= new ProfileEntityBuilder();
  set profileEntity(ProfileEntityBuilder? profileEntity) =>
      _$this._profileEntity = profileEntity;

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

  ProfileOperationEntityBuilder();

  ProfileOperationEntityBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _comment = $v.comment;
      _type = $v.type;
      _profileEntity = $v.profileEntity?.toBuilder();
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
  void replace(ProfileOperationEntity other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ProfileOperationEntity;
  }

  @override
  void update(void Function(ProfileOperationEntityBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProfileOperationEntity build() => _build();

  _$ProfileOperationEntity _build() {
    _$ProfileOperationEntity _$result;
    try {
      _$result = _$v ??
          new _$ProfileOperationEntity._(
              status: BuiltValueNullFieldError.checkNotNull(
                  status, r'ProfileOperationEntity', 'status'),
              comment: BuiltValueNullFieldError.checkNotNull(
                  comment, r'ProfileOperationEntity', 'comment'),
              type: BuiltValueNullFieldError.checkNotNull(
                  type, r'ProfileOperationEntity', 'type'),
              profileEntity: _profileEntity?.build(),
              isChanged: isChanged,
              createdAt: BuiltValueNullFieldError.checkNotNull(
                  createdAt, r'ProfileOperationEntity', 'createdAt'),
              updatedAt: BuiltValueNullFieldError.checkNotNull(
                  updatedAt, r'ProfileOperationEntity', 'updatedAt'),
              archivedAt: BuiltValueNullFieldError.checkNotNull(
                  archivedAt, r'ProfileOperationEntity', 'archivedAt'),
              isDeleted: isDeleted,
              isReported: isReported,
              createdUserId: createdUserId,
              assignedUserId: assignedUserId,
              id: BuiltValueNullFieldError.checkNotNull(
                  id, r'ProfileOperationEntity', 'id'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'profileEntity';
        _profileEntity?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'ProfileOperationEntity', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
