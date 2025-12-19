import 'dart:async';
import 'package:flutter_boilerplate/main_app.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/utils/completers.dart';
import 'package:flutter_boilerplate/utils/localization.dart';
import 'package:flutter_boilerplate/utils/platforms.dart';
import 'package:redux/redux.dart';
import 'package:flutter_boilerplate/redux/ui/ui_actions.dart';
import 'package:flutter_boilerplate/ui/workout/workout_screen.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/redux/workout/workout_actions.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/ui/workout/view/workout_view.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';

class WorkoutViewScreen extends StatelessWidget {
  const WorkoutViewScreen({
    Key? key,
    this.isFilter = false,
  }) : super(key: key);

  static const String route = '/workout/view';

  final bool isFilter;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, WorkoutViewVM>(
      converter: (Store<AppState> store) {
        return WorkoutViewVM.fromStore(store);
      },
      builder: (context, vm) {
        return WorkoutView(
          viewModel: vm,
          isFilter: isFilter,
        );
      },
    );
  }
}

class WorkoutViewVM {
  WorkoutViewVM({
    required this.state,
    required this.workout,
    required this.company,
    required this.onEntityAction,
    required this.onRefreshed,
    required this.isSaving,
    required this.isLoading,
    required this.isDirty,
    required this.onBackPressed,
  });

  factory WorkoutViewVM.fromStore(Store<AppState> store) {
    final state = store.state;
    final workout = state.workoutState.map[state.workoutUIState.selectedId] ??
        WorkoutEntity(id: state.workoutUIState.selectedId);

    Future<Null> _handleRefresh(BuildContext context) {
      final completer =
          snackBarCompleter<Null>(AppLocalization.of(context)!.refreshComplete);
      store.dispatch(LoadWorkout(completer: completer, workoutId: workout.id));
      return completer.future;
    }

    return WorkoutViewVM(
      state: state,
      company: state.company,
      isSaving: state.isSaving,
      isLoading: state.isLoading,
      isDirty: workout.isNew,
      workout: workout,
      onRefreshed: (context) => _handleRefresh(context),
      onBackPressed: () {
        if (isMobile(navigatorKey.currentContext!)) {
          Navigator.of(navigatorKey.currentContext!).pop();
        }
        store.dispatch(UpdateCurrentRoute(WorkoutScreen.route));
      },
      onEntityAction: (BuildContext context, EntityAction action) =>
          handleEntitiesActions([workout], action, autoPop: true),
    );
  }

  final AppState state;
  final WorkoutEntity workout;
  final CompanyEntity company;
  final Function(BuildContext, EntityAction) onEntityAction;
  final Function(BuildContext) onRefreshed;
  final Function onBackPressed;
  final bool isSaving;
  final bool isLoading;
  final bool isDirty;
}
