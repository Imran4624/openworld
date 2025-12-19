// Package imports:
import 'package:built_collection/built_collection.dart';
import 'package:flutter_boilerplate/redux/design/design_state.dart';
import 'package:flutter_boilerplate/redux/user/user_state.dart';
import 'package:flutter_boilerplate/ui/photo/photo_screen.dart';
import 'package:flutter_boilerplate/ui/social/social_screen.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:flutter_boilerplate/data/models/entities.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/redux/company/company_actions.dart';
import 'package:flutter_boilerplate/redux/dashboard/dashboard_actions.dart';
import 'package:flutter_boilerplate/redux/dashboard/dashboard_reducer.dart';
import 'package:flutter_boilerplate/redux/design/design_reducer.dart';
import 'package:flutter_boilerplate/redux/settings/settings_reducer.dart';
import 'package:flutter_boilerplate/redux/ui/ui_actions.dart';
import 'package:flutter_boilerplate/redux/ui/ui_state.dart';
import 'package:flutter_boilerplate/redux/user/user_reducer.dart';
import 'package:flutter_boilerplate/utils/platforms.dart';
import 'package:flutter_boilerplate/utils/web_stub.dart'
    if (dart.library.html) 'package:flutter_boilerplate/utils/web.dart';

// STARTER: import - do not remove comment
import 'package:flutter_boilerplate/redux/payment/payment_reducer.dart';
import 'package:flutter_boilerplate/redux/payment/payment_state.dart';

import 'package:flutter_boilerplate/redux/product/product_reducer.dart';
import 'package:flutter_boilerplate/redux/product/product_state.dart';

import 'package:flutter_boilerplate/redux/social/social_reducer.dart';
import 'package:flutter_boilerplate/redux/social/social_state.dart';

import 'package:flutter_boilerplate/redux/photo/photo_reducer.dart';
import 'package:flutter_boilerplate/redux/photo/photo_state.dart';

import 'package:flutter_boilerplate/redux/workout/workout_reducer.dart';
import 'package:flutter_boilerplate/redux/workout/workout_state.dart';

import 'package:flutter_boilerplate/redux/notification/notification_reducer.dart';
import 'package:flutter_boilerplate/redux/notification/notification_state.dart';

import 'package:flutter_boilerplate/redux/profile_operation/profile_operation_reducer.dart';
import 'package:flutter_boilerplate/redux/profile_operation/profile_operation_state.dart';

import 'package:flutter_boilerplate/redux/profile/profile_reducer.dart';
import 'package:flutter_boilerplate/redux/profile/profile_state.dart';

import 'package:flutter_boilerplate/redux/event/event_reducer.dart';
import 'package:flutter_boilerplate/redux/event/event_state.dart';

import 'package:flutter_boilerplate/redux/chat/chat_reducer.dart';
import 'package:flutter_boilerplate/redux/chat/chat_state.dart';

UIState uiReducer(UIState state, dynamic action) {
  final currentRoute = currentRouteReducer(state.currentRoute, action);
  return state.rebuild((b) => b
    ..filter = filterReducer(state.filter, action)
    ..filterClearedAt = filterClearedAtReducer(state.filterClearedAt, action)
    ..lastActivityAt = lastActivityReducer(state.lastActivityAt, action)
    ..dismissedFlutterWebWarning = dismissedFlutterWebWarningReducer(
        state.dismissedFlutterWebWarning, action)
    ..selectedCompanyIndex =
        selectedCompanyIndexReducer(state.selectedCompanyIndex, action)
    ..previousRoute = state.currentRoute == currentRoute
        ? state.previousRoute
        : state.currentRoute.endsWith('edit')
            ? state.previousRoute
            : state.currentRoute
    ..loadingEntityType =
        loadingEntityTypeReducer(state.loadingEntityType, action)
    ..currentRoute = currentRoute
    ..previewStack.replace(previewStackReducer(state.previewStack, action))
    ..filterStack.replace(filterStackReducer(state.filterStack, action))
    ..dashboardUIState
        .replace(dashboardUIReducer(state.dashboardUIState, action))
    // STARTER: reducer - do not remove comment
    ..paymentUIState.replace(
        paymentUIReducer(state.paymentUIState, action) as PaymentUIState)
    ..productUIState.replace(
        productUIReducer(state.productUIState, action) as ProductUIState)
    ..socialUIState
        .replace(socialUIReducer(state.socialUIState, action) as SocialUIState)
    ..photoUIState
        .replace(photoUIReducer(state.photoUIState, action) as PhotoUIState)
    ..workoutUIState.replace(
        workoutUIReducer(state.workoutUIState, action) as WorkoutUIState)
    ..notificationUIState.replace(
        notificationUIReducer(state.notificationUIState, action)
            as NotificationUIState)
    ..profileOperationUIState.replace(
        profileOperationUIReducer(state.profileOperationUIState, action)
            as ProfileOperationUIState)
    ..profileUIState.replace(
        profileUIReducer(state.profileUIState, action) as ProfileUIState)
    ..eventUIState
        .replace(eventUIReducer(state.eventUIState, action) as EventUIState)
    ..chatUIState
        .replace(chatUIReducer(state.chatUIState, action) as ChatUIState)
    ..designUIState
        .replace(designUIReducer(state.designUIState, action) as DesignUIState)
    ..userUIState
        .replace(userUIReducer(state.userUIState, action) as UserUIState)
    ..settingsUIState
        .replace(settingsUIReducer(state.settingsUIState, action)));
}

