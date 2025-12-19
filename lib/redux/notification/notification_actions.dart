import 'dart:async';
import 'package:flutter_boilerplate/services/validators/emailValidator.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/utils/completers.dart';
import 'package:flutter_boilerplate/utils/localization.dart';
import 'package:flutter_boilerplate/ui/app/entities/entity_actions_dialog.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';

class ViewNotificationList implements PersistUI {
  ViewNotificationList({this.force = false, this.page = 0});

  final bool force;
  final int page;

  @override
  String toString() {
    return 'ViewNotificationList';
  }
}

class ViewNotification implements PersistUI, PersistPrefs {
  ViewNotification({
    this.notificationId,
    this.force = false,
  });

  final String? notificationId;
  final bool force;

  @override
  String toString() {
    return 'ViewNotification';
  }
}

class EditNotification implements PersistUI, PersistPrefs {
  EditNotification({
    required this.notification,
    this.completer,
    this.force = false,
  });

  final NotificationEntity notification;
  final Completer? completer;
  final bool force;

  @override
  String toString() {
    return 'EditNotification';
  }
}

class UpdateNotification implements PersistUI {
  UpdateNotification(this.notification);

  final NotificationEntity notification;

  @override
  String toString() {
    return 'UpdateNotification';
  }
}

class LoadNotification {
  LoadNotification({this.completer, this.notificationId});

  final Completer? completer;
  final String? notificationId;

  @override
  String toString() {
    return 'LoadNotification';
  }
}

class LoadNotificationActivity {
  LoadNotificationActivity({this.completer, this.notificationId});

  final Completer? completer;
  final String? notificationId;

  @override
  String toString() {
    return 'LoadNotificationActivity';
  }
}

class UpdateLastDocumentAction {
  UpdateLastDocumentAction(this.lastDocument);
  final DocumentSnapshot? lastDocument;

  @override
  String toString() {
    return 'UpdateLastDocumentAction';
  }
}

class LoadNotificationRequest implements StartLoading {
  @override
  String toString() {
    return 'LoadNotificationRequest';
  }
}

class LoadNotificationFailure implements StopLoading {
  LoadNotificationFailure(this.error);

  final dynamic error;

  @override
  String toString() {
    return 'LoadNotificationFailure{error: $error}';
  }
}

class LoadNotificationSuccess implements StopLoading, PersistData {
  LoadNotificationSuccess(this.notification);

  final NotificationEntity notification;

  @override
  String toString() {
    return 'LoadNotificationSuccess';
  }
}

// class LoadNotificationsRequest implements StartLoading {}

class LoadNotificationsFailure implements StopLoading {
  LoadNotificationsFailure(this.error);

  final dynamic error;

  @override
  String toString() {
    return 'LoadNotificationsFailure{error: $error}';
  }
}

class LoadNotificationsSuccess implements StopLoading {
  LoadNotificationsSuccess(this.notifications);

  final BuiltList<NotificationEntity> notifications;

  @override
  String toString() {
    return 'LoadNotificationsSuccess';
  }
}

class SaveNotificationRequest implements StartSaving {
  SaveNotificationRequest({this.completer, this.notification});

  final Completer? completer;
  final NotificationEntity? notification;

  @override
  String toString() {
    return 'SaveNotificationRequest';
  }
}

class SaveNotificationSuccess implements StopSaving, PersistData, PersistUI {
  SaveNotificationSuccess(this.notification);

  final NotificationEntity notification;

  @override
  String toString() {
    return 'SaveNotificationSuccess';
  }
}

class AddNotificationSuccess implements StopSaving, PersistData, PersistUI {
  AddNotificationSuccess(this.notification);

  final NotificationEntity notification;

  @override
  String toString() {
    return 'AddNotificationSuccess';
  }
}

class SaveNotificationFailure implements StopSaving {
  SaveNotificationFailure(this.error);

  final Object error;

  @override
  String toString() {
    return 'SaveNotificationFailure{error: $error}';
  }
}

class ArchiveNotificationsRequest implements StartSaving {
  ArchiveNotificationsRequest(this.completer, this.notificationIds);

  final Completer completer;
  final List<String> notificationIds;

  @override
  String toString() {
    return 'ArchiveNotificationsRequest';
  }
}

class ArchiveNotificationsSuccess implements StopSaving, PersistData {
  ArchiveNotificationsSuccess(this.notifications);

  final List<NotificationEntity> notifications;

  @override
  String toString() {
    return 'ArchiveNotificationsSuccess';
  }
}

class ArchiveNotificationsFailure implements StopSaving {
  ArchiveNotificationsFailure(this.notifications);

  final List<NotificationEntity> notifications;

  @override
  String toString() {
    return 'ArchiveNotificationsFailure{notifications: $notifications}';
  }
}

