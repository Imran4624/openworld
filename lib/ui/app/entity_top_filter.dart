// Flutter imports:
import 'package:collection/collection.dart' show IterableNullableExtension;
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/project_config.dart';
import 'package:flutter_boilerplate/services/session_managment_service.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'package:flutter_boilerplate/ui/event/view/event_view_vm.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/ui/app/app_border.dart';
import 'package:flutter_boilerplate/ui/app/icon_text.dart';
import 'package:flutter_boilerplate/utils/icons.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:overflow_view/overflow_view.dart';

// Project imports:
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/ui/app/presenters/entity_presenter.dart';
import 'package:flutter_boilerplate/utils/localization.dart';

class EntityTopFilter extends StatelessWidget {
  const EntityTopFilter({
    required this.show,
  });

  final bool show;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);
    final store = StoreProvider.of<AppState>(context);
    final state = store.state;
    final uiState = state.uiState;
    final prefState = state.prefState;

    final filterEntityType = uiState.filterEntityType;
    final routeEntityType = uiState.entityTypeRoute;

    final entityMap =
        filterEntityType != null ? state.getEntityMap(filterEntityType) : null;
    final filterEntity =
        entityMap != null ? entityMap[uiState.filterEntityId] : null;
    final relatedTypes = filterEntityType?.relatedTypes
            .where((element) => state.company.isModuleEnabled(element))
            .toList() ??
        [];
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return Material(
      color: backgroundColor,
      child: Column(
        children: [
          if (prefState.isViewerFullScreen(uiState.filterEntityType))
            const Expanded(
                child: EventViewScreen(
                  isTopFilter: true,
                )),
          if (ProjectConfig.showRelatedEntitiesTopbarForFullScreen())
            AnimatedContainer(
              height: show ? 46 : 0,
              duration: Duration(milliseconds: kDefaultAnimationDuration),
              curve: Curves.easeInOutCubic,
              child: AnimatedOpacity(
                opacity: show ? 1 : 0,
                duration: Duration(milliseconds: kDefaultAnimationDuration),
                curve: Curves.easeInOutCubic,
                child: filterEntity == null
                    ? Container(
                        color: backgroundColor,
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(width: 4),
                          if (!prefState
                              .isViewerFullScreen(filterEntityType)) ...[
                            IconButton(
                              icon: Icon(
                                Icons.clear,
                                color: state.headerTextColor,
                              ),
                              onPressed: () => store.dispatch(
                                FilterByEntity(entity: uiState.filterEntity),
                              ),
                            ),
                          ],
                          SizedBox(width: 4),
                          if (!prefState.isFilterVisible &&
                              !prefState.isViewerFullScreen(filterEntityType))
                            InkWell(
                              onTap: () {
                                store.dispatch(UpdateUserPreferences(
                                    isFilterVisible:
                                        !prefState.isFilterVisible));
                              },
                              onLongPress: () {
                                editEntity(entity: filterEntity);
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(width: 12),
                                  Icon(
                                    Icons.chrome_reader_mode,
                                    color: state.headerTextColor,
                                  ),
                                  SizedBox(width: 12),
                                  ConstrainedBox(
                                    constraints: BoxConstraints(maxWidth: 220),
                                    child: Text(
                                      EntityPresenter()
                                          .initialize(
                                              filterEntity as BaseEntity,
                                              context)
                                          .title()!,
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: state.headerTextColor),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                ],
                              ),
                            ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: OverflowView.flexible(
                                spacing: 4,
                                children: <Widget>[
                                  for (int i = 0; i < relatedTypes.length; i++)
                                    DecoratedBox(
                                      decoration: BoxDecoration(
                                        border: relatedTypes[i] ==
                                                routeEntityType
                                            ? Border(
                                                bottom: BorderSide(
                                                  color: Theme.of(context).primaryColor,
                                                  width: 2,
                                                ),
                                              )
                                            : null,
                                      ),
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12),
                                          minimumSize: const Size(0, 36),
                                        ),
                                        onPressed: () {
                                          printL('related types ==> $relatedTypes');
                                          viewEntitiesByType(
                                            entityType: relatedTypes[i],
                                            filterEntity:
                                                filterEntity as BaseEntity?,
                                          );
                                        },
                                        onLongPress: () {
                                          handleEntityAction(
                                              filterEntity as BaseEntity,
                                              EntityAction.newEntityType(
                                                  relatedTypes[i]));
                                        },
                                        child: Text(
                                          localization!.lookup(
                                              relatedTypes[i].plural),
                                          style: TextStyle(
                                            color: state.headerTextColor,
                                          ),
                                        ),
                                      ),
                                    )
                                ],
                                builder: (context, remaining) {
                                  return PopupMenuButton<EntityType>(
                                    initialValue: routeEntityType,
                                    onSelected: (EntityType value) {
                                      if (value == filterEntityType) {
                                        viewEntity(
                                          entity: filterEntity as BaseEntity,
                                        );
                                      } else {
                                        viewEntitiesByType(
                                          entityType: value,
                                          filterEntity:
                                              filterEntity as BaseEntity?,
                                        );
                                      }
                                    },
                                    itemBuilder: (BuildContext context) =>
                                        filterEntityType!.relatedTypes
                                            .sublist(
                                                relatedTypes.length - remaining)
                                            .where((element) => state.company
                                                .isModuleEnabled(element))
                                            .map((type) =>
                                                PopupMenuItem<EntityType>(
                                                  value: type,
                                                  child: ConstrainedBox(
                                                    constraints: const BoxConstraints(
                                                      minWidth: 75,
                                                    ),
                                                    child: Text(type ==
                                                            filterEntityType
                                                        ? localization.overview
                                                        : localization.lookup(type.plural)),
                                                  ),
                                                ))
                                            .toList(),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4),
                                      child: Row(
                                        children: [
                                          Text(
                                            localization!.more,
                                            style: TextStyle(
                                                color: state.headerTextColor),
                                          ),
                                          const SizedBox(width: 4),
                                          Icon(Icons.arrow_drop_down,
                                              color: state.headerTextColor),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          if (!prefState
                              .isViewerFullScreen(filterEntityType)) ...[
                            if (filterEntityType!.hasFullWidthViewer)
                              AppBorder(
                                isLeft: true,
                                child: InkWell(
                                  onTap: () {
                                    store.dispatch(ToggleViewerLayout(
                                        uiState.filterEntityType));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: Icon(
                                      MdiIcons.chevronDown,
                                      color: state.headerTextColor,
                                    ),
                                  ),
                                ),
                              ),
                          ]
                        ],
                      ),
              ),
            ),
        ],
      ),
    );
  }
}

