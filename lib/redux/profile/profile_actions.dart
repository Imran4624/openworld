import 'dart:async';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_boilerplate/config/entity_state_config.dart';
import 'package:flutter_boilerplate/data/models/event_model_helper.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/utils/completers.dart';
import 'package:flutter_boilerplate/utils/localization.dart';
import 'package:flutter_boilerplate/ui/app/entities/entity_actions_dialog.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';

class ViewProfileList implements PersistUI {
  ViewProfileList({this.force = false, this.page = 0});

  final bool force;
  final int page;

  @override
  String toString() {
    return 'ViewProfileList';
  }
}

class ViewProfile implements PersistUI, PersistPrefs {
  ViewProfile({
    this.profileId,
    this.force = false,
  });

  final String? profileId;
  final bool force;

  @override
  String toString() {
    return 'ViewProfile';
  }
}

class EditProfile implements PersistUI, PersistPrefs {
  EditProfile({
    required this.profile,
    this.completer,
    this.force = false,
  });

  final ProfileEntity profile;
  final Completer? completer;
  final bool force;

  @override
  String toString() {
    return 'EditProfile';
  }
}

class UpdateProfile implements PersistUI {
  UpdateProfile(this.profile);

  final ProfileEntity profile;

  @override
  String toString() {
    return 'UpdateProfile';
  }
}

class SetLoggedInUserProfile implements PersistUI, UpdateProfileState {
  SetLoggedInUserProfile(this.profile);

  final ProfileEntity profile;

  @override
  String toString() {
    return 'SetLoggedInUserProfile';
  }
}

class LoadProfile {
  LoadProfile({this.completer, this.profileId});

  final Completer? completer;
  final String? profileId;

  @override
  String toString() {
    return 'LoadProfile';
  }
}

class LoadProfileActivity {
  LoadProfileActivity({this.completer, this.profileId});

  final Completer? completer;
  final String? profileId;