class DeleteNotificationsRequest implements StartSaving {
  DeleteNotificationsRequest(this.completer, this.notificationIds);

  final Completer completer;
  final List<String> notificationIds;

  @override
  String toString() {
    return 'DeleteNotificationsRequest';
  }
}

class PurgeNotificationsRequest implements StartSaving {
  PurgeNotificationsRequest(this.completer, this.notificationIds);

  final Completer completer;
  final List<String> notificationIds;

  @override
  String toString() {
    return 'PurgeNotificationsRequest';
  }
}

class DeleteNotificationsSuccess implements StopSaving, PersistData {
  DeleteNotificationsSuccess(this.notifications);

  final List<NotificationEntity> notifications;

  @override
  String toString() {
    return 'DeleteNotificationsSuccess';
  }
}

class PurgeNotificationsSuccess implements StopSaving, PersistData {
  PurgeNotificationsSuccess(this.notifications);

  final List<NotificationEntity> notifications;

  @override
  String toString() {
    return 'PurgeNotificationsSuccess';
  }
}

class DeleteNotificationsFailure implements StopSaving {
  DeleteNotificationsFailure(this.notifications);

  final List<NotificationEntity> notifications;

  @override
  String toString() {
    return 'DeleteNotificationsFailure{notifications: $notifications}';
  }
}

class PurgeNotificationsFailure implements StopSaving {
  PurgeNotificationsFailure(this.notifications);

  final List<NotificationEntity> notifications;

  @override
  String toString() {
    return 'PurgeNotificationsFailure{notifications: $notifications}';
  }
}

class RestoreNotificationsRequest implements StartSaving {
  RestoreNotificationsRequest(this.completer, this.notificationIds);

  final Completer completer;
  final List<String> notificationIds;

  @override
  String toString() {
    return 'RestoreNotificationsRequest';
  }
}

class RestoreNotificationsSuccess implements StopSaving, PersistData {
  RestoreNotificationsSuccess(this.notifications);

  final List<NotificationEntity> notifications;

  @override
  String toString() {
    return 'RestoreNotificationsSuccess';
  }
}

class RestoreNotificationsFailure implements StopSaving {
  RestoreNotificationsFailure(this.notifications);

  final List<NotificationEntity> notifications;

  @override
  String toString() {
    return 'RestoreNotificationsFailure{notifications: $notifications}';
  }
}

class FilterNotifications implements PersistUI {
  FilterNotifications(this.filter);

  final String filter;

  @override
  String toString() {
    return 'FilterNotifications';
  }
}

class SortNotifications implements PersistUI, PersistPrefs {
  SortNotifications(this.field);

  final String field;

  @override
  String toString() {
    return 'SortNotifications';
  }
}

class FilterNotificationsByState implements PersistUI {
  FilterNotificationsByState(this.state);

  final EntityState state;

  @override
  String toString() {
    return 'FilterNotificationsByState';
  }
}

// class FilterNotificationsByCustom1 implements PersistUI {
//   FilterNotificationsByCustom1(this.value);

//   final String value;
// }

// class FilterNotificationsByCustom2 implements PersistUI {
//   FilterNotificationsByCustom2(this.value);

//   final String value;
// }

// class FilterNotificationsByCustom3 implements PersistUI {
//   FilterNotificationsByCustom3(this.value);

//   final String value;
// }

// class FilterNotificationsByCustom4 implements PersistUI {
//   FilterNotificationsByCustom4(this.value);

//   final String value;
// }

class StartNotificationMultiselect {
  StartNotificationMultiselect();

  @override
  String toString() {
    return 'StartNotificationMultiselect';
  }
}

class AddToNotificationMultiselect {
  AddToNotificationMultiselect({required this.entity});

  final BaseEntity entity;

  @override
  String toString() {
    return 'AddToNotificationMultiselect';
  }
}

class RemoveFromNotificationMultiselect {
  RemoveFromNotificationMultiselect({required this.entity});

  final BaseEntity entity;

  @override
  String toString() {
    return 'RemoveFromNotificationMultiselect';
  }
}

class ClearNotificationMultiselect {
  ClearNotificationMultiselect();

  @override
  String toString() {
    return 'ClearNotificationMultiselect';
  }
}

class UpdateNotificationTab implements PersistUI {
  UpdateNotificationTab({this.tabIndex});

  final int? tabIndex;

  @override
  String toString() {
    return 'UpdateNotificationTab';
  }
}

class UpdateNotificationFilter implements PersistUI {
  UpdateNotificationFilter(this.filter);
  final NotificationFilter filter;

  @override
  String toString() {
    return 'UpdateNotificationFilter';
  }
}

class LoadNotifications {
  LoadNotifications({
    this.completer,
    this.filter,
    this.page = 0,
    this.isRefresh = false,
  });

