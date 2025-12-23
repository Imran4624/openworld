import 'dart:async';
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/ui/app/tables/entity_list.dart';
import 'package:flutter_boilerplate/ui/payment/payment_list_item.dart';
import 'package:flutter_boilerplate/ui/payment/payment_presenter.dart';
import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter_boilerplate/redux/ui/list_ui_state.dart';
import 'package:flutter_boilerplate/redux/payment/payment_selectors.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/payment/payment_actions.dart';

class PaymentListBuilder extends StatelessWidget {
  const PaymentListBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, PaymentListVM>(
      converter: PaymentListVM.fromStore,
      builder: (context, viewModel) {
        return EntityList(
          entityType: EntityType.payment,
          presenter: PaymentPresenter(),
          state: viewModel.state,
          entityList: viewModel.paymentList,
          tableColumns: viewModel.tableColumns,
          onRefreshed: viewModel.onRefreshed,
          onSortColumn: viewModel.onSortColumn,
          viewType: ViewType.list,
          onClearMultiselect: viewModel.onClearMultiselect,
          itemBuilder: (BuildContext context, index) {
            final state = viewModel.state;
            final paymentId = viewModel.paymentList[index];
            final payment = viewModel.paymentMap[paymentId]!;
            final listState = state.getListState(EntityType.payment);
            final isInMultiselect = listState.isInMultiselect();

            return PaymentListItem(
              user: viewModel.state.user,
              filter: viewModel.filter,
              payment: payment,
              isChecked: isInMultiselect && listState.isSelected(payment.id),
            );
          },
        );
      },
    );
  }
}

class PaymentListVM {
  PaymentListVM({
    required this.state,
    required this.userCompany,
    required this.paymentList,
    required this.paymentMap,
    required this.filter,
    required this.isLoading,
    required this.listState,
    required this.onRefreshed,
    required this.onEntityAction,
    required this.tableColumns,
    required this.onSortColumn,
    required this.onClearMultiselect,
  });

  static PaymentListVM fromStore(Store<AppState> store) {
    Future<void> _handleRefresh(BuildContext context) {
      if (store.state.isLoading) {
        return Future<void>.value();
      }

      final completer = Completer<void>();

      store.dispatch(LoadPayments(
          completer: completer, filter: store.state.paymentState.filter));

      return completer.future;
    }

    final state = store.state;

    return PaymentListVM(
      state: state,
      userCompany: state.userCompany,
      listState: state.paymentListState,
      paymentList: memoizedFilteredPaymentList(
        state.getUISelection(EntityType.payment),
        state.paymentState.map,
        state.paymentState.list,
        state.paymentListState,
      ),
      paymentMap: state.paymentState.map,
      isLoading: state.isLoading,
      filter: state.paymentState.filter.searchTerm,
      onEntityAction: (BuildContext context, List<BaseEntity> payments,
              EntityAction action) =>
          handlePaymentAction(context, payments, action),
      onRefreshed: (context) => _handleRefresh(context),
        tableColumns:
          state.userCompany.settings.getTableColumns(EntityType.payment) ??
              PaymentPresenter.getDefaultTableFields(state.userCompany),
      onSortColumn: (field) => store.dispatch(UpdatePaymentFilter(
        state.paymentState.filter.rebuild((b) => b
          ..sortField = field
          ..sortAscending = state.paymentState.filter.sortField == field
              ? !state.paymentState.filter.sortAscending
              : true),
      )),
      onClearMultiselect: () => store.dispatch(ClearPaymentMultiselect()),
    );
  }

  final AppState state;
  final UserCompanyEntity userCompany;
  final List<String> paymentList;
  final BuiltMap<String, PaymentEntity> paymentMap;
  final ListUIState listState;
  final String? filter;
  final bool isLoading;
  final Function(BuildContext) onRefreshed;
  final Function(BuildContext, List<BaseEntity>, EntityAction) onEntityAction;
  final List<String> tableColumns;
  final Function(String) onSortColumn;
  final Function onClearMultiselect;
}