  @override
  String toString() {
    return 'LoadProfileActivity';
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

class LoadProfileRequest implements StartLoading {
  @override
  String toString() {
    return 'LoadProfileRequest';
  }
}

class LoadProfileFailure implements StopLoading {
  LoadProfileFailure(this.error);

  final dynamic error;

  @override
  String toString() {
    return 'LoadProfileFailure{error: $error}';
  }
}

class LoadProfileSuccess
    implements StopLoading, PersistData, UpdateProfileState {
  LoadProfileSuccess(this.profile);

  final ProfileEntity profile;

  @override
  String toString() {
    return 'LoadProfileSuccess';
  }
}

// class LoadProfilesRequest implements StartLoading {}

class LoadProfilesFailure implements StopLoading {
  LoadProfilesFailure(this.error);

  final dynamic error;

  @override
  String toString() {
    return 'LoadProfilesFailure{error: $error}';
  }
}

class LoadProfilesSuccess implements StopLoading {
  LoadProfilesSuccess(this.profiles, this.isRefresh);

  final BuiltList<ProfileEntity> profiles;
  final bool isRefresh;

  @override
  String toString() {
    return 'LoadProfilesSuccess{profiles: $profiles}';
  }
}

class SaveProfileRequest implements StartSaving {
  SaveProfileRequest({this.completer, this.profile});

  final Completer? completer;
  final ProfileEntity? profile;

  @override
  String toString() {
    return 'SaveProfileRequest';
  }
}

class SaveProfileSuccess
    implements StopSaving, PersistData, PersistUI, UpdateProfileState {
  SaveProfileSuccess(this.profile);

  final ProfileEntity profile;

  @override
  String toString() {
    return 'SaveProfileSuccess';
  }
}

class AddProfileSuccess
    implements StopSaving, PersistData, PersistUI, UpdateProfileState {
  AddProfileSuccess(this.profile);

  final ProfileEntity profile;

  @override
  String toString() {
    return 'AddProfileSuccess';
  }
}

class SaveProfileFailure implements StopSaving {
  SaveProfileFailure(this.error);

  final Object error;

  @override
  String toString() {
    return 'SaveProfileFailure{error: $error}';
  }
}

class ArchiveProfilesRequest implements StartSaving {
  ArchiveProfilesRequest(this.completer, this.profileIds);

  final Completer completer;
  final List<String> profileIds;

  @override
  String toString() {
    return 'ArchiveProfilesRequest';
  }
}

class ArchiveProfilesSuccess
    implements StopSaving, PersistData, UpdateProfileState {
  ArchiveProfilesSuccess(this.profiles);

  final List<ProfileEntity> profiles;

  @override
  String toString() {
    return 'ArchiveProfilesSuccess';
  }
}

class ArchiveProfilesFailure implements StopSaving {
  ArchiveProfilesFailure(this.profiles);

  final List<ProfileEntity> profiles;

  @override
  String toString() {
    return 'ArchiveProfilesFailure{profiles: $profiles}';
  }
}

class DeleteProfilesRequest implements StartSaving {
  DeleteProfilesRequest(this.completer, this.profileIds);

  final Completer completer;
  final List<String> profileIds;

  @override
  String toString() {
    return 'DeleteProfilesRequest';
  }
}

class PurgeProfilesRequest implements StartLoading {
  PurgeProfilesRequest(this.completer, this.profileIds, this.isMyProfile);

  final Completer completer;
  final List<String> profileIds;
  final bool isMyProfile;

  @override
  String toString() {
    return 'PurgeProfilesRequest';
  }
}

class DeleteProfilesSuccess
    implements StopSaving, PersistData, UpdateProfileState {
  DeleteProfilesSuccess(this.profiles);

  final List<ProfileEntity> profiles;

  @override
  String toString() {
    return 'DeleteProfilesSuccess';
  }
}

class PurgeProfilesSuccess implements StopLoading, PersistData {
  PurgeProfilesSuccess(this.profiles);

  final List<ProfileEntity> profiles;

  @override
  String toString() {
    return 'PurgeProfilesSuccess';
  }
}

class DeleteProfilesFailure implements StopSaving {
  DeleteProfilesFailure(this.profiles);

  final List<ProfileEntity> profiles;

  @override
  String toString() {
    return 'DeleteProfilesFailure{profiles: $profiles}';
  }
}

class PurgeProfilesFailure implements StopSaving {
  PurgeProfilesFailure(this.profiles);

  final List<ProfileEntity> profiles;

  @override
  String toString() {
    return 'PurgeProfilesFailure{profiles: $profiles}';
  }
}

class RestoreProfilesRequest implements StartSaving {
  RestoreProfilesRequest(this.completer, this.profileIds, this.sendEmailTo);

  final Completer completer;
  final List<String> profileIds;
  final String sendEmailTo;

  @override
  String toString() {
    return 'RestoreProfilesRequest';
  }
}

class RestoreProfilesSuccess
    implements StopSaving, PersistData, UpdateProfileState {
  RestoreProfilesSuccess(this.profiles);

  final List<ProfileEntity> profiles;

  @override
  String toString() {
    return 'RestoreProfilesSuccess';
  }
}

class RestoreProfilesFailure implements StopSaving {
  RestoreProfilesFailure(this.profiles);

  final List<ProfileEntity> profiles;

  @override
  String toString() {
    return 'RestoreProfilesFailure{profiles: $profiles}';
  }
}

class FilterProfiles implements PersistUI {
  FilterProfiles(this.filter);

  final String filter;

  @override
  String toString() {
    return 'FilterProfiles';
  }
}

class SortProfiles implements PersistUI, PersistPrefs {
  SortProfiles(this.field);

  final String field;

  @override
  String toString() {
    return 'SortProfiles';
  }
}

class FilterProfilesByState implements PersistUI {
  FilterProfilesByState(this.state);

  final EntityState state;

  @override
  String toString() {
    return 'FilterProfilesByState';
  }
}

class LoadSingleProfileRequest {
  LoadSingleProfileRequest({
    this.completer,
    this.filter,
    this.lastDocument,
    this.insertIndex,
  });

  final Completer? completer;
  final ProfileFilter? filter;
  final DocumentSnapshot? lastDocument;
  final int? insertIndex;

  @override
  String toString() {
    return 'LoadSingleProfileRequest';
  }
}

class LoadSingleProfileSuccess {
  LoadSingleProfileSuccess({
    required this.profile,
    this.lastDocument,
    this.insertIndex,
  });

  final ProfileEntity profile;
  final DocumentSnapshot? lastDocument;
  final int? insertIndex;

  @override
  String toString() {
    return 'LoadSingleProfileSuccess';
  }
}

class FetchAttendeeProfilesRequest {
  final List<BuyerDetails> attendees;
  final Completer<void>? completer;

  FetchAttendeeProfilesRequest({
    required this.attendees,
    this.completer,
  });

  @override
  String toString() {
    return 'FetchAttendeeProfilesRequest';
  }
}

class FetchAttendeeProfilesSuccess {
  final Map<String, String> attendeeProfileMap;
  final List<ProfileEntity> matchedProfiles;

  FetchAttendeeProfilesSuccess({
    required this.attendeeProfileMap,
    required this.matchedProfiles,
  });

  @override
  String toString() {
    return 'FetchAttendeeProfilesSuccess';
  }
}

class FetchAttendeeProfilesFailure {
  final Object error;

  FetchAttendeeProfilesFailure(this.error);

  @override
  String toString() {
    return 'FetchAttendeeProfilesFailure{error: $error}';
  }
}

class ShowAttendeeWithoutProfileDialog {
  final BuyerDetails attendee;

  ShowAttendeeWithoutProfileDialog(this.attendee);

  @override
  String toString() {
    return 'ShowAttendeeWithoutProfileDialog';
  }
}

// class FilterProfilesByCustom1 implements PersistUI {
//   FilterProfilesByCustom1(this.value);

//   final String value;
// }

// class FilterProfilesByCustom2 implements PersistUI {
//   FilterProfilesByCustom2(this.value);

//   final String value;
// }

// class FilterProfilesByCustom3 implements PersistUI {
//   FilterProfilesByCustom3(this.value);

//   final String value;
// }

// class FilterProfilesByCustom4 implements PersistUI {
//   FilterProfilesByCustom4(this.value);

//   final String value;
// }

class StartProfileMultiselect {
  StartProfileMultiselect();

  @override
  String toString() {
    return 'StartProfileMultiselect';
  }
}

class AddToProfileMultiselect {
  AddToProfileMultiselect({required this.entity});

  final BaseEntity entity;

  @override
  String toString() {
    return 'AddToProfileMultiselect';
  }
}

class RemoveFromProfileMultiselect {
  RemoveFromProfileMultiselect({required this.entity});

  final BaseEntity entity;

  @override
  String toString() {
    return 'RemoveFromProfileMultiselect';
  }
}

class ClearProfileMultiselect {
  ClearProfileMultiselect();

  @override
  String toString() {
    return 'ClearProfileMultiselect';
  }
}

class UpdateProfileTab implements PersistUI {
  UpdateProfileTab({this.tabIndex});

  final int? tabIndex;

  @override
  String toString() {
    return 'UpdateProfileTab';
  }
}

class UpdateProfileFilter implements PersistUI {
  UpdateProfileFilter(this.filter);
  final ProfileFilter filter;

  @override
  String toString() {
    return 'UpdateProfileFilter';
  }
}

class LoadProfiles {
  LoadProfiles({
    this.completer,
    this.filter,
    this.page = 0,
    this.isRefresh = false,
  });

  final Completer? completer;
  final ProfileFilter? filter;
  final int page;
  final bool isRefresh;

  @override
  String toString() {
    return 'LoadProfiles';
  }
}

class LoadProfilesRequest implements StartLoading {
  LoadProfilesRequest({this.filter});
  final ProfileFilter? filter;

  @override
  String toString() {
    return 'LoadProfilesRequest';
  }
}

void handleProfileAction(
    BuildContext context, List<BaseEntity> profiles, EntityAction action) {
  if (profiles.isEmpty) {
    return;
  }

  final store = StoreProvider.of<AppState>(context);
  final localization = AppLocalization.of(context)!;
  final profile = profiles.first as ProfileEntity;
  final profileIds = profiles.map((profile) => profile.id).toList();

  switch (action) {
    case EntityAction.edit:
      editEntity(entity: profile);
      break;
    case EntityAction.restore:
      store.dispatch(RestoreProfilesRequest(
          snackBarCompleter<Null>(EntityStateManager.getRestoreSuccessMessage(
              EntityType.profile, profile)),
          profileIds,
          profile.email));
      break;
    case EntityAction.archive:
      store.dispatch(ArchiveProfilesRequest(
          snackBarCompleter<Null>(EntityStateManager.getArchiveSuccessMessage(
              EntityType.profile, profile)),
          profileIds));
      break;
    case EntityAction.delete:
      store.dispatch(DeleteProfilesRequest(
          snackBarCompleter<Null>(EntityStateManager.getDeleteSuccessMessage(
              EntityType.profile, profile)),
          profileIds));
      break;
    case EntityAction.purge:
      store.dispatch(PurgeProfilesRequest(
          snackBarCompleter<Null>(localization.deletedProfile),
          profileIds,
          false));
      break;
    case EntityAction.toggleMultiselect:
      if (!store.state.profileListState.isInMultiselect()) {
        store.dispatch(StartProfileMultiselect());
      }

      if (profiles.isEmpty) {
        break;
      }

      for (final profile in profiles) {
        if (!store.state.profileListState.isSelected(profile.id)) {
          store.dispatch(AddToProfileMultiselect(entity: profile));
        } else {
          store.dispatch(RemoveFromProfileMultiselect(entity: profile));
        }
      }
      break;
    case EntityAction.more:
      showEntityActionsDialog(
        entities: [profile],
      );
      break;
    default:
      logError('unhandled action $action in profile_actions');
      break;
  }
}

// Company Assignment Actions
class AddCompanyToCurrentUser {
  final String email;
  final UserCompany company;
  final Completer? completer;

  AddCompanyToCurrentUser({
    required this.email,
    required this.company,
    this.completer,
  });

  @override
  String toString() {
    return 'AddCompanyToCurrentUser{email: $email, company: ${company.companyName}}';
  }
}

class AddCompanyToUserSuccess {
  final String userId;
  final UserCompany company;

  AddCompanyToUserSuccess({
    required this.userId,
    required this.company,
  });

  @override
  String toString() {
    return 'AddCompanyToUserSuccess{userId: $userId, company: ${company.companyName}}';
  }
}

class AddCompanyToUserFailure {
  final Object error;

  AddCompanyToUserFailure(this.error);

  @override
  String toString() {
    return 'AddCompanyToUserFailure{error: $error}';
  }
}

class AddCompaniesToAttendees {
  final List<BuyerDetails> attendees;
  final UserCompany company;
  final Completer? completer;

  AddCompaniesToAttendees({
    required this.attendees,
    required this.company,
    this.completer,
  });

  @override
  String toString() {
    return 'AddCompaniesToAttendees{attendees: ${attendees.length}, company: ${company.companyName}}';
  }
}
