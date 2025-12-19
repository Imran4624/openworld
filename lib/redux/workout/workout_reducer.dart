import 'package:redux/redux.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/company/company_actions.dart';
import 'package:flutter_boilerplate/redux/ui/entity_ui_state.dart';
import 'package:flutter_boilerplate/redux/workout/workout_actions.dart';
import 'package:flutter_boilerplate/redux/ui/list_ui_state.dart';
import 'package:flutter_boilerplate/redux/workout/workout_state.dart';

EntityUIState workoutUIReducer(WorkoutUIState state, dynamic action) {
  return state.rebuild((b) => b
    ..listUIState.replace(workoutListReducer(state.listUIState, action))
    ..editing.replace(editingReducer(state.editing, action)!)
    ..selectedId = selectedIdReducer(state.selectedId, action)
    ..forceSelected = forceSelectedReducer(state.forceSelected, action)
    ..tabIndex = tabIndexReducer(state.tabIndex, action));
}

final forceSelectedReducer = combineReducers<bool?>([
  TypedReducer<bool?, ViewWorkout>((completer, action) => true),
  TypedReducer<bool?, ViewWorkoutList>((completer, action) => false),
  TypedReducer<bool?, FilterWorkoutsByState>((completer, action) => false),
  TypedReducer<bool?, FilterWorkouts>((completer, action) => false),
]);

final tabIndexReducer = combineReducers<int?>([
  TypedReducer<int?, UpdateWorkoutTab>((completer, action) => action.tabIndex),
  TypedReducer<int?, PreviewEntity>((completer, action) => 0),
]);

Reducer<String?> selectedIdReducer = combineReducers([
  TypedReducer<String?, ArchiveWorkoutsSuccess>((completer, action) => ''),
  TypedReducer<String?, DeleteWorkoutsSuccess>((completer, action) => ''),
  TypedReducer<String?, PurgeWorkoutsSuccess>((completer, action) => ''),
  TypedReducer<String?, PreviewEntity>((selectedId, action) =>
      action.entityType == EntityType.workout ? action.entityId : selectedId),
  TypedReducer<String?, ViewWorkout>(
      (String? selectedId, dynamic action) => action.workoutId),
  TypedReducer<String?, AddWorkoutSuccess>(
      (String? selectedId, dynamic action) => action.workout.id),
  TypedReducer<String?, SelectCompany>(
      (selectedId, action) => action.clearSelection ? '' : selectedId),
  TypedReducer<String?, ClearEntityFilter>((selectedId, action) => ''),
  TypedReducer<String?, SortWorkouts>((selectedId, action) => ''),
  TypedReducer<String?, FilterWorkouts>((selectedId, action) => ''),
  TypedReducer<String?, FilterWorkoutsByState>((selectedId, action) => ''),
  TypedReducer<String?, FilterByEntity>(
      (selectedId, action) => action.clearSelection
          ? ''
          : action.entityType == EntityType.workout
              ? action.entityId
              : selectedId),
]);

final editingReducer = combineReducers<WorkoutEntity?>([
  TypedReducer<WorkoutEntity?, SaveWorkoutSuccess>(_updateEditing),
  TypedReducer<WorkoutEntity?, AddWorkoutSuccess>(_updateEditing),
  TypedReducer<WorkoutEntity?, RestoreWorkoutsSuccess>((workouts, action) {
    return action.workouts[0];
  }),
  TypedReducer<WorkoutEntity?, ArchiveWorkoutsSuccess>((workouts, action) {
    return action.workouts[0];
  }),
  TypedReducer<WorkoutEntity?, DeleteWorkoutsSuccess>((workouts, action) {
    return action.workouts[0];
  }),
  TypedReducer<WorkoutEntity?, PurgeWorkoutsSuccess>((workouts, action) {
    return action.workouts[0];
  }),
  TypedReducer<WorkoutEntity?, EditWorkout>(_updateEditing),
  TypedReducer<WorkoutEntity?, UpdateWorkout>((workout, action) {
    return action.workout.rebuild((b) => b..isChanged = true);
  }),
  TypedReducer<WorkoutEntity?, DiscardChanges>(_clearEditing),
]);

