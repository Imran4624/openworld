// Package imports:
import 'package:built_collection/built_collection.dart';
import 'package:memoize/memoize.dart';

// Project imports:
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/data/models/user_model.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/ui/list_ui_state.dart';

var memoizedDropdownUserList = memo3((BuiltMap<String, UserEntity> userMap,
        BuiltList<String> userList, String clientId) =>
    dropdownUsersSelector(userMap, userList, clientId));

List<String> dropdownUsersSelector(BuiltMap<String, UserEntity> userMap,
    BuiltList<String> userList, String clientId) {
  final list = userList.where((userId) {
    final user = userMap[userId]!;
    /*
    if (clientId != null && clientId > 0 && user.clientId != clientId) {
      return false;
    }
    */
    return user.isActive;
  }).toList();

  list.sort((userAId, userBId) {
    final userA = userMap[userAId]!;
    final userB = userMap[userBId];
    return userA.compareTo(userB, UserFields.firstName, true);
  });

  return list;
}

var memoizedFilteredUserList = memo4((SelectionState selectionState,
        BuiltMap<String, UserEntity> userMap,
        BuiltList<String> userList,
        ListUIState userListState) =>
    filteredUsersSelector(selectionState, userMap, userList, userListState));

List<String> filteredUsersSelector(
    SelectionState selectionState,
    BuiltMap<String, UserEntity> userMap,
    BuiltList<String> userList,
    ListUIState userListState) {
  final filterEntityId = selectionState.filterEntityId;
  // final filterEntityType = selectionState.filterEntityType;

  final filteredList = userList.where((userId) {
    final user = userMap[userId];
    if (user == null) {
      return false;
    }

    if (filterEntityId != null && user.id != filterEntityId) {
      return false;
    }

    if (!user.matchesStates(userListState.stateFilters)) {
      return false;
    }

    // Uncomment if using custom filters in future
    // if (profileListState.custom1Filters.isNotEmpty &&
    //     !profileListState.custom1Filters.contains(profile.customValue1)) {
    //   return false;
    // } else if (profileListState.custom2Filters.isNotEmpty &&
    //     !profileListState.custom2Filters.contains(profile.customValue2)) {
    //   return false;
    // } else if (profileListState.custom3Filters.isNotEmpty &&
    //     !profileListState.custom3Filters.contains(profile.customValue3)) {
    //   return false;
    // } else if (profileListState.custom4Filters.isNotEmpty &&
    //     !profileListState.custom4Filters.contains(profile.customValue4)) {
    //   return false;
    // }

    return user.matchesFilter(userListState.filter);
  }).toList();

  final uniqueProfiles = <String, String>{};
  for (final profileId in filteredList) {
    final profile = userMap[profileId];
    if (profile != null) {
      uniqueProfiles[profile.id] = profileId;
    }
  }

  final sortedList = uniqueProfiles.values.toList();
  // ..sort((profileAId, profileBId) {
  //   final profileA = profileMap[profileAId]!;
  //   final profileB = profileMap[profileBId]!;
  //   return profileA.compareTo(
  //       profileB, profileListState.sortField, profileListState.sortAscending);
  // });

  return sortedList;
}

var memoizedUserList =
    memo1((BuiltMap<String, UserEntity> userMap) => userList(userMap));

List<String?> userList(BuiltMap<String, UserEntity> userMap) {
  final list =
      userMap.keys.where((userId) => userMap[userId]!.isActive).toList();

  list.sort((idA, idB) => userMap[idA]!
      .fullName
      .toLowerCase()
      .compareTo(userMap[idB]!.fullName.toLowerCase()));

  return list;
}

var memoizedGmailUserList =
    memo1((BuiltMap<String, UserEntity> userMap) => gmailUserList(userMap));

List<String?> gmailUserList(BuiltMap<String, UserEntity> userMap) {
  return userList(userMap).where((userId) {
    final user = (userMap[userId] ?? UserEntity) as UserEntity;

    return user.isActive && user.isConnectedToEmail && user.isConnectedToGoogle;
  }).toList();
}

var memoizedMicrosoftUserList =
    memo1((BuiltMap<String, UserEntity> userMap) => microsoftUserList(userMap));

List<String?> microsoftUserList(BuiltMap<String, UserEntity> userMap) {
  return userList(userMap).where((userId) {
    final user = (userMap[userId] ?? UserEntity) as UserEntity;

    return user.isActive &&
        user.isConnectedToEmail &&
        user.isConnectedToMicrosoft;
  }).toList();
}

bool? hasUserChanges(UserEntity user, BuiltMap<String, UserEntity> userMap) =>
    user.isNew ? user.isChanged : user != userMap[user.id];
