// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<ProfileReport> _$profileReportSerializer =
    new _$ProfileReportSerializer();
Serializer<ProfileFilter> _$profileFilterSerializer =
    new _$ProfileFilterSerializer();
Serializer<UserCompany> _$userCompanySerializer = new _$UserCompanySerializer();
Serializer<ProfileListResponse> _$profileListResponseSerializer =
    new _$ProfileListResponseSerializer();
Serializer<ProfilePaginationResponse> _$profilePaginationResponseSerializer =
    new _$ProfilePaginationResponseSerializer();
Serializer<ProfileSingleResponse> _$profileSingleResponseSerializer =
    new _$ProfileSingleResponseSerializer();
Serializer<ProfileItemResponse> _$profileItemResponseSerializer =
    new _$ProfileItemResponseSerializer();
Serializer<ProfileEntity> _$profileEntitySerializer =
    new _$ProfileEntitySerializer();

class _$ProfileReportSerializer implements StructuredSerializer<ProfileReport> {
  @override
  final Iterable<Type> types = const [ProfileReport, _$ProfileReport];
  @override
  final String wireName = 'ProfileReport';

  @override
  Iterable<Object?> serialize(Serializers serializers, ProfileReport object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'userId',
      serializers.serialize(object.userId,
          specifiedType: const FullType(String)),
      'comment',
      serializers.serialize(object.comment,
          specifiedType: const FullType(String)),
      'timestamp',
      serializers.serialize(object.timestamp,
          specifiedType: const FullType(int)),
    ];

    return result;
  }

  @override
  ProfileReport deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ProfileReportBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'userId':
          result.userId = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'comment':
          result.comment = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'timestamp':
          result.timestamp = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
      }
    }

    return result.build();
  }
}

class _$ProfileFilterSerializer implements StructuredSerializer<ProfileFilter> {
  @override
  final Iterable<Type> types = const [ProfileFilter, _$ProfileFilter];
  @override
  final String wireName = 'ProfileFilter';

  @override
  Iterable<Object?> serialize(Serializers serializers, ProfileFilter object,
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
      'currentUserId',
      serializers.serialize(object.currentUserId,
          specifiedType: const FullType(String)),
      'preferredGender',
      serializers.serialize(object.preferredGender,
          specifiedType: const FullType(String)),
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
  ProfileFilter deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ProfileFilterBuilder();

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
        case 'currentUserId':
          result.currentUserId = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'preferredGender':
          result.preferredGender = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
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

class _$UserCompanySerializer implements StructuredSerializer<UserCompany> {
  @override
  final Iterable<Type> types = const [UserCompany, _$UserCompany];
  @override
  final String wireName = 'UserCompany';

  @override
  Iterable<Object?> serialize(Serializers serializers, UserCompany object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'companyId',
      serializers.serialize(object.companyId,
          specifiedType: const FullType(String)),
      'companyName',
      serializers.serialize(object.companyName,
          specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  UserCompany deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new UserCompanyBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'companyId':
          result.companyId = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'companyName':
          result.companyName = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$ProfileListResponseSerializer
    implements StructuredSerializer<ProfileListResponse> {
  @override
  final Iterable<Type> types = const [
    ProfileListResponse,
    _$ProfileListResponse
  ];
  @override
  final String wireName = 'ProfileListResponse';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, ProfileListResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'data',
      serializers.serialize(object.data,
          specifiedType:
              const FullType(BuiltList, const [const FullType(ProfileEntity)])),
    ];

    return result;
  }

  @override
  ProfileListResponse deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ProfileListResponseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'data':
          result.data.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(ProfileEntity)]))!
              as BuiltList<Object?>);
          break;
      }
    }

    return result.build();
  }
}

class _$ProfilePaginationResponseSerializer
    implements StructuredSerializer<ProfilePaginationResponse> {
  @override
  final Iterable<Type> types = const [
    ProfilePaginationResponse,
    _$ProfilePaginationResponse
  ];
  @override
  final String wireName = 'ProfilePaginationResponse';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, ProfilePaginationResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'profiles',
      serializers.serialize(object.profiles,
          specifiedType:
              const FullType(BuiltList, const [const FullType(ProfileEntity)])),
    ];

    return result;
  }

  @override
  ProfilePaginationResponse deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ProfilePaginationResponseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'profiles':
          result.profiles.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(ProfileEntity)]))!
              as BuiltList<Object?>);
          break;
      }
    }

    return result.build();
  }
}

class _$ProfileSingleResponseSerializer
    implements StructuredSerializer<ProfileSingleResponse> {
  @override
  final Iterable<Type> types = const [
    ProfileSingleResponse,
    _$ProfileSingleResponse
  ];
  @override
  final String wireName = 'ProfileSingleResponse';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, ProfileSingleResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[];
    Object? value;
    value = object.profile;
    if (value != null) {
      result
        ..add('profile')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(ProfileEntity)));
    }
    return result;
  }

  @override
  ProfileSingleResponse deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ProfileSingleResponseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'profile':
          result.profile.replace(serializers.deserialize(value,
              specifiedType: const FullType(ProfileEntity))! as ProfileEntity);
          break;
      }
    }

    return result.build();
  }
}

