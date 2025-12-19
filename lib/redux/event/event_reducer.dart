import 'package:redux/redux.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/company/company_actions.dart';
import 'package:flutter_boilerplate/redux/ui/entity_ui_state.dart';
import 'package:flutter_boilerplate/redux/event/event_actions.dart';
import 'package:flutter_boilerplate/redux/ui/list_ui_state.dart';
import 'package:flutter_boilerplate/redux/event/event_state.dart';
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/redux/profile_operation/profile_operation_actions.dart'
    as operations;

EntityUIState eventUIReducer(EventUIState state, dynamic action) {
  return state.rebuild((b) => b
    ..listUIState.replace(eventListReducer(state.listUIState, action))
    ..editing.replace(editingReducer(state.editing, action)!)
    ..selectedId = selectedIdReducer(state.selectedId, action)
    ..forceSelected = forceSelectedReducer(state.forceSelected, action)
    ..tabIndex = tabIndexReducer(state.tabIndex, action));
}

final forceSelectedReducer = combineReducers<bool?>([
  TypedReducer<bool?, ViewEvent>((completer, action) => true),
  TypedReducer<bool?, ViewEventList>((completer, action) => false),
  TypedReducer<bool?, FilterEventsByState>((completer, action) => false),
  TypedReducer<bool?, FilterEvents>((completer, action) => false),
]);

final tabIndexReducer = combineReducers<int?>([
  TypedReducer<int?, UpdateEventTab>((completer, action) => action.tabIndex),
  TypedReducer<int?, PreviewEntity>((completer, action) => 0),
]);

Reducer<String?> selectedIdReducer = combineReducers([
  // TypedReducer<String?, ArchiveEventsSuccess>((completer, action) => ''), // this was unselecting the selected entity from view screen
  // TypedReducer<String?, DeleteEventsSuccess>((completer, action) => ''),
  TypedReducer<String?, PurgeEventsSuccess>((completer, action) => ''),
  TypedReducer<String?, PreviewEntity>((selectedId, action) =>
      action.entityType == EntityType.event ? action.entityId : selectedId),
  TypedReducer<String?, ViewEvent>(
      (String? selectedId, dynamic action) => action.eventId),
  TypedReducer<String?, AddEventSuccess>(
      (String? selectedId, dynamic action) => action.event.id),
  TypedReducer<String?, SelectCompany>(
      (selectedId, action) => action.clearSelection ? '' : selectedId),
  TypedReducer<String?, ClearEntityFilter>((selectedId, action) => ''),
  TypedReducer<String?, SortEvents>((selectedId, action) => ''),
  TypedReducer<String?, FilterEvents>((selectedId, action) => ''),
  TypedReducer<String?, FilterEventsByState>((selectedId, action) => ''),
  TypedReducer<String?, FilterByEntity>(
      (selectedId, action) => action.clearSelection
          ? ''
          : action.entityType == EntityType.event
              ? action.entityId
              : selectedId),
]);

final editingReducer = combineReducers<EventEntity?>([
  TypedReducer<EventEntity?, SaveEventSuccess>(_updateEditing),
  TypedReducer<EventEntity?, AddEventSuccess>((event, action) {
    if (action.isPreview == true) {
      return event;
    }
    return action.event;
  }),
  TypedReducer<EventEntity?, RestoreEventsSuccess>((events, action) {
    return action.events[0];
  }),
  TypedReducer<EventEntity?, ArchiveEventsSuccess>((events, action) {
    return action.events[0];
  }),
  TypedReducer<EventEntity?, DeleteEventsSuccess>((events, action) {
    return action.events[0];
  }),
  TypedReducer<EventEntity?, PurgeEventsSuccess>((events, action) {
    return action.events[0];
  }),
  TypedReducer<EventEntity?, EditEvent>(_updateEditing),
  TypedReducer<EventEntity?, UpdateEvent>((event, action) {
    return action.event.rebuild((b) => b..isChanged = true);
  }),
  TypedReducer<EventEntity?, ViewEvent>((client, action) {
    return EventEntity();
  }),
  TypedReducer<EventEntity?, DiscardChanges>(_clearEditing),
]);

EventEntity _clearEditing(EventEntity? event, dynamic action) {
  return EventEntity();
}

EventEntity? _updateEditing(EventEntity? event, dynamic action) {
  return action.event;
}

