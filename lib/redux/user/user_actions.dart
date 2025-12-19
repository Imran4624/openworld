// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:built_collection/built_collection.dart';
import 'package:flutter_redux/flutter_redux.dart';

// Project imports:
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/auth/auth_actions.dart';
import 'package:flutter_boilerplate/ui/app/entities/entity_actions_dialog.dart';
import 'package:flutter_boilerplate/utils/completers.dart';
import 'package:flutter_boilerplate/utils/dialogs.dart';
import 'package:flutter_boilerplate/utils/localization.dart';

class ViewUserList implements PersistUI {
  ViewUserList({this.force = false});

  final bool force;

  @override
  String toString() {
    return 'ViewUserList';
  }
}

class ViewUser implements PersistUI, PersistPrefs {
  ViewUser({
    required this.userId,
    this.force = false,
  });

  final String? userId;
  final bool force;

  @override
  String toString() {
    return 'ViewUser';
  }
}

class EditUser implements PersistUI, PersistPrefs {
  EditUser({required this.user, this.completer, this.force = false});

  final UserEntity user;
  final Completer? completer;
  final bool force;

  @override
  String toString() {
    return 'EditUser';
  }
}

class UpdateUser implements PersistUI {
  UpdateUser(this.user);

  final UserEntity user;

  @override
  String toString() {
    return 'UpdateUser';
  }
}

// TODO remove this action and related code/update with user
class UpdateUserCompany implements PersistUI {
  UpdateUserCompany(this.userCompany);

  final UserCompanyEntity userCompany;

  @override
  String toString() {
    return 'UpdateUserCompany';
  }
}

class LoadUser {
  LoadUser({this.completer, this.userId});

  final Completer? completer;
  final String? userId;

  @override
  String toString() {
    return 'LoadUser';
  }
}

class LoadUserActivity {
  LoadUserActivity({this.completer, this.userId});

  final Completer? completer;
  final String? userId;

  @override
  String toString() {
    return 'LoadUserActivity';
  }
}

class LoadUsers {
  LoadUsers({this.completer});

  final Completer? completer;

  @override
  String toString() {
    return 'LoadUsers';
  }
}

class LoadUserRequest implements StartLoading {
  @override
  String toString() {
    return 'LoadUserRequest';
  }
}

class LoadUserFailure implements StopLoading {
  LoadUserFailure(this.error);

  final dynamic error;

  @override
  String toString() {
    return 'LoadUserFailure{error: $error}';
  }
}

class LoadUserSuccess implements StopLoading, PersistData {
  LoadUserSuccess(this.user);

  final UserEntity user;

  @override
  String toString() {
    return 'LoadUserSuccess';
  }
}

class LoadUsersRequest implements StartLoading {
  @override
  String toString() {
    return 'LoadUsersRequest';
  }
}

class LoadUsersFailure implements StopLoading {
  LoadUsersFailure(this.error);

  final dynamic error;

  @override
  String toString() {
    return 'LoadUsersFailure{error: $error}';
  }
}

class LoadUsersSuccess implements StopLoading {
  LoadUsersSuccess(this.users);

  final BuiltList<UserEntity> users;

  @override
  String toString() {
    return 'LoadUsersSuccess';
  }
}

class SaveUserRequest implements StartSaving {
  SaveUserRequest({
    required this.completer,
    required this.user,
    this.password,
    this.idToken,
  });

  final Completer completer;
  final UserEntity? user;
  final String? password;
  final String? idToken;

  @override
  String toString() {
    return 'SaveUserRequest';
  }
}

class SaveUserSuccess
    implements StopSaving, PersistData, PersistUI, UserVerifiedPassword {
  SaveUserSuccess(this.user);

  final UserEntity user;

  @override
  String toString() {
    return 'SaveUserSuccess';
  }
}

class AddUserSuccess
    implements StopSaving, PersistData, PersistUI, UserVerifiedPassword {
  AddUserSuccess(this.user);

  final UserEntity user;

  @override
  String toString() {
    return 'AddUserSuccess';
  }
}

class SaveUserFailure implements StopSaving {
  SaveUserFailure(this.error);

  final Object error;

  @override
  String toString() {
    return 'SaveUserFailure{error: $error}';
  }
}

class ArchiveUserRequest implements StartSaving {
  ArchiveUserRequest({
    this.completer,
    this.userIds,
    this.password,
    this.idToken,
  });

  final Completer? completer;
  final List<String>? userIds;
  final String? password;
  final String? idToken;

  @override
  String toString() {
    return 'ArchiveUserRequest';
  }
}

