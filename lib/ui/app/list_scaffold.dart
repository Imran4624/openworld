// Flutter imports:
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/project_config.dart';
import 'package:flutter_boilerplate/services/session_managment_service.dart';
import 'package:flutter_boilerplate/ui/app/routing_rules.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';

// Project imports:
import 'package:flutter_boilerplate/data/models/entities.dart';
import 'package:flutter_boilerplate/data/models/static/app_theme.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/dashboard/dashboard_actions.dart';
import 'package:flutter_boilerplate/redux/event/event_actions.dart';
import 'package:flutter_boilerplate/redux/settings/settings_actions.dart';
import 'package:flutter_boilerplate/redux/ui/pref_state.dart';
import 'package:flutter_boilerplate/ui/app/app_bottom_bar.dart';
import 'package:flutter_boilerplate/ui/app/history_drawer_vm.dart';
import 'package:flutter_boilerplate/ui/app/icon_text.dart';
import 'package:flutter_boilerplate/utils/localization.dart';
import 'package:flutter_boilerplate/utils/platforms.dart';
import 'menu_drawer_vm.dart';
import 'package:flutter_boilerplate/ui/photo/photo_edit_dialog.dart';
import 'package:flutter_boilerplate/ui/photo/edit/photo_edit_vm.dart';

class ListScaffold extends StatelessWidget {
  const ListScaffold({
    required this.appBarTitle,
    required this.body,
    required this.entityType,
    this.onCheckboxPressed,
    this.appBarActions,
    this.appBarLeadingActions = const [],
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingCenterButton,
    this.onHamburgerLongPress,
    this.onCancelSettingsSection,
    this.onCancelSettingsIndex = 0,
  });

  final EntityType entityType;
  final Widget body;
  final AppBottomBar? bottomNavigationBar;
  final FloatingActionButton? floatingActionButton;
  final Widget appBarTitle;
  final List<Widget>? appBarActions;
  final List<Widget> appBarLeadingActions;
  final Function? onHamburgerLongPress;
  final String? onCancelSettingsSection;
  final int onCancelSettingsIndex;
  final Function? onCheckboxPressed;
  final Widget? floatingCenterButton;

  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    final state = store.state;
    final prefState = state.prefState;
    final localization = AppLocalization.of(context);
    final isSettings = entityType.isSetting;

    final isOriginatorGuest = isGuestUser(state) &&
        state.authState.originator == OriginatorType.guest.value;

    bool isEventAuthor = false;
    final selectionState = state.getUISelection(entityType);
    if (selectionState.filterEntityType == EntityType.event &&
        selectionState.filterEntityId != null) {
      final selectedEvent = state.eventState.map[selectionState.filterEntityId];
      if (selectedEvent != null && isAuthenticated(state)) {
        isEventAuthor = selectedEvent.createdUserId == getLoggedInUserId(store);
      }
    }

