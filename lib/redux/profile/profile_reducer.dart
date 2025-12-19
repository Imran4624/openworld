import 'package:flutter_boilerplate/project_config.dart';
import 'package:flutter_boilerplate/redux/auth/auth_actions.dart';
import 'package:flutter_boilerplate/redux/profile_operation/profile_operation_actions.dart'
    hide UpdateLastDocumentAction;
import 'package:redux/redux.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/company/company_actions.dart';
import 'package:flutter_boilerplate/redux/ui/entity_ui_state.dart';
import 'package:flutter_boilerplate/redux/profile/profile_actions.dart';
import 'package:flutter_boilerplate/redux/ui/list_ui_state.dart';
import 'package:flutter_boilerplate/redux/profile/profile_state.dart';

EntityUIState profileUIReducer(ProfileUIState state, dynamic action) {
  return state.rebuild((b) => b
    ..listUIState.replace(profileListReducer(state.listUIState, action))
    ..editing.replace(editingReducer(state.editing, action)!)
    ..selectedId = selectedIdReducer(state.selectedId, action)
    ..forceSelected = forceSelectedReducer(state.forceSelected, action)
    ..tabIndex = tabIndexReducer(state.tabIndex, action));
}

final forceSelectedReducer = combineReducers<bool?>([
  TypedReducer<bool?, ViewProfile>((completer, action) => true),
  TypedReducer<bool?, ViewProfileList>((completer, action) => false),
  TypedReducer<bool?, FilterProfilesByState>((completer, action) => false),
  TypedReducer<bool?, FilterProfiles>((completer, action) => false),
]);

final tabIndexReducer = combineReducers<int?>([
  TypedReducer<int?, UpdateProfileTab>((completer, action) => action.tabIndex),
  TypedReducer<int?, PreviewEntity>((completer, action) => 0),
]);

Reducer<String?> selectedIdReducer = combineReducers([
  TypedReducer<String?, ArchiveProfilesSuccess>((completer, action) => ''),
  TypedReducer<String?, DeleteProfilesSuccess>((completer, action) => ''),
  TypedReducer<String?, PurgeProfilesSuccess>((completer, action) => ''),
  TypedReducer<String?, PreviewEntity>((selectedId, action) =>
      action.entityType == EntityType.profile ? action.entityId : selectedId),
  TypedReducer<String?, ViewProfile>(
      (String? selectedId, dynamic action) => action.profileId),
  TypedReducer<String?, AddProfileSuccess>(
      (String? selectedId, dynamic action) => action.profile.id),
  TypedReducer<String?, SelectCompany>(
      (selectedId, action) => action.clearSelection ? '' : selectedId),
  TypedReducer<String?, ClearEntityFilter>((selectedId, action) => ''),
  TypedReducer<String?, SortProfiles>((selectedId, action) => ''),
  TypedReducer<String?, FilterProfiles>((selectedId, action) => ''),
  TypedReducer<String?, FilterProfilesByState>((selectedId, action) => ''),
  TypedReducer<String?, FilterByEntity>(
      (selectedId, action) => action.clearSelection
          ? ''
          : action.entityType == EntityType.profile
              ? action.entityId
              : selectedId),
]);

final editingReducer = combineReducers<ProfileEntity?>([
  TypedReducer<ProfileEntity?, SaveProfileSuccess>(_updateEditing),
  TypedReducer<ProfileEntity?, AddProfileSuccess>(_updateEditing),
  TypedReducer<ProfileEntity?, RestoreProfilesSuccess>((profiles, action) {
    return action.profiles[0];
  }),
  TypedReducer<ProfileEntity?, ArchiveProfilesSuccess>((profiles, action) {
    return action.profiles[0];
  }),
  TypedReducer<ProfileEntity?, DeleteProfilesSuccess>((profiles, action) {
    return action.profiles[0];
  }),
  TypedReducer<ProfileEntity?, PurgeProfilesSuccess>((profiles, action) {
    return action.profiles[0];
  }),
  TypedReducer<ProfileEntity?, EditProfile>(_updateEditing),
  TypedReducer<ProfileEntity?, UpdateProfile>((profile, action) {
    return action.profile.rebuild((b) => b..isChanged = true);
  }),
  TypedReducer<ProfileEntity?, DiscardChanges>(_clearEditing),
]);

ProfileEntity _clearEditing(ProfileEntity? profile, dynamic action) {
  return ProfileEntity();
}

ProfileEntity? _updateEditing(ProfileEntity? profile, dynamic action) {
  return action.profile;
}

