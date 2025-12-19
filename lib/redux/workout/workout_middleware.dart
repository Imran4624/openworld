import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';
import 'package:built_collection/built_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_boilerplate/main_app.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/ui/ui_actions.dart';
import 'package:flutter_boilerplate/ui/workout/workout_screen.dart';
import 'package:flutter_boilerplate/ui/workout/edit/workout_edit_vm.dart';
import 'package:flutter_boilerplate/ui/workout/view/workout_view_vm.dart';
import 'package:flutter_boilerplate/redux/workout/workout_actions.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/data/repositories/workout_repository.dart';

List<Middleware<AppState>> createStoreWorkoutsMiddleware([
  WorkoutRepository repository = const WorkoutRepository(),
]) {
  final viewWorkoutList = _viewWorkoutList();
  final viewWorkout = _viewWorkout();
  final editWorkout = _editWorkout();
  final loadWorkouts = _loadWorkouts(repository);
  final loadWorkout = _loadWorkout(repository);
  final saveWorkout = _saveWorkout(repository);
  final archiveWorkout = _archiveWorkout(repository);
  final deleteWorkout = _deleteWorkout(repository);
  final purgeWorkout = _purgeWorkout(repository);
  final restoreWorkout = _restoreWorkout(repository);
  final updateFilter = _updateFilter(repository);

  return [
    TypedMiddleware<AppState, ViewWorkoutList>(viewWorkoutList),
    TypedMiddleware<AppState, ViewWorkout>(viewWorkout),
    TypedMiddleware<AppState, EditWorkout>(editWorkout),
    TypedMiddleware<AppState, LoadWorkouts>(loadWorkouts),
    TypedMiddleware<AppState, LoadWorkout>(loadWorkout),
    TypedMiddleware<AppState, SaveWorkoutRequest>(saveWorkout),
    TypedMiddleware<AppState, ArchiveWorkoutsRequest>(archiveWorkout),
    TypedMiddleware<AppState, DeleteWorkoutsRequest>(deleteWorkout),
    TypedMiddleware<AppState, PurgeWorkoutsRequest>(purgeWorkout),
    TypedMiddleware<AppState, RestoreWorkoutsRequest>(restoreWorkout),
    TypedMiddleware<AppState, UpdateWorkoutFilter>(updateFilter),
  ];
}

Middleware<AppState> _editWorkout() {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as EditWorkout;

    next(action);

    store.dispatch(UpdateCurrentRoute(WorkoutEditScreen.route));

    if (store.state.prefState.isMobile) {
      navigatorKey.currentState!.pushNamed(WorkoutEditScreen.route);
    }
  };
}

Middleware<AppState> _viewWorkout() {
  return (Store<AppState> store, dynamic dynamicAction,
      NextDispatcher next) async {
    final action = dynamicAction as ViewWorkout;

    next(action);

    store.dispatch(UpdateCurrentRoute(WorkoutViewScreen.route));

    if (store.state.prefState.isMobile) {
      navigatorKey.currentState!.pushNamed(WorkoutViewScreen.route);
    }
  };
}

Middleware<AppState> _viewWorkoutList() {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as ViewWorkoutList;

    next(action);

    if (store.state.staticState.isStale) {
      store.dispatch(RefreshData());
    }

    store.dispatch(UpdateCurrentRoute(WorkoutScreen.route));

    if (store.state.prefState.isMobile) {
      navigatorKey.currentState!.pushNamedAndRemoveUntil(
          WorkoutScreen.route, (Route<dynamic> route) => false);
    }
  };
}

