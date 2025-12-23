import 'dart:async';
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/ui/app/tables/entity_list.dart';
import 'package:flutter_boilerplate/ui/notification/notification_list_item.dart';
import 'package:flutter_boilerplate/ui/notification/notification_presenter.dart';
import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter_boilerplate/redux/ui/list_ui_state.dart';
import 'package:flutter_boilerplate/redux/notification/notification_selectors.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/notification/notification_actions.dart';

class NotificationListBuilder extends StatelessWidget {
  const NotificationListBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, NotificationListVM>(
      converter: NotificationListVM.fromStore,
      builder: (context, viewModel) {
        return EntityList(
          entityType: EntityType.notification,
          presenter: NotificationPresenter(),
          state: viewModel.state,
          entityList: viewModel.notificationList,
          tableColumns: viewModel.tableColumns,
          onRefreshed: viewModel.onRefreshed,
          onSortColumn: viewModel.onSortColumn,
          viewType: ViewType.list,
          onClearMultiselect: viewModel.onClearMultiselect,
          itemBuilder: (BuildContext context, index) {
            final state = viewModel.state;
            final notificationId = viewModel.notificationList[index];
            final notification = viewModel.notificationMap[notificationId]!;
            final listState = state.getListState(EntityType.notification);
            final isInMultiselect = listState.isInMultiselect();

            return NotificationListItem(
              user: viewModel.state.user,
              filter: viewModel.filter,
              notification: notification,
              isChecked:
                  isInMultiselect && listState.isSelected(notification.id),
            );
          },
        );
      },
    );
  }
}

class NotificationListVM {
  NotificationListVM({
    required this.state,
    required this.userCompany,
    required this.notificationList,
    required this.notificationMap,
    required this.filter,
    required this.isLoading,
    required this.listState,
    required this.onRefreshed,
    required this.onEntityAction,
    required this.tableColumns,
    required this.onSortColumn,
    required this.onClearMultiselect,
  });

  static NotificationListVM fromStore(Store<AppState> store) {
    Future<void> _handleRefresh(BuildContext context) {
      if (store.state.isLoading) {
        return Future<void>.value();
      }

      final completer = Completer<void>();

      store.dispatch(LoadNotifications(
          completer: completer, filter: store.state.notificationState.filter));

      return completer.future;
    }

    final state = store.state;

    return NotificationListVM(
      state: state,
      userCompany: state.userCompany,
      listState: state.notificationListState,
      notificationList: memoizedFilteredNotificationList(
        state.getUISelection(EntityType.notification),
        state.notificationState.map,
        state.notificationState.list,
        state.notificationListState,
      ),
      notificationMap: state.notificationState.map,
      isLoading: state.isLoading,
      filter: state.notificationState.filter.searchTerm,
      onEntityAction: (BuildContext context, List<BaseEntity> notifications,
              EntityAction action) =>
          handleNotificationAction(context, notifications, action),
      onRefreshed: (context) => _handleRefresh(context),
      tableColumns:
          state.userCompany.settings.getTableColumns(EntityType.notification) ??
              NotificationPresenter.getDefaultTableFields(state.userCompany),
      onSortColumn: (field) => store.dispatch(UpdateNotificationFilter(
        state.notificationState.filter.rebuild((b) => b
          ..sortField = field
          ..sortAscending = state.notificationState.filter.sortField == field
              ? !state.notificationState.filter.sortAscending
              : true),
      )),
      onClearMultiselect: () => store.dispatch(ClearNotificationMultiselect()),
    );
  }

  final AppState state;
  final UserCompanyEntity userCompany;
  final List<String> notificationList;
  final BuiltMap<String, NotificationEntity> notificationMap;
  final ListUIState listState;
  final String? filter;
  final bool isLoading;
  final Function(BuildContext) onRefreshed;
  final Function(BuildContext, List<BaseEntity>, EntityAction) onEntityAction;
  final List<String> tableColumns;
  final Function(String) onSortColumn;
  final Function onClearMultiselect;
}
