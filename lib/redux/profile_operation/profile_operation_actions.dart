import 'dart:async';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/utils/completers.dart';
import 'package:flutter_boilerplate/utils/localization.dart';
import 'package:flutter_boilerplate/ui/app/entities/entity_actions_dialog.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';

// region Profile Operation Request Actions
abstract class ProfileOperationRequest {
  final Completer? completer;
  final String targetUserId;

  ProfileOperationRequest({
    this.completer,
    required this.targetUserId,
  });

  @override
  String toString() {
    return 'ProfileOperationRequest';
  }
}

class LikeProfileRequest extends ProfileOperationRequest {
  final int type;

  LikeProfileRequest({
    super.completer,
    required super.targetUserId,
    this.type = LikeType.normal,
  });

  @override
  String toString() {
    return 'LikeProfileRequest';
  }
}

class AcceptMatchRequest extends ProfileOperationRequest {
  AcceptMatchRequest({
    super.completer,
    required super.targetUserId,
  });

  @override
  String toString() {
    return 'AcceptMatchRequest';
  }
}

class PassProfileRequest extends ProfileOperationRequest {
  PassProfileRequest({
    Completer? completer,
    required String targetUserId,
  }) : super(completer: completer, targetUserId: targetUserId);

  @override
  String toString() {
    return 'PassProfileRequest';
  }
}

class BlockProfileRequest extends ProfileOperationRequest {
  BlockProfileRequest({
    Completer? completer,
    required String targetUserId,
  }) : super(completer: completer, targetUserId: targetUserId);

  @override
  String toString() {
    return 'BlockProfileRequest';
  }
}

class FavoriteProfileRequest extends ProfileOperationRequest {
  FavoriteProfileRequest({
    Completer? completer,
    required String targetUserId,
  }) : super(completer: completer, targetUserId: targetUserId);

  @override
  String toString() {
    return 'FavoriteProfileRequest';
  }
}

class MatchProfileRequest extends ProfileOperationRequest {
  final int status;

  MatchProfileRequest({
    Completer? completer,
    required String targetUserId,
    this.status = MatchStatus.pending,
  }) : super(completer: completer, targetUserId: targetUserId);

  @override
  String toString() {
    return 'MatchProfileRequest';
  }
}

class ReportProfileRequest extends ProfileOperationRequest {
  final String comment;

  ReportProfileRequest({
    Completer? completer,
    required String targetUserId,
    required this.comment,
  }) : super(completer: completer, targetUserId: targetUserId);

  @override
  String toString() {
    return 'ReportProfileRequest';
  }
}
// endregion

// region Success Actions
class ProfileOperationSuccess {
  final ProfileOperationEntity profileOperation;

  ProfileOperationSuccess(this.profileOperation);

  @override
  String toString() {
    return 'ProfileOperationSuccess';
  }
}

class AcceptMatchSuccess extends ProfileOperationSuccess {
  AcceptMatchSuccess(super.profileOperation);

  @override
  String toString() {
    return 'AcceptMatchSuccess';
  }
}

class LikeProfileSuccess extends ProfileOperationSuccess {
  LikeProfileSuccess(ProfileOperationEntity profileOperation)
      : super(profileOperation);

  @override
  String toString() {
    return 'LikeProfileSuccess';
  }
}

class PassProfileSuccess extends ProfileOperationSuccess {
  PassProfileSuccess(ProfileOperationEntity profileOperation)
      : super(profileOperation);

  @override
  String toString() {
    return 'PassProfileSuccess';
  }
}

class BlockProfileSuccess extends ProfileOperationSuccess {
  BlockProfileSuccess(ProfileOperationEntity profileOperation)
      : super(profileOperation);

  @override
  String toString() {
    return 'BlockProfileSuccess';
  }
}

class FavoriteProfileSuccess extends ProfileOperationSuccess {
  FavoriteProfileSuccess(ProfileOperationEntity profileOperation)
      : super(profileOperation);

  @override
  String toString() {
    return 'FavoriteProfileSuccess';
  }
}

