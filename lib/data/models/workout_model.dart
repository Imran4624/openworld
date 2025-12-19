import 'package:built_value/built_value.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'package:flutter_boilerplate/utils/formatting.dart';
import 'package:flutter_boilerplate/utils/strings.dart';

part 'workout_model.g.dart';

abstract class WorkoutFilter
    implements Built<WorkoutFilter, WorkoutFilterBuilder> {
  factory WorkoutFilter() {
    return _$WorkoutFilter._(
      searchTerm: '',
      stateFilter: EntityState.active,
      sortField: WorkoutFields.type,
      sortAscending: true,
      limit: 10,
    );
  }

  WorkoutFilter._();

  @override
  @memoized
  int get hashCode;

  String get searchTerm;
  EntityState get stateFilter;
  String get sortField;
  bool get sortAscending;
  int get limit;

  Map<String, dynamic> toFirebaseQuery() {
    final Map<String, dynamic> filters = {};

    // Handle search term
    if (searchTerm.isNotEmpty) {
      filters['title'] = searchTerm.toLowerCase();
    }

    // Handle state filter
    switch (stateFilter) {
      case EntityState.active:
        filters['archived_at'] = 0;
        filters['is_deleted'] = false;
        break;
      case EntityState.archived:
        filters['archived_at_gt'] = 0;
        filters['is_deleted'] = false;
        break;
      case EntityState.deleted:
        filters['is_deleted'] = true;
        break;
    }

    return {
      'filters': filters,
      'sort_field': sortField,
      'sort_ascending': sortAscending,
      'limit': limit
    };
  }

  static Serializer<WorkoutFilter> get serializer => _$workoutFilterSerializer;
}

abstract class WorkoutListResponse
    implements Built<WorkoutListResponse, WorkoutListResponseBuilder> {
  factory WorkoutListResponse(
          [void Function(WorkoutListResponseBuilder) updates]) =
      _$WorkoutListResponse;

  WorkoutListResponse._();

  @override
  @memoized
  int get hashCode;

  BuiltList<WorkoutEntity> get data;

  static Serializer<WorkoutListResponse> get serializer =>
      _$workoutListResponseSerializer;
}

abstract class WorkoutItemResponse
    implements Built<WorkoutItemResponse, WorkoutItemResponseBuilder> {
  factory WorkoutItemResponse(
          [void Function(WorkoutItemResponseBuilder) updates]) =
      _$WorkoutItemResponse;

  WorkoutItemResponse._();

  @override
  @memoized
  int get hashCode;

  WorkoutEntity get data;

  static Serializer<WorkoutItemResponse> get serializer =>
      _$workoutItemResponseSerializer;
}

class WorkoutFields {
  // STARTER: fields - do not remove comment
  static const String type = 'type';
  static const String startTime = 'startTime';
  static const String endTime = 'endTime';
  static const String duration = 'duration';
  static const String distance = 'distance';
  static const String averagePace = 'averagePace';
  static const String caloriesBurned = 'caloriesBurned';
  static const String elevationGain = 'elevationGain';
}

