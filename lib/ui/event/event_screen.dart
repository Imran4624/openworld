import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/project_config.dart';
import 'package:flutter_boilerplate/services/session_managment_service.dart';
import 'package:flutter_boilerplate/utils/platforms.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/event/event_actions.dart';
import 'package:flutter_boilerplate/ui/app/app_bottom_bar.dart';
import 'package:flutter_boilerplate/ui/app/list_scaffold.dart';
import 'package:flutter_boilerplate/ui/app/list_filter.dart';
import 'package:flutter_boilerplate/ui/event/event_list_vm.dart';
import 'package:flutter_boilerplate/ui/event/event_presenter.dart';
import 'package:flutter_boilerplate/ui/event/event_tabs.dart';
import 'package:flutter_boilerplate/utils/localization.dart';

import 'event_screen_vm.dart';

class EventScreen extends StatelessWidget {
  const EventScreen({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  static const String route = '/event';

  final EventScreenVM viewModel;

  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    final state = store.state;
    final userCompany = state.userCompany;
    final localization = AppLocalization.of(context)!;
    final topPadding = isMobile(context) ? 60.0 : 100.0;

    return ListScaffold(
      entityType: EntityType.event,
      onHamburgerLongPress: () => store.dispatch(StartEventMultiselect()),
      appBarTitle: ListFilter(
        key: ValueKey('__filter_${state.eventListState.filterClearedAt}__'),
        entityType: EntityType.event,
        entityIds: viewModel.eventList,
        filter: state.eventState.filter.searchTerm,
        showMyEventsOnly: state.eventState.showMyEventsOnly,
        onFilterChanged: (value) {
          store.dispatch(FilterEvents(value!));
          store.dispatch(UpdateEventFilter(
            state.eventState.filter.rebuild((b) => b..searchTerm = value ?? ''),
          ));
        },
        onEventsFilterChanged: (showMyEvents) {
          store.dispatch(FilterEventsByOwnership(
              showMyEvents, store.state.authState.email));
        },
        onSelectedState: (EntityState filterState, bool? value) {
          store.dispatch(FilterEventsByState(filterState));
          if (value ?? false) {
            store.dispatch(UpdateEventFilter(
              state.eventState.filter
                  .rebuild((b) => b..stateFilter = filterState),
            ));
          }
        },
        selectedStateFilter: state.eventState.filter.stateFilter,
      ),
      onCheckboxPressed: () {
        if (store.state.eventListState.isInMultiselect()) {
          store.dispatch(ClearEventMultiselect());
        } else {
          store.dispatch(StartEventMultiselect());
        }
      },
      body: Column(
        children: [
          if(ProjectConfig.showTopBar(route, false))
           SizedBox(height: topPadding),
          if (isAuthenticated(state) && ProjectConfig.showMyEventsAndAllEventsTabs())
            EventTabs(
              showMyEventsOnly: state.eventState.showMyEventsOnly,
              onTabChanged: (showMyEvents) {
                store.dispatch(FilterEventsByOwnership(
                    showMyEvents, store.state.authState.email));
              },
            ),
          const Expanded(
            child: EventListBuilder(),
          ),
        ],
      ),
      bottomNavigationBar:
          ProjectConfig.showBottomCheckBoxAndFiltersByEntityType(
                  EntityType.event, isAdmin(state)) && isAuthenticated(state)
              ? AppBottomBar(
                  entityType: EntityType.event,
                  tableColumns: EventPresenter.getAllTableFields(userCompany),
                  defaultTableColumns:
                      EventPresenter.getDefaultTableFields(userCompany),
                  showMyEventsOnly: state.eventState.showMyEventsOnly,
                  onEventsFilterChanged: (showMyEvents) {
                    store.dispatch(FilterEventsByOwnership(
                        showMyEvents, store.state.authState.email));
                  },
                  onSelectedSortField: (field) {
                    final ascending = state.eventState.filter.sortField == field
                        ? !state.eventState.filter.sortAscending
                        : true;
                    store.dispatch(UpdateEventFilter(
                      state.eventState.filter.rebuild((b) => b
                        ..sortField = field
                        ..sortAscending = ascending),
                    ));
                  },
                  sortFields: const [
                    // STARTER: constant fields - do not remove comment
                    EventFields.name,

                    EventFields.accessCode,

                    EventFields.callToAction,

                    EventFields.chk,

                    EventFields.currency,

                    EventFields.description,

                    EventFields.end,

                    EventFields.start,

                    EventFields.eventSeriesId,

                    EventFields.hidden,

                    EventFields.onlineEvent,

                    EventFields.privateEvent,

                    EventFields.status,

                    EventFields.ticketsAvailable,

                    EventFields.totalHolds,

                    EventFields.totalIssuedTickets,

                    EventFields.totalOrders,

                    EventFields.unavailable,

                    EventFields.unavailableStatus,
                  ],
                  onSelectedState: (EntityState filterState, bool? value) {
                    store.dispatch(FilterEventsByState(filterState));
                    if (value ?? false) {
                      store.dispatch(UpdateEventFilter(
                        state.eventState.filter
                            .rebuild((b) => b..stateFilter = filterState),
                      ));
                    }
                  },
                  onCheckboxPressed: () {
                    if (store.state.eventListState.isInMultiselect()) {
                      store.dispatch(ClearEventMultiselect());
                    } else {
                      store.dispatch(StartEventMultiselect());
                    }
                  },
                  // // customValues1: userCompany.getCustomFieldValues(CustomFieldType.event1,
                  // //     excludeBlank: true),
                  // // customValues2: userCompany.getCustomFieldValues(CustomFieldType.event2,
                  // //     excludeBlank: true),
                  // // customValues3: userCompany.getCustomFieldValues(CustomFieldType.event3,
                  // //     excludeBlank: true),
                  // // customValues4: userCompany.getCustomFieldValues(CustomFieldType.event4,
                  //     excludeBlank: true),
                  // onSelectedCustom1: (value) =>
                  //     store.dispatch(FilterEventsByCustom1(value)),
                  // onSelectedCustom2: (value) =>
                  //     store.dispatch(FilterEventsByCustom2(value)),
                  // onSelectedCustom3: (value) =>
                  //     store.dispatch(FilterEventsByCustom3(value)),
                  // onSelectedCustom4: (value) =>
                  //     store.dispatch(FilterEventsByCustom4(value)),
                )
              : null,
      floatingActionButton: state.prefState.isMenuFloated &&
              userCompany.canCreate(EntityType.event) &&
              !isGuestUser(state) &&
              ProjectConfig.showFloatingCreateButton(EntityType.event)
          ? FloatingActionButton(
              heroTag: 'event_fab',
              backgroundColor: Theme.of(context).primaryColorDark,
              onPressed: () {
                createEntityByType(
                    context: context, entityType: EntityType.event);
              },
              tooltip: localization.newEvent,
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            )
          : null,
    );
  }
}
