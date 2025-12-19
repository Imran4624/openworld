import 'package:redux/redux.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/company/company_actions.dart';
import 'package:flutter_boilerplate/redux/ui/entity_ui_state.dart';
import 'package:flutter_boilerplate/redux/product/product_actions.dart';
import 'package:flutter_boilerplate/redux/ui/list_ui_state.dart';
import 'package:flutter_boilerplate/redux/product/product_state.dart';

EntityUIState productUIReducer(ProductUIState state, dynamic action) {
  return state.rebuild((b) => b
    ..listUIState.replace(productListReducer(state.listUIState, action))
    ..editing.replace(editingReducer(state.editing, action)!)
    ..selectedId = selectedIdReducer(state.selectedId, action)
    ..forceSelected = forceSelectedReducer(state.forceSelected, action)
    ..tabIndex = tabIndexReducer(state.tabIndex, action));
}

final forceSelectedReducer = combineReducers<bool?>([
  TypedReducer<bool?, ViewProduct>((completer, action) => true),
  TypedReducer<bool?, ViewProductList>((completer, action) => false),
  TypedReducer<bool?, FilterProductsByState>((completer, action) => false),
  TypedReducer<bool?, FilterProducts>((completer, action) => false),
]);

final tabIndexReducer = combineReducers<int?>([
  TypedReducer<int?, UpdateProductTab>((completer, action) => action.tabIndex),
  TypedReducer<int?, PreviewEntity>((completer, action) => 0),
]);

Reducer<String?> selectedIdReducer = combineReducers([
  TypedReducer<String?, ArchiveProductsSuccess>((completer, action) => ''),
  TypedReducer<String?, DeleteProductsSuccess>((completer, action) => ''),
  TypedReducer<String?, PurgeProductsSuccess>((completer, action) => ''),
  TypedReducer<String?, PreviewEntity>((selectedId, action) =>
      action.entityType == EntityType.product ? action.entityId : selectedId),
  TypedReducer<String?, ViewProduct>(
      (String? selectedId, dynamic action) => action.productId),
  TypedReducer<String?, AddProductSuccess>(
      (String? selectedId, dynamic action) => action.product.id),
  TypedReducer<String?, SelectCompany>(
      (selectedId, action) => action.clearSelection ? '' : selectedId),
  TypedReducer<String?, ClearEntityFilter>((selectedId, action) => ''),
  TypedReducer<String?, SortProducts>((selectedId, action) => ''),
  TypedReducer<String?, FilterProducts>((selectedId, action) => ''),
  TypedReducer<String?, FilterProductsByState>((selectedId, action) => ''),
  TypedReducer<String?, FilterByEntity>(
      (selectedId, action) => action.clearSelection
          ? ''
          : action.entityType == EntityType.product
              ? action.entityId
              : selectedId),
]);

final editingReducer = combineReducers<ProductEntity?>([
  TypedReducer<ProductEntity?, SaveProductSuccess>(_updateEditing),
  TypedReducer<ProductEntity?, AddProductSuccess>(_updateEditing),
  TypedReducer<ProductEntity?, RestoreProductsSuccess>((products, action) {
    return action.products[0];
  }),
  TypedReducer<ProductEntity?, ArchiveProductsSuccess>((products, action) {
    return action.products[0];
  }),
  TypedReducer<ProductEntity?, DeleteProductsSuccess>((products, action) {
    return action.products[0];
  }),
  TypedReducer<ProductEntity?, PurgeProductsSuccess>((products, action) {
    return action.products[0];
  }),
  TypedReducer<ProductEntity?, EditProduct>(_updateEditing),
  TypedReducer<ProductEntity?, UpdateProduct>((product, action) {
    return action.product.rebuild((b) => b..isChanged = true);
  }),
  TypedReducer<ProductEntity?, DiscardChanges>(_clearEditing),
]);

ProductEntity _clearEditing(ProductEntity? product, dynamic action) {
  return ProductEntity();
}

ProductEntity? _updateEditing(ProductEntity? product, dynamic action) {
  return action.product;
}

final productListReducer = combineReducers<ListUIState>([
  TypedReducer<ListUIState, SortProducts>(_sortProducts),
  TypedReducer<ListUIState, FilterProductsByState>(_filterProductsByState),
  TypedReducer<ListUIState, FilterProducts>(_filterProducts),
  TypedReducer<ListUIState, StartProductMultiselect>(_startListMultiselect),
  TypedReducer<ListUIState, AddToProductMultiselect>(_addToListMultiselect),
  TypedReducer<ListUIState, RemoveFromProductMultiselect>(
      _removeFromListMultiselect),
  TypedReducer<ListUIState, ClearProductMultiselect>(_clearListMultiselect),
  TypedReducer<ListUIState, ViewProductList>(_viewProductList),
  TypedReducer<ListUIState, FilterByEntity>((state, action) => state.rebuild(
        (b) => b
          ..filter = null
          ..filterClearedAt = DateTime.now().millisecondsSinceEpoch,
      )),
]);

ListUIState _viewProductList(
    ListUIState productListState, ViewProductList action) {
  return productListState.rebuild((b) => b
    ..selectedIds = null
    ..filter = null
    ..filterClearedAt = DateTime.now().millisecondsSinceEpoch);
}

ListUIState _filterProductsByState(
    ListUIState productListState, FilterProductsByState action) {
  if (productListState.stateFilters.contains(action.state)) {
    return productListState.rebuild((b) => b
      ..stateFilters.clear()
      ..stateFilters.add(EntityState.active));
  } else {
    return productListState.rebuild((b) => b
      ..stateFilters.clear()
      ..stateFilters.add(action.state));
  }
}

