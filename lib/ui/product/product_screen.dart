import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/product/product_actions.dart';
import 'package:flutter_boilerplate/ui/app/app_bottom_bar.dart';
import 'package:flutter_boilerplate/ui/app/list_scaffold.dart';
import 'package:flutter_boilerplate/ui/app/list_filter.dart';
import 'package:flutter_boilerplate/ui/product/product_list_vm.dart';
import 'package:flutter_boilerplate/ui/product/product_presenter.dart';
import 'package:flutter_boilerplate/utils/localization.dart';

import 'product_screen_vm.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  static const String route = '/product';

  final ProductScreenVM viewModel;

  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    final state = store.state;
    final userCompany = state.userCompany;
    final localization = AppLocalization.of(context)!;

    return ListScaffold(
      entityType: EntityType.product,
      onHamburgerLongPress: () => store.dispatch(StartProductMultiselect()),
      appBarTitle: ListFilter(
        key: ValueKey('__filter_${state.productListState.filterClearedAt}__'),
        entityType: EntityType.product,
        entityIds: viewModel.productList,
        filter: state.productState.filter.searchTerm,
        onFilterChanged: (value) {
          store.dispatch(FilterProducts(value!));
          store.dispatch(UpdateProductFilter(
            state.productState.filter
                .rebuild((b) => b..searchTerm = value ?? ''),
          ));
        },
        onSelectedState: (EntityState filterState, bool? value) {
          store.dispatch(FilterProductsByState(filterState));
          if (value ?? false) {
            store.dispatch(UpdateProductFilter(
              state.productState.filter
                  .rebuild((b) => b..stateFilter = filterState),
            ));
          }
          // print('productFilter state ==> ${state.productState}');
        },
        selectedStateFilter: state.productState.filter.stateFilter,
      ),
      onCheckboxPressed: () {
        if (store.state.productListState.isInMultiselect()) {
          store.dispatch(ClearProductMultiselect());
        } else {
          store.dispatch(StartProductMultiselect());
        }
      },
      body: ProductListBuilder(),
      bottomNavigationBar: AppBottomBar(
        entityType: EntityType.product,
        tableColumns: ProductPresenter.getAllTableFields(userCompany),
        defaultTableColumns:
            ProductPresenter.getDefaultTableFields(userCompany),
        onSelectedSortField: (field) {
          final ascending = state.productState.filter.sortField == field
              ? !state.productState.filter.sortAscending
              : true;
          store.dispatch(UpdateProductFilter(
            state.productState.filter.rebuild((b) => b
              ..sortField = field
              ..sortAscending = ascending),
          ));
        },
        sortFields: [
          // STARTER: constant fields - do not remove comment
          ProductFields.name,
        ],
        onSelectedState: (EntityState filterState, bool? value) {
          store.dispatch(FilterProductsByState(filterState));
          if (value ?? false) {
            store.dispatch(UpdateProductFilter(
              state.productState.filter
                  .rebuild((b) => b..stateFilter = filterState),
            ));
          }
        },
        onCheckboxPressed: () {
          if (store.state.productListState.isInMultiselect()) {
            store.dispatch(ClearProductMultiselect());
          } else {
            store.dispatch(StartProductMultiselect());
          }
        },
        // // customValues1: userCompany.getCustomFieldValues(CustomFieldType.product1,
        // //     excludeBlank: true),
        // // customValues2: userCompany.getCustomFieldValues(CustomFieldType.product2,
        // //     excludeBlank: true),
        // // customValues3: userCompany.getCustomFieldValues(CustomFieldType.product3,
        // //     excludeBlank: true),
        // // customValues4: userCompany.getCustomFieldValues(CustomFieldType.product4,
        //     excludeBlank: true),
        // onSelectedCustom1: (value) =>
        //     store.dispatch(FilterProductsByCustom1(value)),
        // onSelectedCustom2: (value) =>
        //     store.dispatch(FilterProductsByCustom2(value)),
        // onSelectedCustom3: (value) =>
        //     store.dispatch(FilterProductsByCustom3(value)),
        // onSelectedCustom4: (value) =>
        //     store.dispatch(FilterProductsByCustom4(value)),
      ),
      floatingActionButton: state.prefState.isMenuFloated &&
              userCompany.canCreate(EntityType.product)
          ? FloatingActionButton(
              heroTag: 'product_fab',
              backgroundColor: Theme.of(context).primaryColorDark,
              onPressed: () {
                createEntityByType(
                    context: context, entityType: EntityType.product);
              },
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
              tooltip: localization.newProduct,
            )
          : null,
    );
  }
}