class MatchProfileSuccess extends ProfileOperationSuccess {
  MatchProfileSuccess(ProfileOperationEntity profileOperation)
      : super(profileOperation);

  @override
  String toString() {
    return 'MatchProfileSuccess';
  }
}

class ReportProfileSuccess extends ProfileOperationSuccess {
  ReportProfileSuccess(ProfileOperationEntity profileOperation)
      : super(profileOperation);

  @override
  String toString() {
    return 'ReportProfileSuccess';
  }
}

class LoadTabProfilesSuccess {
  final String tabType;
  final List<ProfileOperationEntity> profiles;
  final bool isRefresh;

  LoadTabProfilesSuccess({
    required this.tabType,
    required this.profiles,
    this.isRefresh = false,
  });

  @override
  String toString() {
    return 'LoadTabProfilesSuccess';
  }
}
// endregion

// region Failure Actions
class ProfileOperationFailure {
  final Object error;

  ProfileOperationFailure(this.error);

  @override
  String toString() {
    return 'ProfileOperationFailure{error: $error}';
  }
}

class AcceptMatchFailure extends ProfileOperationFailure {
  AcceptMatchFailure(super.error);
}

class LikeProfileFailure extends ProfileOperationFailure {
  LikeProfileFailure(Object error) : super(error);
}

class PassProfileFailure extends ProfileOperationFailure {
  PassProfileFailure(Object error) : super(error);
}

class BlockProfileFailure extends ProfileOperationFailure {
  BlockProfileFailure(Object error) : super(error);
}

class FavoriteProfileFailure extends ProfileOperationFailure {
  FavoriteProfileFailure(Object error) : super(error);
}

class MatchProfileFailure extends ProfileOperationFailure {
  MatchProfileFailure(Object error) : super(error);
}

class ReportProfileFailure extends ProfileOperationFailure {
  ReportProfileFailure(Object error) : super(error);
}
// endregion

// region View and Edit Actions
class ViewProfileOperationList implements PersistUI {
  ViewProfileOperationList({this.force = false, this.page = 0});

  final bool force;
  final int page;

  @override
  String toString() {
    return 'ViewProfileOperationList';
  }
}

class ViewProfileOperation implements PersistUI, PersistPrefs {
  ViewProfileOperation({
    this.profileOperationId,
    this.force = false,
  });

  final String? profileOperationId;
  final bool force;

  @override
  String toString() {
    return 'ViewProfileOperation';
  }
}

class EditProfileOperation implements PersistUI, PersistPrefs {
  EditProfileOperation({
    required this.profileOperation,
    this.completer,
    this.force = false,
  });

  final ProfileOperationEntity profileOperation;
  final Completer? completer;
  final bool force;

  @override
  String toString() {
    return 'EditProfileOperation';
  }
}

class UpdateProfileOperation implements PersistUI {
  UpdateProfileOperation(this.profileOperation);

  final ProfileOperationEntity profileOperation;

  @override
  String toString() {
    return 'UpdateProfileOperation';
  }
}
// endregion

// region Load Actions
class LoadProfileOperation {
  LoadProfileOperation({this.completer, this.profileOperationId});

  final Completer? completer;
  final String? profileOperationId;

  @override
  String toString() {
    return 'LoadProfileOperation';
  }
}

class LoadProfileOperationActivity {
  LoadProfileOperationActivity({this.completer, this.profileOperationId});

  final Completer? completer;
  final String? profileOperationId;

  @override
  String toString() {
    return 'LoadProfileOperationActivity';
  }
}

class LoadProfileOperationRequest implements StartLoading {
  @override
  String toString() {
    return 'LoadProfileOperationRequest';
  }
}

class LoadProfileOperationFailure implements StopLoading {
  LoadProfileOperationFailure(this.error);

  final dynamic error;

  @override
  String toString() {
    return 'LoadProfileOperationFailure{error: $error}';
  }
}

class LoadProfileOperationSuccess implements StopLoading, PersistData {
  LoadProfileOperationSuccess(this.profileOperation);

  final ProfileOperationEntity profileOperation;

  @override
  String toString() {
    return 'LoadProfileOperationSuccess';
  }
}

