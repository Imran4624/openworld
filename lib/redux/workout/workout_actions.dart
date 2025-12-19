import 'dart:async';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/utils/completers.dart';
import 'package:flutter_boilerplate/utils/localization.dart';
import 'package:flutter_boilerplate/ui/app/entities/entity_actions_dialog.dart';

class ViewWorkoutList implements PersistUI {
  ViewWorkoutList({this.force = false, this.page = 0});

  final bool force;
  final int page;

  @override
  String toString() {
    return 'ViewWorkoutList';
  }
}

class ViewWorkout implements PersistUI, PersistPrefs {
  ViewWorkout({
    this.workoutId,
    this.force = false,
  });

  final String? workoutId;
  final bool force;

  @override
  String toString() {
    return 'ViewWorkout';
  }
}

class EditWorkout implements PersistUI, PersistPrefs {
  EditWorkout({
    required this.workout,
    this.completer,
    this.force = false,
  });

  final WorkoutEntity workout;
  final Completer? completer;
  final bool force;

  @override
  String toString() {
    return 'EditWorkout';
  }
}

class UpdateWorkout implements PersistUI {
  UpdateWorkout(this.workout);

  final WorkoutEntity workout;

  @override
  String toString() {
    return 'UpdateWorkout';
  }
}

class LoadWorkout {
  LoadWorkout({this.completer, this.workoutId});

  final Completer? completer;
  final String? workoutId;

  @override
  String toString() {
    return 'LoadWorkout';
  }
}

class LoadWorkoutActivity {
  LoadWorkoutActivity({this.completer, this.workoutId});

  final Completer? completer;
  final String? workoutId;

  @override
  String toString() {
    return 'LoadWorkoutActivity';
  }
}

class UpdateLastDocumentAction {
  UpdateLastDocumentAction(this.lastDocument);
  final DocumentSnapshot? lastDocument;

  @override
  String toString() {
    return 'UpdateLastDocumentAction';
  }
}

class LoadWorkoutRequest implements StartLoading {
  @override
  String toString() {
    return 'LoadWorkoutRequest';
  }
}

class LoadWorkoutFailure implements StopLoading {
  LoadWorkoutFailure(this.error);

  final dynamic error;

  @override
  String toString() {
    return 'LoadWorkoutFailure{error: $error}';
  }
}

class LoadWorkoutSuccess implements StopLoading, PersistData {
  LoadWorkoutSuccess(this.workout);

  final WorkoutEntity workout;

  @override
  String toString() {
    return 'LoadWorkoutSuccess';
  }
}

// class LoadWorkoutsRequest implements StartLoading {}

class LoadWorkoutsFailure implements StopLoading {
  LoadWorkoutsFailure(this.error);

  final dynamic error;

  @override
  String toString() {
    return 'LoadWorkoutsFailure{error: $error}';
  }
}

class LoadWorkoutsSuccess implements StopLoading {
  LoadWorkoutsSuccess(this.workouts, this.isRefresh);

  final BuiltList<WorkoutEntity> workouts;
  final bool isRefresh;

  @override
  String toString() {
    return 'LoadWorkoutsSuccess';
  }
}

class SaveWorkoutRequest implements StartSaving {
  SaveWorkoutRequest({this.completer, this.workout});

  final Completer? completer;
  final WorkoutEntity? workout;

  @override
  String toString() {
    return 'SaveWorkoutRequest';
  }
}

class SaveWorkoutSuccess implements StopSaving, PersistData, PersistUI {
  SaveWorkoutSuccess(this.workout);

  final WorkoutEntity workout;

  @override
  String toString() {
    return 'SaveWorkoutSuccess';
  }
}

class AddWorkoutSuccess implements StopSaving, PersistData, PersistUI {
  AddWorkoutSuccess(this.workout);

  final WorkoutEntity workout;

  @override
  String toString() {
    return 'AddWorkoutSuccess';
  }
}

class SaveWorkoutFailure implements StopSaving {
  SaveWorkoutFailure(this.error);

  final Object error;

  @override
  String toString() {
    return 'SaveWorkoutFailure{error: $error}';
  }
}

