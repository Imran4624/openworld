// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/data/models/profile_model.dart';
import 'package:flutter_boilerplate/data/models/static/app_theme.dart';
import 'package:flutter_boilerplate/main_app.dart';
import 'package:flutter_boilerplate/project_config.dart';
import 'package:flutter_boilerplate/redux/chat/chat_actions.dart';
import 'package:flutter_boilerplate/redux/company/company_selectors.dart';
import 'package:flutter_boilerplate/redux/profile/profile_actions.dart';
import 'package:flutter_boilerplate/redux/ui/ui_actions.dart';
import 'package:flutter_boilerplate/services/session_managment_service.dart';
import 'package:flutter_boilerplate/ui/app/live_text.dart';
import 'package:flutter_boilerplate/ui/app/scrollable_listview.dart';
import 'package:flutter_boilerplate/ui/dynamic_fields/dynamic_fields_presenter.dart';
import 'package:flutter_boilerplate/ui/dynamic_fields/dynamic_fields_view_edit.dart';
import 'package:flutter_boilerplate/ui/dynamic_fields/dynamic_fields_view_images.dart';
import 'package:flutter_boilerplate/ui/profile/view/profile_view_vm.dart';
import 'package:flutter_boilerplate/ui/app/view_scaffold.dart';
import 'package:flutter_boilerplate/ui/profile_operation/profile_operation_screen.dart';
import 'package:flutter_boilerplate/ui/profile_operation/view/profile_operation_view_vm.dart';
import 'package:flutter_boilerplate/utils/platforms.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/utils/completers.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';

// Import the profile operation actions
import 'package:flutter_boilerplate/redux/profile_operation/profile_operation_actions.dart';
import 'package:timeago/timeago.dart' as timeago;

