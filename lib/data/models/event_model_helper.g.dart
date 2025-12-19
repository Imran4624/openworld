// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_model_helper.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<TicketType> _$ticketTypeSerializer = new _$TicketTypeSerializer();
Serializer<TicketGroup> _$ticketGroupSerializer = new _$TicketGroupSerializer();
Serializer<Venue> _$venueSerializer = new _$VenueSerializer();
Serializer<Images> _$imagesSerializer = new _$ImagesSerializer();
Serializer<OrderEntity> _$orderEntitySerializer = new _$OrderEntitySerializer();
Serializer<BuyerDetails> _$buyerDetailsSerializer =
    new _$BuyerDetailsSerializer();
Serializer<IssuedTicket> _$issuedTicketSerializer =
    new _$IssuedTicketSerializer();
Serializer<LineItem> _$lineItemSerializer = new _$LineItemSerializer();

class _$TicketTypeSerializer implements StructuredSerializer<TicketType> {
  @override
  final Iterable<Type> types = const [TicketType, _$TicketType];
  @override
  final String wireName = 'TicketType';

  @override
  Iterable<Object?> serialize(Serializers serializers, TicketType object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'object',
      serializers.serialize(object.object,
          specifiedType: const FullType(String)),
      'bookingFee',
      serializers.serialize(object.bookingFee,
          specifiedType: const FullType(int)),
      'maxPerOrder',
      serializers.serialize(object.maxPerOrder,
          specifiedType: const FullType(int)),
      'minPerOrder',
      serializers.serialize(object.minPerOrder,
          specifiedType: const FullType(String)),
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'price',
      serializers.serialize(object.price, specifiedType: const FullType(int)),
      'quantity',
      serializers.serialize(object.quantity,
          specifiedType: const FullType(int)),
      'quantityHeld',
      serializers.serialize(object.quantityHeld,
          specifiedType: const FullType(int)),
      'quantityIssued',
      serializers.serialize(object.quantityIssued,
          specifiedType: const FullType(int)),
      'quantityTotal',
      serializers.serialize(object.quantityTotal,
          specifiedType: const FullType(int)),
      'sortOrder',
      serializers.serialize(object.sortOrder,
          specifiedType: const FullType(int)),
      'status',
      serializers.serialize(object.status,
          specifiedType: const FullType(String)),
      'type',
      serializers.serialize(object.type, specifiedType: const FullType(String)),
    ];
    Object? value;
    value = object.accessCode;
    if (value != null) {
      result
        ..add('accessCode')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.description;
    if (value != null) {
      result
        ..add('description')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.groupId;
    if (value != null) {
      result
        ..add('groupId')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  TicketType deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new TicketTypeBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'object':
          result.object = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'accessCode':
          result.accessCode = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'bookingFee':
          result.bookingFee = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'description':
          result.description = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'groupId':
          result.groupId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'maxPerOrder':
          result.maxPerOrder = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'minPerOrder':
          result.minPerOrder = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'price':
          result.price = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'quantity':
          result.quantity = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'quantityHeld':
          result.quantityHeld = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'quantityIssued':
          result.quantityIssued = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'quantityTotal':
          result.quantityTotal = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'sortOrder':
          result.sortOrder = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'status':
          result.status = serializers.deserialize(value,
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

class _$TicketGroupSerializer implements StructuredSerializer<TicketGroup> {
  @override
  final Iterable<Type> types = const [TicketGroup, _$TicketGroup];
  @override
  final String wireName = 'TicketGroup';

  @override
  Iterable<Object?> serialize(Serializers serializers, TicketGroup object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'maxPerOrder',
      serializers.serialize(object.maxPerOrder,
          specifiedType: const FullType(int)),
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'sortOrder',
      serializers.serialize(object.sortOrder,
          specifiedType: const FullType(int)),
      'ticketIds',
      serializers.serialize(object.ticketIds,
          specifiedType:
              const FullType(BuiltList, const [const FullType(String)])),
    ];

    return result;
  }

  @override
  TicketGroup deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new TicketGroupBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'maxPerOrder':
          result.maxPerOrder = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'sortOrder':
          result.sortOrder = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'ticketIds':
          result.ticketIds.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(String)]))!
              as BuiltList<Object?>);
          break;
      }
    }

    return result.build();
  }
}

class _$VenueSerializer implements StructuredSerializer<Venue> {
  @override
  final Iterable<Type> types = const [Venue, _$Venue];
  @override
  final String wireName = 'Venue';

  @override
  Iterable<Object?> serialize(Serializers serializers, Venue object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[];
    Object? value;
    value = object.name;
    if (value != null) {
      result
        ..add('name')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.postalCode;
    if (value != null) {
      result
        ..add('postalCode')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  Venue deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new VenueBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'postalCode':
          result.postalCode = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
      }
    }

    return result.build();
  }
}

