import 'package:redux/redux.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/company/company_actions.dart';
import 'package:flutter_boilerplate/redux/ui/entity_ui_state.dart';
import 'package:flutter_boilerplate/redux/payment/payment_actions.dart';
import 'package:flutter_boilerplate/redux/ui/list_ui_state.dart';
import 'package:flutter_boilerplate/redux/payment/payment_state.dart';
import 'package:flutter_boilerplate/data/models/payment_provider_models.dart';

EntityUIState paymentUIReducer(PaymentUIState state, dynamic action) {
  return state.rebuild((b) => b
    ..listUIState.replace(paymentListReducer(state.listUIState, action))
    ..editing.replace(editingReducer(state.editing, action)!)
    ..selectedId = selectedIdReducer(state.selectedId, action)
    ..forceSelected = forceSelectedReducer(state.forceSelected, action)
    ..tabIndex = tabIndexReducer(state.tabIndex, action));
}

final forceSelectedReducer = combineReducers<bool?>([
  TypedReducer<bool?, ViewPayment>((completer, action) => true),
  TypedReducer<bool?, ViewPaymentList>((completer, action) => false),
  TypedReducer<bool?, FilterPaymentsByState>((completer, action) => false),
  TypedReducer<bool?, FilterPayments>((completer, action) => false),
]);

final tabIndexReducer = combineReducers<int?>([
  TypedReducer<int?, UpdatePaymentTab>((completer, action) => action.tabIndex),
  TypedReducer<int?, PreviewEntity>((completer, action) => 0),
]);

Reducer<String?> selectedIdReducer = combineReducers([
  TypedReducer<String?, ArchivePaymentsSuccess>((completer, action) => ''),
  TypedReducer<String?, DeletePaymentsSuccess>((completer, action) => ''),
  TypedReducer<String?, PurgePaymentsSuccess>((completer, action) => ''),
  TypedReducer<String?, PreviewEntity>((selectedId, action) =>
      action.entityType == EntityType.payment ? action.entityId : selectedId),
  TypedReducer<String?, ViewPayment>(
      (String? selectedId, dynamic action) => action.paymentId),
  TypedReducer<String?, AddPaymentSuccess>(
      (String? selectedId, dynamic action) => action.payment.id),
  TypedReducer<String?, SelectCompany>(
      (selectedId, action) => action.clearSelection ? '' : selectedId),
  TypedReducer<String?, ClearEntityFilter>((selectedId, action) => ''),
  TypedReducer<String?, SortPayments>((selectedId, action) => ''),
  TypedReducer<String?, FilterPayments>((selectedId, action) => ''),
  TypedReducer<String?, FilterPaymentsByState>((selectedId, action) => ''),
  TypedReducer<String?, FilterByEntity>(
      (selectedId, action) => action.clearSelection
          ? ''
          : action.entityType == EntityType.payment
              ? action.entityId
              : selectedId),
]);

final editingReducer = combineReducers<PaymentEntity?>([
  TypedReducer<PaymentEntity?, SavePaymentSuccess>(_updateEditing),
  TypedReducer<PaymentEntity?, AddPaymentSuccess>(_updateEditing),
  TypedReducer<PaymentEntity?, RestorePaymentsSuccess>((payments, action) {
    return action.payments[0];
  }),
  TypedReducer<PaymentEntity?, ArchivePaymentsSuccess>((payments, action) {
    return action.payments[0];
  }),
  TypedReducer<PaymentEntity?, DeletePaymentsSuccess>((payments, action) {
    return action.payments[0];
  }),
  TypedReducer<PaymentEntity?, PurgePaymentsSuccess>((payments, action) {
    return action.payments[0];
  }),
  TypedReducer<PaymentEntity?, EditPayment>(_updateEditing),
  TypedReducer<PaymentEntity?, UpdatePayment>((payment, action) {
    return action.payment.rebuild((b) => b..isChanged = true);
  }),
  TypedReducer<PaymentEntity?, DiscardChanges>(_clearEditing),
]);

PaymentEntity _clearEditing(PaymentEntity? payment, dynamic action) {
  return PaymentEntity();
}

PaymentEntity? _updateEditing(PaymentEntity? payment, dynamic action) {
  return action.payment;
}

final paymentListReducer = combineReducers<ListUIState>([
  TypedReducer<ListUIState, SortPayments>(_sortPayments),
  TypedReducer<ListUIState, FilterPaymentsByState>(_filterPaymentsByState),
  TypedReducer<ListUIState, FilterPayments>(_filterPayments),
  TypedReducer<ListUIState, StartPaymentMultiselect>(_startListMultiselect),
  TypedReducer<ListUIState, AddToPaymentMultiselect>(_addToListMultiselect),
  TypedReducer<ListUIState, RemoveFromPaymentMultiselect>(
      _removeFromListMultiselect),
  TypedReducer<ListUIState, ClearPaymentMultiselect>(_clearListMultiselect),
  TypedReducer<ListUIState, ViewPaymentList>(_viewPaymentList),
  TypedReducer<ListUIState, FilterByEntity>((state, action) => state.rebuild(
        (b) => b
          ..filter = null
          ..filterClearedAt = DateTime.now().millisecondsSinceEpoch,
      )),
]);

ListUIState _viewPaymentList(
    ListUIState paymentListState, ViewPaymentList action) {
  return paymentListState.rebuild((b) => b
    ..selectedIds = null
    ..filter = null
    ..filterClearedAt = DateTime.now().millisecondsSinceEpoch);
}

ListUIState _filterPaymentsByState(
    ListUIState paymentListState, FilterPaymentsByState action) {
  if (paymentListState.stateFilters.contains(action.state)) {
    return paymentListState.rebuild((b) => b
      ..stateFilters.clear()
      ..stateFilters.add(EntityState.active));
  } else {
    return paymentListState.rebuild((b) => b
      ..stateFilters.clear()
      ..stateFilters.add(action.state));
  }
}