class LoadProfileOperationsFailure implements StopLoading {
  LoadProfileOperationsFailure(this.error);

  final dynamic error;

  @override
  String toString() {
    return 'LoadProfileOperationsFailure{error: $error}';
  }
}

class LoadProfileOperationsSuccess implements StopLoading {
  LoadProfileOperationsSuccess(this.profileOperations,
      {this.isRefresh = false});

  final BuiltList<ProfileOperationEntity> profileOperations;
  final bool isRefresh;

  @override
  String toString() {
    return 'LoadProfileOperationsSuccess';
  }
}

class LoadProfileOperations {
  LoadProfileOperations({
    this.completer,
    this.filter,
    this.page = 0,
    this.isRefresh = false,
    this.tabType,
  });

  final Completer? completer;
  final ProfileOperationFilter? filter;
  final int page;
  final bool isRefresh;
  final String? tabType;

  @override
  String toString() {
    return 'LoadProfileOperations';
  }
}

class LoadProfileOperationsRequest implements StartLoading {
  LoadProfileOperationsRequest({this.filter, this.tabType});
  final ProfileOperationFilter? filter;
  final String? tabType;

  @override
  String toString() {
    return 'LoadProfileOperationsRequest';
  }
}

class UpdateLastDocumentAction {
  UpdateLastDocumentAction({
    required this.lastDocument,
    required this.tabType,
  });

  final DocumentSnapshot? lastDocument;
  final String tabType;

  @override
  String toString() {
    return 'UpdateLastDocumentAction';
  }
}
// endregion

// region Save Actions
class SaveProfileOperationRequest implements StartSaving {
  SaveProfileOperationRequest({this.completer, this.profileOperation});

  final Completer? completer;
  final ProfileOperationEntity? profileOperation;

  @override
  String toString() {
    return 'SaveProfileOperationRequest';
  }
}

class SaveProfileOperationSuccess
    implements StopSaving, PersistData, PersistUI {
  SaveProfileOperationSuccess(this.profileOperation);

  final ProfileOperationEntity profileOperation;

  @override
  String toString() {
    return 'SaveProfileOperationSuccess';
  }
}

class AddProfileOperationSuccess implements StopSaving, PersistData, PersistUI {
  AddProfileOperationSuccess(this.profileOperation);

  final ProfileOperationEntity profileOperation;

  @override
  String toString() {
    return 'AddProfileOperationSuccess';
  }
}

class SaveProfileOperationFailure implements StopSaving {
  SaveProfileOperationFailure(this.error);

  final Object error;

  @override
  String toString() {
    return 'SaveProfileOperationFailure{error: $error}';
  }
}
// endregion

// region Bulk Operations
class ArchiveProfileOperationsRequest implements StartSaving {
  ArchiveProfileOperationsRequest(this.completer, this.profileOperationIds);

  final Completer completer;
  final List<String> profileOperationIds;

  @override
  String toString() {
    return 'ArchiveProfileOperationsRequest';
  }
}

class ArchiveProfileOperationsSuccess implements StopSaving, PersistData {
  ArchiveProfileOperationsSuccess(this.profileOperations);

  final List<ProfileOperationEntity> profileOperations;

  @override
  String toString() {
    return 'ArchiveProfileOperationsSuccess';
  }
}

class ArchiveProfileOperationsFailure implements StopSaving {
  ArchiveProfileOperationsFailure(this.profileOperations);

  final List<ProfileOperationEntity> profileOperations;

  @override
  String toString() {
    return 'ArchiveProfileOperationsFailure{profileOperations: $profileOperations}';
  }
}

class DeleteProfileOperationsRequest implements StartSaving {
  DeleteProfileOperationsRequest(this.completer, this.profileOperationIds);

  final Completer completer;
  final List<String> profileOperationIds;

  @override
  String toString() {
    return 'DeleteProfileOperationsRequest';
  }
}

class PurgeProfileOperationsRequest implements StartSaving {
  PurgeProfileOperationsRequest(this.completer, this.profileOperationIds);

  final Completer completer;
  final List<String> profileOperationIds;

  @override
  String toString() {
    return 'PurgeProfileOperationsRequest';
  }
}

