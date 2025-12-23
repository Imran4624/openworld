import 'dart:async';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/utils/completers.dart';
import 'package:flutter_boilerplate/utils/localization.dart';
import 'package:flutter_boilerplate/ui/app/entities/entity_actions_dialog.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';

class ViewPaymentList implements PersistUI {
  ViewPaymentList({this.force = false, this.page = 0});

  final bool force;
  final int page;
}

class ViewPayment implements PersistUI, PersistPrefs {
  ViewPayment({
    this.paymentId,
    this.force = false,
  });

  final String? paymentId;
  final bool force;
}

class EditPayment implements PersistUI, PersistPrefs {
  EditPayment({
    required this.payment,
    this.completer,
    this.force = false,
  });

  final PaymentEntity payment;
  final Completer? completer;
  final bool force;
}

class UpdatePayment implements PersistUI {
  UpdatePayment(this.payment);

  final PaymentEntity payment;
}

class LoadPayment {
  LoadPayment({this.completer, this.paymentId});

  final Completer? completer;
  final String? paymentId;
}

class LoadPaymentActivity {
  LoadPaymentActivity({this.completer, this.paymentId});

  final Completer? completer;
  final String? paymentId;
}

class UpdateLastDocumentAction {
  UpdateLastDocumentAction(this.lastDocument);
  final DocumentSnapshot? lastDocument;
}

class LoadPaymentRequest implements StartLoading {}

class LoadPaymentFailure implements StopLoading {
  LoadPaymentFailure(this.error);

  final dynamic error;

  @override
  String toString() {
    return 'LoadPaymentFailure{error: $error}';
  }
}

class LoadPaymentSuccess implements StopLoading, PersistData {
  LoadPaymentSuccess(this.payment);

  final PaymentEntity payment;

  @override
  String toString() {
    return 'LoadPaymentSuccess{payment: $payment}';
  }
}

// class LoadPaymentsRequest implements StartLoading {}

class LoadPaymentsFailure implements StopLoading {
  LoadPaymentsFailure(this.error);

  final dynamic error;

  @override
  String toString() {
    return 'LoadPaymentsFailure{error: $error}';
  }
}

class LoadPaymentsSuccess implements StopLoading {
  LoadPaymentsSuccess(this.payments);

  final BuiltList<PaymentEntity> payments;

  @override
  String toString() {
    return 'LoadPaymentsSuccess{payments: $payments}';
  }
}

class SavePaymentRequest implements StartSaving {
  SavePaymentRequest({this.completer, this.payment});

  final Completer? completer;
  final PaymentEntity? payment;
}

class SavePaymentSuccess implements StopSaving, PersistData, PersistUI {
  SavePaymentSuccess(this.payment);

  final PaymentEntity payment;
}

class AddPaymentSuccess implements StopSaving, PersistData, PersistUI {
  AddPaymentSuccess(this.payment);

  final PaymentEntity payment;
}

class SavePaymentFailure implements StopSaving {
  SavePaymentFailure(this.error);

  final Object error;
}

class ArchivePaymentsRequest implements StartSaving {
  ArchivePaymentsRequest(this.completer, this.paymentIds);

  final Completer completer;
  final List<String> paymentIds;
}

class ArchivePaymentsSuccess implements StopSaving, PersistData {
  ArchivePaymentsSuccess(this.payments);

  final List<PaymentEntity> payments;
}

class ArchivePaymentsFailure implements StopSaving {
  ArchivePaymentsFailure(this.payments);

  final List<PaymentEntity> payments;
}

class DeletePaymentsRequest implements StartSaving {
  DeletePaymentsRequest(this.completer, this.paymentIds);

  final Completer completer;
  final List<String> paymentIds;
}

class PurgePaymentsRequest implements StartSaving {
  PurgePaymentsRequest(this.completer, this.paymentIds);

  final Completer completer;
  final List<String> paymentIds;
}

class DeletePaymentsSuccess implements StopSaving, PersistData {
  DeletePaymentsSuccess(this.payments);

  final List<PaymentEntity> payments;
}

class PurgePaymentsSuccess implements StopSaving, PersistData {
  PurgePaymentsSuccess(this.payments);

  final List<PaymentEntity> payments;
}

class DeletePaymentsFailure implements StopSaving {
  DeletePaymentsFailure(this.payments);

  final List<PaymentEntity> payments;
}

class PurgePaymentsFailure implements StopSaving {
  PurgePaymentsFailure(this.payments);

