// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<WorkoutFilter> _$workoutFilterSerializer =
    new _$WorkoutFilterSerializer();
Serializer<WorkoutListResponse> _$workoutListResponseSerializer =
    new _$WorkoutListResponseSerializer();
Serializer<WorkoutItemResponse> _$workoutItemResponseSerializer =
    new _$WorkoutItemResponseSerializer();
Serializer<WorkoutEntity> _$workoutEntitySerializer =
    new _$WorkoutEntitySerializer();
Serializer<PlanInfo> _$planInfoSerializer = new _$PlanInfoSerializer();
Serializer<Weather> _$weatherSerializer = new _$WeatherSerializer();
Serializer<LocationPoint> _$locationPointSerializer =
    new _$LocationPointSerializer();

class _$WorkoutFilterSerializer implements StructuredSerializer<WorkoutFilter> {
  @override
  final Iterable<Type> types = const [WorkoutFilter, _$WorkoutFilter];
  @override
  final String wireName = 'WorkoutFilter';

  @override
  Iterable<Object?> serialize(Serializers serializers, WorkoutFilter object,
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
  WorkoutFilter deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new WorkoutFilterBuilder();

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

class _$WorkoutListResponseSerializer
    implements StructuredSerializer<WorkoutListResponse> {
  @override
  final Iterable<Type> types = const [
    WorkoutListResponse,
    _$WorkoutListResponse
  ];
  @override
  final String wireName = 'WorkoutListResponse';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, WorkoutListResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'data',
      serializers.serialize(object.data,
          specifiedType:
              const FullType(BuiltList, const [const FullType(WorkoutEntity)])),
    ];

    return result;
  }

  @override
  WorkoutListResponse deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new WorkoutListResponseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'data':
          result.data.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(WorkoutEntity)]))!
              as BuiltList<Object?>);
          break;
      }
    }

    return result.build();
  }
}

class _$WorkoutItemResponseSerializer
    implements StructuredSerializer<WorkoutItemResponse> {
  @override
  final Iterable<Type> types = const [
    WorkoutItemResponse,
    _$WorkoutItemResponse
  ];
  @override
  final String wireName = 'WorkoutItemResponse';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, WorkoutItemResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'data',
      serializers.serialize(object.data,
          specifiedType: const FullType(WorkoutEntity)),
    ];

    return result;
  }

  @override
  WorkoutItemResponse deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new WorkoutItemResponseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'data':
          result.data.replace(serializers.deserialize(value,
              specifiedType: const FullType(WorkoutEntity))! as WorkoutEntity);
          break;
      }
    }

    return result.build();
  }
}

class _$WorkoutEntitySerializer implements StructuredSerializer<WorkoutEntity> {
  @override
  final Iterable<Type> types = const [WorkoutEntity, _$WorkoutEntity];
  @override
  final String wireName = 'WorkoutEntity';

  @override
  Iterable<Object?> serialize(Serializers serializers, WorkoutEntity object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'type',
      serializers.serialize(object.type, specifiedType: const FullType(String)),
      'startTime',
      serializers.serialize(object.startTime,
          specifiedType: const FullType(int)),
      'endTime',
      serializers.serialize(object.endTime, specifiedType: const FullType(int)),
      'duration',
      serializers.serialize(object.duration,
          specifiedType: const FullType(int)),
      'distance',
      serializers.serialize(object.distance,
          specifiedType: const FullType(int)),
      'averagePace',
      serializers.serialize(object.averagePace,
          specifiedType: const FullType(int)),
      'caloriesBurned',
      serializers.serialize(object.caloriesBurned,
          specifiedType: const FullType(int)),
      'elevationGain',
      serializers.serialize(object.elevationGain,
          specifiedType: const FullType(int)),
      'locationPoints',
      serializers.serialize(object.locationPoints,
          specifiedType: const FullType(BuiltMap,
              const [const FullType(String), const FullType(LocationPoint)])),
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
    value = object.planInfo;
    if (value != null) {
      result
        ..add('planInfo')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(PlanInfo)));
    }
    value = object.weather;
    if (value != null) {
      result
        ..add('weather')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(Weather)));
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
  WorkoutEntity deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new WorkoutEntityBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'type':
          result.type = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'startTime':
          result.startTime = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'endTime':
          result.endTime = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'duration':
          result.duration = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'distance':
          result.distance = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'averagePace':
          result.averagePace = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'caloriesBurned':
          result.caloriesBurned = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'elevationGain':
          result.elevationGain = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'planInfo':
          result.planInfo.replace(serializers.deserialize(value,
              specifiedType: const FullType(PlanInfo))! as PlanInfo);
          break;
        case 'weather':
          result.weather.replace(serializers.deserialize(value,
              specifiedType: const FullType(Weather))! as Weather);
          break;
        case 'locationPoints':
          result.locationPoints.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltMap, const [
                const FullType(String),
                const FullType(LocationPoint)
              ]))!);
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

