// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/config/entity_state_config.dart';
import 'package:flutter_boilerplate/project_config.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';

// Project imports:
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/main_app.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/design/design_actions.dart';
import 'package:flutter_boilerplate/redux/user/user_actions.dart';
import 'package:flutter_boilerplate/services/session_managment_service.dart';
import 'package:flutter_boilerplate/utils/icons.dart';
import 'package:flutter_boilerplate/utils/localization.dart';
// STARTER: import - do not remove comment
import 'package:flutter_boilerplate/redux/payment/payment_actions.dart';
import 'package:flutter_boilerplate/redux/product/product_actions.dart';
import 'package:flutter_boilerplate/redux/photo/photo_actions.dart';
import 'package:flutter_boilerplate/redux/notification/notification_actions.dart';
import 'package:flutter_boilerplate/redux/profile_operation/profile_operation_actions.dart';
import 'package:flutter_boilerplate/redux/profile/profile_actions.dart';
import 'package:flutter_boilerplate/redux/event/event_actions.dart';
import 'package:flutter_boilerplate/redux/chat/chat_actions.dart';

Future<void> showEntityActionsDialog(
    {required List<BaseEntity> entities,
    Completer? completer,
    bool multiselect = false}) async {
  final mainContext = navigatorKey.currentContext;
  final store = StoreProvider.of<AppState>(navigatorKey.currentContext!);
  final state = store.state;

  final actions = <Widget>[];
  final first = entities[0];

  actions.addAll(first
      .getActions(
    userCompany: state.userCompany,
    includeEdit: false,
    multiselect: multiselect,
    isGuest: isGuestUser(state),
    isAuthor: first.createdUserId == getLoggedInUserId(store),
  )
      .map((entityAction) {
    if (entityAction == null ||
        ProjectConfig.addReportToEntityActions(
            first.entityType, entityAction)) {
      return Divider();
    } else {
      return EntityActionListTile(
        entities: entities,
        action: entityAction,
        mainContext: mainContext,
        completer: completer,
      );
    }
  }).toList());

  if (actions.isEmpty) {
    return;
  }

  showDialog<String>(
      context: navigatorKey.currentContext!,
      builder: (BuildContext dialogContext) {
        return SimpleDialog(children: actions);
      });
}

class EntityActionListTile extends StatelessWidget {
  const EntityActionListTile({
    this.entities,
    this.action,
    this.onEntityAction,
    this.mainContext,
    this.completer,
  });

  final List<BaseEntity>? entities;
  final EntityAction? action;
  final BuildContext? mainContext;
  final Completer? completer;
  final Function(BuildContext, List<BaseEntity>, EntityAction)? onEntityAction;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context)!;
    final first = entities!.first;
    String title = localization.lookup(action.toString());
    switch (action) {
      case EntityAction.archive:
        title =
            EntityStateManager.getArchiveActionText(first.entityType!, first);
        break;
      case EntityAction.delete:
        title =
            EntityStateManager.getDeleteActionText(first.entityType!, first);
        break;
      case EntityAction.restore:
        title =
            EntityStateManager.getRestoreActionText(first.entityType!, first);
        break;
      default:
        title;
    }
    return ListTile(
      leading: Icon(getEntityActionIcon(action)),
      title: Text(
        title,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () {
        if (completer != null) {
          completer!.complete(null);
        }
        Navigator.of(context).pop();
        final first = entities!.first;
        switch (first.entityType) {
          case EntityType.user:
            handleUserAction(mainContext, entities!, action);
            break;
          case EntityType.design:
            handleDesignAction(mainContext, entities!, action);
            break;
          // STARTER: actions - do not remove comment
          case EntityType.payment:
            handlePaymentAction(context, entities!, action!);
            break;
          case EntityType.product:
            handleProductAction(context, entities!, action!);
            break;
          case EntityType.photo:
            handlePhotoAction(context, entities!, action!);
            break;
 
          case EntityType.notification:
            handleNotificationAction(context, entities!, action!);
            break;
          case EntityType.profileOperation:
            handleProfileOperationAction(context, entities!, action!);
            break;
          case EntityType.profile:
            handleProfileAction(context, entities!, action!);
            break;
          case EntityType.event:
            handleEventAction(context, entities!, action!);
            break;
          case EntityType.chat:
            handleChatAction(context, entities!, action!);
            break;
          default:
            throw ' Error: hanldeAction not defined for entityType ${first.entityType}';
        }
      },
    );
  }
}
