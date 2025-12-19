import 'dart:async';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/utils/completers.dart';
import 'package:flutter_boilerplate/utils/localization.dart';
import 'package:redux/redux.dart';
import 'package:flutter_boilerplate/redux/ui/ui_actions.dart';
import 'package:flutter_boilerplate/ui/product/product_screen.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/redux/product/product_actions.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/ui/product/view/product_view.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';

class ProductViewScreen extends StatelessWidget {
  const ProductViewScreen({
    Key? key,
    this.isFilter = false,
  }) : super(key: key);

  static const String route = '/product/view';

  final bool isFilter;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ProductViewVM>(
      converter: (Store<AppState> store) {
        return ProductViewVM.fromStore(store);
      },
      builder: (context, vm) {
        return ProductView(
          viewModel: vm,
          isFilter: isFilter,
        );
      },
    );
  }
}

class ProductViewVM {
  ProductViewVM({
    required this.state,
    required this.product,
    required this.company,
    required this.onEntityAction,
    required this.onRefreshed,
    required this.isSaving,
    required this.isLoading,
    required this.isDirty,
    required this.onBackPressed,
  });

  factory ProductViewVM.fromStore(Store<AppState> store) {
    final state = store.state;
    final product = state.productState.map[state.productUIState.selectedId] ??
        ProductEntity(id: state.productUIState.selectedId);

    Future<Null> _handleRefresh(BuildContext context) {
      final completer =
          snackBarCompleter<Null>(AppLocalization.of(context)!.refreshComplete);
      store.dispatch(LoadProduct(completer: completer, productId: product.id));
      return completer.future;
    }

    return ProductViewVM(
      state: state,
      company: state.company,
      isSaving: state.isSaving,
      isLoading: state.isLoading,
      isDirty: product.isNew,
      product: product,
      onRefreshed: (context) => _handleRefresh(context),
      onBackPressed: () {
        store.dispatch(UpdateCurrentRoute(ProductScreen.route));
      },
      onEntityAction: (BuildContext context, EntityAction action) =>
          handleEntitiesActions([product], action, autoPop: true),
    );
  }

  final AppState state;
  final ProductEntity product;
  final CompanyEntity company;
  final Function(BuildContext, EntityAction) onEntityAction;
  final Function(BuildContext) onRefreshed;
  final Function onBackPressed;
  final bool isSaving;
  final bool isLoading;
  final bool isDirty;
}
