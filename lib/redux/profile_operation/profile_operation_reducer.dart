import 'package:redux/redux.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/company/company_actions.dart';
import 'package:flutter_boilerplate/redux/ui/entity_ui_state.dart';
import 'package:flutter_boilerplate/redux/profile_operation/profile_operation_actions.dart';
import 'package:flutter_boilerplate/redux/ui/list_ui_state.dart';
import 'package:flutter_boilerplate/redux/profile_operation/profile_operation_state.dart';

EntityUIState profileOperationUIReducer(
    ProfileOperationUIState state, dynamic action) {
  return state.rebuild((b) => b
    ..listUIState
        .replace(profileOperationListReducer(state.listUIState, action))
    ..editing.replace(editingReducer(state.editing, action)!)
    ..selectedId = selectedIdReducer(state.selectedId, action)
    ..forceSelected = forceSelectedReducer(state.forceSelected, action)
    ..tabIndex = tabIndexReducer(state.tabIndex, action));
}

final forceSelectedReducer = combineReducers<bool?>([
  TypedReducer<bool?, ViewProfileOperation>((completer, action) => true),
  TypedReducer<bool?, ViewProfileOperationList>((completer, action) => false),
  TypedReducer<bool?, FilterProfileOperationsByState>(
      (completer, action) => false),
  TypedReducer<bool?, FilterProfileOperations>((completer, action) => false),
]);

final tabIndexReducer = combineReducers<int?>([
  TypedReducer<int?, UpdateProfileOperationTab>(
      (completer, action) => action.tabIndex),
  TypedReducer<int?, PreviewEntity>((completer, action) => 0),
]);

Reducer<String?> selectedIdReducer = combineReducers([
  TypedReducer<String?, ArchiveProfileOperationsSuccess>(
      (completer, action) => ''),
  TypedReducer<String?, DeleteProfileOperationsSuccess>(
      (completer, action) => ''),
  TypedReducer<String?, PurgeProfileOperationsSuccess>(
      (completer, action) => ''),
  TypedReducer<String?, PreviewEntity>((selectedId, action) =>
      action.entityType == EntityType.profileOperation
          ? action.entityId
          : selectedId),
  TypedReducer<String?, ViewProfileOperation>(
      (String? selectedId, dynamic action) => action.profileOperationId),
  TypedReducer<String?, AddProfileOperationSuccess>(
      (String? selectedId, dynamic action) => action.profileOperation.id),
  TypedReducer<String?, SelectCompany>(
      (selectedId, action) => action.clearSelection ? '' : selectedId),
  TypedReducer<String?, ClearEntityFilter>((selectedId, action) => ''),
  TypedReducer<String?, SortProfileOperations>((selectedId, action) => ''),
  TypedReducer<String?, FilterProfileOperations>((selectedId, action) => ''),
  TypedReducer<String?, FilterProfileOperationsByState>(
      (selectedId, action) => ''),
  TypedReducer<String?, FilterByEntity>(
      (selectedId, action) => action.clearSelection
          ? ''
          : action.entityType == EntityType.profileOperation
              ? action.entityId
              : selectedId),
]);

final editingReducer = combineReducers<ProfileOperationEntity?>([
  TypedReducer<ProfileOperationEntity?, SaveProfileOperationSuccess>(
      _updateEditing),
  TypedReducer<ProfileOperationEntity?, AddProfileOperationSuccess>(
      _updateEditing),
  TypedReducer<ProfileOperationEntity?, RestoreProfileOperationsSuccess>(
      (profileOperations, action) {
    return action.profileOperations[0];
  }),
  TypedReducer<ProfileOperationEntity?, ArchiveProfileOperationsSuccess>(
      (profileOperations, action) {
    return action.profileOperations[0];
  }),
  TypedReducer<ProfileOperationEntity?, DeleteProfileOperationsSuccess>(
      (profileOperations, action) {
    return action.profileOperations[0];
  }),
  TypedReducer<ProfileOperationEntity?, PurgeProfileOperationsSuccess>(
      (profileOperations, action) {
    return action.profileOperations[0];
  }),
  TypedReducer<ProfileOperationEntity?, EditProfileOperation>(_updateEditing),
  TypedReducer<ProfileOperationEntity?, UpdateProfileOperation>(
      (profileOperation, action) {
    return action.profileOperation.rebuild((b) => b..isChanged = true);
  }),
  TypedReducer<ProfileOperationEntity?, DiscardChanges>(_clearEditing),
]);

