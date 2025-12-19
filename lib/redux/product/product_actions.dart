import 'dart:async';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/utils/completers.dart';
import 'package:flutter_boilerplate/utils/localization.dart';
import 'package:flutter_boilerplate/ui/app/entities/entity_actions_dialog.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';

class ViewProductList implements PersistUI {
  ViewProductList({this.force = false, this.page = 0});

  final bool force;
  final int page;

  @override
  String toString() {
    return 'ViewProductList';
  }
}

class ViewProduct implements PersistUI, PersistPrefs {
  ViewProduct({
    this.productId,
    this.force = false,
  });

  final String? productId;
  final bool force;

  @override
  String toString() {
    return 'ViewProduct';
  }
}

class EditProduct implements PersistUI, PersistPrefs {
  EditProduct({
    required this.product,
    this.completer,
    this.force = false,
  });

  final ProductEntity product;
  final Completer? completer;
  final bool force;

  @override
  String toString() {
    return 'EditProduct';
  }
}

class UpdateProduct implements PersistUI {
  UpdateProduct(this.product);

  final ProductEntity product;

  @override
  String toString() {
    return 'UpdateProduct';
  }
}

class LoadProduct {
  LoadProduct({this.completer, this.productId});

  final Completer? completer;
  final String? productId;

  @override
  String toString() {
    return 'LoadProduct';
  }
}

class LoadProductActivity {
  LoadProductActivity({this.completer, this.productId});

  final Completer? completer;
  final String? productId;

  @override
  String toString() {
    return 'LoadProductActivity';
  }
}

class UpdateLastDocumentAction {
  UpdateLastDocumentAction(this.lastDocument);
  final DocumentSnapshot? lastDocument;

  @override
  String toString() {
    return 'UpdateLastDocumentAction';
  }
}

class LoadProductRequest implements StartLoading {
  @override
  String toString() {
    return 'LoadProductRequest';
  }
}

class LoadProductFailure implements StopLoading {
  LoadProductFailure(this.error);

  final dynamic error;

  @override
  String toString() {
    return 'LoadProductFailure{error: $error}';
  }
}

class LoadProductSuccess implements StopLoading, PersistData {
  LoadProductSuccess(this.product);

  final ProductEntity product;

  @override
  String toString() {
    return 'LoadProductSuccess';
  }
}

class LoadProductsFailure implements StopLoading {
  LoadProductsFailure(this.error);

  final dynamic error;

  @override
  String toString() {
    return 'LoadProductsFailure{error: $error}';
  }
}

class LoadProductsSuccess implements StopLoading {
  LoadProductsSuccess(this.products, this.isRefresh);

  final BuiltList<ProductEntity> products;
  final bool isRefresh;

  @override
  String toString() {
    return 'LoadProductsSuccess';
  }
}

class SaveProductRequest implements StartSaving {
  SaveProductRequest({this.completer, this.product});

  final Completer? completer;
  final ProductEntity? product;

  @override
  String toString() {
    return 'SaveProductRequest';
  }
}

class SaveProductSuccess implements StopSaving, PersistData, PersistUI {
  SaveProductSuccess(this.product);

  final ProductEntity product;

  @override
  String toString() {
    return 'SaveProductSuccess';
  }
}

class AddProductSuccess implements StopSaving, PersistData, PersistUI {
  AddProductSuccess(this.product);

  final ProductEntity product;

  @override
  String toString() {
    return 'AddProductSuccess';
  }
}

class SaveProductFailure implements StopSaving {
  SaveProductFailure(this.error);

  final Object error;

  @override
  String toString() {
    return 'SaveProductFailure{error: $error}';
  }
}

class ArchiveProductsRequest implements StartSaving {
  ArchiveProductsRequest(this.completer, this.productIds);

  final Completer completer;
  final List<String> productIds;

  @override
  String toString() {
    return 'ArchiveProductsRequest';
  }
}

class ArchiveProductsSuccess implements StopSaving, PersistData {
  ArchiveProductsSuccess(this.products);

  final List<ProductEntity> products;

  @override
  String toString() {
    return 'ArchiveProductsSuccess';
  }
}

class ArchiveProductsFailure implements StopSaving {
  ArchiveProductsFailure(this.products);

  final List<ProductEntity> products;

  @override
  String toString() {
    return 'ArchiveProductsFailure{products: $products}';
  }
}

class DeleteProductsRequest implements StartSaving {
  DeleteProductsRequest(this.completer, this.productIds);

  final Completer completer;
  final List<String> productIds;

  @override
  String toString() {
    return 'DeleteProductsRequest';
  }
}

class PurgeProductsRequest implements StartSaving {
  PurgeProductsRequest(this.completer, this.productIds);

  final Completer completer;
  final List<String> productIds;

  @override
  String toString() {
    return 'PurgeProductsRequest';
  }
}

class DeleteProductsSuccess implements StopSaving, PersistData {
  DeleteProductsSuccess(this.products);

  final List<ProductEntity> products;

  @override
  String toString() {
    return 'DeleteProductsSuccess';
  }
}

class PurgeProductsSuccess implements StopSaving, PersistData {
  PurgeProductsSuccess(this.products);

  final List<ProductEntity> products;

  @override
  String toString() {
    return 'PurgeProductsSuccess';
  }
}

class DeleteProductsFailure implements StopSaving {
  DeleteProductsFailure(this.products);

  final List<ProductEntity> products;

  @override
  String toString() {
    return 'DeleteProductsFailure{products: $products}';
  }
}