  final Completer? completer;
  final NotificationFilter? filter;
  final int page;
  final bool isRefresh;

  @override
  String toString() {
    return 'LoadNotifications';
  }
}

class LoadNotificationsRequest implements StartLoading {
  LoadNotificationsRequest({this.filter});
  final NotificationFilter? filter;

  @override
  String toString() {
    return 'LoadNotificationsRequest';
  }
}

class SendNotificationAction {
  SendNotificationAction({
    required this.title,
    required this.body,
    required this.sendTo,
    this.data,
  });

  final String title;
  final String body;
  final String sendTo;
  final Map<String, dynamic>? data;

  @override
  String toString() {
    return 'SendNotificationAction';
  }
}

class SaveFcmTokenRequest {
  SaveFcmTokenRequest({required this.fcmToken});

  final String fcmToken;

  @override
  String toString() {
    return 'SaveFcmTokenRequest';
  }
}

class SaveFcmTokenSuccess {
  SaveFcmTokenSuccess({required this.fcmToken});
  final String fcmToken;

  @override
  String toString() {
    return 'SaveFcmTokenSuccess';
  }
}

class SaveFcmTokenFailure {
  SaveFcmTokenFailure(this.error);

  final Object error;

  @override
  String toString() {
    return 'SaveFcmTokenFailure{error: $error}';
  }
}


class SendEmailAction {
  final EmailMessage emailMessage;

  SendEmailAction({required this.emailMessage}) {
    if (!EmailValidator.isValid(emailMessage)) {
      logError('Invalid EmailMessage: subject, body, or to is empty');
    }
  }

  @override
  String toString() {
    return 'SendEmailAction';
  }
}

class EmailSentSuccess {
  final String messageId;
  EmailSentSuccess(this.messageId);

  @override
  String toString() {
    return 'EmailSentSuccess';
  }
}

class EmailSentFailure {
  final String error;
  EmailSentFailure(this.error);

  @override
  String toString() {
    return 'EmailSentFailure{error: $error}';
  }
}

class RegisterDeviceRequest {
  @override
  String toString() {
    return 'RegisterDeviceRequest';
  }
}

class RegisterDeviceSuccess {
  @override
  String toString() {
    return 'RegisterDeviceSuccess';
  }
}

class RegisterDeviceFailure {
  RegisterDeviceFailure(this.error);

  final Object error;

  @override
  String toString() {
    return 'RegisterDeviceFailure{error: $error}';
  }
}

class UnRegisterDeviceRequest {
  @override
  String toString() {
    return 'UnRegisterDeviceRequest';
  }
}

class RemoveFcmTokenSuccess {
  @override
  String toString() {
    return 'RemoveFcmTokenSuccess';
  }
}

class RemoveFcmTokenFailure {
  RemoveFcmTokenFailure(this.error);

  final Object error;

  @override
  String toString() {
    return 'RemoveFcmTokenFailure{error: $error}';
  }
}

void handleNotificationAction(
    BuildContext context, List<BaseEntity> notifications, EntityAction action) {
  if (notifications.isEmpty) {
    return;
  }

  final store = StoreProvider.of<AppState>(context);
  final localization = AppLocalization.of(context)!;
  final notification = notifications.first as NotificationEntity;
  final notificationIds =
      notifications.map((notification) => notification.id).toList();

  switch (action) {
    case EntityAction.edit:
      editEntity(entity: notification);
      break;
    case EntityAction.restore:
      store.dispatch(RestoreNotificationsRequest(
          snackBarCompleter<Null>(localization.restoredNotification),
          notificationIds));
      break;
    case EntityAction.archive:
      store.dispatch(ArchiveNotificationsRequest(
          snackBarCompleter<Null>(localization.archivedNotification),
          notificationIds));
      break;
    case EntityAction.delete:
      store.dispatch(DeleteNotificationsRequest(
          snackBarCompleter<Null>(localization.deletedNotification),
          notificationIds));
      break;
    case EntityAction.purge:
      store.dispatch(PurgeNotificationsRequest(
          snackBarCompleter<Null>(localization.deletedNotification),
          notificationIds));
      break;
    case EntityAction.toggleMultiselect:
      if (!store.state.notificationListState.isInMultiselect()) {
        store.dispatch(StartNotificationMultiselect());
      }

      if (notifications.isEmpty) {
        break;
      }

      for (final notification in notifications) {
        if (!store.state.notificationListState.isSelected(notification.id)) {
          store.dispatch(AddToNotificationMultiselect(entity: notification));
        } else {
          store.dispatch(
              RemoveFromNotificationMultiselect(entity: notification));
        }
      }
      break;
    case EntityAction.more:
      showEntityActionsDialog(
        entities: [notification],
      );
      break;
    default:
  logError('unhandled action $action in notification_actions');
      break;
  }
}
