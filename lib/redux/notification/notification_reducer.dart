import 'package:redux/redux.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/company/company_actions.dart';
import 'package:flutter_boilerplate/redux/ui/entity_ui_state.dart';
import 'package:flutter_boilerplate/redux/notification/notification_actions.dart';
import 'package:flutter_boilerplate/redux/ui/list_ui_state.dart';
import 'package:flutter_boilerplate/redux/notification/notification_state.dart';

EntityUIState notificationUIReducer(NotificationUIState state, dynamic action) {
  return state.rebuild((b) => b
    ..listUIState.replace(notificationListReducer(state.listUIState, action))
    ..editing.replace(editingReducer(state.editing, action)!)
    ..selectedId = selectedIdReducer(state.selectedId, action)
    ..forceSelected = forceSelectedReducer(state.forceSelected, action)
    ..tabIndex = tabIndexReducer(state.tabIndex, action));
}

final forceSelectedReducer = combineReducers<bool?>([
  TypedReducer<bool?, ViewNotification>((completer, action) => true),
  TypedReducer<bool?, ViewNotificationList>((completer, action) => false),
  TypedReducer<bool?, FilterNotificationsByState>((completer, action) => false),
  TypedReducer<bool?, FilterNotifications>((completer, action) => false),
]);

final tabIndexReducer = combineReducers<int?>([
  TypedReducer<int?, UpdateNotificationTab>(
      (completer, action) => action.tabIndex),
  TypedReducer<int?, PreviewEntity>((completer, action) => 0),
]);

Reducer<String?> selectedIdReducer = combineReducers([
  TypedReducer<String?, ArchiveNotificationsSuccess>((completer, action) => ''),
  TypedReducer<String?, DeleteNotificationsSuccess>((completer, action) => ''),
  TypedReducer<String?, PurgeNotificationsSuccess>((completer, action) => ''),
  TypedReducer<String?, PreviewEntity>((selectedId, action) =>
      action.entityType == EntityType.notification
          ? action.entityId
          : selectedId),
  TypedReducer<String?, ViewNotification>(
      (String? selectedId, dynamic action) => action.notificationId),
  TypedReducer<String?, AddNotificationSuccess>(
      (String? selectedId, dynamic action) => action.notification.id),
  TypedReducer<String?, SelectCompany>(
      (selectedId, action) => action.clearSelection ? '' : selectedId),
  TypedReducer<String?, ClearEntityFilter>((selectedId, action) => ''),
  TypedReducer<String?, SortNotifications>((selectedId, action) => ''),
  TypedReducer<String?, FilterNotifications>((selectedId, action) => ''),
  TypedReducer<String?, FilterNotificationsByState>((selectedId, action) => ''),
  TypedReducer<String?, FilterByEntity>(
      (selectedId, action) => action.clearSelection
          ? ''
          : action.entityType == EntityType.notification
              ? action.entityId
              : selectedId),
]);

final editingReducer = combineReducers<NotificationEntity?>([
  TypedReducer<NotificationEntity?, SaveNotificationSuccess>(_updateEditing),
  TypedReducer<NotificationEntity?, AddNotificationSuccess>(_updateEditing),
  TypedReducer<NotificationEntity?, RestoreNotificationsSuccess>(
      (notifications, action) {
    return action.notifications[0];
  }),
  TypedReducer<NotificationEntity?, ArchiveNotificationsSuccess>(
      (notifications, action) {
    return action.notifications[0];
  }),
  TypedReducer<NotificationEntity?, DeleteNotificationsSuccess>(
      (notifications, action) {
    return action.notifications[0];
  }),
  TypedReducer<NotificationEntity?, PurgeNotificationsSuccess>(
      (notifications, action) {
    return action.notifications[0];
  }),
  TypedReducer<NotificationEntity?, EditNotification>(_updateEditing),
  TypedReducer<NotificationEntity?, UpdateNotification>((notification, action) {
    return action.notification.rebuild((b) => b..isChanged = true);
  }),
  TypedReducer<NotificationEntity?, DiscardChanges>(_clearEditing),
]);

