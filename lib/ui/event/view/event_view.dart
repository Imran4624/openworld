import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/ui/event/view/event_view_vm.dart';
import 'package:flutter_boilerplate/ui/event/view/event_view_default.dart';
import 'package:flutter_boilerplate/ui/event/view/event_view_opw.dart';
import 'package:flutter_boilerplate/project_config.dart';

class EventView extends StatefulWidget {
  const EventView({
    super.key,
    required this.viewModel,
    required this.isFilter,
    required this.isTopFilter,
    this.tabIndex = 0,
  });

  final EventViewVM viewModel;
  final bool isFilter;
  final bool isTopFilter;
  final int tabIndex;

  @override
  EventViewState createState() => EventViewState();
}

class EventViewState extends State<EventView> {
  @override
  Widget build(BuildContext context) {
    switch (ProjectConfig.appType) {
      case AppType.opw:
        return EventViewOpw(
          viewModel: widget.viewModel,
          isFilter: widget.isFilter,
          isTopFilter: widget.isTopFilter,
          tabIndex: widget.tabIndex,
        );
      default:
        return EventViewDefault(
          viewModel: widget.viewModel,
          isFilter: widget.isFilter,
          isTopFilter: widget.isTopFilter,
          tabIndex: widget.tabIndex,
        );
    }
  }
}