ProfileOperationEntity _clearEditing(
    ProfileOperationEntity? profileOperation, dynamic action) {
  return ProfileOperationEntity();
}

ProfileOperationEntity? _updateEditing(
    ProfileOperationEntity? profileOperation, dynamic action) {
  return action.profileOperation;
}

final profileOperationListReducer = combineReducers<ListUIState>([
  TypedReducer<ListUIState, SortProfileOperations>(_sortProfileOperations),
  TypedReducer<ListUIState, FilterProfileOperationsByState>(
      _filterProfileOperationsByState),
  TypedReducer<ListUIState, FilterProfileOperations>(_filterProfileOperations),
  TypedReducer<ListUIState, StartProfileOperationMultiselect>(
      _startListMultiselect),
  TypedReducer<ListUIState, AddToProfileOperationMultiselect>(
      _addToListMultiselect),
  TypedReducer<ListUIState, RemoveFromProfileOperationMultiselect>(
      _removeFromListMultiselect),
  TypedReducer<ListUIState, ClearProfileOperationMultiselect>(
      _clearListMultiselect),
  TypedReducer<ListUIState, ViewProfileOperationList>(
      _viewProfileOperationList),
  TypedReducer<ListUIState, FilterByEntity>((state, action) => state.rebuild(
        (b) => b
          ..filter = null
          ..filterClearedAt = DateTime.now().millisecondsSinceEpoch,
      )),
]);

ListUIState _viewProfileOperationList(
    ListUIState profileOperationListState, ViewProfileOperationList action) {
  return profileOperationListState.rebuild((b) => b
    ..selectedIds = null
    ..filter = null
    ..filterClearedAt = DateTime.now().millisecondsSinceEpoch);
}

ListUIState _filterProfileOperationsByState(
    ListUIState profileOperationListState,
    FilterProfileOperationsByState action) {
  if (profileOperationListState.stateFilters.contains(action.state)) {
    return profileOperationListState.rebuild((b) => b
      ..stateFilters.clear()
      ..stateFilters.add(EntityState.active));
  } else {
    return profileOperationListState.rebuild((b) => b
      ..stateFilters.clear()
      ..stateFilters.add(action.state));
  }
}

ListUIState _filterProfileOperations(
    ListUIState profileOperationListState, FilterProfileOperations action) {
  return profileOperationListState.rebuild((b) => b
    ..filter = action.filter
    ..filterClearedAt = action.filter == null
        ? DateTime.now().millisecondsSinceEpoch
        : profileOperationListState.filterClearedAt);
}

ListUIState _sortProfileOperations(
    ListUIState profileOperationListState, SortProfileOperations action) {
  return profileOperationListState.rebuild((b) => b
    ..sortAscending = b.sortField != action.field || !b.sortAscending!
    ..sortField = action.field);
}

ListUIState _startListMultiselect(
    ListUIState productListState, StartProfileOperationMultiselect action) {
  return productListState.rebuild((b) => b..selectedIds = ListBuilder());
}

ListUIState _addToListMultiselect(
    ListUIState productListState, AddToProfileOperationMultiselect action) {
  return productListState.rebuild((b) => b..selectedIds.add(action.entity.id));
}

ListUIState _removeFromListMultiselect(ListUIState productListState,
    RemoveFromProfileOperationMultiselect action) {
  return productListState
      .rebuild((b) => b..selectedIds.remove(action.entity.id));
}

ListUIState _clearListMultiselect(
    ListUIState productListState, ClearProfileOperationMultiselect action) {
  return productListState.rebuild((b) => b..selectedIds = null);
}

