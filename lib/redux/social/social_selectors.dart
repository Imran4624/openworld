import 'package:flutter_boilerplate/redux/static/static_state.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:memoize/memoize.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/ui/list_ui_state.dart';

var memoizedDropdownSocialList = memo5(
    (BuiltMap<String, SocialEntity> socialMap,
            BuiltList<String> socialList,
            StaticState staticState,
            BuiltMap<String, UserEntity> userMap,
            String? clientId) =>
        dropdownSocialsSelector(
            socialMap, socialList, staticState, userMap, clientId));

List<String> dropdownSocialsSelector(
    BuiltMap<String, SocialEntity> socialMap,
    BuiltList<String> socialList,
    StaticState staticState,
    BuiltMap<String, UserEntity> userMap,
    String? clientId) {
  final list = socialList.where((socialId) {
    final social = socialMap[socialId];
    if (social == null) {
      return false;
    }
    /*
    if (clientId != null && clientId > 0 && social.clientId != clientId) {
      return false;
    }
    */
    return social.isActive;
  }).toList();

  list.sort((socialAId, socialBId) {
    final socialA = socialMap[socialAId]!;
    final socialB = socialMap[socialBId]!;

    // STARTER: primary field - do not remove comment
    return socialA.compareTo(socialB, SocialFields.userDisplayName, true);
  });

  return list;
}

var memoizedFilteredSocialList = memo4((SelectionState selectionState,
        BuiltMap<String, SocialEntity> socialMap,
        BuiltList<String> socialList,
        ListUIState socialListState) =>
    filteredSocialsSelector(
        selectionState, socialMap, socialList, socialListState));

List<String> filteredSocialsSelector(
    SelectionState selectionState,
    BuiltMap<String, SocialEntity> socialMap,
    BuiltList<String> socialList,
    ListUIState socialListState) {
  final filterEntityId = selectionState.filterEntityId;
  // final filterEntityType = selectionState.filterEntityType;

  final filteredList = socialList.where((socialId) {
    final social = socialMap[socialId];
    if (social == null) {
      return false;
    }

    // if (filterEntityId != null && social.id != filterEntityId) {
    //   return false;
    // }

    if (!social.matchesStates(socialListState.stateFilters)) {
      return false;
    }

    // Uncomment if using custom filters in future
    // if (socialListState.custom1Filters.isNotEmpty &&
    //     !socialListState.custom1Filters.contains(social.customValue1)) {
    //   return false;
    // } else if (socialListState.custom2Filters.isNotEmpty &&
    //     !socialListState.custom2Filters.contains(social.customValue2)) {
    //   return false;
    // } else if (socialListState.custom3Filters.isNotEmpty &&
    //     !socialListState.custom3Filters.contains(social.customValue3)) {
    //   return false;
    // } else if (socialListState.custom4Filters.isNotEmpty &&
    //     !socialListState.custom4Filters.contains(social.customValue4)) {
    //   return false;
    // }

    return social.matchesFilter(socialListState.filter);
  }).toList();

  final uniqueSocials = <String, String>{};
  for (final socialId in filteredList) {
    final social = socialMap[socialId];
    if (social != null) {
      uniqueSocials[social.id] = socialId;
    }
  }

  final sortedList = uniqueSocials.values.toList();
  // ..sort((socialAId, socialBId) {
  //   final socialA = socialMap[socialAId]!;
  //   final socialB = socialMap[socialBId]!;
  //   return socialA.compareTo(
  //       socialB, socialListState.sortField, socialListState.sortAscending);
  // });

  return sortedList;
}
