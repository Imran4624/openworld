import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/ui/app/edit_scaffold.dart';
import 'package:flutter_boilerplate/ui/app/form_card.dart';
import 'package:flutter_boilerplate/ui/profile_operation/edit/profile_operation_edit_vm.dart';
import 'package:flutter_boilerplate/utils/localization.dart';
import 'package:flutter_boilerplate/utils/completers.dart';
import 'package:flutter_boilerplate/ui/app/scrollable_listview.dart';

class ProfileOperationEdit extends StatefulWidget {
  const ProfileOperationEdit({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  final ProfileOperationEditVM viewModel;

  @override
  _ProfileOperationEditState createState() => _ProfileOperationEditState();
}

class _ProfileOperationEditState extends State<ProfileOperationEdit> {
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(debugLabel: '_profileOperationEdit');
  final _debouncer = Debouncer();

  // STARTER: controllers - do not remove comment
  final _statusController = TextEditingController();
  final _commentController = TextEditingController();
  final _typeController = TextEditingController();
  List<TextEditingController> _controllers = [];

  @override
  void didChangeDependencies() {
    _controllers = [
      // STARTER: array - do not remove comment
      _statusController,
      _commentController,
      _typeController,
    ];

    _controllers.forEach((controller) => controller.removeListener(_onChanged));

    final profileOperation = widget.viewModel.profileOperation;
    // STARTER: read value - do not remove comment
    _statusController.text = profileOperation.status.toString();
    _commentController.text = profileOperation.comment.toString();
    _typeController.text = profileOperation.type.toString();

    _controllers.forEach((controller) => controller.addListener(_onChanged));

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controllers.forEach((controller) {
      controller.removeListener(_onChanged);
      controller.dispose();
    });

    super.dispose();
  }

  void _onChanged() {
    _debouncer.run(() {
      final profileOperation =
          widget.viewModel.profileOperation.rebuild((b) => b
            // STARTER: set value - do not remove comment
            ..status = int.tryParse(_statusController.text.trim()) ?? 0
            ..comment = _commentController.text.trim()
            ..type = int.tryParse(_typeController.text.trim()) ?? 0);
      if (profileOperation != widget.viewModel.profileOperation) {
        widget.viewModel.onChanged(profileOperation);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;
    final localization = AppLocalization.of(context)!;
    final profileOperation = viewModel.profileOperation;

    return EditScaffold(
      title: profileOperation.isNew
          ? localization.newProfileOperation
          : localization.editProfileOperation,
      onCancelPressed: (context) => viewModel.onCancelPressed(context),
      onSavePressed: (context) {
        final bool isValid = _formKey.currentState!.validate();
        if (!isValid) {
          return;
        }
        viewModel.onSavePressed(context);
      },
      entity: profileOperation,
      body: Form(
        key: _formKey,
        child: Builder(builder: (BuildContext context) {
          return ScrollableListView(
            children: <Widget>[
              FormCard(
                children: <Widget>[
                  // STARTER: widgets - do not remove comment
                  TextFormField(
                    controller: _statusController,
                    autocorrect: false,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Status',
                    ),
                  ),
                  TextFormField(
                    controller: _commentController,
                    autocorrect: false,
                    decoration: InputDecoration(
                      labelText: 'Comment',
                    ),
                  ),
                  TextFormField(
                    controller: _typeController,
                    autocorrect: false,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Type',
                    ),
                  ),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }
}
