// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/data/models/event_model.dart';
import 'package:flutter_boilerplate/project_config.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';

// Project imports:
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/data/models/entities.dart';
import 'package:flutter_boilerplate/data/models/static/app_theme.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/utils/icons.dart';
import 'package:flutter_boilerplate/utils/localization.dart';

class ListFilterMessage extends StatelessWidget {
  const ListFilterMessage({
    required this.filterEntityId,
    required this.filterEntityType,
    required this.onPressed,
    required this.onClearPressed,
    this.isSettings = false,
  });

  final String? filterEntityId;
  final EntityType? filterEntityType;
  final Function(BuildContext) onPressed;
  final Function() onClearPressed;
  final bool isSettings;

  @override
  Widget build(BuildContext context) {
    final state = StoreProvider.of<AppState>(context).state;
    final filteredEntity =
        state.getEntityMap(filterEntityType)![filterEntityId];

    return Material(
      color: AppTheme.light.warning,
      elevation: 0,
      child: FilterListTile(
        entityType: filterEntityType,
        entity: filteredEntity as BaseEntity?,
        onPressed: onPressed,
        onClearPressed: onClearPressed,
        isSettings: isSettings,
      ),
    );
  }
}

class FilterListTile extends StatelessWidget {
  const FilterListTile({
    required this.entityType,
    required this.entity,
    required this.onPressed,
    required this.onClearPressed,
    this.isSettings = false,
  });

  final EntityType? entityType;
  final BaseEntity? entity;
  final Function(BuildContext) onPressed;
  final Function() onClearPressed;
  final bool isSettings;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);

    late String title;
    String? subtitle;

    if (isSettings) {
      subtitle = entity?.listDisplayName ?? '';
      // if (entityType == EntityType.client) {
      //   title = localization!.clientSettings;
      // }
    } else {
      if (entityType == EntityType.event) {
        final event = entity as EventEntity;
        title = event.name;
        subtitle = '';
      } else {
        title = localization!.filteredBy
            .replaceFirst(':value', entity!.listDisplayName);
        subtitle = localization.lookup(entityType.toString());
      }
    }

    return ClipRect(
      child: Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: AppTheme.dark.defaultColor,
              width: .5,
            ),
            borderRadius: BorderRadius.all(Radius.circular(kBorderRadius)),
          ),
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return ListTile(
              leading: constraints.maxWidth > 250
                  ? Icon(getEntityIcon(entityType))
                  : null,
              title: Text(title),
              subtitle: Text(subtitle!),
              onTap: () => onPressed(context),
              trailing: ProjectConfig.showClearFilterCrossButton()
                  ? IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: onClearPressed,
                    )
                  : null,
            );
          }),
        ),
      ),
    );
  }
}