class _$ImagesSerializer implements StructuredSerializer<Images> {
  @override
  final Iterable<Type> types = const [Images, _$Images];
  @override
  final String wireName = 'Images';

  @override
  Iterable<Object?> serialize(Serializers serializers, Images object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'header',
      serializers.serialize(object.header,
          specifiedType: const FullType(String)),
      'thumbnail',
      serializers.serialize(object.thumbnail,
          specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  Images deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ImagesBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'header':
          result.header = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'thumbnail':
          result.thumbnail = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$OrderEntitySerializer implements StructuredSerializer<OrderEntity> {
  @override
  final Iterable<Type> types = const [OrderEntity, _$OrderEntity];
  @override
  final String wireName = 'OrderEntity';

  @override
  Iterable<Object?> serialize(Serializers serializers, OrderEntity object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'status',
      serializers.serialize(object.status,
          specifiedType: const FullType(String)),
      'createdAt',
      serializers.serialize(object.createdAt,
          specifiedType: const FullType(int)),
      'total',
      serializers.serialize(object.total, specifiedType: const FullType(int)),
      'currency',
      serializers.serialize(object.currency,
          specifiedType: const FullType(String)),
      'buyerDetails',
      serializers.serialize(object.buyerDetails,
          specifiedType: const FullType(BuyerDetails)),
      'issuedTickets',
      serializers.serialize(object.issuedTickets,
          specifiedType:
              const FullType(BuiltList, const [const FullType(IssuedTicket)])),
      'lineItems',
      serializers.serialize(object.lineItems,
          specifiedType:
              const FullType(BuiltList, const [const FullType(LineItem)])),
    ];

    return result;
  }

  @override
  OrderEntity deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new OrderEntityBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'status':
          result.status = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'createdAt':
          result.createdAt = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'total':
          result.total = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'currency':
          result.currency = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'buyerDetails':
          result.buyerDetails.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuyerDetails))! as BuyerDetails);
          break;
        case 'issuedTickets':
          result.issuedTickets.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(IssuedTicket)]))!
              as BuiltList<Object?>);
          break;
        case 'lineItems':
          result.lineItems.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(LineItem)]))!
              as BuiltList<Object?>);
          break;
      }
    }

    return result.build();
  }
}

class _$BuyerDetailsSerializer implements StructuredSerializer<BuyerDetails> {
  @override
  final Iterable<Type> types = const [BuyerDetails, _$BuyerDetails];
  @override
  final String wireName = 'BuyerDetails';

  @override
  Iterable<Object?> serialize(Serializers serializers, BuyerDetails object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'email',
      serializers.serialize(object.email,
          specifiedType: const FullType(String)),
      'firstName',
      serializers.serialize(object.firstName,
          specifiedType: const FullType(String)),
      'lastName',
      serializers.serialize(object.lastName,
          specifiedType: const FullType(String)),
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'phone',
      serializers.serialize(object.phone,
          specifiedType: const FullType(String)),
    ];
    Object? value;
    value = object.attendeeStatus;
    if (value != null) {
      result
        ..add('attendeeStatus')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.rspv;
    if (value != null) {
      result
        ..add('rspv')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  BuyerDetails deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new BuyerDetailsBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'email':
          result.email = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'firstName':
          result.firstName = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'lastName':
          result.lastName = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'phone':
          result.phone = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'attendeeStatus':
          result.attendeeStatus = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'rspv':
          result.rspv = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
      }
    }

    return result.build();
  }
}

class _$IssuedTicketSerializer implements StructuredSerializer<IssuedTicket> {
  @override
  final Iterable<Type> types = const [IssuedTicket, _$IssuedTicket];
  @override
  final String wireName = 'IssuedTicket';