NotificationEntity _clearEditing(
    NotificationEntity? notification, dynamic action) {
  return NotificationEntity();
}

NotificationEntity? _updateEditing(
    NotificationEntity? notification, dynamic action) {
  return action.notification;
}

final notificationListReducer = combineReducers<ListUIState>([
  TypedReducer<ListUIState, SortNotifications>(_sortNotifications),
  TypedReducer<ListUIState, FilterNotificationsByState>(
      _filterNotificationsByState),
  TypedReducer<ListUIState, FilterNotifications>(_filterNotifications),
  TypedReducer<ListUIState, StartNotificationMultiselect>(
      _startListMultiselect),
  TypedReducer<ListUIState, AddToNotificationMultiselect>(
      _addToListMultiselect),
  TypedReducer<ListUIState, RemoveFromNotificationMultiselect>(
      _removeFromListMultiselect),
  TypedReducer<ListUIState, ClearNotificationMultiselect>(
      _clearListMultiselect),
  TypedReducer<ListUIState, ViewNotificationList>(_viewNotificationList),
  TypedReducer<ListUIState, FilterByEntity>((state, action) => state.rebuild(
        (b) => b
          ..filter = null
          ..filterClearedAt = DateTime.now().millisecondsSinceEpoch,
      )),
]);

ListUIState _viewNotificationList(
    ListUIState notificationListState, ViewNotificationList action) {
  return notificationListState.rebuild((b) => b
    ..selectedIds = null
    ..filter = null
    ..filterClearedAt = DateTime.now().millisecondsSinceEpoch);
}

ListUIState _filterNotificationsByState(
    ListUIState notificationListState, FilterNotificationsByState action) {
  if (notificationListState.stateFilters.contains(action.state)) {
    return notificationListState.rebuild((b) => b
      ..stateFilters.clear()
      ..stateFilters.add(EntityState.active));
  } else {
    return notificationListState.rebuild((b) => b
      ..stateFilters.clear()
      ..stateFilters.add(action.state));
  }
}

ListUIState _filterNotifications(
    ListUIState notificationListState, FilterNotifications action) {
  return notificationListState.rebuild((b) => b
    ..filter = action.filter
    ..filterClearedAt = action.filter == null
        ? DateTime.now().millisecondsSinceEpoch
        : notificationListState.filterClearedAt);
}

ListUIState _sortNotifications(
    ListUIState notificationListState, SortNotifications action) {
  return notificationListState.rebuild((b) => b
    ..sortAscending = b.sortField != action.field || !b.sortAscending!
    ..sortField = action.field);
}

ListUIState _startListMultiselect(
    ListUIState productListState, StartNotificationMultiselect action) {
  return productListState.rebuild((b) => b..selectedIds = ListBuilder());
}

ListUIState _addToListMultiselect(
    ListUIState productListState, AddToNotificationMultiselect action) {
  return productListState.rebuild((b) => b..selectedIds.add(action.entity.id));
}

ListUIState _removeFromListMultiselect(
    ListUIState productListState, RemoveFromNotificationMultiselect action) {
  return productListState
      .rebuild((b) => b..selectedIds.remove(action.entity.id));
}

ListUIState _clearListMultiselect(
    ListUIState productListState, ClearNotificationMultiselect action) {
  return productListState.rebuild((b) => b..selectedIds = null);
}

final notificationsReducer = combineReducers<NotificationState>([
  TypedReducer<NotificationState, SaveNotificationSuccess>(_updateNotification),
  TypedReducer<NotificationState, AddNotificationSuccess>(_addNotification),
  TypedReducer<NotificationState, LoadNotificationsSuccess>(
      _setLoadedNotifications),
  TypedReducer<NotificationState, LoadNotificationSuccess>(
      _setLoadedNotification),
  TypedReducer<NotificationState, UpdateLastDocumentAction>(
      _updateLastDocument),
  TypedReducer<NotificationState, UpdateNotificationFilter>(
      _updateNotificationFilter),
  // TypedReducer<NotificationState, LoadCompanySuccess>(_setLoadedCompany), //uncomment this if you its dependant on selected company
  TypedReducer<NotificationState, ArchiveNotificationsSuccess>(
      _archiveNotificationSuccess),
  TypedReducer<NotificationState, DeleteNotificationsSuccess>(
      _deleteNotificationSuccess),
  TypedReducer<NotificationState, PurgeNotificationsSuccess>(
      _purgeNotificationSuccess),
  TypedReducer<NotificationState, RestoreNotificationsSuccess>(
      _restoreNotificationSuccess),
  TypedReducer<NotificationState, SaveFcmTokenSuccess>(_saveFcmTokenSuccess),
]);