class _$ProfileItemResponseSerializer
    implements StructuredSerializer<ProfileItemResponse> {
  @override
  final Iterable<Type> types = const [
    ProfileItemResponse,
    _$ProfileItemResponse
  ];
  @override
  final String wireName = 'ProfileItemResponse';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, ProfileItemResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'data',
      serializers.serialize(object.data,
          specifiedType: const FullType(ProfileEntity)),
    ];

    return result;
  }

  @override
  ProfileItemResponse deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ProfileItemResponseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'data':
          result.data.replace(serializers.deserialize(value,
              specifiedType: const FullType(ProfileEntity))! as ProfileEntity);
          break;
      }
    }

    return result.build();
  }
}

class _$ProfileEntitySerializer implements StructuredSerializer<ProfileEntity> {
  @override
  final Iterable<Type> types = const [ProfileEntity, _$ProfileEntity];
  @override
  final String wireName = 'ProfileEntity';

  @override
  Iterable<Object?> serialize(Serializers serializers, ProfileEntity object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'email',
      serializers.serialize(object.email,
          specifiedType: const FullType(String)),
      'companyIds',
      serializers.serialize(object.companyIds,
          specifiedType:
              const FullType(BuiltList, const [const FullType(String)])),
      'dynamicFields',
      serializers.serialize(object.dynamicFields,
          specifiedType: const FullType(BuiltMap,
              const [const FullType(String), const FullType(dynamic)])),
      'isProfileCompleted',
      serializers.serialize(object.isProfileCompleted,
          specifiedType: const FullType(bool)),
      'isAdmin',
      serializers.serialize(object.isAdmin,
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
    value = object.paymentStatus;
    if (value != null) {
      result
        ..add('payment_status')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.orgStripeAccountId;
    if (value != null) {
      result
        ..add('org_stripe_account_id')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
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
  ProfileEntity deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ProfileEntityBuilder();

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
        case 'email':
          result.email = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'companyIds':
          result.companyIds.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(String)]))!
              as BuiltList<Object?>);
          break;
        case 'payment_status':
          result.paymentStatus = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'org_stripe_account_id':
          result.orgStripeAccountId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'dynamicFields':
          result.dynamicFields.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltMap,
                  const [const FullType(String), const FullType(dynamic)]))!);
          break;
        case 'isProfileCompleted':
          result.isProfileCompleted = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
        case 'isAdmin':
          result.isAdmin = serializers.deserialize(value,
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

class _$ProfileReport extends ProfileReport {
  @override
  final String userId;
  @override
  final String comment;
  @override
  final int timestamp;

  factory _$ProfileReport([void Function(ProfileReportBuilder)? updates]) =>
      (new ProfileReportBuilder()..update(updates))._build();

  _$ProfileReport._(
      {required this.userId, required this.comment, required this.timestamp})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(userId, r'ProfileReport', 'userId');
    BuiltValueNullFieldError.checkNotNull(comment, r'ProfileReport', 'comment');
    BuiltValueNullFieldError.checkNotNull(
        timestamp, r'ProfileReport', 'timestamp');
  }

  @override
  ProfileReport rebuild(void Function(ProfileReportBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProfileReportBuilder toBuilder() => new ProfileReportBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProfileReport &&
        userId == other.userId &&
        comment == other.comment &&
        timestamp == other.timestamp;
  }

  int? __hashCode;
  @override
  int get hashCode {
    if (__hashCode != null) return __hashCode!;
    var _$hash = 0;
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jc(_$hash, comment.hashCode);
    _$hash = $jc(_$hash, timestamp.hashCode);
    _$hash = $jf(_$hash);
    return __hashCode ??= _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProfileReport')
          ..add('userId', userId)
          ..add('comment', comment)
          ..add('timestamp', timestamp))
        .toString();
  }
}

