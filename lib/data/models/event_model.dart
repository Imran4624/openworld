import 'package:built_value/built_value.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/data/models/event_model_helper.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'package:flutter_boilerplate/utils/formatting.dart';
import 'package:flutter_boilerplate/utils/strings.dart';

part 'event_model.g.dart';

abstract class EventFilter implements Built<EventFilter, EventFilterBuilder> {
  factory EventFilter() {
    return _$EventFilter._(
      searchTerm: '',
      stateFilter: EntityState.active,
      sortField: EventFields.name,
      sortAscending: true,
      limit: kEventLoadLimit,
    );
  }

  EventFilter._();

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

  static Serializer<EventFilter> get serializer => _$eventFilterSerializer;
}

abstract class EventInteraction
    implements Built<EventInteraction, EventInteractionBuilder> {
  factory EventInteraction([void Function(EventInteractionBuilder) updates]) =
      _$EventInteraction;

  EventInteraction._();

  @override
  @memoized
  int get hashCode;

  int get time;
  String get userId;
  String get type;

  static Serializer<EventInteraction> get serializer =>
      _$eventInteractionSerializer;
}

abstract class JoinRequest implements Built<JoinRequest, JoinRequestBuilder> {
  factory JoinRequest([void Function(JoinRequestBuilder) updates]) =
      _$JoinRequest;

  JoinRequest._();

  @override
  @memoized
  int get hashCode;

  String get userId;
  int get requestedAt;
  String get status;
  String? get message;
  int? get approvedAt;
  String? get approvedBy;

  static Serializer<JoinRequest> get serializer => _$joinRequestSerializer;
}

abstract class EventLocationData
    implements Built<EventLocationData, EventLocationDataBuilder> {
  factory EventLocationData([void Function(EventLocationDataBuilder) updates]) =
      _$EventLocationData;

  EventLocationData._();

  @override
  @memoized
  int get hashCode;

  double get lat;
  double get lng;
  String? get name;
  String? get placeId;
  String? get address;
  String? get city;
  String? get country;

  static Serializer<EventLocationData> get serializer =>
      _$eventLocationDataSerializer;
}

abstract class EventListResponse
    implements Built<EventListResponse, EventListResponseBuilder> {
  factory EventListResponse([void Function(EventListResponseBuilder) updates]) =
      _$EventListResponse;

  EventListResponse._();

  @override
  @memoized
  int get hashCode;

  BuiltList<EventEntity> get data;

  static Serializer<EventListResponse> get serializer =>
      _$eventListResponseSerializer;
}

abstract class EventItemResponse
    implements Built<EventItemResponse, EventItemResponseBuilder> {
  factory EventItemResponse([void Function(EventItemResponseBuilder) updates]) =
      _$EventItemResponse;

  EventItemResponse._();

  @override
  @memoized
  int get hashCode;

  EventEntity get data;

  static Serializer<EventItemResponse> get serializer =>
      _$eventItemResponseSerializer;
}

class EventFields {
  // STARTER: fields - do not remove comment
  static const String name = 'name';
  static const String accessCode = 'accessCode';
  static const String callToAction = 'callToAction';
  static const String chk = 'chk';
  static const String currency = 'currency';
  static const String description = 'description';
  static const String end = 'end';
  static const String start = 'start';
  static const String eventSeriesId = 'eventSeriesId';
  static const String hidden = 'hidden';
  static const String onlineEvent = 'onlineEvent';
  static const String privateEvent = 'privateEvent';
  static const String status = 'status';
  static const String ticketsAvailable = 'ticketsAvailable';
  static const String totalHolds = 'totalHolds';
  static const String totalIssuedTickets = 'totalIssuedTickets';
  static const String totalOrders = 'totalOrders';
  static const String unavailable = 'unavailable';
  static const String unavailableStatus = 'unavailableStatus';
  static const String dynamicFields = 'dynamicFields';
  static const String themeId = 'themeId';
  static const String themeName = 'themeName';
  static const String themeFontFamily = 'themeFontFamily';
  static const String themePrimaryColorHex = 'themePrimaryColorHex';
  static const String themeSecondaryColorHex = 'themeSecondaryColorHex';
}