class ArchiveWorkoutsRequest implements StartSaving {
  ArchiveWorkoutsRequest(this.completer, this.workoutIds);

  final Completer completer;
  final List<String> workoutIds;

  @override
  String toString() {
    return 'ArchiveWorkoutsRequest';
  }
}

class ArchiveWorkoutsSuccess implements StopSaving, PersistData {
  ArchiveWorkoutsSuccess(this.workouts);

  final List<WorkoutEntity> workouts;

  @override
  String toString() {
    return 'ArchiveWorkoutsSuccess';
  }
}

class ArchiveWorkoutsFailure implements StopSaving {
  ArchiveWorkoutsFailure(this.workouts);

  final List<WorkoutEntity> workouts;

  @override
  String toString() {
    return 'ArchiveWorkoutsFailure{workouts: $workouts}';
  }
}

class DeleteWorkoutsRequest implements StartSaving {
  DeleteWorkoutsRequest(this.completer, this.workoutIds);

  final Completer completer;
  final List<String> workoutIds;

  @override
  String toString() {
    return 'DeleteWorkoutsRequest';
  }
}

class PurgeWorkoutsRequest implements StartSaving {
  PurgeWorkoutsRequest(this.completer, this.workoutIds);

  final Completer completer;
  final List<String> workoutIds;

  @override
  String toString() {
    return 'PurgeWorkoutsRequest';
  }
}

class DeleteWorkoutsSuccess implements StopSaving, PersistData {
  DeleteWorkoutsSuccess(this.workouts);

  final List<WorkoutEntity> workouts;

  @override
  String toString() {
    return 'DeleteWorkoutsSuccess';
  }
}

class PurgeWorkoutsSuccess implements StopSaving, PersistData {
  PurgeWorkoutsSuccess(this.workouts);

  final List<WorkoutEntity> workouts;

  @override
  String toString() {
    return 'PurgeWorkoutsSuccess';
  }
}

class DeleteWorkoutsFailure implements StopSaving {
  DeleteWorkoutsFailure(this.workouts);

  final List<WorkoutEntity> workouts;

  @override
  String toString() {
    return 'DeleteWorkoutsFailure{workouts: $workouts}';
  }
}

class PurgeWorkoutsFailure implements StopSaving {
  PurgeWorkoutsFailure(this.workouts);

  final List<WorkoutEntity> workouts;

  @override
  String toString() {
    return 'PurgeWorkoutsFailure{workouts: $workouts}';
  }
}

class RestoreWorkoutsRequest implements StartSaving {
  RestoreWorkoutsRequest(this.completer, this.workoutIds);

  final Completer completer;
  final List<String> workoutIds;

  @override
  String toString() {
    return 'RestoreWorkoutsRequest';
  }
}

class RestoreWorkoutsSuccess implements StopSaving, PersistData {
  RestoreWorkoutsSuccess(this.workouts);

  final List<WorkoutEntity> workouts;

  @override
  String toString() {
    return 'RestoreWorkoutsSuccess';
  }
}

class RestoreWorkoutsFailure implements StopSaving {
  RestoreWorkoutsFailure(this.workouts);

  final List<WorkoutEntity> workouts;

  @override
  String toString() {
    return 'RestoreWorkoutsFailure{workouts: $workouts}';
  }
}

class FilterWorkouts implements PersistUI {
  FilterWorkouts(this.filter);

  final String filter;

  @override
  String toString() {
    return 'FilterWorkouts';
  }
}

class SortWorkouts implements PersistUI, PersistPrefs {
  SortWorkouts(this.field);

  final String field;

  @override
  String toString() {
    return 'SortWorkouts';
  }
}

class FilterWorkoutsByState implements PersistUI {
  FilterWorkoutsByState(this.state);

  final EntityState state;

  @override
  String toString() {
    return 'FilterWorkoutsByState';
  }
}

// class FilterWorkoutsByCustom1 implements PersistUI {
//   FilterWorkoutsByCustom1(this.value);

//   final String value;
// }

