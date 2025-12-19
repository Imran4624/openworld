import 'dart:async';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_boilerplate/config/entity_state_config.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/utils/completers.dart';
import 'package:flutter_boilerplate/utils/localization.dart';
import 'package:flutter_boilerplate/ui/app/entities/entity_actions_dialog.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';

class ViewEventList implements PersistUI {
  ViewEventList({this.force = false, this.page = 0});

  final bool force;
  final int page;

  @override
  String toString() {
    return 'ViewEventList';
  }
}

class ViewEvent implements PersistUI, PersistPrefs {
  ViewEvent({
    this.eventId,
    this.force = false,
  });

  final String? eventId;
  final bool force;

  @override
  String toString() {
    return 'ViewEvent';
  }
}

class EditEvent implements PersistUI, PersistPrefs {
  EditEvent({
    required this.event,
    this.completer,
    this.force = false,
  });

  final EventEntity event;
  final Completer? completer;
  final bool force;

  @override
  String toString() {
    return 'EditEvent';
  }
}

class UpdateEvent implements PersistUI {
  UpdateEvent(this.event);

  final EventEntity event;

  @override
  String toString() {
    return 'UpdateEvent';
  }
}

class LoadEvent {
  LoadEvent({this.completer, this.eventId});

  final Completer? completer;
  final String? eventId;

  @override
  String toString() {
    return 'LoadEvent';
  }
}

class LoadEventActivity {
  LoadEventActivity({this.completer, this.eventId});

  final Completer? completer;
  final String? eventId;

