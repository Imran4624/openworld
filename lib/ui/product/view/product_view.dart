import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/ui/app/scrollable_listview.dart';
import 'package:flutter_boilerplate/ui/product/view/product_view_vm.dart';
import 'package:flutter_boilerplate/ui/app/view_scaffold.dart';
import 'package:flutter_boilerplate/data/models/product_model.dart';
import 'package:flutter_boilerplate/ui/app/FieldGrid.dart';
import 'package:flutter_boilerplate/ui/dynamic_fields/dynamic_fields_view_edit.dart';

class ProductView extends StatefulWidget {
  const ProductView({
    Key? key,
    required this.viewModel,
    required this.isFilter,
  }) : super(key: key);

  final ProductViewVM viewModel;
  final bool isFilter;

  @override
  _ProductViewState createState() => new _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;
    final product = viewModel.product;

    return ViewScaffold(
      isFilter: widget.isFilter,
      entity: product,
      //STARTER: primary field - do not remove comment
      title: product.name,
      onBackPressed: () => viewModel.onBackPressed(),
      body: ScrollableListView(
        children: <Widget>[
          const SizedBox(height: 16.0),
          
          if (product.dynamicFields.isNotEmpty)
            buildFormattedDataView(product, context)
          else
            FieldGrid(
              {
                // STARTER: field grid - do not remove comment
                ProductFields.name: product.name,
              },
            ),
        ],
      ),
    );
  }
}