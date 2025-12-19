import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/notification/notification_actions.dart';
import 'package:flutter_boilerplate/ui/app/app_bottom_bar.dart';
import 'package:flutter_boilerplate/ui/app/list_scaffold.dart';
import 'package:flutter_boilerplate/ui/app/list_filter.dart';
import 'package:flutter_boilerplate/ui/notification/notification_list_vm.dart';
import 'package:flutter_boilerplate/ui/notification/notification_presenter.dart';
import 'package:flutter_boilerplate/utils/localization.dart';

import 'notification_screen_vm.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  static const String route = '/notification';

  final NotificationScreenVM viewModel;

  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    final state = store.state;
    final userCompany = state.userCompany;
    final localization = AppLocalization.of(context)!;

    return ListScaffold(
      entityType: EntityType.notification,
      onHamburgerLongPress: () =>
          store.dispatch(StartNotificationMultiselect()),
      appBarTitle: ListFilter(
        key: ValueKey(
            '__filter_${state.notificationListState.filterClearedAt}__'),
        entityType: EntityType.notification,
        entityIds: viewModel.notificationList,
        filter: state.notificationState.filter.searchTerm,
        onFilterChanged: (value) {
          store.dispatch(FilterNotifications(value!));
          store.dispatch(UpdateNotificationFilter(
            state.notificationState.filter
                .rebuild((b) => b..searchTerm = value ?? ''),
          ));
        },
        onSelectedState: (EntityState filterState, bool? value) {
          store.dispatch(FilterNotificationsByState(filterState));
          if (value ?? false) {
            store.dispatch(UpdateNotificationFilter(
              state.notificationState.filter
                  .rebuild((b) => b..stateFilter = filterState),
            ));
          }
          // printL('notificationFilter state ==> ${state.notificationState}');
        },
        selectedStateFilter: state.notificationState.filter.stateFilter,
      ),
      onCheckboxPressed: () {
        if (store.state.notificationListState.isInMultiselect()) {
          store.dispatch(ClearNotificationMultiselect());
        } else {
          store.dispatch(StartNotificationMultiselect());
        }
      },
      body: NotificationListBuilder(),
      bottomNavigationBar: AppBottomBar(
        entityType: EntityType.notification,
        tableColumns: NotificationPresenter.getAllTableFields(userCompany),
        defaultTableColumns:
            NotificationPresenter.getDefaultTableFields(userCompany),
        onSelectedSortField: (field) {
          final ascending = state.notificationState.filter.sortField == field
              ? !state.notificationState.filter.sortAscending
              : true;
          store.dispatch(UpdateNotificationFilter(
            state.notificationState.filter.rebuild((b) => b
              ..sortField = field
              ..sortAscending = ascending),
          ));
        },
        sortFields: [
          // STARTER: constant fields - do not remove comment
          NotificationFields.title,

          NotificationFields.body,

          NotificationFields.type,

          NotificationFields.channel,

          NotificationFields.actionUrl,

          NotificationFields.payload,

          NotificationFields.priority,
        ],
        onSelectedState: (EntityState filterState, bool? value) {
          store.dispatch(FilterNotificationsByState(filterState));
          if (value ?? false) {
            store.dispatch(UpdateNotificationFilter(
              state.notificationState.filter
                  .rebuild((b) => b..stateFilter = filterState),
            ));
          }
        },
        onCheckboxPressed: () {
          if (store.state.notificationListState.isInMultiselect()) {
            store.dispatch(ClearNotificationMultiselect());
          } else {
            store.dispatch(StartNotificationMultiselect());
          }
        },
        // // customValues1: userCompany.getCustomFieldValues(CustomFieldType.notification1,
        // //     excludeBlank: true),
        // // customValues2: userCompany.getCustomFieldValues(CustomFieldType.notification2,
        // //     excludeBlank: true),
        // // customValues3: userCompany.getCustomFieldValues(CustomFieldType.notification3,
        // //     excludeBlank: true),
        // // customValues4: userCompany.getCustomFieldValues(CustomFieldType.notification4,
        //     excludeBlank: true),
        // onSelectedCustom1: (value) =>
        //     store.dispatch(FilterNotificationsByCustom1(value)),
        // onSelectedCustom2: (value) =>
        //     store.dispatch(FilterNotificationsByCustom2(value)),
        // onSelectedCustom3: (value) =>
        //     store.dispatch(FilterNotificationsByCustom3(value)),
        // onSelectedCustom4: (value) =>
        //     store.dispatch(FilterNotificationsByCustom4(value)),
      ),
      floatingActionButton: state.prefState.isMenuFloated &&
              userCompany.canCreate(EntityType.notification)
          ? FloatingActionButton(
              heroTag: 'notification_fab',
              backgroundColor: Theme.of(context).primaryColorDark,
              onPressed: () {
                createEntityByType(
                    context: context, entityType: EntityType.notification);
              },
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
              tooltip: localization.newNotification,
            )
          : null,
    );
  }
}
