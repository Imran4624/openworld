// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:built_collection/built_collection.dart';
import 'package:flutter_boilerplate/config/entity_state_config.dart';
import 'package:flutter_boilerplate/project_config.dart';
import 'package:flutter_boilerplate/services/session_managment_service.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/ui/list_ui_state.dart';
import 'package:flutter_boilerplate/ui/app/app_border.dart';
import 'package:flutter_boilerplate/utils/localization.dart';
import 'package:flutter_boilerplate/utils/platforms.dart';

class AppBottomBar extends StatefulWidget {
  const AppBottomBar({
    required this.entityType,
    required this.sortFields,
    required this.onSelectedSortField,
    required this.onCheckboxPressed,
    this.onSelectedState,
    this.defaultTableColumns,
    this.tableColumns,
    this.onEventsFilterChanged,
    this.showMyEventsOnly = false,
    this.onSelectedStatus,
    this.onSelectedCustom1,
    this.onSelectedCustom2,
    this.onSelectedCustom3,
    this.onSelectedCustom4,
    this.statuses = const [],
    this.customValues1 = const [],
    this.customValues2 = const [],
    this.customValues3 = const [],
    this.customValues4 = const [],
    this.hideListOptions = false,
    this.iconButtons = const [],
  });

  final EntityType entityType;
  final List<String> sortFields;
  final List<EntityStatus> statuses;
  final Function onCheckboxPressed;
  final Function(String)? onSelectedSortField;
  final Function(EntityState, bool?)? onSelectedState;
  final Function(EntityStatus, bool?)? onSelectedStatus;
  final Function(String)? onSelectedCustom1;
  final Function(String)? onSelectedCustom2;
  final Function(String)? onSelectedCustom3;
  final Function(String)? onSelectedCustom4;
  final List<String> customValues1;
  final List<String> customValues2;
  final List<String> customValues3;
  final List<String> customValues4;
  final List<String>? tableColumns;
  final List<String>? defaultTableColumns;
  final Function(bool)? onEventsFilterChanged;
  final bool showMyEventsOnly;
  final bool hideListOptions;
  final List<IconButton> iconButtons;

  @override
  _AppBottomBarState createState() => _AppBottomBarState();
}

class _AppBottomBarState extends State<AppBottomBar> {
  PersistentBottomSheetController? _sortController;
  PersistentBottomSheetController? _filterStateController;
  PersistentBottomSheetController? _filterStatusController;
  PersistentBottomSheetController? _filterCustom1Controller;
  PersistentBottomSheetController? _filterCustom2Controller;
  PersistentBottomSheetController? _filterCustom3Controller;
  PersistentBottomSheetController? _filterCustom4Controller;
  PersistentBottomSheetController? _eventsFilterController;

  int kSortPanel = 0;
  int kFilterStatePanel = 1;
  int kFilterStatusPanel = 2;
  int kCustom1Panel = 3;
  int kCustom2Panel = 4;
  int kCustom3Panel = 5;
  int kCustom4Panel = 6;

  int? closeBottomSheet() {
    if (_filterStateController != null) {
      _filterStateController!.close();
      return kFilterStatePanel;
    }

    if (_filterStatusController != null) {
      _filterStatusController!.close();
      return kFilterStatusPanel;
    }

    if (_sortController != null) {
      _sortController!.close();
      return kSortPanel;
    }

    if (_filterCustom1Controller != null) {
      _filterCustom1Controller!.close();
      return kCustom1Panel;
    }

    if (_filterCustom2Controller != null) {
      _filterCustom2Controller!.close();
      return kCustom2Panel;
    }

    if (_filterCustom3Controller != null) {
      _filterCustom3Controller!.close();
      return kCustom3Panel;
    }

    if (_filterCustom4Controller != null) {
      _filterCustom4Controller!.close();
      return kCustom4Panel;
    }

    return null;
  }