final profileListReducer = combineReducers<ListUIState>([
  TypedReducer<ListUIState, SortProfiles>(_sortProfiles),
  TypedReducer<ListUIState, FilterProfilesByState>(_filterProfilesByState),
  TypedReducer<ListUIState, FilterProfiles>(_filterProfiles),
  TypedReducer<ListUIState, StartProfileMultiselect>(_startListMultiselect),
  TypedReducer<ListUIState, AddToProfileMultiselect>(_addToListMultiselect),
  TypedReducer<ListUIState, RemoveFromProfileMultiselect>(
      _removeFromListMultiselect),
  TypedReducer<ListUIState, ClearProfileMultiselect>(_clearListMultiselect),
  TypedReducer<ListUIState, ViewProfileList>(_viewProfileList),
  TypedReducer<ListUIState, FilterByEntity>((state, action) => state.rebuild(
        (b) => b
          ..filter = null
          ..filterClearedAt = DateTime.now().millisecondsSinceEpoch,
      )),
]);

ListUIState _viewProfileList(
    ListUIState profileListState, ViewProfileList action) {
  return profileListState.rebuild((b) => b
    ..selectedIds = null
    ..filter = null
    ..filterClearedAt = DateTime.now().millisecondsSinceEpoch);
}

ListUIState _filterProfilesByState(
    ListUIState profileListState, FilterProfilesByState action) {
  if (profileListState.stateFilters.contains(action.state)) {
    return profileListState.rebuild((b) => b
      ..stateFilters.clear()
      ..stateFilters.add(EntityState.active));
  } else {
    return profileListState.rebuild((b) => b
      ..stateFilters.clear()
      ..stateFilters.add(action.state));
  }
}

ListUIState _filterProfiles(
    ListUIState profileListState, FilterProfiles action) {
  return profileListState.rebuild((b) => b
    ..filter = action.filter
    ..filterClearedAt = action.filter.isEmpty
        ? DateTime.now().millisecondsSinceEpoch
        : profileListState.filterClearedAt);
}

ListUIState _sortProfiles(ListUIState profileListState, SortProfiles action) {
  return profileListState.rebuild((b) => b
    ..sortAscending = b.sortField != action.field || !b.sortAscending!
    ..sortField = action.field);
}

ListUIState _startListMultiselect(
    ListUIState productListState, StartProfileMultiselect action) {
  return productListState.rebuild((b) => b..selectedIds = ListBuilder());
}

ListUIState _addToListMultiselect(
    ListUIState productListState, AddToProfileMultiselect action) {
  return productListState.rebuild((b) => b..selectedIds.add(action.entity.id));
}

ListUIState _removeFromListMultiselect(
    ListUIState productListState, RemoveFromProfileMultiselect action) {
  return productListState
      .rebuild((b) => b..selectedIds.remove(action.entity.id));
}

ListUIState _clearListMultiselect(
    ListUIState productListState, ClearProfileMultiselect action) {
  return productListState.rebuild((b) => b..selectedIds = null);
}

final profilesReducer = combineReducers<ProfileState>([
  TypedReducer<ProfileState, SaveProfileSuccess>(_updateProfile),
  TypedReducer<ProfileState, AddProfileSuccess>(_addProfile),
  TypedReducer<ProfileState, LoadProfilesSuccess>(_setLoadedProfiles),
  TypedReducer<ProfileState, LoadProfileSuccess>(_setLoadedProfile),
  TypedReducer<ProfileState, UpdateLastDocumentAction>(_updateLastDocument),
  TypedReducer<ProfileState, UpdateProfileFilter>(_updateProfileFilter),
  TypedReducer<ProfileState, SetLoggedInUserProfile>(
      _updateLoggedInUserProfile),
  TypedReducer<ProfileState, AddCompanySuccess>(_addCompanyToUserProfile),
  TypedReducer<ProfileState, SaveCompanySuccess>(_updateCompanyInUserProfile),
  // TypedReducer<ProfileState, LoadCompanySuccess>(_setLoadedCompany), //uncomment this if you its dependant on selected company
  TypedReducer<ProfileState, ArchiveProfilesSuccess>(_archiveProfileSuccess),
  TypedReducer<ProfileState, DeleteProfilesSuccess>(_deleteProfileSuccess),
  TypedReducer<ProfileState, PurgeProfilesSuccess>(_purgeProfileSuccess),
  TypedReducer<ProfileState, RestoreProfilesSuccess>(_restoreProfileSuccess),
  TypedReducer<ProfileState, UpdateProfileCompletionStatusSuccess>(
      _updateProfileCompletionStatusSuccess),
  TypedReducer<ProfileState, LikeProfileSuccess>(_handleLikeSuccess),
  TypedReducer<ProfileState, AcceptMatchSuccess>(_handleAcceptMatchSuccess),
  TypedReducer<ProfileState, PassProfileSuccess>(_handlePassSuccess),
  TypedReducer<ProfileState, BlockProfileSuccess>(_handleBlockSuccess),
  TypedReducer<ProfileState, LoadSingleProfileSuccess>(
      _handleLoadSingleProfileSuccess),
  TypedReducer<ProfileState, FetchAttendeeProfilesSuccess>(
      _updateAttendeeProfilesAndMap),
]);