class _$PlanInfoSerializer implements StructuredSerializer<PlanInfo> {
  @override
  final Iterable<Type> types = const [PlanInfo, _$PlanInfo];
  @override
  final String wireName = 'PlanInfo';

  @override
  Iterable<Object?> serialize(Serializers serializers, PlanInfo object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'planId',
      serializers.serialize(object.planId, specifiedType: const FullType(int)),
      'weekNumber',
      serializers.serialize(object.weekNumber,
          specifiedType: const FullType(int)),
      'runNumber',
      serializers.serialize(object.runNumber,
          specifiedType: const FullType(int)),
      'isCompleted',
      serializers.serialize(object.isCompleted,
          specifiedType: const FullType(bool)),
    ];

    return result;
  }

  @override
  PlanInfo deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new PlanInfoBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'planId':
          result.planId = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'weekNumber':
          result.weekNumber = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'runNumber':
          result.runNumber = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'isCompleted':
          result.isCompleted = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
      }
    }

    return result.build();
  }
}

class _$WeatherSerializer implements StructuredSerializer<Weather> {
  @override
  final Iterable<Type> types = const [Weather, _$Weather];
  @override
  final String wireName = 'Weather';

  @override
  Iterable<Object?> serialize(Serializers serializers, Weather object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'temperature',
      serializers.serialize(object.temperature,
          specifiedType: const FullType(double)),
      'conditions',
      serializers.serialize(object.conditions,
          specifiedType: const FullType(String)),
      'humidity',
      serializers.serialize(object.humidity,
          specifiedType: const FullType(double)),
    ];

    return result;
  }

  @override
  Weather deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new WeatherBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'temperature':
          result.temperature = serializers.deserialize(value,
              specifiedType: const FullType(double))! as double;
          break;
        case 'conditions':
          result.conditions = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'humidity':
          result.humidity = serializers.deserialize(value,
              specifiedType: const FullType(double))! as double;
          break;
      }
    }

    return result.build();
  }
}

class _$LocationPointSerializer implements StructuredSerializer<LocationPoint> {
  @override
  final Iterable<Type> types = const [LocationPoint, _$LocationPoint];
  @override
  final String wireName = 'LocationPoint';

  @override
  Iterable<Object?> serialize(Serializers serializers, LocationPoint object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'timestamp',
      serializers.serialize(object.timestamp,
          specifiedType: const FullType(int)),
      'latitude',
      serializers.serialize(object.latitude,
          specifiedType: const FullType(double)),
      'longitude',
      serializers.serialize(object.longitude,
          specifiedType: const FullType(double)),
      'altitude',
      serializers.serialize(object.altitude,
          specifiedType: const FullType(double)),
      'accuracy',
      serializers.serialize(object.accuracy,
          specifiedType: const FullType(double)),
      'speed',
      serializers.serialize(object.speed,
          specifiedType: const FullType(double)),
    ];

    return result;
  }

  @override
  LocationPoint deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new LocationPointBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'timestamp':
          result.timestamp = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'latitude':
          result.latitude = serializers.deserialize(value,
              specifiedType: const FullType(double))! as double;
          break;
        case 'longitude':
          result.longitude = serializers.deserialize(value,
              specifiedType: const FullType(double))! as double;
          break;
        case 'altitude':
          result.altitude = serializers.deserialize(value,
              specifiedType: const FullType(double))! as double;
          break;
        case 'accuracy':
          result.accuracy = serializers.deserialize(value,
              specifiedType: const FullType(double))! as double;
          break;
        case 'speed':
          result.speed = serializers.deserialize(value,
              specifiedType: const FullType(double))! as double;
          break;
      }
    }

    return result.build();
  }
}

