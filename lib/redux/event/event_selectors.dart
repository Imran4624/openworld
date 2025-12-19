import 'package:flutter_boilerplate/main_app.dart';
import 'package:flutter_boilerplate/redux/static/static_state.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:memoize/memoize.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/ui/list_ui_state.dart';

var memoizedDropdownEventList = memo5((BuiltMap<String, EventEntity> eventMap,
        BuiltList<String> eventList,
        StaticState staticState,
        BuiltMap<String, UserEntity> userMap,
        String? clientId) =>
    dropdownEventsSelector(
        eventMap, eventList, staticState, userMap, clientId));

List<String> dropdownEventsSelector(
    BuiltMap<String, EventEntity> eventMap,
    BuiltList<String> eventList,
    StaticState staticState,
    BuiltMap<String, UserEntity> userMap,
    String? clientId) {
  final list = eventList.where((eventId) {
    final event = eventMap[eventId];
    if (event == null) {
      return false;
    }
    /*
    if (clientId != null && clientId > 0 && event.clientId != clientId) {
      return false;
    }
    */
    return event.isActive;
  }).toList();

  list.sort((eventAId, eventBId) {
    final eventA = eventMap[eventAId]!;
    final eventB = eventMap[eventBId]!;

    // STARTER: primary field - do not remove comment
    return eventA.compareTo(eventB, EventFields.name, true);
  });

  return list;
}

var memoizedFilteredEventList = memo4((SelectionState selectionState,
        BuiltMap<String, EventEntity> eventMap,
        BuiltList<String> eventList,
        ListUIState eventListState) =>
    filteredEventsSelector(
        selectionState, eventMap, eventList, eventListState));

List<String> filteredEventsSelector(
    SelectionState selectionState,
    BuiltMap<String, EventEntity> eventMap,
    BuiltList<String> eventList,
    ListUIState eventListState) {
  final filterEntityId = selectionState.filterEntityId;
  // final filterEntityType = selectionState.filterEntityType;
  final filteredList = eventList.where((eventId) {
    final event = eventMap[eventId];
    if (event == null) {
      return false;
    }

    if (filterEntityId != null && event.id != filterEntityId) {
      return false;
    }

    if (!event.matchesStates(eventListState.stateFilters)) {
      return false;
    }

    // Uncomment if using custom filters in future
    // if (eventListState.custom1Filters.isNotEmpty &&
    //     !eventListState.custom1Filters.contains(event.customValue1)) {
    //   return false;
    // } else if (eventListState.custom2Filters.isNotEmpty &&
    //     !eventListState.custom2Filters.contains(event.customValue2)) {
    //   return false;
    // } else if (eventListState.custom3Filters.isNotEmpty &&
    //     !eventListState.custom3Filters.contains(event.customValue3)) {
    //   return false;
    // } else if (eventListState.custom4Filters.isNotEmpty &&
    //     !eventListState.custom4Filters.contains(event.customValue4)) {
    //   return false;
    // }

    return event.matchesFilter(eventListState.filter);
  }).toList();

  final uniqueEvents = <String, String>{};
  for (final eventId in filteredList) {
    final event = eventMap[eventId];
    if (event != null) {
      uniqueEvents[event.id] = eventId;
    }
  }

  final sortedList = uniqueEvents.values.toList();
  // ..sort((eventAId, eventBId) {
  //   final eventA = eventMap[eventAId]!;
  //   final eventB = eventMap[eventBId]!;
  //   return eventA.compareTo(
  //       eventB, eventListState.sortField, eventListState.sortAscending);
  // });

  return sortedList;
}