final profileOperationsReducer = combineReducers<ProfileOperationState>([
  TypedReducer<ProfileOperationState, SaveProfileOperationSuccess>(
      _updateProfileOperation),
  TypedReducer<ProfileOperationState, AddProfileOperationSuccess>(
      _addProfileOperation),
  TypedReducer<ProfileOperationState, LoadProfileOperationsSuccess>(
      _setLoadedProfileOperations),
  TypedReducer<ProfileOperationState, LoadProfileOperationSuccess>(
      _setLoadedProfileOperation),
  TypedReducer<ProfileOperationState, UpdateLastDocumentAction>(
      _updateLastDocument),
  TypedReducer<ProfileOperationState, UpdateProfileOperationActiveTab>(
      _updateProfileOperationActiveTab),
  TypedReducer<ProfileOperationState, UpdateProfileOperationFilter>(
      _updateProfileOperationFilter),
  TypedReducer<ProfileOperationState, ArchiveProfileOperationsSuccess>(
      _archiveProfileOperationSuccess),
  TypedReducer<ProfileOperationState, DeleteProfileOperationsSuccess>(
      _deleteProfileOperationSuccess),
  TypedReducer<ProfileOperationState, PurgeProfileOperationsSuccess>(
      _purgeProfileOperationSuccess),
  TypedReducer<ProfileOperationState, RestoreProfileOperationsSuccess>(
      _restoreProfileOperationSuccess),
  TypedReducer<ProfileOperationState, LikeProfileSuccess>(_handleLikeSuccess),
  TypedReducer<ProfileOperationState, AcceptMatchSuccess>(
      _handleAcceptMatchSuccess),
  TypedReducer<ProfileOperationState, PassProfileSuccess>(_handlePassSuccess),
  TypedReducer<ProfileOperationState, BlockProfileSuccess>(_handleBlockSuccess),
  TypedReducer<ProfileOperationState, FavoriteProfileSuccess>(
      _handleFavoriteSuccess),
  TypedReducer<ProfileOperationState, MatchProfileSuccess>(_handleMatchSuccess),
  TypedReducer<ProfileOperationState, ReportProfileSuccess>(
      _handleReportSuccess),
  // Add new reducer for loading profiles
  TypedReducer<ProfileOperationState, LoadTabProfilesSuccess>(
      _setLoadedTabProfiles),
  TypedReducer<ProfileOperationState, LoadProfileOperationsRequest>(
      _setLoadingState),
]);

ProfileOperationState _setLoadingState(
    ProfileOperationState state, LoadProfileOperationsRequest action) {
  return state.rebuild((b) => b..isLoading = true);
}

ProfileOperationState _setLoadedTabProfiles(
    ProfileOperationState state, LoadTabProfilesSuccess action) {
  final profileMap = Map<String, ProfileOperationEntity>.fromIterable(
    action.profiles,
    key: (dynamic item) => item.id,
    value: (dynamic item) => item,
  );

  final profileIds = action.profiles.map((profile) => profile.id).toList();

  return state.rebuild((b) {
    b.isLoading = false;

    switch (action.tabType) {
      case ProfileOperationTab.likes:
        if (action.isRefresh) {
          b.likesProfileMap.clear();
          b.likesProfileMap.addAll(profileMap);
          b.likesProfileList.replace(profileIds);
        } else {
          for (var entry in profileMap.entries) {
            if (!state.likesProfileMap.containsKey(entry.key)) {
              b.likesProfileMap[entry.key] = entry.value;
            }
          }

          for (var id in profileIds) {
            if (!state.likesProfileList.contains(id)) {
              b.likesProfileList.add(id);
            }
          }
        }
        break;
      case ProfileOperationTab.likedMe:
        if (action.isRefresh) {
          b.likedMeProfileMap.clear();
          b.likedMeProfileMap.addAll(profileMap);
          b.likedMeProfileList.replace(profileIds);
        } else {
          for (var entry in profileMap.entries) {
            if (!state.likedMeProfileMap.containsKey(entry.key)) {
              b.likedMeProfileMap[entry.key] = entry.value;
            }
          }

          for (var id in profileIds) {
            if (!state.likedMeProfileList.contains(id)) {
              b.likedMeProfileList.add(id);
            }
          }
        }
        break;
      case ProfileOperationTab.matches:
        if (action.isRefresh) {
          b.matchesProfileMap.clear();
          b.matchesProfileMap.addAll(profileMap);
          b.matchesProfileList.replace(profileIds);
        } else {
          for (var entry in profileMap.entries) {
            if (!state.matchesProfileMap.containsKey(entry.key)) {
              b.matchesProfileMap[entry.key] = entry.value;
            }
          }

          for (var id in profileIds) {
            if (!state.matchesProfileList.contains(id)) {
              b.matchesProfileList.add(id);
            }
          }
        }
        break;
      case ProfileOperationTab.passes:
        if (action.isRefresh) {
          b.passesProfileMap.clear();
          b.passesProfileMap.addAll(profileMap);
          b.passesProfileList.replace(profileIds);
        } else {
          for (var entry in profileMap.entries) {
            if (!state.passesProfileMap.containsKey(entry.key)) {
              b.passesProfileMap[entry.key] = entry.value;
            }
          }

          for (var id in profileIds) {
            if (!state.passesProfileList.contains(id)) {
              b.passesProfileList.add(id);
            }
          }
        }
        break;
    }
  });
}