abstract class EventEntity extends Object
    with BaseEntity
    implements Built<EventEntity, EventEntityBuilder> {
  factory EventEntity({
    String? id,
    AppState? state,
  }) {
    return _$EventEntity._(
      id: id ?? BaseEntity.nextId,
      isChanged: false,
      isDeleted: false,
      createdAt: 0,
      updatedAt: 0,
      createdUserId: '',
      assignedUserId: '',
      archivedAt: 0,
      // STARTER: constructor - do not remove comment
      name: '',
      accessCode: '',
      callToAction: '',
      chk: '',
      currency: '',
      description: '',
      end: 0,
      start: 0,
      eventSeriesId: '',
      hidden: false,
      onlineEvent: false,
      privateEvent: false,
      status: '',
      ticketsAvailable: false,
      totalHolds: 0,
      totalIssuedTickets: 0,
      totalOrders: 0,
      unavailable: false,
      unavailableStatus: '',
      themeId: null,
      themeName: null,
      themeFontFamily: null,
      themePrimaryColorHex: null,
      themeSecondaryColorHex: null,
      url: '',
      // ... other fields ...
      orders: BuiltList<OrderEntity>(),
      ticketGroups: BuiltList<TicketGroup>(),
      ticketTypes: BuiltList<TicketType>(),
      venue: Venue((b) => b
        ..name = ''
        ..postalCode = ''),
      images: Images((b) => b
        ..header = ''
        ..thumbnail = ''),
      dynamicFields: BuiltMap<String, dynamic>(),
      createdByObj: null,
      views: <EventInteraction>[],
      favourites: <EventInteraction>[],
      joinRequests: <JoinRequest>[],
      locationData: null,
      eventType: null,
      reportsMap: null,
      reported: null,
    );
  }

  EventEntity._();

  @override
  @memoized
  int get hashCode;

  // STARTER: properties - do not remove comment
  String get name;

  String? get accessCode;

  String? get eventType;

  String get callToAction;

  String get chk;

  String get currency;

  String get description;

  int get end;

  int get start;

  String get eventSeriesId;

  bool get hidden;

  bool get onlineEvent;

  bool get privateEvent;

  String get status;

  bool get ticketsAvailable;

  int get totalHolds;

  int get totalIssuedTickets;

  int get totalOrders;

  bool get unavailable;

  String get unavailableStatus;

  String? get themeId;
  String? get themeName;
  String? get themeFontFamily;
  String? get themePrimaryColorHex;
  String? get themeSecondaryColorHex;

  @BuiltValueField(serialize: false)
  EventTheme? get themeObject {
    if (themeId == null) return null;

    try {
      return EventThemes.getThemeById(themeId!);
    } catch (e) {
      return EventThemes.predefinedThemes.first;
    }
  }

  @BuiltValueField(serialize: false)
  String? get font => themeObject?.fontFamily;

  String get url;
  List<String>? get paymentMethods;

  @BuiltValueField(serialize: false)
  Map<String, dynamic>? get createdByObj;
// from event helper class:
  BuiltList<OrderEntity> get orders;
  Images? get images;
  Venue? get venue;
  BuiltList<TicketGroup>? get ticketGroups;
  BuiltList<TicketType>? get ticketTypes;

  @BuiltValueField(serialize: false)
  BuiltMap<String, dynamic> get dynamicFields;

  @BuiltValueField(serialize: false)
  String? get location =>
      locationData?.name ?? dynamicFields['location'] as String?;

  @BuiltValueField(serialize: false)
  int? get capacity {
    final capacityValue = dynamicFields['capacity'];
    if (capacityValue == null) return null;
    if (capacityValue is int) return capacityValue;
    if (capacityValue is double) return capacityValue.toInt();
    if (capacityValue is String) return int.tryParse(capacityValue);
    return null;
  }

  @BuiltValueField(serialize: false)
  String? get ticketType => dynamicFields['ticketType'] as String?;

  @BuiltValueField(serialize: false)
  double? get price {
    final priceValue = dynamicFields['price'];
    if (priceValue == null) return null;
    if (priceValue is double) return priceValue;
    if (priceValue is int) return priceValue.toDouble();
    if (priceValue is String) return double.tryParse(priceValue);
    return null;
  }

  @BuiltValueField(serialize: false)
  int? get ageRestriction {
    final ageValue = dynamicFields['ageRestriction'];
    if (ageValue == null) return null;
    if (ageValue is int) return ageValue;
    if (ageValue is double) return ageValue.toInt();
    if (ageValue is String) return int.tryParse(ageValue);
    return null;
  }

  @BuiltValueField(serialize: false)
  String? get genderRestriction =>
      dynamicFields['genderRestriction'] as String?;

  @BuiltValueField(serialize: false)
  List<EventInteraction>? get views;

  @BuiltValueField(serialize: false)
  List<EventInteraction>? get favourites;

  @BuiltValueField(serialize: false)
  List<JoinRequest>? get joinRequests;

  @BuiltValueField(serialize: false)
  EventLocationData? get locationData;

  Map<String, dynamic>? get reportsMap;

  bool? get reported;

  @override
  EntityType get entityType => EntityType.event;

  @override
  List<EntityAction?> getActions({
    UserCompanyEntity? userCompany,
    bool includeEdit = false,
    bool multiselect = false,
    bool? isGuest,
    bool? isAuthor,
  }) {
    final actions = <EntityAction?>[];

    final author = isAuthor == true;
    final guest = isGuest == true;

    if (guest) {
      return [];
    }

    if (!isDeleted! &&
        !multiselect &&
        includeEdit &&
        (userCompany?.canEditEntity(this) == true || author)) {
      actions.add(EntityAction.edit);
    }

    if (!multiselect && (userCompany?.canEditEntity(this) == true || author)) {
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

  int compareTo(EventEntity event, String sortField, bool sortAscending) {
    int response = 0;
    final eventA = sortAscending ? this : event;
    final eventB = sortAscending ? event : this;

    switch (sortField) {
      // STARTER: sort switch - do not remove comment
      case EventFields.name:
        response = eventA.name.compareTo(eventB.name);
        break;

      case EventFields.accessCode:
        response = eventA.accessCode!.compareTo(eventB.accessCode!);
        break;

      case EventFields.callToAction:
        response = eventA.callToAction.compareTo(eventB.callToAction);
        break;

      case EventFields.chk:
        response = eventA.chk.compareTo(eventB.chk);
        break;

      case EventFields.currency:
        response = eventA.currency.compareTo(eventB.currency);
        break;

      case EventFields.description:
        response = eventA.description.compareTo(eventB.description);
        break;

      case EventFields.eventSeriesId:
        response = eventA.eventSeriesId.compareTo(eventB.eventSeriesId);
        break;

      case EventFields.status:
        response = eventA.status.compareTo(eventB.status);
        break;

      case EventFields.unavailableStatus:
        response = eventA.unavailableStatus.compareTo(eventB.unavailableStatus);
        break;

      default:
        logError('sort by event.$sortField is not implemented');
        break;
    }

    if (response == 0) {
      // STARTER: sort default - do not remove comment
      return eventA.name.compareTo(eventB.name);
    } else {
      return response;
    }
  }

  @override
  bool matchesFilter(String? filter) {
    return matchesStrings(
      haystacks: [
        // STARTER: field names - do not remove comment
        name,
        accessCode,
        callToAction,
        chk,
        currency,
        description,
        eventSeriesId,
        status,
        unavailableStatus,
      ],
      needle: filter,
    );
  }

  @override
  String? matchesFilterValue(String? filter) {
    return matchesStringsValue(
      haystacks: [
        // STARTER: field names - do not remove comment
        name,
        accessCode,
        callToAction,
        chk,
        currency,
        description,
        eventSeriesId,
        status,
        unavailableStatus,
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

  static Serializer<EventEntity> get serializer => _$eventEntitySerializer;
}
