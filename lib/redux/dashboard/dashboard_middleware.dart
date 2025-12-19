// Flutter imports:
import 'package:flutter/widgets.dart';
// Package imports:
import 'package:redux/redux.dart';

// Project imports:
import 'package:flutter_boilerplate/main_app.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/dashboard/dashboard_actions.dart';
import 'package:flutter_boilerplate/redux/ui/ui_actions.dart';
import 'package:flutter_boilerplate/ui/dashboard/dashboard_screen_vm.dart';
import 'package:flutter_boilerplate/services/session_managment_service.dart';

List<Middleware<AppState>> createStoreDashboardMiddleware() {
  final viewDashboard = _createViewDashboard();

  return [
    TypedMiddleware<AppState, ViewDashboard>(viewDashboard),
  ];
}

Middleware<AppState> _createViewDashboard() {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as ViewDashboard;

    checkForChanges(
        store: store,
        force: action.force,
        callback: () {
          final state = store.state;

          if (state.isStale && isAuthenticated(state)) {
            store.dispatch(RefreshData());
          }

          next(action);

          store.dispatch(UpdateCurrentRoute(DashboardScreenBuilder.route));

          if (store.state.prefState.isMobile &&
              store.state.userCompany.canViewDashboard) {
            navigatorKey.currentState!.pushNamedAndRemoveUntil(
                DashboardScreenBuilder.route, (Route<dynamic> route) => false);
          }
        });
  };
}
