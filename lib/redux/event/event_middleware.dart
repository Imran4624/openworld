import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:redux/redux.dart';
import 'package:built_collection/built_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_boilerplate/main_app.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/ui/ui_actions.dart';
import 'package:flutter_boilerplate/ui/event/event_screen.dart';
import 'package:flutter_boilerplate/ui/event/edit/event_edit_vm.dart';
import 'package:flutter_boilerplate/ui/event/view/event_view_vm.dart';
import 'package:flutter_boilerplate/redux/event/event_actions.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/data/repositories/event_repository.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'package:flutter_boilerplate/services/session_managment_service.dart';
import 'package:flutter_boilerplate/services/ai_service.dart';
import 'package:flutter_boilerplate/services/ai_event_validator.dart';
import 'package:flutter_boilerplate/project_config.dart';
import 'package:flutter_boilerplate/data/models/event_model_helper.dart';

List<Middleware<AppState>> createStoreEventsMiddleware([
  EventRepository repository = const EventRepository(),
  AiService aiService = const AiService(),
]) {
  final viewEventList = _viewEventList();
  final viewEvent = _viewEvent();
  final editEvent = _editEvent();
  final loadEvents = _loadEvents(repository);
  final loadEvent = _loadEvent(repository);
  final saveEvent = _saveEvent(repository);
  final archiveEvent = _archiveEvent(repository);
  final deleteEvent = _deleteEvent(repository);
  final purgeEvent = _purgeEvent(repository);
  final restoreEvent = _restoreEvent(repository);
  final updateFilter = _updateFilter(repository);
  final filterOwnership = _filterEventsByOwnership(repository);
  final saveEventOperation = _saveEventInteraction(repository);
  final chatWithAi = _chatWithAi(aiService);

  return [
    TypedMiddleware<AppState, ViewEventList>(viewEventList),
    TypedMiddleware<AppState, ViewEvent>(viewEvent),
    TypedMiddleware<AppState, EditEvent>(editEvent),
    TypedMiddleware<AppState, LoadEvents>(loadEvents),
    TypedMiddleware<AppState, LoadEvent>(loadEvent),
    TypedMiddleware<AppState, SaveEventRequest>(saveEvent),
    TypedMiddleware<AppState, ArchiveEventsRequest>(archiveEvent),
    TypedMiddleware<AppState, DeleteEventsRequest>(deleteEvent),
    TypedMiddleware<AppState, PurgeEventsRequest>(purgeEvent),
    TypedMiddleware<AppState, RestoreEventsRequest>(restoreEvent),
    TypedMiddleware<AppState, UpdateEventFilter>(updateFilter),
    TypedMiddleware<AppState, FilterEventsByOwnership>(filterOwnership),
    TypedMiddleware<AppState, SaveEventOperation>(saveEventOperation),
    TypedMiddleware<AppState, ChatWithAi>(chatWithAi),
  ];
}

Middleware<AppState> _filterEventsByOwnership(EventRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as FilterEventsByOwnership;

    next(action);

    store.dispatch(LoadEvents(
      filter: store.state.eventState.filter,
      isRefresh: true,
      myEventsOnly: action.showMyEventsOnly,
      currentUserEmail: action.currentUserEmail,
    ));
  };
}

Middleware<AppState> _editEvent() {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as EditEvent;

    next(action);

    store.dispatch(UpdateCurrentRoute(EventEditScreen.route));

    if (store.state.prefState.isDesktop &&
        ProjectConfig.fullWidthEntities().contains(EntityType.event) &&
        !store.state.prefState.isEditorFullScreen(EntityType.event)) {
      store.dispatch(ToggleEditorLayout(EntityType.event));
    }

    if (store.state.prefState.isMobile) {
      navigatorKey.currentState!.pushNamed(EventEditScreen.route);
    }
  };
}

Middleware<AppState> _viewEvent() {
  return (Store<AppState> store, dynamic dynamicAction,
      NextDispatcher next) async {
    final action = dynamicAction as ViewEvent;

    next(action);

    final fullRoute =
        ProjectConfig.getEntityDetailUrl(EntityType.event, action.eventId!);

    store.dispatch(UpdateCurrentRoute(fullRoute));

    if (store.state.prefState.isMobile) {
      navigatorKey.currentState!.pushNamed(EventViewScreen.route);
    }
  };
}

