// Dart imports:
import 'dart:async';
import 'dart:math';

// Flutter imports:
import 'package:built_collection/built_collection.dart';
import 'package:collection/collection.dart' show IterableNullableExtension;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_boilerplate/project_config.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/data/models/static/app_theme.dart';
import 'package:flutter_boilerplate/ui/app/form_card.dart';
import 'package:flutter_boilerplate/ui/app/tables/app_paginated_data_table.dart';
import 'package:flutter_boilerplate/ui/app/tables/entity_grid_view.dart';
import 'package:overflow_view/overflow_view.dart';

// Project imports:
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
// import 'package:flutter_boilerplate/redux/ui/pref_state.dart';
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
import 'package:flutter_boilerplate/services/session_managment_service.dart';
import 'package:flutter_boilerplate/ui/app/tables/event_grid_view.dart';

class EntityList extends StatefulWidget {
  EntityList({
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
    this.onLoadMore,
  }) : super(
            key: ValueKey(
                '__${entityType}_${tableColumns}_${state.uiState.filterEntityId}_${state.getUIState(entityType)!.listUIState.tableHashCode}__'));

  final AppState state;
  final EntityType entityType;
  final ViewType? viewType;
  final List<String>? tableColumns;
  final List<String?> entityList;
  final Function(BuildContext) onRefreshed;
  final Future<void> Function(BuildContext)? onLoadMore;
  final EntityPresenter? presenter;
  final Function(String) onSortColumn;
  final Function(BuildContext, int) itemBuilder;
  final Function onClearMultiselect;

  @override
  _EntityListState createState() => _EntityListState();
}

class _EntityListState extends State<EntityList> {
  late EntityDataTableSource dataTableSource;

  int _firstRowIndex = 0;
  bool _isLoadingMore = false;

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
    final entityUIState = state.getUIState(entityType);
    final rowsPerPage = state.prefState.rowsPerPage;

