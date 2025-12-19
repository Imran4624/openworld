import 'dart:async';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_boilerplate/redux/ui/entity_ui_state.dart';
import 'package:flutter_boilerplate/redux/ui/list_ui_state.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/ui/pref_state.dart';
import 'package:flutter_boilerplate/data/models/payment_provider_models.dart';

part 'payment_state.g.dart';

abstract class PaymentState
    implements Built<PaymentState, PaymentStateBuilder> {
  factory PaymentState() {
    return _$PaymentState._(
      map: BuiltMap<String, PaymentEntity>(),
      list: BuiltList<String>(),
      lastDocument: null,
      filter: PaymentFilter(),
      isProcessingPayment: false,
      processingMessage: '',
      lastPaymentResult: null,
      lastPaymentIntent: null,
      lastPaymentError: '',
    );
  }
  PaymentState._();

  @override
  @memoized
  int get hashCode;

  BuiltMap<String, PaymentEntity> get map;
  BuiltList<String> get list;

  DocumentSnapshot? get lastDocument;
  PaymentFilter get filter;

  bool get isProcessingPayment;
  String get processingMessage;
  Payment? get lastPaymentResult;
  PaymentIntent? get lastPaymentIntent;
  String get lastPaymentError;

  PaymentEntity get(String paymentId) {
    return map[paymentId] ?? PaymentEntity(id: paymentId);
  }

  PaymentState loadPayments(BuiltList<PaymentEntity> clients) {
    final map = Map<String, PaymentEntity>.fromIterable(
      clients,
      key: (dynamic item) => item.id,
      value: (dynamic item) => item,
    );

    return rebuild((b) => b
      ..map.addAll(map)
      ..list.replace((map.keys.toList() + list.toList()).toSet().toList()));
  }

  static Serializer<PaymentState> get serializer => _$paymentStateSerializer;
}

abstract class PaymentUIState extends Object
    with EntityUIState
    implements Built<PaymentUIState, PaymentUIStateBuilder> {
  factory PaymentUIState(PrefStateSortField? sortField) {
    return _$PaymentUIState._(
      listUIState: ListUIState(
        // STARTER: primary field - do not remove comment
        sortField?.field ?? PaymentFields.id,
        sortAscending: sortField?.ascending,
      ),
      editing: PaymentEntity(),
      selectedId: '',
      tabIndex: 0,
    );
  }
  PaymentUIState._();

  @override
  @memoized
  int get hashCode;

  PaymentEntity? get editing;

  @override
  bool get isCreatingNew => editing?.isNew ?? false;

  @override
  String get editingId => editing?.id ?? '';

  static Serializer<PaymentUIState> get serializer =>
      _$paymentUIStateSerializer;
}
