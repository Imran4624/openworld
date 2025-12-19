import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_boilerplate/.env.dart';
import 'package:flutter_boilerplate/project_config.dart';
import 'package:flutter_boilerplate/redux/auth/auth_actions.dart';
import 'package:flutter_boilerplate/redux/notification/notification_actions.dart'
    as notification;
import 'package:flutter_boilerplate/services/session_managment_service.dart';
import 'package:flutter_boilerplate/ui/app/routing_rules.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'package:flutter_boilerplate/ui/dynamic_fields/dynamic_fields_presenter.dart';
import 'package:flutter_boilerplate/utils/completers.dart';
import 'package:redux/redux.dart';
import 'package:built_collection/built_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_boilerplate/main_app.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/ui/ui_actions.dart';
import 'package:flutter_boilerplate/ui/profile/profile_screen.dart';
import 'package:flutter_boilerplate/ui/profile/edit/profile_edit_vm.dart';
import 'package:flutter_boilerplate/ui/profile/view/profile_view_vm.dart';
import 'package:flutter_boilerplate/redux/profile/profile_actions.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/data/repositories/profile_repository.dart';
import 'package:flutter_boilerplate/data/repositories/auth_repository.dart';
import 'package:flutter_boilerplate/redux/chat/chat_actions.dart'
    as chatActions;
import 'package:flutter_boilerplate/services/email_service/get_email_templates.dart';

List<Middleware<AppState>> createStoreProfilesMiddleware([
  ProfileRepository repository = const ProfileRepository(),
  AuthRepository authRepository = const AuthRepository(),
]) {
  final viewProfileList = _viewProfileList();
  final viewProfile = _viewProfile();
  final editProfile = _editProfile();
  final loadProfiles = _loadProfiles(repository);
  final loadSingleProfile = _loadSingleProfile(repository);
  final loadProfile = _loadProfile(repository);
  final saveProfile = _saveProfile(repository, authRepository);
  final archiveProfile = _archiveProfile(repository);
  final deleteProfile = _deleteProfile(repository);
  final purgeProfile = _purgeProfile(repository);
  final restoreProfile = _restoreProfile(repository);
  final updateFilter = _updateFilter(repository);
  final fetchAttendeeProfiles = _fetchAttendeeProfiles();
  final addCompanyToUser = _addCompanyToUser(repository);
  final addCompaniesToAttendees = _addCompaniesToAttendees(repository);

  return [
    TypedMiddleware<AppState, ViewProfileList>(viewProfileList),
    TypedMiddleware<AppState, ViewProfile>(viewProfile),
    TypedMiddleware<AppState, EditProfile>(editProfile),
    TypedMiddleware<AppState, LoadProfiles>(loadProfiles),
    TypedMiddleware<AppState, LoadSingleProfileRequest>(loadSingleProfile),
    TypedMiddleware<AppState, LoadProfile>(loadProfile),
    TypedMiddleware<AppState, SaveProfileRequest>(saveProfile),
    TypedMiddleware<AppState, ArchiveProfilesRequest>(archiveProfile),
    TypedMiddleware<AppState, DeleteProfilesRequest>(deleteProfile),
    TypedMiddleware<AppState, PurgeProfilesRequest>(purgeProfile),
    TypedMiddleware<AppState, RestoreProfilesRequest>(restoreProfile),
    TypedMiddleware<AppState, UpdateProfileFilter>(updateFilter),
    TypedMiddleware<AppState, FetchAttendeeProfilesRequest>(
        fetchAttendeeProfiles),
    TypedMiddleware<AppState, AddCompanyToCurrentUser>(addCompanyToUser),
    TypedMiddleware<AppState, AddCompaniesToAttendees>(
        addCompaniesToAttendees),
  ];
}

Middleware<AppState> _editProfile() {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as EditProfile;

    next(action);

    store.dispatch(UpdateCurrentRoute(ProfileEditScreen.route));

    if (store.state.prefState.isMobile) {
      navigatorKey.currentState!.pushNamed(ProfileEditScreen.route);
    }
  };
}

