import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/redux/ui/ui_actions.dart';
import 'package:redux/redux.dart';
import 'package:flutter_boilerplate/utils/completers.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/ui/app/dialogs/error_dialog.dart';
import 'package:flutter_boilerplate/ui/workout/view/workout_view_vm.dart';
import 'package:flutter_boilerplate/redux/workout/workout_actions.dart';
import 'package:flutter_boilerplate/ui/workout/edit/workout_edit.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_boilerplate/utils/localization.dart';
import 'package:flutter_boilerplate/ui/workout/workout_screen.dart';

class WorkoutEditScreen extends StatelessWidget {
  const WorkoutEditScreen({Key? key}) : super(key: key);
  static const String route = '/workout/edit';

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, WorkoutEditVM>(
      converter: (Store<AppState> store) {
        return WorkoutEditVM.fromStore(store);
      },
      builder: (context, viewModel) {
        return WorkoutEdit(
          viewModel: viewModel,
          key: ValueKey(viewModel.workout.updatedAt),
        );
      },
    );
  }
}

class WorkoutEditVM {
  WorkoutEditVM({
    required this.state,
    required this.workout,
    this.company,
    required this.onChanged,
    required this.isSaving,
    this.origWorkout,
    required this.onSavePressed,
    required this.onCancelPressed,
    required this.isLoading,
  });

  factory WorkoutEditVM.fromStore(Store<AppState> store) {
    final state = store.state;
    final workout = state.workoutUIState.editing;

    return WorkoutEditVM(
      state: state,
      isLoading: state.isLoading,
      isSaving: state.isSaving,
      origWorkout: state.workoutState.map[workout!.id],
      workout: workout,
      company: state.company,
      onChanged: (WorkoutEntity workout) {
        store.dispatch(UpdateWorkout(workout));
      },
      onCancelPressed: (BuildContext context) {
        if (state.workoutUIState.cancelCompleter != null) {
          state.workoutUIState.cancelCompleter!.complete();
        } else {
          store.dispatch(UpdateCurrentRoute(WorkoutScreen.route));
          if (state.prefState.isMobile) {
            Navigator.of(context).pop();
          }
        }
      },
      onSavePressed: (BuildContext context) {
        Debouncer.runOnComplete(() {
          final workout = store.state.workoutUIState.editing!;
          final localization = AppLocalization.of(context)!;
          final Completer<WorkoutEntity> completer = Completer<WorkoutEntity>();
          store.dispatch(
              SaveWorkoutRequest(completer: completer, workout: workout));
          return completer.future.then((savedWorkout) {
            showToast(workout.isNew
                ? localization.createdWorkout
                : localization.updatedWorkout);
            if (state.prefState.isMobile) {
              store.dispatch(UpdateCurrentRoute(WorkoutViewScreen.route));
              if (workout.isNew) {
                Navigator.of(context)
                    .pushReplacementNamed(WorkoutViewScreen.route);
              } else {
                Navigator.of(context).pop(savedWorkout);
              }
            } else {
              viewEntity(entity: savedWorkout, force: true);
            }
          }).catchError((Object error) {
            showDialog<ErrorDialog>(
                context: context,
                builder: (BuildContext context) {
                  return ErrorDialog(error);
                });
          });
        });
      },
    );
  }

  final WorkoutEntity workout;
  final CompanyEntity? company;
  final Function(WorkoutEntity) onChanged;
  final Function(BuildContext) onSavePressed;
  final Function(BuildContext) onCancelPressed;
  final bool isLoading;
  final bool isSaving;
  final WorkoutEntity? origWorkout;
  final AppState state;
}
