import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/ui/app/edit_scaffold.dart';
import 'package:flutter_boilerplate/ui/app/form_card.dart';
import 'package:flutter_boilerplate/ui/notification/edit/notification_edit_vm.dart';
import 'package:flutter_boilerplate/utils/localization.dart';
import 'package:flutter_boilerplate/utils/completers.dart';
import 'package:flutter_boilerplate/ui/app/scrollable_listview.dart';

class NotificationEdit extends StatefulWidget {
  const NotificationEdit({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  final NotificationEditVM viewModel;

  @override
  _NotificationEditState createState() => _NotificationEditState();
}

class _NotificationEditState extends State<NotificationEdit> {
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(debugLabel: '_notificationEdit');
  final _debouncer = Debouncer();

  // STARTER: controllers - do not remove comment
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final _typeController = TextEditingController();
  final _channelController = TextEditingController();
  final _actionUrlController = TextEditingController();
  final _payloadController = TextEditingController();
  final _priorityController = TextEditingController();
  List<TextEditingController> _controllers = [];

  @override
  void didChangeDependencies() {
    _controllers = [
      // STARTER: array - do not remove comment
      _titleController,
      _bodyController,
      _typeController,
      _channelController,
      _actionUrlController,
      _payloadController,
      _priorityController,
    ];

    _controllers.forEach((controller) => controller.removeListener(_onChanged));

    final notification = widget.viewModel.notification;
    // STARTER: read value - do not remove comment
    _titleController.text = notification.title.toString();
    _bodyController.text = notification.body.toString();
    _typeController.text = notification.type.toString();
    _channelController.text = notification.channel.toString();
    _actionUrlController.text = notification.actionUrl.toString();
    _payloadController.text = notification.payload.toString();
    _priorityController.text = notification.priority.toString();

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
      final notification = widget.viewModel.notification.rebuild((b) => b
        // STARTER: set value - do not remove comment
        ..title = _titleController.text.trim()
        ..body = _bodyController.text.trim()
        ..type = _typeController.text.trim()
        ..channel = _channelController.text.trim()
        ..actionUrl = _actionUrlController.text.trim()
        ..payload = _payloadController.text.trim()
        ..priority = _priorityController.text.trim());
      if (notification != widget.viewModel.notification) {
        widget.viewModel.onChanged(notification);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;
    final localization = AppLocalization.of(context)!;
    final notification = viewModel.notification;

    return EditScaffold(
      title: notification.isNew
          ? localization.newNotification
          : localization.editNotification,
      onCancelPressed: (context) => viewModel.onCancelPressed(context),
      onSavePressed: (context) {
        final bool isValid = _formKey.currentState!.validate();
        if (!isValid) {
          return;
        }
        viewModel.onSavePressed(context);
      },
      entity: notification,
      body: Form(
        key: _formKey,
        child: Builder(builder: (BuildContext context) {
          return ScrollableListView(
            children: <Widget>[
              FormCard(
                children: <Widget>[
                  // STARTER: widgets - do not remove comment
                  TextFormField(
                    controller: _titleController,
                    autocorrect: false,
                    decoration: InputDecoration(
                      labelText: 'Title',
                    ),
                  ),
                  TextFormField(
                    controller: _bodyController,
                    autocorrect: false,
                    decoration: InputDecoration(
                      labelText: 'Body',
                    ),
                  ),
                  TextFormField(
                    controller: _typeController,
                    autocorrect: false,
                    decoration: InputDecoration(
                      labelText: 'Type',
                    ),
                  ),
                  TextFormField(
                    controller: _channelController,
                    autocorrect: false,
                    decoration: InputDecoration(
                      labelText: 'Channel',
                    ),
                  ),
                  TextFormField(
                    controller: _actionUrlController,
                    autocorrect: false,
                    decoration: InputDecoration(
                      labelText: 'ActionUrl',
                    ),
                  ),
                  TextFormField(
                    controller: _payloadController,
                    autocorrect: false,
                    decoration: InputDecoration(
                      labelText: 'Payload',
                    ),
                  ),
                  TextFormField(
                    controller: _priorityController,
                    autocorrect: false,
                    decoration: InputDecoration(
                      labelText: 'Priority',
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