  void _showEventsFilterSheet() {
    if (_eventsFilterController != null) {
      _eventsFilterController!.close();
      return;
    }

    _eventsFilterController = Scaffold.of(context).showBottomSheet((context) {
      return Container(
        color: Theme.of(context).colorScheme.surface,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('All Events'),
              leading: Radio<bool>(
                value: false,
                groupValue: widget.showMyEventsOnly,
                onChanged: (value) {
                  widget.onEventsFilterChanged?.call(false);
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: Text('My Events'),
              leading: Radio<bool>(
                value: true,
                groupValue: widget.showMyEventsOnly,
                onChanged: (value) {
                  widget.onEventsFilterChanged?.call(true);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      );
    });

    _eventsFilterController!.closed.whenComplete(() {
      _eventsFilterController = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = StoreProvider.of<AppState>(context).state;
    final prefState = state.prefState;

    showFilterStateSheet() {
      if (closeBottomSheet() == kFilterStatePanel) {
        return;
      }
      _filterStateController = Scaffold.of(context).showBottomSheet((context) {
        return StoreConnector<AppState, BuiltList<EntityState>>(
          converter: (Store<AppState> store) =>
              store.state.getListState(widget.entityType).stateFilters,
          builder: (BuildContext context, stateFilters) {
            return Container(
              color: Theme.of(context).colorScheme.surface,
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Column(
                  children: ProjectConfig.allowedEntityStateActions(isAdmin(state), widget.entityType)
                  .map((entityState) => CheckboxListTile(
                    key: ValueKey('state_${AppLocalization.of(context)!.lookup('$entityState')}'),
                    title: Text(EntityStateManager.getStateLabel(widget.entityType, entityState)),
                    controlAffinity: ListTileControlAffinity.leading,
                    value: stateFilters.contains(entityState),
                    activeColor: Theme.of(context).colorScheme.secondary,
                    dense: true,
                    onChanged: (value) => widget.onSelectedState!(entityState, value),
                  ))
                  .toList(),
                ),
              ]),
            );
          },
        );
      });

      _filterStateController!.closed.whenComplete(() {
        _filterStateController = null;
      });
    }

    showFilterStatusSheet() {
      if (closeBottomSheet() == kFilterStatusPanel) {
        return;
      }

      _filterStatusController = Scaffold.of(context).showBottomSheet((context) {
        return StoreConnector<AppState, BuiltList<EntityStatus>>(
          converter: (Store<AppState> store) =>
              store.state.getListState(widget.entityType).statusFilters,
          builder: (BuildContext context, statusFilters) {
            return Container(
              color: Theme.of(context).colorScheme.surface,
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Column(
                  children: widget.statuses.map((status) {
                    return CheckboxListTile(
                      key: Key(status.toString()),
                      title: Text(
                          AppLocalization.of(context)!.lookup(status.name)),
                      controlAffinity: ListTileControlAffinity.leading,
                      value: statusFilters.contains(status),
                      activeColor: Theme.of(context).colorScheme.secondary,
                      dense: true,
                      onChanged: (value) {
                        widget.onSelectedStatus!(status, value);
                      },
                    );
                  }).toList(),
                ),
              ]),
            );
          },
        );
      });

      _filterStatusController!.closed.whenComplete(() {
        _filterStatusController = null;
      });
    }

    showSortSheet() {
      if (closeBottomSheet() == kSortPanel) {
        return;
      }

      _sortController = Scaffold.of(context).showBottomSheet((context) {
        return StoreConnector<AppState, ListUIState>(
          //distinct: true,
          converter: (Store<AppState> store) =>
              store.state.getListState(widget.entityType),
          builder: (BuildContext context, listUIState) {
            return Container(
              color: Theme.of(context).colorScheme.surface,
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: widget.sortFields.map((sortField) {
                    final field = sortField;
                    return InkWell(
                      onTap: () => widget.onSelectedSortField!(sortField),
                      child: IgnorePointer(
                        child: RadioListTile<String>(
                          dense: true,
                          title: Text(
                              AppLocalization.of(context)!.lookup(sortField)),
                          subtitle: sortField == listUIState.sortField
                              ? Text(listUIState.sortAscending
                                  ? AppLocalization.of(context)!.ascending
                                  : AppLocalization.of(context)!.descending)
                              : null,
                          groupValue: listUIState.sortField,
                          activeColor: Theme.of(context).colorScheme.secondary,
                          onChanged: (String? value) {
                            if (value == null &&
                                listUIState.sortField == field) {
                              // Is re-selecting
                              widget.onSelectedSortField!(field);
                            } else if (value != null) {
                              widget.onSelectedSortField!(value);
                            }
                          },
                          value: field,
                          toggleable: true,
                        ),
                      ),
                    );
                  }).toList()),
            );
          },
        );
      });

      _sortController!.closed.whenComplete(() {
        _sortController = null;
      });
    }

    showFilterCustom1Sheet() {
      if (closeBottomSheet() == kCustom1Panel) {
        return;
      }

      _filterCustom1Controller =
          Scaffold.of(context).showBottomSheet((context) {
        return CustomFieldSelector(
          customNumber: 1,
          entityType: widget.entityType,
          customFilters: state.getListState(widget.entityType).custom1Filters,
          onSelected: (field) => widget.onSelectedCustom1!(field),
          customValues: widget.customValues1,
        );
      });

      _filterCustom1Controller!.closed.whenComplete(() {
        _filterCustom1Controller = null;
      });
    }

    showFilterCustom2Sheet() {
      if (closeBottomSheet() == kCustom2Panel) {
        return;
      }
      _filterCustom2Controller =
          Scaffold.of(context).showBottomSheet((context) {
        return CustomFieldSelector(
          customNumber: 2,
          entityType: widget.entityType,
          customFilters: state.getListState(widget.entityType).custom2Filters,
          onSelected: (field) => widget.onSelectedCustom2!(field),
          customValues: widget.customValues2,
        );
      });

      _filterCustom2Controller!.closed.whenComplete(() {
        _filterCustom2Controller = null;
      });
    }

    showFilterCustom3Sheet() {
      if (closeBottomSheet() == kCustom3Panel) {
        return;
      }

      _filterCustom3Controller =
          Scaffold.of(context).showBottomSheet((context) {
        return CustomFieldSelector(
          customNumber: 3,
          entityType: widget.entityType,
          customFilters: state.getListState(widget.entityType).custom3Filters,
          onSelected: (field) => widget.onSelectedCustom3!(field),
          customValues: widget.customValues3,
        );
      });

      _filterCustom3Controller!.closed.whenComplete(() {
        _filterCustom3Controller = null;
      });
    }

    showFilterCustom4Sheet() {
      if (closeBottomSheet() == kCustom4Panel) {
        return;
      }

      _filterCustom4Controller =
          Scaffold.of(context).showBottomSheet((context) {
        return CustomFieldSelector(
          customNumber: 4,
          entityType: widget.entityType,
          customFilters: state.getListState(widget.entityType).custom4Filters,
          onSelected: (field) => widget.onSelectedCustom4!(field),
          customValues: widget.customValues4,
        );
      });

      _filterCustom4Controller!.closed.whenComplete(() {
        _filterCustom4Controller = null;
      });
    }

    return StoreBuilder(builder: (BuildContext context, Store<AppState> store) {
      final localization = AppLocalization.of(context);
      final isList =
          widget.entityType.isSetting || state.prefState.isModuleList;

      // void _onColumnsPressed() {
      //   multiselectDialog(
      //     context: context,
      //     entityType: widget.entityType,
      //     onSelected: (selected) {
      //       final listUIState = store.state.getListState(widget.entityType);
      //       if (!selected.contains(listUIState.sortField)) {
      //         widget.onSelectedSortField!(selected.isEmpty ? '' : selected[0]);
      //       }
      //       final settings = state.userCompany.settings.rebuild((b) => b
      //         ..tableColumns['${widget.entityType}'] =
      //             BuiltList<String>(selected));
      //       final userCompany =
      //           state.userCompany.rebuild((b) => b..settings.replace(settings));
      //       final user =
      //           state.user.rebuild((b) => b..userCompany.replace(userCompany));
      //       final completer = snackBarCompleter<Null>(
      //           AppLocalization.of(context)!.savedSettings);
      //       store.dispatch(
      //         SaveUserSettingsRequest(
      //           completer: completer,
      //           user: user,
      //         ),
      //       );
      //     },
      //     options: widget.tableColumns ?? [],
      //     defaultSelected: widget.defaultTableColumns ?? [],
      //     selected: state
      //             .userCompany.settings.tableColumns['${widget.entityType}']
      //             ?.toList() ??
      //         [],
      //   );
      // }

      return BottomAppBar(
        elevation: 0,
        shape: CircularNotchedRectangle(),
        child: SizedBox(
          height: kTopBottomBarHeight,
          child: AppBorder(
            isTop: true,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(width: 4),
                if (!widget.entityType.isSetting) ...widget.iconButtons,
                if (!widget.hideListOptions && 
                    (isAdmin(state)|| ProjectConfig.showMultiselectCheckboxByEntityType(
                            widget.entityType, state))) ...[
                  if (isMobile(context))
                    IconButton(
                      tooltip: prefState.enableTooltips
                          ? localization!.multiselect
                          : null,
                      icon: Icon(Icons.check_box),
                      onPressed: () => widget.onCheckboxPressed(),
                    ),
                ],
                if (ProjectConfig.showMyEventsAndAllEventsDropdown(widget.entityType))
                  IconButton(
                    tooltip: 'Event Filter',
                    icon: Icon(Icons.filter_list),
                    onPressed: _showEventsFilterSheet,
                    color: widget.showMyEventsOnly
                        ? Theme.of(context).colorScheme.secondary
                        : null,
                  ),
                if (isMobile(context) &&
                    widget.onSelectedState != null  &&
                    (isAdmin(state)||
                        ProjectConfig.showActionFiltersAndCheckBox(
                            widget.entityType) && isAuthenticated(state)))
                  IconButton(
                    tooltip: localization!.filter,
                    icon: Icon(Icons.filter_list),
                    onPressed: showFilterStateSheet,
                    color: store.state
                            .getListState(widget.entityType)
                            .hasStateFilters
                        ? Theme.of(context).colorScheme.secondary
                        : null,
                  ),
                if (widget.statuses.isNotEmpty && isList)
                  IconButton(
                    tooltip:
                        prefState.enableTooltips ? localization!.status : null,
                    icon: Icon(Icons.filter),
                    onPressed: showFilterStatusSheet,
                    color: store.state
                            .getListState(widget.entityType)
                            .hasStatusFilters
                        ? Theme.of(context).colorScheme.secondary
                        : null,
                  ),
                if (widget.customValues1.isNotEmpty)
                  IconButton(
                    tooltip: prefState.enableTooltips
                        ? localization!.filteredBy.replaceFirst(
                            ':value', widget.customValues1.join(', '))
                        : null,
                    icon: Icon(Icons.looks_one),
                    onPressed: showFilterCustom1Sheet,
                    color: store.state
                            .getListState(widget.entityType)
                            .hasCustom1Filters
                        ? Theme.of(context).colorScheme.secondary
                        : null,
                  ),
                if (widget.customValues2.isNotEmpty)
                  IconButton(
                    tooltip: prefState.enableTooltips
                        ? localization!.filteredBy.replaceFirst(
                            ':value', widget.customValues2.join(', '))
                        : null,
                    icon: Icon(Icons.looks_two),
                    onPressed: showFilterCustom2Sheet,
                    color: store.state
                            .getListState(widget.entityType)
                            .hasCustom2Filters
                        ? Theme.of(context).colorScheme.secondary
                        : null,
                  ),
                if (widget.customValues3.isNotEmpty)
                  IconButton(
                    tooltip: prefState.enableTooltips
                        ? localization!.filteredBy.replaceFirst(
                            ':value', widget.customValues3.join(', '))
                        : '',
                    icon: Icon(Icons.looks_3),
                    onPressed: showFilterCustom3Sheet,
                    color: store.state
                            .getListState(widget.entityType)
                            .hasCustom3Filters
                        ? Theme.of(context).colorScheme.secondary
                        : null,
                  ),
                if (widget.customValues4.isNotEmpty)
                  IconButton(
                    tooltip: prefState.enableTooltips
                        ? localization!.filteredBy.replaceFirst(
                            ':value', widget.customValues4.join(', '))
                        : '',
                    icon: Icon(Icons.looks_4),
                    onPressed: showFilterCustom4Sheet,
                    color: store.state
                            .getListState(widget.entityType)
                            .hasCustom4Filters
                        ? Theme.of(context).colorScheme.secondary
                        : null,
                  ),
                if (!widget.hideListOptions) ...[
                  if (isList &&
                      widget.sortFields.isNotEmpty &&
                      ProjectConfig.showSortingButton)
                    IconButton(
                      tooltip:
                          prefState.enableTooltips ? localization!.sort : null,
                      icon: Icon(Icons.sort_by_alpha),
                      onPressed: showSortSheet,
                    ),
                ],
                if (!state.prefState.isMenuFloated) Spacer(),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class CustomFieldSelector extends StatelessWidget {
  const CustomFieldSelector({
    Key? key,
    required this.customNumber,
    required this.entityType,
    required this.customValues,
    required this.onSelected,
    required this.customFilters,
  }) : super(key: key);

  final int customNumber;
  final EntityType entityType;
  final List<String> customValues;
  final Function(String) onSelected;
  final BuiltList<String> customFilters;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, BuiltList<String>?>(
      converter: (Store<AppState> store) =>
          store.state.getListState(entityType).getCustomFilters(customNumber),
      builder: (BuildContext context, customFilters) {
        return Container(
          color: Theme.of(context).colorScheme.surface,
          child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            Column(
              children: customValues.map<Widget>((customField) {
                return CheckboxListTile(
                  key: Key(customField.toString()),
                  title: Text(customField),
                  controlAffinity: ListTileControlAffinity.leading,
                  value: customFilters!.contains(customField),
                  activeColor: Theme.of(context).colorScheme.secondary,
                  dense: true,
                  onChanged: (value) => onSelected(customField),
                );
              }).toList(),
            ),
          ]),
        );
      },
    );
  }
}
