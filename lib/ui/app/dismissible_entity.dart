// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/config/entity_state_config.dart';
// Removed unused project_config import

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

// Project imports:
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/data/models/static/app_theme.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
// Removed unused session management import
import 'package:flutter_boilerplate/ui/app/lists/selected_indicator.dart';
import 'package:flutter_boilerplate/utils/localization.dart';
import 'package:flutter_boilerplate/utils/platforms.dart';

class DismissibleEntity extends StatelessWidget {
  const DismissibleEntity({
    required this.userCompany,
    required this.entity,
    required this.child,
    required this.isSelected,
    this.showMultiselect = true,
    this.isDismissible = true,
  });

  final UserCompanyEntity userCompany;
  final BaseEntity entity;
  final Widget child;
  final bool isSelected;
  final bool showMultiselect;
  final bool isDismissible;

  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    // Removed unused 'state'

    if (!userCompany.canEditEntity(entity)) {
      return child;
    }

    final localization = AppLocalization.of(context);
    final isMultiselect =
        store.state.getListState(entity.entityType).isInMultiselect();

    final widget = SelectedIndicator(
      isSelected: isDesktop(context) &&
          isSelected &&
          showMultiselect &&
          isDismissible &&
          !isMultiselect &&
          !entity.entityType!.isSetting,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: 60,
        ),
        child: child,
      ),
    );

    if (!isDismissible) {
      return widget;
    }

    return Slidable(
      key: Key('__${entity.entityKey}_${entity.entityState}__'),
      startActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          if (showMultiselect)
            SlidableAction(
              onPressed: (context) =>
                  handleEntityAction(entity, EntityAction.toggleMultiselect),
              icon: Icons.check_box,
              label: localization!.select,
              backgroundColor: AppTheme.light.success,
              foregroundColor: AppTheme.dark.text,
            ),
          SlidableAction(
            label: localization!.more,
            backgroundColor: AppTheme.dark.defaultColor,
            foregroundColor: AppTheme.dark.text,
            icon: Icons.more_vert,
            onPressed: (context) =>
                handleEntityAction(entity, EntityAction.more),
          ),
        ],
      ),
      endActionPane: entity.isDeletable
          ? ActionPane(
              motion: const DrawerMotion(),
              children: [
                if (entity.isActive)
                  SlidableAction(
                    label: EntityStateManager.getArchiveActionText(
                        entity.entityType!, entity),
                    backgroundColor: AppTheme.dark.warning,
                    foregroundColor: AppTheme.dark.text,
                    icon: Icons.archive,
                    onPressed: (context) =>
                        handleEntityAction(entity, EntityAction.archive),
                  )
                else if (entity.isRestorable)
                  SlidableAction(
                    label: EntityStateManager.getRestoreActionText(
                        entity.entityType!, entity),
                    backgroundColor: AppTheme.dark.primary,
                    foregroundColor: AppTheme.dark.text,
                    icon: Icons.restore,
                    onPressed: (context) =>
                        handleEntityAction(entity, EntityAction.restore),
                  ),
                if (!entity.isDeleted!)
                  SlidableAction(
                    label: EntityStateManager.getDeleteActionText(
                        entity.entityType!, entity),
                    backgroundColor: AppTheme.dark.danger,
                    foregroundColor: AppTheme.dark.text,
                    icon: Icons.delete,
                    onPressed: (context) =>
                        handleEntityAction(entity, EntityAction.delete),
                  ),
              ],
            )
          : null,
      child: widget,
    );
  }
}