    if (widget.entityList.isNotEmpty) {
      if ((entityUIState!.selectedId ?? '').isNotEmpty) {
        final selectedIndex =
            widget.entityList.indexOf(entityUIState.selectedId);

        if (selectedIndex >= 0) {
          _firstRowIndex = (selectedIndex / rowsPerPage).floor() * rowsPerPage;
        }
      } else if (state.historyList.isNotEmpty) {
        final history = state.historyList.first;
        if (history.page != null) {
          _firstRowIndex = history.page! * rowsPerPage;
        }
      }
    }

    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_isLoadingMore) return;
    
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        _scrollController.position.userScrollDirection ==
            ScrollDirection.reverse) {
      
      if (widget.entityType == EntityType.event) {
        final state = widget.state;
        if (state.eventState.lastDocument == null) {
          return; 
        }
      }
      
      _loadMoreData();
    }
  }

  void _loadMoreData() {
    if (_isLoadingMore) return;
    
    setState(() {
      _isLoadingMore = true;
    });

    final loadFunction = widget.onLoadMore ?? widget.onRefreshed;
    
    loadFunction(context).then((_) {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
        });
      }
      logError('Error loading more data: $error');
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(EntityList oldWidget) {
    super.didUpdateWidget(oldWidget);

    final state = widget.state;
    final uiState = state.getUIState(widget.entityType)!;
    dataTableSource.editingId = uiState.editingId;
    dataTableSource.entityList = widget.entityList;
    dataTableSource.entityMap = state.getEntityMap(widget.entityType)
        as BuiltMap<String?, BaseEntity?>?;

    // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
    dataTableSource.notifyListeners();
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
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > kTabletLayoutWidth
        ? 4
        : screenWidth > kMobileLayoutWidth
            ? 3
            : 2;

    if (!state.isLoaded && entityList.isEmpty && state.isLoading) {
      return LoadingIndicator();
    }

    final shouldSelectEntity = state.shouldSelectEntity(
        entityType: entityType, entityList: entityList);
    if (shouldSelectEntity == true) {
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
      if (entityList.isEmpty && ProjectConfig.defaultBackgroundImageForNoRecords(entityType)) {
        return _EmptyEntityListStateWidget(entityType: entityType);
      }
      if (entityList.isNotEmpty && ProjectConfig.listViewType(entityType) == ViewType.gridImproved) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: EventGridView(
            eventList: entityList,
            eventMap: entityMap,
            crossAxisCount: crossAxisCount,
            scrollController: _scrollController,
            onTap: (event) => selectEntity(entity: event),
          ),
        );
      }
      if (widget.viewType == ViewType.list) {
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
                        itemCount: entityList.length + 2 + (_isLoadingMore ? 1 : 0),
                        itemBuilder: (BuildContext context, index) {
                          if (index == 0 || index == entityList.length + 1) {
                            return Container(
                              color: Theme.of(context).cardColor,
                              height: 25,
                            );
                          } else if (index == entityList.length + 2 && _isLoadingMore) {
                            return Container(
                              padding: const EdgeInsets.all(16.0),
                              child: const Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    ),
                                    SizedBox(width: 16),
                                    Text('Loading more data...'),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return widget.itemBuilder(context, index - 1);
                          }
                        },
                      ),
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
                child: EntityGridView(
                  entityList: entityList,
                  entityMap: entityMap,
                  tableColumns: widget.tableColumns,
                  scrollController: _scrollController,
                  crossAxisCount: crossAxisCount,
                  entityPresenter: widget.presenter,
                  selectEntity: (entity) {
                    selectEntity(entity: entity);
                  },
                ),
              ),
            ),
          ],
        );
      } else {
        final rowsPerPage = state.prefState.rowsPerPage;

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
              child: SingleChildScrollView(
                primary: true,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: AppPaginatedDataTable(
                    onSelectAll: (value) {
                      final startIndex =
                          min(_firstRowIndex, entityList.length - 1);
                      final endIndex =
                          min(_firstRowIndex + rowsPerPage, entityList.length);
                      final entities = entityList
                          .sublist(startIndex, endIndex)
                          .map<BaseEntity>((String? entityId) =>
                              entityMap![entityId] as BaseEntity)
                          .where((invoice) =>
                              value != listUIState.isSelected(invoice.id))
                          .toList();
                      handleEntitiesActions(
                          entities, EntityAction.toggleMultiselect);
                    },
                    columns: [
                      if (!isInMultiselect) DataColumn(label: SizedBox()),
                      ...widget.tableColumns!.map((field) {
                        String? label =
                            AppLocalization.of(context)!.lookup(field);
                        if (field.startsWith('custom')) {
                          final key = field.replaceFirst(
                              'custom', entityType.snakeCase);
                          label = state.company.getCustomFieldLabel(key);
                        }
                        return DataColumn(
                            label: Container(
                              child: Text(
                                label,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            onSort: (int columnIndex, bool ascending) {
                              widget.onSortColumn(field);
                            });
                      }),
                    ],
                    source: dataTableSource,
                    sortColumnIndex: widget.tableColumns!
                            .contains(listUIState.sortField)
                        ? widget.tableColumns!.indexOf(listUIState.sortField) +
                            1
                        : 0,
                    sortAscending: listUIState.sortAscending,
                    rowsPerPage: state.prefState.rowsPerPage,
                    showFirstLastButtons: true,
                    onPageChanged: (row) {
                      _firstRowIndex = row;
                      store.dispatch(UpdateLastHistory(
                          (row / state.prefState.rowsPerPage).floor()));
                    },
                    initialFirstRowIndex: _firstRowIndex,
                    availableRowsPerPage: [
                      10,
                      25,
                      50,
                      100,
                    ],
                    onRowsPerPageChanged: (value) {
                      store.dispatch(UpdateUserPreferences(rowsPerPage: value));
                    },
                  ),
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
    final isGuest = isGuestUser(state);
    final actions = (firstEntity?.getActions(
                includeEdit: false,
                multiselect: true,
                userCompany: state.userCompany,
                isGuest: isGuest,
                isAuthor: firstEntity.createdUserId == getLoggedInUserId(store),
              ) ??
            <EntityAction>[])
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
                    if (isInMultiselect)
                      Checkbox(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onChanged: (value) {
                          final endIndex =
                              min(entityList.length, kMaxEntitiesPerBulkAction);
                          final entities = entityList
                              .sublist(0, endIndex)
                              .map<BaseEntity>((entityId) =>
                                  entityMap![entityId] as BaseEntity)
                              .toList();
                          handleEntitiesActions(
                              entities, EntityAction.toggleMultiselect);
                        },
                        activeColor: Theme.of(context).colorScheme.secondary,
                        value: entityList.length ==
                            (listUIState.selectedIds ?? <String>[]).length,
                      ),
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
                                        text: ProjectConfig.getEntityActionText(entityType, action, entity: entities.first),
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
                                            Text(ProjectConfig.getEntityActionText(entityType, action, entity: entities.first)),
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
                      if (ProjectConfig.showSaveButtonByEntityType(entityType))
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
                  listOrTable(),
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

// Move this widget to file scope
class _EmptyEntityListStateWidget extends StatelessWidget {
  final EntityType entityType;
  const _EmptyEntityListStateWidget({required this.entityType});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final store = StoreProvider.of<AppState>(context);
    final canCreate = store.state.userCompany.canCreate(entityType);
    final entityName = entityType.readableValue;
    final emptyBgColor = isDark ? AppTheme.dark.background : AppTheme.light.background;
    return Container(
      color: emptyBgColor,
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.28,
                  maxWidth: 320,
                ),
                child: Image.asset(
                  'assets/loopjam/images/defaultBackgroundImageForNoRecords.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                  ProjectConfig.defaultHelperTextForNoRecords(),
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: isDark ? Colors.white70 : Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 32),
              if (canCreate)
                SizedBox(
                  width: 220,
                  height: 48,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.cardColor,
                      foregroundColor: theme.textTheme.bodyLarge?.color,
                      elevation: 0,
                      // No border
                    ),
                    icon: Icon(Icons.add_box_rounded, color: theme.primaryColorDark),
                    label: Text(
                      'Create an $entityName',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    onPressed: () {
                      createEntityByType(context: context, entityType: entityType);
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
