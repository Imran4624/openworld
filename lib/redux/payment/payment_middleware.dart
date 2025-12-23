import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'package:redux/redux.dart';
import 'package:built_collection/built_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_boilerplate/main_app.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/ui/ui_actions.dart';
import 'package:flutter_boilerplate/ui/payment/payment_screen.dart';
import 'package:flutter_boilerplate/ui/payment/edit/payment_edit_vm.dart';
import 'package:flutter_boilerplate/ui/payment/view/payment_view_vm.dart';
import 'package:flutter_boilerplate/redux/payment/payment_actions.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/data/repositories/payment_repository.dart';

List<Middleware<AppState>> createStorePaymentsMiddleware([
  PaymentRepository repository = const PaymentRepository(),
]) {
  final viewPaymentList = _viewPaymentList();
  final viewPayment = _viewPayment();
  final editPayment = _editPayment();
  final loadPayments = _loadPayments(repository);
  final loadPayment = _loadPayment(repository);
  final savePayment = _savePayment(repository);
  final archivePayment = _archivePayment(repository);
  final deletePayment = _deletePayment(repository);
  final purgePayment = _purgePayment(repository);
  final restorePayment = _restorePayment(repository);
  final updateFilter = _updateFilter(repository);

  return [
    TypedMiddleware<AppState, ViewPaymentList>(viewPaymentList),
    TypedMiddleware<AppState, ViewPayment>(viewPayment),
    TypedMiddleware<AppState, EditPayment>(editPayment),
    TypedMiddleware<AppState, LoadPayments>(loadPayments),
    TypedMiddleware<AppState, LoadPayment>(loadPayment),
    TypedMiddleware<AppState, SavePaymentRequest>(savePayment),
    TypedMiddleware<AppState, ArchivePaymentsRequest>(archivePayment),
    TypedMiddleware<AppState, DeletePaymentsRequest>(deletePayment),
    TypedMiddleware<AppState, PurgePaymentsRequest>(purgePayment),
    TypedMiddleware<AppState, RestorePaymentsRequest>(restorePayment),
    TypedMiddleware<AppState, UpdatePaymentFilter>(updateFilter),
  ];
}

Middleware<AppState> _editPayment() {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as EditPayment;

    next(action);

    store.dispatch(UpdateCurrentRoute(PaymentEditScreen.route));

    if (store.state.prefState.isMobile) {
      navigatorKey.currentState!.pushNamed(PaymentEditScreen.route);
    }
  };
}

Middleware<AppState> _viewPayment() {
  return (Store<AppState> store, dynamic dynamicAction,
      NextDispatcher next) async {
    final action = dynamicAction as ViewPayment;

    next(action);

    store.dispatch(UpdateCurrentRoute(PaymentViewScreen.route));

    if (store.state.prefState.isMobile) {
      navigatorKey.currentState!.pushNamed(PaymentViewScreen.route);
    }
  };
}

Middleware<AppState> _viewPaymentList() {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as ViewPaymentList;

    next(action);

    if (store.state.staticState.isStale) {
      store.dispatch(RefreshData());
    }

    store.dispatch(UpdateCurrentRoute(PaymentScreen.route));

    if (store.state.prefState.isMobile) {
      navigatorKey.currentState!.pushNamedAndRemoveUntil(
          PaymentScreen.route, (Route<dynamic> route) => false);
    }
  };
}

