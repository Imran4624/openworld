import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/redux/ui/ui_actions.dart';
import 'package:redux/redux.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/ui/app/dialogs/error_dialog.dart';
import 'package:flutter_boilerplate/redux/event/event_actions.dart';
import 'package:flutter_boilerplate/ui/event/edit/event_edit.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_boilerplate/utils/localization.dart';
import 'package:flutter_boilerplate/ui/dynamic_fields/dynamic_fields_presenter.dart';
import 'package:flutter_boilerplate/services/payment_handler.dart';

class EventEditScreen extends StatelessWidget {
  const EventEditScreen({super.key});
  static const String route = '/event/edit';

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, EventEditVM>(
      converter: (Store<AppState> store) {
        return EventEditVM.fromStore(store);
      },
      builder: (context, viewModel) {
        return EventEdit(
          viewModel: viewModel,
          key: ValueKey(viewModel.event.updatedAt),
        );
      },
    );
  }
}

class EventEditVM {
  EventEditVM({
    required this.state,
    required this.event,
    this.company,
    required this.onChanged,
    required this.isSaving,
    this.origEvent,
    required this.onSavePressed,
    required this.onCancelPressed,
    required this.isLoading,
  });

  factory EventEditVM.fromStore(Store<AppState> store) {
    final state = store.state;
    final authState = state.authState;
    final username = authState.currentUserName;
    final currentUserId = authState.currentUserId; 
    
    String? getThumbnailUrl() {
      try {
        final dynamicFields = state.profileState.loggedInUserProfile.dynamicFields;
        final List<String> imageUrls = dynamicFields.getImages('images');
        return imageUrls.isNotEmpty ? imageUrls.first : null;
      } catch (e) {
        return null;
      }
    }
    
    final createdByObj = {
      'thumbnail': getThumbnailUrl(),
      'username': username,
      'userId': currentUserId,
    };
    final event = (state.eventUIState.editing ?? EventEntity())
        .rebuild((b) => b..createdByObj = createdByObj);

    return EventEditVM(
      state: state,
      isLoading: state.isLoading,
      isSaving: state.isSaving,
      origEvent: state.eventState.map[event.id],
      event: event,
      company: state.company,
      onChanged: (EventEntity event) {
        store.dispatch(
            UpdateEvent(event.rebuild((b) => b..createdByObj = createdByObj)));
      },
      onCancelPressed: (BuildContext context) {
        createEntity(entity: EventEntity(), force: true);
        if (state.eventUIState.cancelCompleter != null) {
          state.eventUIState.cancelCompleter!.complete();
        } else {
          store.dispatch(UpdateCurrentRoute(state.uiState.previousRoute));
        }
      },
      onSavePressed: (BuildContext context) async {
        final state = store.state;
        final authState = state.authState;
        final username = authState.currentUserName;
        
        final createdByObj = {
          'thumbnail': getThumbnailUrl(),
          'username': username,
          'userId': currentUserId,
        };
        final event = (store.state.eventUIState.editing ?? EventEntity())
            .rebuild((b) => b..createdByObj = createdByObj);

        if (event.isNew) {
          final currentEventCount = state.eventState.list.where((eventId) {
            final existingEvent = state.eventState.map[eventId];
            return existingEvent?.createdUserId == currentUserId;
          }).length;

          final completer = Completer<EventEntity>();
          
          PaymentHandler.handleEventCreationAction(
            context,
            currentEventCount: currentEventCount,
            onCreate: () {
              _performEventSave(context, store, event, completer);
            },
            onPaymentSuccess: () {
              _performEventSave(context, store, event, completer);
            },
          );

          return completer.future;
        } else {
          final completer = Completer<EventEntity>();
          _performEventSave(context, store, event, completer);
          return completer.future;
        }
      },
    );
  }

  final EventEntity event;
  final CompanyEntity? company;
  final Function(EventEntity) onChanged;
  final Future<EventEntity> Function(BuildContext) onSavePressed;
  final Function(BuildContext) onCancelPressed;
  final bool isLoading;
  final bool isSaving;
  final EventEntity? origEvent;
  final AppState state;

  static void _performEventSave(
    BuildContext context,
    Store<AppState> store,
    EventEntity event,
    Completer<EventEntity> completer,
  ) {
    final localization = AppLocalization.of(context)!;

    store.dispatch(SaveEventRequest(
        completer: completer,
        event: event));

    completer.future.then((savedEvent) {
      showToast(event.isNew
          ? localization.createdEvent
          : localization.updatedEvent);
      viewEntity(entity: savedEvent, force: true);
    }).catchError((error) {
      showDialog<ErrorDialog>(
          context: context,
          builder: (BuildContext context) {
            return ErrorDialog(error);
          });
    });
  }
}