ListUIState _filterPayments(
    ListUIState paymentListState, FilterPayments action) {
  return paymentListState.rebuild((b) => b
    ..filter = action.filter
    ..filterClearedAt = action.filter == null
        ? DateTime.now().millisecondsSinceEpoch
        : paymentListState.filterClearedAt);
}

ListUIState _sortPayments(ListUIState paymentListState, SortPayments action) {
  return paymentListState.rebuild((b) => b
    ..sortAscending = b.sortField != action.field || !b.sortAscending!
    ..sortField = action.field);
}

ListUIState _startListMultiselect(
    ListUIState productListState, StartPaymentMultiselect action) {
  return productListState.rebuild((b) => b..selectedIds = ListBuilder());
}

ListUIState _addToListMultiselect(
    ListUIState productListState, AddToPaymentMultiselect action) {
  return productListState.rebuild((b) => b..selectedIds.add(action.entity.id));
}

ListUIState _removeFromListMultiselect(
    ListUIState productListState, RemoveFromPaymentMultiselect action) {
  return productListState
      .rebuild((b) => b..selectedIds.remove(action.entity.id));
}

ListUIState _clearListMultiselect(
    ListUIState productListState, ClearPaymentMultiselect action) {
  return productListState.rebuild((b) => b..selectedIds = null);
}

final paymentsReducer = combineReducers<PaymentState>([
  TypedReducer<PaymentState, SavePaymentSuccess>(_updatePayment),
  TypedReducer<PaymentState, AddPaymentSuccess>(_addPayment),
  TypedReducer<PaymentState, LoadPaymentsSuccess>(_setLoadedPayments),
  TypedReducer<PaymentState, LoadPaymentSuccess>(_setLoadedPayment),
  TypedReducer<PaymentState, UpdateLastDocumentAction>(_updateLastDocument),
  TypedReducer<PaymentState, UpdatePaymentFilter>(_updatePaymentFilter),
  // TypedReducer<PaymentState, LoadCompanySuccess>(_setLoadedCompany), //uncomment this if you its dependant on selected company
  TypedReducer<PaymentState, ArchivePaymentsSuccess>(_archivePaymentSuccess),
  TypedReducer<PaymentState, DeletePaymentsSuccess>(_deletePaymentSuccess),
  TypedReducer<PaymentState, PurgePaymentsSuccess>(_purgePaymentSuccess),
  TypedReducer<PaymentState, RestorePaymentsSuccess>(_restorePaymentSuccess),
]);

PaymentState _archivePaymentSuccess(
    PaymentState paymentState, ArchivePaymentsSuccess action) {
  final int currentTime = DateTime.now().millisecondsSinceEpoch;
  return paymentState.rebuild((b) {
    for (final payment in action.payments) {
      b.map[payment.id] = paymentState.map[payment.id]!
          .rebuild((b) => b..archivedAt = currentTime);
    }
  });
}

PaymentState _updatePaymentFilter(
    PaymentState paymentState, UpdatePaymentFilter action) {
  return paymentState.rebuild((b) => b..filter = action.filter.toBuilder());
}

// PaymentState _deletePaymentSuccess(PaymentState paymentState, DeletePaymentsSuccess action) {
//   return paymentState.rebuild((b) {
//     for (final payment in action.payments) {
//       b.map[payment.id] = payment;
//     }
//   });
// }

PaymentState _deletePaymentSuccess(
    PaymentState paymentState, DeletePaymentsSuccess action) {
  return paymentState.rebuild((b) {
    for (final payment in action.payments) {
      b.map[payment.id] =
          paymentState.map[payment.id]!.rebuild((b) => b..isDeleted = true);
    }
  });
}

PaymentState _purgePaymentSuccess(
    PaymentState paymentState, PurgePaymentsSuccess action) {
  return paymentState.rebuild((b) {
    for (final payment in action.payments) {
      b.map.remove(payment.id);
      b.list.remove(payment.id);
    }
  });
}

PaymentState _restorePaymentSuccess(
    PaymentState paymentState, RestorePaymentsSuccess action) {
  return paymentState.rebuild((b) {
    for (final payment in action.payments) {
      b.map[payment.id] = paymentState.map[payment.id]!.rebuild((b) => b
        ..isDeleted = false
        ..archivedAt = 0);
    }
  });
}

PaymentState _addPayment(PaymentState paymentState, AddPaymentSuccess action) {
  return paymentState.rebuild((b) => b
    ..map[action.payment.id] = action.payment
    ..list.add(action.payment.id));
}

PaymentState _updatePayment(
    PaymentState paymentState, SavePaymentSuccess action) {
  return paymentState
      .rebuild((b) => b..map[action.payment.id] = action.payment);
}

PaymentState _updateLastDocument(
    PaymentState paymentState, UpdateLastDocumentAction action) {
  return paymentState.rebuild((b) => b..lastDocument = action.lastDocument);
}

PaymentState _setLoadedPayment(
    PaymentState paymentState, LoadPaymentSuccess action) {
  return paymentState
      .rebuild((b) => b..map[action.payment.id] = action.payment);
}

PaymentState _setLoadedPayments(
    PaymentState paymentState, LoadPaymentsSuccess action) {
  return paymentState.rebuild((b) {
    action.payments.forEach((payment) {
      b.map[payment.id] = payment;
      if (!b.list.build().contains(payment.id)) {
        b.list.add(payment.id);
      }
    });
  });
}

// PaymentState _setLoadedCompany(PaymentState paymentState, LoadCompanySuccess action) {
//   final company = action.userCompany.company;
//   return paymentState.loadPayments(company.payments);
// }
