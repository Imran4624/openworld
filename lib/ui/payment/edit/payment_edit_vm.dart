import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/redux/ui/ui_actions.dart';
import 'package:redux/redux.dart';
import 'package:flutter_boilerplate/utils/completers.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/ui/app/dialogs/error_dialog.dart';
import 'package:flutter_boilerplate/ui/payment/view/payment_view_vm.dart';
import 'package:flutter_boilerplate/redux/payment/payment_actions.dart';
import 'package:flutter_boilerplate/ui/payment/edit/payment_edit.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_boilerplate/utils/localization.dart';

class PaymentEditScreen extends StatelessWidget {
  const PaymentEditScreen({Key? key}) : super(key: key);
  static const String route = '/payment/edit';

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, PaymentEditVM>(
      converter: (Store<AppState> store) {
        return PaymentEditVM.fromStore(store);
      },
      builder: (context, viewModel) {
        return PaymentEdit(
          viewModel: viewModel,
          key: ValueKey(viewModel.payment.updatedAt),
        );
      },
    );
  }
}

class PaymentEditVM {
  PaymentEditVM({
    required this.state,
    required this.payment,
    this.company,
    required this.onChanged,
    required this.isSaving,
    this.origPayment,
    required this.onSavePressed,
    required this.onCancelPressed,
    required this.isLoading,
  });

  factory PaymentEditVM.fromStore(Store<AppState> store) {
    final state = store.state;
    final payment = state.paymentUIState.editing;

    return PaymentEditVM(
      state: state,
      isLoading: state.isLoading,
      isSaving: state.isSaving,
      origPayment: state.paymentState.map[payment!.id],
      payment: payment,
      company: state.company,
      onChanged: (PaymentEntity payment) {
        store.dispatch(UpdatePayment(payment));
      },
      onCancelPressed: (BuildContext context) {
        createEntity(entity: PaymentEntity(), force: true);
        if (state.paymentUIState.cancelCompleter != null) {
          state.paymentUIState.cancelCompleter!.complete();
        } else {
          store.dispatch(UpdateCurrentRoute(state.uiState.previousRoute));
        }
      },
      onSavePressed: (BuildContext context) {
        Debouncer.runOnComplete(() {
          final payment = store.state.paymentUIState.editing!;
          final localization = AppLocalization.of(context)!;
          final Completer<PaymentEntity> completer = Completer<PaymentEntity>();
          store.dispatch(
              SavePaymentRequest(completer: completer, payment: payment));
          return completer.future.then((savedPayment) {
            showToast(payment.isNew
                ? localization.createdPayment
                : localization.updatedPayment);
            if (state.prefState.isMobile) {
              store.dispatch(UpdateCurrentRoute(PaymentViewScreen.route));
              if (payment.isNew) {
                Navigator.of(context)
                    .pushReplacementNamed(PaymentViewScreen.route);
              } else {
                Navigator.of(context).pop(savedPayment);
              }
            } else {
              viewEntity(entity: savedPayment, force: true);
            }
          }).catchError((Object error) {
            showDialog<ErrorDialog>(
                context: context,
                builder: (BuildContext context) {
                  return ErrorDialog(error);
                });
          });
        });
      },
    );
  }

  final PaymentEntity payment;
  final CompanyEntity? company;
  final Function(PaymentEntity) onChanged;
  final Function(BuildContext) onSavePressed;
  final Function(BuildContext) onCancelPressed;
  final bool isLoading;
  final bool isSaving;
  final PaymentEntity? origPayment;
  final AppState state;
}