class EntityTopFilterHeader extends StatelessWidget {
  const EntityTopFilterHeader();

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);
    final store = StoreProvider.of<AppState>(context);
    final state = store.state;
    final uiState = state.uiState;
    final prefState = state.prefState;

    final filterEntityType = uiState.filterEntityType;

    final entityMap =
        filterEntityType != null ? state.getEntityMap(filterEntityType) : null;
    final filterEntity =
        entityMap != null ? entityMap[uiState.filterEntityId]! : null;

    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;

    final entityActions = (filterEntity as BaseEntity)
        .getActions(
          includeEdit: true,
          userCompany: state.userCompany,
          isGuest: isGuestUser(state),
          isAuthor: filterEntity.createdUserId == getLoggedInUserId(store) || isAdmin(state),
        )
        .whereNotNull();
    final textStyle = Theme.of(context)
        .textTheme
        .bodyMedium!
        .copyWith(color: state.headerTextColor);

    return Material(
      color: backgroundColor,
      elevation: 0,
      child: SizedBox(
        height: kTopBottomBarHeight - 4,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 4,
            ),
            IconButton(
              icon: Icon(
                Icons.clear,
                color: state.headerTextColor,
              ),
              onPressed: () {
                final entityType = uiState.filterEntityType!;
                if (entityType.hasFullWidthViewer &&
                    state.prefState.isViewerFullScreen(entityType)) {
                  viewEntitiesByType(
                      entityType: entityType,
                      page: state.historyList.length >= 2
                          ? state.historyList[1].page
                          : 0);
                } else {
                  store.dispatch(
                    FilterByEntity(entity: uiState.filterEntity),
                  );
                }
              },
            ),
            SizedBox(width: 4),
            if (!prefState.isFilterVisible)
              InkWell(
                onTap: () {
                  store.dispatch(UpdateUserPreferences(
                      isFilterVisible: !prefState.isFilterVisible));
                },
                onLongPress: () {
                  editEntity(entity: filterEntity);
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: 12),
                    Icon(
                      Icons.chrome_reader_mode,
                      color: state.headerTextColor,
                    ),
                    SizedBox(width: 12),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 220),
                      child: Text(
                        EntityPresenter()
                            .initialize(filterEntity, context)
                            .title()!,
                        style: TextStyle(
                            fontSize: 17, color: state.headerTextColor),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    SizedBox(width: 12),
                  ],
                ),
              ),
            SizedBox(width: 12),
            if(isAdmin(state) || filterEntity.createdUserId == getLoggedInUserId(store))
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: OverflowView.flexible(
                    spacing: 8,
                    children: entityActions.map(
                      (action) {
                        final label = ProjectConfig.getEntityActionText(filterEntityType, action, entity: filterEntity);
                        if(action == EntityAction.edit && filterEntity.createdUserId != getLoggedInUserId(store)) {
                          return SizedBox.shrink();
                        }
                        if(action != EntityAction.edit && action != EntityAction.archive && !isAdmin(state)) {
                          return SizedBox.shrink();
                        }
                        return OutlinedButton(
                          style: action == EntityAction.edit
                              ? ButtonStyle(
                                  backgroundColor: WidgetStateProperty.all(state
                                      .prefState.colorThemeModel!.colorSuccess))
                              : null,
                          child: IconText(
                            icon: getEntityActionIcon(action),
                            text: label,
                            style: state.isSaving ? null : textStyle,
                          ),
                          onPressed: state.isSaving
                              ? null
                              : () {
                                  handleEntitiesActions([filterEntity], action);
                                },
                        );
                      },
                    ).toList(),
                    builder: (context, remaining) {
                      return PopupMenuButton<EntityAction>(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            children: [
                              Text(
                                localization!.more,
                                style: textStyle,
                              ),
                              SizedBox(width: 4),
                              Icon(Icons.arrow_drop_down,
                                  color: state.headerTextColor),
                            ],
                          ),
                        ),
                        onSelected: (EntityAction action) {
                          handleEntitiesActions([filterEntity], action);
                        },
                        itemBuilder: (BuildContext context) {
                          return entityActions
                              .toList()
                              .sublist(entityActions.length - remaining)
                              .map((action) {
                            return PopupMenuItem<EntityAction>(
                              value: action,
                              child: Row(
                                children: <Widget>[
                                  Icon(getEntityActionIcon(action),
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                                  SizedBox(width: 16.0),
                                  Text(AppLocalization.of(context)!
                                      .lookup(action.toString())),
                                ],
                              ),
                            );
                          }).toList();
                        },
                      );
                    }),
              ),
            ),
            AppBorder(
              isLeft: true,
              child: InkWell(
                onTap: () {
                  store.dispatch(ToggleViewerLayout(uiState.filterEntityType));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Icon(
                    MdiIcons.chevronUp,
                    color: state.headerTextColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