  @override
  Iterable<Object?> serialize(Serializers serializers, IssuedTicket object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'barcode',
      serializers.serialize(object.barcode,
          specifiedType: const FullType(String)),
      'qrCodeUrl',
      serializers.serialize(object.qrCodeUrl,
          specifiedType: const FullType(String)),
      'status',
      serializers.serialize(object.status,
          specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  IssuedTicket deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new IssuedTicketBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'barcode':
          result.barcode = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'qrCodeUrl':
          result.qrCodeUrl = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'status':
          result.status = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$LineItemSerializer implements StructuredSerializer<LineItem> {
  @override
  final Iterable<Type> types = const [LineItem, _$LineItem];
  @override
  final String wireName = 'LineItem';

  @override
  Iterable<Object?> serialize(Serializers serializers, LineItem object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'description',
      serializers.serialize(object.description,
          specifiedType: const FullType(String)),
      'quantity',
      serializers.serialize(object.quantity,
          specifiedType: const FullType(int)),
      'total',
      serializers.serialize(object.total, specifiedType: const FullType(int)),
      'type',
      serializers.serialize(object.type, specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  LineItem deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new LineItemBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'description':
          result.description = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'quantity':
          result.quantity = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'total':
          result.total = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
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

class _$TicketType extends TicketType {
  @override
  final String id;
  @override
  final String object;
  @override
  final String? accessCode;
  @override
  final int bookingFee;
  @override
  final String? description;
  @override
  final String? groupId;
  @override
  final int maxPerOrder;
  @override
  final String minPerOrder;
  @override
  final String name;
  @override
  final int price;
  @override
  final int quantity;
  @override
  final int quantityHeld;
  @override
  final int quantityIssued;
  @override
  final int quantityTotal;
  @override
  final int sortOrder;
  @override
  final String status;
  @override
  final String type;

  factory _$TicketType([void Function(TicketTypeBuilder)? updates]) =>
      (new TicketTypeBuilder()..update(updates))._build();

  _$TicketType._(
      {required this.id,
      required this.object,
      this.accessCode,
      required this.bookingFee,
      this.description,
      this.groupId,
      required this.maxPerOrder,
      required this.minPerOrder,
      required this.name,
      required this.price,
      required this.quantity,
      required this.quantityHeld,
      required this.quantityIssued,
      required this.quantityTotal,
      required this.sortOrder,
      required this.status,
      required this.type})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(id, r'TicketType', 'id');
    BuiltValueNullFieldError.checkNotNull(object, r'TicketType', 'object');
    BuiltValueNullFieldError.checkNotNull(
        bookingFee, r'TicketType', 'bookingFee');
    BuiltValueNullFieldError.checkNotNull(
        maxPerOrder, r'TicketType', 'maxPerOrder');
    BuiltValueNullFieldError.checkNotNull(
        minPerOrder, r'TicketType', 'minPerOrder');
    BuiltValueNullFieldError.checkNotNull(name, r'TicketType', 'name');
    BuiltValueNullFieldError.checkNotNull(price, r'TicketType', 'price');
    BuiltValueNullFieldError.checkNotNull(quantity, r'TicketType', 'quantity');
    BuiltValueNullFieldError.checkNotNull(
        quantityHeld, r'TicketType', 'quantityHeld');
    BuiltValueNullFieldError.checkNotNull(
        quantityIssued, r'TicketType', 'quantityIssued');
    BuiltValueNullFieldError.checkNotNull(
        quantityTotal, r'TicketType', 'quantityTotal');
    BuiltValueNullFieldError.checkNotNull(
        sortOrder, r'TicketType', 'sortOrder');
    BuiltValueNullFieldError.checkNotNull(status, r'TicketType', 'status');
    BuiltValueNullFieldError.checkNotNull(type, r'TicketType', 'type');
  }

  @override
  TicketType rebuild(void Function(TicketTypeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TicketTypeBuilder toBuilder() => new TicketTypeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TicketType &&
        id == other.id &&
        object == other.object &&
        accessCode == other.accessCode &&
        bookingFee == other.bookingFee &&
        description == other.description &&
        groupId == other.groupId &&
        maxPerOrder == other.maxPerOrder &&
        minPerOrder == other.minPerOrder &&
        name == other.name &&
        price == other.price &&
        quantity == other.quantity &&
        quantityHeld == other.quantityHeld &&
        quantityIssued == other.quantityIssued &&
        quantityTotal == other.quantityTotal &&
        sortOrder == other.sortOrder &&
        status == other.status &&
        type == other.type;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, object.hashCode);
    _$hash = $jc(_$hash, accessCode.hashCode);
    _$hash = $jc(_$hash, bookingFee.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, groupId.hashCode);
    _$hash = $jc(_$hash, maxPerOrder.hashCode);
    _$hash = $jc(_$hash, minPerOrder.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, price.hashCode);
    _$hash = $jc(_$hash, quantity.hashCode);
    _$hash = $jc(_$hash, quantityHeld.hashCode);
    _$hash = $jc(_$hash, quantityIssued.hashCode);
    _$hash = $jc(_$hash, quantityTotal.hashCode);
    _$hash = $jc(_$hash, sortOrder.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TicketType')
          ..add('id', id)
          ..add('object', object)
          ..add('accessCode', accessCode)
          ..add('bookingFee', bookingFee)
          ..add('description', description)
          ..add('groupId', groupId)
          ..add('maxPerOrder', maxPerOrder)
          ..add('minPerOrder', minPerOrder)
          ..add('name', name)
          ..add('price', price)
          ..add('quantity', quantity)
          ..add('quantityHeld', quantityHeld)
          ..add('quantityIssued', quantityIssued)
          ..add('quantityTotal', quantityTotal)
          ..add('sortOrder', sortOrder)
          ..add('status', status)
          ..add('type', type))
        .toString();
  }
}

class TicketTypeBuilder implements Builder<TicketType, TicketTypeBuilder> {
  _$TicketType? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _object;
  String? get object => _$this._object;
  set object(String? object) => _$this._object = object;

  String? _accessCode;
  String? get accessCode => _$this._accessCode;
  set accessCode(String? accessCode) => _$this._accessCode = accessCode;

  int? _bookingFee;
  int? get bookingFee => _$this._bookingFee;
  set bookingFee(int? bookingFee) => _$this._bookingFee = bookingFee;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _groupId;
  String? get groupId => _$this._groupId;
  set groupId(String? groupId) => _$this._groupId = groupId;

  int? _maxPerOrder;
  int? get maxPerOrder => _$this._maxPerOrder;
  set maxPerOrder(int? maxPerOrder) => _$this._maxPerOrder = maxPerOrder;

  String? _minPerOrder;
  String? get minPerOrder => _$this._minPerOrder;
  set minPerOrder(String? minPerOrder) => _$this._minPerOrder = minPerOrder;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _price;
  int? get price => _$this._price;
  set price(int? price) => _$this._price = price;

  int? _quantity;
  int? get quantity => _$this._quantity;
  set quantity(int? quantity) => _$this._quantity = quantity;

  int? _quantityHeld;
  int? get quantityHeld => _$this._quantityHeld;
  set quantityHeld(int? quantityHeld) => _$this._quantityHeld = quantityHeld;

  int? _quantityIssued;
  int? get quantityIssued => _$this._quantityIssued;
  set quantityIssued(int? quantityIssued) =>
      _$this._quantityIssued = quantityIssued;

  int? _quantityTotal;
  int? get quantityTotal => _$this._quantityTotal;
  set quantityTotal(int? quantityTotal) =>
      _$this._quantityTotal = quantityTotal;

  int? _sortOrder;
  int? get sortOrder => _$this._sortOrder;
  set sortOrder(int? sortOrder) => _$this._sortOrder = sortOrder;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  TicketTypeBuilder();

  TicketTypeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _object = $v.object;
      _accessCode = $v.accessCode;
      _bookingFee = $v.bookingFee;
      _description = $v.description;
      _groupId = $v.groupId;
      _maxPerOrder = $v.maxPerOrder;
      _minPerOrder = $v.minPerOrder;
      _name = $v.name;
      _price = $v.price;
      _quantity = $v.quantity;
      _quantityHeld = $v.quantityHeld;
      _quantityIssued = $v.quantityIssued;
      _quantityTotal = $v.quantityTotal;
      _sortOrder = $v.sortOrder;
      _status = $v.status;
      _type = $v.type;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TicketType other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$TicketType;
  }

  @override
  void update(void Function(TicketTypeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TicketType build() => _build();

  _$TicketType _build() {
    final _$result = _$v ??
        new _$TicketType._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'TicketType', 'id'),
            object: BuiltValueNullFieldError.checkNotNull(
                object, r'TicketType', 'object'),
            accessCode: accessCode,
            bookingFee: BuiltValueNullFieldError.checkNotNull(
                bookingFee, r'TicketType', 'bookingFee'),
            description: description,
            groupId: groupId,
            maxPerOrder: BuiltValueNullFieldError.checkNotNull(
                maxPerOrder, r'TicketType', 'maxPerOrder'),
            minPerOrder: BuiltValueNullFieldError.checkNotNull(
                minPerOrder, r'TicketType', 'minPerOrder'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'TicketType', 'name'),
            price: BuiltValueNullFieldError.checkNotNull(
                price, r'TicketType', 'price'),
            quantity: BuiltValueNullFieldError.checkNotNull(
                quantity, r'TicketType', 'quantity'),
            quantityHeld: BuiltValueNullFieldError.checkNotNull(
                quantityHeld, r'TicketType', 'quantityHeld'),
            quantityIssued: BuiltValueNullFieldError.checkNotNull(
                quantityIssued, r'TicketType', 'quantityIssued'),
            quantityTotal: BuiltValueNullFieldError.checkNotNull(
                quantityTotal, r'TicketType', 'quantityTotal'),
            sortOrder:
                BuiltValueNullFieldError.checkNotNull(sortOrder, r'TicketType', 'sortOrder'),
            status: BuiltValueNullFieldError.checkNotNull(status, r'TicketType', 'status'),
            type: BuiltValueNullFieldError.checkNotNull(type, r'TicketType', 'type'));
    replace(_$result);
    return _$result;
  }
}

class _$TicketGroup extends TicketGroup {
  @override
  final String id;
  @override
  final int maxPerOrder;
  @override
  final String name;
  @override
  final int sortOrder;
  @override
  final BuiltList<String> ticketIds;

  factory _$TicketGroup([void Function(TicketGroupBuilder)? updates]) =>
      (new TicketGroupBuilder()..update(updates))._build();

  _$TicketGroup._(
      {required this.id,
      required this.maxPerOrder,
      required this.name,
      required this.sortOrder,
      required this.ticketIds})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(id, r'TicketGroup', 'id');
    BuiltValueNullFieldError.checkNotNull(
        maxPerOrder, r'TicketGroup', 'maxPerOrder');
    BuiltValueNullFieldError.checkNotNull(name, r'TicketGroup', 'name');
    BuiltValueNullFieldError.checkNotNull(
        sortOrder, r'TicketGroup', 'sortOrder');
    BuiltValueNullFieldError.checkNotNull(
        ticketIds, r'TicketGroup', 'ticketIds');
  }

  @override
  TicketGroup rebuild(void Function(TicketGroupBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TicketGroupBuilder toBuilder() => new TicketGroupBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TicketGroup &&
        id == other.id &&
        maxPerOrder == other.maxPerOrder &&
        name == other.name &&
        sortOrder == other.sortOrder &&
        ticketIds == other.ticketIds;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, maxPerOrder.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, sortOrder.hashCode);
    _$hash = $jc(_$hash, ticketIds.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TicketGroup')
          ..add('id', id)
          ..add('maxPerOrder', maxPerOrder)
          ..add('name', name)
          ..add('sortOrder', sortOrder)
          ..add('ticketIds', ticketIds))
        .toString();
  }
}

class TicketGroupBuilder implements Builder<TicketGroup, TicketGroupBuilder> {
  _$TicketGroup? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  int? _maxPerOrder;
  int? get maxPerOrder => _$this._maxPerOrder;
  set maxPerOrder(int? maxPerOrder) => _$this._maxPerOrder = maxPerOrder;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _sortOrder;
  int? get sortOrder => _$this._sortOrder;
  set sortOrder(int? sortOrder) => _$this._sortOrder = sortOrder;

  ListBuilder<String>? _ticketIds;
  ListBuilder<String> get ticketIds =>
      _$this._ticketIds ??= new ListBuilder<String>();
  set ticketIds(ListBuilder<String>? ticketIds) =>
      _$this._ticketIds = ticketIds;

  TicketGroupBuilder();

  TicketGroupBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _maxPerOrder = $v.maxPerOrder;
      _name = $v.name;
      _sortOrder = $v.sortOrder;
      _ticketIds = $v.ticketIds.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TicketGroup other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$TicketGroup;
  }

  @override
  void update(void Function(TicketGroupBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TicketGroup build() => _build();

  _$TicketGroup _build() {
    _$TicketGroup _$result;
    try {
      _$result = _$v ??
          new _$TicketGroup._(
              id: BuiltValueNullFieldError.checkNotNull(
                  id, r'TicketGroup', 'id'),
              maxPerOrder: BuiltValueNullFieldError.checkNotNull(
                  maxPerOrder, r'TicketGroup', 'maxPerOrder'),
              name: BuiltValueNullFieldError.checkNotNull(
                  name, r'TicketGroup', 'name'),
              sortOrder: BuiltValueNullFieldError.checkNotNull(
                  sortOrder, r'TicketGroup', 'sortOrder'),
              ticketIds: ticketIds.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'ticketIds';
        ticketIds.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'TicketGroup', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$Venue extends Venue {
  @override
  final String? name;
  @override
  final String? postalCode;

  factory _$Venue([void Function(VenueBuilder)? updates]) =>
      (new VenueBuilder()..update(updates))._build();

  _$Venue._({this.name, this.postalCode}) : super._();

  @override
  Venue rebuild(void Function(VenueBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VenueBuilder toBuilder() => new VenueBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Venue &&
        name == other.name &&
        postalCode == other.postalCode;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, postalCode.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Venue')
          ..add('name', name)
          ..add('postalCode', postalCode))
        .toString();
  }
}

class VenueBuilder implements Builder<Venue, VenueBuilder> {
  _$Venue? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _postalCode;
  String? get postalCode => _$this._postalCode;
  set postalCode(String? postalCode) => _$this._postalCode = postalCode;

  VenueBuilder();

  VenueBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _postalCode = $v.postalCode;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Venue other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Venue;
  }

  @override
  void update(void Function(VenueBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Venue build() => _build();

  _$Venue _build() {
    final _$result = _$v ?? new _$Venue._(name: name, postalCode: postalCode);
    replace(_$result);
    return _$result;
  }
}

class _$Images extends Images {
  @override
  final String header;
  @override
  final String thumbnail;

  factory _$Images([void Function(ImagesBuilder)? updates]) =>
      (new ImagesBuilder()..update(updates))._build();

  _$Images._({required this.header, required this.thumbnail}) : super._() {
    BuiltValueNullFieldError.checkNotNull(header, r'Images', 'header');
    BuiltValueNullFieldError.checkNotNull(thumbnail, r'Images', 'thumbnail');
  }

  @override
  Images rebuild(void Function(ImagesBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ImagesBuilder toBuilder() => new ImagesBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Images &&
        header == other.header &&
        thumbnail == other.thumbnail;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, header.hashCode);
    _$hash = $jc(_$hash, thumbnail.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Images')
          ..add('header', header)
          ..add('thumbnail', thumbnail))
        .toString();
  }
}

class ImagesBuilder implements Builder<Images, ImagesBuilder> {
  _$Images? _$v;

  String? _header;
  String? get header => _$this._header;
  set header(String? header) => _$this._header = header;

  String? _thumbnail;
  String? get thumbnail => _$this._thumbnail;
  set thumbnail(String? thumbnail) => _$this._thumbnail = thumbnail;

  ImagesBuilder();

  ImagesBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _header = $v.header;
      _thumbnail = $v.thumbnail;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Images other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Images;
  }

  @override
  void update(void Function(ImagesBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Images build() => _build();

  _$Images _build() {
    final _$result = _$v ??
        new _$Images._(
            header: BuiltValueNullFieldError.checkNotNull(
                header, r'Images', 'header'),
            thumbnail: BuiltValueNullFieldError.checkNotNull(
                thumbnail, r'Images', 'thumbnail'));
    replace(_$result);
    return _$result;
  }
}

class _$OrderEntity extends OrderEntity {
  @override
  final String id;
  @override
  final String status;
  @override
  final int createdAt;
  @override
  final int total;
  @override
  final String currency;
  @override
  final BuyerDetails buyerDetails;
  @override
  final BuiltList<IssuedTicket> issuedTickets;
  @override
  final BuiltList<LineItem> lineItems;

  factory _$OrderEntity([void Function(OrderEntityBuilder)? updates]) =>
      (new OrderEntityBuilder()..update(updates))._build();

  _$OrderEntity._(
      {required this.id,
      required this.status,
      required this.createdAt,
      required this.total,
      required this.currency,
      required this.buyerDetails,
      required this.issuedTickets,
      required this.lineItems})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(id, r'OrderEntity', 'id');
    BuiltValueNullFieldError.checkNotNull(status, r'OrderEntity', 'status');
    BuiltValueNullFieldError.checkNotNull(
        createdAt, r'OrderEntity', 'createdAt');
    BuiltValueNullFieldError.checkNotNull(total, r'OrderEntity', 'total');
    BuiltValueNullFieldError.checkNotNull(currency, r'OrderEntity', 'currency');
    BuiltValueNullFieldError.checkNotNull(
        buyerDetails, r'OrderEntity', 'buyerDetails');
    BuiltValueNullFieldError.checkNotNull(
        issuedTickets, r'OrderEntity', 'issuedTickets');
    BuiltValueNullFieldError.checkNotNull(
        lineItems, r'OrderEntity', 'lineItems');
  }

  @override
  OrderEntity rebuild(void Function(OrderEntityBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OrderEntityBuilder toBuilder() => new OrderEntityBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OrderEntity &&
        id == other.id &&
        status == other.status &&
        createdAt == other.createdAt &&
        total == other.total &&
        currency == other.currency &&
        buyerDetails == other.buyerDetails &&
        issuedTickets == other.issuedTickets &&
        lineItems == other.lineItems;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, buyerDetails.hashCode);
    _$hash = $jc(_$hash, issuedTickets.hashCode);
    _$hash = $jc(_$hash, lineItems.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OrderEntity')
          ..add('id', id)
          ..add('status', status)
          ..add('createdAt', createdAt)
          ..add('total', total)
          ..add('currency', currency)
          ..add('buyerDetails', buyerDetails)
          ..add('issuedTickets', issuedTickets)
          ..add('lineItems', lineItems))
        .toString();
  }
}

class OrderEntityBuilder implements Builder<OrderEntity, OrderEntityBuilder> {
  _$OrderEntity? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  int? _createdAt;
  int? get createdAt => _$this._createdAt;
  set createdAt(int? createdAt) => _$this._createdAt = createdAt;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  BuyerDetailsBuilder? _buyerDetails;
  BuyerDetailsBuilder get buyerDetails =>
      _$this._buyerDetails ??= new BuyerDetailsBuilder();
  set buyerDetails(BuyerDetailsBuilder? buyerDetails) =>
      _$this._buyerDetails = buyerDetails;

  ListBuilder<IssuedTicket>? _issuedTickets;
  ListBuilder<IssuedTicket> get issuedTickets =>
      _$this._issuedTickets ??= new ListBuilder<IssuedTicket>();
  set issuedTickets(ListBuilder<IssuedTicket>? issuedTickets) =>
      _$this._issuedTickets = issuedTickets;

  ListBuilder<LineItem>? _lineItems;
  ListBuilder<LineItem> get lineItems =>
      _$this._lineItems ??= new ListBuilder<LineItem>();
  set lineItems(ListBuilder<LineItem>? lineItems) =>
      _$this._lineItems = lineItems;

  OrderEntityBuilder();

  OrderEntityBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _status = $v.status;
      _createdAt = $v.createdAt;
      _total = $v.total;
      _currency = $v.currency;
      _buyerDetails = $v.buyerDetails.toBuilder();
      _issuedTickets = $v.issuedTickets.toBuilder();
      _lineItems = $v.lineItems.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OrderEntity other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$OrderEntity;
  }

  @override
  void update(void Function(OrderEntityBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OrderEntity build() => _build();

  _$OrderEntity _build() {
    _$OrderEntity _$result;
    try {
      _$result = _$v ??
          new _$OrderEntity._(
              id: BuiltValueNullFieldError.checkNotNull(
                  id, r'OrderEntity', 'id'),
              status: BuiltValueNullFieldError.checkNotNull(
                  status, r'OrderEntity', 'status'),
              createdAt: BuiltValueNullFieldError.checkNotNull(
                  createdAt, r'OrderEntity', 'createdAt'),
              total: BuiltValueNullFieldError.checkNotNull(
                  total, r'OrderEntity', 'total'),
              currency: BuiltValueNullFieldError.checkNotNull(
                  currency, r'OrderEntity', 'currency'),
              buyerDetails: buyerDetails.build(),
              issuedTickets: issuedTickets.build(),
              lineItems: lineItems.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'buyerDetails';
        buyerDetails.build();
        _$failedField = 'issuedTickets';
        issuedTickets.build();
        _$failedField = 'lineItems';
        lineItems.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'OrderEntity', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$BuyerDetails extends BuyerDetails {
  @override
  final String email;
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final String name;
  @override
  final String phone;
  @override
  final String? attendeeStatus;
  @override
  final String? rspv;

  factory _$BuyerDetails([void Function(BuyerDetailsBuilder)? updates]) =>
      (new BuyerDetailsBuilder()..update(updates))._build();

  _$BuyerDetails._(
      {required this.email,
      required this.firstName,
      required this.lastName,
      required this.name,
      required this.phone,
      this.attendeeStatus,
      this.rspv})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(email, r'BuyerDetails', 'email');
    BuiltValueNullFieldError.checkNotNull(
        firstName, r'BuyerDetails', 'firstName');
    BuiltValueNullFieldError.checkNotNull(
        lastName, r'BuyerDetails', 'lastName');
    BuiltValueNullFieldError.checkNotNull(name, r'BuyerDetails', 'name');
    BuiltValueNullFieldError.checkNotNull(phone, r'BuyerDetails', 'phone');
  }

  @override
  BuyerDetails rebuild(void Function(BuyerDetailsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuyerDetailsBuilder toBuilder() => new BuyerDetailsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuyerDetails &&
        email == other.email &&
        firstName == other.firstName &&
        lastName == other.lastName &&
        name == other.name &&
        phone == other.phone &&
        attendeeStatus == other.attendeeStatus &&
        rspv == other.rspv;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, firstName.hashCode);
    _$hash = $jc(_$hash, lastName.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jc(_$hash, attendeeStatus.hashCode);
    _$hash = $jc(_$hash, rspv.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BuyerDetails')
          ..add('email', email)
          ..add('firstName', firstName)
          ..add('lastName', lastName)
          ..add('name', name)
          ..add('phone', phone)
          ..add('attendeeStatus', attendeeStatus)
          ..add('rspv', rspv))
        .toString();
  }
}

class BuyerDetailsBuilder
    implements Builder<BuyerDetails, BuyerDetailsBuilder> {
  _$BuyerDetails? _$v;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _firstName;
  String? get firstName => _$this._firstName;
  set firstName(String? firstName) => _$this._firstName = firstName;

  String? _lastName;
  String? get lastName => _$this._lastName;
  set lastName(String? lastName) => _$this._lastName = lastName;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  String? _attendeeStatus;
  String? get attendeeStatus => _$this._attendeeStatus;
  set attendeeStatus(String? attendeeStatus) =>
      _$this._attendeeStatus = attendeeStatus;

  String? _rspv;
  String? get rspv => _$this._rspv;
  set rspv(String? rspv) => _$this._rspv = rspv;

  BuyerDetailsBuilder();

  BuyerDetailsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _email = $v.email;
      _firstName = $v.firstName;
      _lastName = $v.lastName;
      _name = $v.name;
      _phone = $v.phone;
      _attendeeStatus = $v.attendeeStatus;
      _rspv = $v.rspv;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuyerDetails other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$BuyerDetails;
  }

  @override
  void update(void Function(BuyerDetailsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BuyerDetails build() => _build();

  _$BuyerDetails _build() {
    final _$result = _$v ??
        new _$BuyerDetails._(
            email: BuiltValueNullFieldError.checkNotNull(
                email, r'BuyerDetails', 'email'),
            firstName: BuiltValueNullFieldError.checkNotNull(
                firstName, r'BuyerDetails', 'firstName'),
            lastName: BuiltValueNullFieldError.checkNotNull(
                lastName, r'BuyerDetails', 'lastName'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'BuyerDetails', 'name'),
            phone: BuiltValueNullFieldError.checkNotNull(
                phone, r'BuyerDetails', 'phone'),
            attendeeStatus: attendeeStatus,
            rspv: rspv);
    replace(_$result);
    return _$result;
  }
}

class _$IssuedTicket extends IssuedTicket {
  @override
  final String id;
  @override
  final String barcode;
  @override
  final String qrCodeUrl;
  @override
  final String status;

  factory _$IssuedTicket([void Function(IssuedTicketBuilder)? updates]) =>
      (new IssuedTicketBuilder()..update(updates))._build();

  _$IssuedTicket._(
      {required this.id,
      required this.barcode,
      required this.qrCodeUrl,
      required this.status})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(id, r'IssuedTicket', 'id');
    BuiltValueNullFieldError.checkNotNull(barcode, r'IssuedTicket', 'barcode');
    BuiltValueNullFieldError.checkNotNull(
        qrCodeUrl, r'IssuedTicket', 'qrCodeUrl');
    BuiltValueNullFieldError.checkNotNull(status, r'IssuedTicket', 'status');
  }

  @override
  IssuedTicket rebuild(void Function(IssuedTicketBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  IssuedTicketBuilder toBuilder() => new IssuedTicketBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is IssuedTicket &&
        id == other.id &&
        barcode == other.barcode &&
        qrCodeUrl == other.qrCodeUrl &&
        status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, barcode.hashCode);
    _$hash = $jc(_$hash, qrCodeUrl.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'IssuedTicket')
          ..add('id', id)
          ..add('barcode', barcode)
          ..add('qrCodeUrl', qrCodeUrl)
          ..add('status', status))
        .toString();
  }
}

class IssuedTicketBuilder
    implements Builder<IssuedTicket, IssuedTicketBuilder> {
  _$IssuedTicket? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _barcode;
  String? get barcode => _$this._barcode;
  set barcode(String? barcode) => _$this._barcode = barcode;

  String? _qrCodeUrl;
  String? get qrCodeUrl => _$this._qrCodeUrl;
  set qrCodeUrl(String? qrCodeUrl) => _$this._qrCodeUrl = qrCodeUrl;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  IssuedTicketBuilder();

  IssuedTicketBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _barcode = $v.barcode;
      _qrCodeUrl = $v.qrCodeUrl;
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(IssuedTicket other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$IssuedTicket;
  }

  @override
  void update(void Function(IssuedTicketBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  IssuedTicket build() => _build();

  _$IssuedTicket _build() {
    final _$result = _$v ??
        new _$IssuedTicket._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'IssuedTicket', 'id'),
            barcode: BuiltValueNullFieldError.checkNotNull(
                barcode, r'IssuedTicket', 'barcode'),
            qrCodeUrl: BuiltValueNullFieldError.checkNotNull(
                qrCodeUrl, r'IssuedTicket', 'qrCodeUrl'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'IssuedTicket', 'status'));
    replace(_$result);
    return _$result;
  }
}

class _$LineItem extends LineItem {
  @override
  final String id;
  @override
  final String description;
  @override
  final int quantity;
  @override
  final int total;
  @override
  final String type;

  factory _$LineItem([void Function(LineItemBuilder)? updates]) =>
      (new LineItemBuilder()..update(updates))._build();

  _$LineItem._(
      {required this.id,
      required this.description,
      required this.quantity,
      required this.total,
      required this.type})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(id, r'LineItem', 'id');
    BuiltValueNullFieldError.checkNotNull(
        description, r'LineItem', 'description');
    BuiltValueNullFieldError.checkNotNull(quantity, r'LineItem', 'quantity');
    BuiltValueNullFieldError.checkNotNull(total, r'LineItem', 'total');
    BuiltValueNullFieldError.checkNotNull(type, r'LineItem', 'type');
  }

  @override
  LineItem rebuild(void Function(LineItemBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LineItemBuilder toBuilder() => new LineItemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LineItem &&
        id == other.id &&
        description == other.description &&
        quantity == other.quantity &&
        total == other.total &&
        type == other.type;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, quantity.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LineItem')
          ..add('id', id)
          ..add('description', description)
          ..add('quantity', quantity)
          ..add('total', total)
          ..add('type', type))
        .toString();
  }
}

class LineItemBuilder implements Builder<LineItem, LineItemBuilder> {
  _$LineItem? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  int? _quantity;
  int? get quantity => _$this._quantity;
  set quantity(int? quantity) => _$this._quantity = quantity;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  LineItemBuilder();

  LineItemBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _description = $v.description;
      _quantity = $v.quantity;
      _total = $v.total;
      _type = $v.type;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LineItem other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$LineItem;
  }

  @override
  void update(void Function(LineItemBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LineItem build() => _build();

  _$LineItem _build() {
    final _$result = _$v ??
        new _$LineItem._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'LineItem', 'id'),
            description: BuiltValueNullFieldError.checkNotNull(
                description, r'LineItem', 'description'),
            quantity: BuiltValueNullFieldError.checkNotNull(
                quantity, r'LineItem', 'quantity'),
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'LineItem', 'total'),
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'LineItem', 'type'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
