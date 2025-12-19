import 'package:built_collection/built_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/.env.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/project_config.dart';
import 'package:flutter_boilerplate/services/session_managment_service.dart';
import 'package:flutter_boilerplate/ui/app/app_webview_url.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:redux/redux.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/redux/profile_operation/profile_operation_actions.dart';
import 'package:flutter_boilerplate/data/repositories/profile_operation_repository.dart';
import 'package:flutter_boilerplate/main_app.dart';
import 'package:flutter_boilerplate/redux/ui/ui_actions.dart';
import 'package:flutter_boilerplate/ui/profile_operation/profile_operation_screen.dart';
import 'package:flutter_boilerplate/ui/profile_operation/edit/profile_operation_edit_vm.dart';
import 'package:flutter_boilerplate/ui/profile_operation/view/profile_operation_view_vm.dart';
import 'package:flutter_boilerplate/redux/notification/notification_actions.dart'
    as notification_actions;

List<Middleware<AppState>> createStoreProfileOperationsMiddleware([
  ProfileOperationRepository repository = const ProfileOperationRepository(),
]) {
  final viewProfileOperationList = _viewProfileOperationList();
  final viewProfileOperation = _viewProfileOperation();
  final editProfileOperation = _editProfileOperation();
  final loadProfileOperations = _loadProfileOperations(repository);
  final loadProfileOperation = _loadProfileOperation(repository);
  final saveProfileOperation = _saveProfileOperation(repository);
  final archiveProfileOperation = _archiveProfileOperation(repository);
  final deleteProfileOperation = _deleteProfileOperation(repository);
  final purgeProfileOperation = _purgeProfileOperation(repository);
  final restoreProfileOperation = _restoreProfileOperation(repository);
  final updateFilter = _updateFilter(repository);
  final updateActiveTab = _updateActiveTab(repository);

  // Add middleware for new profile operation actions
  final likeProfile = _likeProfile(repository);
  final acceptMatchRequest = _acceptMatchRequest(repository);
  final passProfile = _passProfile(repository);
  final blockProfile = _blockProfile(repository);
  final favoriteProfile = _favoriteProfile(repository);
  final matchProfile = _matchProfile(repository);
  final reportProfile = _reportProfile(repository);

  final likeEntity = _likeEntity(repository);
  final commentEntity = _commentEntity(repository);
  final reportEntity = _reportEntity(repository);

  return [
    TypedMiddleware<AppState, ViewProfileOperationList>(
        viewProfileOperationList),
    TypedMiddleware<AppState, ViewProfileOperation>(viewProfileOperation),
    TypedMiddleware<AppState, EditProfileOperation>(editProfileOperation),
    TypedMiddleware<AppState, LoadProfileOperations>(loadProfileOperations),
    TypedMiddleware<AppState, LoadProfileOperation>(loadProfileOperation),
    TypedMiddleware<AppState, SaveProfileOperationRequest>(
        saveProfileOperation),
    TypedMiddleware<AppState, ArchiveProfileOperationsRequest>(
        archiveProfileOperation),
    TypedMiddleware<AppState, DeleteProfileOperationsRequest>(
        deleteProfileOperation),
    TypedMiddleware<AppState, PurgeProfileOperationsRequest>(
        purgeProfileOperation),
    TypedMiddleware<AppState, RestoreProfileOperationsRequest>(
        restoreProfileOperation),
    TypedMiddleware<AppState, UpdateProfileOperationFilter>(updateFilter),
    TypedMiddleware<AppState, UpdateProfileOperationActiveTab>(updateActiveTab),

    // New middleware entries
    TypedMiddleware<AppState, LikeProfileRequest>(likeProfile),
    TypedMiddleware<AppState, AcceptMatchRequest>(acceptMatchRequest),
    TypedMiddleware<AppState, PassProfileRequest>(passProfile),
    TypedMiddleware<AppState, BlockProfileRequest>(blockProfile),
    TypedMiddleware<AppState, FavoriteProfileRequest>(favoriteProfile),
    TypedMiddleware<AppState, MatchProfileRequest>(matchProfile),
    TypedMiddleware<AppState, ReportProfileRequest>(reportProfile),

    // New entity middleware entries
    TypedMiddleware<AppState, LikeEntityRequest>(likeEntity),
    TypedMiddleware<AppState, CommentEntityRequest>(commentEntity),
    TypedMiddleware<AppState, ReportEntityRequest>(reportEntity),
  ];
}