ListUIState _filterProducts(
    ListUIState productListState, FilterProducts action) {
  return productListState.rebuild((b) => b
    ..filter = action.filter
    ..filterClearedAt = action.filter == null
        ? DateTime.now().millisecondsSinceEpoch
        : productListState.filterClearedAt);
}

ListUIState _sortProducts(ListUIState productListState, SortProducts action) {
  return productListState.rebuild((b) => b
    ..sortAscending = b.sortField != action.field || !b.sortAscending!
    ..sortField = action.field);
}

ListUIState _startListMultiselect(
    ListUIState productListState, StartProductMultiselect action) {
  return productListState.rebuild((b) => b..selectedIds = ListBuilder());
}

ListUIState _addToListMultiselect(
    ListUIState productListState, AddToProductMultiselect action) {
  return productListState.rebuild((b) => b..selectedIds.add(action.entity.id));
}

ListUIState _removeFromListMultiselect(
    ListUIState productListState, RemoveFromProductMultiselect action) {
  return productListState
      .rebuild((b) => b..selectedIds.remove(action.entity.id));
}

ListUIState _clearListMultiselect(
    ListUIState productListState, ClearProductMultiselect action) {
  return productListState.rebuild((b) => b..selectedIds = null);
}

final productsReducer = combineReducers<ProductState>([
  TypedReducer<ProductState, SaveProductSuccess>(_updateProduct),
  TypedReducer<ProductState, AddProductSuccess>(_addProduct),
  TypedReducer<ProductState, LoadProductsSuccess>(_setLoadedProducts),
  TypedReducer<ProductState, LoadProductSuccess>(_setLoadedProduct),
  TypedReducer<ProductState, UpdateLastDocumentAction>(_updateLastDocument),
  TypedReducer<ProductState, UpdateProductFilter>(_updateProductFilter),
  TypedReducer<ProductState, ArchiveProductsSuccess>(_archiveProductSuccess),
  TypedReducer<ProductState, DeleteProductsSuccess>(_deleteProductSuccess),
  TypedReducer<ProductState, PurgeProductsSuccess>(_purgeProductSuccess),
  TypedReducer<ProductState, RestoreProductsSuccess>(_restoreProductSuccess),
  TypedReducer<ProductState, LoadSingleProductSuccess>(
      _handleLoadSingleProductSuccess),
]);

ProductState _archiveProductSuccess(
    ProductState productState, ArchiveProductsSuccess action) {
  final int currentTime = DateTime.now().millisecondsSinceEpoch;
  return productState.rebuild((b) {
    for (final product in action.products) {
      b.map[product.id] = productState.map[product.id]!
          .rebuild((b) => b..archivedAt = currentTime);
    }
  });
}

ProductState _updateProductFilter(
    ProductState productState, UpdateProductFilter action) {
  return productState.rebuild((b) => b..filter = action.filter.toBuilder());
}

// ProductState _deleteProductSuccess(ProductState productState, DeleteProductsSuccess action) {
//   return productState.rebuild((b) {
//     for (final product in action.products) {
//       b.map[product.id] = product;
//     }
//   });
// }

ProductState _deleteProductSuccess(
    ProductState productState, DeleteProductsSuccess action) {
  return productState.rebuild((b) {
    for (final product in action.products) {
      b.map[product.id] =
          productState.map[product.id]!.rebuild((b) => b..isDeleted = true);
    }
  });
}

ProductState _purgeProductSuccess(
    ProductState productState, PurgeProductsSuccess action) {
  return productState.rebuild((b) {
    for (final product in action.products) {
      b.map.remove(product.id);
      b.list.remove(product.id);
    }
  });
}

ProductState _restoreProductSuccess(
    ProductState productState, RestoreProductsSuccess action) {
  return productState.rebuild((b) {
    for (final product in action.products) {
      b.map[product.id] = productState.map[product.id]!.rebuild((b) => b
        ..isDeleted = false
        ..archivedAt = 0);
    }
  });
}

ProductState _handleLoadSingleProductSuccess(
    ProductState state, LoadSingleProductSuccess action) {
  return state.rebuild((b) {
    final newProduct = action.product;

    b.map[newProduct.id] = newProduct;
    if (action.insertIndex != null && action.insertIndex! < b.list.length) {
      b.list.insert(action.insertIndex!, newProduct.id);
    } else {
      b.list.add(newProduct.id);
    }

    if (action.lastDocument != null) {
      b.lastDocument = action.lastDocument;
    }
  });
}

ProductState _addProduct(ProductState productState, AddProductSuccess action) {
  return productState.rebuild((b) => b
    ..map[action.product.id] = action.product
    ..list.add(action.product.id));
}

ProductState _updateProduct(
    ProductState productState, SaveProductSuccess action) {
  return productState
      .rebuild((b) => b..map[action.product.id] = action.product);
}

ProductState _updateLastDocument(
    ProductState productState, UpdateLastDocumentAction action) {
  return productState.rebuild((b) => b..lastDocument = action.lastDocument);
}

ProductState _setLoadedProduct(
    ProductState productState, LoadProductSuccess action) {
  return productState
      .rebuild((b) => b..map[action.product.id] = action.product);
}

ProductState _setLoadedProducts(
    ProductState productState, LoadProductsSuccess action) {
  return productState.rebuild((b) {
    if (action.isRefresh) {
      b.map.clear();
      b.list.clear();
    }
    action.products.forEach((product) {
      b.map[product.id] = product;
      if (!b.list.build().contains(product.id)) {
        b.list.add(product.id);
      }
    });
  });
}

// ProductState _setLoadedCompany(ProductState productState, LoadCompanySuccess action) {
//   final company = action.userCompany.company;
//   return productState.loadProducts(company.products);
// }