ProfileState _archiveProfileSuccess(
    ProfileState profileState, ArchiveProfilesSuccess action) {
  final int currentTime = DateTime.now().millisecondsSinceEpoch;
  return profileState.rebuild((b) {
    for (final profile in action.profiles) {
      b.map[profile.id] = profileState.map[profile.id]!
          .rebuild((b) => b..archivedAt = currentTime);
    }
  });
}

ProfileState _updateProfileFilter(
    ProfileState profileState, UpdateProfileFilter action) {
  return profileState.rebuild((b) => b..filter = action.filter.toBuilder());
}

ProfileState _updateLoggedInUserProfile(
    ProfileState profileState, SetLoggedInUserProfile action) {
  return profileState
      .rebuild((b) => b..loggedInUserProfile = action.profile.toBuilder());
}

ProfileState _addCompanyToUserProfile(
    ProfileState profileState, AddCompanySuccess action) {
  return profileState.rebuild((b) {
    b.loggedInUserProfile.update((profileBuilder) {
      if (!profileBuilder.companyIds.build().contains(action.company.id)) {
        profileBuilder.companyIds.add(action.company.id);
      }
    });
  });
}

ProfileState _updateCompanyInUserProfile(
    ProfileState profileState, SaveCompanySuccess action) {
  return profileState.rebuild((b) {
    b.loggedInUserProfile.update((profileBuilder) {
      if (!profileBuilder.companyIds.build().contains(action.company.id)) {
        profileBuilder.companyIds.add(action.company.id);
      }
    });
  });
}

ProfileState _handleLikeSuccess(ProfileState state, LikeProfileSuccess action) {
  final targetUserId = action.profileOperation.assignedUserId;

  return state.rebuild((b) {
    b.loggedInUserProfile.update((profileBuilder) {
      profileBuilder.likesProfileMap[targetUserId!] = action.profileOperation;
    });
    if (ProjectConfig.removeProfileAfterOperationPerformed()) {
      b.list.remove(targetUserId);
      b.map.remove(targetUserId);
    }
  });
}

ProfileState _handleAcceptMatchSuccess(
    ProfileState state, AcceptMatchSuccess action) {
  final targetUserId = action.profileOperation.assignedUserId;
  final originalProfile = state.loggedInUserProfile;

  return state.rebuild((b) {
    b.loggedInUserProfile.update((profileBuilder) {
      profileBuilder.matchesProfileMap[targetUserId!] = action.profileOperation;

      final hasLikedMe =
          originalProfile.likedMeProfileMap.containsKey(targetUserId);
      if (hasLikedMe) {
        final updatedLikedMeMap = Map<String, ProfileOperationEntity>.from(
            originalProfile.likedMeProfileMap.toMap());
        updatedLikedMeMap.remove(targetUserId);

        profileBuilder.likedMeProfileMap.clear();
        profileBuilder.likedMeProfileMap.addAll(updatedLikedMeMap);
      }
    });
  });
}

ProfileState _handleLoadSingleProfileSuccess(
    ProfileState state, LoadSingleProfileSuccess action) {
  return state.rebuild((b) {
    final newProfile = action.profile;

    b.map[newProfile.id] = newProfile;
    if (action.insertIndex != null && action.insertIndex! < b.list.length) {
      b.list.insert(action.insertIndex!, newProfile.id);
    } else {
      b.list.add(newProfile.id);
    }

    if (action.lastDocument != null) {
      b.lastDocument = action.lastDocument;
    }
  });
}

ProfileState _handlePassSuccess(ProfileState state, PassProfileSuccess action) {
  final targetUserId = action.profileOperation.assignedUserId;

  return state.rebuild((b) {
    b.loggedInUserProfile.update((profileBuilder) {
      profileBuilder.passesProfileMap[targetUserId!] = action.profileOperation;
    });
    b.list.remove(targetUserId);
    b.map.remove(targetUserId);
  });
}

ProfileState _updateAttendeeProfilesAndMap(
    ProfileState state, FetchAttendeeProfilesSuccess action) {
  return state.rebuild((b) {
    b.attendeeProfileMap =
        BuiltMap<String, String>(action.attendeeProfileMap).toBuilder();

    for (final profile in action.matchedProfiles) {
      b.map[profile.id] = profile;
    }
  });
}

