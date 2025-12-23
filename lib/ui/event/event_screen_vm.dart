import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/event/event_actions.dart';
import 'package:flutter_boilerplate/redux/event/event_selectors.dart';
import 'package:redux/redux.dart';

import 'event_screen.dart';

class EventScreenBuilder extends StatelessWidget {
  const EventScreenBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, EventScreenVM>(
      converter: EventScreenVM.fromStore,
      onInit: (store) {
          store.dispatch(LoadEvents(isRefresh: true));
      },
      builder: (context, vm) {
        return EventScreen(
          viewModel: vm,
        );
      },
    );
  }
}

class EventScreenVM {
  EventScreenVM({
    required this.isInMultiselect,
    required this.eventList,
    required this.userCompany,
    required this.onEntityAction,
    required this.eventMap,
  });

  final bool isInMultiselect;
  final UserCompanyEntity userCompany;
  final List<String> eventList;
  final Function(BuildContext, List<BaseEntity>, EntityAction) onEntityAction;
  final BuiltMap<String, EventEntity> eventMap;

  static EventScreenVM fromStore(Store<AppState> store) {
    final state = store.state;

    return EventScreenVM(
      eventMap: state.eventState.map,
      eventList: memoizedFilteredEventList(
        state.getUISelection(EntityType.event),
        state.eventState.map,
        state.eventState.list,
        state.eventListState,
      ),
      userCompany: state.userCompany,
      isInMultiselect: state.eventListState.isInMultiselect(),
      onEntityAction: (BuildContext context, List<BaseEntity> events,
              EntityAction action) =>
          handleEventAction(context, events, action),
    );
  }
}