Middleware<AppState> _archivePayment(PaymentRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as ArchivePaymentsRequest;
    final prevPayments = action.paymentIds
        .map((id) => store.state.paymentState.map[id])
        .whereType<PaymentEntity>()
        .toList();

    repository
        .bulkAction(
            store.state.credentials, action.paymentIds, EntityAction.archive)
        .then((List<PaymentEntity> payments) {
      store.dispatch(ArchivePaymentsSuccess(payments));
      action.completer.complete(null);
    }).catchError((Object error) {
      logError('Failed to archive payments: $error');
      store.dispatch(ArchivePaymentsFailure(prevPayments));
      action.completer.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _deletePayment(PaymentRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as DeletePaymentsRequest;
    final prevPayments = action.paymentIds
        .map((id) => store.state.paymentState.map[id])
        .whereType<PaymentEntity>()
        .toList();

    repository
        .bulkAction(
            store.state.credentials, action.paymentIds, EntityAction.delete)
        .then((List<PaymentEntity> payments) {
      store.dispatch(DeletePaymentsSuccess(payments));
      action.completer.complete(null);
    }).catchError((Object error) {
      logError('Failed to delete payments: $error');
      store.dispatch(DeletePaymentsFailure(prevPayments));
      action.completer.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _purgePayment(PaymentRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as PurgePaymentsRequest;
    final prevPayments = action.paymentIds
        .map((id) => store.state.paymentState.map[id])
        .whereType<PaymentEntity>()
        .toList();

    repository
        .bulkAction(
            store.state.credentials, action.paymentIds, EntityAction.purge)
        .then((List<PaymentEntity> payments) {
      store.dispatch(PurgePaymentsSuccess(payments));
      action.completer.complete(null);
    }).catchError((Object error) {
      logError('Failed to purge payments: $error');
      store.dispatch(PurgePaymentsFailure(prevPayments));
      action.completer.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _restorePayment(PaymentRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as RestorePaymentsRequest;
    final prevPayments = action.paymentIds
        .map((id) => store.state.paymentState.map[id])
        .whereType<PaymentEntity>()
        .toList();

    repository
        .bulkAction(
            store.state.credentials, action.paymentIds, EntityAction.restore)
        .then((List<PaymentEntity> payments) {
      store.dispatch(RestorePaymentsSuccess(payments));
      action.completer.complete(null);
    }).catchError((Object error) {
      logError('Failed to restore payments: $error');
      store.dispatch(RestorePaymentsFailure(prevPayments));
      action.completer.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _savePayment(PaymentRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as SavePaymentRequest;
    repository
        .saveData(store.state.credentials, action.payment!)
        .then((PaymentEntity payment) {
      if (action.payment!.isNew) {
        store.dispatch(AddPaymentSuccess(payment));
      } else {
        store.dispatch(SavePaymentSuccess(payment));
      }

      action.completer?.complete(payment);
    }).catchError((Object error) {
      logError('Failed to save payment: $error');
      store.dispatch(SavePaymentFailure(error));
      action.completer?.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _loadPayment(PaymentRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as LoadPayment;

    store.dispatch(LoadPaymentRequest());
    repository
        .loadItem(store.state.credentials, action.paymentId!)
        .then((payment) {
      store.dispatch(LoadPaymentSuccess(payment));
      action.completer?.complete(null);
    }).catchError((Object error) {
      logError('Failed to load payment: $error');
      store.dispatch(LoadPaymentFailure(error));
      action.completer?.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _loadPayments(PaymentRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    if (store.state.isLoading) {
      return;
    }

    final action = dynamicAction as LoadPayments;
    final state = store.state;
    final stateFilters = state.paymentListState.stateFilters;
    final currentFilter = action.filter ?? state.paymentState.filter;

    final filter = currentFilter.rebuild((b) {
      if (stateFilters.isNotEmpty) {
        b.stateFilter = stateFilters.first;
      } else {
        b.stateFilter = EntityState.active;
      }
    });
    store.dispatch(LoadPaymentsRequest(filter: filter));

    var lastDocument = state.paymentState.lastDocument;
    if (action.isRefresh) {
      lastDocument = null;
      store.dispatch(UpdateLastDocumentAction(null));
    }

    repository
        .loadListWithPagination(
      lastDocument: lastDocument,
      limit: filter.limit,
      filter: filter,
    )
        .then((response) {
      final payments = response['payments'] as BuiltList<PaymentEntity>;
      final newLastDocument = response['lastDocument'] as DocumentSnapshot?;

      store.dispatch(LoadPaymentsSuccess(payments));
      if (payments.isNotEmpty) {
        store.dispatch(UpdateLastDocumentAction(newLastDocument));
      }
      action.completer?.complete(null);
    }).catchError((Object error) {
      logError('Failed to load payments: $error');
      store.dispatch(LoadPaymentsFailure(error));
      action.completer?.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _updateFilter(PaymentRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as UpdatePaymentFilter;

    next(action);

    store.dispatch(LoadPayments(
      filter: action.filter,
      isRefresh: true,
    ));
  };
}
