import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/workout/workout_actions.dart';
import 'package:flutter_boilerplate/redux/workout/workout_selectors.dart';
import 'package:redux/redux.dart';

import 'workout_screen.dart';

class WorkoutScreenBuilder extends StatelessWidget {
  const WorkoutScreenBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, WorkoutScreenVM>(
      converter: WorkoutScreenVM.fromStore,
      onInit: (store) {
        store.dispatch(LoadWorkouts(isRefresh: true));
      },
      builder: (context, vm) {
        return WorkoutScreen(
          viewModel: vm,
        );
      },
    );
  }
}

class WorkoutScreenVM {
  WorkoutScreenVM({
    required this.isInMultiselect,
    required this.workoutList,
    required this.userCompany,
    required this.onEntityAction,
    required this.workoutMap,
  });

  final bool isInMultiselect;
  final UserCompanyEntity userCompany;
  final List<String> workoutList;
  final Function(BuildContext, List<BaseEntity>, EntityAction) onEntityAction;
  final BuiltMap<String, WorkoutEntity> workoutMap;

  static WorkoutScreenVM fromStore(Store<AppState> store) {
    final state = store.state;

    return WorkoutScreenVM(
      workoutMap: state.workoutState.map,
      workoutList: memoizedFilteredWorkoutList(
        state.getUISelection(EntityType.workout),
        state.workoutState.map,
        state.workoutState.list,
        state.workoutListState,
      ),
      userCompany: state.userCompany,
      isInMultiselect: state.workoutListState.isInMultiselect(),
      onEntityAction: (BuildContext context, List<BaseEntity> workouts,
              EntityAction action) =>
          handleWorkoutAction(context, workouts, action),
    );
  }
}
