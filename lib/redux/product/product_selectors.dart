import 'package:flutter_boilerplate/redux/static/static_state.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:memoize/memoize.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/ui/list_ui_state.dart';

var memoizedDropdownProductList = memo5(
    (BuiltMap<String, ProductEntity> productMap,
            BuiltList<String> productList,
            StaticState staticState,
            BuiltMap<String, UserEntity> userMap,
            String? clientId) =>
        dropdownProductsSelector(
            productMap, productList, staticState, userMap, clientId));

List<String> dropdownProductsSelector(
    BuiltMap<String, ProductEntity> productMap,
    BuiltList<String> productList,
    StaticState staticState,
    BuiltMap<String, UserEntity> userMap,
    String? clientId) {
  final list = productList.where((productId) {
    final product = productMap[productId];
    if (product == null) {
      return false;
    }
    /*
    if (clientId != null && clientId > 0 && product.clientId != clientId) {
      return false;
    }
    */
    return product.isActive;
  }).toList();

  list.sort((productAId, productBId) {
    final productA = productMap[productAId]!;
    final productB = productMap[productBId]!;

    // STARTER: primary field - do not remove comment
    return productA.compareTo(productB, ProductFields.name, true);
  });

  return list;
}

var memoizedFilteredProductList = memo4((SelectionState selectionState,
        BuiltMap<String, ProductEntity> productMap,
        BuiltList<String> productList,
        ListUIState productListState) =>
    filteredProductsSelector(
        selectionState, productMap, productList, productListState));

List<String> filteredProductsSelector(
    SelectionState selectionState,
    BuiltMap<String, ProductEntity> productMap,
    BuiltList<String> productList,
    ListUIState productListState) {
  final filterEntityId = selectionState.filterEntityId;
  // final filterEntityType = selectionState.filterEntityType;

  final filteredList = productList.where((productId) {
    final product = productMap[productId];
    if (product == null) {
      return false;
    }

    if (filterEntityId != null && product.id != filterEntityId) {
      return false;
    }

    if (!product.matchesStates(productListState.stateFilters)) {
      return false;
    }

    // Uncomment if using custom filters in future
    // if (productListState.custom1Filters.isNotEmpty &&
    //     !productListState.custom1Filters.contains(product.customValue1)) {
    //   return false;
    // } else if (productListState.custom2Filters.isNotEmpty &&
    //     !productListState.custom2Filters.contains(product.customValue2)) {
    //   return false;
    // } else if (productListState.custom3Filters.isNotEmpty &&
    //     !productListState.custom3Filters.contains(product.customValue3)) {
    //   return false;
    // } else if (productListState.custom4Filters.isNotEmpty &&
    //     !productListState.custom4Filters.contains(product.customValue4)) {
    //   return false;
    // }

    return product.matchesFilter(productListState.filter);
  }).toList();

  final uniqueProducts = <String, String>{};
  for (final productId in filteredList) {
    final product = productMap[productId];
    if (product != null) {
      uniqueProducts[product.id] = productId;
    }
  }

  final sortedList = uniqueProducts.values.toList();
  // ..sort((productAId, productBId) {
  //   final productA = productMap[productAId]!;
  //   final productB = productMap[productBId]!;
  //   return productA.compareTo(
  //       productB, productListState.sortField, productListState.sortAscending);
  // });

  return sortedList;
}
