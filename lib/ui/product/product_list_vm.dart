import 'dart:async';
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/ui/app/tables/improvedEntityList.dart';
import 'package:flutter_boilerplate/ui/product/product_grid_item.dart';
import 'package:flutter_boilerplate/ui/product/product_presenter.dart';
import 'package:redux/redux.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter_boilerplate/redux/ui/list_ui_state.dart';
import 'package:flutter_boilerplate/redux/product/product_selectors.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/product/product_actions.dart';

class ProductListBuilder extends StatelessWidget {
  const ProductListBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ProductListVM>(
      converter: ProductListVM.fromStore,
      builder: (context, viewModel) {
        return ImprovedEntityList(
          entityType: EntityType.product,
          presenter: ProductPresenter(),
          state: viewModel.state,
          entityList: viewModel.productList,
          tableColumns: viewModel.tableColumns,
          onRefreshed: viewModel.onRefreshed,
          onSortColumn: viewModel.onSortColumn,
          viewType: ViewType.grid,
          onClearMultiselect: viewModel.onClearMultiselect,
          itemBuilder: (BuildContext context, index) {
            final state = viewModel.state;
            final productId = viewModel.productList[index];
            final product = viewModel.productMap[productId]!;
            final listState = state.getListState(EntityType.product);
            final isInMultiselect = listState.isInMultiselect();

            
              return ProductGridItem(
                product: product,
                onTap: () => selectEntity(entity: product),
                onLongPress: () => selectEntity(entity: product, longPress: true),
                isInMultiselect: isInMultiselect,
                isChecked: isInMultiselect && listState.isSelected(product.id),
              );
          },
        );
      },
    );
  }
}

class ProductListVM {
  ProductListVM({
    required this.state,
    required this.userCompany,
    required this.productList,
    required this.productMap,
    required this.filter,
    required this.isLoading,
    required this.listState,
    required this.onRefreshed,
    required this.onEntityAction,
    required this.tableColumns,
    required this.onSortColumn,
    required this.onClearMultiselect,
  });

  static ProductListVM fromStore(Store<AppState> store) {
    Future<void> handleRefresh(BuildContext context) {
      if (store.state.isLoading) {
        return Future<void>.value();
      }

      final completer = Completer<void>();

      store.dispatch(LoadProducts(
          completer: completer, filter: store.state.productState.filter));

      return completer.future;
    }

    final state = store.state;

    return ProductListVM(
      state: state,
      userCompany: state.userCompany,
      listState: state.productListState,
      productList: memoizedFilteredProductList(
        state.getUISelection(EntityType.product),
        state.productState.map,
        state.productState.list,
        state.productListState,
      ),
      productMap: state.productState.map,
      isLoading: state.isLoading,
      filter: state.productState.filter.searchTerm,
      onEntityAction: (BuildContext context, List<BaseEntity> products,
              EntityAction action) =>
          handleProductAction(context, products, action),
      onRefreshed: (context) => handleRefresh(context),
      tableColumns:
          state.userCompany.settings.getTableColumns(EntityType.product) ??
              ProductPresenter.getDefaultTableFields(state.userCompany),
      onSortColumn: (field) => store.dispatch(UpdateProductFilter(
        state.productState.filter.rebuild((b) => b
          ..sortField = field
          ..sortAscending = state.productState.filter.sortField == field
              ? !state.productState.filter.sortAscending
              : true),
      )),
      onClearMultiselect: () => store.dispatch(ClearProductMultiselect()),
    );
  }

  final AppState state;
  final UserCompanyEntity userCompany;
  final List<String> productList;
  final BuiltMap<String, ProductEntity> productMap;
  final ListUIState listState;
  final String? filter;
  final bool isLoading;
  final Function(BuildContext) onRefreshed;
  final Function(BuildContext, List<BaseEntity>, EntityAction) onEntityAction;
  final List<String> tableColumns;
  final Function(String) onSortColumn;
  final Function onClearMultiselect;
}
