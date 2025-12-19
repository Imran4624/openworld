// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/config/entity_state_config.dart';
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/data/models/dynamic_fields/dynamic_fields_modal.dart';
import 'package:flutter_boilerplate/project_config.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/redux/profile/profile_actions.dart';
import 'package:flutter_boilerplate/services/session_managment_service.dart';
import 'package:flutter_boilerplate/ui/dynamic_fields/dynamic_fields_presenter.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/data/models/static/app_theme.dart';
import 'package:flutter_boilerplate/redux/settings/settings_actions.dart';
import 'package:flutter_boilerplate/ui/app/multiselect.dart';
import 'package:flutter_boilerplate/ui/app/search_text.dart';
import 'package:flutter_boilerplate/utils/platforms.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:flutter_boilerplate/data/models/entities.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/utils/completers.dart';
import 'package:flutter_boilerplate/utils/formatting.dart';
import 'package:flutter_boilerplate/utils/localization.dart';
import 'package:flutter_boilerplate/utils/strings.dart';

class ListFilter extends StatefulWidget {
  const ListFilter({
    Key? key,
    required this.entityType,
    required this.filter,
    required this.onFilterChanged,
    required this.entityIds,
    this.statuses,
    this.onSelectedStatus,
    this.onSelectedState,
    this.selectedStateFilter,
    this.onEventsFilterChanged,
    this.showMyEventsOnly = false,
    this.isAuthor = false,
  }) : super(key: key);

  final EntityType entityType;
  final String? filter;
  final Function(String?) onFilterChanged;
  final List<String?> entityIds;
  final List<EntityStatus>? statuses;
  final Function(EntityStatus, bool)? onSelectedStatus;
  final Function(EntityState, bool)? onSelectedState;
  final EntityState? selectedStateFilter;
  final Function(bool)? onEventsFilterChanged;
  final bool showMyEventsOnly;
  final bool isAuthor;

  @override
  _ListFilterState createState() => new _ListFilterState();
}

class _ListFilterState extends State<ListFilter> {
  TextEditingController? _filterController;
  FocusNode? _focusNode;
  final _debouncer = Debouncer();

  @override
  void initState() {
    super.initState();
    _filterController = TextEditingController();
    _focusNode = FocusNode()..addListener(onFocusChanged);
  }

  void onFocusChanged() {
    // Check is needed to prevent the TextField from
    // refocusing when the users tries to tab out
    if (_focusNode!.hasFocus) {
      setState(() {});
    }
  }

  String? get _getPlaceholder {
    final localization = AppLocalization.of(context)!;
    final count = widget.entityIds.length;

    final isDashboardOrSettings =
        [EntityType.dashboard, EntityType.settings].contains(widget.entityType);
    final isSingle = count == 1 || isDashboardOrSettings;

    final key = toSnakeCase(
        isSingle ? widget.entityType.readableValue : widget.entityType.plural);
    final placeholder = localization.lookup(
        widget.entityType == EntityType.dashboard
            ? 'search_company'
            : 'search_$key');

    return isSingle
        ? placeholder
        : placeholder.replaceFirst(
            ':count',
            formatNumber(count.toDouble(), context,
                formatNumberType: FormatNumberType.int)!);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _filterController!.text = widget.filter ?? '';

    // if (widget.filter != null) {
    //   _focusNode!.requestFocus();
    // }
  }

  @override
  void dispose() {
    _filterController!.dispose();
    _focusNode!.removeListener(onFocusChanged);
    _focusNode!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);
    final Store<AppState> store = StoreProvider.of<AppState>(context);
    final state = store.state;