Middleware<AppState> _editProfileOperation() {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as EditProfileOperation;

    next(action);

    store.dispatch(UpdateCurrentRoute(ProfileOperationEditScreen.route));

    if (store.state.prefState.isMobile) {
      navigatorKey.currentState!.pushNamed(ProfileOperationEditScreen.route);
    }
  };
}

Middleware<AppState> _viewProfileOperation() {
  return (Store<AppState> store, dynamic dynamicAction,
      NextDispatcher next) async {
    final action = dynamicAction as ViewProfileOperation;

    next(action);

    store.dispatch(UpdateCurrentRoute(ProfileOperationViewScreen.route));

    if (store.state.prefState.isMobile) {
      navigatorKey.currentState!.pushNamed(ProfileOperationViewScreen.route);
    }
  };
}

Middleware<AppState> _viewProfileOperationList() {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as ViewProfileOperationList;

    next(action);

    if (store.state.staticState.isStale) {
      store.dispatch(RefreshData());
    }

    store.dispatch(UpdateCurrentRoute(ProfileOperationScreen.route));

    if (store.state.prefState.isMobile) {
      navigatorKey.currentState!.pushNamedAndRemoveUntil(
          ProfileOperationScreen.route, (Route<dynamic> route) => false);
    }
  };
}

Middleware<AppState> _archiveProfileOperation(
    ProfileOperationRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as ArchiveProfileOperationsRequest;
    final prevProfileOperations = action.profileOperationIds
        .map((id) => store.state.profileOperationState.map[id])
        .whereType<ProfileOperationEntity>()
        .toList();

    repository
        .bulkAction(store.state.credentials, action.profileOperationIds,
            EntityAction.archive)
        .then((List<ProfileOperationEntity> profileOperations) {
      store.dispatch(ArchiveProfileOperationsSuccess(profileOperations));
      action.completer.complete(null);
    }).catchError((Object error) {
      logError(' Error in archiveProfileOperation middleware: $error');
      store.dispatch(ArchiveProfileOperationsFailure(prevProfileOperations));
      action.completer.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _deleteProfileOperation(
    ProfileOperationRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as DeleteProfileOperationsRequest;
    final prevProfileOperations = action.profileOperationIds
        .map((id) => store.state.profileOperationState.map[id])
        .whereType<ProfileOperationEntity>()
        .toList();

    repository
        .bulkAction(store.state.credentials, action.profileOperationIds,
            EntityAction.delete)
        .then((List<ProfileOperationEntity> profileOperations) {
      store.dispatch(DeleteProfileOperationsSuccess(profileOperations));
      action.completer.complete(null);
    }).catchError((Object error) {
      logError(' Error in deleteProfileOperation middleware: $error');
      store.dispatch(DeleteProfileOperationsFailure(prevProfileOperations));
      action.completer.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _purgeProfileOperation(
    ProfileOperationRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as PurgeProfileOperationsRequest;
    final prevProfileOperations = action.profileOperationIds
        .map((id) => store.state.profileOperationState.map[id])
        .whereType<ProfileOperationEntity>()
        .toList();

    repository
        .bulkAction(store.state.credentials, action.profileOperationIds,
            EntityAction.purge)
        .then((List<ProfileOperationEntity> profileOperations) {
      store.dispatch(PurgeProfileOperationsSuccess(profileOperations));
      action.completer.complete(null);
    }).catchError((Object error) {
      logError(' Error in purgeProfileOperation middleware: $error');
      store.dispatch(PurgeProfileOperationsFailure(prevProfileOperations));
      action.completer.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _restoreProfileOperation(
    ProfileOperationRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as RestoreProfileOperationsRequest;
    final prevProfileOperations = action.profileOperationIds
        .map((id) => store.state.profileOperationState.map[id])
        .whereType<ProfileOperationEntity>()
        .toList();

    repository
        .bulkAction(store.state.credentials, action.profileOperationIds,
            EntityAction.restore)
        .then((List<ProfileOperationEntity> profileOperations) {
      store.dispatch(RestoreProfileOperationsSuccess(profileOperations));
      action.completer.complete(null);
    }).catchError((Object error) {
      logError(' Error in restoreProfileOperation middleware: $error');
      store.dispatch(RestoreProfileOperationsFailure(prevProfileOperations));
      action.completer.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _saveProfileOperation(
    ProfileOperationRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as SaveProfileOperationRequest;
    repository
        .saveData(store.state.credentials, action.profileOperation!)
        .then((ProfileOperationEntity profileOperation) {
      if (action.profileOperation!.isNew) {
        store.dispatch(AddProfileOperationSuccess(profileOperation));
      } else {
        store.dispatch(SaveProfileOperationSuccess(profileOperation));
      }

      action.completer?.complete(profileOperation);
    }).catchError((Object error) {
      logError(' Error in saveProfileOperation middleware: $error');
      store.dispatch(SaveProfileOperationFailure(error));
      action.completer?.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _loadProfileOperation(
    ProfileOperationRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as LoadProfileOperation;

    store.dispatch(LoadProfileOperationRequest());
    repository
        .loadItem(store.state.credentials, action.profileOperationId!)
        .then((profileOperation) {
      store.dispatch(LoadProfileOperationSuccess(profileOperation));
      action.completer?.complete(null);
    }).catchError((Object error) {
      logError(' Error in loadProfileOperation middleware: $error');
      store.dispatch(LoadProfileOperationFailure(error));
      action.completer?.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _updateActiveTab(ProfileOperationRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as UpdateProfileOperationActiveTab;
    next(action);

    // Load profiles for the newly selected tab
    store.dispatch(LoadProfileOperations(
      tabType: action.activeTab,
      isRefresh: true,
    ));
  };
}

Middleware<AppState> _loadProfileOperations(
    ProfileOperationRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    if (store.state.isLoading) {
      next(dynamicAction);
      return;
    }

    final action = dynamicAction as LoadProfileOperations;
    final state = store.state;
    final stateFilters = state.profileOperationListState.stateFilters;
    final currentFilter = action.filter ?? state.profileOperationState.filter;
    final tabType = action.tabType ?? state.profileOperationState.activeTab;

    // Update filter with current state filter from listUIState
    final filter = currentFilter.rebuild((b) {
      if (stateFilters.isNotEmpty) {
        b.stateFilter = stateFilters.first; // Use the first state filter
      } else {
        b.stateFilter = EntityState.active; // Default to active
      }
    });

    store.dispatch(
        LoadProfileOperationsRequest(filter: filter, tabType: tabType));

    var lastDocument = state.profileOperationState.lastDocumentMap[tabType];
    if (action.isRefresh) {
      lastDocument = null;
      store.dispatch(
          UpdateLastDocumentAction(lastDocument: null, tabType: tabType));
    }

    repository
        .loadListWithPagination(
      lastDocument: lastDocument,
      limit: filter.limit,
      filter: filter,
      tabType: tabType,
      currentUserId: getLoggedInUserId(store),
    )
        .then((response) async {
      final profileOperations =
          response['profileOperations'] as BuiltList<ProfileOperationEntity>;
      final newLastDocument = response['lastDocument'] as DocumentSnapshot?;

      store.dispatch(LoadProfileOperationsSuccess(profileOperations,
          isRefresh: action.isRefresh));
      store.dispatch(LoadTabProfilesSuccess(
          profiles: profileOperations.toList(),
          tabType: tabType,
          isRefresh: action.isRefresh));

      if (profileOperations.isNotEmpty) {
        store.dispatch(UpdateLastDocumentAction(
            lastDocument: newLastDocument, tabType: tabType));
      }

      action.completer?.complete(null);
    }).catchError((Object error) {
      logError(' Error in loadProfileOperations middleware: $error');
      store.dispatch(LoadProfileOperationsFailure(error));
      action.completer?.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _updateFilter(ProfileOperationRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as UpdateProfileOperationFilter;

    next(action);

    store.dispatch(LoadProfileOperations(
      filter: action.filter,
      isRefresh: true,
    ));
  };
}

// Middleware functions for profile operations

Middleware<AppState> _likeProfile(ProfileOperationRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction,
      NextDispatcher next) async {
    final LikeProfileRequest request = dynamicAction as LikeProfileRequest;

    try {
      final profileOperation = await repository.likeProfile(
        currentUserId: getLoggedInUserId(store),
        targetUserId: request.targetUserId,
        type: request.type,
      );
      store.dispatch(notification_actions.SendNotificationAction(
        title: Config.APP_NAME,
        sendTo: request.targetUserId,
        body:
            ' ${store.state.profileState.loggedInUserProfile.name} ${ProjectConfig.likeOrWaveNotificationText}',
        data: {
          'type': ProjectConfig.matchOrWaveText,
          'senderId': getLoggedInUserId(store),
        },
      ));
      store.dispatch(LikeProfileSuccess(profileOperation));
      if (isWeb() && store.state.profileState.list.length <= 1) {
        store.dispatch(TogglePreviewSidebar());
      }
      request.completer?.complete(profileOperation);
    } catch (error) {
      logError(' Error liking profile: $error');

      store.dispatch(LikeProfileFailure(error));

      request.completer?.completeError(error);
    }

    next(dynamicAction);
  };
}

Middleware<AppState> _acceptMatchRequest(
    ProfileOperationRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction,
      NextDispatcher next) async {
    final AcceptMatchRequest request = dynamicAction as AcceptMatchRequest;

    try {
      final profileOperation = await repository.acceptMatchRequest(
        currentUserId: getLoggedInUserId(store),
        targetUserId: request.targetUserId,
      );
      store.dispatch(notification_actions.SendNotificationAction(
        title: Config.APP_NAME,
        sendTo: request.targetUserId,
        body:
            'You\'r ${ProjectConfig.matchedOrConnectedText} with ${store.state.profileState.loggedInUserProfile.name}',
        data: {
          'type': ProjectConfig.matchOrWaveText,
          'senderId': getLoggedInUserId(store),
        },
      ));
      store.dispatch(UpdateProfileOperationActiveTab('Matches'));
      store.dispatch(AcceptMatchSuccess(profileOperation));
      request.completer?.complete(profileOperation);
    } catch (error) {
      logError(' Error accepting match request: $error');

      store.dispatch(AcceptMatchFailure(error));

      request.completer?.completeError(error);
    }

    next(dynamicAction);
  };
}

Middleware<AppState> _passProfile(ProfileOperationRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction,
      NextDispatcher next) async {
    final PassProfileRequest request = dynamicAction as PassProfileRequest;

    try {
      final profileOperation = await repository.passProfile(
        currentUserId: getLoggedInUserId(store),
        targetUserId: request.targetUserId,
      );

      store.dispatch(PassProfileSuccess(profileOperation));

      request.completer?.complete(profileOperation);
    } catch (error) {
      logError(' Error passing profile: $error');

      store.dispatch(PassProfileFailure(error));

      request.completer?.completeError(error);
    }

    next(dynamicAction);
  };
}

Middleware<AppState> _blockProfile(ProfileOperationRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction,
      NextDispatcher next) async {
    final BlockProfileRequest request = dynamicAction as BlockProfileRequest;

    try {
      final profileOperation = await repository.blockProfile(
        currentUserId: getLoggedInUserId(store),
        targetUserId: request.targetUserId,
      );

      store.dispatch(BlockProfileSuccess(profileOperation));

      request.completer?.complete(profileOperation);
    } catch (error) {
      logError(' Error blocking profile: $error');

      store.dispatch(BlockProfileFailure(error));

      request.completer?.completeError(error);
    }

    next(dynamicAction);
  };
}

Middleware<AppState> _favoriteProfile(ProfileOperationRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction,
      NextDispatcher next) async {
    final FavoriteProfileRequest request =
        dynamicAction as FavoriteProfileRequest;

    try {
      final profileOperation = await repository.favoriteProfile(
        currentUserId: getLoggedInUserId(store),
        targetUserId: request.targetUserId,
      );

      store.dispatch(FavoriteProfileSuccess(profileOperation));

      request.completer?.complete(profileOperation);
    } catch (error) {
      logError(' Error favoriting profile: $error');

      store.dispatch(FavoriteProfileFailure(error));

      request.completer?.completeError(error);
    }

    next(dynamicAction);
  };
}

Middleware<AppState> _matchProfile(ProfileOperationRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction,
      NextDispatcher next) async {
    final MatchProfileRequest request = dynamicAction as MatchProfileRequest;

    try {
      final profileOperation = await repository.acceptMatchRequest(
        currentUserId: getLoggedInUserId(store),
        targetUserId: request.targetUserId,
      );

      store.dispatch(MatchProfileSuccess(profileOperation));

      request.completer?.complete(profileOperation);
    } catch (error) {
      logError(' Error matching profile: $error');

      store.dispatch(MatchProfileFailure(error));

      request.completer?.completeError(error);
    }

    next(dynamicAction);
  };
}

Middleware<AppState> _reportProfile(ProfileOperationRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction,
      NextDispatcher next) async {
    final ReportProfileRequest request = dynamicAction as ReportProfileRequest;

    try {
      final profileOperation = await repository.reportProfile(
        currentUserId: getLoggedInUserId(store),
        targetUserId: request.targetUserId,
        comment: request.comment,
      );

      store.dispatch(ReportProfileSuccess(profileOperation));

      const message =
          'Thanks for your report.Our team will review this profile shortly to ensure the community stays safe and respectful.';
      showToast(message);
      request.completer?.complete(profileOperation);
    } catch (error) {
      logError(' Error reporting profile: $error');

      store.dispatch(ReportProfileFailure(error));

      request.completer?.completeError(error);
    }

    next(dynamicAction);
  };
}

// Entity Actions Middleware

Middleware<AppState> _likeEntity(ProfileOperationRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction,
      NextDispatcher next) async {
    final LikeEntityRequest request = dynamicAction as LikeEntityRequest;

    try {
      final result = await repository.likeEntity(
        currentUserId: getLoggedInUserId(store),
        targetId: request.entityId,
        entityType: request.entityType,
        type: request.type,
      );

      store.dispatch(LikeEntitySuccess(result, request.entityType));
      request.completer?.complete(result);
    } catch (error) {
      logError(' Error liking entity: $error');
      store.dispatch(LikeEntityFailure(error));
      request.completer?.completeError(error);
    }

    next(dynamicAction);
  };
}

Middleware<AppState> _commentEntity(ProfileOperationRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction,
      NextDispatcher next) async {
    final CommentEntityRequest request = dynamicAction as CommentEntityRequest;

    try {
      final result = await repository.commentEntity(
        currentUserId: getLoggedInUserId(store),
        currentUserName: store.state.authState.currentUserName,
        targetId: request.entityId,
        entityType: request.entityType,
        comment: request.comment,
      );

      store.dispatch(CommentEntitySuccess(result, request.entityType));
      request.completer?.complete(result);
    } catch (error) {
      logError(' Error commenting on entity: $error');
      store.dispatch(CommentEntityFailure(error));
      request.completer?.completeError(error);
    }

    next(dynamicAction);
  };
}

Middleware<AppState> _reportEntity(ProfileOperationRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction,
      NextDispatcher next) async {
    final ReportEntityRequest request = dynamicAction as ReportEntityRequest;

    try {
      final result = await repository.reportEntity(
        currentUserId: getLoggedInUserId(store),
        targetId: request.entityId,
        entityType: request.entityType,
        comment: request.comment,
      );

      store.dispatch(ReportEntitySuccess(result, request.entityType));

      const message =
          'Thanks for your report. Our team will review this content shortly to ensure the community stays safe and respectful.';
      showToast(message);

      request.completer?.complete(result);
    } catch (error) {
      logError(' Error reporting entity: $error');
      store.dispatch(ReportEntityFailure(error));
      request.completer?.completeError(error);
    }

    next(dynamicAction);
  };
}