  final List<PaymentEntity> payments;
}

class RestorePaymentsRequest implements StartSaving {
  RestorePaymentsRequest(this.completer, this.paymentIds);

  final Completer completer;
  final List<String> paymentIds;
}

class RestorePaymentsSuccess implements StopSaving, PersistData {
  RestorePaymentsSuccess(this.payments);

  final List<PaymentEntity> payments;
}

class RestorePaymentsFailure implements StopSaving {
  RestorePaymentsFailure(this.payments);

  final List<PaymentEntity> payments;
}

class FilterPayments implements PersistUI {
  FilterPayments(this.filter);

  final String filter;
}

class SortPayments implements PersistUI, PersistPrefs {
  SortPayments(this.field);

  final String field;
}

class FilterPaymentsByState implements PersistUI {
  FilterPaymentsByState(this.state);

  final EntityState state;
}

// class FilterPaymentsByCustom1 implements PersistUI {
//   FilterPaymentsByCustom1(this.value);

//   final String value;
// }

// class FilterPaymentsByCustom2 implements PersistUI {
//   FilterPaymentsByCustom2(this.value);

//   final String value;
// }

// class FilterPaymentsByCustom3 implements PersistUI {
//   FilterPaymentsByCustom3(this.value);

//   final String value;
// }

// class FilterPaymentsByCustom4 implements PersistUI {
//   FilterPaymentsByCustom4(this.value);

//   final String value;
// }

class StartPaymentMultiselect {
  StartPaymentMultiselect();
}

class AddToPaymentMultiselect {
  AddToPaymentMultiselect({required this.entity});

  final BaseEntity entity;
}

class RemoveFromPaymentMultiselect {
  RemoveFromPaymentMultiselect({required this.entity});

  final BaseEntity entity;
}

class ClearPaymentMultiselect {
  ClearPaymentMultiselect();
}

class UpdatePaymentTab implements PersistUI {
  UpdatePaymentTab({this.tabIndex});

  final int? tabIndex;
}

class UpdatePaymentFilter implements PersistUI {
  UpdatePaymentFilter(this.filter);
  final PaymentFilter filter;
}

class LoadPayments {
  LoadPayments({
    this.completer,
    this.filter,
    this.page = 0,
    this.isRefresh = false,
  });

  final Completer? completer;
  final PaymentFilter? filter;
  final int page;
  final bool isRefresh;
}

class LoadPaymentsRequest implements StartLoading {
  LoadPaymentsRequest({this.filter});
  final PaymentFilter? filter;
}

void handlePaymentAction(
    BuildContext context, List<BaseEntity> payments, EntityAction action) {
  if (payments.isEmpty) {
    return;
  }

  final store = StoreProvider.of<AppState>(context);
  final localization = AppLocalization.of(context)!;
  final payment = payments.first as PaymentEntity;
  final paymentIds = payments.map((payment) => payment.id).toList();

  switch (action) {
    case EntityAction.edit:
      editEntity(entity: payment);
      break;
    case EntityAction.restore:
      store.dispatch(RestorePaymentsRequest(
          snackBarCompleter<Null>(localization.restoredPayment), paymentIds));
      break;
    case EntityAction.archive:
      store.dispatch(ArchivePaymentsRequest(
          snackBarCompleter<Null>(localization.archivedPayment), paymentIds));
      break;
    case EntityAction.delete:
      store.dispatch(DeletePaymentsRequest(
          snackBarCompleter<Null>(localization.deletedPayment), paymentIds));
      break;
    case EntityAction.purge:
      store.dispatch(PurgePaymentsRequest(
          snackBarCompleter<Null>(localization.deletedPayment), paymentIds));
      break;
    case EntityAction.toggleMultiselect:
      if (!store.state.paymentListState.isInMultiselect()) {
        store.dispatch(StartPaymentMultiselect());
      }

      if (payments.isEmpty) {
        break;
      }

      for (final payment in payments) {
        if (!store.state.paymentListState.isSelected(payment.id)) {
          store.dispatch(AddToPaymentMultiselect(entity: payment));
        } else {
          store.dispatch(RemoveFromPaymentMultiselect(entity: payment));
        }
      }
      break;
    case EntityAction.more:
      showEntityActionsDialog(
        entities: [payment],
      );
      break;
    default:
      logError(' ERROR: unhandled action $action in payment_actions');
      break;
  }
}