ProfileOperationState _setLoadedProfileOperations(
    ProfileOperationState profileOperationState,
    LoadProfileOperationsSuccess action) {
  return profileOperationState.rebuild((b) {
    b.isLoading = false;

    if (action.isRefresh) {
      b.map.clear();
      b.list.clear();
    }

    for (final profileOperation in action.profileOperations) {
      // Make sure the ProfileEntity is valid
      ProfileOperationEntity operationToSave;
      if (profileOperation.profileEntity!.name.isEmpty) {
        // If the profile entity has an empty name, ensure we have a valid profile entity
        operationToSave = profileOperation.rebuild((b) => b
          ..profileEntity
              .replace(ProfileEntity().rebuild((pb) => pb..name = '')));
      } else {
        operationToSave = profileOperation;
      }

      b.map[operationToSave.id] = operationToSave;
      if (!b.list.build().contains(operationToSave.id)) {
        b.list.add(operationToSave.id);
      }
    }
  });
}

ProfileOperationState _addProfileOperation(
    ProfileOperationState profileOperationState,
    AddProfileOperationSuccess action) {
  // Make sure the ProfileEntity is valid
  ProfileOperationEntity operationToAdd = action.profileOperation;
  if (operationToAdd.profileEntity!.name == null) {
    operationToAdd = operationToAdd.rebuild((b) => b
      ..profileEntity.replace(ProfileEntity().rebuild((pb) => pb..name = '')));
  }

  return profileOperationState.rebuild((b) => b
    ..map[operationToAdd.id] = operationToAdd
    ..list.add(operationToAdd.id));
}

ProfileOperationState _updateProfileOperation(
    ProfileOperationState profileOperationState,
    SaveProfileOperationSuccess action) {
  // Make sure the ProfileEntity is valid
  ProfileOperationEntity operationToUpdate = action.profileOperation;
  if (operationToUpdate.profileEntity!.name == null) {
    operationToUpdate = operationToUpdate.rebuild((b) => b
      ..profileEntity.replace(ProfileEntity().rebuild((pb) => pb..name = '')));
  }

  return profileOperationState
      .rebuild((b) => b..map[operationToUpdate.id] = operationToUpdate);
}

ProfileOperationState _archiveProfileOperationSuccess(
    ProfileOperationState profileOperationState,
    ArchiveProfileOperationsSuccess action) {
  final int currentTime = DateTime.now().millisecondsSinceEpoch;
  return profileOperationState.rebuild((b) {
    for (final profileOperation in action.profileOperations) {
      b.map[profileOperation.id] = profileOperationState
          .map[profileOperation.id]!
          .rebuild((b) => b..archivedAt = currentTime);
    }
  });
}

ProfileOperationState _updateProfileOperationFilter(
    ProfileOperationState profileOperationState,
    UpdateProfileOperationFilter action) {
  return profileOperationState
      .rebuild((b) => b..filter = action.filter.toBuilder());
}

ProfileOperationState _deleteProfileOperationSuccess(
    ProfileOperationState profileOperationState,
    DeleteProfileOperationsSuccess action) {
  return profileOperationState.rebuild((b) {
    for (final profileOperation in action.profileOperations) {
      b.map[profileOperation.id] = profileOperationState
          .map[profileOperation.id]!
          .rebuild((b) => b..isDeleted = true);
    }
  });
}

ProfileOperationState _purgeProfileOperationSuccess(
    ProfileOperationState profileOperationState,
    PurgeProfileOperationsSuccess action) {
  return profileOperationState.rebuild((b) {
    for (final profileOperation in action.profileOperations) {
      b.map.remove(profileOperation.id);
      b.list.remove(profileOperation.id);
    }
  });
}

ProfileOperationState _restoreProfileOperationSuccess(
    ProfileOperationState profileOperationState,
    RestoreProfileOperationsSuccess action) {
  return profileOperationState.rebuild((b) {
    for (final profileOperation in action.profileOperations) {
      b.map[profileOperation.id] =
          profileOperationState.map[profileOperation.id]!.rebuild((b) => b
            ..isDeleted = false
            ..archivedAt = 0);
    }
  });
}

// ProfileOperationState _addProfileOperation(
//     ProfileOperationState profileOperationState,
//     AddProfileOperationSuccess action) {
//   return profileOperationState.rebuild((b) => b
//     ..map[action.profileOperation.id] = action.profileOperation
//     ..list.add(action.profileOperation.id));
// }

