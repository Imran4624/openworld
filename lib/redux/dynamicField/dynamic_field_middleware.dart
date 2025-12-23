import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/data/models/dynamic_fields/dynamic_fields_modal.dart';
import 'package:flutter_boilerplate/data/models/entities.dart';
import 'package:flutter_boilerplate/data/repositories/dynamicFields/dynamic_fields_repository.dart';
import 'package:flutter_boilerplate/main_app.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/dynamicField/dynamic_field_actions.dart';
import 'package:flutter_boilerplate/redux/profile/profile_actions.dart';
import 'package:flutter_boilerplate/redux/ui/ui_actions.dart';
import 'package:flutter_boilerplate/services/session_managment_service.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'package:flutter_boilerplate/ui/dashboard/dashboard_screen_vm.dart';
import 'package:flutter_boilerplate/ui/dynamic_fields/dynamic_fields_create.dart';
import 'package:flutter_boilerplate/ui/dynamic_fields/dynamic_fields_search_overview_screen.dart';
import 'package:flutter_boilerplate/ui/dynamic_fields/dynamic_fields_view_edit.dart';
import 'package:flutter_boilerplate/ui/profile/view/profile_view_vm.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createDynamicFieldMiddleware([
  DynamicFieldRepository repository = const DynamicFieldRepository(),
]) {
  final viewDynamicFields = _viewDynamicFields();
  final viewSearchScreen = _viewSearchScreen();
  final loadQuestions = _loadQuestions();
  final loadAnswers = _getAnswers(repository);
  final submitAnswers = _submitAnswers();
  final saveProfileDetails = _saveProfileMiddleware(repository);

  return [
    TypedMiddleware<AppState, ViewDynamicFields>(viewDynamicFields),
    TypedMiddleware<AppState, ViewSearchScreen>(viewSearchScreen),
    TypedMiddleware<AppState, LoadQuestions>(loadQuestions),
    TypedMiddleware<AppState, LoadAnswers>(loadAnswers),
    TypedMiddleware<AppState, SubmitAction>(submitAnswers),
    TypedMiddleware<AppState, SaveDynamicFieldDetails>(saveProfileDetails),
  ];
}

Middleware<AppState> _viewDynamicFields() {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as ViewDynamicFields;

    next(action);

    String route;

    route =
        action.isEdit ? EditOverviewScreen.route : DynamicFieldsCreate.route;

    store.dispatch(UpdateCurrentRoute(route));

    if (store.state.prefState.isMobile) {
      navigatorKey.currentState!.pushNamed(route);
    }
    if (action.isEdit) {
      final completer = Completer<Null>();
      store.dispatch(LoadAnswers(completer, action.questionType));
    } else {
      store.dispatch(LoadAnswersSuccess({}));
    }

    store.dispatch(LoadQuestions(action.questionType));
  };
}

Middleware<AppState> _viewSearchScreen() {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as ViewSearchScreen;

    next(action);

    store.dispatch(UpdateCurrentRoute(SearchOverviewScreen.route));

    if (store.state.prefState.isMobile) {
      navigatorKey.currentState!.pushNamedAndRemoveUntil(
        SearchOverviewScreen.route,
        (Route<dynamic> route) => false,
      );
    }

    // store.dispatch(LoadQuestions(action.questionType));
  };
}

Middleware<AppState> _saveProfileMiddleware(DynamicFieldRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) async {
    if (action is SaveDynamicFieldDetails) {
      try {
        final userId = getLoggedInUserId(store);
        var dynamicFieldsData = action.dynamicFieldsData;

        final profileUIState = store.state.profileUIState;

        final currentProfile = profileUIState.editing;

        if (currentProfile == null) {
          logError("Error: No profile is being edited.");
          return;
        }

        final updatedProfile = currentProfile
            .rebuild((b) => b..dynamicFields.replace(dynamicFieldsData));
        final completer = Completer();
        if (action.entityType == EntityType.profile) {
          store.dispatch(SaveProfileRequest(
              completer: completer, profile: updatedProfile));
        } else {
          await repository.saveData(
              userId,
              dynamicFieldsData,
              store.state.dynamicFieldState.questionGroupType,
              action.entityType);

          store.dispatch(ProfileSavedAction());
          if (store.state.prefState.isMobile) {
            if (action.entityType == EntityType.profile) {
              navigatorKey.currentState!.pushNamed((ProfileViewScreen.route));
            } else {
              navigatorKey.currentState?.pop();
            }
          } else {
            store.dispatch(UpdateCurrentRoute(
                action.entityType == EntityType.profile
                    ? ProfileViewScreen.route
                    : DashboardScreenBuilder.route));
          }
        }
      } catch (e) {
        logError("Error saving profile data: $e");
      }
    }

    next(action);
  };
}

Middleware<AppState> _loadQuestions() {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as LoadQuestions;

    next(action);

    final questionGroups =
        QuestionGroupModel.fromQuestionList(action.questionType);
    store.dispatch(LoadQuestionsSuccess(questionGroups, action.questionType));
  };
}

Middleware<AppState> _submitAnswers() {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as SubmitAction;

    next(action);

    final flatData = <String, dynamic>{};
    store.state.dynamicFieldState.answers.forEach((groupName, groupAnswers) {
      groupAnswers.forEach((key, value) {
        flatData[key] = value;
      });
    });

    // Handle the submission logic here, e.g., API call or local storage
    logInfo('Submitting answers: $flatData');
  };
}

Middleware<AppState> _getAnswers(DynamicFieldRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction,
      NextDispatcher next) async {
    final action = dynamicAction as LoadAnswers;

    next(action);

    final String currentUserId = getLoggedInUserId(store);

    try {
      final userProfileDetail =
          await repository.loadItem(currentUserId, action.questionType);

      if (userProfileDetail != null) {
        final Map<String, dynamic> userProfileData =
            userProfileDetail as Map<String, dynamic>;

        logInfo('User Profile Data: $userProfileData');
        store.dispatch(LoadAnswersSuccess(userProfileData));
        action.completer.complete(null);
      } else {
        logInfo('No user profile found for userId: $currentUserId');
      }
    } catch (e) {
      logError('Error fetching user profile: $e');
    }
  };
}