final eventListReducer = combineReducers<ListUIState>([
  TypedReducer<ListUIState, SortEvents>(_sortEvents),
  TypedReducer<ListUIState, FilterEventsByState>(_filterEventsByState),
  TypedReducer<ListUIState, FilterEvents>(_filterEvents),
  TypedReducer<ListUIState, StartEventMultiselect>(_startListMultiselect),
  TypedReducer<ListUIState, AddToEventMultiselect>(_addToListMultiselect),
  TypedReducer<ListUIState, RemoveFromEventMultiselect>(
      _removeFromListMultiselect),
  TypedReducer<ListUIState, ClearEventMultiselect>(_clearListMultiselect),
  TypedReducer<ListUIState, ViewEventList>(_viewEventList),
  TypedReducer<ListUIState, FilterByEntity>((state, action) => state.rebuild(
        (b) => b
          ..filter = null
          ..filterClearedAt = DateTime.now().millisecondsSinceEpoch,
      )),
]);

ListUIState _viewEventList(ListUIState eventListState, ViewEventList action) {
  return eventListState.rebuild((b) => b
    ..selectedIds = null
    ..filter = null
    ..filterClearedAt = DateTime.now().millisecondsSinceEpoch);
}

ListUIState _filterEventsByState(
    ListUIState eventListState, FilterEventsByState action) {
  if (eventListState.stateFilters.contains(action.state)) {
    return eventListState.rebuild((b) => b
      ..stateFilters.clear()
      ..stateFilters.add(EntityState.active));
  } else {
    return eventListState.rebuild((b) => b
      ..stateFilters.clear()
      ..stateFilters.add(action.state));
  }
}

ListUIState _filterEvents(ListUIState eventListState, FilterEvents action) {
  return eventListState.rebuild((b) => b
    ..filter = action.filter
    ..filterClearedAt = action.filter.isEmpty
        ? DateTime.now().millisecondsSinceEpoch
        : eventListState.filterClearedAt);
}

ListUIState _sortEvents(ListUIState eventListState, SortEvents action) {
  return eventListState.rebuild((b) => b
    ..sortAscending = b.sortField != action.field || !b.sortAscending!
    ..sortField = action.field);
}

ListUIState _startListMultiselect(
    ListUIState productListState, StartEventMultiselect action) {
  return productListState.rebuild((b) => b..selectedIds = ListBuilder());
}

ListUIState _addToListMultiselect(
    ListUIState productListState, AddToEventMultiselect action) {
  return productListState.rebuild((b) => b..selectedIds.add(action.entity.id));
}

ListUIState _removeFromListMultiselect(
    ListUIState productListState, RemoveFromEventMultiselect action) {
  return productListState
      .rebuild((b) => b..selectedIds.remove(action.entity.id));
}

ListUIState _clearListMultiselect(
    ListUIState productListState, ClearEventMultiselect action) {
  return productListState.rebuild((b) => b..selectedIds = null);
}

final eventsReducer = combineReducers<EventState>([
  TypedReducer<EventState, FilterEventsByOwnership>(_filterEventsByOwnership),
  TypedReducer<EventState, SaveEventSuccess>(_updateEvent),
  TypedReducer<EventState, AddEventSuccess>(_addEvent),
  TypedReducer<EventState, LoadEventsSuccess>(_setLoadedEvents),
  TypedReducer<EventState, LoadEventSuccess>(_setLoadedEvent),
  TypedReducer<EventState, UpdateLastDocumentAction>(_updateLastDocument),
  TypedReducer<EventState, UpdateEventFilter>(_updateEventFilter),
  TypedReducer<EventState, ChatWithAiSuccess>(_setAiGeneratedEvents),
  // TypedReducer<EventState, LoadCompanySuccess>(_setLoadedCompany), //uncomment this if you its dependant on selected company
  TypedReducer<EventState, ArchiveEventsSuccess>(_archiveEventSuccess),
  TypedReducer<EventState, DeleteEventsSuccess>(_deleteEventSuccess),
  TypedReducer<EventState, PurgeEventsSuccess>(_purgeEventSuccess),
  TypedReducer<EventState, RestoreEventsSuccess>(_restoreEventSuccess),
  TypedReducer<EventState, EventOperationSuccess>(_updateEventFromOperation),
  TypedReducer<EventState, operations.ReportEntitySuccess>(
      _handleReportEntitySuccess),
]);

EventState _archiveEventSuccess(
    EventState eventState, ArchiveEventsSuccess action) {
  final int currentTime = DateTime.now().millisecondsSinceEpoch;
  return eventState.rebuild((b) {
    for (final event in action.events) {
      b.map[event.id] =
          eventState.map[event.id]!.rebuild((b) => b..archivedAt = currentTime);
    }
  });
}

EventState _filterEventsByOwnership(
    EventState eventState, FilterEventsByOwnership action) {
  return eventState.rebuild((b) => b
    ..showMyEventsOnly = action.showMyEventsOnly
    ..lastUpdated = DateTime.now().millisecondsSinceEpoch);
}

EventState _updateEventFilter(EventState eventState, UpdateEventFilter action) {
  return eventState.rebuild((b) => b..filter = action.filter.toBuilder());
}