class ArchiveUserSuccess
    implements StopSaving, PersistData, UserVerifiedPassword {
  ArchiveUserSuccess(this.users);

  final List<UserEntity> users;

  @override
  String toString() {
    return 'ArchiveUserSuccess';
  }
}

class ArchiveUserFailure implements StopSaving {
  ArchiveUserFailure(this.users);

  final List<UserEntity?> users;

  @override
  String toString() {
    return 'ArchiveUserFailure{users: $users}';
  }
}

class DeleteUserRequest implements StartSaving {
  DeleteUserRequest({
    this.completer,
    this.userIds,
    this.password,
    this.idToken,
  });

  final Completer? completer;
  final List<String>? userIds;
  final String? password;
  final String? idToken;

  @override
  String toString() {
    return 'DeleteUserRequest';
  }
}

class DeleteUserSuccess
    implements StopSaving, PersistData, UserVerifiedPassword {
  DeleteUserSuccess(this.users);

  final List<UserEntity> users;

  @override
  String toString() {
    return 'DeleteUserSuccess';
  }
}

class DeleteUserFailure implements StopSaving {
  DeleteUserFailure(this.users);

  final List<UserEntity?> users;

  @override
  String toString() {
    return 'DeleteUserFailure{users: $users}';
  }
}

class RestoreUserRequest implements StartSaving {
  RestoreUserRequest({
    this.completer,
    this.userIds,
    this.password,
    this.idToken,
  });

  final Completer? completer;
  final List<String>? userIds;
  final String? password;
  final String? idToken;

  @override
  String toString() {
    return 'RestoreUserRequest';
  }
}

class RestoreUserSuccess
    implements StopSaving, PersistData, UserVerifiedPassword {
  RestoreUserSuccess(this.users);

  final List<UserEntity> users;

  @override
  String toString() {
    return 'RestoreUserSuccess';
  }
}

class RestoreUserFailure implements StopSaving {
  RestoreUserFailure(this.users);

  final List<UserEntity?> users;

  @override
  String toString() {
    return 'RestoreUserFailure{users: $users}';
  }
}

class RemoveUserRequest implements StartSaving {
  RemoveUserRequest({
    this.completer,
    this.userId,
    this.password,
    this.idToken,
  });

  final Completer? completer;
  final String? userId;
  final String? password;
  final String? idToken;

  @override
  String toString() {
    return 'RemoveUserRequest';
  }
}

class RemoveUserSuccess implements StopSaving, PersistData {
  RemoveUserSuccess(this.userId);

  final String? userId;

  @override
  String toString() {
    return 'RemoveUserSuccess';
  }
}

class RemoveUserFailure implements StopSaving {
  RemoveUserFailure(this.error);

  final dynamic error;

  @override
  String toString() {
    return 'RemoveUserFailure{error: $error}';
  }
}

class ResendInviteRequest implements StartSaving {
  ResendInviteRequest({
    this.completer,
    this.userId,
    this.password,
    this.idToken,
  });

  final Completer? completer;
  final String? userId;
  final String? password;
  final String? idToken;

  @override
  String toString() {
    return 'ResendInviteRequest';
  }
}

class ResendInviteSuccess implements StopSaving, PersistData {
  ResendInviteSuccess(this.userId);

  final String? userId;

  @override
  String toString() {
    return 'ResendInviteSuccess';
  }
}

class ResendInviteFailure implements StopSaving {
  ResendInviteFailure(this.error);

  final dynamic error;

  @override
  String toString() {
    return 'ResendInviteFailure{error: $error}';
  }
}

class FilterUsers {
  FilterUsers(this.filter);

  final String? filter;

  @override
  String toString() {
    return 'FilterUsers';
  }
}

class SortUsers implements PersistUI, PersistPrefs {
  SortUsers(this.field);

  final String field;

  @override
  String toString() {
    return 'SortUsers';
  }
}

class FilterUsersByState implements PersistUI {
  FilterUsersByState(this.state);

  final EntityState state;

  @override
  String toString() {
    return 'FilterUsersByState';
  }
}

class FilterUsersByCustom1 implements PersistUI {
  FilterUsersByCustom1(this.value);

  final String value;

  @override
  String toString() {
    return 'FilterUsersByCustom1';
  }
}

class FilterUsersByCustom2 implements PersistUI {
  FilterUsersByCustom2(this.value);

  final String value;

  @override
  String toString() {
    return 'FilterUsersByCustom2';
  }
}

class FilterUsersByCustom3 implements PersistUI {
  FilterUsersByCustom3(this.value);

  final String value;

  @override
  String toString() {
    return 'FilterUsersByCustom3';
  }
}

