// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:built_collection/built_collection.dart';
import 'package:collection/collection.dart' show IterableNullableExtension;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_boilerplate/project_config.dart';
import 'package:flutter_boilerplate/services/session_managment_service.dart';
import 'package:flutter_boilerplate/ui/app/tables/profile_grid_view.dart';
import 'package:flutter_boilerplate/ui/profile/swipe/swipe_profile_view.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/data/models/static/app_theme.dart';
import 'package:flutter_boilerplate/ui/app/form_card.dart';
import 'package:overflow_view/overflow_view.dart';

// Project imports:
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/ui/app/entities/entity_actions_dialog.dart';
import 'package:flutter_boilerplate/ui/app/forms/save_cancel_buttons.dart';
import 'package:flutter_boilerplate/ui/app/help_text.dart';
import 'package:flutter_boilerplate/ui/app/icon_text.dart';
import 'package:flutter_boilerplate/ui/app/lists/list_divider.dart';
import 'package:flutter_boilerplate/ui/app/lists/list_filter.dart';
import 'package:flutter_boilerplate/ui/app/loading_indicator.dart';
import 'package:flutter_boilerplate/ui/app/presenters/entity_presenter.dart';
import 'package:flutter_boilerplate/ui/app/scrollable_listview.dart';
import 'package:flutter_boilerplate/ui/app/tables/entity_datatable.dart';
import 'package:flutter_boilerplate/utils/icons.dart';
import 'package:flutter_boilerplate/utils/localization.dart';
import 'package:flutter_boilerplate/utils/platforms.dart';

class ProfileList extends StatefulWidget {
  ProfileList({
    required this.state,
    required this.entityType,
    required this.entityList,
    required this.onRefreshed,
    required this.onSortColumn,
    required this.itemBuilder,
    required this.onClearMultiselect,
    this.presenter,
    this.tableColumns,
    this.viewType,
    this.isProfileOperation = false,
  }) : super(
            key: ValueKey(
                '__${entityType}_${tableColumns}_${state.uiState.filterEntityId}_${state.getUIState(entityType)!.listUIState.tableHashCode}__'));

  final AppState state;
  final EntityType entityType;
  final ViewType? viewType;
  final List<String>? tableColumns;
  final List<String?> entityList;
  final Function(BuildContext) onRefreshed;
  final EntityPresenter? presenter;
  final Function(String) onSortColumn;
  final Function(BuildContext, int) itemBuilder;
  final Function onClearMultiselect;
  final bool isProfileOperation;

  @override
  _ProfileListState createState() => _ProfileListState();
}

class _ProfileListState extends State<ProfileList> {
  late EntityDataTableSource dataTableSource;


