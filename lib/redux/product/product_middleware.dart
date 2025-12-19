import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_boilerplate/project_config.dart';
import 'package:flutter_boilerplate/utils/completers.dart';
import 'package:redux/redux.dart';
import 'package:built_collection/built_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_boilerplate/main_app.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/ui/ui_actions.dart';
import 'package:flutter_boilerplate/ui/product/product_screen.dart';
import 'package:flutter_boilerplate/ui/product/edit/product_edit_vm.dart';
import 'package:flutter_boilerplate/ui/product/view/product_view_vm.dart';
import 'package:flutter_boilerplate/redux/product/product_actions.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/data/repositories/product_repository.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';

List<Middleware<AppState>> createStoreProductsMiddleware([
  ProductRepository repository = const ProductRepository(),
]) {
  final viewProductList = _viewProductList();
  final viewProduct = _viewProduct();
  final editProduct = _editProduct();
  final loadProducts = _loadProducts(repository);
  final loadSingleProduct = _loadSingleProduct(repository);
  final loadProduct = _loadProduct(repository);
  final saveProduct = _saveProduct(repository);
  final archiveProduct = _archiveProduct(repository);
  final deleteProduct = _deleteProduct(repository);
  final purgeProduct = _purgeProduct(repository);
  final restoreProduct = _restoreProduct(repository);
  final updateFilter = _updateFilter(repository);

  return [
    TypedMiddleware<AppState, ViewProductList>(viewProductList),
    TypedMiddleware<AppState, ViewProduct>(viewProduct),
    TypedMiddleware<AppState, EditProduct>(editProduct),
    TypedMiddleware<AppState, LoadProducts>(loadProducts),
    TypedMiddleware<AppState, LoadSingleProductRequest>(loadSingleProduct),
    TypedMiddleware<AppState, LoadProduct>(loadProduct),
    TypedMiddleware<AppState, SaveProductRequest>(saveProduct),
    TypedMiddleware<AppState, ArchiveProductsRequest>(archiveProduct),
    TypedMiddleware<AppState, DeleteProductsRequest>(deleteProduct),
    TypedMiddleware<AppState, PurgeProductsRequest>(purgeProduct),
    TypedMiddleware<AppState, RestoreProductsRequest>(restoreProduct),
    TypedMiddleware<AppState, UpdateProductFilter>(updateFilter),
  ];
}

Middleware<AppState> _editProduct() {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as EditProduct;

    next(action);

    store.dispatch(UpdateCurrentRoute(ProductEditScreen.route));

    if (store.state.prefState.isMobile) {
      navigatorKey.currentState!.pushNamed(ProductEditScreen.route);
    }
  };
}

Middleware<AppState> _viewProduct() {
  return (Store<AppState> store, dynamic dynamicAction,
      NextDispatcher next) async {
    final action = dynamicAction as ViewProduct;

    next(action);

    final fullRoute =
        ProjectConfig.getEntityDetailUrl(EntityType.product, action.productId!);
    store.dispatch(UpdateCurrentRoute(fullRoute));

    if (store.state.prefState.isMobile) {
      navigatorKey.currentState!.pushNamed(ProductViewScreen.route);
    }
  };
}

Middleware<AppState> _viewProductList() {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as ViewProductList;

    next(action);

    if (store.state.staticState.isStale) {
      store.dispatch(RefreshData());
    }

    store.dispatch(UpdateCurrentRoute(ProductScreen.route));

    if (store.state.prefState.isMobile) {
      navigatorKey.currentState!.pushNamedAndRemoveUntil(
          ProductScreen.route, (Route<dynamic> route) => false);
    }
  };
}