class _$WorkoutFilter extends WorkoutFilter {
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

  factory _$WorkoutFilter([void Function(WorkoutFilterBuilder)? updates]) =>
      (new WorkoutFilterBuilder()..update(updates))._build();

  _$WorkoutFilter._(
      {required this.searchTerm,
      required this.stateFilter,
      required this.sortField,
      required this.sortAscending,
      required this.limit})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        searchTerm, r'WorkoutFilter', 'searchTerm');
    BuiltValueNullFieldError.checkNotNull(
        stateFilter, r'WorkoutFilter', 'stateFilter');
    BuiltValueNullFieldError.checkNotNull(
        sortField, r'WorkoutFilter', 'sortField');
    BuiltValueNullFieldError.checkNotNull(
        sortAscending, r'WorkoutFilter', 'sortAscending');
    BuiltValueNullFieldError.checkNotNull(limit, r'WorkoutFilter', 'limit');
  }

  @override
  WorkoutFilter rebuild(void Function(WorkoutFilterBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WorkoutFilterBuilder toBuilder() => new WorkoutFilterBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WorkoutFilter &&
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
    return (newBuiltValueToStringHelper(r'WorkoutFilter')
          ..add('searchTerm', searchTerm)
          ..add('stateFilter', stateFilter)
          ..add('sortField', sortField)
          ..add('sortAscending', sortAscending)
          ..add('limit', limit))
        .toString();
  }
}

