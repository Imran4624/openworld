import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/redux/ui/ui_actions.dart';
import 'package:redux/redux.dart';
import 'package:flutter_boilerplate/utils/completers.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/ui/app/dialogs/error_dialog.dart';
import 'package:flutter_boilerplate/ui/notification/view/notification_view_vm.dart';
import 'package:flutter_boilerplate/redux/notification/notification_actions.dart';
import 'package:flutter_boilerplate/ui/notification/edit/notification_edit.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_boilerplate/utils/localization.dart';

class NotificationEditScreen extends StatelessWidget {
  const NotificationEditScreen({Key? key}) : super(key: key);
  static const String route = '/notification/edit';

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, NotificationEditVM>(
      converter: (Store<AppState> store) {
        return NotificationEditVM.fromStore(store);
      },
      builder: (context, viewModel) {
        return NotificationEdit(
          viewModel: viewModel,
          key: ValueKey(viewModel.notification.updatedAt),
        );
      },
    );
  }
}

class NotificationEditVM {
  NotificationEditVM({
    required this.state,
    required this.notification,
    this.company,
    required this.onChanged,
    required this.isSaving,
    this.origNotification,
    required this.onSavePressed,
    required this.onCancelPressed,
    required this.isLoading,
  });

  factory NotificationEditVM.fromStore(Store<AppState> store) {
    final state = store.state;
    final notification = state.notificationUIState.editing;

    return NotificationEditVM(
      state: state,
      isLoading: state.isLoading,
      isSaving: state.isSaving,
      origNotification: state.notificationState.map[notification!.id],
      notification: notification,
      company: state.company,
      onChanged: (NotificationEntity notification) {
        store.dispatch(UpdateNotification(notification));
      },
      onCancelPressed: (BuildContext context) {
        createEntity(entity: NotificationEntity(), force: true);
        if (state.notificationUIState.cancelCompleter != null) {
          state.notificationUIState.cancelCompleter!.complete();
        } else {
          store.dispatch(UpdateCurrentRoute(state.uiState.previousRoute));
        }
      },
      onSavePressed: (BuildContext context) {
        Debouncer.runOnComplete(() {
          final notification = store.state.notificationUIState.editing!;
          final localization = AppLocalization.of(context)!;
          final Completer<NotificationEntity> completer =
              Completer<NotificationEntity>();
          store.dispatch(SaveNotificationRequest(
              completer: completer, notification: notification));
          return completer.future.then((savedNotification) {
            showToast(notification.isNew
                ? localization.createdNotification
                : localization.updatedNotification);
            if (state.prefState.isMobile) {
              store.dispatch(UpdateCurrentRoute(NotificationViewScreen.route));
              if (notification.isNew) {
                Navigator.of(context)
                    .pushReplacementNamed(NotificationViewScreen.route);
              } else {
                Navigator.of(context).pop(savedNotification);
              }
            } else {
              viewEntity(entity: savedNotification, force: true);
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

  final NotificationEntity notification;
  final CompanyEntity? company;
  final Function(NotificationEntity) onChanged;
  final Function(BuildContext) onSavePressed;
  final Function(BuildContext) onCancelPressed;
  final bool isLoading;
  final bool isSaving;
  final NotificationEntity? origNotification;
  final AppState state;
}