class DeleteProfileOperationsSuccess implements StopSaving, PersistData {
  DeleteProfileOperationsSuccess(this.profileOperations);

  final List<ProfileOperationEntity> profileOperations;

  @override
  String toString() {
    return 'DeleteProfileOperationsSuccess';
  }
}

class PurgeProfileOperationsSuccess implements StopSaving, PersistData {
  PurgeProfileOperationsSuccess(this.profileOperations);

  final List<ProfileOperationEntity> profileOperations;

  @override
  String toString() {
    return 'PurgeProfileOperationsSuccess';
  }
}

class DeleteProfileOperationsFailure implements StopSaving {
  DeleteProfileOperationsFailure(this.profileOperations);

  final List<ProfileOperationEntity> profileOperations;

  @override
  String toString() {
    return 'DeleteProfileOperationsFailure{profileOperations: $profileOperations}';
  }
}

class PurgeProfileOperationsFailure implements StopSaving {
  PurgeProfileOperationsFailure(this.profileOperations);

  final List<ProfileOperationEntity> profileOperations;

  @override
  String toString() {
    return 'PurgeProfileOperationsFailure{profileOperations: $profileOperations}';
  }
}

class RestoreProfileOperationsRequest implements StartSaving {
  RestoreProfileOperationsRequest(this.completer, this.profileOperationIds);

  final Completer completer;
  final List<String> profileOperationIds;

  @override
  String toString() {
    return 'RestoreProfileOperationsRequest';
  }
}

class RestoreProfileOperationsSuccess implements StopSaving, PersistData {
  RestoreProfileOperationsSuccess(this.profileOperations);

  final List<ProfileOperationEntity> profileOperations;

  @override
  String toString() {
    return 'RestoreProfileOperationsSuccess';
  }
}

class RestoreProfileOperationsFailure implements StopSaving {
  RestoreProfileOperationsFailure(this.profileOperations);

  final List<ProfileOperationEntity> profileOperations;

  @override
  String toString() {
    return 'RestoreProfileOperationsFailure{profileOperations: $profileOperations}';
  }
}
// endregion

// region Filter and Sort Actions
class FilterProfileOperations implements PersistUI {
  FilterProfileOperations(this.filter);

  final String filter;

  @override
  String toString() {
    return 'FilterProfileOperations';
  }
}

class SortProfileOperations implements PersistUI, PersistPrefs {
  SortProfileOperations(this.field);

  final String field;

  @override
  String toString() {
    return 'SortProfileOperations';
  }
}

class FilterProfileOperationsByState implements PersistUI {
  FilterProfileOperationsByState(this.state);

  final EntityState state;

  @override
  String toString() {
    return 'FilterProfileOperationsByState';
  }
}

class UpdateProfileOperationFilter implements PersistUI {
  UpdateProfileOperationFilter(this.filter);
  final ProfileOperationFilter filter;

  @override
  String toString() {
    return 'UpdateProfileOperationFilter';
  }
}
// endregion

// region Multiselect Actions
class StartProfileOperationMultiselect {
  StartProfileOperationMultiselect();

  @override
  String toString() {
    return 'StartProfileOperationMultiselect';
  }
}

class AddToProfileOperationMultiselect {
  AddToProfileOperationMultiselect({required this.entity});

  final BaseEntity entity;

  @override
  String toString() {
    return 'AddToProfileOperationMultiselect';
  }
}

class RemoveFromProfileOperationMultiselect {
  RemoveFromProfileOperationMultiselect({required this.entity});

  final BaseEntity entity;

  @override
  String toString() {
    return 'RemoveFromProfileOperationMultiselect';
  }
}

class ClearProfileOperationMultiselect {
  ClearProfileOperationMultiselect();

  @override
  String toString() {
    return 'ClearProfileOperationMultiselect';
  }
}
// endregion

// region Tab Actions
class UpdateProfileOperationTab implements PersistUI {
  UpdateProfileOperationTab({this.tabIndex});

  final int? tabIndex;

  @override
  String toString() {
    return 'UpdateProfileOperationTab';
  }
}