// ProfileOperationState _updateProfileOperation(
//     ProfileOperationState profileOperationState,
//     SaveProfileOperationSuccess action) {
//   return profileOperationState.rebuild(
//       (b) => b..map[action.profileOperation.id] = action.profileOperation);
// }

ProfileOperationState _updateLastDocument(
    ProfileOperationState profileOperationState,
    UpdateLastDocumentAction action) {
  return profileOperationState
      .rebuild((b) => b..lastDocumentMap[action.tabType] = action.lastDocument);
}

ProfileOperationState _updateProfileOperationActiveTab(
    ProfileOperationState profileOperationState,
    UpdateProfileOperationActiveTab action) {
  return profileOperationState.rebuild((b) => b..activeTab = action.activeTab);
}

ProfileOperationState _setLoadedProfileOperation(
    ProfileOperationState profileOperationState,
    LoadProfileOperationSuccess action) {
  return profileOperationState.rebuild(
      (b) => b..map[action.profileOperation.id] = action.profileOperation);
}

// ProfileOperationState _setLoadedProfileOperations(
//     ProfileOperationState profileOperationState,
//     LoadProfileOperationsSuccess action) {
//   return profileOperationState.rebuild((b) {
//     b.isLoading = false;

//     if (action.isRefresh) {
//       b.map.clear();
//       b.list.clear();
//     }
//     action.profileOperations.forEach((profileOperation) {
//       b.map[profileOperation.id] = profileOperation;
//       if (!b.list.build().contains(profileOperation.id)) {
//         b.list.add(profileOperation.id);
//       }
//     });
//   });
// }

ProfileOperationState _handleLikeSuccess(
    ProfileOperationState state, LikeProfileSuccess action) {
  final targetUserId = action.profileOperation.assignedUserId;

  return state.rebuild((b) {
    b.map[action.profileOperation.id] = action.profileOperation;
    b.list.add(action.profileOperation.id);

    b.likesProfileMap[targetUserId!] = action.profileOperation;
    b.likesProfileList.add(targetUserId);

    b.passesProfileList.remove(targetUserId);
    b.passesProfileMap.remove(targetUserId);
  });
}

ProfileOperationState _handleAcceptMatchSuccess(
    ProfileOperationState state, AcceptMatchSuccess action) {
  final targetUserId = action.profileOperation.assignedUserId;

  return state.rebuild((b) {
    b.map[action.profileOperation.id] = action.profileOperation;
    b.list.add(action.profileOperation.id);

    b.matchesProfileMap[targetUserId!] = action.profileOperation;
    b.matchesProfileList.add(targetUserId);
    b.likedMeProfileList.remove(targetUserId);
    b.likedMeProfileMap.remove(targetUserId);
  });
}

ProfileOperationState _handlePassSuccess(
    ProfileOperationState state, PassProfileSuccess action) {
  final targetUserId = action.profileOperation.assignedUserId;

  return state.rebuild((b) {
    b.map[action.profileOperation.id] = action.profileOperation;
    b.list.add(action.profileOperation.id);

    b.passesProfileMap[targetUserId!] = action.profileOperation;
    b.passesProfileList.add(targetUserId);
    b.likesProfileList.remove(targetUserId);
    b.likesProfileMap.remove(targetUserId);
    b.likedMeProfileList.remove(targetUserId);
    b.likedMeProfileMap.remove(targetUserId);
    b.matchesProfileList.remove(targetUserId);
    b.matchesProfileMap.remove(targetUserId);
  });
}

ProfileOperationState _handleBlockSuccess(
    ProfileOperationState state, BlockProfileSuccess action) {
  return state.rebuild((b) => b
    ..map[action.profileOperation.id] = action.profileOperation
    ..list.add(action.profileOperation.id));
}

ProfileOperationState _handleFavoriteSuccess(
    ProfileOperationState state, FavoriteProfileSuccess action) {
  return state.rebuild((b) => b
    ..map[action.profileOperation.id] = action.profileOperation
    ..list.add(action.profileOperation.id));
}

ProfileOperationState _handleMatchSuccess(
    ProfileOperationState state, MatchProfileSuccess action) {
  return state.rebuild((b) => b
    ..map[action.profileOperation.id] = action.profileOperation
    ..list.add(action.profileOperation.id));
}

ProfileOperationState _handleReportSuccess(
    ProfileOperationState state, ReportProfileSuccess action) {
  return state.rebuild((b) => b
    ..map[action.profileOperation.id] = action.profileOperation
    ..list.add(action.profileOperation.id));
}
