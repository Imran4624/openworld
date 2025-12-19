import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/ui/app/scrollable_listview.dart';
import 'package:flutter_boilerplate/ui/notification/view/notification_view_vm.dart';
import 'package:flutter_boilerplate/ui/app/view_scaffold.dart';
// STARTER: import - do not remove comment
import 'package:flutter_boilerplate/data/models/notification_model.dart';
import 'package:flutter_boilerplate/ui/app/FieldGrid.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({
    Key? key,
    required this.viewModel,
    required this.isFilter,
  }) : super(key: key);

  final NotificationViewVM viewModel;
  final bool isFilter;

  @override
  _NotificationViewState createState() => new _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;
    final notification = viewModel.notification;

    return ViewScaffold(
      isFilter: widget.isFilter,
      entity: notification,
      //STARTER: primary field - do not remove comment
      title: notification.title,
      onBackPressed: () => viewModel.onBackPressed(),
      body: ScrollableListView(
        children: <Widget>[
          const SizedBox(height: 16.0),
          FieldGrid(
            {
              // STARTER: field grid - do not remove comment
              NotificationFields.title: notification.title,
              NotificationFields.body: notification.body,
              NotificationFields.type: notification.type,
              NotificationFields.channel: notification.channel,
              NotificationFields.actionUrl: notification.actionUrl,
              NotificationFields.payload: notification.payload,
              NotificationFields.priority: notification.priority,
            },
          ),
        ],
      ),
    );
  }
}
