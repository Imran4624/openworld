import 'package:flutter_boilerplate/redux/static/static_state.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:memoize/memoize.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/ui/list_ui_state.dart';

var memoizedDropdownNotificationList = memo5(
    (BuiltMap<String, NotificationEntity> notificationMap,
            BuiltList<String> notificationList,
            StaticState staticState,
            BuiltMap<String, UserEntity> userMap,
            String? clientId) =>
        dropdownNotificationsSelector(
            notificationMap, notificationList, staticState, userMap, clientId));

List<String> dropdownNotificationsSelector(
    BuiltMap<String, NotificationEntity> notificationMap,
    BuiltList<String> notificationList,
    StaticState staticState,
    BuiltMap<String, UserEntity> userMap,
    String? clientId) {
  final list = notificationList.where((notificationId) {
    final notification = notificationMap[notificationId];
    if (notification == null) {
      return false;
    }
    /*
    if (clientId != null && clientId > 0 && notification.clientId != clientId) {
      return false;
    }
    */
    return notification.isActive;
  }).toList();

  list.sort((notificationAId, notificationBId) {
    final notificationA = notificationMap[notificationAId]!;
    final notificationB = notificationMap[notificationBId]!;

    // STARTER: primary field - do not remove comment
    return notificationA.compareTo(
        notificationB, NotificationFields.title, true);
  });

  return list;
}

var memoizedFilteredNotificationList = memo4((SelectionState selectionState,
        BuiltMap<String, NotificationEntity> notificationMap,
        BuiltList<String> notificationList,
        ListUIState notificationListState) =>
    filteredNotificationsSelector(selectionState, notificationMap,
        notificationList, notificationListState));

List<String> filteredNotificationsSelector(
    SelectionState selectionState,
    BuiltMap<String, NotificationEntity> notificationMap,
    BuiltList<String> notificationList,
    ListUIState notificationListState) {
  final filterEntityId = selectionState.filterEntityId;
  // final filterEntityType = selectionState.filterEntityType;

  final filteredList = notificationList.where((notificationId) {
    final notification = notificationMap[notificationId];
    if (notification == null) {
      return false;
    }

    if (filterEntityId != null && notification.id != filterEntityId) {
      return false;
    }

    if (!notification.matchesStates(notificationListState.stateFilters)) {
      return false;
    }

    // Uncomment if using custom filters in future
    // if (notificationListState.custom1Filters.isNotEmpty &&
    //     !notificationListState.custom1Filters.contains(notification.customValue1)) {
    //   return false;
    // } else if (notificationListState.custom2Filters.isNotEmpty &&
    //     !notificationListState.custom2Filters.contains(notification.customValue2)) {
    //   return false;
    // } else if (notificationListState.custom3Filters.isNotEmpty &&
    //     !notificationListState.custom3Filters.contains(notification.customValue3)) {
    //   return false;
    // } else if (notificationListState.custom4Filters.isNotEmpty &&
    //     !notificationListState.custom4Filters.contains(notification.customValue4)) {
    //   return false;
    // }

    return notification.matchesFilter(notificationListState.filter);
  }).toList();

  final uniqueNotifications = <String, String>{};
  for (final notificationId in filteredList) {
    final notification = notificationMap[notificationId];
    if (notification != null) {
      uniqueNotifications[notification.id] = notificationId;
    }
  }

  final sortedList = uniqueNotifications.values.toList();
  // ..sort((notificationAId, notificationBId) {
  //   final notificationA = notificationMap[notificationAId]!;
  //   final notificationB = notificationMap[notificationBId]!;
  //   return notificationA.compareTo(
  //       notificationB, notificationListState.sortField, notificationListState.sortAscending);
  // });

  return sortedList;
}
