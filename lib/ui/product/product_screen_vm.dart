import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/product/product_actions.dart';
import 'package:flutter_boilerplate/redux/product/product_selectors.dart';
import 'package:redux/redux.dart';

import 'product_screen.dart';

class ProductScreenBuilder extends StatelessWidget {
  const ProductScreenBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ProductScreenVM>(
      converter: ProductScreenVM.fromStore,
      builder: (context, vm) {
        return ProductScreen(
          viewModel: vm,
        );
      },
    );
  }
}

class ProductScreenVM {
  ProductScreenVM({
    required this.isInMultiselect,
    required this.productList,
    required this.userCompany,
    required this.onEntityAction,
    required this.productMap,
  });

  final bool isInMultiselect;
  final UserCompanyEntity userCompany;
  final List<String> productList;
  final Function(BuildContext, List<BaseEntity>, EntityAction) onEntityAction;
  final BuiltMap<String, ProductEntity> productMap;

  static ProductScreenVM fromStore(Store<AppState> store) {
    final state = store.state;

    return ProductScreenVM(
      productMap: state.productState.map,
      productList: memoizedFilteredProductList(
        state.getUISelection(EntityType.product),
        state.productState.map,
        state.productState.list,
        state.productListState,
      ),
      userCompany: state.userCompany,
      isInMultiselect: state.productListState.isInMultiselect(),
      onEntityAction: (BuildContext context, List<BaseEntity> products,
              EntityAction action) =>
          handleProductAction(context, products, action),
    );
  }
}