class ProfileReportBuilder
    implements Builder<ProfileReport, ProfileReportBuilder> {
  _$ProfileReport? _$v;

  String? _userId;
  String? get userId => _$this._userId;
  set userId(String? userId) => _$this._userId = userId;

  String? _comment;
  String? get comment => _$this._comment;
  set comment(String? comment) => _$this._comment = comment;

  int? _timestamp;
  int? get timestamp => _$this._timestamp;
  set timestamp(int? timestamp) => _$this._timestamp = timestamp;

  ProfileReportBuilder();

  ProfileReportBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _userId = $v.userId;
      _comment = $v.comment;
      _timestamp = $v.timestamp;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProfileReport other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ProfileReport;
  }

  @override
  void update(void Function(ProfileReportBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProfileReport build() => _build();

  _$ProfileReport _build() {
    final _$result = _$v ??
        new _$ProfileReport._(
            userId: BuiltValueNullFieldError.checkNotNull(
                userId, r'ProfileReport', 'userId'),
            comment: BuiltValueNullFieldError.checkNotNull(
                comment, r'ProfileReport', 'comment'),
            timestamp: BuiltValueNullFieldError.checkNotNull(
                timestamp, r'ProfileReport', 'timestamp'));
    replace(_$result);
    return _$result;
  }
}

class _$ProfileFilter extends ProfileFilter {
  @override
  final String searchTerm;
  @override
  final EntityState stateFilter;
  @override
  final String sortField;
  @override
  final bool sortAscending;
  @override
  final String currentUserId;
  @override
  final String preferredGender;
  @override
  final int limit;
  @override
  final BuiltMap<String, dynamic> dynamicFieldsFilters;

  factory _$ProfileFilter([void Function(ProfileFilterBuilder)? updates]) =>
      (new ProfileFilterBuilder()..update(updates))._build();

  _$ProfileFilter._(
      {required this.searchTerm,
      required this.stateFilter,
      required this.sortField,
      required this.sortAscending,
      required this.currentUserId,
      required this.preferredGender,
      required this.limit,
      required this.dynamicFieldsFilters})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        searchTerm, r'ProfileFilter', 'searchTerm');
    BuiltValueNullFieldError.checkNotNull(
        stateFilter, r'ProfileFilter', 'stateFilter');
    BuiltValueNullFieldError.checkNotNull(
        sortField, r'ProfileFilter', 'sortField');
    BuiltValueNullFieldError.checkNotNull(
        sortAscending, r'ProfileFilter', 'sortAscending');
    BuiltValueNullFieldError.checkNotNull(
        currentUserId, r'ProfileFilter', 'currentUserId');
    BuiltValueNullFieldError.checkNotNull(
        preferredGender, r'ProfileFilter', 'preferredGender');
    BuiltValueNullFieldError.checkNotNull(limit, r'ProfileFilter', 'limit');
    BuiltValueNullFieldError.checkNotNull(
        dynamicFieldsFilters, r'ProfileFilter', 'dynamicFieldsFilters');
  }

  @override
  ProfileFilter rebuild(void Function(ProfileFilterBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProfileFilterBuilder toBuilder() => new ProfileFilterBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProfileFilter &&
        searchTerm == other.searchTerm &&
        stateFilter == other.stateFilter &&
        sortField == other.sortField &&
        sortAscending == other.sortAscending &&
        currentUserId == other.currentUserId &&
        preferredGender == other.preferredGender &&
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
    _$hash = $jc(_$hash, currentUserId.hashCode);
    _$hash = $jc(_$hash, preferredGender.hashCode);
    _$hash = $jc(_$hash, limit.hashCode);
    _$hash = $jc(_$hash, dynamicFieldsFilters.hashCode);
    _$hash = $jf(_$hash);
    return __hashCode ??= _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProfileFilter')
          ..add('searchTerm', searchTerm)
          ..add('stateFilter', stateFilter)
          ..add('sortField', sortField)
          ..add('sortAscending', sortAscending)
          ..add('currentUserId', currentUserId)
          ..add('preferredGender', preferredGender)
          ..add('limit', limit)
          ..add('dynamicFieldsFilters', dynamicFieldsFilters))
        .toString();
  }
}

