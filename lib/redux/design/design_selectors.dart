// Package imports:
import 'package:built_collection/built_collection.dart';
import 'package:flutter/foundation.dart';
import 'package:memoize/memoize.dart';

// Project imports:
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/ui/list_ui_state.dart';

var memoizedDropdownDesignList = memo3(
    (BuiltMap<String, DesignEntity> designMap, BuiltList<String> designList,
            String clientId) =>
        dropdownDesignsSelector(designMap, designList, clientId));

List<String> dropdownDesignsSelector(BuiltMap<String, DesignEntity> designMap,
    BuiltList<String> designList, String clientId) {
  final list = designList.where((designId) {
    final design = designMap[designId]!;
    /*
    if (clientId != null && clientId > 0 && design.clientId != clientId) {
      return false;
    }
    */
    return design.isActive;
  }).toList();

  list.sort((designAId, designBId) {
    final designA = designMap[designAId]!;
    final designB = designMap[designBId];
    return designA.compareTo(designB, DesignFields.name, true);
  });

  return list;
}

var memoizedFilteredDesignList = memo3(
    (BuiltMap<String, DesignEntity> designMap, BuiltList<String> designList,
            ListUIState designListState) =>
        filteredDesignsSelector(designMap, designList, designListState));

List<String> filteredDesignsSelector(BuiltMap<String, DesignEntity> designMap,
    BuiltList<String> designList, ListUIState designListState) {
  final list = designList.where((designId) {
    final design = designMap[designId]!;

    if (!design.isCustom) {
      return false;
    }

    if (!design.matchesStates(designListState.stateFilters)) {
      return false;
    }
    return design.matchesFilter(designListState.filter);
  }).toList();

  list.sort((designAId, designBId) {
    final designA = designMap[designAId]!;
    final designB = designMap[designBId];
    return designA.compareTo(
        designB, designListState.sortField, designListState.sortAscending);
  });

  return list;
}

bool hasDesignTemplatesForEntityType(
    BuiltMap<String, DesignEntity> designMap, EntityType entityType) {
  if (!kReleaseMode) {
    return true;
  }

  var hasMatch = false;

  designMap.forEach((designId, design) {
    if (design.supportsEntityType(entityType)) {
      hasMatch = true;
    }
  });

  return hasMatch;
}
