import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/ui/app/edit_scaffold.dart';
import 'package:flutter_boilerplate/ui/app/form_card.dart';
import 'package:flutter_boilerplate/ui/chat/create/create_chat_vm.dart';
import 'package:flutter_boilerplate/utils/localization.dart';
import 'package:flutter_boilerplate/utils/completers.dart';
import 'package:flutter_boilerplate/ui/app/scrollable_listview.dart';

class ChatEdit extends StatefulWidget {
  const ChatEdit({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  final CreateChatVM viewModel;

  @override
  _ChatEditState createState() => _ChatEditState();
}

class _ChatEditState extends State<ChatEdit> {
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(debugLabel: '_chatEdit');
  final _debouncer = Debouncer();

  // STARTER: controllers - do not remove comment

  final _groupNameController = TextEditingController();

  List<TextEditingController> _controllers = [];

  @override
  void didChangeDependencies() {
    _controllers = [
      // STARTER: array - do not remove comment

      _groupNameController,
    ];

    _controllers.forEach((controller) => controller.removeListener(_onChanged));

    final chat = widget.viewModel.chat;
    // STARTER: read value - do not remove comment

    _groupNameController.text = chat.groupName.toString();

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
      final chat = widget.viewModel.chat.rebuild((b) => b
        // STARTER: set value - do not remove comment
        ..groupName = _groupNameController.text.trim());
      if (chat != widget.viewModel.chat) {
        widget.viewModel.onChanged(chat);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;
    final localization = AppLocalization.of(context)!;
    final chat = viewModel.chat;

    return EditScaffold(
      title: chat.isNew ? localization.newChat : localization.editChat,
      onCancelPressed: (context) => viewModel.onCancelPressed(context),
      onSavePressed: (context) {
        final bool isValid = _formKey.currentState!.validate();
        if (!isValid) {
          return;
        }
        viewModel.onSavePressed(context);
      },
      entity: chat,
      body: Form(
        key: _formKey,
        child: Builder(builder: (BuildContext context) {
          return ScrollableListView(
            children: <Widget>[
              FormCard(
                children: <Widget>[
                  // STARTER: widgets - do not remove comment
                  TextFormField(
                    controller: _groupNameController,
                    autocorrect: false,
                    decoration: InputDecoration(
                      labelText: 'Receiver Email',
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