WorkoutEntity _clearEditing(WorkoutEntity? workout, dynamic action) {
  return WorkoutEntity();
}

WorkoutEntity? _updateEditing(WorkoutEntity? workout, dynamic action) {
  return action.workout;
}

final workoutListReducer = combineReducers<ListUIState>([
  TypedReducer<ListUIState, SortWorkouts>(_sortWorkouts),
  TypedReducer<ListUIState, FilterWorkoutsByState>(_filterWorkoutsByState),
  TypedReducer<ListUIState, FilterWorkouts>(_filterWorkouts),
  TypedReducer<ListUIState, StartWorkoutMultiselect>(_startListMultiselect),
  TypedReducer<ListUIState, AddToWorkoutMultiselect>(_addToListMultiselect),
  TypedReducer<ListUIState, RemoveFromWorkoutMultiselect>(
      _removeFromListMultiselect),
  TypedReducer<ListUIState, ClearWorkoutMultiselect>(_clearListMultiselect),
  TypedReducer<ListUIState, ViewWorkoutList>(_viewWorkoutList),
  TypedReducer<ListUIState, FilterByEntity>((state, action) => state.rebuild(
        (b) => b
          ..filter = null
          ..filterClearedAt = DateTime.now().millisecondsSinceEpoch,
      )),
]);

ListUIState _viewWorkoutList(
    ListUIState workoutListState, ViewWorkoutList action) {
  return workoutListState.rebuild((b) => b
    ..selectedIds = null
    ..filter = null
    ..filterClearedAt = DateTime.now().millisecondsSinceEpoch);
}

ListUIState _filterWorkoutsByState(
    ListUIState workoutListState, FilterWorkoutsByState action) {
  if (workoutListState.stateFilters.contains(action.state)) {
    return workoutListState.rebuild((b) => b
      ..stateFilters.clear()
      ..stateFilters.add(EntityState.active));
  } else {
    return workoutListState.rebuild((b) => b
      ..stateFilters.clear()
      ..stateFilters.add(action.state));
  }
}

ListUIState _filterWorkouts(
    ListUIState workoutListState, FilterWorkouts action) {
  return workoutListState.rebuild((b) => b
    ..filter = action.filter
    ..filterClearedAt = action.filter == null
        ? DateTime.now().millisecondsSinceEpoch
        : workoutListState.filterClearedAt);
}

ListUIState _sortWorkouts(ListUIState workoutListState, SortWorkouts action) {
  return workoutListState.rebuild((b) => b
    ..sortAscending = b.sortField != action.field || !b.sortAscending!
    ..sortField = action.field);
}

ListUIState _startListMultiselect(
    ListUIState productListState, StartWorkoutMultiselect action) {
  return productListState.rebuild((b) => b..selectedIds = ListBuilder());
}

ListUIState _addToListMultiselect(
    ListUIState productListState, AddToWorkoutMultiselect action) {
  return productListState.rebuild((b) => b..selectedIds.add(action.entity.id));
}

ListUIState _removeFromListMultiselect(
    ListUIState productListState, RemoveFromWorkoutMultiselect action) {
  return productListState
      .rebuild((b) => b..selectedIds.remove(action.entity.id));
}

ListUIState _clearListMultiselect(
    ListUIState productListState, ClearWorkoutMultiselect action) {
  return productListState.rebuild((b) => b..selectedIds = null);
}

