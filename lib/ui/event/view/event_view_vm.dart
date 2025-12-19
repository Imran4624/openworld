import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/utils/completers.dart';
import 'package:flutter_boilerplate/utils/localization.dart';
import 'package:flutter_boilerplate/utils/company_assignment_utils.dart';
import 'package:redux/redux.dart';
import 'package:flutter_boilerplate/redux/ui/ui_actions.dart';
import 'package:flutter_boilerplate/ui/event/event_screen.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/redux/event/event_actions.dart';

import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/ui/event/view/event_view.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';

class EventViewScreen extends StatelessWidget {
  const EventViewScreen({
    Key? key,
    this.isFilter = false,
    this.isTopFilter = false,
  }) : super(key: key);

  static const String route = '/event/view';

  final bool isFilter;
  final bool isTopFilter;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, EventViewVM>(
      converter: (Store<AppState> store) {
        return EventViewVM.fromStore(store);
      },
      builder: (context, vm) {
        return EventView(
          viewModel: vm,
          isFilter: isFilter,
          isTopFilter: isTopFilter,
        );
      },
    );
  }
}

class EventViewVM {
  EventViewVM({
    required this.state,
    required this.event,
    required this.company,
    required this.onEntityAction,
    required this.onRefreshed,
    required this.isSaving,
    required this.isLoading,
    required this.isDirty,
    required this.onBackPressed,
    required this.onEventOperation,
  });

  factory EventViewVM.fromStore(Store<AppState> store) {
    final state = store.state;
    final event = state.eventState.map[state.eventUIState.selectedId] ??
        EventEntity(id: state.eventUIState.selectedId);

    Future<Null> _handleRefresh(BuildContext context) {
      final completer =
          snackBarCompleter<Null>(AppLocalization.of(context)!.refreshComplete);
      store.dispatch(LoadEvent(completer: completer, eventId: event.id));
      return completer.future;
    }

    return EventViewVM(
      state: state,
      company: state.company,
      isSaving: state.isSaving,
      isLoading: state.isLoading,
      isDirty: event.isNew,
      event: event,
      onRefreshed: (context) => _handleRefresh(context),
      onBackPressed: () {
        store.dispatch(UpdateCurrentRoute(EventScreen.route));
      },
      onEntityAction: (BuildContext context, EntityAction action) =>
          handleEntitiesActions([event], action, autoPop: true),
      onEventOperation: (String eventId, String userId, int eventOperationType, [Completer? completer]) {
        store.dispatch(SaveEventOperation(
          eventId: eventId,
          userId: userId,
          eventOperationType: eventOperationType,
          completer: completer,
        ));
      },
    );
  }

  final AppState state;
  final EventEntity event;
  final CompanyEntity company;
  final Function(BuildContext, EntityAction) onEntityAction;
  final Function(BuildContext) onRefreshed;
  final Function onBackPressed;
  final Function(String eventId, String userId, int eventOperationType, [Completer? completer]) onEventOperation;
  final bool isSaving;
  final bool isLoading;
  final bool isDirty;
}
