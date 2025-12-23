// Package imports:
import 'package:flutter_boilerplate/redux/dynamicField/dynamic_field_reducer.dart';
import 'package:flutter_boilerplate/redux/user/user_reducer.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/company/company_actions.dart';
import 'package:flutter_boilerplate/redux/company/company_state.dart';
import 'package:flutter_boilerplate/redux/settings/settings_actions.dart';

// STARTER: import - do not remove comment
import 'package:flutter_boilerplate/redux/payment/payment_reducer.dart';

import 'package:flutter_boilerplate/redux/product/product_reducer.dart';

import 'package:flutter_boilerplate/redux/photo/photo_reducer.dart';

import 'package:flutter_boilerplate/redux/notification/notification_reducer.dart';

import 'package:flutter_boilerplate/redux/profile_operation/profile_operation_reducer.dart';

import 'package:flutter_boilerplate/redux/profile/profile_reducer.dart';

import 'package:flutter_boilerplate/redux/event/event_reducer.dart';

import 'package:flutter_boilerplate/redux/chat/chat_reducer.dart';

UserCompanyState companyReducer(UserCompanyState state, dynamic action) {
  if (action is DeleteCompanySuccess) {
    return UserCompanyState(false);
  }

  return state.rebuild((b) => b
    ..lastUpdated = lastUpdatedReducer(state.lastUpdated, action)
    ..selectedCompanyId = selectedCompanyIdReducer(state.selectedCompanyId, action)
    ..userCompany.replace(userCompanyEntityReducer(state.userCompany, action)!)
    // STARTER: reducer - do not remove comment
    ..paymentState.replace(paymentsReducer(state.paymentState, action))
    ..productState.replace(productsReducer(state.productState, action))
    ..photoState.replace(photosReducer(state.photoState, action))
    ..notificationState
        .replace(notificationsReducer(state.notificationState, action))
    ..profileOperationState
        .replace(profileOperationsReducer(state.profileOperationState, action))
    ..profileState.replace(profilesReducer(state.profileState, action))
    ..userState.replace(usersReducer(state.userState, action))
    ..eventState.replace(eventsReducer(state.eventState, action))
    ..chatState.replace(chatsReducer(state.chatState, action))
    ..dynamicFieldState
        .replace(dynamicFieldReducer(state.dynamicFieldState, action)));
}

Reducer<UserCompanyEntity?> userCompanyEntityReducer = combineReducers([
  TypedReducer<UserCompanyEntity?, LoadCompanySuccess>(
      loadCompanySuccessReducer),
  TypedReducer<UserCompanyEntity?, SaveCompanySuccess>(
      saveCompanySuccessReducer),
  TypedReducer<UserCompanyEntity?, SaveEInvoiceCertificateSuccess>(
      (userCompany, action) {
    return userCompany!.rebuild((b) => b);
  }),
  TypedReducer<UserCompanyEntity?, SaveAuthUserSuccess>(
    (userCompany, action) => userCompany!.rebuild((b) => b
      ..user.replace(action.user)
      ..settings.replace(action.user.userCompany!.settings)),
  ),
  TypedReducer<UserCompanyEntity?, ConnectOAuthUserSuccess>(
    (userCompany, action) =>
        userCompany!.rebuild((b) => b..user.replace(action.user)),
  ),
  TypedReducer<UserCompanyEntity?, ConnecGmailUserSuccess>(
    (userCompany, action) =>
        userCompany!.rebuild((b) => b..user.replace(action.user)),
  ),
  TypedReducer<UserCompanyEntity?, DisconnectOAuthUserSuccess>(
    (userCompany, action) =>
        userCompany!.rebuild((b) => b..user.replace(action.user)),
  ),
  TypedReducer<UserCompanyEntity?, DisconnectOAuthMailerSuccess>(
    (userCompany, action) =>
        userCompany!.rebuild((b) => b..user.replace(action.user)),
  ),
  TypedReducer<UserCompanyEntity?, DisableTwoFactorSuccess>(
    (userCompany, action) =>
        userCompany!.rebuild((b) => b..user.isTwoFactorEnabled = false),
  ),
  TypedReducer<UserCompanyEntity?, SaveUserSettingsSuccess>(
      (userCompany, action) => userCompany!
          .rebuild((b) => b..settings.replace(action.userCompany.settings))),
  TypedReducer<UserCompanyEntity?, UpdateCompanyLanguage>(
    (userCompany, action) => userCompany!
        .rebuild((b) => b..company.settings.languageId = action.languageId),
  ),
]);

UserCompanyEntity loadCompanySuccessReducer(
    UserCompanyEntity? company, LoadCompanySuccess action) {
  var userCompany = action.userCompany;

  userCompany;

  /*

  return userCompany;

  if (userCompany.company.taskStatuses != null) {
    userCompany = userCompany
      ..company.rebuild((b) => b
        ..taskStatusMap.addAll(Map.fromIterable(
          userCompany.company.taskStatuses,
          key: (dynamic item) => item.id,
          value: (dynamic item) => item,
        )));
  }

  if (userCompany.company.expenseCategories != null) {
    userCompany = userCompany
      ..company.rebuild((b) => b
        ..expenseCategoryMap.addAll(Map.fromIterable(
          userCompany.company.expenseCategories,
          key: (dynamic item) => item.id,
          value: (dynamic item) => item,
        )));
  }
  */

  // clear all sub-data
  userCompany = userCompany
      .rebuild((b) => b..company.replace(userCompany.company.coreCompany));

  return userCompany;
}

UserCompanyEntity saveCompanySuccessReducer(
    UserCompanyEntity? userCompany, SaveCompanySuccess action) {
  final company = action.company
      .rebuild((b) => b..users.replace(userCompany!.company.users));

  userCompany = userCompany!.rebuild((b) => b..company.replace(company));

  return userCompany;
}

Reducer<int> lastUpdatedReducer = combineReducers([
  TypedReducer<int, LoadCompanySuccess>((state, action) {
    return action.userCompany.company.isLarge && state == 0
        ? 0
        : DateTime.now().millisecondsSinceEpoch;
  }),
]);

Reducer<String> selectedCompanyIdReducer = combineReducers([
  TypedReducer<String, SelectCompanyById>((state, action) {
    return action.companyId;
  }),
  TypedReducer<String, LoadCompanySuccess>((state, action) {
    return action.userCompany.company.id;
  }),
]);