class WorkoutFilterBuilder
    implements Builder<WorkoutFilter, WorkoutFilterBuilder> {
  _$WorkoutFilter? _$v;

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

  WorkoutFilterBuilder();

  WorkoutFilterBuilder get _$this {
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
  void replace(WorkoutFilter other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$WorkoutFilter;
  }

  @override
  void update(void Function(WorkoutFilterBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WorkoutFilter build() => _build();

  _$WorkoutFilter _build() {
    final _$result = _$v ??
        new _$WorkoutFilter._(
            searchTerm: BuiltValueNullFieldError.checkNotNull(
                searchTerm, r'WorkoutFilter', 'searchTerm'),
            stateFilter: BuiltValueNullFieldError.checkNotNull(
                stateFilter, r'WorkoutFilter', 'stateFilter'),
            sortField: BuiltValueNullFieldError.checkNotNull(
                sortField, r'WorkoutFilter', 'sortField'),
            sortAscending: BuiltValueNullFieldError.checkNotNull(
                sortAscending, r'WorkoutFilter', 'sortAscending'),
            limit: BuiltValueNullFieldError.checkNotNull(
                limit, r'WorkoutFilter', 'limit'));
    replace(_$result);
    return _$result;
  }
}

class _$WorkoutListResponse extends WorkoutListResponse {
  @override
  final BuiltList<WorkoutEntity> data;

  factory _$WorkoutListResponse(
          [void Function(WorkoutListResponseBuilder)? updates]) =>
      (new WorkoutListResponseBuilder()..update(updates))._build();

  _$WorkoutListResponse._({required this.data}) : super._() {
    BuiltValueNullFieldError.checkNotNull(data, r'WorkoutListResponse', 'data');
  }

  @override
  WorkoutListResponse rebuild(
          void Function(WorkoutListResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WorkoutListResponseBuilder toBuilder() =>
      new WorkoutListResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WorkoutListResponse && data == other.data;
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
    return (newBuiltValueToStringHelper(r'WorkoutListResponse')
          ..add('data', data))
        .toString();
  }
}

class WorkoutListResponseBuilder
    implements Builder<WorkoutListResponse, WorkoutListResponseBuilder> {
  _$WorkoutListResponse? _$v;

  ListBuilder<WorkoutEntity>? _data;
  ListBuilder<WorkoutEntity> get data =>
      _$this._data ??= new ListBuilder<WorkoutEntity>();
  set data(ListBuilder<WorkoutEntity>? data) => _$this._data = data;

  WorkoutListResponseBuilder();

  WorkoutListResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(WorkoutListResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$WorkoutListResponse;
  }

  @override
  void update(void Function(WorkoutListResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WorkoutListResponse build() => _build();

  _$WorkoutListResponse _build() {
    _$WorkoutListResponse _$result;
    try {
      _$result = _$v ?? new _$WorkoutListResponse._(data: data.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'WorkoutListResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$WorkoutItemResponse extends WorkoutItemResponse {
  @override
  final WorkoutEntity data;

  factory _$WorkoutItemResponse(
          [void Function(WorkoutItemResponseBuilder)? updates]) =>
      (new WorkoutItemResponseBuilder()..update(updates))._build();

  _$WorkoutItemResponse._({required this.data}) : super._() {
    BuiltValueNullFieldError.checkNotNull(data, r'WorkoutItemResponse', 'data');
  }

  @override
  WorkoutItemResponse rebuild(
          void Function(WorkoutItemResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WorkoutItemResponseBuilder toBuilder() =>
      new WorkoutItemResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WorkoutItemResponse && data == other.data;
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
    return (newBuiltValueToStringHelper(r'WorkoutItemResponse')
          ..add('data', data))
        .toString();
  }
}

class WorkoutItemResponseBuilder
    implements Builder<WorkoutItemResponse, WorkoutItemResponseBuilder> {
  _$WorkoutItemResponse? _$v;

  WorkoutEntityBuilder? _data;
  WorkoutEntityBuilder get data => _$this._data ??= new WorkoutEntityBuilder();
  set data(WorkoutEntityBuilder? data) => _$this._data = data;

  WorkoutItemResponseBuilder();

  WorkoutItemResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(WorkoutItemResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$WorkoutItemResponse;
  }

  @override
  void update(void Function(WorkoutItemResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WorkoutItemResponse build() => _build();

  _$WorkoutItemResponse _build() {
    _$WorkoutItemResponse _$result;
    try {
      _$result = _$v ?? new _$WorkoutItemResponse._(data: data.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'WorkoutItemResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$WorkoutEntity extends WorkoutEntity {
  @override
  final String type;
  @override
  final int startTime;
  @override
  final int endTime;
  @override
  final int duration;
  @override
  final int distance;
  @override
  final int averagePace;
  @override
  final int caloriesBurned;
  @override
  final int elevationGain;
  @override
  final PlanInfo? planInfo;
  @override
  final Weather? weather;
  @override
  final BuiltMap<String, LocationPoint> locationPoints;
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

  factory _$WorkoutEntity([void Function(WorkoutEntityBuilder)? updates]) =>
      (new WorkoutEntityBuilder()..update(updates))._build();

  _$WorkoutEntity._(
      {required this.type,
      required this.startTime,
      required this.endTime,
      required this.duration,
      required this.distance,
      required this.averagePace,
      required this.caloriesBurned,
      required this.elevationGain,
      this.planInfo,
      this.weather,
      required this.locationPoints,
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
    BuiltValueNullFieldError.checkNotNull(type, r'WorkoutEntity', 'type');
    BuiltValueNullFieldError.checkNotNull(
        startTime, r'WorkoutEntity', 'startTime');
    BuiltValueNullFieldError.checkNotNull(endTime, r'WorkoutEntity', 'endTime');
    BuiltValueNullFieldError.checkNotNull(
        duration, r'WorkoutEntity', 'duration');
    BuiltValueNullFieldError.checkNotNull(
        distance, r'WorkoutEntity', 'distance');
    BuiltValueNullFieldError.checkNotNull(
        averagePace, r'WorkoutEntity', 'averagePace');
    BuiltValueNullFieldError.checkNotNull(
        caloriesBurned, r'WorkoutEntity', 'caloriesBurned');
    BuiltValueNullFieldError.checkNotNull(
        elevationGain, r'WorkoutEntity', 'elevationGain');
    BuiltValueNullFieldError.checkNotNull(
        locationPoints, r'WorkoutEntity', 'locationPoints');
    BuiltValueNullFieldError.checkNotNull(
        createdAt, r'WorkoutEntity', 'createdAt');
    BuiltValueNullFieldError.checkNotNull(
        updatedAt, r'WorkoutEntity', 'updatedAt');
    BuiltValueNullFieldError.checkNotNull(
        archivedAt, r'WorkoutEntity', 'archivedAt');
    BuiltValueNullFieldError.checkNotNull(id, r'WorkoutEntity', 'id');
  }

  @override
  WorkoutEntity rebuild(void Function(WorkoutEntityBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WorkoutEntityBuilder toBuilder() => new WorkoutEntityBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WorkoutEntity &&
        type == other.type &&
        startTime == other.startTime &&
        endTime == other.endTime &&
        duration == other.duration &&
        distance == other.distance &&
        averagePace == other.averagePace &&
        caloriesBurned == other.caloriesBurned &&
        elevationGain == other.elevationGain &&
        planInfo == other.planInfo &&
        weather == other.weather &&
        locationPoints == other.locationPoints &&
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
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, startTime.hashCode);
    _$hash = $jc(_$hash, endTime.hashCode);
    _$hash = $jc(_$hash, duration.hashCode);
    _$hash = $jc(_$hash, distance.hashCode);
    _$hash = $jc(_$hash, averagePace.hashCode);
    _$hash = $jc(_$hash, caloriesBurned.hashCode);
    _$hash = $jc(_$hash, elevationGain.hashCode);
    _$hash = $jc(_$hash, planInfo.hashCode);
    _$hash = $jc(_$hash, weather.hashCode);
    _$hash = $jc(_$hash, locationPoints.hashCode);
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
    return (newBuiltValueToStringHelper(r'WorkoutEntity')
          ..add('type', type)
          ..add('startTime', startTime)
          ..add('endTime', endTime)
          ..add('duration', duration)
          ..add('distance', distance)
          ..add('averagePace', averagePace)
          ..add('caloriesBurned', caloriesBurned)
          ..add('elevationGain', elevationGain)
          ..add('planInfo', planInfo)
          ..add('weather', weather)
          ..add('locationPoints', locationPoints)
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

class WorkoutEntityBuilder
    implements Builder<WorkoutEntity, WorkoutEntityBuilder> {
  _$WorkoutEntity? _$v;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  int? _startTime;
  int? get startTime => _$this._startTime;
  set startTime(int? startTime) => _$this._startTime = startTime;

  int? _endTime;
  int? get endTime => _$this._endTime;
  set endTime(int? endTime) => _$this._endTime = endTime;

  int? _duration;
  int? get duration => _$this._duration;
  set duration(int? duration) => _$this._duration = duration;

  int? _distance;
  int? get distance => _$this._distance;
  set distance(int? distance) => _$this._distance = distance;

  int? _averagePace;
  int? get averagePace => _$this._averagePace;
  set averagePace(int? averagePace) => _$this._averagePace = averagePace;

  int? _caloriesBurned;
  int? get caloriesBurned => _$this._caloriesBurned;
  set caloriesBurned(int? caloriesBurned) =>
      _$this._caloriesBurned = caloriesBurned;

  int? _elevationGain;
  int? get elevationGain => _$this._elevationGain;
  set elevationGain(int? elevationGain) =>
      _$this._elevationGain = elevationGain;

  PlanInfoBuilder? _planInfo;
  PlanInfoBuilder get planInfo => _$this._planInfo ??= new PlanInfoBuilder();
  set planInfo(PlanInfoBuilder? planInfo) => _$this._planInfo = planInfo;

  WeatherBuilder? _weather;
  WeatherBuilder get weather => _$this._weather ??= new WeatherBuilder();
  set weather(WeatherBuilder? weather) => _$this._weather = weather;

  MapBuilder<String, LocationPoint>? _locationPoints;
  MapBuilder<String, LocationPoint> get locationPoints =>
      _$this._locationPoints ??= new MapBuilder<String, LocationPoint>();
  set locationPoints(MapBuilder<String, LocationPoint>? locationPoints) =>
      _$this._locationPoints = locationPoints;

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

  WorkoutEntityBuilder();

  WorkoutEntityBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _type = $v.type;
      _startTime = $v.startTime;
      _endTime = $v.endTime;
      _duration = $v.duration;
      _distance = $v.distance;
      _averagePace = $v.averagePace;
      _caloriesBurned = $v.caloriesBurned;
      _elevationGain = $v.elevationGain;
      _planInfo = $v.planInfo?.toBuilder();
      _weather = $v.weather?.toBuilder();
      _locationPoints = $v.locationPoints.toBuilder();
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
  void replace(WorkoutEntity other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$WorkoutEntity;
  }

  @override
  void update(void Function(WorkoutEntityBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WorkoutEntity build() => _build();

  _$WorkoutEntity _build() {
    _$WorkoutEntity _$result;
    try {
      _$result = _$v ??
          new _$WorkoutEntity._(
              type: BuiltValueNullFieldError.checkNotNull(
                  type, r'WorkoutEntity', 'type'),
              startTime: BuiltValueNullFieldError.checkNotNull(
                  startTime, r'WorkoutEntity', 'startTime'),
              endTime: BuiltValueNullFieldError.checkNotNull(
                  endTime, r'WorkoutEntity', 'endTime'),
              duration: BuiltValueNullFieldError.checkNotNull(
                  duration, r'WorkoutEntity', 'duration'),
              distance: BuiltValueNullFieldError.checkNotNull(
                  distance, r'WorkoutEntity', 'distance'),
              averagePace: BuiltValueNullFieldError.checkNotNull(
                  averagePace, r'WorkoutEntity', 'averagePace'),
              caloriesBurned: BuiltValueNullFieldError.checkNotNull(
                  caloriesBurned, r'WorkoutEntity', 'caloriesBurned'),
              elevationGain: BuiltValueNullFieldError.checkNotNull(
                  elevationGain, r'WorkoutEntity', 'elevationGain'),
              planInfo: _planInfo?.build(),
              weather: _weather?.build(),
              locationPoints: locationPoints.build(),
              isChanged: isChanged,
              createdAt:
                  BuiltValueNullFieldError.checkNotNull(createdAt, r'WorkoutEntity', 'createdAt'),
              updatedAt: BuiltValueNullFieldError.checkNotNull(updatedAt, r'WorkoutEntity', 'updatedAt'),
              archivedAt: BuiltValueNullFieldError.checkNotNull(archivedAt, r'WorkoutEntity', 'archivedAt'),
              isDeleted: isDeleted,
              isReported: isReported,
              createdUserId: createdUserId,
              assignedUserId: assignedUserId,
              id: BuiltValueNullFieldError.checkNotNull(id, r'WorkoutEntity', 'id'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'planInfo';
        _planInfo?.build();
        _$failedField = 'weather';
        _weather?.build();
        _$failedField = 'locationPoints';
        locationPoints.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'WorkoutEntity', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$PlanInfo extends PlanInfo {
  @override
  final int planId;
  @override
  final int weekNumber;
  @override
  final int runNumber;
  @override
  final bool isCompleted;

  factory _$PlanInfo([void Function(PlanInfoBuilder)? updates]) =>
      (new PlanInfoBuilder()..update(updates)).build() as _$PlanInfo;

  _$PlanInfo._(
      {required this.planId,
      required this.weekNumber,
      required this.runNumber,
      required this.isCompleted})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(planId, r'PlanInfo', 'planId');
    BuiltValueNullFieldError.checkNotNull(
        weekNumber, r'PlanInfo', 'weekNumber');
    BuiltValueNullFieldError.checkNotNull(runNumber, r'PlanInfo', 'runNumber');
    BuiltValueNullFieldError.checkNotNull(
        isCompleted, r'PlanInfo', 'isCompleted');
  }

  @override
  PlanInfo rebuild(void Function(PlanInfoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  _$PlanInfoBuilder toBuilder() => new _$PlanInfoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PlanInfo &&
        planId == other.planId &&
        weekNumber == other.weekNumber &&
        runNumber == other.runNumber &&
        isCompleted == other.isCompleted;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, planId.hashCode);
    _$hash = $jc(_$hash, weekNumber.hashCode);
    _$hash = $jc(_$hash, runNumber.hashCode);
    _$hash = $jc(_$hash, isCompleted.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PlanInfo')
          ..add('planId', planId)
          ..add('weekNumber', weekNumber)
          ..add('runNumber', runNumber)
          ..add('isCompleted', isCompleted))
        .toString();
  }
}

class _$PlanInfoBuilder extends PlanInfoBuilder {
  _$PlanInfo? _$v;

  @override
  int get planId {
    _$this;
    return super.planId;
  }

  @override
  set planId(int planId) {
    _$this;
    super.planId = planId;
  }

  @override
  int get weekNumber {
    _$this;
    return super.weekNumber;
  }

  @override
  set weekNumber(int weekNumber) {
    _$this;
    super.weekNumber = weekNumber;
  }

  @override
  int get runNumber {
    _$this;
    return super.runNumber;
  }

  @override
  set runNumber(int runNumber) {
    _$this;
    super.runNumber = runNumber;
  }

  @override
  bool get isCompleted {
    _$this;
    return super.isCompleted;
  }

  @override
  set isCompleted(bool isCompleted) {
    _$this;
    super.isCompleted = isCompleted;
  }

  _$PlanInfoBuilder() : super._();

  PlanInfoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      super.planId = $v.planId;
      super.weekNumber = $v.weekNumber;
      super.runNumber = $v.runNumber;
      super.isCompleted = $v.isCompleted;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PlanInfo other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$PlanInfo;
  }

  @override
  void update(void Function(PlanInfoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PlanInfo build() => _build();

  _$PlanInfo _build() {
    final _$result = _$v ??
        new _$PlanInfo._(
            planId: BuiltValueNullFieldError.checkNotNull(
                planId, r'PlanInfo', 'planId'),
            weekNumber: BuiltValueNullFieldError.checkNotNull(
                weekNumber, r'PlanInfo', 'weekNumber'),
            runNumber: BuiltValueNullFieldError.checkNotNull(
                runNumber, r'PlanInfo', 'runNumber'),
            isCompleted: BuiltValueNullFieldError.checkNotNull(
                isCompleted, r'PlanInfo', 'isCompleted'));
    replace(_$result);
    return _$result;
  }
}

class _$Weather extends Weather {
  @override
  final double temperature;
  @override
  final String conditions;
  @override
  final double humidity;

  factory _$Weather([void Function(WeatherBuilder)? updates]) =>
      (new WeatherBuilder()..update(updates)).build() as _$Weather;

  _$Weather._(
      {required this.temperature,
      required this.conditions,
      required this.humidity})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        temperature, r'Weather', 'temperature');
    BuiltValueNullFieldError.checkNotNull(conditions, r'Weather', 'conditions');
    BuiltValueNullFieldError.checkNotNull(humidity, r'Weather', 'humidity');
  }

  @override
  Weather rebuild(void Function(WeatherBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  _$WeatherBuilder toBuilder() => new _$WeatherBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Weather &&
        temperature == other.temperature &&
        conditions == other.conditions &&
        humidity == other.humidity;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, temperature.hashCode);
    _$hash = $jc(_$hash, conditions.hashCode);
    _$hash = $jc(_$hash, humidity.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Weather')
          ..add('temperature', temperature)
          ..add('conditions', conditions)
          ..add('humidity', humidity))
        .toString();
  }
}

class _$WeatherBuilder extends WeatherBuilder {
  _$Weather? _$v;

  @override
  double get temperature {
    _$this;
    return super.temperature;
  }

  @override
  set temperature(double temperature) {
    _$this;
    super.temperature = temperature;
  }

  @override
  String get conditions {
    _$this;
    return super.conditions;
  }

  @override
  set conditions(String conditions) {
    _$this;
    super.conditions = conditions;
  }

  @override
  double get humidity {
    _$this;
    return super.humidity;
  }

  @override
  set humidity(double humidity) {
    _$this;
    super.humidity = humidity;
  }

  _$WeatherBuilder() : super._();

  WeatherBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      super.temperature = $v.temperature;
      super.conditions = $v.conditions;
      super.humidity = $v.humidity;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Weather other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Weather;
  }

  @override
  void update(void Function(WeatherBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Weather build() => _build();

  _$Weather _build() {
    final _$result = _$v ??
        new _$Weather._(
            temperature: BuiltValueNullFieldError.checkNotNull(
                temperature, r'Weather', 'temperature'),
            conditions: BuiltValueNullFieldError.checkNotNull(
                conditions, r'Weather', 'conditions'),
            humidity: BuiltValueNullFieldError.checkNotNull(
                humidity, r'Weather', 'humidity'));
    replace(_$result);
    return _$result;
  }
}

class _$LocationPoint extends LocationPoint {
  @override
  final int timestamp;
  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final double altitude;
  @override
  final double accuracy;
  @override
  final double speed;

  factory _$LocationPoint([void Function(LocationPointBuilder)? updates]) =>
      (new LocationPointBuilder()..update(updates)).build() as _$LocationPoint;

  _$LocationPoint._(
      {required this.timestamp,
      required this.latitude,
      required this.longitude,
      required this.altitude,
      required this.accuracy,
      required this.speed})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        timestamp, r'LocationPoint', 'timestamp');
    BuiltValueNullFieldError.checkNotNull(
        latitude, r'LocationPoint', 'latitude');
    BuiltValueNullFieldError.checkNotNull(
        longitude, r'LocationPoint', 'longitude');
    BuiltValueNullFieldError.checkNotNull(
        altitude, r'LocationPoint', 'altitude');
    BuiltValueNullFieldError.checkNotNull(
        accuracy, r'LocationPoint', 'accuracy');
    BuiltValueNullFieldError.checkNotNull(speed, r'LocationPoint', 'speed');
  }

  @override
  LocationPoint rebuild(void Function(LocationPointBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  _$LocationPointBuilder toBuilder() =>
      new _$LocationPointBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LocationPoint &&
        timestamp == other.timestamp &&
        latitude == other.latitude &&
        longitude == other.longitude &&
        altitude == other.altitude &&
        accuracy == other.accuracy &&
        speed == other.speed;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, timestamp.hashCode);
    _$hash = $jc(_$hash, latitude.hashCode);
    _$hash = $jc(_$hash, longitude.hashCode);
    _$hash = $jc(_$hash, altitude.hashCode);
    _$hash = $jc(_$hash, accuracy.hashCode);
    _$hash = $jc(_$hash, speed.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LocationPoint')
          ..add('timestamp', timestamp)
          ..add('latitude', latitude)
          ..add('longitude', longitude)
          ..add('altitude', altitude)
          ..add('accuracy', accuracy)
          ..add('speed', speed))
        .toString();
  }
}

class _$LocationPointBuilder extends LocationPointBuilder {
  _$LocationPoint? _$v;

  @override
  int get timestamp {
    _$this;
    return super.timestamp;
  }

  @override
  set timestamp(int timestamp) {
    _$this;
    super.timestamp = timestamp;
  }

  @override
  double get latitude {
    _$this;
    return super.latitude;
  }

  @override
  set latitude(double latitude) {
    _$this;
    super.latitude = latitude;
  }

  @override
  double get longitude {
    _$this;
    return super.longitude;
  }

  @override
  set longitude(double longitude) {
    _$this;
    super.longitude = longitude;
  }

  @override
  double get altitude {
    _$this;
    return super.altitude;
  }

  @override
  set altitude(double altitude) {
    _$this;
    super.altitude = altitude;
  }

  @override
  double get accuracy {
    _$this;
    return super.accuracy;
  }

  @override
  set accuracy(double accuracy) {
    _$this;
    super.accuracy = accuracy;
  }

  @override
  double get speed {
    _$this;
    return super.speed;
  }

  @override
  set speed(double speed) {
    _$this;
    super.speed = speed;
  }

  _$LocationPointBuilder() : super._();

  LocationPointBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      super.timestamp = $v.timestamp;
      super.latitude = $v.latitude;
      super.longitude = $v.longitude;
      super.altitude = $v.altitude;
      super.accuracy = $v.accuracy;
      super.speed = $v.speed;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LocationPoint other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$LocationPoint;
  }

  @override
  void update(void Function(LocationPointBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LocationPoint build() => _build();

  _$LocationPoint _build() {
    final _$result = _$v ??
        new _$LocationPoint._(
            timestamp: BuiltValueNullFieldError.checkNotNull(
                timestamp, r'LocationPoint', 'timestamp'),
            latitude: BuiltValueNullFieldError.checkNotNull(
                latitude, r'LocationPoint', 'latitude'),
            longitude: BuiltValueNullFieldError.checkNotNull(
                longitude, r'LocationPoint', 'longitude'),
            altitude: BuiltValueNullFieldError.checkNotNull(
                altitude, r'LocationPoint', 'altitude'),
            accuracy: BuiltValueNullFieldError.checkNotNull(
                accuracy, r'LocationPoint', 'accuracy'),
            speed: BuiltValueNullFieldError.checkNotNull(
                speed, r'LocationPoint', 'speed'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