    final isDashboardOrSettings =
        [EntityType.dashboard, EntityType.settings].contains(widget.entityType);
    return Row(
      children: [
        if (ProjectConfig.showTitleByEntityType(widget.entityType) &&
            isMobile(context) &&
            !ProjectConfig.showSearchInputFieldByEntityType(widget.entityType))
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
                '${ProjectConfig.getTitleByEntityType(localization, widget.entityType)}'),
          ),
        if (widget.entityType == EntityType.settings)
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
                padding: const EdgeInsets.only(right: 8),
                onPressed: () {
                  //widget.onFilterChanged(null);
                  store.dispatch(ToggleShowNewSettings());
                },
                icon: Icon(MdiIcons.newBox)),
          ),
        if (ProjectConfig.showSearchInputFieldByEntityType(
            widget.entityType)) ...[
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.only(top: 2, left: 5),
              child: SearchText(
                filterController: _filterController,
                focusNode: _focusNode,
                onCleared: () => widget.onFilterChanged(''),
                onChanged: (value) {
                  _debouncer.run(() {
                    widget.onFilterChanged(value);
                  });
                },
                placeholder: _getPlaceholder,
              ),
            ),
          ),
        ],
        if (isDesktop(context) &&
            widget.entityType == EntityType.event &&
            ProjectConfig.showBottomCheckBoxAndFiltersByEntityType(
                EntityType.event, isAdmin(state)) &&
            isAuthenticated(state) &&
            ProjectConfig.showMyEventsAndAllEventsDropdown(
                widget.entityType)) ...[
          SizedBox(width: 8),
          Flexible(
            child: Container(
              height: 42,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).dividerColor,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: DropdownButtonHideUnderline(
                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButton<bool>(
                    isExpanded: true,
                    value: widget.showMyEventsOnly,
                    items: [
                      DropdownMenuItem(
                        value: false,
                        child: Text('All Events'),
                      ),
                      DropdownMenuItem(
                        value: true,
                        child: Text('My Events'),
                      ),
                    ],
                    onChanged: (value) {
                      widget.onEventsFilterChanged?.call(value ?? false);
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
        if (ProjectConfig.showTopbarForPhotos(context,
                state.authState.originator == OriginatorType.guest.value,
                isEventAuthor: widget.isAuthor) &&
            !isDashboardOrSettings &&
            isAuthenticated(state)) ...[
          if (widget.onSelectedState != null &&
              (ProjectConfig.showActionFiltersAndCheckBox(widget.entityType) ||
                  isAdmin(state) ||
                  (ProjectConfig.appType == AppType.loopjam &&
                      widget.isAuthor))) ...[
            SizedBox(width: 8),
            Container(
              constraints: BoxConstraints(maxWidth: 200),
              child: DropDownMultiSelect(
                onChanged: (List<dynamic> selected) {
                  final stateFilters = state
                      .getListState(widget.entityType)
                      .stateFilters
                      .toList();

                  final added =
                      selected.where((dynamic e) => !stateFilters.contains(e));
                  final removed =
                      stateFilters.where((dynamic e) => !selected.contains(e));

                  for (var state in added) {
                    widget.onSelectedState!(state, true);
                  }
                  for (var state in removed) {
                    widget.onSelectedState!(state, false);
                  }
                },
                options: ProjectConfig.allowedEntityStateActions(
                        state.authState.isAdmin, widget.entityType)
                    .toList(),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(borderSide: BorderSide()),
                  enabledBorder: state.prefState.enableDarkMode
                      ? null
                      : OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppTheme.dark.defaultColor)),
                  isDense: true,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 13, horizontal: 10),
                ),
                selectedValues: state
                    .getListState(widget.entityType)
                    .stateFilters
                    .where((entityState) =>
                        ProjectConfig.allowedEntityStateActions(
                                state.authState.isAdmin, widget.entityType)
                            .contains(entityState))
                    .toList(),
                whenEmpty: localization!.all,
                menuItembuilder: (dynamic value) {
                  final state = value as EntityState;
                  return Text(
                    EntityStateManager.getStateLabel(widget.entityType, state),
                    overflow: TextOverflow.clip,
                    maxLines: 1,
                  );
                },
                childBuilder: (selected) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        selected.isNotEmpty
                            ? selected
                                .map<String?>((dynamic value) =>
                                    EntityStateManager.getStateLabel(
                                        widget.entityType, value))
                                .join(', ')
                            : localization.all,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
          if (widget.statuses != null) ...[
            SizedBox(width: 8),
            Container(
              constraints: BoxConstraints(maxWidth: 200),
              child: DropDownMultiSelect(
                  onChanged: (List<dynamic> selected) {
                    final statusFilters = state
                        .getListState(widget.entityType)
                        .statusFilters
                        .toList();

                    final added = selected.where((dynamic e) => !statusFilters
                        .map((e) => e.id)
                        .toList()
                        .contains((e as EntityStatus).id));

                    final removed = statusFilters.where((dynamic e) => !selected
                        .map<String?>((dynamic e) => e.id)
                        .toList()
                        .contains((e as EntityStatus).id));

                    for (var status in added) {
                      widget.onSelectedStatus!(status, true);
                    }

                    for (var status in removed) {
                      widget.onSelectedStatus!(status, false);
                    }
                  },
                  options: widget.statuses,
                  selectedValues: state
                      .getListState(widget.entityType)
                      .statusFilters
                      .toList(),
                  whenEmpty: localization!.all,
                  menuItembuilder: (dynamic value) {
                    final state = value as EntityStatus;
                    return Text(localization.lookup(state.name));
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    enabledBorder: state.prefState.enableDarkMode
                        ? null
                        : OutlineInputBorder(
                            borderSide:
                                BorderSide(color: AppTheme.dark.defaultColor)),
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 13, horizontal: 10),
                  ),
                  childBuilder: (selected) {
                    return Align(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            selected.isNotEmpty
                                ? selected
                                    .map((dynamic value) =>
                                        (value as EntityStatus).name)
                                    .join(', ')
                                : localization.all,
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        alignment: Alignment.centerLeft);
                  }),
            ),
          ],
        ],

        // Add a spacer to push the advanced filter to the right

        // Show advanced filter dropdown for profiles regardless of desktop/mobile
        if (widget.entityType == EntityType.profile &&
            ProjectConfig.showProfileFilters()) ...[
          const Spacer(),
          buildAdvancedFilterDropdown(context, state)
        ]
      ],
    );
  }
}