final workoutsReducer = combineReducers<WorkoutState>([
  TypedReducer<WorkoutState, SaveWorkoutSuccess>(_updateWorkout),
  TypedReducer<WorkoutState, AddWorkoutSuccess>(_addWorkout),
  TypedReducer<WorkoutState, LoadWorkoutsSuccess>(_setLoadedWorkouts),
  TypedReducer<WorkoutState, LoadWorkoutSuccess>(_setLoadedWorkout),
  TypedReducer<WorkoutState, UpdateLastDocumentAction>(_updateLastDocument),
  TypedReducer<WorkoutState, UpdateWorkoutFilter>(_updateWorkoutFilter),
  // TypedReducer<WorkoutState, LoadCompanySuccess>(_setLoadedCompany), //uncomment this if you its dependant on selected company
  TypedReducer<WorkoutState, ArchiveWorkoutsSuccess>(_archiveWorkoutSuccess),
  TypedReducer<WorkoutState, DeleteWorkoutsSuccess>(_deleteWorkoutSuccess),
  TypedReducer<WorkoutState, PurgeWorkoutsSuccess>(_purgeWorkoutSuccess),
  TypedReducer<WorkoutState, RestoreWorkoutsSuccess>(_restoreWorkoutSuccess),
]);

WorkoutState _archiveWorkoutSuccess(
    WorkoutState workoutState, ArchiveWorkoutsSuccess action) {
  final int currentTime = DateTime.now().millisecondsSinceEpoch;
  return workoutState.rebuild((b) {
    for (final workout in action.workouts) {
      b.map[workout.id] = workoutState.map[workout.id]!
          .rebuild((b) => b..archivedAt = currentTime);
    }
  });
}

WorkoutState _updateWorkoutFilter(
    WorkoutState workoutState, UpdateWorkoutFilter action) {
  return workoutState.rebuild((b) => b..filter = action.filter.toBuilder());
}

// WorkoutState _deleteWorkoutSuccess(WorkoutState workoutState, DeleteWorkoutsSuccess action) {
//   return workoutState.rebuild((b) {
//     for (final workout in action.workouts) {
//       b.map[workout.id] = workout;
//     }
//   });
// }

WorkoutState _deleteWorkoutSuccess(
    WorkoutState workoutState, DeleteWorkoutsSuccess action) {
  return workoutState.rebuild((b) {
    for (final workout in action.workouts) {
      b.map[workout.id] =
          workoutState.map[workout.id]!.rebuild((b) => b..isDeleted = true);
    }
  });
}

WorkoutState _purgeWorkoutSuccess(
    WorkoutState workoutState, PurgeWorkoutsSuccess action) {
  return workoutState.rebuild((b) {
    for (final workout in action.workouts) {
      b.map.remove(workout.id);
      b.list.remove(workout.id);
    }
  });
}

WorkoutState _restoreWorkoutSuccess(
    WorkoutState workoutState, RestoreWorkoutsSuccess action) {
  return workoutState.rebuild((b) {
    for (final workout in action.workouts) {
      b.map[workout.id] = workoutState.map[workout.id]!.rebuild((b) => b
        ..isDeleted = false
        ..archivedAt = 0);
    }
  });
}

WorkoutState _addWorkout(WorkoutState workoutState, AddWorkoutSuccess action) {
  return workoutState.rebuild((b) => b
    ..map[action.workout.id] = action.workout
    ..list.add(action.workout.id));
}

WorkoutState _updateWorkout(
    WorkoutState workoutState, SaveWorkoutSuccess action) {
  return workoutState
      .rebuild((b) => b..map[action.workout.id] = action.workout);
}

WorkoutState _updateLastDocument(
    WorkoutState workoutState, UpdateLastDocumentAction action) {
  return workoutState.rebuild((b) => b..lastDocument = action.lastDocument);
}

WorkoutState _setLoadedWorkout(
    WorkoutState workoutState, LoadWorkoutSuccess action) {
  return workoutState
      .rebuild((b) => b..map[action.workout.id] = action.workout);
}

WorkoutState _setLoadedWorkouts(
    WorkoutState workoutState, LoadWorkoutsSuccess action) {
  return workoutState.rebuild((b) {
    if (action.isRefresh) {
      b.map.clear();
      b.list.clear();
    }
    action.workouts.forEach((workout) {
      b.map[workout.id] = workout;
      if (!b.list.build().contains(workout.id)) {
        b.list.add(workout.id);
      }
    });
  });
}

// WorkoutState _setLoadedCompany(WorkoutState workoutState, LoadCompanySuccess action) {
//   final company = action.userCompany.company;
//   return workoutState.loadWorkouts(company.workouts);
// }