// EventState _deleteEventSuccess(EventState eventState, DeleteEventsSuccess action) {
//   return eventState.rebuild((b) {
//     for (final event in action.events) {
//       b.map[event.id] = event;
//     }
//   });
// }

EventState _deleteEventSuccess(
    EventState eventState, DeleteEventsSuccess action) {
  return eventState.rebuild((b) {
    for (final event in action.events) {
      b.map[event.id] =
          eventState.map[event.id]!.rebuild((b) => b..isDeleted = true);
    }
  });
}

EventState _purgeEventSuccess(
    EventState eventState, PurgeEventsSuccess action) {
  return eventState.rebuild((b) {
    for (final event in action.events) {
      b.map.remove(event.id);
      b.list.remove(event.id);
    }
  });
}

EventState _restoreEventSuccess(
    EventState eventState, RestoreEventsSuccess action) {
  return eventState.rebuild((b) {
    for (final event in action.events) {
      b.map[event.id] = eventState.map[event.id]!.rebuild((b) => b
        ..isDeleted = false
        ..archivedAt = 0);
    }
  });
}

EventState _updateEventFromOperation(
    EventState eventState, EventOperationSuccess action) {
  return eventState.rebuild((b) => b..map[action.event.id] = action.event);
}

EventState _addEvent(EventState eventState, AddEventSuccess action) {
  return eventState.rebuild((b) {
    b.map[action.event.id] = action.event;
    if (!action.isPreview) {
      b.list.add(action.event.id);
    }
  });
}

EventState _updateEvent(EventState eventState, SaveEventSuccess action) {
  return eventState.rebuild((b) => b..map[action.event.id] = action.event);
}

EventState _updateLastDocument(
    EventState eventState, UpdateLastDocumentAction action) {
  return eventState.rebuild((b) => b..lastDocument = action.lastDocument);
}

EventState _setLoadedEvent(EventState eventState, LoadEventSuccess action) {
  return eventState.rebuild((b) => b..map[action.event.id] = action.event);
}

EventState _setLoadedEvents(EventState eventState, LoadEventsSuccess action) {
  return eventState.rebuild((b) {
    if (action.isRefresh) {
      b.map.clear();
      b.list.clear();
    }

    if (action.myEventsOnly) {
      final aiEventIdsToPreserve = <String>[];
      final aiEventsToPreserve = <String, EventEntity>{};
      
      for (final eventId in b.list.build()) {
        final event = b.map.build()[eventId];
        if (event != null && event.callToAction == CallToActionType.thirdParty) {
          aiEventsToPreserve[eventId] = event;
          aiEventIdsToPreserve.add(eventId);
        }
      }
      
      b.list.clear();
      
      for (final eventId in aiEventIdsToPreserve) {
        b.list.add(eventId);
        b.map[eventId] = aiEventsToPreserve[eventId]!;
      }
    }

    final eventsToAdd = <EventEntity>[];
    for (var event in action.events) {
      if (!b.list.build().contains(event.id)) {
        if (action.myEventsOnly) {
          if (event.orders.any(
              (order) => order.buyerDetails.email == action.currentUserEmail && 
                         order.buyerDetails.attendeeStatus != AttendeeStatus.owner)) {
            eventsToAdd.add(event);
          }
        } else {
          eventsToAdd.add(event);
        }
      }
    }

    if (action.myEventsOnly) {
      eventsToAdd.sort((a, b) => b.end.compareTo(a.end));
    }

    for (var event in eventsToAdd) {
      b.list.add(event.id);
      b.map[event.id] = event;
    }
  });
}

EventState _setAiGeneratedEvents(EventState eventState, ChatWithAiSuccess action) {
  return eventState.rebuild((b) {
    b.map.clear();
    b.list.clear();
    
    for (var event in action.events) {
      b.list.add(event.id);
      b.map[event.id] = event;
    }
  });
}

EventState _handleReportEntitySuccess(
    EventState eventState, operations.ReportEntitySuccess action) {
  if (action.entityType != EntityType.event) {
    return eventState;
  }

  final targetId = action.data['targetId'] as String;
  final newReportsMap = action.data['reportsMap'] as Map<String, dynamic>;
  final reported = action.data['reported'] as bool;
  final currentEvent = eventState.map[targetId];

  if (currentEvent == null) {
    return eventState;
  }

  return eventState.rebuild((b) {
    final updatedEvent = currentEvent.rebuild((sb) => sb
      ..reportsMap = Map<String, dynamic>.from(newReportsMap)
      ..reported = reported);

    b.map[targetId] = updatedEvent;
  });
}

// EventState _setLoadedCompany(EventState eventState, LoadCompanySuccess action) {
//   final company = action.userCompany.company;
//   return eventState.loadEvents(company.events);
// }