Reducer<int> lastActivityReducer = combineReducers([
  TypedReducer<int, UpdateCurrentRoute>((state, action) {
    return DateTime.now().millisecondsSinceEpoch;
  }),
]);

Reducer<bool> dismissedFlutterWebWarningReducer = combineReducers([
  TypedReducer<bool, DismissFlutterWebWarning>((state, action) {
    return true;
  }),
]);

Reducer<String?> filterReducer = combineReducers([
  TypedReducer<String?, FilterCompany>((filter, action) {
    return action.filter;
  }),
  TypedReducer<String?, ViewDashboard>((state, action) {
    return action.filter;
  }),
]);

Reducer<EntityType?> loadingEntityTypeReducer = combineReducers([
  TypedReducer<EntityType?, StopLoading>((state, action) {
    return null;
  }),
]);

Reducer<int> filterClearedAtReducer = combineReducers([
  TypedReducer<int, FilterCompany>((filterClearedAt, action) {
    return action.filter == null
        ? DateTime.now().millisecondsSinceEpoch
        : filterClearedAt;
  }),
  TypedReducer<int, ViewDashboard>((state, action) {
    return DateTime.now().millisecondsSinceEpoch;
  }),
]);

Reducer<String> currentRouteReducer = combineReducers([
  TypedReducer<String, UpdateCurrentRoute>((currentRoute, action) {
    if (isWeb()) {
      if (action.route.startsWith(PhotoScreen.route) ||
          action.route.startsWith(SocialScreen.route)) {
        return action.route;
      }
      String routeToUpdate;

      if (action.route.startsWith('http')) {
        final hashIndex = action.route.indexOf('#');
        if (hashIndex != -1 && hashIndex < action.route.length - 1) {
          final fragment = action.route.substring(hashIndex + 1);
          routeToUpdate = '#$fragment';
        } else {
          routeToUpdate = action.route;
        }
      } else {
        routeToUpdate =
            action.route.startsWith('#') ? action.route : '#${action.route}';
      }
      WebUtils.updateBrowserUrl(routeToUpdate);
    }

    return action.route;
  }),
]);

Reducer<String> previousRouteReducer = combineReducers([
  TypedReducer<String, UpdateCurrentRoute>((currentRoute, action) {
    return currentRoute;
  }),
]);

Reducer<int> selectedCompanyIndexReducer = combineReducers([
  TypedReducer<int, SelectCompany>((selectedCompanyIndex, action) {
    return action.companyIndex;
  }),
]);

Reducer<BuiltList<EntityType>> previewStackReducer = combineReducers([
  TypedReducer<BuiltList<EntityType>, PreviewEntity>((previewStack, action) {
    if (action.entityType == null) {
      return previewStack;
    }

    if (previewStack.isNotEmpty && previewStack.last == action.entityType) {
      return BuiltList(<EntityType>[]);
    }

    return BuiltList(<EntityType?>[
      ...previewStack.where((entityType) => entityType != action.entityType),
      action.entityType
    ]);
  }),
  TypedReducer<BuiltList<EntityType>, ClearPreviewStack>(
      (previewStack, action) {
    return BuiltList(<EntityType>[]);
  }),
  TypedReducer<BuiltList<EntityType>, PopPreviewStack>((previewStack, action) {
    return BuiltList(
        <EntityType>[...previewStack.sublist(0, previewStack.length - 1)]);
  }),
]);

Reducer<BuiltList<BaseEntity>> filterStackReducer = combineReducers([
  TypedReducer<BuiltList<BaseEntity>, ClearEntityFilter>((filterStack, action) {
    return BuiltList<BaseEntity>();
  }),
  TypedReducer<BuiltList<BaseEntity>, FilterByEntity>((filterStack, action) {
    if (filterStack.isNotEmpty) {
      if (action.entityId == filterStack.last.id &&
          action.entityType == filterStack.last.entityType) {
        return BuiltList<BaseEntity>();
      }
    }
    return BuiltList(<BaseEntity?>[
      ...filterStack.where((entity) => entity.entityType != action.entityType),
      action.entity
    ]);
  }),
  TypedReducer<BuiltList<BaseEntity>, PopFilterStack>((filterStack, action) {
    return BuiltList(
        <BaseEntity>[...filterStack.sublist(0, filterStack.length - 1)]);
  }),
]);
