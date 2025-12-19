import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/project_config.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/ui/dynamic_fields/dynamic_field_load_questions.dart';
import 'package:flutter_boilerplate/ui/dynamic_fields/dynamic_fields_view_edit.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/redux/dynamicField/dynamic_field_actions.dart';
import 'package:flutter_boilerplate/ui/app/edit_scaffold.dart';
import 'package:flutter_boilerplate/ui/product/edit/product_edit_vm.dart';
import 'package:flutter_boilerplate/utils/localization.dart';
import 'package:flutter_boilerplate/utils/completers.dart';
import 'package:flutter_boilerplate/ui/dynamic_fields/dynamic_fields_create.dart';

class ProductEdit extends StatefulWidget {
  const ProductEdit({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  final ProductEditVM viewModel;

  @override
  _ProductEditState createState() => _ProductEditState();
}

class _ProductEditState extends State<ProductEdit> {
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(debugLabel: '_productEdit');
  final _debouncer = Debouncer();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final store = StoreProvider.of<AppState>(context);
        if (!widget.viewModel.product.isNew) {
          store.dispatch(LoadAnswersSuccess(
              widget.viewModel.product.dynamicFields.toMap()));
        }
        loadDynamicFieldQuestions(ProjectConfig.onBoardingQuestionType);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;
    final localization = AppLocalization.of(context)!;
    final product = viewModel.product;

    return EditScaffold(
      title: product.isNew ? localization.newProduct : localization.editProduct,
      onCancelPressed: (context) => viewModel.onCancelPressed(context),
      onSavePressed: (context) {
        final bool isValid = _formKey.currentState!.validate();
        if (!isValid) {
          return;
        }
        viewModel.onSavePressed(context);
      },
      entity: product,
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: product.isNew
                    ? const DynamicFieldsCreate()
                    : const EditOverviewScreen(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}