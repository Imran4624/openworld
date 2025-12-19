import 'dart:async';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/utils/completers.dart';
import 'package:flutter_boilerplate/utils/localization.dart';
import 'package:redux/redux.dart';
import 'package:flutter_boilerplate/redux/ui/ui_actions.dart';
import 'package:flutter_boilerplate/ui/payment/payment_screen.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/redux/payment/payment_actions.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/ui/payment/view/payment_view.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';

class PaymentViewScreen extends StatelessWidget {
  const PaymentViewScreen({
    Key? key,
    this.isFilter = false,
  }) : super(key: key);

  static const String route = '/payment/view';

  final bool isFilter;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, PaymentViewVM>(
      converter: (Store<AppState> store) {
        return PaymentViewVM.fromStore(store);
      },
      builder: (context, vm) {
        return PaymentView(
          viewModel: vm,
          isFilter: isFilter,
        );
      },
    );
  }
}

class PaymentViewVM {
  PaymentViewVM({
    required this.state,
    required this.payment,
    required this.company,
    required this.onEntityAction,
    required this.onRefreshed,
    required this.isSaving,
    required this.isLoading,
    required this.isDirty,
    required this.onBackPressed,
  });

  factory PaymentViewVM.fromStore(Store<AppState> store) {
    final state = store.state;
    final payment = state.paymentState.map[state.paymentUIState.selectedId] ??
        PaymentEntity(id: state.paymentUIState.selectedId);

    Future<Null> _handleRefresh(BuildContext context) {
      final completer =
          snackBarCompleter<Null>(AppLocalization.of(context)!.refreshComplete);
      store.dispatch(LoadPayment(completer: completer, paymentId: payment.id));
      return completer.future;
    }

    return PaymentViewVM(
      state: state,
      company: state.company,
      isSaving: state.isSaving,
      isLoading: state.isLoading,
      isDirty: payment.isNew,
      payment: payment,
      onRefreshed: (context) => _handleRefresh(context),
      onBackPressed: () {
        store.dispatch(UpdateCurrentRoute(PaymentScreen.route));
      },
      onEntityAction: (BuildContext context, EntityAction action) =>
          handleEntitiesActions([payment], action, autoPop: true),
    );
  }

  final AppState state;
  final PaymentEntity payment;
  final CompanyEntity company;
  final Function(BuildContext, EntityAction) onEntityAction;
  final Function(BuildContext) onRefreshed;
  final Function onBackPressed;
  final bool isSaving;
  final bool isLoading;
  final bool isDirty;
}