Widget ProfileSharedView(BuildContext context, ProfileViewVM? profileViewModel,
    ProfileOperationViewVM? profileOperationViewVM, bool isFilter) {
  final profile = profileViewModel != null
      ? profileViewModel.profile
      : profileOperationViewVM!.profileOperation.profileEntity;
  final targetProfileId = profile!.id;
  // printL('profile== > $profile');
  List<String> imageUrls =
      profile.dynamicFields.getImages(DynamicFieldsConstants.images);
  String? fullName =
      profile.dynamicFields.getValue(DynamicFieldsConstants.name);
  final store = StoreProvider.of<AppState>(context);
  final appTheme =
      AppTheme.getThemeColors(store.state.prefState.enableDarkMode);
  final state = store.state;
  final String activeTab = state.profileOperationState.activeTab;
  final bool isFromLikedMeTab = activeTab == 'Liked Me';
  final bool isFromILikesTab = activeTab == 'I Liked';
  final bool isFromPassedTab = activeTab == 'Passes';

  bool showAcceptButton = false;
  bool showLikeButton = true;
  bool showPassButton = true;
  bool showChatButton = false;
  String alertMessage = '';

  final ProfileEntity? loggedInUserProfile = profileViewModel != null
      ? profileViewModel.state.profileState.loggedInUserProfile
      : profileOperationViewVM?.state.profileState.loggedInUserProfile;
  final String currentUserId = getLoggedInUserId(store);

  bool isOwnProfile = targetProfileId == currentUserId;

  // Check which tab we're coming from first
  if (isFromLikedMeTab && !isOwnProfile && profileOperationViewVM != null) {
    showAcceptButton = true;
    showLikeButton = false;
  }
  if (isFromILikesTab && !isOwnProfile && profileOperationViewVM != null) {
    showLikeButton = false;
    showPassButton = false;
  }
  if (isFromPassedTab && !isOwnProfile && profileOperationViewVM != null) {
    showLikeButton = true;
    showPassButton = false;
  }

  if (loggedInUserProfile != null && !isOwnProfile) {
    if (loggedInUserProfile.likesProfileMap.containsKey(targetProfileId)) {
      showLikeButton = false;
      showPassButton = false;
      alertMessage = ProjectConfig.alertMessageForLikeOrWave;
    }

    if (loggedInUserProfile.passesProfileMap.containsKey(targetProfileId)) {
      showLikeButton = true;
      showPassButton = false;
      alertMessage = 'You have already passed on this profile';
    }

    if (loggedInUserProfile.matchesProfileMap.containsKey(targetProfileId)) {
      showLikeButton = false;
      showPassButton = false;
      showAcceptButton = false;

      final matchOperation =
          loggedInUserProfile.matchesProfileMap[targetProfileId];
      if (matchOperation != null &&
          matchOperation.status == MatchStatus.matched) {
        showChatButton = true;
        alertMessage = ProjectConfig.alertMessageForMatchedOrWaved;
      } else if (matchOperation != null &&
          matchOperation.status == MatchStatus.pending) {
        if (matchOperation.createdUserId == currentUserId) {
          alertMessage = 'You have sent a match request to this profile';
        } else {
          showAcceptButton = true;
          alertMessage = 'This profile wants to match with you';
        }
      }
    }

    if (loggedInUserProfile.likedMeProfileMap.containsKey(targetProfileId)) {
      final operation = loggedInUserProfile.likedMeProfileMap[targetProfileId];
      if (operation != null && operation.status == MatchStatus.pending) {
        showAcceptButton = true;
        showLikeButton = false;
        alertMessage = ProjectConfig.alertMessageForLikedMeOrWavedMe;
      }
    }

    final state = store.state;
    final stateProfile = state.profileState.loggedInUserProfile;

    if (stateProfile.likesProfileMap.containsKey(targetProfileId) &&
        !loggedInUserProfile.likesProfileMap.containsKey(targetProfileId)) {
      showLikeButton = false;
      showPassButton = false;
      alertMessage = ProjectConfig.alertMessageForLikeOrWave;
    }

    if (stateProfile.passesProfileMap.containsKey(targetProfileId) &&
        !loggedInUserProfile.passesProfileMap.containsKey(targetProfileId)) {
      showLikeButton = true;
      showPassButton = false;
      alertMessage = 'You have already passed on this profile';
    }

    if (stateProfile.matchesProfileMap.containsKey(targetProfileId) &&
        !loggedInUserProfile.matchesProfileMap.containsKey(targetProfileId)) {
      final matchOperation = stateProfile.matchesProfileMap[targetProfileId];
      if (matchOperation != null &&
          matchOperation.status == MatchStatus.matched) {
        showLikeButton = false;
        showPassButton = false;
        showAcceptButton = false;
        showChatButton = true;
        alertMessage = ProjectConfig.alertMessageForMatchedOrWaved;
      }
    }

    if (stateProfile.likedMeProfileMap.containsKey(targetProfileId) &&
        !loggedInUserProfile.likedMeProfileMap.containsKey(targetProfileId)) {
      final operation = stateProfile.likedMeProfileMap[targetProfileId];
      if (operation != null && operation.status == MatchStatus.pending) {
        showAcceptButton = true;
        showLikeButton = false;
        alertMessage = ProjectConfig.alertMessageForLikedMeOrWavedMe;
      }
    }
  }

  if (profileOperationViewVM != null) {
    final operation = profileOperationViewVM.profileOperation;
    final int type = operation.type;
    final int status = operation.status;

    switch (type) {
      case ProfileOperationType.like:
        if (operation.createdUserId == currentUserId) {
          showLikeButton = false;
          showPassButton = false;
          alertMessage = ProjectConfig.alertMessageForLikeOrWave;
        }
        break;

      case ProfileOperationType.pass:
        if (operation.createdUserId == currentUserId) {
          showLikeButton = true;
          showPassButton = false;
          alertMessage = 'You have already passed on this profile';
        }
        break;

      case ProfileOperationType.block:
        if (operation.createdUserId == currentUserId) {
          showLikeButton = false;
          showPassButton = false;
          showAcceptButton = false;
          showChatButton = false;
          alertMessage = 'You have blocked this profile';
        }
        break;

      case ProfileOperationType.match:
        if ((status & MatchStatus.pending) == MatchStatus.pending) {
          if (operation.assignedUserId == currentUserId) {
            showAcceptButton = true;
            showLikeButton = false;
            alertMessage = 'This profile wants to match with you';
          } else if (operation.createdUserId == currentUserId) {
            showLikeButton = false;
            alertMessage = 'You have sent a match request to this profile';
          }
        }

        if ((status & MatchStatus.matched) == MatchStatus.matched) {
          showAcceptButton = false;
          showLikeButton = false;
          showPassButton = false;
          showChatButton = true;
          alertMessage = ProjectConfig.alertMessageForMatchedOrWaved;
        }
        break;
    }
  }

  if (isOwnProfile || ProjectConfig.showProfileOperationsButtons == false) {
    showLikeButton = false;
    showPassButton = false;
    showAcceptButton = false;
    showChatButton = false;
  }

  if (isAdmin(state) && !isOwnProfile) {
    showChatButton = true;
    showLikeButton = false;
  }

  void handleBackButton() {
    if (profileViewModel != null) {
      profileViewModel.onBackPressed();
    } else if (profileOperationViewVM != null) {
      profileOperationViewVM.onBackPressed();
    }
  }

  return ViewScaffold(
    isFilter: isFilter,
    entity: profile,
    title: fullName,
    isProfileOperation: profileOperationViewVM != null,
    isEditable: isOwnProfile,
    onBackPressed: handleBackButton,
    body: Stack(
      children: [
        ScrollableListView(
          children: <Widget>[
            const SizedBox(height: 16.0),
            if (imageUrls.isNotEmpty)
              Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 2,
                    child: DynamicFieldsViewImages(
                      viewType: ImageViewType.detail,
                      images: imageUrls,
                    ),
                  ),
                  if (alertMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 12.0),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: AppTheme.light.transparent,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: AppTheme.light.primary),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: AppTheme.light.primary,
                            ),
                            const SizedBox(width: 12.0),
                            Expanded(
                              child: Text(
                                alertMessage,
                                style: TextStyle(
                                  color: AppTheme.light.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            if (isAdmin(state) &&
                profile.isReported == true &&
                profile.reportedBy.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 12.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: (appTheme.primary).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: appTheme.primary),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.report_problem_outlined,
                            color: appTheme.primary,
                            size: 24,
                          ),
                          const SizedBox(width: 12.0),
                          Text(
                            'Profile Reported',
                            style: TextStyle(
                              color: appTheme.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12.0),
                      Text(
                        'This profile has been reported by ${profile.reportedBy.length} user(s)',
                        style: TextStyle(
                          color: appTheme.primary,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      if (profile.reportedBy.isNotEmpty)
                        ...profile.reportedBy.entries.map((entry) {
                          final ProfileReport reportData = entry.value;
                          String reason = reportData.comment;
                          final int timestamp = reportData.timestamp;
                          final DateTime reportDateTime =
                              timestamp > 100000000000
                                  ? DateTime.fromMillisecondsSinceEpoch(
                                      timestamp) // If in milliseconds
                                  : DateTime.fromMillisecondsSinceEpoch(
                                      timestamp * 1000);
                          if (reason.isEmpty) {
                            reason = 'No reason provided';
                          }

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Container(
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: appTheme.background,
                                borderRadius: BorderRadius.circular(6.0),
                                border: Border.all(color: appTheme.primary),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Reason: $reason',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                  LiveText(
                                    () => timeago.format(
                                      reportDateTime,
                                      locale:
                                          '${localeSelector(store.state, twoLetter: true)}_short',
                                    ),
                                    duration: Duration(minutes: 1),
                                    maxLines: 2,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                    ],
                  ),
                ),
              ),
            buildFormattedDataView(profile, context),
            const SizedBox(height: 80.0),
          ],
        ),
        if (showPassButton ||
            showLikeButton ||
            showAcceptButton ||
            showChatButton)
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (showPassButton && ProjectConfig.canUserPassProfiles)
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          final store = StoreProvider.of<AppState>(context);
                          final completer =
                              snackBarCompleter<void>('Passed this profile');

                          final profileState = store.state.profileState;
                          final passedProfileIndex =
                              profileState.list.indexOf(targetProfileId);
                          store.dispatch(PassProfileRequest(
                            completer: completer,
                            targetUserId: targetProfileId,
                          ));
                          store.dispatch(LoadSingleProfileRequest(
                            completer: completer,
                            filter: profileState.filter,
                            lastDocument: profileState.lastDocument,
                            insertIndex: passedProfileIndex >= 0
                                ? passedProfileIndex
                                : null,
                          ));
                          completer.future.then((_) {
                            store.dispatch(UpdateCurrentRoute(
                                store.state.uiState.previousRoute));
                            if (isMobile(navigatorKey.currentContext!)) {
                              Navigator.of(context).pop();
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(20),
                          backgroundColor: Colors.white,
                          elevation: 5,
                        ),
                        child: Icon(
                          Icons.close,
                          color: appTheme.danger,
                          size: 30,
                        ),
                      ),
                    ),
                  if (showLikeButton)
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          final store = StoreProvider.of<AppState>(context);
                          final completer = snackBarCompleter<void>(
                              ProjectConfig.likeOrWaveRequestSent);

                          store.dispatch(LikeProfileRequest(
                            completer: completer,
                            targetUserId: targetProfileId,
                            type: LikeType.normal,
                          ));

                          final profileState = store.state.profileState;
                          final passedProfileIndex =
                              profileState.list.indexOf(targetProfileId);
                          store.dispatch(LoadSingleProfileRequest(
                            completer: completer,
                            filter: profileState.filter,
                            lastDocument: profileState.lastDocument,
                            insertIndex: passedProfileIndex >= 0
                                ? passedProfileIndex
                                : null,
                          ));
                          completer.future.then((_) {
                            store.dispatch(UpdateCurrentRoute(
                                store.state.uiState.previousRoute));
                            if (isMobile(navigatorKey.currentContext!)) {
                              Navigator.of(context).pop();
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(20),
                          backgroundColor: Colors.white,
                          elevation: 5,
                        ),
                        child: Icon(
                          ProjectConfig.likeOrWaveIcon,
                          color: appTheme.success,
                          size: 30,
                        ),
                      ),
                    ),
                  if (showAcceptButton)
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          final store = StoreProvider.of<AppState>(context);
                          final completer = snackBarCompleter<void>(
                              'Match request accepted!');

                          store.dispatch(AcceptMatchRequest(
                            completer: completer,
                            targetUserId: targetProfileId,
                          ));
                          completer.future.then((_) {
                            store.dispatch(UpdateCurrentRoute(
                                ProfileOperationScreen.route));
                            if (store.state.prefState.isMobile) {
                              navigatorKey.currentState!
                                  .pushNamedAndRemoveUntil(
                                      ProfileOperationScreen.route,
                                      (Route<dynamic> route) => false);
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(20),
                          backgroundColor: Colors.white,
                          elevation: 5,
                        ),
                        child: const Icon(
                          Icons.check_circle_outline,
                          color: Colors.green,
                          size: 30,
                        ),
                      ),
                    ),
                  if (showChatButton && ProjectConfig.showProfileChatOperationButtons)
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          final String userEmail = profile.email;

                          if (userEmail.isNotEmpty) {
                            final store = StoreProvider.of<AppState>(context);
                            final completer = Completer<void>();

                            store.dispatch(CreateOrOpenChatRequest(
                                context: context,
                                targetEmail: userEmail,
                                completer: completer));

                            completer.future.then((_) {}).catchError((error) {
                              printL('Error opening chat: $error');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Error opening chat: ${error.toString()}'),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Cannot open chat: Email address not available for ${profile.name}'),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(20),
                          backgroundColor: Colors.white,
                          elevation: 5,
                        ),
                        child: const Icon(
                          Icons.chat_bubble_outline,
                          color: Colors.blue,
                          size: 30,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
      ],
    ),
  );
}
