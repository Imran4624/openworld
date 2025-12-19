import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/ui/app/presenters/entity_presenter.dart';

class WorkoutPresenter extends EntityPresenter {
  static List<String> getDefaultTableFields(UserCompanyEntity userCompany) {
    return [
      // STARTER: constant fields - do not remove comment
      WorkoutFields.type,

      WorkoutFields.startTime,

      WorkoutFields.endTime,

      WorkoutFields.duration,

      WorkoutFields.distance,

      WorkoutFields.averagePace,

      WorkoutFields.caloriesBurned,

      WorkoutFields.elevationGain,
    ];
  }

  static List<String> getAllTableFields(UserCompanyEntity userCompany) {
    return [
      ...getDefaultTableFields(userCompany),
      ...EntityPresenter.getBaseFields(),
    ];
  }

  @override
  Widget getField({String? field, required BuildContext context}) {
    // final state = StoreProvider.of<AppState>(context).state;
    final workout = entity as WorkoutEntity;

    switch (field) {
      // STARTER: switch case - do not remove comment
      case WorkoutFields.type:
        return Text(workout.type);
      case WorkoutFields.startTime:
        return Text(workout.startTime.toString());
      case WorkoutFields.endTime:
        return Text(workout.endTime.toString());
      case WorkoutFields.duration:
        return Text(workout.duration.toString());
      case WorkoutFields.distance:
        return Text(workout.distance.toString());
      case WorkoutFields.averagePace:
        return Text(workout.averagePace.toString());
      case WorkoutFields.caloriesBurned:
        return Text(workout.caloriesBurned.toString());
      case WorkoutFields.elevationGain:
        return Text(workout.elevationGain.toString());
    }

    return super.getField(field: field, context: context);
  }
}
