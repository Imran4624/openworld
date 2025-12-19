// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<EventFilter> _$eventFilterSerializer = new _$EventFilterSerializer();
Serializer<EventInteraction> _$eventInteractionSerializer =
    new _$EventInteractionSerializer();
Serializer<JoinRequest> _$joinRequestSerializer = new _$JoinRequestSerializer();
Serializer<EventLocationData> _$eventLocationDataSerializer =
    new _$EventLocationDataSerializer();
Serializer<EventListResponse> _$eventListResponseSerializer =
    new _$EventListResponseSerializer();
Serializer<EventItemResponse> _$eventItemResponseSerializer =
    new _$EventItemResponseSerializer();
Serializer<EventEntity> _$eventEntitySerializer = new _$EventEntitySerializer();

class _$EventFilterSerializer implements StructuredSerializer<EventFilter> {
  @override
  final Iterable<Type> types = const [EventFilter, _$EventFilter];
  @override
  final String wireName = 'EventFilter';

  @override
  Iterable<Object?> serialize(Serializers serializers, EventFilter object,
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
  EventFilter deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new EventFilterBuilder();

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

class _$EventInteractionSerializer
    implements StructuredSerializer<EventInteraction> {
  @override
  final Iterable<Type> types = const [EventInteraction, _$EventInteraction];
  @override
  final String wireName = 'EventInteraction';

  @override
  Iterable<Object?> serialize(Serializers serializers, EventInteraction object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'time',
      serializers.serialize(object.time, specifiedType: const FullType(int)),
      'userId',
      serializers.serialize(object.userId,
          specifiedType: const FullType(String)),
      'type',
      serializers.serialize(object.type, specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  EventInteraction deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new EventInteractionBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'time':
          result.time = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'userId':
          result.userId = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'type':
          result.type = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$JoinRequestSerializer implements StructuredSerializer<JoinRequest> {
  @override
  final Iterable<Type> types = const [JoinRequest, _$JoinRequest];
  @override
  final String wireName = 'JoinRequest';

  @override
  Iterable<Object?> serialize(Serializers serializers, JoinRequest object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'userId',
      serializers.serialize(object.userId,
          specifiedType: const FullType(String)),
      'requestedAt',
      serializers.serialize(object.requestedAt,
          specifiedType: const FullType(int)),
      'status',
      serializers.serialize(object.status,
          specifiedType: const FullType(String)),
    ];
    Object? value;
    value = object.message;
    if (value != null) {
      result
        ..add('message')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.approvedAt;
    if (value != null) {
      result
        ..add('approvedAt')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.approvedBy;
    if (value != null) {
      result
        ..add('approvedBy')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  JoinRequest deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new JoinRequestBuilder();

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
        case 'requestedAt':
          result.requestedAt = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'status':
          result.status = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'message':
          result.message = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'approvedAt':
          result.approvedAt = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int?;
          break;
        case 'approvedBy':
          result.approvedBy = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
      }
    }

    return result.build();
  }
}

class _$EventLocationDataSerializer
    implements StructuredSerializer<EventLocationData> {
  @override
  final Iterable<Type> types = const [EventLocationData, _$EventLocationData];
  @override
  final String wireName = 'EventLocationData';

  @override
  Iterable<Object?> serialize(Serializers serializers, EventLocationData object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'lat',
      serializers.serialize(object.lat, specifiedType: const FullType(double)),
      'lng',
      serializers.serialize(object.lng, specifiedType: const FullType(double)),
    ];
    Object? value;
    value = object.name;
    if (value != null) {
      result
        ..add('name')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.placeId;
    if (value != null) {
      result
        ..add('placeId')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.address;
    if (value != null) {
      result
        ..add('address')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.city;
    if (value != null) {
      result
        ..add('city')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.country;
    if (value != null) {
      result
        ..add('country')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  EventLocationData deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new EventLocationDataBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'lat':
          result.lat = serializers.deserialize(value,
              specifiedType: const FullType(double))! as double;
          break;
        case 'lng':
          result.lng = serializers.deserialize(value,
              specifiedType: const FullType(double))! as double;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'placeId':
          result.placeId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'address':
          result.address = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'city':
          result.city = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'country':
          result.country = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
      }
    }

    return result.build();
  }
}

class _$EventListResponseSerializer
    implements StructuredSerializer<EventListResponse> {
  @override
  final Iterable<Type> types = const [EventListResponse, _$EventListResponse];
  @override
  final String wireName = 'EventListResponse';

  @override
  Iterable<Object?> serialize(Serializers serializers, EventListResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'data',
      serializers.serialize(object.data,
          specifiedType:
              const FullType(BuiltList, const [const FullType(EventEntity)])),
    ];

    return result;
  }

  @override
  EventListResponse deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new EventListResponseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'data':
          result.data.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(EventEntity)]))!
              as BuiltList<Object?>);
          break;
      }
    }

    return result.build();
  }
}

class _$EventItemResponseSerializer
    implements StructuredSerializer<EventItemResponse> {
  @override
  final Iterable<Type> types = const [EventItemResponse, _$EventItemResponse];
  @override
  final String wireName = 'EventItemResponse';

  @override
  Iterable<Object?> serialize(Serializers serializers, EventItemResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'data',
      serializers.serialize(object.data,
          specifiedType: const FullType(EventEntity)),
    ];

    return result;
  }

  @override
  EventItemResponse deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new EventItemResponseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'data':
          result.data.replace(serializers.deserialize(value,
              specifiedType: const FullType(EventEntity))! as EventEntity);
          break;
      }
    }

    return result.build();
  }
}

class _$EventEntitySerializer implements StructuredSerializer<EventEntity> {
  @override
  final Iterable<Type> types = const [EventEntity, _$EventEntity];
  @override
  final String wireName = 'EventEntity';

