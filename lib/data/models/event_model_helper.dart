import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter_boilerplate/data/models/entities.dart';

part 'event_model_helper.g.dart';

abstract class TicketType implements Built<TicketType, TicketTypeBuilder> {
  factory TicketType([void Function(TicketTypeBuilder) updates]) = _$TicketType;

  TicketType._();

  String get id;
  String get object;
  String? get accessCode;
  int get bookingFee;
  String? get description;
  String? get groupId;
  int get maxPerOrder;
  String get minPerOrder;
  String get name;
  int get price;
  int get quantity;
  int get quantityHeld;
  int get quantityIssued;
  int get quantityTotal;
  int get sortOrder;
  String get status;
  String get type;

  static Serializer<TicketType> get serializer => _$ticketTypeSerializer;
}

abstract class TicketGroup implements Built<TicketGroup, TicketGroupBuilder> {
  factory TicketGroup([void Function(TicketGroupBuilder) updates]) =
      _$TicketGroup;

  TicketGroup._();

  String get id;
  int get maxPerOrder;
  String get name;
  int get sortOrder;
  BuiltList<String> get ticketIds; // List of ticket IDs

  static Serializer<TicketGroup> get serializer => _$ticketGroupSerializer;
}

abstract class Venue implements Built<Venue, VenueBuilder> {
  factory Venue([void Function(VenueBuilder) updates]) = _$Venue;

  Venue._();

  String? get name;
  String? get postalCode;

  static Serializer<Venue> get serializer => _$venueSerializer;
}

abstract class Images implements Built<Images, ImagesBuilder> {
  factory Images([void Function(ImagesBuilder) updates]) = _$Images;

  Images._();

  String get header;
  String get thumbnail;

  static Serializer<Images> get serializer => _$imagesSerializer;
}

//order entities

abstract class OrderEntity implements Built<OrderEntity, OrderEntityBuilder> {
  factory OrderEntity([void Function(OrderEntityBuilder) updates]) =
      _$OrderEntity;
  OrderEntity._();

  String get id;
  String get status;
  int get createdAt;
  int get total;
  String get currency;
  BuyerDetails get buyerDetails;
  BuiltList<IssuedTicket> get issuedTickets;
  BuiltList<LineItem> get lineItems;

  static Serializer<OrderEntity> get serializer => _$orderEntitySerializer;
}

abstract class BuyerDetails
    implements Built<BuyerDetails, BuyerDetailsBuilder> {
  factory BuyerDetails([void Function(BuyerDetailsBuilder) updates]) =
      _$BuyerDetails;
  BuyerDetails._();

  String get email;
  String get firstName;
  String get lastName;
  String get name;
  String get phone;
  String? get attendeeStatus;
  String? get rspv;

  Map<String, dynamic> toJson() => {
        'email': email,
        'name': name,
        'firstName': firstName,
        'lastName': lastName,
        'attendee_status': attendeeStatus??'',
        'rspv': rspv??'',
      };

  static Serializer<BuyerDetails> get serializer => _$buyerDetailsSerializer;
}

abstract class IssuedTicket
    implements Built<IssuedTicket, IssuedTicketBuilder> {
  factory IssuedTicket({String? id}) {
    return _$IssuedTicket._(
      id: id ?? BaseEntity.nextId,
      barcode: '',
      qrCodeUrl: '',
      status: '',
    );
  }

  IssuedTicket._();

  String get id;
  String get barcode;
  String get qrCodeUrl;
  String get status;

  static Serializer<IssuedTicket> get serializer => _$issuedTicketSerializer;
}

abstract class LineItem implements Built<LineItem, LineItemBuilder> {
  factory LineItem({String? id}) {
    return _$LineItem._(
      id: id ?? BaseEntity.nextId,
      description: '',
      quantity: 0,
      total: 0,
      type: '',
    );
  }

  LineItem._();

  String get id;
  String get description;
  int get quantity;
  int get total;
  String get type;

  static Serializer<LineItem> get serializer => _$lineItemSerializer;
}