ProfileState _handleBlockSuccess(
    ProfileState state, BlockProfileSuccess action) {
  final targetUserId = action.profileOperation.assignedUserId;
  final originalProfile = state.loggedInUserProfile;

  return state.rebuild((b) {
    b.loggedInUserProfile.update((profileBuilder) {
      if (originalProfile.likesProfileMap.containsKey(targetUserId!)) {
        final updatedLikesMap = Map<String, ProfileOperationEntity>.from(
            originalProfile.likesProfileMap.toMap());
        updatedLikesMap.remove(targetUserId);

        profileBuilder.likesProfileMap.clear();
        profileBuilder.likesProfileMap.addAll(updatedLikesMap);
      }

      if (originalProfile.likedMeProfileMap.containsKey(targetUserId)) {
        final updatedLikedMeMap = Map<String, ProfileOperationEntity>.from(
            originalProfile.likedMeProfileMap.toMap());
        updatedLikedMeMap.remove(targetUserId);

        profileBuilder.likedMeProfileMap.clear();
        profileBuilder.likedMeProfileMap.addAll(updatedLikedMeMap);
      }

      if (originalProfile.matchesProfileMap.containsKey(targetUserId)) {
        final updatedMatchesMap = Map<String, ProfileOperationEntity>.from(
            originalProfile.matchesProfileMap.toMap());
        updatedMatchesMap.remove(targetUserId);

        profileBuilder.matchesProfileMap.clear();
        profileBuilder.matchesProfileMap.addAll(updatedMatchesMap);
      }

      if (originalProfile.passesProfileMap.containsKey(targetUserId)) {
        final updatedPassesMap = Map<String, ProfileOperationEntity>.from(
            originalProfile.passesProfileMap.toMap());
        updatedPassesMap.remove(targetUserId);

        profileBuilder.passesProfileMap.clear();
        profileBuilder.passesProfileMap.addAll(updatedPassesMap);
      }
    });
  });
}

// ProfileState _deleteProfileSuccess(ProfileState profileState, DeleteProfilesSuccess action) {
//   return profileState.rebuild((b) {
//     for (final profile in action.profiles) {
//       b.map[profile.id] = profile;
//     }
//   });
// }

ProfileState _deleteProfileSuccess(
    ProfileState profileState, DeleteProfilesSuccess action) {
  return profileState.rebuild((b) {
    for (final profile in action.profiles) {
      b.map[profile.id] =
          profileState.map[profile.id]!.rebuild((b) => b..isDeleted = true);
    }
  });
}

ProfileState _purgeProfileSuccess(
    ProfileState profileState, PurgeProfilesSuccess action) {
  return profileState.rebuild((b) {
    for (final profile in action.profiles) {
      b.map.remove(profile.id);
      b.list.remove(profile.id);
    }
  });
}

ProfileState _restoreProfileSuccess(
    ProfileState profileState, RestoreProfilesSuccess action) {
  return profileState.rebuild((b) {
    for (final profile in action.profiles) {
      b.map[profile.id] = profileState.map[profile.id]!.rebuild((b) => b
        ..isDeleted = false
        ..archivedAt = 0);
    }
  });
}

ProfileState _addProfile(ProfileState profileState, AddProfileSuccess action) {
  return profileState.rebuild((b) => b
    ..map[action.profile.id] = action.profile
    ..list.add(action.profile.id));
}

ProfileState _updateProfile(
    ProfileState profileState, SaveProfileSuccess action) {
  return profileState
      .rebuild((b) => b..map[action.profile.id] = action.profile);
}

ProfileState _updateProfileCompletionStatusSuccess(
    ProfileState profileState, UpdateProfileCompletionStatusSuccess action) {
  return profileState
      .rebuild((b) => b..loggedInUserProfile.isProfileCompleted = true);
}

ProfileState _updateLastDocument(
    ProfileState profileState, UpdateLastDocumentAction action) {
  return profileState.rebuild((b) => b..lastDocument = action.lastDocument);
}

ProfileState _setLoadedProfile(
    ProfileState profileState, LoadProfileSuccess action) {
  return profileState
      .rebuild((b) => b..map[action.profile.id] = action.profile);
}

ProfileState _setLoadedProfiles(
    ProfileState profileState, LoadProfilesSuccess action) {
  return profileState.rebuild((b) {
    if (action.isRefresh) {
      b.map.clear();
      b.list.clear();
    }
    action.profiles.forEach((profile) {
      b.map[profile.id] = profile;
      if (!b.list.build().contains(profile.id)) {
        b.list.add(profile.id);
      }
    });
  });
}

// ProfileState _setLoadedCompany(ProfileState profileState, LoadCompanySuccess action) {
//   final company = action.userCompany.company;
//   return profileState.loadProfiles(company.profiles);
// }