  @override
  Iterable<Object?> serialize(Serializers serializers, EventEntity object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'callToAction',
      serializers.serialize(object.callToAction,
          specifiedType: const FullType(String)),
      'chk',
      serializers.serialize(object.chk, specifiedType: const FullType(String)),
      'currency',
      serializers.serialize(object.currency,
          specifiedType: const FullType(String)),
      'description',
      serializers.serialize(object.description,
          specifiedType: const FullType(String)),
      'end',
      serializers.serialize(object.end, specifiedType: const FullType(int)),
      'start',
      serializers.serialize(object.start, specifiedType: const FullType(int)),
      'eventSeriesId',
      serializers.serialize(object.eventSeriesId,
          specifiedType: const FullType(String)),
      'hidden',
      serializers.serialize(object.hidden, specifiedType: const FullType(bool)),
      'onlineEvent',
      serializers.serialize(object.onlineEvent,
          specifiedType: const FullType(bool)),
      'privateEvent',
      serializers.serialize(object.privateEvent,
          specifiedType: const FullType(bool)),
      'status',
      serializers.serialize(object.status,
          specifiedType: const FullType(String)),
      'ticketsAvailable',
      serializers.serialize(object.ticketsAvailable,
          specifiedType: const FullType(bool)),
      'totalHolds',
      serializers.serialize(object.totalHolds,
          specifiedType: const FullType(int)),
      'totalIssuedTickets',
      serializers.serialize(object.totalIssuedTickets,
          specifiedType: const FullType(int)),
      'totalOrders',
      serializers.serialize(object.totalOrders,
          specifiedType: const FullType(int)),
      'unavailable',
      serializers.serialize(object.unavailable,
          specifiedType: const FullType(bool)),
      'unavailableStatus',
      serializers.serialize(object.unavailableStatus,
          specifiedType: const FullType(String)),
      'url',
      serializers.serialize(object.url, specifiedType: const FullType(String)),
      'orders',
      serializers.serialize(object.orders,
          specifiedType:
              const FullType(BuiltList, const [const FullType(OrderEntity)])),
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
    value = object.accessCode;
    if (value != null) {
      result
        ..add('accessCode')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.eventType;
    if (value != null) {
      result
        ..add('eventType')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.themeId;
    if (value != null) {
      result
        ..add('themeId')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.themeName;
    if (value != null) {
      result
        ..add('themeName')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.themeFontFamily;
    if (value != null) {
      result
        ..add('themeFontFamily')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.themePrimaryColorHex;
    if (value != null) {
      result
        ..add('themePrimaryColorHex')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.themeSecondaryColorHex;
    if (value != null) {
      result
        ..add('themeSecondaryColorHex')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.paymentMethods;
    if (value != null) {
      result
        ..add('paymentMethods')
        ..add(serializers.serialize(value,
            specifiedType:
                const FullType(List, const [const FullType(String)])));
    }
    value = object.images;
    if (value != null) {
      result
        ..add('images')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(Images)));
    }
    value = object.venue;
    if (value != null) {
      result
        ..add('venue')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(Venue)));
    }
    value = object.ticketGroups;
    if (value != null) {
      result
        ..add('ticketGroups')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(
                BuiltList, const [const FullType(TicketGroup)])));
    }
    value = object.ticketTypes;
    if (value != null) {
      result
        ..add('ticketTypes')
        ..add(serializers.serialize(value,
            specifiedType:
                const FullType(BuiltList, const [const FullType(TicketType)])));
    }
    value = object.reportsMap;
    if (value != null) {
      result
        ..add('reportsMap')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(
                Map, const [const FullType(String), const FullType(dynamic)])));
    }
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
  EventEntity deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new EventEntityBuilder();

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
        case 'accessCode':
          result.accessCode = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'eventType':
          result.eventType = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'callToAction':
          result.callToAction = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'chk':
          result.chk = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'currency':
          result.currency = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'description':
          result.description = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'end':
          result.end = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'start':
          result.start = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'eventSeriesId':
          result.eventSeriesId = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'hidden':
          result.hidden = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
        case 'onlineEvent':
          result.onlineEvent = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
        case 'privateEvent':
          result.privateEvent = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
        case 'status':
          result.status = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'ticketsAvailable':
          result.ticketsAvailable = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
        case 'totalHolds':
          result.totalHolds = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'totalIssuedTickets':
          result.totalIssuedTickets = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'totalOrders':
          result.totalOrders = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'unavailable':
          result.unavailable = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
        case 'unavailableStatus':
          result.unavailableStatus = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'themeId':
          result.themeId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'themeName':
          result.themeName = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'themeFontFamily':
          result.themeFontFamily = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'themePrimaryColorHex':
          result.themePrimaryColorHex = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'themeSecondaryColorHex':
          result.themeSecondaryColorHex = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'url':
          result.url = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'paymentMethods':
          result.paymentMethods = serializers.deserialize(value,
                  specifiedType:
                      const FullType(List, const [const FullType(String)]))
              as List<String>?;
          break;
        case 'orders':
          result.orders.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(OrderEntity)]))!
              as BuiltList<Object?>);
          break;
        case 'images':
          result.images.replace(serializers.deserialize(value,
              specifiedType: const FullType(Images))! as Images);
          break;
        case 'venue':
          result.venue.replace(serializers.deserialize(value,
              specifiedType: const FullType(Venue))! as Venue);
          break;
        case 'ticketGroups':
          result.ticketGroups.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(TicketGroup)]))!
              as BuiltList<Object?>);
          break;
        case 'ticketTypes':
          result.ticketTypes.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(TicketType)]))!
              as BuiltList<Object?>);
          break;
        case 'reportsMap':
          result.reportsMap = serializers.deserialize(value,
              specifiedType: const FullType(Map, const [
                const FullType(String),
                const FullType(dynamic)
              ])) as Map<String, dynamic>?;
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

class _$EventFilter extends EventFilter {
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

  factory _$EventFilter([void Function(EventFilterBuilder)? updates]) =>
      (new EventFilterBuilder()..update(updates))._build();

  _$EventFilter._(
      {required this.searchTerm,
      required this.stateFilter,
      required this.sortField,
      required this.sortAscending,
      required this.limit})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        searchTerm, r'EventFilter', 'searchTerm');
    BuiltValueNullFieldError.checkNotNull(
        stateFilter, r'EventFilter', 'stateFilter');
    BuiltValueNullFieldError.checkNotNull(
        sortField, r'EventFilter', 'sortField');
    BuiltValueNullFieldError.checkNotNull(
        sortAscending, r'EventFilter', 'sortAscending');
    BuiltValueNullFieldError.checkNotNull(limit, r'EventFilter', 'limit');
  }

  @override
  EventFilter rebuild(void Function(EventFilterBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EventFilterBuilder toBuilder() => new EventFilterBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EventFilter &&
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
    return (newBuiltValueToStringHelper(r'EventFilter')
          ..add('searchTerm', searchTerm)
          ..add('stateFilter', stateFilter)
          ..add('sortField', sortField)
          ..add('sortAscending', sortAscending)
          ..add('limit', limit))
        .toString();
  }
}