// class FilterWorkoutsByCustom2 implements PersistUI {
//   FilterWorkoutsByCustom2(this.value);

//   final String value;
// }

// class FilterWorkoutsByCustom3 implements PersistUI {
//   FilterWorkoutsByCustom3(this.value);

//   final String value;
// }

// class FilterWorkoutsByCustom4 implements PersistUI {
//   FilterWorkoutsByCustom4(this.value);

//   final String value;
// }

class StartWorkoutMultiselect {
  StartWorkoutMultiselect();

  @override
  String toString() {
    return 'StartWorkoutMultiselect';
  }
}

class AddToWorkoutMultiselect {
  AddToWorkoutMultiselect({required this.entity});

  final BaseEntity entity;

  @override
  String toString() {
    return 'AddToWorkoutMultiselect';
  }
}

class RemoveFromWorkoutMultiselect {
  RemoveFromWorkoutMultiselect({required this.entity});

  final BaseEntity entity;

  @override
  String toString() {
    return 'RemoveFromWorkoutMultiselect';
  }
}

class ClearWorkoutMultiselect {
  ClearWorkoutMultiselect();

  @override
  String toString() {
    return 'ClearWorkoutMultiselect';
  }
}

class UpdateWorkoutTab implements PersistUI {
  UpdateWorkoutTab({this.tabIndex});

  final int? tabIndex;

  @override
  String toString() {
    return 'UpdateWorkoutTab';
  }
}

class UpdateWorkoutFilter implements PersistUI {
  UpdateWorkoutFilter(this.filter);
  final WorkoutFilter filter;

  @override
  String toString() {
    return 'UpdateWorkoutFilter';
  }
}

class LoadWorkouts {
  LoadWorkouts({
    this.completer,
    this.filter,
    this.page = 0,
    this.isRefresh = false,
  });

  final Completer? completer;
  final WorkoutFilter? filter;
  final int page;
  final bool isRefresh;

  @override
  String toString() {
    return 'LoadWorkouts';
  }
}

class LoadWorkoutsRequest implements StartLoading {
  LoadWorkoutsRequest({this.filter});
  final WorkoutFilter? filter;

  @override
  String toString() {
    return 'LoadWorkoutsRequest';
  }
}

void handleWorkoutAction(
    BuildContext context, List<BaseEntity> workouts, EntityAction action) {
  if (workouts.isEmpty) {
    return;
  }

  final store = StoreProvider.of<AppState>(context);
  final localization = AppLocalization.of(context)!;
  final workout = workouts.first as WorkoutEntity;
  final workoutIds = workouts.map((workout) => workout.id).toList();

  switch (action) {
    case EntityAction.edit:
      editEntity(entity: workout);
      break;
    case EntityAction.restore:
      store.dispatch(RestoreWorkoutsRequest(
          snackBarCompleter<Null>(localization.restoredWorkout), workoutIds));
      break;
    case EntityAction.archive:
      store.dispatch(ArchiveWorkoutsRequest(
          snackBarCompleter<Null>(localization.archivedWorkout), workoutIds));
      break;
    case EntityAction.delete:
      store.dispatch(DeleteWorkoutsRequest(
          snackBarCompleter<Null>(localization.deletedWorkout), workoutIds));
      break;
    case EntityAction.purge:
      store.dispatch(PurgeWorkoutsRequest(
          snackBarCompleter<Null>(localization.deletedWorkout), workoutIds));
      break;
    case EntityAction.toggleMultiselect:
      if (!store.state.workoutListState.isInMultiselect()) {
        store.dispatch(StartWorkoutMultiselect());
      }

      if (workouts.isEmpty) {
        break;
      }

      for (final workout in workouts) {
        if (!store.state.workoutListState.isSelected(workout.id)) {
          store.dispatch(AddToWorkoutMultiselect(entity: workout));
        } else {
          store.dispatch(RemoveFromWorkoutMultiselect(entity: workout));
        }
      }
      break;
    case EntityAction.more:
      showEntityActionsDialog(
        entities: [workout],
      );
      break;
    default:
      logError('unhandled action $action in workout_actions');
      break;
  }
}