abstract class WorkoutEntity extends Object
    with BaseEntity
    implements Built<WorkoutEntity, WorkoutEntityBuilder> {
  factory WorkoutEntity({String? id, AppState? state}) {
    return _$WorkoutEntity._(
      id: id ?? BaseEntity.nextId,
      isChanged: false,
      isDeleted: false,
      createdAt: 0,
      updatedAt: 0,
      createdUserId: '',
      assignedUserId: '',
      archivedAt: 0,
      type: '',
      startTime: 0,
      endTime: 0,
      duration: 0,
      distance: 0,
      averagePace: 0,
      caloriesBurned: 0,
      elevationGain: 0,
      planInfo: null,
      weather: null,
      locationPoints: BuiltMap<String, LocationPoint>(),
    );
  }

  WorkoutEntity._();

  @override
  @memoized
  int get hashCode;

  String get type;
  int get startTime;
  int get endTime;
  int get duration;
  int get distance;
  int get averagePace;
  int get caloriesBurned;
  int get elevationGain;
  PlanInfo? get planInfo;
  Weather? get weather;
  BuiltMap<String, LocationPoint> get locationPoints;

  @override
  EntityType get entityType => EntityType.workout;

  @override
  List<EntityAction?> getActions({
    UserCompanyEntity? userCompany,
    bool includeEdit = false,
    bool multiselect = false,
    bool? isGuest,
    bool? isAuthor,
  }) {
    final actions = <EntityAction?>[];

    if (!isDeleted! &&
        !multiselect &&
        includeEdit &&
        userCompany?.canEditEntity(this) == true) {
      actions.add(EntityAction.edit);
    }

    if (!multiselect && userCompany?.canEditEntity(this) == true) {
      actions.add(EntityAction.purge);
    }

    if (actions.isNotEmpty) {
      actions.add(null);
    }

    return actions
      ..addAll(super.getActions(
        userCompany: userCompany,
        isGuest: isGuest,
        isAuthor: isAuthor,
      ));
  }

  int compareTo(WorkoutEntity workout, String sortField, bool sortAscending) {
    int response = 0;
    final workoutA = sortAscending ? this : workout;
    final workoutB = sortAscending ? workout : this;

    switch (sortField) {
      // STARTER: sort switch - do not remove comment
      case WorkoutFields.type:
        response = workoutA.type.compareTo(workoutB.type);
        break;

      default:
        logError('sort by workout.$sortField is not implemented');
        break;
    }

    if (response == 0) {
      // STARTER: sort default - do not remove comment
      return workoutA.type.compareTo(workoutB.type);
    } else {
      return response;
    }
  }

  @override
  bool matchesFilter(String? filter) {
    return matchesStrings(
      haystacks: [
        // STARTER: field names - do not remove comment
        type,
      ],
      needle: filter,
    );
  }

  @override
  String? matchesFilterValue(String? filter) {
    return matchesStringsValue(
      haystacks: [
        // STARTER: field names - do not remove comment
        type,
      ],
      needle: filter,
    )!;
  }

  @override
  String get listDisplayName => '';

  @override
  double get listDisplayAmount => 0;

  @override
  FormatNumberType get listDisplayAmountType => FormatNumberType.int;

  static Serializer<WorkoutEntity> get serializer => _$workoutEntitySerializer;
}

//#region Related classes

abstract class PlanInfo implements Built<PlanInfo, PlanInfoBuilder> {
  factory PlanInfo([void Function(PlanInfoBuilder)? updates]) = _$PlanInfo;

  PlanInfo._();

  int get planId;
  int get weekNumber;
  int get runNumber;
  bool get isCompleted;

  static Serializer<PlanInfo> get serializer => _$planInfoSerializer;
}

abstract class PlanInfoBuilder implements Builder<PlanInfo, PlanInfoBuilder> {
  factory PlanInfoBuilder() = _$PlanInfoBuilder;

  PlanInfoBuilder._();

  int planId = 0;
  int weekNumber = 0;
  int runNumber = 0;
  bool isCompleted = false;
}

abstract class Weather implements Built<Weather, WeatherBuilder> {
  factory Weather([void Function(WeatherBuilder)? updates]) = _$Weather;

  Weather._();

  double get temperature;
  String get conditions;
  double get humidity;

  static Serializer<Weather> get serializer => _$weatherSerializer;
}

abstract class WeatherBuilder implements Builder<Weather, WeatherBuilder> {
  factory WeatherBuilder() = _$WeatherBuilder;

  WeatherBuilder._();

  double temperature = 0;
  String conditions = '';
  double humidity = 0;
}

abstract class LocationPoint
    implements Built<LocationPoint, LocationPointBuilder> {
  factory LocationPoint([void Function(LocationPointBuilder)? updates]) =
      _$LocationPoint;

  LocationPoint._();

  int get timestamp;
  double get latitude;
  double get longitude;
  double get altitude;
  double get accuracy;
  double get speed;

  static Serializer<LocationPoint> get serializer => _$locationPointSerializer;
}

abstract class LocationPointBuilder
    implements Builder<LocationPoint, LocationPointBuilder> {
  factory LocationPointBuilder() = _$LocationPointBuilder;

  LocationPointBuilder._();

  int timestamp = 0;
  double latitude = 0;
  double longitude = 0;
  double altitude = 0;
  double accuracy = 0;
  double speed = 0;
}

//#endregion