Middleware<AppState> _archiveWorkout(WorkoutRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as ArchiveWorkoutsRequest;
    final prevWorkouts = action.workoutIds
        .map((id) => store.state.workoutState.map[id])
        .whereType<WorkoutEntity>()
        .toList();

    repository
        .bulkAction(
            store.state.credentials, action.workoutIds, EntityAction.archive)
        .then((List<WorkoutEntity> workouts) {
      store.dispatch(ArchiveWorkoutsSuccess(workouts));
      action.completer.complete(null);
    }).catchError((Object error) {
      print(error);
      store.dispatch(ArchiveWorkoutsFailure(prevWorkouts));
      action.completer.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _deleteWorkout(WorkoutRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as DeleteWorkoutsRequest;
    final prevWorkouts = action.workoutIds
        .map((id) => store.state.workoutState.map[id])
        .whereType<WorkoutEntity>()
        .toList();

    repository
        .bulkAction(
            store.state.credentials, action.workoutIds, EntityAction.delete)
        .then((List<WorkoutEntity> workouts) {
      store.dispatch(DeleteWorkoutsSuccess(workouts));
      action.completer.complete(null);
    }).catchError((Object error) {
      print(error);
      store.dispatch(DeleteWorkoutsFailure(prevWorkouts));
      action.completer.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _purgeWorkout(WorkoutRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as PurgeWorkoutsRequest;
    final prevWorkouts = action.workoutIds
        .map((id) => store.state.workoutState.map[id])
        .whereType<WorkoutEntity>()
        .toList();

    repository
        .bulkAction(
            store.state.credentials, action.workoutIds, EntityAction.purge)
        .then((List<WorkoutEntity> workouts) {
      store.dispatch(PurgeWorkoutsSuccess(workouts));
      action.completer.complete(null);
    }).catchError((Object error) {
      print(error);
      store.dispatch(PurgeWorkoutsFailure(prevWorkouts));
      action.completer.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _restoreWorkout(WorkoutRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as RestoreWorkoutsRequest;
    final prevWorkouts = action.workoutIds
        .map((id) => store.state.workoutState.map[id])
        .whereType<WorkoutEntity>()
        .toList();

    repository
        .bulkAction(
            store.state.credentials, action.workoutIds, EntityAction.restore)
        .then((List<WorkoutEntity> workouts) {
      store.dispatch(RestoreWorkoutsSuccess(workouts));
      action.completer.complete(null);
    }).catchError((Object error) {
      print(error);
      store.dispatch(RestoreWorkoutsFailure(prevWorkouts));
      action.completer.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _saveWorkout(WorkoutRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as SaveWorkoutRequest;
    repository
        .saveData(store.state.credentials, action.workout!)
        .then((WorkoutEntity workout) {
      if (action.workout!.isNew) {
        store.dispatch(AddWorkoutSuccess(workout));
      } else {
        store.dispatch(SaveWorkoutSuccess(workout));
      }

      action.completer?.complete(workout);
    }).catchError((Object error) {
      print(error);
      store.dispatch(SaveWorkoutFailure(error));
      action.completer?.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _loadWorkout(WorkoutRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as LoadWorkout;

    store.dispatch(LoadWorkoutRequest());
    repository
        .loadItem(store.state.credentials, action.workoutId!)
        .then((workout) {
      store.dispatch(LoadWorkoutSuccess(workout));
      action.completer?.complete(null);
    }).catchError((Object error) {
      print(error);
      store.dispatch(LoadWorkoutFailure(error));
      action.completer?.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _loadWorkouts(WorkoutRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    if (store.state.isLoading) {
      return;
    }

    final action = dynamicAction as LoadWorkouts;
    final state = store.state; // Get current state filter from listUIState
    final stateFilters = state.workoutListState.stateFilters;
    final currentFilter = action.filter ?? state.workoutState.filter;

    // Update filter with current state filter from listUIState
    final filter = currentFilter.rebuild((b) {
      if (stateFilters.isNotEmpty) {
        b.stateFilter = stateFilters.first; // Use the first state filter
      } else {
        b.stateFilter = EntityState.active; // Default to active
      }
    });
    store.dispatch(LoadWorkoutsRequest(filter: filter));

    var lastDocument = state.workoutState.lastDocument;
    if (action.isRefresh) {
      lastDocument = null;
      store.dispatch(UpdateLastDocumentAction(null));
    }

    repository
        .loadListWithPagination(
      lastDocument: lastDocument,
      limit: filter.limit,
      filter: filter,
    )
        .then((response) {
      final workouts = response['workouts'] as BuiltList<WorkoutEntity>;
      final newLastDocument = response['lastDocument'] as DocumentSnapshot?;
      store.dispatch(LoadWorkoutsSuccess(workouts,action.isRefresh));
      if (workouts.isNotEmpty) {
        store.dispatch(UpdateLastDocumentAction(newLastDocument));
      }
      action.completer?.complete(null);
    }).catchError((Object error) {
      print(error);
      store.dispatch(LoadWorkoutsFailure(error));
      action.completer?.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _updateFilter(WorkoutRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as UpdateWorkoutFilter;

    next(action);

    store.dispatch(LoadWorkouts(
      filter: action.filter,
      isRefresh: true,
    ));
  };
}