class EventFilterBuilder implements Builder<EventFilter, EventFilterBuilder> {
  _$EventFilter? _$v;

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

  EventFilterBuilder();

  EventFilterBuilder get _$this {
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
  void replace(EventFilter other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$EventFilter;
  }

  @override
  void update(void Function(EventFilterBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EventFilter build() => _build();

  _$EventFilter _build() {
    final _$result = _$v ??
        new _$EventFilter._(
            searchTerm: BuiltValueNullFieldError.checkNotNull(
                searchTerm, r'EventFilter', 'searchTerm'),
            stateFilter: BuiltValueNullFieldError.checkNotNull(
                stateFilter, r'EventFilter', 'stateFilter'),
            sortField: BuiltValueNullFieldError.checkNotNull(
                sortField, r'EventFilter', 'sortField'),
            sortAscending: BuiltValueNullFieldError.checkNotNull(
                sortAscending, r'EventFilter', 'sortAscending'),
            limit: BuiltValueNullFieldError.checkNotNull(
                limit, r'EventFilter', 'limit'));
    replace(_$result);
    return _$result;
  }
}

class _$EventInteraction extends EventInteraction {
  @override
  final int time;
  @override
  final String userId;
  @override
  final String type;

  factory _$EventInteraction(
          [void Function(EventInteractionBuilder)? updates]) =>
      (new EventInteractionBuilder()..update(updates))._build();

  _$EventInteraction._(
      {required this.time, required this.userId, required this.type})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(time, r'EventInteraction', 'time');
    BuiltValueNullFieldError.checkNotNull(
        userId, r'EventInteraction', 'userId');
    BuiltValueNullFieldError.checkNotNull(type, r'EventInteraction', 'type');
  }

  @override
  EventInteraction rebuild(void Function(EventInteractionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EventInteractionBuilder toBuilder() =>
      new EventInteractionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EventInteraction &&
        time == other.time &&
        userId == other.userId &&
        type == other.type;
  }

  int? __hashCode;
  @override
  int get hashCode {
    if (__hashCode != null) return __hashCode!;
    var _$hash = 0;
    _$hash = $jc(_$hash, time.hashCode);
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jf(_$hash);
    return __hashCode ??= _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EventInteraction')
          ..add('time', time)
          ..add('userId', userId)
          ..add('type', type))
        .toString();
  }
}

class EventInteractionBuilder
    implements Builder<EventInteraction, EventInteractionBuilder> {
  _$EventInteraction? _$v;

  int? _time;
  int? get time => _$this._time;
  set time(int? time) => _$this._time = time;

  String? _userId;
  String? get userId => _$this._userId;
  set userId(String? userId) => _$this._userId = userId;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  EventInteractionBuilder();

  EventInteractionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _time = $v.time;
      _userId = $v.userId;
      _type = $v.type;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EventInteraction other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$EventInteraction;
  }

  @override
  void update(void Function(EventInteractionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EventInteraction build() => _build();

  _$EventInteraction _build() {
    final _$result = _$v ??
        new _$EventInteraction._(
            time: BuiltValueNullFieldError.checkNotNull(
                time, r'EventInteraction', 'time'),
            userId: BuiltValueNullFieldError.checkNotNull(
                userId, r'EventInteraction', 'userId'),
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'EventInteraction', 'type'));
    replace(_$result);
    return _$result;
  }
}

class _$JoinRequest extends JoinRequest {
  @override
  final String userId;
  @override
  final int requestedAt;
  @override
  final String status;
  @override
  final String? message;
  @override
  final int? approvedAt;
  @override
  final String? approvedBy;

  factory _$JoinRequest([void Function(JoinRequestBuilder)? updates]) =>
      (new JoinRequestBuilder()..update(updates))._build();

  _$JoinRequest._(
      {required this.userId,
      required this.requestedAt,
      required this.status,
      this.message,
      this.approvedAt,
      this.approvedBy})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(userId, r'JoinRequest', 'userId');
    BuiltValueNullFieldError.checkNotNull(
        requestedAt, r'JoinRequest', 'requestedAt');
    BuiltValueNullFieldError.checkNotNull(status, r'JoinRequest', 'status');
  }

  @override
  JoinRequest rebuild(void Function(JoinRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  JoinRequestBuilder toBuilder() => new JoinRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is JoinRequest &&
        userId == other.userId &&
        requestedAt == other.requestedAt &&
        status == other.status &&
        message == other.message &&
        approvedAt == other.approvedAt &&
        approvedBy == other.approvedBy;
  }

  int? __hashCode;
  @override
  int get hashCode {
    if (__hashCode != null) return __hashCode!;
    var _$hash = 0;
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jc(_$hash, requestedAt.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jc(_$hash, approvedAt.hashCode);
    _$hash = $jc(_$hash, approvedBy.hashCode);
    _$hash = $jf(_$hash);
    return __hashCode ??= _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'JoinRequest')
          ..add('userId', userId)
          ..add('requestedAt', requestedAt)
          ..add('status', status)
          ..add('message', message)
          ..add('approvedAt', approvedAt)
          ..add('approvedBy', approvedBy))
        .toString();
  }
}

class JoinRequestBuilder implements Builder<JoinRequest, JoinRequestBuilder> {
  _$JoinRequest? _$v;

  String? _userId;
  String? get userId => _$this._userId;
  set userId(String? userId) => _$this._userId = userId;

  int? _requestedAt;
  int? get requestedAt => _$this._requestedAt;
  set requestedAt(int? requestedAt) => _$this._requestedAt = requestedAt;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  int? _approvedAt;
  int? get approvedAt => _$this._approvedAt;
  set approvedAt(int? approvedAt) => _$this._approvedAt = approvedAt;

