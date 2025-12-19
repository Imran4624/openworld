import 'dart:async';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_boilerplate/redux/ui/entity_ui_state.dart';
import 'package:flutter_boilerplate/redux/ui/list_ui_state.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/ui/pref_state.dart';

part 'profile_operation_state.g.dart';

class ProfileOperationTab {
  static const String likes = 'I Liked';
  static const String likedMe = 'Liked Me';
  static const String matches = 'Matches';
  static const String passes = 'Passes';
  static const String comments = 'Comments';

  static List<String> getValues(bool canUserPassProfile) {
    final List<String> tabs = [
      likes,
      likedMe,
      matches,
    ];

    if (canUserPassProfile) {
      tabs.add(passes);
    }

    // Uncomment if you want to add comments tab later
    // tabs.add(comments);

    return tabs;
  }
}

abstract class ProfileOperationState
    implements Built<ProfileOperationState, ProfileOperationStateBuilder> {
  factory ProfileOperationState() {
    return _$ProfileOperationState._(
      map: BuiltMap<String, ProfileOperationEntity>(),
      list: BuiltList<String>(),
      lastDocumentMap: BuiltMap<String, DocumentSnapshot?>(),
      filter: ProfileOperationFilter(),
      activeTab: ProfileOperationTab.likes,
      likesProfileMap: BuiltMap<String, ProfileOperationEntity>(),
      likedMeProfileMap: BuiltMap<String, ProfileOperationEntity>(),
      matchesProfileMap: BuiltMap<String, ProfileOperationEntity>(),
      passesProfileMap: BuiltMap<String, ProfileOperationEntity>(),
      likesProfileList: BuiltList<String>(),
      likedMeProfileList: BuiltList<String>(),
      matchesProfileList: BuiltList<String>(),
      passesProfileList: BuiltList<String>(),
      isLoading: false,
    );
  }
  ProfileOperationState._();

  @override
  @memoized
  int get hashCode;

  BuiltMap<String, ProfileOperationEntity> get map;
  BuiltList<String> get list;

  BuiltMap<String, DocumentSnapshot?> get lastDocumentMap;

  DocumentSnapshot? get lastDocument => lastDocumentMap[activeTab];

  ProfileOperationFilter get filter;

  String get activeTab;

  BuiltMap<String, ProfileOperationEntity> get likesProfileMap;
  BuiltMap<String, ProfileOperationEntity> get likedMeProfileMap;
  BuiltMap<String, ProfileOperationEntity> get matchesProfileMap;
  BuiltMap<String, ProfileOperationEntity> get passesProfileMap;

  BuiltList<String> get likesProfileList;
  BuiltList<String> get likedMeProfileList;
  BuiltList<String> get matchesProfileList;
  BuiltList<String> get passesProfileList;

  bool get isLoading;

  BuiltList<String> getActiveTabProfileList() {
    switch (activeTab) {
      case ProfileOperationTab.likes:
        return likesProfileList;
      case ProfileOperationTab.likedMe:
        return likedMeProfileList;
      case ProfileOperationTab.matches:
        return matchesProfileList;
      case ProfileOperationTab.passes:
        return passesProfileList;
      default:
        return BuiltList<
            String>(); // Empty list for Comments tab or unknown tab
    }
  }

  // Helper method to get the profile map for the active tab
  BuiltMap<String, ProfileOperationEntity> getActiveTabProfileMap() {
    switch (activeTab) {
      case ProfileOperationTab.likes:
        return likesProfileMap;
      case ProfileOperationTab.likedMe:
        return likedMeProfileMap;
      case ProfileOperationTab.matches:
        return matchesProfileMap;
      case ProfileOperationTab.passes:
        return passesProfileMap;
      default:
        return BuiltMap<String,
            ProfileOperationEntity>(); // Empty map for Comments tab or unknown tab
    }
  }

  ProfileOperationEntity get(String profileOperationId) {
    return map[profileOperationId] ??
        ProfileOperationEntity(id: profileOperationId);
  }

  ProfileOperationState loadProfileOperations(
      BuiltList<ProfileOperationEntity> clients) {
    final map = Map<String, ProfileOperationEntity>.fromIterable(
      clients,
      key: (dynamic item) => item.id,
      value: (dynamic item) => item,
    );

    return rebuild((b) => b
      ..map.addAll(map)
      ..list.replace((map.keys.toList() + list.toList()).toSet().toList()));
  }

  static Serializer<ProfileOperationState> get serializer =>
      _$profileOperationStateSerializer;
}

abstract class ProfileOperationUIState extends Object
    with EntityUIState
    implements Built<ProfileOperationUIState, ProfileOperationUIStateBuilder> {
  factory ProfileOperationUIState(PrefStateSortField? sortField) {
    return _$ProfileOperationUIState._(
      listUIState: ListUIState(
        // STARTER: primary field - do not remove comment
        sortField?.field ?? ProfileOperationFields.status,
        sortAscending: sortField?.ascending,
      ),
      editing: ProfileOperationEntity(),
      selectedId: '',
      tabIndex: 0,
    );
  }
  ProfileOperationUIState._();

  @override
  @memoized
  int get hashCode;

  ProfileOperationEntity? get editing;

  @override
  bool get isCreatingNew => editing?.isNew ?? false;

  @override
  String get editingId => editing?.id ?? '';

  static Serializer<ProfileOperationUIState> get serializer =>
      _$profileOperationUIStateSerializer;
}