class ProfileFilterBuilder
    implements Builder<ProfileFilter, ProfileFilterBuilder> {
  _$ProfileFilter? _$v;

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

  String? _currentUserId;
  String? get currentUserId => _$this._currentUserId;
  set currentUserId(String? currentUserId) =>
      _$this._currentUserId = currentUserId;

  String? _preferredGender;
  String? get preferredGender => _$this._preferredGender;
  set preferredGender(String? preferredGender) =>
      _$this._preferredGender = preferredGender;

  int? _limit;
  int? get limit => _$this._limit;
  set limit(int? limit) => _$this._limit = limit;

  MapBuilder<String, dynamic>? _dynamicFieldsFilters;
  MapBuilder<String, dynamic> get dynamicFieldsFilters =>
      _$this._dynamicFieldsFilters ??= new MapBuilder<String, dynamic>();
  set dynamicFieldsFilters(MapBuilder<String, dynamic>? dynamicFieldsFilters) =>
      _$this._dynamicFieldsFilters = dynamicFieldsFilters;

  ProfileFilterBuilder();

  ProfileFilterBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _searchTerm = $v.searchTerm;
      _stateFilter = $v.stateFilter;
      _sortField = $v.sortField;
      _sortAscending = $v.sortAscending;
      _currentUserId = $v.currentUserId;
      _preferredGender = $v.preferredGender;
      _limit = $v.limit;
      _dynamicFieldsFilters = $v.dynamicFieldsFilters.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProfileFilter other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ProfileFilter;
  }

  @override
  void update(void Function(ProfileFilterBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProfileFilter build() => _build();

  _$ProfileFilter _build() {
    _$ProfileFilter _$result;
    try {
      _$result = _$v ??
          new _$ProfileFilter._(
              searchTerm: BuiltValueNullFieldError.checkNotNull(
                  searchTerm, r'ProfileFilter', 'searchTerm'),
              stateFilter: BuiltValueNullFieldError.checkNotNull(
                  stateFilter, r'ProfileFilter', 'stateFilter'),
              sortField: BuiltValueNullFieldError.checkNotNull(
                  sortField, r'ProfileFilter', 'sortField'),
              sortAscending: BuiltValueNullFieldError.checkNotNull(
                  sortAscending, r'ProfileFilter', 'sortAscending'),
              currentUserId: BuiltValueNullFieldError.checkNotNull(
                  currentUserId, r'ProfileFilter', 'currentUserId'),
              preferredGender: BuiltValueNullFieldError.checkNotNull(
                  preferredGender, r'ProfileFilter', 'preferredGender'),
              limit: BuiltValueNullFieldError.checkNotNull(
                  limit, r'ProfileFilter', 'limit'),
              dynamicFieldsFilters: dynamicFieldsFilters.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'dynamicFieldsFilters';
        dynamicFieldsFilters.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'ProfileFilter', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$UserCompany extends UserCompany {
  @override
  final String companyId;
  @override
  final String companyName;

  factory _$UserCompany([void Function(UserCompanyBuilder)? updates]) =>
      (new UserCompanyBuilder()..update(updates))._build();

  _$UserCompany._({required this.companyId, required this.companyName})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        companyId, r'UserCompany', 'companyId');
    BuiltValueNullFieldError.checkNotNull(
        companyName, r'UserCompany', 'companyName');
  }

  @override
  UserCompany rebuild(void Function(UserCompanyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserCompanyBuilder toBuilder() => new UserCompanyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserCompany &&
        companyId == other.companyId &&
        companyName == other.companyName;
  }

  int? __hashCode;
  @override
  int get hashCode {
    if (__hashCode != null) return __hashCode!;
    var _$hash = 0;
    _$hash = $jc(_$hash, companyId.hashCode);
    _$hash = $jc(_$hash, companyName.hashCode);
    _$hash = $jf(_$hash);
    return __hashCode ??= _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UserCompany')
          ..add('companyId', companyId)
          ..add('companyName', companyName))
        .toString();
  }
}

class UserCompanyBuilder implements Builder<UserCompany, UserCompanyBuilder> {
  _$UserCompany? _$v;

  String? _companyId;
  String? get companyId => _$this._companyId;
  set companyId(String? companyId) => _$this._companyId = companyId;

  String? _companyName;
  String? get companyName => _$this._companyName;
  set companyName(String? companyName) => _$this._companyName = companyName;

  UserCompanyBuilder();

  UserCompanyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _companyId = $v.companyId;
      _companyName = $v.companyName;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserCompany other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$UserCompany;
  }

  @override
  void update(void Function(UserCompanyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserCompany build() => _build();

  _$UserCompany _build() {
    final _$result = _$v ??
        new _$UserCompany._(
            companyId: BuiltValueNullFieldError.checkNotNull(
                companyId, r'UserCompany', 'companyId'),
            companyName: BuiltValueNullFieldError.checkNotNull(
                companyName, r'UserCompany', 'companyName'));
    replace(_$result);
    return _$result;
  }
}

class _$ProfileListResponse extends ProfileListResponse {
  @override
  final BuiltList<ProfileEntity> data;

  factory _$ProfileListResponse(
          [void Function(ProfileListResponseBuilder)? updates]) =>
      (new ProfileListResponseBuilder()..update(updates))._build();

  _$ProfileListResponse._({required this.data}) : super._() {
    BuiltValueNullFieldError.checkNotNull(data, r'ProfileListResponse', 'data');
  }

  @override
  ProfileListResponse rebuild(
          void Function(ProfileListResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProfileListResponseBuilder toBuilder() =>
      new ProfileListResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProfileListResponse && data == other.data;
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
    return (newBuiltValueToStringHelper(r'ProfileListResponse')
          ..add('data', data))
        .toString();
  }
}

class ProfileListResponseBuilder
    implements Builder<ProfileListResponse, ProfileListResponseBuilder> {
  _$ProfileListResponse? _$v;

  ListBuilder<ProfileEntity>? _data;
  ListBuilder<ProfileEntity> get data =>
      _$this._data ??= new ListBuilder<ProfileEntity>();
  set data(ListBuilder<ProfileEntity>? data) => _$this._data = data;

  ProfileListResponseBuilder();

  ProfileListResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProfileListResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ProfileListResponse;
  }

  @override
  void update(void Function(ProfileListResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProfileListResponse build() => _build();

  _$ProfileListResponse _build() {
    _$ProfileListResponse _$result;
    try {
      _$result = _$v ?? new _$ProfileListResponse._(data: data.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'ProfileListResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$ProfilePaginationResponse extends ProfilePaginationResponse {
  @override
  final BuiltList<ProfileEntity> profiles;
  @override
  final DocumentSnapshot<Object?>? lastDocument;

  factory _$ProfilePaginationResponse(
          [void Function(ProfilePaginationResponseBuilder)? updates]) =>
      (new ProfilePaginationResponseBuilder()..update(updates))._build();

  _$ProfilePaginationResponse._({required this.profiles, this.lastDocument})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        profiles, r'ProfilePaginationResponse', 'profiles');
  }

  @override
  ProfilePaginationResponse rebuild(
          void Function(ProfilePaginationResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProfilePaginationResponseBuilder toBuilder() =>
      new ProfilePaginationResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProfilePaginationResponse &&
        profiles == other.profiles &&
        lastDocument == other.lastDocument;
  }

  int? __hashCode;
  @override
  int get hashCode {
    if (__hashCode != null) return __hashCode!;
    var _$hash = 0;
    _$hash = $jc(_$hash, profiles.hashCode);
    _$hash = $jc(_$hash, lastDocument.hashCode);
    _$hash = $jf(_$hash);
    return __hashCode ??= _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProfilePaginationResponse')
          ..add('profiles', profiles)
          ..add('lastDocument', lastDocument))
        .toString();
  }
}

class ProfilePaginationResponseBuilder
    implements
        Builder<ProfilePaginationResponse, ProfilePaginationResponseBuilder> {
  _$ProfilePaginationResponse? _$v;

  ListBuilder<ProfileEntity>? _profiles;
  ListBuilder<ProfileEntity> get profiles =>
      _$this._profiles ??= new ListBuilder<ProfileEntity>();
  set profiles(ListBuilder<ProfileEntity>? profiles) =>
      _$this._profiles = profiles;

  DocumentSnapshot<Object?>? _lastDocument;
  DocumentSnapshot<Object?>? get lastDocument => _$this._lastDocument;
  set lastDocument(DocumentSnapshot<Object?>? lastDocument) =>
      _$this._lastDocument = lastDocument;

  ProfilePaginationResponseBuilder();

  ProfilePaginationResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _profiles = $v.profiles.toBuilder();
      _lastDocument = $v.lastDocument;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProfilePaginationResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ProfilePaginationResponse;
  }

  @override
  void update(void Function(ProfilePaginationResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProfilePaginationResponse build() => _build();

  _$ProfilePaginationResponse _build() {
    _$ProfilePaginationResponse _$result;
    try {
      _$result = _$v ??
          new _$ProfilePaginationResponse._(
              profiles: profiles.build(), lastDocument: lastDocument);
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'profiles';
        profiles.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'ProfilePaginationResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$ProfileSingleResponse extends ProfileSingleResponse {
  @override
  final ProfileEntity? profile;
  @override
  final DocumentSnapshot<Object?>? lastDocument;

  factory _$ProfileSingleResponse(
          [void Function(ProfileSingleResponseBuilder)? updates]) =>
      (new ProfileSingleResponseBuilder()..update(updates))._build();

  _$ProfileSingleResponse._({this.profile, this.lastDocument}) : super._();

  @override
  ProfileSingleResponse rebuild(
          void Function(ProfileSingleResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProfileSingleResponseBuilder toBuilder() =>
      new ProfileSingleResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProfileSingleResponse &&
        profile == other.profile &&
        lastDocument == other.lastDocument;
  }

  int? __hashCode;
  @override
  int get hashCode {
    if (__hashCode != null) return __hashCode!;
    var _$hash = 0;
    _$hash = $jc(_$hash, profile.hashCode);
    _$hash = $jc(_$hash, lastDocument.hashCode);
    _$hash = $jf(_$hash);
    return __hashCode ??= _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProfileSingleResponse')
          ..add('profile', profile)
          ..add('lastDocument', lastDocument))
        .toString();
  }
}

class ProfileSingleResponseBuilder
    implements Builder<ProfileSingleResponse, ProfileSingleResponseBuilder> {
  _$ProfileSingleResponse? _$v;

  ProfileEntityBuilder? _profile;
  ProfileEntityBuilder get profile =>
      _$this._profile ??= new ProfileEntityBuilder();
  set profile(ProfileEntityBuilder? profile) => _$this._profile = profile;

  DocumentSnapshot<Object?>? _lastDocument;
  DocumentSnapshot<Object?>? get lastDocument => _$this._lastDocument;
  set lastDocument(DocumentSnapshot<Object?>? lastDocument) =>
      _$this._lastDocument = lastDocument;

  ProfileSingleResponseBuilder();

  ProfileSingleResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _profile = $v.profile?.toBuilder();
      _lastDocument = $v.lastDocument;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProfileSingleResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ProfileSingleResponse;
  }

  @override
  void update(void Function(ProfileSingleResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProfileSingleResponse build() => _build();

  _$ProfileSingleResponse _build() {
    _$ProfileSingleResponse _$result;
    try {
      _$result = _$v ??
          new _$ProfileSingleResponse._(
              profile: _profile?.build(), lastDocument: lastDocument);
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'profile';
        _profile?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'ProfileSingleResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$ProfileItemResponse extends ProfileItemResponse {
  @override
  final ProfileEntity data;

  factory _$ProfileItemResponse(
          [void Function(ProfileItemResponseBuilder)? updates]) =>
      (new ProfileItemResponseBuilder()..update(updates))._build();

  _$ProfileItemResponse._({required this.data}) : super._() {
    BuiltValueNullFieldError.checkNotNull(data, r'ProfileItemResponse', 'data');
  }

  @override
  ProfileItemResponse rebuild(
          void Function(ProfileItemResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProfileItemResponseBuilder toBuilder() =>
      new ProfileItemResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProfileItemResponse && data == other.data;
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
    return (newBuiltValueToStringHelper(r'ProfileItemResponse')
          ..add('data', data))
        .toString();
  }
}

class ProfileItemResponseBuilder
    implements Builder<ProfileItemResponse, ProfileItemResponseBuilder> {
  _$ProfileItemResponse? _$v;

  ProfileEntityBuilder? _data;
  ProfileEntityBuilder get data => _$this._data ??= new ProfileEntityBuilder();
  set data(ProfileEntityBuilder? data) => _$this._data = data;

  ProfileItemResponseBuilder();

  ProfileItemResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProfileItemResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ProfileItemResponse;
  }

  @override
  void update(void Function(ProfileItemResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProfileItemResponse build() => _build();

  _$ProfileItemResponse _build() {
    _$ProfileItemResponse _$result;
    try {
      _$result = _$v ?? new _$ProfileItemResponse._(data: data.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'ProfileItemResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$ProfileEntity extends ProfileEntity {
  @override
  final String name;
  @override
  final String email;
  @override
  final BuiltList<String> companyIds;
  @override
  final String? paymentStatus;
  @override
  final String? orgStripeAccountId;
  @override
  final BuiltMap<String, dynamic> dynamicFields;
  @override
  final BuiltMap<String, ProfileOperationEntity> likesProfileMap;
  @override
  final BuiltMap<String, ProfileReport> reportedBy;
  @override
  final BuiltMap<String, ProfileOperationEntity> likedMeProfileMap;
  @override
  final BuiltMap<String, ProfileOperationEntity> matchesProfileMap;
  @override
  final BuiltMap<String, ProfileOperationEntity> passesProfileMap;
  @override
  final bool isProfileCompleted;
  @override
  final bool isAdmin;
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

  factory _$ProfileEntity([void Function(ProfileEntityBuilder)? updates]) =>
      (new ProfileEntityBuilder()..update(updates))._build();

  _$ProfileEntity._(
      {required this.name,
      required this.email,
      required this.companyIds,
      this.paymentStatus,
      this.orgStripeAccountId,
      required this.dynamicFields,
      required this.likesProfileMap,
      required this.reportedBy,
      required this.likedMeProfileMap,
      required this.matchesProfileMap,
      required this.passesProfileMap,
      required this.isProfileCompleted,
      required this.isAdmin,
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
    BuiltValueNullFieldError.checkNotNull(name, r'ProfileEntity', 'name');
    BuiltValueNullFieldError.checkNotNull(email, r'ProfileEntity', 'email');
    BuiltValueNullFieldError.checkNotNull(
        companyIds, r'ProfileEntity', 'companyIds');
    BuiltValueNullFieldError.checkNotNull(
        dynamicFields, r'ProfileEntity', 'dynamicFields');
    BuiltValueNullFieldError.checkNotNull(
        likesProfileMap, r'ProfileEntity', 'likesProfileMap');
    BuiltValueNullFieldError.checkNotNull(
        reportedBy, r'ProfileEntity', 'reportedBy');
    BuiltValueNullFieldError.checkNotNull(
        likedMeProfileMap, r'ProfileEntity', 'likedMeProfileMap');
    BuiltValueNullFieldError.checkNotNull(
        matchesProfileMap, r'ProfileEntity', 'matchesProfileMap');
    BuiltValueNullFieldError.checkNotNull(
        passesProfileMap, r'ProfileEntity', 'passesProfileMap');
    BuiltValueNullFieldError.checkNotNull(
        isProfileCompleted, r'ProfileEntity', 'isProfileCompleted');
    BuiltValueNullFieldError.checkNotNull(isAdmin, r'ProfileEntity', 'isAdmin');
    BuiltValueNullFieldError.checkNotNull(
        createdAt, r'ProfileEntity', 'createdAt');
    BuiltValueNullFieldError.checkNotNull(
        updatedAt, r'ProfileEntity', 'updatedAt');
    BuiltValueNullFieldError.checkNotNull(
        archivedAt, r'ProfileEntity', 'archivedAt');
    BuiltValueNullFieldError.checkNotNull(id, r'ProfileEntity', 'id');
  }

  @override
  ProfileEntity rebuild(void Function(ProfileEntityBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProfileEntityBuilder toBuilder() => new ProfileEntityBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProfileEntity &&
        name == other.name &&
        email == other.email &&
        companyIds == other.companyIds &&
        paymentStatus == other.paymentStatus &&
        orgStripeAccountId == other.orgStripeAccountId &&
        dynamicFields == other.dynamicFields &&
        likesProfileMap == other.likesProfileMap &&
        reportedBy == other.reportedBy &&
        likedMeProfileMap == other.likedMeProfileMap &&
        matchesProfileMap == other.matchesProfileMap &&
        passesProfileMap == other.passesProfileMap &&
        isProfileCompleted == other.isProfileCompleted &&
        isAdmin == other.isAdmin &&
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
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, companyIds.hashCode);
    _$hash = $jc(_$hash, paymentStatus.hashCode);
    _$hash = $jc(_$hash, orgStripeAccountId.hashCode);
    _$hash = $jc(_$hash, dynamicFields.hashCode);
    _$hash = $jc(_$hash, likesProfileMap.hashCode);
    _$hash = $jc(_$hash, reportedBy.hashCode);
    _$hash = $jc(_$hash, likedMeProfileMap.hashCode);
    _$hash = $jc(_$hash, matchesProfileMap.hashCode);
    _$hash = $jc(_$hash, passesProfileMap.hashCode);
    _$hash = $jc(_$hash, isProfileCompleted.hashCode);
    _$hash = $jc(_$hash, isAdmin.hashCode);
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
    return (newBuiltValueToStringHelper(r'ProfileEntity')
          ..add('name', name)
          ..add('email', email)
          ..add('companyIds', companyIds)
          ..add('paymentStatus', paymentStatus)
          ..add('orgStripeAccountId', orgStripeAccountId)
          ..add('dynamicFields', dynamicFields)
          ..add('likesProfileMap', likesProfileMap)
          ..add('reportedBy', reportedBy)
          ..add('likedMeProfileMap', likedMeProfileMap)
          ..add('matchesProfileMap', matchesProfileMap)
          ..add('passesProfileMap', passesProfileMap)
          ..add('isProfileCompleted', isProfileCompleted)
          ..add('isAdmin', isAdmin)
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

class ProfileEntityBuilder
    implements Builder<ProfileEntity, ProfileEntityBuilder> {
  _$ProfileEntity? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  ListBuilder<String>? _companyIds;
  ListBuilder<String> get companyIds =>
      _$this._companyIds ??= new ListBuilder<String>();
  set companyIds(ListBuilder<String>? companyIds) =>
      _$this._companyIds = companyIds;

  String? _paymentStatus;
  String? get paymentStatus => _$this._paymentStatus;
  set paymentStatus(String? paymentStatus) =>
      _$this._paymentStatus = paymentStatus;

  String? _orgStripeAccountId;
  String? get orgStripeAccountId => _$this._orgStripeAccountId;
  set orgStripeAccountId(String? orgStripeAccountId) =>
      _$this._orgStripeAccountId = orgStripeAccountId;

  MapBuilder<String, dynamic>? _dynamicFields;
  MapBuilder<String, dynamic> get dynamicFields =>
      _$this._dynamicFields ??= new MapBuilder<String, dynamic>();
  set dynamicFields(MapBuilder<String, dynamic>? dynamicFields) =>
      _$this._dynamicFields = dynamicFields;

  MapBuilder<String, ProfileOperationEntity>? _likesProfileMap;
  MapBuilder<String, ProfileOperationEntity> get likesProfileMap =>
      _$this._likesProfileMap ??=
          new MapBuilder<String, ProfileOperationEntity>();
  set likesProfileMap(
          MapBuilder<String, ProfileOperationEntity>? likesProfileMap) =>
      _$this._likesProfileMap = likesProfileMap;

  MapBuilder<String, ProfileReport>? _reportedBy;
  MapBuilder<String, ProfileReport> get reportedBy =>
      _$this._reportedBy ??= new MapBuilder<String, ProfileReport>();
  set reportedBy(MapBuilder<String, ProfileReport>? reportedBy) =>
      _$this._reportedBy = reportedBy;

  MapBuilder<String, ProfileOperationEntity>? _likedMeProfileMap;
  MapBuilder<String, ProfileOperationEntity> get likedMeProfileMap =>
      _$this._likedMeProfileMap ??=
          new MapBuilder<String, ProfileOperationEntity>();
  set likedMeProfileMap(
          MapBuilder<String, ProfileOperationEntity>? likedMeProfileMap) =>
      _$this._likedMeProfileMap = likedMeProfileMap;

  MapBuilder<String, ProfileOperationEntity>? _matchesProfileMap;
  MapBuilder<String, ProfileOperationEntity> get matchesProfileMap =>
      _$this._matchesProfileMap ??=
          new MapBuilder<String, ProfileOperationEntity>();
  set matchesProfileMap(
          MapBuilder<String, ProfileOperationEntity>? matchesProfileMap) =>
      _$this._matchesProfileMap = matchesProfileMap;

  MapBuilder<String, ProfileOperationEntity>? _passesProfileMap;
  MapBuilder<String, ProfileOperationEntity> get passesProfileMap =>
      _$this._passesProfileMap ??=
          new MapBuilder<String, ProfileOperationEntity>();
  set passesProfileMap(
          MapBuilder<String, ProfileOperationEntity>? passesProfileMap) =>
      _$this._passesProfileMap = passesProfileMap;

  bool? _isProfileCompleted;
  bool? get isProfileCompleted => _$this._isProfileCompleted;
  set isProfileCompleted(bool? isProfileCompleted) =>
      _$this._isProfileCompleted = isProfileCompleted;

  bool? _isAdmin;
  bool? get isAdmin => _$this._isAdmin;
  set isAdmin(bool? isAdmin) => _$this._isAdmin = isAdmin;

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

  ProfileEntityBuilder();

  ProfileEntityBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _email = $v.email;
      _companyIds = $v.companyIds.toBuilder();
      _paymentStatus = $v.paymentStatus;
      _orgStripeAccountId = $v.orgStripeAccountId;
      _dynamicFields = $v.dynamicFields.toBuilder();
      _likesProfileMap = $v.likesProfileMap.toBuilder();
      _reportedBy = $v.reportedBy.toBuilder();
      _likedMeProfileMap = $v.likedMeProfileMap.toBuilder();
      _matchesProfileMap = $v.matchesProfileMap.toBuilder();
      _passesProfileMap = $v.passesProfileMap.toBuilder();
      _isProfileCompleted = $v.isProfileCompleted;
      _isAdmin = $v.isAdmin;
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
  void replace(ProfileEntity other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ProfileEntity;
  }

  @override
  void update(void Function(ProfileEntityBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProfileEntity build() => _build();

  _$ProfileEntity _build() {
    _$ProfileEntity _$result;
    try {
      _$result = _$v ??
          new _$ProfileEntity._(
              name: BuiltValueNullFieldError.checkNotNull(
                  name, r'ProfileEntity', 'name'),
              email: BuiltValueNullFieldError.checkNotNull(
                  email, r'ProfileEntity', 'email'),
              companyIds: companyIds.build(),
              paymentStatus: paymentStatus,
              orgStripeAccountId: orgStripeAccountId,
              dynamicFields: dynamicFields.build(),
              likesProfileMap: likesProfileMap.build(),
              reportedBy: reportedBy.build(),
              likedMeProfileMap: likedMeProfileMap.build(),
              matchesProfileMap: matchesProfileMap.build(),
              passesProfileMap: passesProfileMap.build(),
              isProfileCompleted: BuiltValueNullFieldError.checkNotNull(
                  isProfileCompleted, r'ProfileEntity', 'isProfileCompleted'),
              isAdmin: BuiltValueNullFieldError.checkNotNull(
                  isAdmin, r'ProfileEntity', 'isAdmin'),
              isChanged: isChanged,
              createdAt: BuiltValueNullFieldError.checkNotNull(
                  createdAt, r'ProfileEntity', 'createdAt'),
              updatedAt: BuiltValueNullFieldError.checkNotNull(
                  updatedAt, r'ProfileEntity', 'updatedAt'),
              archivedAt: BuiltValueNullFieldError.checkNotNull(
                  archivedAt, r'ProfileEntity', 'archivedAt'),
              isDeleted: isDeleted,
              isReported: isReported,
              createdUserId: createdUserId,
              assignedUserId: assignedUserId,
              id: BuiltValueNullFieldError.checkNotNull(
                  id, r'ProfileEntity', 'id'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'companyIds';
        companyIds.build();

        _$failedField = 'dynamicFields';
        dynamicFields.build();
        _$failedField = 'likesProfileMap';
        likesProfileMap.build();
        _$failedField = 'reportedBy';
        reportedBy.build();
        _$failedField = 'likedMeProfileMap';
        likedMeProfileMap.build();
        _$failedField = 'matchesProfileMap';
        matchesProfileMap.build();
        _$failedField = 'passesProfileMap';
        passesProfileMap.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'ProfileEntity', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