class PurgeProductsFailure implements StopSaving {
  PurgeProductsFailure(this.products);

  final List<ProductEntity> products;

  @override
  String toString() {
    return 'PurgeProductsFailure{products: $products}';
  }
}

class RestoreProductsRequest implements StartSaving {
  RestoreProductsRequest(this.completer, this.productIds);

  final Completer completer;
  final List<String> productIds;

  @override
  String toString() {
    return 'RestoreProductsRequest';
  }
}

class RestoreProductsSuccess implements StopSaving, PersistData {
  RestoreProductsSuccess(this.products);

  final List<ProductEntity> products;

  @override
  String toString() {
    return 'RestoreProductsSuccess';
  }
}

class RestoreProductsFailure implements StopSaving {
  RestoreProductsFailure(this.products);

  final List<ProductEntity> products;

  @override
  String toString() {
    return 'RestoreProductsFailure{products: $products}';
  }
}

class FilterProducts implements PersistUI {
  FilterProducts(this.filter);

  final String filter;

  @override
  String toString() {
    return 'FilterProducts';
  }
}

class SortProducts implements PersistUI, PersistPrefs {
  SortProducts(this.field);

  final String field;

  @override
  String toString() {
    return 'SortProducts';
  }
}

class FilterProductsByState implements PersistUI {
  FilterProductsByState(this.state);

  final EntityState state;

  @override
  String toString() {
    return 'FilterProductsByState';
  }
}

class LoadSingleProductRequest {
  LoadSingleProductRequest({
    this.completer,
    this.filter,
    this.lastDocument,
    this.insertIndex,
  });

  final Completer? completer;
  final ProductFilter? filter;
  final DocumentSnapshot? lastDocument;
  final int? insertIndex;

  @override
  String toString() {
    return 'LoadSingleProductRequest';
  }
}

class LoadSingleProductSuccess {
  LoadSingleProductSuccess({
    required this.product,
    this.lastDocument,
    this.insertIndex,
  });

  final ProductEntity product;
  final DocumentSnapshot? lastDocument;
  final int? insertIndex;

  @override
  String toString() {
    return 'LoadSingleProductSuccess';
  }
}

class StartProductMultiselect {
  StartProductMultiselect();

  @override
  String toString() {
    return 'StartProductMultiselect';
  }
}

class AddToProductMultiselect {
  AddToProductMultiselect({required this.entity});

  final BaseEntity entity;

  @override
  String toString() {
    return 'AddToProductMultiselect';
  }
}

class RemoveFromProductMultiselect {
  RemoveFromProductMultiselect({required this.entity});

  final BaseEntity entity;

  @override
  String toString() {
    return 'RemoveFromProductMultiselect';
  }
}

class ClearProductMultiselect {
  ClearProductMultiselect();

  @override
  String toString() {
    return 'ClearProductMultiselect';
  }
}

class UpdateProductTab implements PersistUI {
  UpdateProductTab({this.tabIndex});

  final int? tabIndex;

  @override
  String toString() {
    return 'UpdateProductTab';
  }
}

class UpdateProductFilter implements PersistUI {
  UpdateProductFilter(this.filter);
  final ProductFilter filter;

  @override
  String toString() {
    return 'UpdateProductFilter';
  }
}

class LoadProducts {
  LoadProducts({
    this.completer,
    this.filter,
    this.page = 0,
    this.isRefresh = false,
  });

  final Completer? completer;
  final ProductFilter? filter;
  final int page;
  final bool isRefresh;

  @override
  String toString() {
    return 'LoadProducts';
  }
}

class LoadProductsRequest implements StartLoading {
  LoadProductsRequest({this.filter});
  final ProductFilter? filter;

  @override
  String toString() {
    return 'LoadProductsRequest';
  }
}

void handleProductAction(
    BuildContext context, List<BaseEntity> products, EntityAction action) {
  if (products.isEmpty) {
    return;
  }

  final store = StoreProvider.of<AppState>(context);
  final localization = AppLocalization.of(context)!;
  final product = products.first as ProductEntity;
  final productIds = products.map((product) => product.id).toList();

  switch (action) {
    case EntityAction.edit:
      editEntity(entity: product);
      break;
    case EntityAction.restore:
      store.dispatch(RestoreProductsRequest(
          snackBarCompleter<Null>(localization.restoredProduct), productIds));
      break;
    case EntityAction.archive:
      store.dispatch(ArchiveProductsRequest(
          snackBarCompleter<Null>(localization.archivedProduct), productIds));
      break;
    case EntityAction.delete:
      store.dispatch(DeleteProductsRequest(
          snackBarCompleter<Null>(localization.deletedProduct), productIds));
      break;
    case EntityAction.purge:
      store.dispatch(PurgeProductsRequest(
          snackBarCompleter<Null>(localization.deletedProduct), productIds));
      break;
    case EntityAction.toggleMultiselect:
      if (!store.state.productListState.isInMultiselect()) {
        store.dispatch(StartProductMultiselect());
      }

      if (products.isEmpty) {
        break;
      }

      for (final product in products) {
        if (!store.state.productListState.isSelected(product.id)) {
          store.dispatch(AddToProductMultiselect(entity: product));
        } else {
          store.dispatch(RemoveFromProductMultiselect(entity: product));
        }
      }
      break;
    case EntityAction.more:
      showEntityActionsDialog(
        entities: [product],
      );
      break;
    default:
  logError('unhandled action $action in product_actions');
      break;
  }
}