Middleware<AppState> _viewEventList() {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as ViewEventList;

    next(action);

    if (store.state.staticState.isStale) {
      store.dispatch(const RefreshData());
    }

    store.dispatch(UpdateCurrentRoute(EventScreen.route));

    if (store.state.prefState.isMobile) {
      navigatorKey.currentState!.pushNamedAndRemoveUntil(
          EventScreen.route, (Route<dynamic> route) => false);
    }
  };
}

Middleware<AppState> _archiveEvent(EventRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as ArchiveEventsRequest;
    final prevEvents = action.eventIds
        .map((id) => store.state.eventState.map[id])
        .whereType<EventEntity>()
        .toList();

    repository
        .bulkAction(
            store.state.credentials, action.eventIds, EntityAction.archive)
        .then((List<EventEntity> events) {
      store.dispatch(ArchiveEventsSuccess(events));
      action.completer.complete(null);
    }).catchError((Object error) {
      logError('$error');
      store.dispatch(ArchiveEventsFailure(prevEvents));
      action.completer.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _deleteEvent(EventRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as DeleteEventsRequest;
    final prevEvents = action.eventIds
        .map((id) => store.state.eventState.map[id])
        .whereType<EventEntity>()
        .toList();

    repository
        .bulkAction(
            store.state.credentials, action.eventIds, EntityAction.delete)
        .then((List<EventEntity> events) {
      store.dispatch(DeleteEventsSuccess(events));
      action.completer.complete(null);
    }).catchError((Object error) {
      logError('$error');
      store.dispatch(DeleteEventsFailure(prevEvents));
      action.completer.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _purgeEvent(EventRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as PurgeEventsRequest;
    final prevEvents = action.eventIds
        .map((id) => store.state.eventState.map[id])
        .whereType<EventEntity>()
        .toList();

    repository
        .bulkAction(
            store.state.credentials, action.eventIds, EntityAction.purge)
        .then((List<EventEntity> events) {
      store.dispatch(PurgeEventsSuccess(events));

      action.completer.complete(null);
    }).catchError((Object error) {
      logError('$error');
      store.dispatch(PurgeEventsFailure(prevEvents));
      action.completer.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _restoreEvent(EventRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as RestoreEventsRequest;
    final prevEvents = action.eventIds
        .map((id) => store.state.eventState.map[id])
        .whereType<EventEntity>()
        .toList();

    repository
        .bulkAction(
            store.state.credentials, action.eventIds, EntityAction.restore)
        .then((List<EventEntity> events) {
      store.dispatch(RestoreEventsSuccess(events));
      action.completer.complete(null);
    }).catchError((Object error) {
      logError('$error');
      store.dispatch(RestoreEventsFailure(prevEvents));
      action.completer.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _saveEvent(EventRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as SaveEventRequest;
    final currentUserId = getLoggedInUserId(store);

    final thumbnail = store
        .state.profileState.loggedInUserProfile.dynamicFields['images']?.first;
    final username = store.state.authState.currentUserName;

    Map<String, dynamic> createdByObj;
    String effectiveUserId = currentUserId;

    if (!action.event!.isNew && action.event!.createdByObj != null) {
      createdByObj = action.event!.createdByObj!;
      effectiveUserId = action.event!.createdUserId ?? currentUserId;
    } else {
      createdByObj = {
        'thumbnail': thumbnail,
        'username': username,
        'userId': currentUserId,
      };
    }

    EventEntity eventToSave = action.event!;

    repository
        .saveData(store.state.credentials, eventToSave, effectiveUserId,
            action.isPreview, createdByObj)
        .then((EventEntity event) {
      if (action.isPreview) {
        action.completer?.complete(event);
        store.dispatch(AddEventSuccess(event, isPreview: true));
        return;
      }
      if (action.event!.isNew) {
        store.dispatch(AddEventSuccess(event));
      } else {
        store.dispatch(SaveEventSuccess(event));
      }
      if (action.completer != null && action.isViewEvent) {
        store.dispatch(ViewEvent(eventId: event.id));
      }

      action.completer?.complete(event);
    }).catchError((Object error) {
      logError('$error');
      store.dispatch(SaveEventFailure(error));
      action.completer?.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _loadEvent(EventRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as LoadEvent;

    store.dispatch(LoadEventRequest());
    repository.loadItem(store.state.credentials, action.eventId!).then((event) {
      store.dispatch(LoadEventSuccess(event));
      action.completer?.complete(null);
    }).catchError((Object error) {
      logError('$error');
      store.dispatch(LoadEventFailure(error));
      action.completer?.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _loadEvents(EventRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction,
      NextDispatcher next) async {
    if (store.state.isLoading) {
      return;
    }

    final action = dynamicAction as LoadEvents;
    final state = store.state;
    final stateFilters = state.eventListState.stateFilters;
    final currentFilter = action.filter ?? state.eventState.filter;

    String? currentUserId = getLoggedInUserId(store);
    int retryCount = 0;
    while ((currentUserId == null || currentUserId.isEmpty) && retryCount < 5) {
      await Future.delayed(const Duration(milliseconds: 100));
      currentUserId = getLoggedInUserId(store);
      retryCount++;
    }

    final filter = currentFilter.rebuild((b) {
      if (stateFilters.isNotEmpty) {
        b.stateFilter = stateFilters.first;
      } else {
        b.stateFilter = EntityState.active;
      }
    });
    store.dispatch(LoadEventsRequest(filter: filter));

    var lastDocument = state.eventState.lastDocument;
    if (action.isRefresh) {
      lastDocument = null;
      store.dispatch(UpdateLastDocumentAction(null));
    }

    repository
        .loadListWithPagination(
            lastDocument: lastDocument,
            limit: ProjectConfig.isLimitRemoved() ? 0 : filter.limit,
            filter: filter,
            myEventsOnly: action.myEventsOnly,
            currentUserId: currentUserId)
        .then((response) {
      final events = response['events'] as BuiltList<EventEntity>;
      final newLastDocument = response['lastDocument'] as DocumentSnapshot?;

      store.dispatch(LoadEventsSuccess(events,
          isRefresh: action.isRefresh,
          myEventsOnly: action.myEventsOnly,
          currentUserEmail: action.currentUserEmail));
      if (events.isNotEmpty) {
        store.dispatch(UpdateLastDocumentAction(newLastDocument));
      }
      action.completer?.complete(null);
    }).catchError((Object error) {
      logError('$error');
      store.dispatch(LoadEventsFailure(error));
      action.completer?.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _updateFilter(EventRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as UpdateEventFilter;

    next(action);

    store.dispatch(LoadEvents(
      filter: action.filter,
      isRefresh: true,
    ));
  };
}

Middleware<AppState> _saveEventInteraction(EventRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as SaveEventOperation;

    store.dispatch(SaveEventOperationRequest(
      eventId: action.eventId,
      userId: action.userId,
      eventOperationType: action.eventOperationType,
      completer: action.completer,
    ));

    final currentEvent = store.state.eventState.map[action.eventId];

    if (currentEvent == null) {
      repository
          .loadItem(store.state.credentials, action.eventId)
          .then((event) {
        _createEventInterAction(store, action, repository, event);
      }).catchError((Object error) {
        logError('EventOperation - Error loading event: $error');
        store.dispatch(EventOperationFailure(error));
        action.completer?.completeError(error);
      });
    } else {
      _createEventInterAction(store, action, repository, currentEvent);
    }

    next(action);
  };
}

void _createEventInterAction(
  Store<AppState> store,
  SaveEventOperation action,
  EventRepository repository,
  EventEntity currentEvent,
) {
  final interaction = EventInteraction((b) => b
    ..time = DateTime.now().millisecondsSinceEpoch
    ..userId = action.userId
    ..type = action.eventOperationType.toString());

  EventEntity updatedEvent;
  bool wasUpdated = false;

  switch (action.eventOperationType) {
    case EventOperationType.saved:
      final currentFavourites = currentEvent.favourites ?? <EventInteraction>[];
      final updatedFavourites =
          _updateEventInteractions(currentFavourites, interaction);
      wasUpdated = updatedFavourites.length != currentFavourites.length ||
          !_interactionListsEqual(updatedFavourites, currentFavourites);
      updatedEvent =
          _createEventWithUpdatedFavourites(currentEvent, updatedFavourites);
      break;
    case EventOperationType.viewed:
      final currentViews = currentEvent.views ?? <EventInteraction>[];
      final updatedViews = _updateEventInteractions(currentViews, interaction);
      wasUpdated = updatedViews.length != currentViews.length ||
          !_interactionListsEqual(updatedViews, currentViews);
      updatedEvent = _createEventWithUpdatedViews(currentEvent, updatedViews);
      break;
    default:
      updatedEvent = currentEvent;
      logError('Unknown EventOperationType type: ${action.eventOperationType}');
      break;
  }

  if (wasUpdated) {
    repository
        .updateEvent(store.state.credentials, updatedEvent)
        .then((EventEntity savedEvent) {
      store.dispatch(EventOperationSuccess(
        event: savedEvent,
        eventOperationType: action.eventOperationType,
      ));
      action.completer?.complete(savedEvent);
    }).catchError((Object error) {
      logError('EventOperation - Error saving updated event: $error');
      store.dispatch(EventOperationFailure(error));
      action.completer?.completeError(error);
    });
  } else {
    store.dispatch(EventOperationSuccess(
      event: updatedEvent,
      eventOperationType: action.eventOperationType,
    ));
    action.completer?.complete(updatedEvent);
  }
}

List<EventInteraction> _updateEventInteractions(
  List<EventInteraction> currentList,
  EventInteraction newInteraction,
) {
  final updatedList = List<EventInteraction>.from(currentList);

  final existingIndex = updatedList.indexWhere((item) =>
      item.userId == newInteraction.userId && item.type == newInteraction.type);

  if (newInteraction.type == EventOperationType.saved.toString()) {
    if (existingIndex >= 0) {
      updatedList.removeAt(existingIndex);
      return updatedList;
    } else {
      updatedList.add(newInteraction);
      return updatedList;
    }
  } else if (newInteraction.type == EventOperationType.viewed.toString()) {
    if (existingIndex >= 0) {
      return currentList;
    } else {
      updatedList.add(newInteraction);
      return updatedList;
    }
  } else {
    updatedList.add(newInteraction);
    return updatedList;
  }
}

EventEntity _createEventWithUpdatedFavourites(
  EventEntity originalEvent,
  List<EventInteraction> updatedFavourites,
) {
  return originalEvent.rebuild((b) => b..favourites = updatedFavourites);
}

EventEntity _createEventWithUpdatedViews(
  EventEntity originalEvent,
  List<EventInteraction> updatedViews,
) {
  return originalEvent.rebuild((b) => b..views = updatedViews);
}

bool _interactionListsEqual(
    List<EventInteraction> list1, List<EventInteraction> list2) {
  if (list1.length != list2.length) return false;

  for (int i = 0; i < list1.length; i++) {
    final item1 = list1[i];
    final item2 = list2[i];

    if (item1.userId != item2.userId ||
        item1.type != item2.type ||
        item1.time != item2.time) {
      return false;
    }
  }

  return true;
}

Middleware<AppState> _chatWithAi(AiService aiService) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as ChatWithAi;

    store.dispatch(ChatWithAiRequest());

    double? userLatitude = action.userLatitude;
    double? userLongitude = action.userLongitude;
    String? userLocationName = action.userLocationName;
    aiService
        .chatWithAi(
      action.message!,
      userLatitude: userLatitude,
      userLongitude: userLongitude,
      userLocationName: userLocationName,
    )
        .then((dynamic response) {
      try {
        final List<EventEntity> events =
            _buildEventsFromAiResponse(response, store);

        Map<String, double>? mapBounds;
        if (events.isNotEmpty) {
          try {
            final lats = <double>[];
            final lngs = <double>[];

            for (final event in events) {
              if (event.locationData != null) {
                lats.add(event.locationData!.lat);
                lngs.add(event.locationData!.lng);
              }
            }

            if (lats.isNotEmpty && lngs.isNotEmpty) {
              mapBounds = {
                'min_lat': lats.reduce((a, b) => a < b ? a : b),
                'max_lat': lats.reduce((a, b) => a > b ? a : b),
                'min_lng': lngs.reduce((a, b) => a < b ? a : b),
                'max_lng': lngs.reduce((a, b) => a > b ? a : b),
              };
            }
          } catch (e) {
            logError('Error calculating map bounds: $e');
          }
        }

        if (events.isEmpty) {
          showToast(
              'No events found for your search. Try a different query or location.');
        }
        store.dispatch(ChatWithAiSuccess(events, mapBounds: mapBounds));
        if (action.completer != null) {
          action.completer!.complete(events);
        }
      } catch (error) {
        logError('Error building events from AI response: $error');
        showToast('Unable to process search results. Please try again.');
        store.dispatch(ChatWithAiFailure(error));
        if (action.completer != null) {
          action.completer!.complete(<EventEntity>[]);
        }
      }
    });

    next(action);
  };
}

List<EventEntity> _buildEventsFromAiResponse(
    dynamic response, Store<AppState> store) {
  final List<EventEntity> events = [];
  const validator = AIEventValidator();

  if (response['events'] != null && response['events'] is List) {
    for (var eventData in response['events']) {
      try {
        if (!validator.isValidEvent(eventData)) {
          logError(
              'Invalid AI event skipped: ${eventData['name'] ?? 'unnamed'}');
          continue;
        }

        final currentUserId = getLoggedInUserId(store);
        final baseEvent = EventEntity();

        EventLocationData? locationData;
        if (eventData['location'] != null && eventData['location'] is Map) {
          final location = eventData['location'];
          try {
            locationData = EventLocationData((b) => b
              ..lat = (location['latitude'] as num?)?.toDouble() ?? 0.0
              ..lng = (location['longitude'] as num?)?.toDouble() ?? 0.0
              ..name = location['name'] as String? ?? ''
              ..address = location['address'] as String? ?? ''
              ..city = location['city'] as String? ?? ''
              ..country = location['country'] as String? ?? ''
              ..placeId = location['placeId'] as String?);
          } catch (e) {
            logError('Error creating locationData: $e');
            locationData = null;
          }
        }

        final currency = eventData['currency']?.toString() ?? '';

        Map<String, dynamic> createdByData = {};
        if (eventData['createdBy'] != null && eventData['createdBy'] is Map) {
          createdByData = Map<String, dynamic>.from(eventData['createdBy']);
        }

        // Handle images properly
        Images? imagesObj;
        if (eventData['images'] != null && eventData['images'] is Map) {
          final imagesData = eventData['images'] as Map<String, dynamic>;
          final header = imagesData['header'] as String?;
          final thumbnail = imagesData['thumbnail'] as String?;

          if (header != null &&
              header.isNotEmpty &&
              thumbnail != null &&
              thumbnail.isNotEmpty) {
            imagesObj = Images((i) => i
              ..header = header
              ..thumbnail = thumbnail);
            logInfo(
                'AI event "${eventData['name']}" includes images: header=$header, thumbnail=$thumbnail');
          }
        }

        final event = baseEvent.rebuild((b) => b
          ..id = 'ai_${DateTime.now().millisecondsSinceEpoch}_${events.length}'
          ..isChanged = false
          ..isDeleted = false
          ..createdAt = DateTime.now().millisecondsSinceEpoch
          ..updatedAt = DateTime.now().millisecondsSinceEpoch
          ..createdUserId = currentUserId
          ..assignedUserId = ''
          ..archivedAt = 0
          ..name = eventData['name']
          ..description = eventData['description'] ?? ''
          ..start = eventData['start']
          ..end =
              eventData['end'] ?? (eventData['start'] + (2 * 60 * 60 * 1000))
          ..callToAction = CallToActionType.thirdParty
          ..url = eventData['url'] ?? ''
          ..currency = currency
          ..accessCode = ''
          ..chk = ''
          ..eventSeriesId = ''
          ..hidden = false
          ..onlineEvent = false
          ..privateEvent = false
          ..status = 'active'
          ..ticketsAvailable = false
          ..totalHolds = 0
          ..totalIssuedTickets = 0
          ..totalOrders = 0
          ..unavailable = false
          ..unavailableStatus = ''
          ..locationData = locationData?.toBuilder()
          ..createdByObj = createdByData.isNotEmpty ? createdByData : null
          ..images = imagesObj?.toBuilder()
          ..dynamicFields.addAll({
            'category': eventData['category'] ?? 'General',
            'price': eventData['price'] ?? 'Check website',
            'location': eventData['location'] ?? {},
          }));

        events.add(event);
      } catch (e) {
        logError('Error parsing AI event: $e');
        continue;
      }
    }
  } else {
    logError('Invalid AI response format');
  }

  return events;
}