Middleware<AppState> _viewProfile() {
  return (Store<AppState> store, dynamic dynamicAction,
      NextDispatcher next) async {
    final action = dynamicAction as ViewProfile;

    next(action);

    final fullRoute =
        ProjectConfig.getEntityDetailUrl(EntityType.profile, action.profileId!);
    store.dispatch(UpdateCurrentRoute(fullRoute));
    if (store.state.prefState.isMobile) {
      navigatorKey.currentState!.pushNamed(ProfileViewScreen.route);
    } else {
      if (ProjectConfig.appType == AppType.opw &&
          !store.state.prefState.isViewerFullScreen(EntityType.profile)) {
        store.dispatch(ToggleViewerLayout(EntityType.profile));
      }
    }
  };
}

Middleware<AppState> _viewProfileList() {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as ViewProfileList;

    next(action);

    if (store.state.staticState.isStale) {
      store.dispatch(RefreshData());
    }

    store.dispatch(UpdateCurrentRoute(ProfileScreen.route));

    if (store.state.prefState.isMobile) {
      navigatorKey.currentState!.pushNamedAndRemoveUntil(
          ProfileScreen.route, (Route<dynamic> route) => false);
    }
  };
}

Middleware<AppState> _archiveProfile(ProfileRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as ArchiveProfilesRequest;
    final prevProfiles = action.profileIds
        .map((id) => store.state.profileState.map[id])
        .whereType<ProfileEntity>()
        .toList();

    repository
        .bulkAction(
            store.state.credentials, action.profileIds, EntityAction.archive)
        .then((List<ProfileEntity> profiles) {
      store.dispatch(ArchiveProfilesSuccess(profiles));
      action.completer.complete(null);
    }).catchError((Object error) {
      logError(' Error in archiveProfiles middleware: $error');
      store.dispatch(ArchiveProfilesFailure(prevProfiles));
      action.completer.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _deleteProfile(ProfileRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as DeleteProfilesRequest;
    final prevProfiles = action.profileIds
        .map((id) => store.state.profileState.map[id])
        .whereType<ProfileEntity>()
        .toList();

    repository
        .bulkAction(
            store.state.credentials, action.profileIds, EntityAction.delete)
        .then((List<ProfileEntity> profiles) {
      store.dispatch(DeleteProfilesSuccess(profiles));
      action.completer.complete(null);
    }).catchError((Object error) {
      logError(' Error in deleteProfiles middleware: $error');
      store.dispatch(DeleteProfilesFailure(prevProfiles));
      action.completer.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _purgeProfile(ProfileRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as PurgeProfilesRequest;
    final prevProfiles = action.profileIds
        .map((id) => store.state.profileState.map[id])
        .whereType<ProfileEntity>()
        .toList();

    repository
        .bulkAction(
            store.state.credentials, action.profileIds, EntityAction.purge)
        .then((List<ProfileEntity> profiles) {
      store.dispatch(PurgeProfilesSuccess(profiles));
      if (!action.isMyProfile) {
        store.dispatch(ViewProfileList());
      }
      action.completer.complete(null);
    }).catchError((Object error) {
      logError(' Error in purgeProfiles middleware: $error');
      store.dispatch(PurgeProfilesFailure(prevProfiles));
      action.completer.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _restoreProfile(ProfileRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction,
      NextDispatcher next) async {
    final action = dynamicAction as RestoreProfilesRequest;
    final prevProfiles = action.profileIds
        .map((id) => store.state.profileState.map[id])
        .whereType<ProfileEntity>()
        .toList();

    repository
        .bulkAction(
            store.state.credentials, action.profileIds, EntityAction.restore)
        .then((List<ProfileEntity> profiles) async {
      store.dispatch(RestoreProfilesSuccess(profiles));
      if (ProjectConfig.autoMessageFromAdminEnabled) {
        for (final profileOp in profiles) {
          final restoredUserId = profileOp.id;
          final adminId = Config.autoMessageAdminProfileId;
          if (adminId.isNotEmpty && restoredUserId.isNotEmpty) {
            store.dispatch(chatActions.SendMessageRequest(
              message: ChatMessageEntity(
                chatId: '',
                senderId: adminId,
                content: ProjectConfig.autoMessageFromAdminText,
                replyTo: restoredUserId,
                attachments: BuiltList<ChatMessageAttachment>(),
                isViewOnce: false,
              ),
            ));
          }
        }
      }
      if (ProjectConfig.sendAccountApprovedEmail) {
        final htmlTemplate = await getProfileApprovedEmailTemplate();
        store.dispatch(notification.SendEmailAction(
            emailMessage: EmailMessage(
          to: action.sendEmailTo,
          subject: "Welcome to Cocktails & Conversation — you're all set!",
          body: htmlTemplate,
        )));
      }
      action.completer.complete(null);
    }).catchError((Object error) {
      logError(' Error in restoreProfiles middleware: $error');
      store.dispatch(RestoreProfilesFailure(prevProfiles));
      action.completer.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _saveProfile(
    ProfileRepository repository, AuthRepository authRepository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as SaveProfileRequest;

    final dynamicFieldsState = store.state.dynamicFieldState;
    final dynamicFieldsData = <String, dynamic>{};

    dynamicFieldsState.answers.forEach((groupId, groupAnswers) {
      groupAnswers.forEach((key, value) {
        if (value == null || (value is String && value.isEmpty)) {
          return;
        }

        if (value is List) {
          final cleanList = value
              .where((item) =>
                  item != null && (item is! String || item.isNotEmpty))
              .toList();

          if (cleanList.isNotEmpty) {
            dynamicFieldsData[key] = cleanList;
          }
        } else if (value is Map) {
          final cleanMap = Map<String, dynamic>.from(value)
            ..removeWhere((_, v) => v == null || (v is String && v.isEmpty));

          if (cleanMap.isNotEmpty) {
            dynamicFieldsData[key] = cleanMap;
          }
        } else {
          dynamicFieldsData[key] = value;
        }
      });
    });

    final updatedProfile = action.profile!.isNew
        ? action.profile!.rebuild((b) => b
          ..dynamicFields.clear()
          ..dynamicFields.addAll(dynamicFieldsData)
          ..email = store.state.authState.email)
        : action.profile!;
    final updatedProfileData = action.profile ?? updatedProfile;
    repository
        .saveData(getLoggedInUserId(store), updatedProfileData)
        .then((profile) async {
      if (profile.isArchived) {
        store.dispatch(SetArchivedUserStatus(profile.isArchived));
      }

      logInfo('Profile saved successfully, marking as complete...');

      final completer = Completer<Null>();
      store.dispatch(UpdateProfileCompletionStatus(
        completer: completer,
      ));

      try {
        await completer.future;
        logInfo('Profile completion status updated successfully');

        final userId = getLoggedInUserId(store);
        final refreshedProfile =
            await authRepository.getCurrentUserProfile(userId);

        if (refreshedProfile == null) {
          if (!(ProjectConfig.appType == AppType.opw &&
              store.state.authState.isEmailLinkAuth)) {
            store.dispatch(UserLogout());
          }
          return;
        }

        logInfo(
            'Refreshed profile completion status: ${refreshedProfile.isProfileCompleted}');

        final completedProfile =
            refreshedProfile.rebuild((b) => b..isProfileCompleted = true);

        if (action.profile!.isNew) {
          store.dispatch(AddProfileSuccess(completedProfile));
        } else {
          store.dispatch(SaveProfileSuccess(completedProfile));
        }

        updateLoggedInUserProfile(store, completedProfile);

        store.dispatch(UpdateAuthStateAction(
          currentUserName: store.state.authState.currentUserName,
          currentUserId: store.state.authState.currentUserId,
          email: store.state.authState.email,
          isArchived: completedProfile.isArchived,
          isAdmin: completedProfile.isAdmin,
          setProfileCompleted: true,
          isEmailVerified: store.state.authState.isEmailVerified,
        ));

        logInfo('Profile completion flow completed successfully');

        if (completedProfile.isArchived) {
          RoutingRules.navigationForArchivedUser(completedProfile);
        } else {
          RoutingRules.defaultEntityLoadingRouting();
        }

        action.completer?.complete(completedProfile);
      } catch (error) {
        logError(' Error updating profile completion status: $error');
        if (action.profile!.isNew) {
          store.dispatch(AddProfileSuccess(profile));
        } else {
          store.dispatch(SaveProfileSuccess(profile));
        }
        updateLoggedInUserProfile(store, profile);
        action.completer?.complete(profile);
      }
    }).catchError((Object error) {
      logError(' Error saving profile: $error');
      store.dispatch(SaveProfileFailure(error));
      action.completer?.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _loadProfile(ProfileRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as LoadProfile;

    store.dispatch(LoadProfileRequest());
    repository
        .loadItem(store.state.credentials, action.profileId!)
        .then((profile) {
      store.dispatch(LoadProfileSuccess(profile));
      action.completer?.complete(null);
    }).catchError((Object error) {
      store.dispatch(LoadProfileFailure(error));
      logError(' Error in loadProfile middleware: $error');
      action.completer?.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _loadProfiles(ProfileRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    if (store.state.isLoading) {
      return;
    }

    final action = dynamicAction as LoadProfiles;
    final state = store.state;
    final stateFilters = state.profileListState.stateFilters;
    final ProfileFilter baseFilter = action.filter ?? state.profileState.filter;

    String preferredGender = '';
    final loggedInProfile = state.profileState.loggedInUserProfile;

    final bool isAdmin = loggedInProfile.isAdmin;
    final currentUserId = loggedInProfile.id;
    if (!isAdmin) {
      preferredGender = loggedInProfile.dynamicFields.getPreferredGender();
    }

    var selectedCompanyId =  state.userCompanyState.selectedCompanyId;

    if (ProjectConfig.appType == AppType.opw) {
      if (selectedCompanyId.isEmpty) {
        logError('LoadProfiles failed for opw: no company selected');
        action.completer
            ?.completeError('A company must be selected for app type opw');
        next(action);
        return;
      }
    } else {
      selectedCompanyId = '';
    }

    final updatedFilter = baseFilter.rebuild((b) {
      if (stateFilters.isNotEmpty) {
        b.stateFilter = stateFilters.first;
      }
      b.currentUserId = currentUserId;
      if (preferredGender.isNotEmpty) {
        b.preferredGender = preferredGender;
      }
    });
    store.dispatch(LoadProfilesRequest(filter: updatedFilter));

    var lastDocument = state.profileState.lastDocument;
    if (action.isRefresh) {
      lastDocument = null;
      store.dispatch(UpdateLastDocumentAction(null));
    }

    repository
        .loadListWithPagination(
      lastDocument: lastDocument,
      limit: updatedFilter.limit,
      filter: updatedFilter,
      isAdmin: isAdmin,
      excludeLikedMatchedProfiles: ProjectConfig.excludeLikedMatchedProfiles,
      selectedCompanyId: selectedCompanyId,
    )
        .then((response) {
      final profiles = response.profiles;
      final newLastDocument = response.lastDocument;

      store.dispatch(LoadProfilesSuccess(profiles, action.isRefresh));
      if (profiles.isNotEmpty) {
        store.dispatch(UpdateLastDocumentAction(newLastDocument));
        action.completer?.complete(null);
      } else {
        if (lastDocument != null) {
          snackBarCompleter<void>('No more profiles available').complete();
        } else {
          snackBarCompleter<void>('No profiles found').complete();
        }
        action.completer?.complete(null);
      }
    }).catchError((Object error) {
      logError(' Error loading profiles: $error');
      store.dispatch(LoadProfilesFailure(error));
      action.completer?.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _fetchAttendeeProfiles() {
  return (Store<AppState> store, dynamic action, NextDispatcher next) async {
    if (action is FetchAttendeeProfilesRequest) {
      final attendees = action.attendees;

      try {
        final emails = attendees
            .map((attendee) => attendee.email.toLowerCase())
            .toSet()
            .toList();

        final Map<String, String> attendeeProfileMap = {};
        final List<ProfileEntity> matchedProfiles = [];

        for (int i = 0; i < emails.length; i += 10) {
          final int endIndex =
              (i + 10 < emails.length) ? i + 10 : emails.length;
          final batch = emails.sublist(i, endIndex);
          
          final querySnapshot = await FirebaseFirestore.instance
              .collection(ProjectConfig.usersProfileCollectionName)
              .where('email', whereIn: batch)
              .get();

          for (final doc in querySnapshot.docs) {
            try {
              final data = doc.data();
              final String profileId = doc.id;

              final isDeleted = data['is_deleted'] == true; 
              final archivedAt = data['archived_at'] ?? 0;
              
              if (data['email'] != null && !isDeleted && archivedAt == 0) {
                final email = data['email'].toString().toLowerCase();
                attendeeProfileMap[email] = profileId;

                final profileEntity =
                    _createProfileEntityFromData(data, profileId);
                if (!profileEntity.isArchived && !(profileEntity.isDeleted ?? false)) {
                  matchedProfiles.add(profileEntity);
                }
              }
            } catch (e) {
              logError(' Error processing profile document: $e');
            }
          }
        }

        store.dispatch(FetchAttendeeProfilesSuccess(
          attendeeProfileMap: attendeeProfileMap,
          matchedProfiles: matchedProfiles,
        ));

        if (action.completer != null) {
          action.completer!.complete();
        }
      } catch (error) {
        logError(' Error fetching attendee profiles: $error');
        store.dispatch(FetchAttendeeProfilesFailure(error));

        if (action.completer != null) {
          action.completer!.completeError(error);
        }
      }
    }

    next(action);
  };
}

ProfileEntity _createProfileEntityFromData(
    Map<String, dynamic> data, String profileId) {
  try {
    return ProfileMapper.dbToEntity(data, profileId);
  } catch (e) {
    logError(' Error creating ProfileEntity: $e');
    return ProfileEntity(id: profileId).rebuild((b) => b
      ..name = 'Profile $profileId'
      ..isDeleted = false);
  }
}

Middleware<AppState> _loadSingleProfile(ProfileRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction,
      NextDispatcher next) async {
    final action = dynamicAction as LoadSingleProfileRequest;

    try {
      final response = await repository.loadSingleProfile(
        lastDocument: action.lastDocument,
        limit: 1,
        filter: action.filter ?? store.state.profileState.filter,
      );

      final profile = response.profile;
      final newLastDocument = response.lastDocument;

      if (profile != null) {
        store.dispatch(LoadSingleProfileSuccess(
          profile: profile,
          lastDocument: newLastDocument,
          insertIndex: action.insertIndex,
        ));
      }

      action.completer?.complete();
    } catch (error) {
      logError(' Error loading single profile: $error');
      action.completer?.completeError(error);
    }

    next(action);
  };
}

Middleware<AppState> _updateFilter(ProfileRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as UpdateProfileFilter;

    next(action);

    store.dispatch(LoadProfiles(
      filter: action.filter,
      isRefresh: true,
    ));
  };
}

Middleware<AppState> _addCompanyToUser(ProfileRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction,
      NextDispatcher next) async {
    final action = dynamicAction as AddCompanyToCurrentUser;
    next(action);

    try {
      await repository.addUserCompanyToProfile(
        userEmail: action.email,
        company: action.company,
      );

      store.dispatch(AddCompanyToUserSuccess(
        userId: action.email,
        company: action.company,
      ));

      final currentUserEmail = store.state.authState.email;
      if (action.email.toLowerCase() == currentUserEmail.toLowerCase()) {
        final currentProfile = store.state.profileState.loggedInUserProfile;
        final updatedProfile = currentProfile.rebuild((b) => b
          ..companyIds.add(action.company.companyId));
        updateLoggedInUserProfile(store, updatedProfile);
      }

      action.completer?.complete();
    } catch (error) {
      logError('Failed to add company to user profile: $error');
      store.dispatch(AddCompanyToUserFailure(error));
      action.completer?.completeError(error);
    }
  };
}

Middleware<AppState> _addCompaniesToAttendees(ProfileRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction,
      NextDispatcher next) async {
    final action = dynamicAction as AddCompaniesToAttendees;
    next(action);

    try {
      List<Future> futures = [];
      final currentUserEmail = store.state.authState.email;
      bool currentUserUpdated = false;

      for (final attendee in action.attendees) {
        if (attendee.email.isNotEmpty) {
          futures.add(repository.addUserCompanyToProfile(
            userEmail: attendee.email,
            company: action.company,
          ));

          if (attendee.email.toLowerCase() == currentUserEmail.toLowerCase()) {
            currentUserUpdated = true;
          }
        }
      }

      await Future.wait(futures);

      if (currentUserUpdated) {
        final currentProfile = store.state.profileState.loggedInUserProfile;

        final existingCompanyIds = currentProfile.companyIds.toSet();
        if (!existingCompanyIds.contains(action.company.companyId)) {
          final updatedProfile = currentProfile.rebuild((b) => b
            ..companyIds.add(action.company.companyId));
          updateLoggedInUserProfile(store, updatedProfile);
        }
      }

      logInfo(
          'Successfully added company ${action.company.companyName} to ${action.attendees.length} attendees');
      action.completer?.complete();
    } catch (error) {
      logError('Failed to add company to attendees: $error');
      action.completer?.completeError(error);
    }
  };
}
