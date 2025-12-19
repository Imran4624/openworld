import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_boilerplate/project_config.dart';
import 'package:flutter_boilerplate/services/push_notifications/fcm_pus_notification_service.dart';
import 'package:flutter_boilerplate/services/push_notifications/firebase_messaging_service.dart';
import 'package:redux/redux.dart';
import 'package:built_collection/built_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_boilerplate/main_app.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/ui/ui_actions.dart';
import 'package:flutter_boilerplate/ui/notification/notification_screen.dart';
import 'package:flutter_boilerplate/ui/notification/edit/notification_edit_vm.dart';
import 'package:flutter_boilerplate/ui/notification/view/notification_view_vm.dart';
import 'package:flutter_boilerplate/redux/notification/notification_actions.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/data/repositories/notification_repository.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'dart:convert';

List<Middleware<AppState>> createStoreNotificationsMiddleware([
  NotificationRepository repository = const NotificationRepository(),
]) {
  final fcmService = FcmService();
  final viewNotificationList = _viewNotificationList();
  final viewNotification = _viewNotification();
  final editNotification = _editNotification();
  final loadNotifications = _loadNotifications(repository);
  final loadNotification = _loadNotification(repository);
  final saveNotification = _saveNotification(repository);
  final archiveNotification = _archiveNotification(repository);
  final deleteNotification = _deleteNotification(repository);
  final purgeNotification = _purgeNotification(repository);
  final restoreNotification = _restoreNotification(repository);
  final updateFilter = _updateFilter(repository);
  final registerDevice = _registerDevice(repository);
  final sendNotification = _sendNotification(repository, fcmService);
  final saveFcmToken = _saveFcmToken(repository);
  final removeFcmToken = _removeFcmToken(repository);
  final sendEmail = _sendEmail(repository);
  return [
    TypedMiddleware<AppState, ViewNotificationList>(viewNotificationList),
    TypedMiddleware<AppState, ViewNotification>(viewNotification),
    TypedMiddleware<AppState, EditNotification>(editNotification),
    TypedMiddleware<AppState, LoadNotifications>(loadNotifications),
    TypedMiddleware<AppState, LoadNotification>(loadNotification),
    TypedMiddleware<AppState, SaveNotificationRequest>(saveNotification),
    TypedMiddleware<AppState, ArchiveNotificationsRequest>(archiveNotification),
    TypedMiddleware<AppState, DeleteNotificationsRequest>(deleteNotification),
    TypedMiddleware<AppState, PurgeNotificationsRequest>(purgeNotification),
    TypedMiddleware<AppState, RestoreNotificationsRequest>(restoreNotification),
    TypedMiddleware<AppState, UpdateNotificationFilter>(updateFilter),
    TypedMiddleware<AppState, RegisterDeviceRequest>(registerDevice),
    TypedMiddleware<AppState, SendNotificationAction>(sendNotification),
    TypedMiddleware<AppState, SaveFcmTokenRequest>(saveFcmToken),
    TypedMiddleware<AppState, UnRegisterDeviceRequest>(removeFcmToken),
    TypedMiddleware<AppState, SendEmailAction>(sendEmail),
  ];
}

Middleware<AppState> _editNotification() {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as EditNotification;

    next(action);

    store.dispatch(UpdateCurrentRoute(NotificationEditScreen.route));

    if (store.state.prefState.isMobile) {
      navigatorKey.currentState!.pushNamed(NotificationEditScreen.route);
    }
  };
}

Middleware<AppState> _viewNotification() {
  return (Store<AppState> store, dynamic dynamicAction,
      NextDispatcher next) async {
    final action = dynamicAction as ViewNotification;

    next(action);

    store.dispatch(UpdateCurrentRoute(NotificationViewScreen.route));

    if (store.state.prefState.isMobile) {
      navigatorKey.currentState!.pushNamed(NotificationViewScreen.route);
    }
  };
}

Middleware<AppState> _viewNotificationList() {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as ViewNotificationList;

    next(action);

    if (store.state.staticState.isStale) {
      store.dispatch(RefreshData());
    }

    store.dispatch(UpdateCurrentRoute(NotificationScreen.route));

    if (store.state.prefState.isMobile) {
      navigatorKey.currentState!.pushNamedAndRemoveUntil(
          NotificationScreen.route, (Route<dynamic> route) => false);
    }
  };
}