Middleware<AppState> _archiveProduct(ProductRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as ArchiveProductsRequest;
    final prevProducts = action.productIds
        .map((id) => store.state.productState.map[id])
        .whereType<ProductEntity>()
        .toList();

    repository
        .bulkAction(
            store.state.credentials, action.productIds, EntityAction.archive)
        .then((List<ProductEntity> products) {
      store.dispatch(ArchiveProductsSuccess(products));
      action.completer.complete(null);
    }).catchError((Object error) {
      logError(' ArchiveProducts error: $error');
      store.dispatch(ArchiveProductsFailure(prevProducts));
      action.completer.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _deleteProduct(ProductRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as DeleteProductsRequest;
    final prevProducts = action.productIds
        .map((id) => store.state.productState.map[id])
        .whereType<ProductEntity>()
        .toList();

    repository
        .bulkAction(
            store.state.credentials, action.productIds, EntityAction.delete)
        .then((List<ProductEntity> products) {
      store.dispatch(DeleteProductsSuccess(products));
      action.completer.complete(null);
    }).catchError((Object error) {
      logError(' DeleteProducts error: $error');
      store.dispatch(DeleteProductsFailure(prevProducts));
      action.completer.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _purgeProduct(ProductRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as PurgeProductsRequest;
    final prevProducts = action.productIds
        .map((id) => store.state.productState.map[id])
        .whereType<ProductEntity>()
        .toList();

    repository
        .bulkAction(
            store.state.credentials, action.productIds, EntityAction.purge)
        .then((List<ProductEntity> products) {
      store.dispatch(PurgeProductsSuccess(products));
      action.completer.complete(null);
    }).catchError((Object error) {
      logError(' PurgeProducts error: $error');
      store.dispatch(PurgeProductsFailure(prevProducts));
      action.completer.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _restoreProduct(ProductRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as RestoreProductsRequest;
    final prevProducts = action.productIds
        .map((id) => store.state.productState.map[id])
        .whereType<ProductEntity>()
        .toList();

    repository
        .bulkAction(
            store.state.credentials, action.productIds, EntityAction.restore)
        .then((List<ProductEntity> products) {
      store.dispatch(RestoreProductsSuccess(products));
      action.completer.complete(null);
    }).catchError((Object error) {
      logError(' RestoreProducts error: $error');
      store.dispatch(RestoreProductsFailure(prevProducts));
      action.completer.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _saveProduct(ProductRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as SaveProductRequest;

    final dynamicFieldsState = store.state.dynamicFieldState;
    final dynamicFieldsData = <String, dynamic>{};

    dynamicFieldsState.answers.forEach((groupId, groupAnswers) {
      groupAnswers.forEach((key, value) {
        if (value == null || (value is String && value.isEmpty)) {
          return;
        }

        if (value is List) {
          final cleanList = value
              .where((item) =>
                  item != null && (item is! String || item.isNotEmpty))
              .toList();

          if (cleanList.isNotEmpty) {
            dynamicFieldsData[key] = cleanList;
          }
        } else if (value is Map) {
          final cleanMap = Map<String, dynamic>.from(value)
            ..removeWhere((_, v) => v == null || (v is String && v.isEmpty));

          if (cleanMap.isNotEmpty) {
            dynamicFieldsData[key] = cleanMap;
          }
        } else {
          dynamicFieldsData[key] = value;
        }
      });
    });

    final updatedProduct = action.product!.isNew
        ? action.product!.rebuild((b) => b
          ..dynamicFields.clear()
          ..dynamicFields.addAll(dynamicFieldsData))
        : action.product!;

    final updatedProductData = action.product ?? updatedProduct;
    repository
        .saveData(store.state.credentials, updatedProductData)
        .then((product) async {
      if (action.product!.isNew) {
        store.dispatch(AddProductSuccess(product));
      } else {
        store.dispatch(SaveProductSuccess(product));
      }

      action.completer?.complete(product);
    }).catchError((Object error) {
      logError(' Error saving product: $error');
      store.dispatch(SaveProductFailure(error));
      action.completer?.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _loadProduct(ProductRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as LoadProduct;

    store.dispatch(LoadProductRequest());
    repository
        .loadItem(store.state.credentials, action.productId!)
        .then((product) {
      store.dispatch(LoadProductSuccess(product));
      action.completer?.complete(null);
    }).catchError((Object error) {
      logError(' Error loading product: $error');
      store.dispatch(LoadProductFailure(error));
      action.completer?.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _loadProducts(ProductRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    if (store.state.isLoading) {
      return;
    }

    final action = dynamicAction as LoadProducts;
    final state = store.state;
    final stateFilters = state.productListState.stateFilters;
    final currentFilter = action.filter ?? state.productState.filter;

    // Update filter with current state filter from listUIState
    final filter = currentFilter.rebuild((b) {
      if (stateFilters.isNotEmpty) {
        b.stateFilter = stateFilters.first; // Use the first state filter
      } else {
        b.stateFilter = EntityState.active; // Default to active
      }
    });
    store.dispatch(LoadProductsRequest(filter: filter));

    var lastDocument = state.productState.lastDocument;
    if (action.isRefresh) {
      lastDocument = null;
      store.dispatch(UpdateLastDocumentAction(null));
    }

    repository
        .loadListWithPagination(
      lastDocument: lastDocument,
      limit: filter.limit,
      filter: filter,
    )
        .then((response) {
      final products = response['products'] as BuiltList<ProductEntity>;
      final newLastDocument = response['lastDocument'] as DocumentSnapshot?;

      store.dispatch(LoadProductsSuccess(products, action.isRefresh));
      if (products.isNotEmpty) {
        store.dispatch(UpdateLastDocumentAction(newLastDocument));
        action.completer?.complete(null);
      } else {
        if (lastDocument != null) {
          snackBarCompleter<void>('No more data available').complete();
        } else {
          snackBarCompleter<void>('No data found').complete();
        }
        action.completer?.complete(null);
      }
    }).catchError((Object error) {
      logError(' Error loading products: $error');
      store.dispatch(LoadProductsFailure(error));
      action.completer?.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _loadSingleProduct(ProductRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction,
      NextDispatcher next) async {
    final action = dynamicAction as LoadSingleProductRequest;

    try {
      final response = await repository.loadSingleProduct(
        lastDocument: action.lastDocument,
        limit: 1,
        filter: action.filter ?? store.state.productState.filter,
      );

      final product = response['product'] as ProductEntity?;
      final newLastDocument = response['lastDocument'] as DocumentSnapshot?;

      if (product != null) {
        store.dispatch(LoadSingleProductSuccess(
          product: product,
          lastDocument: newLastDocument,
          insertIndex: action.insertIndex,
        ));
      }

      action.completer?.complete();
    } catch (error) {
      logError(' Error loading single product: $error');
      action.completer?.completeError(error);
    }

    next(action);
  };
}

Middleware<AppState> _updateFilter(ProductRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as UpdateProductFilter;

    next(action);

    store.dispatch(LoadProducts(
      filter: action.filter,
      isRefresh: true,
    ));
  };
}
