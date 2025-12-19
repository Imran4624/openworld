// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';

// Project imports:
import 'package:flutter_boilerplate/data/models/entities.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/utils/formatting.dart';
import 'package:flutter_boilerplate/utils/icons.dart';
import 'package:flutter_boilerplate/utils/localization.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';

class ActivityListTile extends StatelessWidget {
  const ActivityListTile({
    Key? key,
    this.enableNavigation = true,
    required this.activity,
  }) : super(key: key);

  final ActivityEntity activity;
  final bool enableNavigation;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context)!;
    final store = StoreProvider.of<AppState>(context);
    final state = store.state;

    final user = state.userState.map[activity.userId];

    String key = 'activity_${activity.activityTypeId}';
    // if (activity.activityTypeId == kActivityCreatePayment) {
    //   key +=  '_manual';
    // }
    String? title = localization.lookup(key);
    title = activity.getDescription(
      title,
      localization.system,
      localization.recurring,
      user: user,
    );

    return ListTile(
      leading: Icon(activity.isComment
          ? MdiIcons.comment
          : getEntityIcon(activity.entityType)),
      title: Text(activity.isComment
          ? (user?.fullName == null
              ? ''
              : (user!.fullName + ': ' + activity.notes.replaceAll('\n', ' ')))
          : title),
      onTap: !enableNavigation
          ? null
          : () {
              switch (activity.entityType) {
                // toDo: add this to module.sh
                // case EntityType.client:
                //   viewEntityById(
                //       entityId: activity.clientId,
                //       entityType: EntityType.client);
                //   break;
                default:
                  printL(
                      'Error: entity type ${activity.entityType} not handled in activity_list_tile');
              }
            },
      trailing: enableNavigation ? Icon(Icons.navigate_next) : null,
      subtitle: Row(
        children: <Widget>[
          Flexible(
            child: Text((!activity.isComment && activity.notes.isNotEmpty
                    ? localization.lookup(activity.notes).trim() + '\n'
                    : '') +
                formatDate(
                    convertTimestampToDateString(activity.createdAt), context,
                    showTime: true, showSeconds: false) +
                ((activity.ip ?? '').isNotEmpty ? ' • ' + activity.ip! : '')),
          ),
        ],
      ),
    );
  }
}
