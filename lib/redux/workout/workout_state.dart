import 'dart:async';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_boilerplate/redux/ui/entity_ui_state.dart';
import 'package:flutter_boilerplate/redux/ui/list_ui_state.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/ui/pref_state.dart';

part 'workout_state.g.dart';

abstract class WorkoutState
    implements Built<WorkoutState, WorkoutStateBuilder> {
  factory WorkoutState() {
    return _$WorkoutState._(
      map: BuiltMap<String, WorkoutEntity>(),
      list: BuiltList<String>(),
      lastDocument: null,
      filter: WorkoutFilter(),
    );
  }
  WorkoutState._();

  @override
  @memoized
  int get hashCode;

  BuiltMap<String, WorkoutEntity> get map;
  BuiltList<String> get list;

  DocumentSnapshot? get lastDocument;
  WorkoutFilter get filter;

  WorkoutEntity get(String workoutId) {
    return map[workoutId] ?? WorkoutEntity(id: workoutId);
  }

  WorkoutState loadWorkouts(BuiltList<WorkoutEntity> clients) {
    final map = Map<String, WorkoutEntity>.fromIterable(
      clients,
      key: (dynamic item) => item.id,
      value: (dynamic item) => item,
    );

    return rebuild((b) => b
      ..map.addAll(map)
      ..list.replace((map.keys.toList() + list.toList()).toSet().toList()));
  }

  static Serializer<WorkoutState> get serializer => _$workoutStateSerializer;
}

abstract class WorkoutUIState extends Object
    with EntityUIState
    implements Built<WorkoutUIState, WorkoutUIStateBuilder> {
  factory WorkoutUIState(PrefStateSortField? sortField) {
    return _$WorkoutUIState._(
      listUIState: ListUIState(
        // STARTER: primary field - do not remove comment
        sortField?.field ?? WorkoutFields.type,
        sortAscending: sortField?.ascending,
      ),
      editing: WorkoutEntity(),
      selectedId: '',
      tabIndex: 0,
    );
  }
  WorkoutUIState._();

  @override
  @memoized
  int get hashCode;

  WorkoutEntity? get editing;

  @override
  bool get isCreatingNew => editing?.isNew ?? false;

  @override
  String get editingId => editing?.id ?? '';

  static Serializer<WorkoutUIState> get serializer =>
      _$workoutUIStateSerializer;
}