  late ScrollController _scrollController;
  @override
  void initState() {
    super.initState();

    final entityType = widget.entityType;
    final state = widget.state;
    final entityList = widget.entityList;
    final entityMap = state.getEntityMap(entityType);
    final entityState = state.getUIState(entityType)!;
    dataTableSource = EntityDataTableSource(
      context: context,
      entityType: entityType,
      editingId: entityState.editingId,
      tableColumns: widget.tableColumns,
      entityList: entityList.toList(),
      entityMap: entityMap as BuiltMap<String?, BaseEntity?>?,
      entityPresenter: widget.presenter,
      onTap: (BaseEntity entity) => selectEntity(entity: entity),
    );

    // make sure the initial page shows the selected record


    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100 &&
        _scrollController.position.userScrollDirection ==
            ScrollDirection.reverse) {
      widget.onRefreshed(context);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(ProfileList oldWidget) {
    super.didUpdateWidget(oldWidget);

    final state = widget.state;
    final uiState = state.getUIState(widget.entityType)!;
    dataTableSource.editingId = uiState.editingId;
    dataTableSource.entityList = widget.entityList;
    dataTableSource.entityMap = state.getEntityMap(widget.entityType)
        as BuiltMap<String?, BaseEntity?>?;

  }

  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    final localization = AppLocalization.of(context);
    final state = widget.state;
    final uiState = state.uiState;
    final entityType = widget.entityType;
    final listUIState = state.getUIState(entityType)!.listUIState;
    final isInMultiselect = listUIState.isInMultiselect();
    final entityList = widget.entityList;
    final entityMap = state.getEntityMap(entityType);
    final countSelected = (listUIState.selectedIds ?? <String>[]).length;
    final isList = entityType.isSetting || state.prefState.isModuleList;

    if (!state.isLoaded && entityList.isEmpty && state.isLoading) {
      return const LoadingIndicator();
    }

    final shouldSelectEntity = state.shouldSelectEntity(
        entityType: entityType, entityList: entityList);
    if (shouldSelectEntity != false && state.getUIState(entityType)!.selectedId != getLoggedInUserId(store)) {
      // null is a special case which means we need to reselect
      // the current selection to add it to the history
      final entityId = shouldSelectEntity == null 
          ? state.getUIState(entityType)!.selectedId
          : (entityList.isEmpty ? null : entityList.first);

      WidgetsBinding.instance.addPostFrameCallback((duration) {
        viewEntityById(
          entityType: entityType,
          entityId: entityId,
        );
      });
    }

    listOrTable() {
      if (ProjectConfig.swipingProfilesEnabled(isAdmin(state)) && 
          entityType == EntityType.profile && 
          !isInMultiselect) {
        return SwipeProfileView(
          profileList: entityList.whereType<String>().toList(),
          profileMap: entityMap != null
              ? Map<String, ProfileEntity>.fromIterable(
                  entityList.whereType<String>(),
                  key: (id) => id,
                  value: (id) => entityMap[id] as ProfileEntity,
                )
              : {},
          onRefresh: () => widget.onRefreshed(context),
          state: state,
        );
      } else if (widget.viewType == ViewType.list) {
        return FormCard(
          padding: ProjectConfig.removePadding(entityType)
              ? EdgeInsets.all(0.0)
              : null,
          internalPadding: ProjectConfig.removePadding(entityType)
              ? EdgeInsets.all(0.0)
              : null,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (uiState.filterEntityId != null && isMobile(context))
                ListFilterMessage(
                  filterEntityId: uiState.filterEntityId,
                  filterEntityType: uiState.filterEntityType,
                  onPressed: (_) => viewEntityById(
                      entityId: state.uiState.filterEntityId,
                      entityType: state.uiState.filterEntityType),
                  onClearPressed: () => store.dispatch(ClearEntityFilter()),
                ),
              Expanded(
                child: entityList.isEmpty
                    ? HelpText(store.state.userCompany.canCreate(entityType)
                        ? AppLocalization.of(context)!.clickPlusToCreateRecord
                        : AppLocalization.of(context)!.noRecordsFound)
                    : ScrollableListViewBuilder(
                        scrollController: _scrollController,
                        primary: false,
                        padding: const EdgeInsets.symmetric(vertical: 0),
                        separatorBuilder: (context, index) =>
                            (index == 0 || index == entityList.length)
                                ? SizedBox()
                                : ListDivider(),
                        itemCount: entityList.length + 2,
                        itemBuilder: (BuildContext context, index) {
                          if (index == 0 || index == entityList.length + 1) {
                            return Container(
                              color: Theme.of(context).cardColor,
                              height: 25,
                            );
                          } else {
                            return widget.itemBuilder(context, index - 1);
                          }
                        },
                      ) /*DraggableScrollbar.semicircle(
                        backgroundColor: Theme.of(context).backgroundColor,
                        scrollbarTimeToFade: Duration(seconds: 1),
                        controller: _scrollController,
                        child: ScrollableListViewBuilder(
                          padding: const EdgeInsets.symmetric(vertical: 25),
                          controller: _scrollController,
                          separatorBuilder: (context, index) =>
                              (index == 0 || index == entityList.length)
                                  ? SizedBox()
                                  : ListDivider(),
                          itemCount: entityList.length + 2,
                          itemBuilder: (BuildContext context, index) {
                            if (index == 0 || index == entityList.length + 1) {
                              return Container(
                                color: Theme.of(context).cardColor,
                                height: 25,
                              );
                            } else {
                              return widget.itemBuilder(context, index - 1);
                            }
                          },
                        ),
                      )*/
                ,
              ),
            ],
          ),
        );
      } else if (widget.viewType == ViewType.grid) {
        return Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            if (uiState.filterEntityId != null && isMobile(context))
              ListFilterMessage(
                filterEntityId: uiState.filterEntityId,
                filterEntityType: uiState.filterEntityType,
                onPressed: (_) {
                  viewEntityById(
                      entityId: state.uiState.filterEntityId,
                      entityType: state.uiState.filterEntityType);
                },
                onClearPressed: () {
                  store.dispatch(ClearEntityFilter());
                },
              ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: ProfileGridView(
                  entityList: entityList,
                  entityMap: entityMap,
                  scrollController: _scrollController,
                  onSelectEntity: (profile) => selectEntity(entity: profile),
                  isProfileOperation: widget.isProfileOperation,
                ),
              ),
            ),
          ],
        );
      }
    }

    final entities = listUIState.selectedIds == null
        ? <BaseEntity>[]
        : listUIState.selectedIds!
            .map<BaseEntity>((entityId) => entityMap![entityId] as BaseEntity)
            .toList();
    final firstEntity = entities.isEmpty ? null : entities.first;
    final actions = (firstEntity?.getActions(
                includeEdit: false,
                multiselect: true,
                userCompany: state.userCompany) ??
            [])
        .whereNotNull();

    return RefreshIndicator(
        onRefresh: () => widget.onRefreshed(context),
        child: Column(
          children: [
            AnimatedContainer(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              color: Theme.of(context).cardColor,
              height: isInMultiselect ? kTopBottomBarHeight : 0,
              duration: Duration(milliseconds: kDefaultAnimationDuration),
              curve: Curves.easeInOutCubic,
              child: AnimatedOpacity(
                opacity: isInMultiselect ? 1 : 0,
                duration: Duration(milliseconds: kDefaultAnimationDuration),
                curve: Curves.easeInOutCubic,
                child: Row(
                  children: [
                    if (isDesktop(context)) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(isList
                            ? '($countSelected)'
                            : localization!.countSelected
                                .replaceFirst(':count', '$countSelected')),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: OverflowView.flexible(
                              spacing: 8,
                              children: actions
                                  .map(
                                    (action) => OutlinedButton(
                                      child: IconText(
                                        icon: getEntityActionIcon(action),
                                        text: ProjectConfig.getEntityActionText(
                                            entityType, action, entity: entities.first),
                                      ),
                                      onPressed: () {
                                        handleEntitiesActions(entities, action);
                                        widget.onClearMultiselect();
                                      },
                                    ),
                                  )
                                  .toList(),
                              builder: (context, remaining) {
                                return PopupMenuButton<EntityAction>(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Row(
                                      children: [
                                        Text(
                                          localization!.more,
                                          style: TextStyle(
                                              color:
                                                  state.prefState.enableDarkMode
                                                      ? AppTheme.dark.text
                                                      : AppTheme.light.text),
                                        ),
                                        SizedBox(width: 4),
                                        Icon(Icons.arrow_drop_down,
                                            color:
                                                state.prefState.enableDarkMode
                                                    ? AppTheme.dark.text
                                                    : AppTheme.light.text),
                                      ],
                                    ),
                                  ),
                                  onSelected: (EntityAction action) {
                                    handleEntitiesActions(entities, action);
                                    widget.onClearMultiselect();
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return actions
                                        .toList()
                                        .sublist(actions.length - remaining)
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
                      )
                    ] else ...[
                      SizedBox(width: 16),
                      Expanded(
                        child: Text(localization!.countSelected
                            .replaceFirst(':count', '$countSelected')),
                      ),
                      SaveCancelButtons(
                        isHeader: false,
                        saveLabel: localization.actions,
                        isEnabled: entities.isNotEmpty,
                        isCancelEnabled: true,
                        onSavePressed: (context) async {
                          await showEntityActionsDialog(
                            entities: entities,
                            multiselect: true,
                            completer: Completer<Null>()
                              ..future.then<Null>(
                                  (_) => widget.onClearMultiselect()),
                          );
                        },
                        onCancelPressed: (_) => widget.onClearMultiselect(),
                      ),
                    ]
                  ],
                ),
              ),
            ),
            Expanded(
              child: Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  listOrTable()!,
                  if ((state.isLoading &&
                          (isMobile(context) || !entityType.isSetting)) ||
                      (state.isSaving &&
                          (entityType.isSetting ||
                              (!state.prefState.isPreviewVisible &&
                                  !state.uiState.isEditing))))
                    LinearProgressIndicator(),
                ],
              ),
            ),
          ],
        ));
  }
}