  String? _approvedBy;
  String? get approvedBy => _$this._approvedBy;
  set approvedBy(String? approvedBy) => _$this._approvedBy = approvedBy;

  JoinRequestBuilder();

  JoinRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _userId = $v.userId;
      _requestedAt = $v.requestedAt;
      _status = $v.status;
      _message = $v.message;
      _approvedAt = $v.approvedAt;
      _approvedBy = $v.approvedBy;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(JoinRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$JoinRequest;
  }

  @override
  void update(void Function(JoinRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  JoinRequest build() => _build();

  _$JoinRequest _build() {
    final _$result = _$v ??
        new _$JoinRequest._(
            userId: BuiltValueNullFieldError.checkNotNull(
                userId, r'JoinRequest', 'userId'),
            requestedAt: BuiltValueNullFieldError.checkNotNull(
                requestedAt, r'JoinRequest', 'requestedAt'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'JoinRequest', 'status'),
            message: message,
            approvedAt: approvedAt,
            approvedBy: approvedBy);
    replace(_$result);
    return _$result;
  }
}

class _$EventLocationData extends EventLocationData {
  @override
  final double lat;
  @override
  final double lng;
  @override
  final String? name;
  @override
  final String? placeId;
  @override
  final String? address;
  @override
  final String? city;
  @override
  final String? country;

  factory _$EventLocationData(
          [void Function(EventLocationDataBuilder)? updates]) =>
      (new EventLocationDataBuilder()..update(updates))._build();

  _$EventLocationData._(
      {required this.lat,
      required this.lng,
      this.name,
      this.placeId,
      this.address,
      this.city,
      this.country})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(lat, r'EventLocationData', 'lat');
    BuiltValueNullFieldError.checkNotNull(lng, r'EventLocationData', 'lng');
  }

  @override
  EventLocationData rebuild(void Function(EventLocationDataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EventLocationDataBuilder toBuilder() =>
      new EventLocationDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EventLocationData &&
        lat == other.lat &&
        lng == other.lng &&
        name == other.name &&
        placeId == other.placeId &&
        address == other.address &&
        city == other.city &&
        country == other.country;
  }

  int? __hashCode;
  @override
  int get hashCode {
    if (__hashCode != null) return __hashCode!;
    var _$hash = 0;
    _$hash = $jc(_$hash, lat.hashCode);
    _$hash = $jc(_$hash, lng.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, placeId.hashCode);
    _$hash = $jc(_$hash, address.hashCode);
    _$hash = $jc(_$hash, city.hashCode);
    _$hash = $jc(_$hash, country.hashCode);
    _$hash = $jf(_$hash);
    return __hashCode ??= _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EventLocationData')
          ..add('lat', lat)
          ..add('lng', lng)
          ..add('name', name)
          ..add('placeId', placeId)
          ..add('address', address)
          ..add('city', city)
          ..add('country', country))
        .toString();
  }
}

class EventLocationDataBuilder
    implements Builder<EventLocationData, EventLocationDataBuilder> {
  _$EventLocationData? _$v;

  double? _lat;
  double? get lat => _$this._lat;
  set lat(double? lat) => _$this._lat = lat;

  double? _lng;
  double? get lng => _$this._lng;
  set lng(double? lng) => _$this._lng = lng;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _placeId;
  String? get placeId => _$this._placeId;
  set placeId(String? placeId) => _$this._placeId = placeId;

  String? _address;
  String? get address => _$this._address;
  set address(String? address) => _$this._address = address;

  String? _city;
  String? get city => _$this._city;
  set city(String? city) => _$this._city = city;

  String? _country;
  String? get country => _$this._country;
  set country(String? country) => _$this._country = country;

  EventLocationDataBuilder();

  EventLocationDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lat = $v.lat;
      _lng = $v.lng;
      _name = $v.name;
      _placeId = $v.placeId;
      _address = $v.address;
      _city = $v.city;
      _country = $v.country;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EventLocationData other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$EventLocationData;
  }

