// Package imports:
import 'package:built_collection/built_collection.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/user/user_actions.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/app/loading_reducer.dart';
import 'package:flutter_boilerplate/redux/auth/auth_actions.dart';
import 'package:flutter_boilerplate/redux/auth/auth_reducer.dart';
import 'package:flutter_boilerplate/redux/company/company_actions.dart';
import 'package:flutter_boilerplate/redux/company/company_reducer.dart';
import 'package:flutter_boilerplate/redux/company/company_state.dart';
import 'package:flutter_boilerplate/redux/design/design_actions.dart';
import 'package:flutter_boilerplate/redux/static/static_reducer.dart';
import 'package:flutter_boilerplate/redux/ui/pref_reducer.dart';
import 'package:flutter_boilerplate/redux/ui/ui_reducer.dart';

// STARTER: import - do not remove comment
import 'package:flutter_boilerplate/redux/payment/payment_actions.dart';

import 'package:flutter_boilerplate/redux/product/product_actions.dart';


import 'package:flutter_boilerplate/redux/photo/photo_actions.dart';

import 'package:flutter_boilerplate/redux/notification/notification_actions.dart';

import 'package:flutter_boilerplate/redux/profile_operation/profile_operation_actions.dart';

import 'package:flutter_boilerplate/redux/profile/profile_actions.dart';


import 'package:flutter_boilerplate/redux/chat/chat_actions.dart';

// We create the State reducer by combining many smaller reducers into one!
AppState appReducer(AppState state, dynamic action) {
  if (action is UserLogout) {
    return AppState(
            prefState: state.prefState,
            isWhiteLabeled: state.isWhiteLabeled,
            reportErrors: state.account.reportErrors)
        .rebuild((b) => b
          ..authState.replace(state.authState.rebuild((b) => b
            ..isAuthenticated = false
            ..lastEnteredPasswordAt = 0))
          ..isTesting = state.isTesting);
  } else if (action is LoadStateSuccess) {
    return action.state.rebuild((b) => b
      ..isLoading = false
      ..isSaving = false);
  } else if (action is ClearData) {
    return state.rebuild((b) => b
      ..userCompanyStates[state.uiState.selectedCompanyIndex] =
          UserCompanyState(state.account.reportErrors));
  } else if (action is UpdateAppVersionSuccess) {
    return state.rebuild((b) => b..appVersion = action.appVersion.toBuilder());
  }

  return state.rebuild((b) => b
    ..isLoading = loadingReducer(state.isLoading, action)
    ..isSaving = savingReducer(state.isSaving, action)
    ..lastError = lastErrorReducer(state.lastError, action)
    ..authState.replace(authReducer(state.authState, action))
    ..staticState.replace(staticReducer(state.staticState, action))
    ..userCompanyStates[state.uiState.selectedCompanyIndex] = companyReducer(
        state.userCompanyStates[state.uiState.selectedCompanyIndex], action)
    ..companies.replace(companiesReducer(state.companies, action))
    ..uiState.replace(uiReducer(state.uiState, action))
    ..prefState
        .replace(prefReducer(state.prefState, action, state.company.id)));
}

final lastErrorReducer = combineReducers<String>([
  TypedReducer<String, ClearLastError>((state, action) {
    return '';
  }),

  // STARTER: errors - do not remove comment
  TypedReducer<String, LoadPaymentsFailure>((state, action) {
    return '${action.error}';
  }),

  TypedReducer<String, LoadProductsFailure>((state, action) {
    return '${action.error}';
  }),

  TypedReducer<String, LoadPhotosFailure>((state, action) {
    return '${action.error}';
  }),

  TypedReducer<String, LoadNotificationsFailure>((state, action) {
    return '${action.error}';
  }),

  TypedReducer<String, LoadProfileOperationsFailure>((state, action) {
    return '${action.error}';
  }),

  TypedReducer<String, UpdateAppVersionSuccess>((state, action) {
    logInfo('App version update success: ${action.appVersion.latest}');
    return '';
  }),

  TypedReducer<String, UpdateAppVersionFailure>((state, action) {
    logError('App version update failure: ${action.error}');
    return '';
  }),

  TypedReducer<String, LoadProfilesFailure>((state, action) {
    return '${action.error}';
  }),

  TypedReducer<String, LoadUsersFailure>((state, action) {
    return '${action.error}';
  }),

  TypedReducer<String, LoadChatsFailure>((state, action) {
    return '${action.error}';
  }),

  TypedReducer<String, LoadDesignsFailure>((state, action) {
    return '${action.error}';
  }),
  TypedReducer<String, RefreshDataFailure>((state, action) {
    return '${action.error}';
  }),
]);

final companiesReducer = combineReducers<BuiltList<CompanyEntity>>([
  TypedReducer<BuiltList<CompanyEntity>, LoadCompaniesByIdsSuccess>((companies, action) {
    return BuiltList<CompanyEntity>(action.companies);
  }),
  TypedReducer<BuiltList<CompanyEntity>, LoadCompanySuccess>((companies, action) {
    final updatedCompanies = companies.toBuilder();
    final existingIndex = companies.indexWhere((c) => c.id == action.userCompany.company.id);
    
    if (existingIndex >= 0) {
      updatedCompanies[existingIndex] = action.userCompany.company;
    } else {
      updatedCompanies.add(action.userCompany.company);
    }
    
    return updatedCompanies.build();
  }),
]);
