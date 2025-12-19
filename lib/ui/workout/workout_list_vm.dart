import 'dart:async';
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/ui/app/tables/entity_list.dart';
import 'package:flutter_boilerplate/ui/workout/workout_list_item.dart';
import 'package:flutter_boilerplate/ui/workout/workout_presenter.dart';
import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter_boilerplate/redux/ui/list_ui_state.dart';
import 'package:flutter_boilerplate/redux/workout/workout_selectors.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/workout/workout_actions.dart';

class WorkoutListBuilder extends StatelessWidget {
  const WorkoutListBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, WorkoutListVM>(
      converter: WorkoutListVM.fromStore,
      builder: (context, viewModel) {
        return EntityList(
          entityType: EntityType.workout,
          presenter: WorkoutPresenter(),
          state: viewModel.state,
          entityList: viewModel.workoutList,
          tableColumns: viewModel.tableColumns,
          onRefreshed: viewModel.onRefreshed,
          onSortColumn: viewModel.onSortColumn,
          viewType: ViewType.list,
          onClearMultiselect: viewModel.onClearMultiselect,
          itemBuilder: (BuildContext context, index) {
            final state = viewModel.state;
            final workoutId = viewModel.workoutList[index];
            final workout = viewModel.workoutMap[workoutId]!;
            final listState = state.getListState(EntityType.workout);
            final isInMultiselect = listState.isInMultiselect();

            return WorkoutListItem(
              user: viewModel.state.user,
              filter: viewModel.filter,
              workout: workout,
              isChecked: isInMultiselect && listState.isSelected(workout.id),
            );
          },
        );
      },
    );
  }
}

class WorkoutListVM {
  WorkoutListVM({
    required this.state,
    required this.userCompany,
    required this.workoutList,
    required this.workoutMap,
    required this.filter,
    required this.isLoading,
    required this.listState,
    required this.onRefreshed,
    required this.onEntityAction,
    required this.tableColumns,
    required this.onSortColumn,
    required this.onClearMultiselect,
  });

  static WorkoutListVM fromStore(Store<AppState> store) {
    Future<void> _handleRefresh(BuildContext context) {
      if (store.state.isLoading) {
        return Future<void>.value();
      }

      final completer = Completer<void>();

      store.dispatch(LoadWorkouts(
          completer: completer, filter: store.state.workoutState.filter));

      return completer.future;
    }

    final state = store.state;

    return WorkoutListVM(
      state: state,
      userCompany: state.userCompany,
      listState: state.workoutListState,
      workoutList: memoizedFilteredWorkoutList(
        state.getUISelection(EntityType.workout),
        state.workoutState.map,
        state.workoutState.list,
        state.workoutListState,
      ),
      workoutMap: state.workoutState.map,
      isLoading: state.isLoading,
      filter: state.workoutState.filter.searchTerm,
      onEntityAction: (BuildContext context, List<BaseEntity> workouts,
              EntityAction action) =>
          handleWorkoutAction(context, workouts, action),
      onRefreshed: (context) => _handleRefresh(context),
      tableColumns:
          state.userCompany.settings?.getTableColumns(EntityType.workout) ??
              WorkoutPresenter.getDefaultTableFields(state.userCompany),
      onSortColumn: (field) => store.dispatch(UpdateWorkoutFilter(
        state.workoutState.filter.rebuild((b) => b
          ..sortField = field
          ..sortAscending = state.workoutState.filter.sortField == field
              ? !state.workoutState.filter.sortAscending
              : true),
      )),
      onClearMultiselect: () => store.dispatch(ClearWorkoutMultiselect()),
    );
  }

  final AppState state;
  final UserCompanyEntity userCompany;
  final List<String> workoutList;
  final BuiltMap<String, WorkoutEntity> workoutMap;
  final ListUIState listState;
  final String? filter;
  final bool isLoading;
  final Function(BuildContext) onRefreshed;
  final Function(BuildContext, List<BaseEntity>, EntityAction) onEntityAction;
  final List<String> tableColumns;
  final Function(String) onSortColumn;
  final Function onClearMultiselect;
}