    Widget leading = const SizedBox();
    if (isSettings && isMobile(context)) {
      leading = IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      );
    } else if ((isMobile(context) || state.prefState.isMenuFloated) &&
        ProjectConfig.showMenuDrawer) {
      leading = Builder(
        builder: (context) => InkWell(
          onLongPress: onHamburgerLongPress as void Function()?,
          child: IconButton(
            tooltip: localization!.menuSidebar,
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      );
    } else if (!entityType.hideCreate &&
        state.userCompany.canCreate(entityType) &&
        ProjectConfig.showFloatingCreateButton(entityType) &&
        isAuthenticated(state)) {
      leading = Padding(
        padding: const EdgeInsets.only(left: 16, right: 14),
        child: OutlinedButton(
          style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(AppTheme.light.success)),
          onPressed: () {
            if (ProjectConfig.showCreateEditInDialog(entityType)) {
              final viewModel = PhotoEditVM.fromStore(store);
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => PhotoEditDialog(
                  viewModel: viewModel,
                  isEditMode: false,
                  onClose: () => Navigator.of(context).pop(),
                ),
              );
            } else {
              createEntityByType(entityType: entityType, context: context);
            }
          },
          child: IconText(
            text: localization!.create,
            icon: Icons.add,
            style: TextStyle(color: AppTheme.dark.text),
          ),
        ),
      );
    }

    double leadingWidth = 0;
    if (entityType == EntityType.settings) {
      leadingWidth = isDesktop(context) && !state.prefState.isMenuFloated
          ? 0
          : kMinInteractiveDimension;
    } else if (!ProjectConfig.showFloatingCreateButton(entityType)) {
      leadingWidth = 40;
    } else {
      leadingWidth = (isDesktop(context) ? 100 : 10) +
          (kMinInteractiveDimension - 4) *
              (appBarLeadingActions.length +
                  (onCheckboxPressed == null || isMobile(context) ? 1 : 2));
    }

    leading = Row(
      children: [
        Expanded(child: leading),
        if (ProjectConfig.showTopbarForPhotos(context,
                state.authState.originator == OriginatorType.guest.value,
                isEventAuthor: isEventAuthor) &&
            onCheckboxPressed != null &&
            (ProjectConfig.showMultiselectCheckboxByEntityType(
                    entityType, state) ||
                state.authState.isAdmin) &&
            isAuthenticated(state))
          IconButton(
            icon: const Icon(Icons.check_box),
            tooltip:
                prefState.enableTooltips ? localization!.multiselect : null,
            onPressed:
                state.prefState.showKanban ? null : () => onCheckboxPressed!(),
          ),
        if (appBarLeadingActions.isNotEmpty) const SizedBox(width: 4),
        ...appBarLeadingActions,
      ],
    );

    return PopScope(
        canPop: !isSettings,
        onPopInvoked: (_) {
          if (!isSettings) {
            store.dispatch(ViewDashboard());
          }
        },
        child: FocusTraversalGroup(
            child: Scaffold(
          drawer: ProjectConfig.showMenuDrawer &&
                  (isMobile(context) || state.prefState.isMenuFloated)
              ? const MenuDrawerBuilder()
              : null,
          endDrawer: (isMobile(context) ||
                      (state.prefState.isHistoryFloated && !isSettings)) &&
                  ProjectConfig.showActivityLog
              ? const HistoryDrawerBuilder()
              : null,
          appBar: ProjectConfig.showEntityTopBar(
                      state.uiState.currentRoute, isMobile(context),entityType: entityType) &&
                  (entityType == EntityType.photo
                      ? ProjectConfig.showTopbarForPhotos(
                          context, isOriginatorGuest,
                          isEventAuthor: isEventAuthor)
                      : true)
              ? AppBar(
                  centerTitle: false,
                  automaticallyImplyLeading: false,
                  leading: leading,
                  shadowColor: ProjectConfig.showTopbarBackground()
                      ? null
                      : AppTheme.light.transparent,
                  backgroundColor: ProjectConfig.showTopbarBackground()
                      ? null
                      : AppTheme.light.transparent,
                  leadingWidth: leadingWidth,
                  title: Row(
                    children: [
                      Expanded(child: appBarTitle),
                      if (isDesktop(context) && onCancelSettingsSection != null)
                        TextButton(
                            onPressed: () {
                              store.dispatch(ViewSettings(
                                company: state.company,
                                section: onCancelSettingsSection,
                                tabIndex: onCancelSettingsIndex,
                              ));
                            },
                            child: Text(
                              localization!.back,
                              style: TextStyle(color: state.headerTextColor),
                            )),
                    ],
                  ),
                  actions: [
                    ...appBarActions ?? <Widget>[],
                    if (ProjectConfig.appType == AppType.loopjam &&
                        entityType == EntityType.photo &&
                        isEventAuthor &&
                        isAuthenticated(state))
                      PopupMenuButton<String>(
                        icon: Icon(
                          Icons.more_vert,
                          color: state.headerTextColor,
                        ),
                        onSelected: (String value) {
                          final selectedEventId = selectionState.filterEntityId;
                          if (selectedEventId != null && value == 'purge') {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Confirm Delete'),
                                  content: const Text(
                                      'Are you sure you want to permanently delete this event? This action cannot be undone.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();

                                        final completer = Completer<void>();

                                        completer.future.then((_) {
                                          RoutingRules
                                              .defaultEntityLoadingRouting();
                                        }).catchError((error) {
                                          logError('Action failed: $error');
                                          showToast("Can't delete event");
                                        });

                                        store.dispatch(PurgeEventsRequest(
                                          completer,
                                          [selectedEventId],
                                        ));
                                      },
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.red,
                                      ),
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        itemBuilder: (BuildContext context) => [
                          const PopupMenuItem<String>(
                            value: 'purge',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.delete_forever,
                                  color: Colors.red,
                                  size: 20,
                                ),
                                SizedBox(width: 12),
                                Text(
                                  'Delete Event',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    if (!isSettings &&
                        (isMobile(context) ||
                            !state.prefState.isHistoryVisible) &&
                        ProjectConfig.showActivityLog)
                      Builder(builder: (context) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: IconButton(
                              padding: const EdgeInsets.only(right: 8),
                              onPressed: () {
                                if (isMobile(context) ||
                                    state.prefState.isHistoryFloated) {
                                  Scaffold.of(context).openEndDrawer();
                                } else {
                                  store.dispatch(UpdateUserPreferences(
                                      sidebar: AppSidebar.history));
                                }
                              },
                              icon: Icon(
                                Icons.history,
                                color: state.headerTextColor,
                              )),
                        );
                      }),
                    /*
                  Builder(
                    builder: (context) => IconButton(
                      padding: const EdgeInsets.only(left: 4, right: 20),
                      tooltip: prefState.enableTooltips
                          ? localization.history
                          : null,
                      icon: Icon(Icons.history),
                      onPressed: () {
                        if (isMobile(context) ||
                            state.prefState.isHistoryFloated) {
                          Scaffold.of(context).openEndDrawer();
                        } else {
                          store.dispatch(UpdateUserPreferences(
                              sidebar: AppSidebar.history));
                        }
                      },
                    ),
                  ),
                  */
                  ],
                )
              : null,
          body: Stack(
            children: [
              Column(children: [
                Expanded(
                  child: ClipRect(
                    child: body,
                  ),
                ),
              ]),
              if (floatingCenterButton != null) floatingCenterButton!,
            ],
          ),
          bottomNavigationBar: isMobile(context) &&
                  ProjectConfig.showBottomCheckBoxAndFiltersByEntityType(
                      entityType, isAdmin(state)) &&
                  isAuthenticated(state)
              ? bottomNavigationBar
              : null,
          floatingActionButton: floatingActionButton,
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        )));
  }
}