Middleware<AppState> _archiveNotification(NotificationRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as ArchiveNotificationsRequest;
    final prevNotifications = action.notificationIds
        .map((id) => store.state.notificationState.map[id])
        .whereType<NotificationEntity>()
        .toList();

    repository
        .bulkAction(store.state.credentials, action.notificationIds,
            EntityAction.archive)
        .then((List<NotificationEntity> notifications) {
      store.dispatch(ArchiveNotificationsSuccess(notifications));
      action.completer.complete(null);
    }).catchError((Object error) {
      logError(' Error in archiveNotifications middleware: $error');
      store.dispatch(ArchiveNotificationsFailure(prevNotifications));
      action.completer.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _deleteNotification(NotificationRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as DeleteNotificationsRequest;
    final prevNotifications = action.notificationIds
        .map((id) => store.state.notificationState.map[id])
        .whereType<NotificationEntity>()
        .toList();

    repository
        .bulkAction(store.state.credentials, action.notificationIds,
            EntityAction.delete)
        .then((List<NotificationEntity> notifications) {
      store.dispatch(DeleteNotificationsSuccess(notifications));
      action.completer.complete(null);
    }).catchError((Object error) {
      logError(' Error in deleteNotifications middleware: $error');
      store.dispatch(DeleteNotificationsFailure(prevNotifications));
      action.completer.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _purgeNotification(NotificationRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as PurgeNotificationsRequest;
    final prevNotifications = action.notificationIds
        .map((id) => store.state.notificationState.map[id])
        .whereType<NotificationEntity>()
        .toList();

    repository
        .bulkAction(
            store.state.credentials, action.notificationIds, EntityAction.purge)
        .then((List<NotificationEntity> notifications) {
      store.dispatch(PurgeNotificationsSuccess(notifications));
      action.completer.complete(null);
    }).catchError((Object error) {
      logError(' Error in purgeNotifications middleware: $error');
      store.dispatch(PurgeNotificationsFailure(prevNotifications));
      action.completer.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _restoreNotification(NotificationRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as RestoreNotificationsRequest;
    final prevNotifications = action.notificationIds
        .map((id) => store.state.notificationState.map[id])
        .whereType<NotificationEntity>()
        .toList();

    repository
        .bulkAction(store.state.credentials, action.notificationIds,
            EntityAction.restore)
        .then((List<NotificationEntity> notifications) {
      store.dispatch(RestoreNotificationsSuccess(notifications));
      action.completer.complete(null);
    }).catchError((Object error) {
      logError(' Error in restoreNotifications middleware: $error');
      store.dispatch(RestoreNotificationsFailure(prevNotifications));
      action.completer.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _saveNotification(NotificationRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as SaveNotificationRequest;
    repository
        .saveData(store.state.credentials, action.notification!)
        .then((NotificationEntity notification) {
      if (action.notification!.isNew) {
        store.dispatch(AddNotificationSuccess(notification));
      } else {
        store.dispatch(SaveNotificationSuccess(notification));
      }

      action.completer?.complete(notification);
    }).catchError((Object error) {
      logError(' Error in saveNotification middleware: $error');
      store.dispatch(SaveNotificationFailure(error));
      action.completer?.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _loadNotification(NotificationRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as LoadNotification;

    store.dispatch(LoadNotificationRequest());
    repository
        .loadItem(store.state.credentials, action.notificationId!)
        .then((notification) {
      store.dispatch(LoadNotificationSuccess(notification));
      action.completer?.complete(null);
    }).catchError((Object error) {
      logError(' Error in loadNotification middleware: $error');
      store.dispatch(LoadNotificationFailure(error));
      action.completer?.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _loadNotifications(NotificationRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    if (store.state.isLoading) {
      return;
    }

    final action = dynamicAction as LoadNotifications;
    final state = store.state; // Get current state filter from listUIState
    final stateFilters = state.notificationListState.stateFilters;
    final currentFilter = action.filter ?? state.notificationState.filter;

    // Update filter with current state filter from listUIState
    final filter = currentFilter.rebuild((b) {
      if (stateFilters.isNotEmpty) {
        b.stateFilter = stateFilters.first; // Use the first state filter
      } else {
        b.stateFilter = EntityState.active; // Default to active
      }
    });
    store.dispatch(LoadNotificationsRequest(filter: filter));

    var lastDocument = state.notificationState.lastDocument;
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
      final notifications =
          response['notifications'] as BuiltList<NotificationEntity>;
      final newLastDocument = response['lastDocument'] as DocumentSnapshot?;

      store.dispatch(LoadNotificationsSuccess(notifications));
      if (notifications.isNotEmpty) {
        store.dispatch(UpdateLastDocumentAction(newLastDocument));
      }
      action.completer?.complete(null);
    }).catchError((Object error) {
      logError(' Error in loadNotifications middleware: $error');
      store.dispatch(LoadNotificationsFailure(error));
      action.completer?.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _updateFilter(NotificationRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as UpdateNotificationFilter;

    next(action);

    store.dispatch(LoadNotifications(
      filter: action.filter,
      isRefresh: true,
    ));
  };
}

Middleware<AppState> _registerDevice(NotificationRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction,
      NextDispatcher next) async {
    final action = dynamicAction as RegisterDeviceRequest;

    next(action);

    try {
      final firebaseMessagingService = FirebaseMessagingService();
      firebaseMessagingService
          .initialize(navigatorKey.currentContext!)
          .then((_) {
        store.dispatch(RegisterDeviceSuccess());
      }).catchError((e) {
        logError(' Error Notification initialization $e ');
        store.dispatch(RegisterDeviceFailure(e));
      });
    } catch (e) {
      logError(' Error Notification initialization $e ');
      store.dispatch(RegisterDeviceFailure(e));
    }
  };
}

Middleware<AppState> _sendNotification(
    NotificationRepository repository, FcmService fcmService) {
  return (Store<AppState> store, dynamic dynamicAction,
      NextDispatcher next) async {
    final action = dynamicAction as SendNotificationAction;

    try {
      final recipientFcmTokens =
          await repository.getUserFcmTokens(action.sendTo);

      if (recipientFcmTokens.isEmpty) {
        logWarning(
            'Cannot send notification: No FCM tokens found for user ${action.sendTo}');
        next(action);
        return;
      }

      int successCount = 0;

      for (final deviceToken in recipientFcmTokens) {
        String tokenPreview = deviceToken.length > 20
            ? deviceToken.substring(0, 20) + '...'
            : deviceToken;

        bool isWebToken = fcmService.isWebToken(deviceToken);

        final result = await fcmService.sendNotification(
          fcmToken: deviceToken,
          title: action.title,
          body: action.body,
          data: action.data,
          isWebToken: isWebToken,
        );

        if (result['success']) {
          logInfo('Successfully sent notification to: $tokenPreview');
          successCount++;
        } else {
          logError(
              'Failed to send notification to $tokenPreview: ${result['error']}');

          final error = result['error'];
          if (error != null && error is String) {
            try {
              final errorJson = jsonDecode(error);
              final errorDetails = errorJson['error'];

              if (errorDetails != null) {
                final errorCode = errorDetails['status'];

                if (errorCode == 'INVALID_ARGUMENT' ||
                    errorCode == 'NOT_FOUND' ||
                    errorCode == 'PERMISSION_DENIED' ||
                    errorCode == 'UNREGISTERED') {
                  logInfo('Removing invalid token: $tokenPreview');
                  await repository.removeFcmToken(action.sendTo, deviceToken);
                }
              }
            } catch (parseError) {
              if (error.contains('InvalidRegistration') ||
                  error.contains('NotRegistered') ||
                  error.contains('invalid token')) {
                logInfo('Removing invalid token: $tokenPreview');
                await repository.removeFcmToken(action.sendTo, deviceToken);
              }
            }
          }
        }
      }

      logInfo(
          'Notification sent to $successCount/${recipientFcmTokens.length} devices');
    } catch (e) {
      logError('Error sending notification: $e');
    }

    next(action);
  };
}

Middleware<AppState> _saveFcmToken(NotificationRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction,
      NextDispatcher next) async {
    final action = dynamicAction as SaveFcmTokenRequest;
    final state = store.state;
    final currentUser = state.profileState.loggedInUserProfile;

    if (currentUser == null) {
      store.dispatch(SaveFcmTokenFailure('User not logged in'));
      return;
    }

    try {
      await repository.saveFcmToken(currentUser.id, action.fcmToken);
      store.dispatch(SaveFcmTokenSuccess(fcmToken: action.fcmToken));
    } catch (error) {
      logError('Error saving FCM token: $error');
      store.dispatch(SaveFcmTokenFailure(error));
    }

    next(action);
  };
}

Middleware<AppState> _removeFcmToken(NotificationRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction,
      NextDispatcher next) async {
    final action = dynamicAction as UnRegisterDeviceRequest;
    final state = store.state;
    final currentUser = state.profileState.loggedInUserProfile;
    final fcmToken = store.state.notificationState.currentFcmToken;
    if (currentUser == null) {
      store.dispatch(RemoveFcmTokenFailure('User not logged in'));
      return;
    }

    try {
      await repository.removeFcmToken(currentUser.id, fcmToken);
      store.dispatch(RemoveFcmTokenSuccess());
    } catch (error) {
      printL('Error removing FCM token: $error');
      store.dispatch(RemoveFcmTokenFailure(error));
    }

    next(action);
  };
}

Middleware<AppState> _sendEmail(NotificationRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) async {
    next(action);

    if (action is SendEmailAction) {
      try {
        final response = await repository.sendEmail(
          toEmail: action.emailMessage.to!,
          message: action.emailMessage.body!,
          authToken: store.state.token,
          subject: action.emailMessage.subject!,
        );

        if (response['statusCode'] == 200) {
          logInfo(
              'Email sent successFully ==> to ${response['body']['messageId']} body => ${response['body']}');
          next(EmailSentSuccess(response['body']['messageId']));
        } else {
          logError(
              ' Email sent Error ==> error: ${response['body']['error'] ?? 'Failed to send email'} body => ${response['body']}');
          next(EmailSentFailure(
            response['body']['error'] ?? 'Failed to send email',
          ));
        }
      } catch (e) {
        next(EmailSentFailure(e.toString()));
      }
    }
  };
}