NotificationState _saveFcmTokenSuccess(
    NotificationState state, SaveFcmTokenSuccess action) {
  return state.rebuild((b) => b..currentFcmToken = action.fcmToken);
}

NotificationState _archiveNotificationSuccess(
    NotificationState notificationState, ArchiveNotificationsSuccess action) {
  final int currentTime = DateTime.now().millisecondsSinceEpoch;
  return notificationState.rebuild((b) {
    for (final notification in action.notifications) {
      b.map[notification.id] = notificationState.map[notification.id]!
          .rebuild((b) => b..archivedAt = currentTime);
    }
  });
}

NotificationState _updateNotificationFilter(
    NotificationState notificationState, UpdateNotificationFilter action) {
  return notificationState
      .rebuild((b) => b..filter = action.filter.toBuilder());
}

// NotificationState _deleteNotificationSuccess(NotificationState notificationState, DeleteNotificationsSuccess action) {
//   return notificationState.rebuild((b) {
//     for (final notification in action.notifications) {
//       b.map[notification.id] = notification;
//     }
//   });
// }

NotificationState _deleteNotificationSuccess(
    NotificationState notificationState, DeleteNotificationsSuccess action) {
  return notificationState.rebuild((b) {
    for (final notification in action.notifications) {
      b.map[notification.id] = notificationState.map[notification.id]!
          .rebuild((b) => b..isDeleted = true);
    }
  });
}

NotificationState _purgeNotificationSuccess(
    NotificationState notificationState, PurgeNotificationsSuccess action) {
  return notificationState.rebuild((b) {
    for (final notification in action.notifications) {
      b.map.remove(notification.id);
      b.list.remove(notification.id);
    }
  });
}

NotificationState _restoreNotificationSuccess(
    NotificationState notificationState, RestoreNotificationsSuccess action) {
  return notificationState.rebuild((b) {
    for (final notification in action.notifications) {
      b.map[notification.id] =
          notificationState.map[notification.id]!.rebuild((b) => b
            ..isDeleted = false
            ..archivedAt = 0);
    }
  });
}

NotificationState _addNotification(
    NotificationState notificationState, AddNotificationSuccess action) {
  return notificationState.rebuild((b) => b
    ..map[action.notification.id] = action.notification
    ..list.add(action.notification.id));
}

NotificationState _updateNotification(
    NotificationState notificationState, SaveNotificationSuccess action) {
  return notificationState
      .rebuild((b) => b..map[action.notification.id] = action.notification);
}

NotificationState _updateLastDocument(
    NotificationState notificationState, UpdateLastDocumentAction action) {
  return notificationState
      .rebuild((b) => b..lastDocument = action.lastDocument);
}

NotificationState _setLoadedNotification(
    NotificationState notificationState, LoadNotificationSuccess action) {
  return notificationState
      .rebuild((b) => b..map[action.notification.id] = action.notification);
}

NotificationState _setLoadedNotifications(
    NotificationState notificationState, LoadNotificationsSuccess action) {
  return notificationState.rebuild((b) {
    action.notifications.forEach((notification) {
      b.map[notification.id] = notification;
      if (!b.list.build().contains(notification.id)) {
        b.list.add(notification.id);
      }
    });
  });
}

// NotificationState _setLoadedCompany(NotificationState notificationState, LoadCompanySuccess action) {
//   final company = action.userCompany.company;
//   return notificationState.loadNotifications(company.notifications);
// }