Widget buildAdvancedFilterDropdown(BuildContext context, AppState state) {
  final localization = AppLocalization.of(context);
  final themeColors =
      state.prefState.enableDarkMode ? AppTheme.dark : AppTheme.light;
  final appliedFilters = state.profileState.filter.dynamicFieldsFilters;
  final questionGroups = state.dynamicFieldState.questionGroups;

  final Map<String, QuestionModel> questionMap = {};
  for (var group in questionGroups) {
    for (var question in group.questions) {
      questionMap[question.id] = question;
    }
  }

  final isMobileView = isMobile(context);
  final activeFilterCount =
      appliedFilters.isNotEmpty ? appliedFilters.length : 0;

  if (isMobileView) {
    return InkWell(
      onTap: () {
        viewSpecialEntity(
            entityType: EntityType.profile,
            entityViewType: EntityViewType.profileFilters);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: activeFilterCount > 0
              ? themeColors.primary.withOpacity(0.1)
              : themeColors.secondary.withOpacity(0.1),
          border: Border.all(
            color: activeFilterCount > 0
                ? themeColors.primary
                : themeColors.defaultColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.filter_list,
              size: 18,
              color: activeFilterCount > 0
                  ? themeColors.primary
                  : themeColors.text,
            ),
            const SizedBox(width: 8),
            Text(
              activeFilterCount > 0
                  ? '${localization?.filter ?? 'Filters'} ($activeFilterCount)'
                  : localization?.filter ?? 'Advanced Filters',
              style: TextStyle(
                fontSize: 14,
                fontWeight:
                    activeFilterCount > 0 ? FontWeight.w600 : FontWeight.w500,
                color: activeFilterCount > 0
                    ? themeColors.primary
                    : themeColors.text,
              ),
            ),
          ],
        ),
      ),
    );
  }

  final List<Widget> filterChips = [];
  for (final appliedFilter in appliedFilters.entries) {
    final key = appliedFilter.key;
    final value = appliedFilter.value;
    final displayName = questionMap.getDisplayName(key);
    final displayValue = questionMap.getDisplayValueForField(key, value);

    if (displayValue.isEmpty) continue;

    filterChips.add(InkWell(
      onTap: () {
        viewSpecialEntity(
          entityType: EntityType.profile,
          entityViewType: EntityViewType.profileFilters,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        margin: const EdgeInsets.only(left: 8),
        decoration: BoxDecoration(
          color: themeColors.background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: themeColors.primary.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                '$displayName: $displayValue',
                style: TextStyle(
                  fontSize: 12,
                  color: themeColors.text,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 4),
            InkWell(
              onTap: () {
                final updatedFilter = state.profileState.filter.rebuild((b) {
                  final updatedFilters = Map<String, dynamic>.from(
                      state.profileState.filter.dynamicFieldsFilters.toMap());
                  updatedFilters.remove(key);
                  b.dynamicFieldsFilters.replace(updatedFilters);
                });

                StoreProvider.of<AppState>(context)
                    .dispatch(UpdateProfileFilter(updatedFilter));
              },
              child: Icon(
                Icons.close,
                size: 14,
                color: themeColors.defaultColor,
              ),
            ),
          ],
        ),
      ),
    ));
  }

  return Container(
    constraints: const BoxConstraints(maxWidth: 600),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () {
            viewSpecialEntity(
                entityType: EntityType.profile,
                entityViewType: EntityViewType.profileFilters);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: activeFilterCount > 0
                  ? themeColors.primary.withOpacity(0.1)
                  : themeColors.secondary.withOpacity(0.1),
              border: Border.all(
                color: activeFilterCount > 0
                    ? themeColors.primary
                    : themeColors.defaultColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.filter_list,
                  size: 18,
                  color: activeFilterCount > 0
                      ? themeColors.primary
                      : themeColors.text,
                ),
                const SizedBox(width: 8),
                Text(
                  activeFilterCount > 0
                      ? '${localization?.filter ?? 'Filters'} ($activeFilterCount)'
                      : localization?.filter ?? 'Advanced Filters',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: activeFilterCount > 0
                        ? FontWeight.w600
                        : FontWeight.w500,
                    color: activeFilterCount > 0
                        ? themeColors.primary
                        : themeColors.text,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (filterChips.isNotEmpty)
          Flexible(
            child: Container(
              height: 36,
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.5,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: filterChips,
                ),
              ),
            ),
          ),
        if (filterChips.isNotEmpty && activeFilterCount > 0)
          InkWell(
            onTap: () {
              final updatedFilter = state.profileState.filter.rebuild((b) {
                b.dynamicFieldsFilters.clear();
              });

              StoreProvider.of<AppState>(context)
                  .dispatch(UpdateProfileFilter(updatedFilter));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                localization?.clearAll ?? 'Clear All',
                style: TextStyle(
                  fontSize: 12,
                  color: themeColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
      ],
    ),
  );
}