class FilterUsersByCustom4 implements PersistUI {
  FilterUsersByCustom4(this.value);

  final String value;

  @override
  String toString() {
    return 'FilterUsersByCustom4';
  }
}

void handleUserAction(
    BuildContext? context, List<BaseEntity> users, EntityAction? action) {
  if (users.isEmpty) {
    return;
  }

  final store = StoreProvider.of<AppState>(context!);
  final localization = AppLocalization.of(context);
  final user = users.first as UserEntity;
  final userIds = users.map((user) => user.id).toList();

  switch (action) {
    case EntityAction.edit:
      editEntity(entity: user);
      break;
    case EntityAction.restore:
      final message = userIds.length > 1
          ? localization!.restoredUsers
              .replaceFirst(':value', ':count')
              .replaceFirst(':count', userIds.length.toString())
          : localization!.restoredUser;
      final dispatch = ([String? password, String? idToken]) =>
          store.dispatch(RestoreUserRequest(
            completer: snackBarCompleter<Null>(message),
            userIds: userIds,
            password: password,
            idToken: idToken,
          ));
      passwordCallback(
          context: context,
          callback: (password, idToken) {
            dispatch(password, idToken);
          });
      break;
    case EntityAction.archive:
      final message = userIds.length > 1
          ? localization!.archivedUsers
              .replaceFirst(':value', ':count')
              .replaceFirst(':count', userIds.length.toString())
          : localization!.archivedUser;
      final dispatch = ([String? password, String? idToken]) =>
          store.dispatch(ArchiveUserRequest(
            completer: snackBarCompleter<Null>(message),
            userIds: userIds,
            password: password,
            idToken: idToken,
          ));
      passwordCallback(
          context: context,
          callback: (password, idToken) {
            dispatch(password, idToken);
          });
      break;
    case EntityAction.delete:
      final message = userIds.length > 1
          ? localization!.deletedUsers
              .replaceFirst(':value', ':count')
              .replaceFirst(':count', userIds.length.toString())
          : localization!.deletedUser;
      final dispatch = ([
        String? password,
        String? idToken,
      ]) =>
          store.dispatch(DeleteUserRequest(
            completer: snackBarCompleter<Null>(message),
            userIds: userIds,
            password: password,
            idToken: idToken,
          ));
      passwordCallback(
          context: context,
          callback: (password, idToken) {
            dispatch(password, idToken);
          });
      break;
    case EntityAction.remove:
      final message = userIds.length > 1
          ? localization!.removedUsers
              .replaceFirst(':value', ':count')
              .replaceFirst(':count', userIds.length.toString())
          : localization!.removedUser;
      final dispatch = ([
        String? password,
        String? idToken,
      ]) =>
          store.dispatch(RemoveUserRequest(
            completer: snackBarCompleter<Null>(message),
            userId: user.id,
            password: password,
            idToken: idToken,
          ));
      confirmCallback(
          context: context,
          callback: (_) {
            passwordCallback(
                context: context,
                callback: (password, idToken) {
                  dispatch(password, idToken);
                });
          });
      break;
    case EntityAction.toggleMultiselect:
      if (!store.state.userListState.isInMultiselect()) {
        store.dispatch(StartUserMultiselect());
      }

      if (users.isEmpty) {
        break;
      }

      for (final user in users) {
        if (!store.state.userListState.isSelected(user.id)) {
          store.dispatch(AddToUserMultiselect(entity: user));
        } else {
          store.dispatch(RemoveFromUserMultiselect(entity: user));
        }
      }
      break;
    case EntityAction.resendInvite:
      passwordCallback(
          context: context,
          callback: (password, idToken) {
            store.dispatch(ResendInviteRequest(
              userId: user.id,
              password: password,
              idToken: idToken,
              completer: snackBarCompleter<Null>(
                  localization!.emailSentToConfirmEmail),
            ));
          });
      break;
    case EntityAction.more:
      showEntityActionsDialog(
        entities: [user],
      );
      break;
  }
}

class StartUserMultiselect {
  @override
  String toString() {
    return 'StartUserMultiselect';
  }
}

class AddToUserMultiselect {
  AddToUserMultiselect({required this.entity});

  final BaseEntity? entity;

  @override
  String toString() {
    return 'AddToUserMultiselect';
  }
}

class RemoveFromUserMultiselect {
  RemoveFromUserMultiselect({required this.entity});

  final BaseEntity? entity;

  @override
  String toString() {
    return 'RemoveFromUserMultiselect';
  }
}

class ClearUserMultiselect {
  @override
  String toString() {
    return 'ClearUserMultiselect';
  }
}
