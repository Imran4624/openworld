import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/ui/event/edit/event_edit_vm.dart';
import 'package:flutter_boilerplate/ui/event/edit/event_edit_opw.dart';
import 'package:flutter_boilerplate/project_config.dart';

class EventEdit extends StatefulWidget {
  const EventEdit({
    super.key,
    required this.viewModel,
  });

  final EventEditVM viewModel;

  @override
  _EventEditState createState() => _EventEditState();
}

class _EventEditState extends State<EventEdit> {
  @override
  Widget build(BuildContext context) {
    switch (ProjectConfig.appType) {
      
      case AppType.opw:
        return EventEditOpw(viewModel: widget.viewModel);
      default:
        return EventEditOpw(viewModel: widget.viewModel);
    }
  }
}