  @override
  String toString() {
    return 'LoadEventActivity';
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

class LoadEventRequest implements StartLoading {
  @override
  String toString() {
    return 'LoadEventRequest';
  }
}

class LoadEventFailure implements StopLoading {
  LoadEventFailure(this.error);

  final dynamic error;

  @override
  String toString() {
    return 'LoadEventFailure{error: $error}';
  }
}

class LoadEventSuccess implements StopLoading, PersistData {
  LoadEventSuccess(this.event);

  final EventEntity event;

  @override
  String toString() {
    return 'LoadEventSuccess';
  }
}

class ChatWithAi {
  ChatWithAi({
    this.completer, 
    this.message,
    this.userLatitude,
    this.userLongitude,
    this.userLocationName,
  });

  final Completer? completer;
  final String? message;
  final double? userLatitude;
  final double? userLongitude;
  final String? userLocationName;

  @override
  String toString() {
    return 'ChatWithAi';
  }
}

class ChatWithAiRequest implements StartLoading {
  @override
  String toString() {
    return 'ChatWithAiRequest';
  }
}

class ChatWithAiFailure implements StopLoading {
  ChatWithAiFailure(this.error);

  final dynamic error;

  @override
  String toString() {
    return 'ChatWithAiFailure{error: $error}';
  }
}

class ChatWithAiSuccess implements StopLoading, PersistData {
  ChatWithAiSuccess(this.events, {this.mapBounds});

  final List<EventEntity> events;
  final Map<String, double>? mapBounds;

  @override
  String toString() {
    return 'ChatWithAiSuccess';
  }
}

// class LoadEventsRequest implements StartLoading {}

class LoadEventsFailure implements StopLoading {
  LoadEventsFailure(this.error);

  final dynamic error;

  @override
  String toString() {
    return 'LoadEventsFailure{error: $error}';
  }
}

class LoadEventsSuccess implements StopLoading {
  LoadEventsSuccess(this.events,
      {this.isRefresh = false,
      this.myEventsOnly = false,
      this.currentUserEmail = ''});

  final BuiltList<EventEntity> events;
  final bool isRefresh;
  final bool myEventsOnly;
  final String currentUserEmail;

  @override
  String toString() {
    return 'LoadEventsSuccess';
  }
}

class PurchaseTicketRequest implements StartSaving {
  PurchaseTicketRequest({
    required this.completer,
    required this.event,
    required this.ticketType,
  });

  final Completer completer;
  final EventEntity event;
  final dynamic ticketType;

  @override
  String toString() {
    return 'PurchaseTicketRequest';
  }
}

class SaveEventRequest implements StartSaving {
  SaveEventRequest({this.completer, this.event, this.isPreview = false, this.isViewEvent = true});

  final Completer? completer;
  final EventEntity? event;
  final bool isPreview;
  final bool isViewEvent;

  @override
  String toString() {
    return 'SaveEventRequest';
  }
}

class SaveEventSuccess implements StopSaving, PersistData, PersistUI {
  SaveEventSuccess(this.event);

  final EventEntity event;

  @override
  String toString() {
    return 'SaveEventSuccess';
  }
}

class AddEventSuccess implements StopSaving, PersistData, PersistUI {
  AddEventSuccess(this.event, {this.isPreview = false});

  final EventEntity event;
  final bool isPreview;

  @override
  String toString() {
    return 'AddEventSuccess';
  }
}

class SaveEventFailure implements StopSaving {
  SaveEventFailure(this.error);

  final Object error;

  @override
  String toString() {
    return 'SaveEventFailure{error: $error}';
  }
}

class ArchiveEventsRequest implements StartSaving {
  ArchiveEventsRequest(this.completer, this.eventIds);

  final Completer completer;
  final List<String> eventIds;

  @override
  String toString() {
    return 'ArchiveEventsRequest';
  }
}

class ArchiveEventsSuccess implements StopSaving, PersistData {
  ArchiveEventsSuccess(this.events);

  final List<EventEntity> events;

  @override
  String toString() {
    return 'ArchiveEventsSuccess';
  }
}

class ArchiveEventsFailure implements StopSaving {
  ArchiveEventsFailure(this.events);

  final List<EventEntity> events;

  @override
  String toString() {
    return 'ArchiveEventsFailure{events: $events}';
  }
}

class DeleteEventsRequest implements StartSaving {
  DeleteEventsRequest(this.completer, this.eventIds);

  final Completer completer;
  final List<String> eventIds;

  @override
  String toString() {
    return 'DeleteEventsRequest';
  }
}

class PurgeEventsRequest implements StartSaving {
  PurgeEventsRequest(this.completer, this.eventIds);

  final Completer completer;
  final List<String> eventIds;

  @override
  String toString() {
    return 'PurgeEventsRequest';
  }
}

class DeleteEventsSuccess implements StopSaving, PersistData {
  DeleteEventsSuccess(this.events);

  final List<EventEntity> events;

  @override
  String toString() {
    return 'DeleteEventsSuccess';
  }
}

class PurgeEventsSuccess implements StopSaving, PersistData {
  PurgeEventsSuccess(this.events);

  final List<EventEntity> events;

  @override
  String toString() {
    return 'PurgeEventsSuccess';
  }
}

class DeleteEventsFailure implements StopSaving {
  DeleteEventsFailure(this.events);

  final List<EventEntity> events;

  @override
  String toString() {
    return 'DeleteEventsFailure{events: $events}';
  }
}

class PurgeEventsFailure implements StopSaving {
  PurgeEventsFailure(this.events);

  final List<EventEntity> events;

  @override
  String toString() {
    return 'PurgeEventsFailure{events: $events}';
  }
}

class RestoreEventsRequest implements StartSaving {
  RestoreEventsRequest(this.completer, this.eventIds);

  final Completer completer;
  final List<String> eventIds;

  @override
  String toString() {
    return 'RestoreEventsRequest';
  }
}

class RestoreEventsSuccess implements StopSaving, PersistData {
  RestoreEventsSuccess(this.events);

  final List<EventEntity> events;

  @override
  String toString() {
    return 'RestoreEventsSuccess';
  }
}

class RestoreEventsFailure implements StopSaving {
  RestoreEventsFailure(this.events);

  final List<EventEntity> events;

  @override
  String toString() {
    return 'RestoreEventsFailure{events: $events}';
  }
}

class SaveEventOperation {
  SaveEventOperation({
    required this.eventId,
    required this.userId,
    required this.eventOperationType,
    this.completer,
  });

  final String eventId;
  final String userId;
  final int eventOperationType; 
  final Completer? completer;

  @override
  String toString() {
    return 'EventOperation{eventId: $eventId, userId: $userId, eventOperationType: $eventOperationType}';
  }
}

class SaveEventOperationRequest implements StartLoading {
  SaveEventOperationRequest({
    required this.eventId,
    required this.userId,
    required this.eventOperationType,
    this.completer,
  });

  final String eventId;
  final String userId;
  final int eventOperationType;
  final Completer? completer;

  @override
  String toString() {
    return 'SaveEventOperationRequest';
  }
}

class EventOperationSuccess implements StopLoading, PersistData {
  EventOperationSuccess({
    required this.event,
    required this.eventOperationType,
  });

  final EventEntity event;
  final int eventOperationType;

  @override
  String toString() {
    return 'EventOperationSuccess';
  }
}

class EventOperationFailure implements StopLoading {
  EventOperationFailure(this.error);

  final dynamic error;

  @override
  String toString() {
    return 'EventOperationFailure{error: $error}';
  }
}

class FilterEvents implements PersistUI {
  FilterEvents(this.filter);

  final String filter;

  @override
  String toString() {
    return 'FilterEvents';
  }
}

class SortEvents implements PersistUI, PersistPrefs {
  SortEvents(this.field);

  final String field;

  @override
  String toString() {
    return 'SortEvents';
  }
}

class FilterEventsByState implements PersistUI {
  FilterEventsByState(this.state);

  final EntityState state;

  @override
  String toString() {
    return 'FilterEventsByState';
  }
}

// class FilterEventsByCustom1 implements PersistUI {
//   FilterEventsByCustom1(this.value);

//   final String value;
// }

// class FilterEventsByCustom2 implements PersistUI {
//   FilterEventsByCustom2(this.value);

//   final String value;
// }

// class FilterEventsByCustom3 implements PersistUI {
//   FilterEventsByCustom3(this.value);

//   final String value;
// }

// class FilterEventsByCustom4 implements PersistUI {
//   FilterEventsByCustom4(this.value);

//   final String value;
// }

class StartEventMultiselect {
  StartEventMultiselect();

  @override
  String toString() {
    return 'StartEventMultiselect';
  }
}

class AddToEventMultiselect {
  AddToEventMultiselect({required this.entity});

  final BaseEntity entity;

  @override
  String toString() {
    return 'AddToEventMultiselect';
  }
}

class RemoveFromEventMultiselect {
  RemoveFromEventMultiselect({required this.entity});

  final BaseEntity entity;

  @override
  String toString() {
    return 'RemoveFromEventMultiselect';
  }
}

class ClearEventMultiselect {
  ClearEventMultiselect();

  @override
  String toString() {
    return 'ClearEventMultiselect';
  }
}

class UpdateEventTab implements PersistUI {
  UpdateEventTab({this.tabIndex});

  final int? tabIndex;

  @override
  String toString() {
    return 'UpdateEventTab';
  }
}

class UpdateEventFilter implements PersistUI {
  UpdateEventFilter(this.filter);
  final EventFilter filter;

  @override
  String toString() {
    return 'UpdateEventFilter';
  }
}

class LoadEvents {
  LoadEvents(
      {this.completer,
      this.filter,
      this.page = 0,
      this.isRefresh = false,
      this.myEventsOnly = false,
      this.currentUserEmail = ''});

  final Completer? completer;
  final EventFilter? filter;
  final int page;
  final bool isRefresh;
  final bool myEventsOnly;
  final String currentUserEmail;

  @override
  String toString() {
    return 'LoadEvents';
  }
}

class FilterEventsByOwnership implements PersistUI {
  FilterEventsByOwnership(this.showMyEventsOnly, this.currentUserEmail);
  final bool showMyEventsOnly;
  final String currentUserEmail;

  @override
  String toString() {
    return 'FilterEventsByOwnership';
  }
}

class LoadEventsRequest implements StartLoading {
  LoadEventsRequest({this.filter});
  final EventFilter? filter;

  @override
  String toString() {
    return 'LoadEventsRequest';
  }
}

void handleEventAction(
    BuildContext context, List<BaseEntity> events, EntityAction action) {
  if (events.isEmpty) {
    return;
  }

  final store = StoreProvider.of<AppState>(context);
  final localization = AppLocalization.of(context)!;
  final event = events.first as EventEntity;
  final eventIds = events.map((event) => event.id).toList();

  switch (action) {
    case EntityAction.edit:
      editEntity(entity: event);
      break;
    case EntityAction.restore:
      store.dispatch(RestoreEventsRequest(
          snackBarCompleter<Null>(EntityStateManager.getRestoreSuccessMessage(
              EntityType.event, event)),
          eventIds));
      break;
    case EntityAction.archive:
      store.dispatch(ArchiveEventsRequest(
          snackBarCompleter<Null>(EntityStateManager.getArchiveSuccessMessage(
              EntityType.event, event)),
          eventIds));
      break;
    case EntityAction.delete:
      store.dispatch(DeleteEventsRequest(
          snackBarCompleter<Null>(EntityStateManager.getDeleteSuccessMessage(
              EntityType.event, event)),
          eventIds));
      break;
    case EntityAction.newPhoto:
      createEntity(
          entity: PhotoEntity(state: store.state)
              .rebuild((b) => b..category = event.name));
      break;
    case EntityAction.purge:
      store.dispatch(PurgeEventsRequest(
          snackBarCompleter<Null>(localization.deletedEvent), eventIds));
      break;
    case EntityAction.toggleMultiselect:
      if (!store.state.eventListState.isInMultiselect()) {
        store.dispatch(StartEventMultiselect());
      }

      if (events.isEmpty) {
        break;
      }

      for (final event in events) {
        if (!store.state.eventListState.isSelected(event.id)) {
          store.dispatch(AddToEventMultiselect(entity: event));
        } else {
          store.dispatch(RemoveFromEventMultiselect(entity: event));
        }
      }
      break;
    case EntityAction.more:
      showEntityActionsDialog(
        entities: [event],
      );
      break;
    default:
  logError('unhandled action $action in event_actions');
      break;
  }
}
