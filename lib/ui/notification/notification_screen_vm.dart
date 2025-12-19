import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/notification/notification_actions.dart';
import 'package:flutter_boilerplate/redux/notification/notification_selectors.dart';
import 'package:redux/redux.dart';

import 'notification_screen.dart';

class NotificationScreenBuilder extends StatelessWidget {
  const NotificationScreenBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, NotificationScreenVM>(
      converter: NotificationScreenVM.fromStore,
      onInit: (store) {
        store.dispatch(LoadNotifications(isRefresh: true));
      },
      builder: (context, vm) {
        return NotificationScreen(
          viewModel: vm,
        );
      },
    );
  }
}

class NotificationScreenVM {
  NotificationScreenVM({
    required this.isInMultiselect,
    required this.notificationList,
    required this.userCompany,
    required this.onEntityAction,
    required this.notificationMap,
  });

  final bool isInMultiselect;
  final UserCompanyEntity userCompany;
  final List<String> notificationList;
  final Function(BuildContext, List<BaseEntity>, EntityAction) onEntityAction;
  final BuiltMap<String, NotificationEntity> notificationMap;

  static NotificationScreenVM fromStore(Store<AppState> store) {
    final state = store.state;

    return NotificationScreenVM(
      notificationMap: state.notificationState.map,
      notificationList: memoizedFilteredNotificationList(
        state.getUISelection(EntityType.notification),
        state.notificationState.map,
        state.notificationState.list,
        state.notificationListState,
      ),
      userCompany: state.userCompany,
      isInMultiselect: state.notificationListState.isInMultiselect(),
      onEntityAction: (BuildContext context, List<BaseEntity> notifications,
              EntityAction action) =>
          handleNotificationAction(context, notifications, action),
    );
  }
}
