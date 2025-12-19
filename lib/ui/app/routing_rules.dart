import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/data/models/entities.dart';
import 'package:flutter_boilerplate/data/models/profile_model.dart';
import 'package:flutter_boilerplate/main_app.dart';
import 'package:flutter_boilerplate/project_config.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/auth/auth_actions.dart';
import 'package:flutter_boilerplate/redux/profile/profile_actions.dart';
import 'package:flutter_boilerplate/redux/ui/pref_state.dart';
import 'package:flutter_boilerplate/redux/ui/ui_actions.dart';
import 'package:flutter_boilerplate/ui/app/pending_approval_screen.dart';
import 'package:flutter_boilerplate/ui/dynamic_fields/dynamic_field_load_questions.dart';
import 'package:flutter_boilerplate/ui/event/view/event_view_vm.dart';
import 'package:flutter_boilerplate/utils/platforms.dart';
import 'package:flutter_boilerplate/utils/web_stub.dart'
    if (dart.library.html) 'package:flutter_boilerplate/utils/web.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'dart:async';

class RoutingRules {
  static void onRefreshRouting(AppLayout appLayout) {
    final store = StoreProvider.of<AppState>(navigatorKey.currentContext!);
    final authState = store.state.authState;

    // Check if we're on web and have a URL with an entity ID that should be preserved
    if (isWeb()) {
      final path = WebUtils.browserRoute;
      final id = WebUtils.getUrlParameter('id');

      if (id != null && id.isNotEmpty && path != null && path.isNotEmpty) {
        String routePath = path;
        if (path.contains('?')) {
          routePath = path.split('?')[0];
        }

        if (routePath == EventViewScreen.route) {
          fetchAndViewEntity(
              store: store, entityType: EntityType.event, entityId: id);
          return;
        }
      }
    }

    // if (appLayout == AppLayout.mobile) {
    if (authState.setProfileCompleted) {
      if (authState.isArchived) {
        if (appLayout == AppLayout.mobile) {
          navigatorKey.currentState!.pushNamedAndRemoveUntil(
            ApprovalPendingScreen.route,
            (Route<dynamic> route) => false,
          );
        } else {
          store.dispatch(UpdateCurrentRoute(ApprovalPendingScreen.route));
        }
      } else {
        final entityType = ProjectConfig.showDashboard &&
                store.state.userCompany.canViewDashboard
            ? EntityType.dashboard
            : ProjectConfig.defaultEntityForLoggedInUser;
        viewEntitiesByType(entityType: entityType);
      }
    } else {
      final completer = Completer();
      loadDynamicFieldQuestions(ProjectConfig.onBoardingQuestionType,
          completer: completer);
      completer.future.then((_) {
        createEntityByType(
          context: navigatorKey.currentContext!,
          force: true,
          entityType: EntityType.profile,
        );
      });
    }
    //   bool isFirst = true;
    //   routes.forEach((route) {
    //     if (isFirst) {
    //       navigatorKey.currentState!.pushReplacementNamed(route);
    //     } else {
    //       if ( store.state.authState.setProfileCompleted) {
    //        printL(' Mobile current route is$route');
    //       } else {
    //       navigatorKey.currentState!.pushNamed(route);
    //       }
    //     }
    //     isFirst = false;
    //   });
    // } else {

    //   if (routes.isEmpty || routes.last == DashboardScreenBuilder.route) {
    //     final entityType = store.state.userCompany.canViewDashboard
    //             ? EntityType.dashboard
    //             : ProjectConfig.defaultEntityToLoadAfterLogin;
    //         viewEntitiesByType(entityType: entityType);
    //   } else {
    //     if (store.state.authState.setProfileCompleted) {
    //        printL(' Web current route is${routes.first}');
    //       store.dispatch(UpdateCurrentRoute(routes.first));
    //     } else {
    //       store.dispatch(UpdateCurrentRoute(routes.last));
    //     }
    //   }
    if (appLayout == AppLayout.desktop) {
      store.dispatch(ViewMainScreen());
    }
    // }
  }

  static void navigationForArchivedUser(ProfileEntity profile) {
    final store = StoreProvider.of<AppState>(navigatorKey.currentContext!);
    if (profile.isArchived) {
      if (isNotMobile(navigatorKey.currentContext!)) {
        store.dispatch(UpdateCurrentRoute(ApprovalPendingScreen.route));
      } else {
        navigatorKey.currentState!.pushNamedAndRemoveUntil(
          ApprovalPendingScreen.route,
          (Route<dynamic> route) => false,
        );
      }
    } else {
      if (ProjectConfig.defaultNewUserStatus() != kEntityStateActive &&
          profile.isNew) {
        if (isNotMobile(navigatorKey.currentContext!)) {
          store.dispatch(UpdateCurrentRoute(ApprovalPendingScreen.route));
        } else {
          navigatorKey.currentState!.pushNamedAndRemoveUntil(
            ApprovalPendingScreen.route,
            (Route<dynamic> route) => false,
          );
        }
      } else {
        store.dispatch(ViewProfile(profileId: profile.id, force: true));
      }
    }
  }

  static void defaultEntityLoadingRouting() {
    final store = StoreProvider.of<AppState>(navigatorKey.currentContext!);
    final entityType =
        ProjectConfig.showDashboard && store.state.userCompany.canViewDashboard
            ? EntityType.dashboard
            : ProjectConfig.defaultEntityForLoggedInUser;

    if (store.state.profileState.loggedInUserProfile.isArchived) {
      navigationForArchivedUser(store.state.profileState.loggedInUserProfile);
    } else {
      viewEntitiesByType(entityType: entityType);
    }
  }

  static void profileCompletionRouting(
      bool isUserArchived,
      bool isProfileCompleted,
      BuildContext context,
      CheckProfileCompletionRequest action) {
    final store = StoreProvider.of<AppState>(context);

    if (isUserArchived && !action.isSignUp) {
      store.dispatch(SetArchivedUserStatus(isUserArchived));
      if (isNotMobile(context)) {
        store.dispatch(UpdateCurrentRoute(ApprovalPendingScreen.route));
      } else {
        navigatorKey.currentState!.pushNamedAndRemoveUntil(
          ApprovalPendingScreen.route,
          (Route<dynamic> route) => false,
        );
      }
    } else {
      if (isProfileCompleted) {
        store.dispatch(UpdateProfileCompletionStatusSuccess());
        final entityType = ProjectConfig.showDashboard &&
                store.state.userCompany.canViewDashboard
            ? EntityType.dashboard
            : ProjectConfig.defaultEntityForLoggedInUser;
        viewEntitiesByType(entityType: entityType);
      } else {
        final completer = Completer();
        loadDynamicFieldQuestions(ProjectConfig.onBoardingQuestionType,
            completer: completer);
        completer.future.then((_) {
          createEntityByType(
            context: context,
            force: true,
            entityType: EntityType.profile,
          );
        });
      }
    }
  }
}
