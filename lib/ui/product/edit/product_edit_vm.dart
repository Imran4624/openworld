import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/redux/ui/ui_actions.dart';
import 'package:redux/redux.dart';
import 'package:flutter_boilerplate/utils/completers.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/ui/app/dialogs/error_dialog.dart';
import 'package:flutter_boilerplate/redux/product/product_actions.dart';
import 'package:flutter_boilerplate/ui/product/edit/product_edit.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_boilerplate/utils/localization.dart';

class ProductEditScreen extends StatelessWidget {
  const ProductEditScreen({Key? key}) : super(key: key);
  static const String route = '/product/edit';

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ProductEditVM>(
      converter: (Store<AppState> store) {
        return ProductEditVM.fromStore(store);
      },
      builder: (context, viewModel) {
        return ProductEdit(
          viewModel: viewModel,
          key: ValueKey(viewModel.product.updatedAt),
        );
      },
    );
  }
}

class ProductEditVM {
  ProductEditVM({
    required this.state,
    required this.product,
    this.company,
    required this.onChanged,
    required this.isSaving,
    this.origProduct,
    required this.onSavePressed,
    required this.onCancelPressed,
    required this.isLoading,
  });

  factory ProductEditVM.fromStore(Store<AppState> store) {
    final state = store.state;
    final product = state.productUIState.editing;

    return ProductEditVM(
      state: state,
      isLoading: state.isLoading,
      isSaving: state.isSaving,
      origProduct: state.productState.map[product!.id],
      product: product,
      company: state.company,
      onChanged: (ProductEntity product) {
        store.dispatch(UpdateProduct(product));
      },
      onCancelPressed: (BuildContext context) {
        createEntity(entity: ProductEntity(), force: true);
        if (state.productUIState.cancelCompleter != null) {
          state.productUIState.cancelCompleter!.complete();
        } else {
          store.dispatch(UpdateCurrentRoute(state.uiState.previousRoute));
        }
      },
      onSavePressed: (BuildContext context) {
        Debouncer.runOnComplete(() async {
          final product = store.state.productUIState.editing!;
          final localization = AppLocalization.of(context)!;
          final Completer<ProductEntity> completer = Completer<ProductEntity>();

          store.dispatch(
              SaveProductRequest(completer: completer, product: product));

          try {
            if (context.mounted) {
              showToast(
                product.isNew
                    ? localization.createdProduct
                    : localization.updatedProduct,
                context: context,
              );
            }
          } catch (error) {
            if (context.mounted) {
              showDialog<ErrorDialog>(
                context: context,
                builder: (BuildContext context) {
                  return ErrorDialog(error);
                },
              );
            }
          }
        });
      },
    );
  }

  final ProductEntity product;
  final CompanyEntity? company;
  final Function(ProductEntity) onChanged;
  final Function(BuildContext) onSavePressed;
  final Function(BuildContext) onCancelPressed;
  final bool isLoading;
  final bool isSaving;
  final ProductEntity? origProduct;
  final AppState state;
}
