import 'dart:async';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_boilerplate/redux/ui/entity_ui_state.dart';
import 'package:flutter_boilerplate/redux/ui/list_ui_state.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/ui/pref_state.dart';

part 'profile_state.g.dart';

abstract class ProfileState
    implements Built<ProfileState, ProfileStateBuilder> {
  factory ProfileState() {
    return _$ProfileState._(
      map: BuiltMap<String, ProfileEntity>(),
      list: BuiltList<String>(),
      lastDocument: null,
      filter: ProfileFilter(),
      loggedInUserProfile: ProfileEntity(),
      attendeeProfileMap: BuiltMap<String, String>(),
    );
  }
  ProfileState._();

  @override
  @memoized
  int get hashCode;

  BuiltMap<String, ProfileEntity> get map;
  BuiltList<String> get list;

  DocumentSnapshot? get lastDocument;
  ProfileFilter get filter;
  ProfileEntity get loggedInUserProfile;
  BuiltMap<String, String> get attendeeProfileMap;

  ProfileEntity get(String profileId) {
    return map[profileId] ?? ProfileEntity(id: profileId);
  }

  ProfileState loadProfiles(BuiltList<ProfileEntity> clients) {
    final map = Map<String, ProfileEntity>.fromIterable(
      clients,
      key: (dynamic item) => item.id,
      value: (dynamic item) => item,
    );

    return rebuild((b) => b
      ..map.addAll(map)
      ..list.replace((map.keys.toList() + list.toList()).toSet().toList()));
  }

  static Serializer<ProfileState> get serializer => _$profileStateSerializer;
}

abstract class ProfileUIState extends Object
    with EntityUIState
    implements Built<ProfileUIState, ProfileUIStateBuilder> {
  factory ProfileUIState(PrefStateSortField? sortField) {
    return _$ProfileUIState._(
      listUIState: ListUIState(
        // STARTER: primary field - do not remove comment
        sortField?.field ?? ProfileFields.name,
        sortAscending: sortField?.ascending,
      ),
      editing: ProfileEntity(),
      selectedId: '',
      tabIndex: 0,
      dynamicFields: BuiltMap<String, dynamic>(),
    );
  }
  ProfileUIState._();

  @override
  @memoized
  int get hashCode;

  ProfileEntity? get editing;

  BuiltMap<String, dynamic> get dynamicFields;

  @override
  bool get isCreatingNew => editing?.isNew ?? false;

  @override
  String get editingId => editing?.id ?? '';

  static Serializer<ProfileUIState> get serializer =>
      _$profileUIStateSerializer;
}