class UpdateProfileOperationActiveTab implements PersistUI {
  UpdateProfileOperationActiveTab(this.activeTab);

  final String activeTab;

  @override
  String toString() {
    return 'UpdateProfileOperationActiveTab';
  }
}
// endregion

// region Entity Actions
class LikeEntityRequest implements StartSaving {
  LikeEntityRequest({
    this.completer,
    required this.entityId,
    required this.entityType,
    this.type = LikeType.normal,
  });

  final Completer? completer;
  final String entityId;
  final int type;
  final EntityType entityType;
}

class LikeEntitySuccess implements PersistData, PersistUI {
  LikeEntitySuccess(this.data, this.entityType);

  final Map<String, dynamic> data;
  final EntityType entityType;
}

class LikeEntityFailure {
  LikeEntityFailure(this.error);

  final Object error;
}

class CommentEntityRequest implements StartSaving {
  CommentEntityRequest({
    this.completer,
    required this.entityId,
    required this.entityType,
    required this.comment,
  });

  final Completer? completer;
  final String entityId;
  final EntityType entityType;
  final String comment;
}

class CommentEntitySuccess implements PersistData, PersistUI {
  CommentEntitySuccess(this.data, this.entityType);

  final Map<String, dynamic> data;
  final EntityType entityType;
}

class CommentEntityFailure {
  CommentEntityFailure(this.error);

  final Object error;
}

class ReportEntityRequest {
  ReportEntityRequest({
    this.completer,
    required this.entityId,
    required this.entityType,
    required this.comment,
  });

  final Completer? completer;
  final String entityId;
  final EntityType entityType;
  final String comment;
}

class ReportEntitySuccess implements PersistData, PersistUI {
  ReportEntitySuccess(this.data, this.entityType);

  final Map<String, dynamic> data;
  final EntityType entityType;
}

class ReportEntityFailure {
  ReportEntityFailure(this.error);

  final Object error;
}
// endregion

// region Action Handlers
void handleProfileOperationAction(BuildContext context,
    List<BaseEntity> profileOperations, EntityAction action) {
  if (profileOperations.isEmpty) {
    return;
  }

  final store = StoreProvider.of<AppState>(context);
  final localization = AppLocalization.of(context)!;
  final profileOperation = profileOperations.first as ProfileOperationEntity;
  final profileOperationIds =
      profileOperations.map((profileOperation) => profileOperation.id).toList();

  switch (action) {
    case EntityAction.edit:
      editEntity(entity: profileOperation);
      break;
    case EntityAction.restore:
      store.dispatch(RestoreProfileOperationsRequest(
          snackBarCompleter<Null>(localization.restoredProfileOperation),
          profileOperationIds));
      break;
    case EntityAction.archive:
      store.dispatch(ArchiveProfileOperationsRequest(
          snackBarCompleter<Null>(localization.archivedProfileOperation),
          profileOperationIds));
      break;
    case EntityAction.delete:
      store.dispatch(DeleteProfileOperationsRequest(
          snackBarCompleter<Null>(localization.deletedProfileOperation),
          profileOperationIds));
      break;
    case EntityAction.purge:
      store.dispatch(PurgeProfileOperationsRequest(
          snackBarCompleter<Null>(localization.deletedProfileOperation),
          profileOperationIds));
      break;
    case EntityAction.toggleMultiselect:
      if (!store.state.profileOperationListState.isInMultiselect()) {
        store.dispatch(StartProfileOperationMultiselect());
      }

      if (profileOperations.isEmpty) {
        break;
      }

      for (final profileOperation in profileOperations) {
        if (!store.state.profileOperationListState
            .isSelected(profileOperation.id)) {
          store.dispatch(
              AddToProfileOperationMultiselect(entity: profileOperation));
        } else {
          store.dispatch(
              RemoveFromProfileOperationMultiselect(entity: profileOperation));
        }
      }
      break;
    case EntityAction.more:
      showEntityActionsDialog(
        entities: [profileOperation],
      );
      break;
    default:
  logError('unhandled action $action in profile_operation_actions');
      break;
  }
}
// endregion
