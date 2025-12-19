import 'package:flutter_boilerplate/redux/static/static_state.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:memoize/memoize.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/ui/list_ui_state.dart';

var memoizedDropdownProfileOperationList = memo5(
    (BuiltMap<String, ProfileOperationEntity> profileOperationMap,
            BuiltList<String> profileOperationList,
            StaticState staticState,
            BuiltMap<String, UserEntity> userMap,
            String? clientId) =>
        dropdownProfileOperationsSelector(profileOperationMap,
            profileOperationList, staticState, userMap, clientId));

List<String> dropdownProfileOperationsSelector(
    BuiltMap<String, ProfileOperationEntity> profileOperationMap,
    BuiltList<String> profileOperationList,
    StaticState staticState,
    BuiltMap<String, UserEntity> userMap,
    String? clientId) {
  final list = profileOperationList.where((profileOperationId) {
    final profileOperation = profileOperationMap[profileOperationId];
    if (profileOperation == null) {
      return false;
    }
    /*
    if (clientId != null && clientId > 0 && profileOperation.clientId != clientId) {
      return false;
    }
    */
    return profileOperation.isActive;
  }).toList();

  list.sort((profileOperationAId, profileOperationBId) {
    final profileOperationA = profileOperationMap[profileOperationAId]!;
    final profileOperationB = profileOperationMap[profileOperationBId]!;

    // STARTER: primary field - do not remove comment
    return profileOperationA.compareTo(
        profileOperationB, ProfileOperationFields.status, true);
  });

  return list;
}

var memoizedFilteredProfileOperationList = memo4((SelectionState selectionState,
        BuiltMap<String, ProfileOperationEntity> profileOperationMap,
        BuiltList<String> profileOperationList,
        ListUIState profileOperationListState) =>
    filteredProfileOperationsSelector(selectionState, profileOperationMap,
        profileOperationList, profileOperationListState));

List<String> filteredProfileOperationsSelector(
    SelectionState selectionState,
    BuiltMap<String, ProfileOperationEntity> profileOperationMap,
    BuiltList<String> profileOperationList,
    ListUIState profileOperationListState) {
  final filterEntityId = selectionState.filterEntityId;
  // final filterEntityType = selectionState.filterEntityType;

  final filteredList = profileOperationList.where((profileOperationId) {
    final profileOperation = profileOperationMap[profileOperationId];
    if (profileOperation == null) {
      return false;
    }

    if (filterEntityId != null && profileOperation.id != filterEntityId) {
      return false;
    }

    if (!profileOperation
        .matchesStates(profileOperationListState.stateFilters)) {
      return false;
    }

    // Uncomment if using custom filters in future
    // if (profileOperationListState.custom1Filters.isNotEmpty &&
    //     !profileOperationListState.custom1Filters.contains(profileOperation.customValue1)) {
    //   return false;
    // } else if (profileOperationListState.custom2Filters.isNotEmpty &&
    //     !profileOperationListState.custom2Filters.contains(profileOperation.customValue2)) {
    //   return false;
    // } else if (profileOperationListState.custom3Filters.isNotEmpty &&
    //     !profileOperationListState.custom3Filters.contains(profileOperation.customValue3)) {
    //   return false;
    // } else if (profileOperationListState.custom4Filters.isNotEmpty &&
    //     !profileOperationListState.custom4Filters.contains(profileOperation.customValue4)) {
    //   return false;
    // }

    return profileOperation.matchesFilter(profileOperationListState.filter);
  }).toList();

  final uniqueProfileOperations = <String, String>{};
  for (final profileOperationId in filteredList) {
    final profileOperation = profileOperationMap[profileOperationId];
    if (profileOperation != null) {
      uniqueProfileOperations[profileOperation.id] = profileOperationId;
    }
  }

  final sortedList = uniqueProfileOperations.values.toList();
  // ..sort((profileOperationAId, profileOperationBId) {
  //   final profileOperationA = profileOperationMap[profileOperationAId]!;
  //   final profileOperationB = profileOperationMap[profileOperationBId]!;
  //   return profileOperationA.compareTo(
  //       profileOperationB, profileOperationListState.sortField, profileOperationListState.sortAscending);
  // });

  return sortedList;
}