  @override
  void update(void Function(EventLocationDataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EventLocationData build() => _build();

  _$EventLocationData _build() {
    final _$result = _$v ??
        new _$EventLocationData._(
            lat: BuiltValueNullFieldError.checkNotNull(
                lat, r'EventLocationData', 'lat'),
            lng: BuiltValueNullFieldError.checkNotNull(
                lng, r'EventLocationData', 'lng'),
            name: name,
            placeId: placeId,
            address: address,
            city: city,
            country: country);
    replace(_$result);
    return _$result;
  }
}

class _$EventListResponse extends EventListResponse {
  @override
  final BuiltList<EventEntity> data;

  factory _$EventListResponse(
          [void Function(EventListResponseBuilder)? updates]) =>
      (new EventListResponseBuilder()..update(updates))._build();

  _$EventListResponse._({required this.data}) : super._() {
    BuiltValueNullFieldError.checkNotNull(data, r'EventListResponse', 'data');
  }

  @override
  EventListResponse rebuild(void Function(EventListResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EventListResponseBuilder toBuilder() =>
      new EventListResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EventListResponse && data == other.data;
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
    return (newBuiltValueToStringHelper(r'EventListResponse')
          ..add('data', data))
        .toString();
  }
}

class EventListResponseBuilder
    implements Builder<EventListResponse, EventListResponseBuilder> {
  _$EventListResponse? _$v;

  ListBuilder<EventEntity>? _data;
  ListBuilder<EventEntity> get data =>
      _$this._data ??= new ListBuilder<EventEntity>();
  set data(ListBuilder<EventEntity>? data) => _$this._data = data;

  EventListResponseBuilder();

  EventListResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EventListResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$EventListResponse;
  }

  @override
  void update(void Function(EventListResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EventListResponse build() => _build();

  _$EventListResponse _build() {
    _$EventListResponse _$result;
    try {
      _$result = _$v ?? new _$EventListResponse._(data: data.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'EventListResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$EventItemResponse extends EventItemResponse {
  @override
  final EventEntity data;

  factory _$EventItemResponse(
          [void Function(EventItemResponseBuilder)? updates]) =>
      (new EventItemResponseBuilder()..update(updates))._build();

  _$EventItemResponse._({required this.data}) : super._() {
    BuiltValueNullFieldError.checkNotNull(data, r'EventItemResponse', 'data');
  }

  @override
  EventItemResponse rebuild(void Function(EventItemResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EventItemResponseBuilder toBuilder() =>
      new EventItemResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EventItemResponse && data == other.data;
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
    return (newBuiltValueToStringHelper(r'EventItemResponse')
          ..add('data', data))
        .toString();
  }
}

class EventItemResponseBuilder
    implements Builder<EventItemResponse, EventItemResponseBuilder> {
  _$EventItemResponse? _$v;

  EventEntityBuilder? _data;
  EventEntityBuilder get data => _$this._data ??= new EventEntityBuilder();
  set data(EventEntityBuilder? data) => _$this._data = data;

  EventItemResponseBuilder();

  EventItemResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EventItemResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$EventItemResponse;
  }

  @override
  void update(void Function(EventItemResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EventItemResponse build() => _build();

  _$EventItemResponse _build() {
    _$EventItemResponse _$result;
    try {
      _$result = _$v ?? new _$EventItemResponse._(data: data.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'EventItemResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$EventEntity extends EventEntity {
  @override
  final String name;
  @override
  final String? accessCode;
  @override
  final String? eventType;
  @override
  final String callToAction;
  @override
  final String chk;
  @override
  final String currency;
  @override
  final String description;
  @override
  final int end;
  @override
  final int start;
  @override
  final String eventSeriesId;
  @override
  final bool hidden;
  @override
  final bool onlineEvent;
  @override
  final bool privateEvent;
  @override
  final String status;
  @override
  final bool ticketsAvailable;
  @override
  final int totalHolds;
  @override
  final int totalIssuedTickets;
  @override
  final int totalOrders;
  @override
  final bool unavailable;
  @override
  final String unavailableStatus;
  @override
  final String? themeId;
  @override
  final String? themeName;
  @override
  final String? themeFontFamily;
  @override
  final String? themePrimaryColorHex;
  @override
  final String? themeSecondaryColorHex;
  @override
  final String url;
  @override
  final List<String>? paymentMethods;
  @override
  final Map<String, dynamic>? createdByObj;
  @override
  final BuiltList<OrderEntity> orders;
  @override
  final Images? images;
  @override
  final Venue? venue;
  @override
  final BuiltList<TicketGroup>? ticketGroups;
  @override
  final BuiltList<TicketType>? ticketTypes;
  @override
  final BuiltMap<String, dynamic> dynamicFields;
  @override
  final List<EventInteraction>? views;
  @override
  final List<EventInteraction>? favourites;
  @override
  final List<JoinRequest>? joinRequests;
  @override
  final EventLocationData? locationData;
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

  factory _$EventEntity([void Function(EventEntityBuilder)? updates]) =>
      (new EventEntityBuilder()..update(updates))._build();

  _$EventEntity._(
      {required this.name,
      this.accessCode,
      this.eventType,
      required this.callToAction,
      required this.chk,
      required this.currency,
      required this.description,
      required this.end,
      required this.start,
      required this.eventSeriesId,
      required this.hidden,
      required this.onlineEvent,
      required this.privateEvent,
      required this.status,
      required this.ticketsAvailable,
      required this.totalHolds,
      required this.totalIssuedTickets,
      required this.totalOrders,
      required this.unavailable,
      required this.unavailableStatus,
      this.themeId,
      this.themeName,
      this.themeFontFamily,
      this.themePrimaryColorHex,
      this.themeSecondaryColorHex,
      required this.url,
      this.paymentMethods,
      this.createdByObj,
      required this.orders,
      this.images,
      this.venue,
      this.ticketGroups,
      this.ticketTypes,
      required this.dynamicFields,
      this.views,
      this.favourites,
      this.joinRequests,
      this.locationData,
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
    BuiltValueNullFieldError.checkNotNull(name, r'EventEntity', 'name');
    BuiltValueNullFieldError.checkNotNull(
        callToAction, r'EventEntity', 'callToAction');
    BuiltValueNullFieldError.checkNotNull(chk, r'EventEntity', 'chk');
    BuiltValueNullFieldError.checkNotNull(currency, r'EventEntity', 'currency');
    BuiltValueNullFieldError.checkNotNull(
        description, r'EventEntity', 'description');
    BuiltValueNullFieldError.checkNotNull(end, r'EventEntity', 'end');
    BuiltValueNullFieldError.checkNotNull(start, r'EventEntity', 'start');
    BuiltValueNullFieldError.checkNotNull(
        eventSeriesId, r'EventEntity', 'eventSeriesId');
    BuiltValueNullFieldError.checkNotNull(hidden, r'EventEntity', 'hidden');
    BuiltValueNullFieldError.checkNotNull(
        onlineEvent, r'EventEntity', 'onlineEvent');
    BuiltValueNullFieldError.checkNotNull(
        privateEvent, r'EventEntity', 'privateEvent');
    BuiltValueNullFieldError.checkNotNull(status, r'EventEntity', 'status');
    BuiltValueNullFieldError.checkNotNull(
        ticketsAvailable, r'EventEntity', 'ticketsAvailable');
    BuiltValueNullFieldError.checkNotNull(
        totalHolds, r'EventEntity', 'totalHolds');
    BuiltValueNullFieldError.checkNotNull(
        totalIssuedTickets, r'EventEntity', 'totalIssuedTickets');
    BuiltValueNullFieldError.checkNotNull(
        totalOrders, r'EventEntity', 'totalOrders');
    BuiltValueNullFieldError.checkNotNull(
        unavailable, r'EventEntity', 'unavailable');
    BuiltValueNullFieldError.checkNotNull(
        unavailableStatus, r'EventEntity', 'unavailableStatus');
    BuiltValueNullFieldError.checkNotNull(url, r'EventEntity', 'url');
    BuiltValueNullFieldError.checkNotNull(orders, r'EventEntity', 'orders');
    BuiltValueNullFieldError.checkNotNull(
        dynamicFields, r'EventEntity', 'dynamicFields');
    BuiltValueNullFieldError.checkNotNull(
        createdAt, r'EventEntity', 'createdAt');
    BuiltValueNullFieldError.checkNotNull(
        updatedAt, r'EventEntity', 'updatedAt');
    BuiltValueNullFieldError.checkNotNull(
        archivedAt, r'EventEntity', 'archivedAt');
    BuiltValueNullFieldError.checkNotNull(id, r'EventEntity', 'id');
  }

  @override
  EventEntity rebuild(void Function(EventEntityBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EventEntityBuilder toBuilder() => new EventEntityBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EventEntity &&
        name == other.name &&
        accessCode == other.accessCode &&
        eventType == other.eventType &&
        callToAction == other.callToAction &&
        chk == other.chk &&
        currency == other.currency &&
        description == other.description &&
        end == other.end &&
        start == other.start &&
        eventSeriesId == other.eventSeriesId &&
        hidden == other.hidden &&
        onlineEvent == other.onlineEvent &&
        privateEvent == other.privateEvent &&
        status == other.status &&
        ticketsAvailable == other.ticketsAvailable &&
        totalHolds == other.totalHolds &&
        totalIssuedTickets == other.totalIssuedTickets &&
        totalOrders == other.totalOrders &&
        unavailable == other.unavailable &&
        unavailableStatus == other.unavailableStatus &&
        themeId == other.themeId &&
        themeName == other.themeName &&
        themeFontFamily == other.themeFontFamily &&
        themePrimaryColorHex == other.themePrimaryColorHex &&
        themeSecondaryColorHex == other.themeSecondaryColorHex &&
        url == other.url &&
        paymentMethods == other.paymentMethods &&
        createdByObj == other.createdByObj &&
        orders == other.orders &&
        images == other.images &&
        venue == other.venue &&
        ticketGroups == other.ticketGroups &&
        ticketTypes == other.ticketTypes &&
        dynamicFields == other.dynamicFields &&
        views == other.views &&
        favourites == other.favourites &&
        joinRequests == other.joinRequests &&
        locationData == other.locationData &&
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
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, accessCode.hashCode);
    _$hash = $jc(_$hash, eventType.hashCode);
    _$hash = $jc(_$hash, callToAction.hashCode);
    _$hash = $jc(_$hash, chk.hashCode);
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, end.hashCode);
    _$hash = $jc(_$hash, start.hashCode);
    _$hash = $jc(_$hash, eventSeriesId.hashCode);
    _$hash = $jc(_$hash, hidden.hashCode);
    _$hash = $jc(_$hash, onlineEvent.hashCode);
    _$hash = $jc(_$hash, privateEvent.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, ticketsAvailable.hashCode);
    _$hash = $jc(_$hash, totalHolds.hashCode);
    _$hash = $jc(_$hash, totalIssuedTickets.hashCode);
    _$hash = $jc(_$hash, totalOrders.hashCode);
    _$hash = $jc(_$hash, unavailable.hashCode);
    _$hash = $jc(_$hash, unavailableStatus.hashCode);
    _$hash = $jc(_$hash, themeId.hashCode);
    _$hash = $jc(_$hash, themeName.hashCode);
    _$hash = $jc(_$hash, themeFontFamily.hashCode);
    _$hash = $jc(_$hash, themePrimaryColorHex.hashCode);
    _$hash = $jc(_$hash, themeSecondaryColorHex.hashCode);
    _$hash = $jc(_$hash, url.hashCode);
    _$hash = $jc(_$hash, paymentMethods.hashCode);
    _$hash = $jc(_$hash, createdByObj.hashCode);
    _$hash = $jc(_$hash, orders.hashCode);
    _$hash = $jc(_$hash, images.hashCode);
    _$hash = $jc(_$hash, venue.hashCode);
    _$hash = $jc(_$hash, ticketGroups.hashCode);
    _$hash = $jc(_$hash, ticketTypes.hashCode);
    _$hash = $jc(_$hash, dynamicFields.hashCode);
    _$hash = $jc(_$hash, views.hashCode);
    _$hash = $jc(_$hash, favourites.hashCode);
    _$hash = $jc(_$hash, joinRequests.hashCode);
    _$hash = $jc(_$hash, locationData.hashCode);
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
    return (newBuiltValueToStringHelper(r'EventEntity')
          ..add('name', name)
          ..add('accessCode', accessCode)
          ..add('eventType', eventType)
          ..add('callToAction', callToAction)
          ..add('chk', chk)
          ..add('currency', currency)
          ..add('description', description)
          ..add('end', end)
          ..add('start', start)
          ..add('eventSeriesId', eventSeriesId)
          ..add('hidden', hidden)
          ..add('onlineEvent', onlineEvent)
          ..add('privateEvent', privateEvent)
          ..add('status', status)
          ..add('ticketsAvailable', ticketsAvailable)
          ..add('totalHolds', totalHolds)
          ..add('totalIssuedTickets', totalIssuedTickets)
          ..add('totalOrders', totalOrders)
          ..add('unavailable', unavailable)
          ..add('unavailableStatus', unavailableStatus)
          ..add('themeId', themeId)
          ..add('themeName', themeName)
          ..add('themeFontFamily', themeFontFamily)
          ..add('themePrimaryColorHex', themePrimaryColorHex)
          ..add('themeSecondaryColorHex', themeSecondaryColorHex)
          ..add('url', url)
          ..add('paymentMethods', paymentMethods)
          ..add('createdByObj', createdByObj)
          ..add('orders', orders)
          ..add('images', images)
          ..add('venue', venue)
          ..add('ticketGroups', ticketGroups)
          ..add('ticketTypes', ticketTypes)
          ..add('dynamicFields', dynamicFields)
          ..add('views', views)
          ..add('favourites', favourites)
          ..add('joinRequests', joinRequests)
          ..add('locationData', locationData)
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

class EventEntityBuilder implements Builder<EventEntity, EventEntityBuilder> {
  _$EventEntity? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _accessCode;
  String? get accessCode => _$this._accessCode;
  set accessCode(String? accessCode) => _$this._accessCode = accessCode;

  String? _eventType;
  String? get eventType => _$this._eventType;
  set eventType(String? eventType) => _$this._eventType = eventType;

  String? _callToAction;
  String? get callToAction => _$this._callToAction;
  set callToAction(String? callToAction) => _$this._callToAction = callToAction;

  String? _chk;
  String? get chk => _$this._chk;
  set chk(String? chk) => _$this._chk = chk;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  int? _end;
  int? get end => _$this._end;
  set end(int? end) => _$this._end = end;

  int? _start;
  int? get start => _$this._start;
  set start(int? start) => _$this._start = start;

  String? _eventSeriesId;
  String? get eventSeriesId => _$this._eventSeriesId;
  set eventSeriesId(String? eventSeriesId) =>
      _$this._eventSeriesId = eventSeriesId;

  bool? _hidden;
  bool? get hidden => _$this._hidden;
  set hidden(bool? hidden) => _$this._hidden = hidden;

  bool? _onlineEvent;
  bool? get onlineEvent => _$this._onlineEvent;
  set onlineEvent(bool? onlineEvent) => _$this._onlineEvent = onlineEvent;

  bool? _privateEvent;
  bool? get privateEvent => _$this._privateEvent;
  set privateEvent(bool? privateEvent) => _$this._privateEvent = privateEvent;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  bool? _ticketsAvailable;
  bool? get ticketsAvailable => _$this._ticketsAvailable;
  set ticketsAvailable(bool? ticketsAvailable) =>
      _$this._ticketsAvailable = ticketsAvailable;

  int? _totalHolds;
  int? get totalHolds => _$this._totalHolds;
  set totalHolds(int? totalHolds) => _$this._totalHolds = totalHolds;

  int? _totalIssuedTickets;
  int? get totalIssuedTickets => _$this._totalIssuedTickets;
  set totalIssuedTickets(int? totalIssuedTickets) =>
      _$this._totalIssuedTickets = totalIssuedTickets;

  int? _totalOrders;
  int? get totalOrders => _$this._totalOrders;
  set totalOrders(int? totalOrders) => _$this._totalOrders = totalOrders;

  bool? _unavailable;
  bool? get unavailable => _$this._unavailable;
  set unavailable(bool? unavailable) => _$this._unavailable = unavailable;

  String? _unavailableStatus;
  String? get unavailableStatus => _$this._unavailableStatus;
  set unavailableStatus(String? unavailableStatus) =>
      _$this._unavailableStatus = unavailableStatus;

  String? _themeId;
  String? get themeId => _$this._themeId;
  set themeId(String? themeId) => _$this._themeId = themeId;

  String? _themeName;
  String? get themeName => _$this._themeName;
  set themeName(String? themeName) => _$this._themeName = themeName;

  String? _themeFontFamily;
  String? get themeFontFamily => _$this._themeFontFamily;
  set themeFontFamily(String? themeFontFamily) =>
      _$this._themeFontFamily = themeFontFamily;

  String? _themePrimaryColorHex;
  String? get themePrimaryColorHex => _$this._themePrimaryColorHex;
  set themePrimaryColorHex(String? themePrimaryColorHex) =>
      _$this._themePrimaryColorHex = themePrimaryColorHex;

  String? _themeSecondaryColorHex;
  String? get themeSecondaryColorHex => _$this._themeSecondaryColorHex;
  set themeSecondaryColorHex(String? themeSecondaryColorHex) =>
      _$this._themeSecondaryColorHex = themeSecondaryColorHex;

  String? _url;
  String? get url => _$this._url;
  set url(String? url) => _$this._url = url;

  List<String>? _paymentMethods;
  List<String>? get paymentMethods => _$this._paymentMethods;
  set paymentMethods(List<String>? paymentMethods) =>
      _$this._paymentMethods = paymentMethods;

  Map<String, dynamic>? _createdByObj;
  Map<String, dynamic>? get createdByObj => _$this._createdByObj;
  set createdByObj(Map<String, dynamic>? createdByObj) =>
      _$this._createdByObj = createdByObj;

  ListBuilder<OrderEntity>? _orders;
  ListBuilder<OrderEntity> get orders =>
      _$this._orders ??= new ListBuilder<OrderEntity>();
  set orders(ListBuilder<OrderEntity>? orders) => _$this._orders = orders;

  ImagesBuilder? _images;
  ImagesBuilder get images => _$this._images ??= new ImagesBuilder();
  set images(ImagesBuilder? images) => _$this._images = images;

  VenueBuilder? _venue;
  VenueBuilder get venue => _$this._venue ??= new VenueBuilder();
  set venue(VenueBuilder? venue) => _$this._venue = venue;

  ListBuilder<TicketGroup>? _ticketGroups;
  ListBuilder<TicketGroup> get ticketGroups =>
      _$this._ticketGroups ??= new ListBuilder<TicketGroup>();
  set ticketGroups(ListBuilder<TicketGroup>? ticketGroups) =>
      _$this._ticketGroups = ticketGroups;

  ListBuilder<TicketType>? _ticketTypes;
  ListBuilder<TicketType> get ticketTypes =>
      _$this._ticketTypes ??= new ListBuilder<TicketType>();
  set ticketTypes(ListBuilder<TicketType>? ticketTypes) =>
      _$this._ticketTypes = ticketTypes;

  MapBuilder<String, dynamic>? _dynamicFields;
  MapBuilder<String, dynamic> get dynamicFields =>
      _$this._dynamicFields ??= new MapBuilder<String, dynamic>();
  set dynamicFields(MapBuilder<String, dynamic>? dynamicFields) =>
      _$this._dynamicFields = dynamicFields;

  List<EventInteraction>? _views;
  List<EventInteraction>? get views => _$this._views;
  set views(List<EventInteraction>? views) => _$this._views = views;

  List<EventInteraction>? _favourites;
  List<EventInteraction>? get favourites => _$this._favourites;
  set favourites(List<EventInteraction>? favourites) =>
      _$this._favourites = favourites;

  List<JoinRequest>? _joinRequests;
  List<JoinRequest>? get joinRequests => _$this._joinRequests;
  set joinRequests(List<JoinRequest>? joinRequests) =>
      _$this._joinRequests = joinRequests;

  EventLocationDataBuilder? _locationData;
  EventLocationDataBuilder get locationData =>
      _$this._locationData ??= new EventLocationDataBuilder();
  set locationData(EventLocationDataBuilder? locationData) =>
      _$this._locationData = locationData;

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

  EventEntityBuilder();

  EventEntityBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _accessCode = $v.accessCode;
      _eventType = $v.eventType;
      _callToAction = $v.callToAction;
      _chk = $v.chk;
      _currency = $v.currency;
      _description = $v.description;
      _end = $v.end;
      _start = $v.start;
      _eventSeriesId = $v.eventSeriesId;
      _hidden = $v.hidden;
      _onlineEvent = $v.onlineEvent;
      _privateEvent = $v.privateEvent;
      _status = $v.status;
      _ticketsAvailable = $v.ticketsAvailable;
      _totalHolds = $v.totalHolds;
      _totalIssuedTickets = $v.totalIssuedTickets;
      _totalOrders = $v.totalOrders;
      _unavailable = $v.unavailable;
      _unavailableStatus = $v.unavailableStatus;
      _themeId = $v.themeId;
      _themeName = $v.themeName;
      _themeFontFamily = $v.themeFontFamily;
      _themePrimaryColorHex = $v.themePrimaryColorHex;
      _themeSecondaryColorHex = $v.themeSecondaryColorHex;
      _url = $v.url;
      _paymentMethods = $v.paymentMethods;
      _createdByObj = $v.createdByObj;
      _orders = $v.orders.toBuilder();
      _images = $v.images?.toBuilder();
      _venue = $v.venue?.toBuilder();
      _ticketGroups = $v.ticketGroups?.toBuilder();
      _ticketTypes = $v.ticketTypes?.toBuilder();
      _dynamicFields = $v.dynamicFields.toBuilder();
      _views = $v.views;
      _favourites = $v.favourites;
      _joinRequests = $v.joinRequests;
      _locationData = $v.locationData?.toBuilder();
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
  void replace(EventEntity other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$EventEntity;
  }

  @override
  void update(void Function(EventEntityBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EventEntity build() => _build();

  _$EventEntity _build() {
    _$EventEntity _$result;
    try {
      _$result = _$v ??
          new _$EventEntity._(
              name: BuiltValueNullFieldError.checkNotNull(
                  name, r'EventEntity', 'name'),
              accessCode: accessCode,
              eventType: eventType,
              callToAction: BuiltValueNullFieldError.checkNotNull(
                  callToAction, r'EventEntity', 'callToAction'),
              chk: BuiltValueNullFieldError.checkNotNull(
                  chk, r'EventEntity', 'chk'),
              currency: BuiltValueNullFieldError.checkNotNull(
                  currency, r'EventEntity', 'currency'),
              description: BuiltValueNullFieldError.checkNotNull(
                  description, r'EventEntity', 'description'),
              end: BuiltValueNullFieldError.checkNotNull(
                  end, r'EventEntity', 'end'),
              start: BuiltValueNullFieldError.checkNotNull(
                  start, r'EventEntity', 'start'),
              eventSeriesId: BuiltValueNullFieldError.checkNotNull(
                  eventSeriesId, r'EventEntity', 'eventSeriesId'),
              hidden: BuiltValueNullFieldError.checkNotNull(
                  hidden, r'EventEntity', 'hidden'),
              onlineEvent: BuiltValueNullFieldError.checkNotNull(onlineEvent, r'EventEntity', 'onlineEvent'),
              privateEvent: BuiltValueNullFieldError.checkNotNull(privateEvent, r'EventEntity', 'privateEvent'),
              status: BuiltValueNullFieldError.checkNotNull(status, r'EventEntity', 'status'),
              ticketsAvailable: BuiltValueNullFieldError.checkNotNull(ticketsAvailable, r'EventEntity', 'ticketsAvailable'),
              totalHolds: BuiltValueNullFieldError.checkNotNull(totalHolds, r'EventEntity', 'totalHolds'),
              totalIssuedTickets: BuiltValueNullFieldError.checkNotNull(totalIssuedTickets, r'EventEntity', 'totalIssuedTickets'),
              totalOrders: BuiltValueNullFieldError.checkNotNull(totalOrders, r'EventEntity', 'totalOrders'),
              unavailable: BuiltValueNullFieldError.checkNotNull(unavailable, r'EventEntity', 'unavailable'),
              unavailableStatus: BuiltValueNullFieldError.checkNotNull(unavailableStatus, r'EventEntity', 'unavailableStatus'),
              themeId: themeId,
              themeName: themeName,
              themeFontFamily: themeFontFamily,
              themePrimaryColorHex: themePrimaryColorHex,
              themeSecondaryColorHex: themeSecondaryColorHex,
              url: BuiltValueNullFieldError.checkNotNull(url, r'EventEntity', 'url'),
              paymentMethods: paymentMethods,
              createdByObj: createdByObj,
              orders: orders.build(),
              images: _images?.build(),
              venue: _venue?.build(),
              ticketGroups: _ticketGroups?.build(),
              ticketTypes: _ticketTypes?.build(),
              dynamicFields: dynamicFields.build(),
              views: views,
              favourites: favourites,
              joinRequests: joinRequests,
              locationData: _locationData?.build(),
              reportsMap: reportsMap,
              reported: reported,
              isChanged: isChanged,
              createdAt: BuiltValueNullFieldError.checkNotNull(createdAt, r'EventEntity', 'createdAt'),
              updatedAt: BuiltValueNullFieldError.checkNotNull(updatedAt, r'EventEntity', 'updatedAt'),
              archivedAt: BuiltValueNullFieldError.checkNotNull(archivedAt, r'EventEntity', 'archivedAt'),
              isDeleted: isDeleted,
              isReported: isReported,
              createdUserId: createdUserId,
              assignedUserId: assignedUserId,
              id: BuiltValueNullFieldError.checkNotNull(id, r'EventEntity', 'id'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'orders';
        orders.build();
        _$failedField = 'images';
        _images?.build();
        _$failedField = 'venue';
        _venue?.build();
        _$failedField = 'ticketGroups';
        _ticketGroups?.build();
        _$failedField = 'ticketTypes';
        _ticketTypes?.build();
        _$failedField = 'dynamicFields';
        dynamicFields.build();

        _$failedField = 'locationData';
        _locationData?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'EventEntity', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
