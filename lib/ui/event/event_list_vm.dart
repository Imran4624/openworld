import 'dart:async';
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/project_config.dart';
import 'package:flutter_boilerplate/ui/app/tables/entity_list.dart';
import 'package:flutter_boilerplate/ui/app/tables/entity_list_opw.dart' as opw;
import 'package:flutter_boilerplate/ui/event/event_list_item.dart';
import 'package:flutter_boilerplate/ui/event/event_presenter.dart';
import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter_boilerplate/redux/ui/list_ui_state.dart';
import 'package:flutter_boilerplate/redux/event/event_selectors.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/event/event_actions.dart';
import 'package:flutter_boilerplate/ui/app/app_webview_url.dart' as appView;

class EventListBuilder extends StatelessWidget {
  const EventListBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, EventListVM>(
      converter: EventListVM.fromStore,
      builder: (context, viewModel) {
        if (ProjectConfig.appType == AppType.opw) {
          return opw.EntityListOpw(
            state: viewModel.state,
            entityList: viewModel.eventList,
            onRefreshed: viewModel.onRefreshed,
            onEventTap: (event) {
              if ((event.callToAction == CallToActionType.thirdParty || 
                   event.callToAction == CallToActionType.thirdParty) && 
                  event.url.isNotEmpty) {
                appView.openUrl(context, event.url, event.name);
              } else {
                final store = StoreProvider.of<AppState>(context);
                store.dispatch(ViewEvent(eventId: event.id));
              }
            },
          );
        }

        return EntityList(
          entityType: EntityType.event,
          presenter: EventPresenter(),
          state: viewModel.state,
          entityList: viewModel.eventList,
          tableColumns: viewModel.tableColumns,
          onRefreshed: viewModel.onRefreshed,
          onLoadMore: viewModel.onLoadMore,
          onSortColumn: viewModel.onSortColumn,
          viewType: ViewType.list,
          onClearMultiselect: viewModel.onClearMultiselect,
          itemBuilder: (BuildContext context, index) {
            final state = viewModel.state;
            final eventId = viewModel.eventList[index];
            final event = viewModel.eventMap[eventId]!;
            final listState = state.getListState(EntityType.event);
            final isInMultiselect = listState.isInMultiselect();

            return EventListItem(
              user: viewModel.state.user,
              filter: viewModel.filter,
              event: event,
              isChecked: isInMultiselect && listState.isSelected(event.id),
            );
          },
        );
      },
    );
  }
}

class EventListVM {
  EventListVM({
    required this.state,
    required this.userCompany,
    required this.eventList,
    required this.eventMap,
    required this.filter,
    required this.isLoading,
    required this.listState,
    required this.onRefreshed,
    required this.onLoadMore,
    required this.onEntityAction,
    required this.tableColumns,
    required this.onSortColumn,
    required this.onClearMultiselect,
  });

  static EventListVM fromStore(Store<AppState> store) {
    Future<void> _handleRefresh(BuildContext context) {
      if (store.state.isLoading) {
        return Future<void>.value();
      }

      final completer = Completer<void>();

      store.dispatch(LoadEvents(
          completer: completer, 
          filter: store.state.eventState.filter,
          isRefresh: true));

      return completer.future;
    }

    Future<void> _handleLoadMore(BuildContext context) {
      if (store.state.isLoading) {
        return Future<void>.value();
      }

      if (store.state.eventState.lastDocument == null) {
        return Future<void>.value();
      }

      final completer = Completer<void>();

      store.dispatch(LoadEvents(
          completer: completer, 
          filter: store.state.eventState.filter,
          isRefresh: false));

      return completer.future;
    }

    final state = store.state;

    final filteredEventList = memoizedFilteredEventList(
      state.getUISelection(EntityType.event),
      state.eventState.map,
      state.eventState.list,
      state.eventListState,
    );
    
    
    return EventListVM(
      state: state,
      userCompany: state.userCompany,
      listState: state.eventListState,
      eventList: filteredEventList,
      eventMap: state.eventState.map,
      isLoading: state.isLoading,
      filter: state.eventState.filter.searchTerm,
      onEntityAction: (BuildContext context, List<BaseEntity> events,
              EntityAction action) =>
          handleEventAction(context, events, action),
      onRefreshed: (context) => _handleRefresh(context),
      onLoadMore: (context) => _handleLoadMore(context),
      tableColumns:
          state.userCompany.settings.getTableColumns(EntityType.event) ??
              EventPresenter.getDefaultTableFields(state.userCompany),
      onSortColumn: (field) => store.dispatch(UpdateEventFilter(
        state.eventState.filter.rebuild((b) => b
          ..sortField = field
          ..sortAscending = state.eventState.filter.sortField == field
              ? !state.eventState.filter.sortAscending
              : true),
      )),
      onClearMultiselect: () => store.dispatch(ClearEventMultiselect()),
    );
  }

  final AppState state;
  final UserCompanyEntity userCompany;
  final List<String> eventList;
  final BuiltMap<String, EventEntity> eventMap;
  final ListUIState listState;
  final String? filter;
  final bool isLoading;
  final Future<void> Function(BuildContext) onRefreshed;
  final Future<void> Function(BuildContext) onLoadMore;
  final Function(BuildContext, List<BaseEntity>, EntityAction) onEntityAction;
  final List<String> tableColumns;
  final Function(String) onSortColumn;
  final Function onClearMultiselect;
}
