// Package imports:
import 'package:flutter_boilerplate/redux/settings/settings_state.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:flutter_boilerplate/data/models/entities.dart';
import 'package:flutter_boilerplate/redux/company/company_actions.dart';
import 'package:flutter_boilerplate/redux/settings/settings_actions.dart';

Reducer<SettingsUIState> settingsUIReducer = combineReducers([
  TypedReducer<SettingsUIState, ViewSettings>((state, action) {
    return state.rebuild((b) => b
      ..company.replace(action.company ?? state.company)
      ..origCompany.replace(action.company ?? state.origCompany)
      ..user.replace(action.user ?? state.user)
      ..origUser.replace(action.user ?? state.origUser)
      ..updatedAt = DateTime.now().millisecondsSinceEpoch
      ..section = action.section ?? state.section
      ..tabIndex = action.clearFilter ? 0 : action.tabIndex ?? state.tabIndex
      ..isChanged = false
      ..filter = action.clearFilter ? null : state.filter
      ..filterClearedAt = action.clearFilter
          ? DateTime.now().millisecondsSinceEpoch
          : state.filterClearedAt
      ..showNewSettings =
          action.tabIndex != null ? state.showNewSettings : false
      ..showPdfPreview = false);
  }),
  TypedReducer<SettingsUIState, UpdateCompany>((state, action) {
    return state.rebuild((b) => b
      ..company.replace(action.company)
      ..isChanged = true);
  }),
  TypedReducer<SettingsUIState, UpdateSettings>((state, action) {
    switch (state.entityType) {
      // case EntityType.client:
      //   return state.rebuild((b) => b
      //     ..client.settings.replace(action.settings)
      //     ..isChanged = true);

      default:
        return state.rebuild((b) => b
          ..company.settings.replace(action.settings)
          ..isChanged = true);
    }
  }),
  TypedReducer<SettingsUIState, UpdateUserSettings>((state, action) {
    return state.rebuild((b) => b
      ..user.replace(action.user)
      ..isChanged = true);
  }),
  TypedReducer<SettingsUIState, ResetSettings>((state, action) {
    return state.rebuild((b) => b
      ..company.replace(state.origCompany)
      ..user.replace(state.origUser)
      ..isChanged = false
      ..updatedAt = DateTime.now().millisecondsSinceEpoch);
  }),
  TypedReducer<SettingsUIState, SaveCompanySuccess>((state, action) {
    return state.rebuild((b) => b
      ..company.replace(action.company)
      ..origCompany.replace(action.company)
      ..updatedAt = DateTime.now().millisecondsSinceEpoch
      ..isChanged = false);
  }),
  TypedReducer<SettingsUIState, SaveAuthUserSuccess>((state, action) {
    return state.rebuild((b) => b
      ..user.replace(action.user)
      ..origUser.replace(action.user)
      ..isChanged = false);
  }),
  TypedReducer<SettingsUIState, ConnectOAuthUserSuccess>((state, action) {
    return state.rebuild((b) => b
      ..user.replace(action.user)
      ..origUser.replace(action.user)
      ..isChanged = false);
  }),
  TypedReducer<SettingsUIState, DisconnectOAuthUserSuccess>((state, action) {
    return state.rebuild((b) => b
      ..user.replace(action.user)
      ..origUser.replace(action.user)
      ..isChanged = false);
  }),
  TypedReducer<SettingsUIState, DisconnectOAuthMailerSuccess>((state, action) {
    return state.rebuild((b) => b
      ..user.replace(action.user)
      ..origUser.replace(action.user)
      ..isChanged = false);
  }),
  TypedReducer<SettingsUIState, FilterSettings>((state, action) {
    return state.rebuild((b) => b
      ..filter = action.filter
      ..filterClearedAt = action.filter == null
          ? DateTime.now().millisecondsSinceEpoch
          : state.filterClearedAt);
  }),
  TypedReducer<SettingsUIState, ClearSettingsFilter>((state, action) {
    return state.rebuild((b) => b
      ..updatedAt = DateTime.now().millisecondsSinceEpoch
      ..company.replace(state.origCompany)
      ..entityType = EntityType.company
      ..isChanged = false
      ..tabIndex = 0);
  }),
  TypedReducer<SettingsUIState, UpdateSettingsTab>((state, action) {
    return state.rebuild((b) => b..tabIndex = action.tabIndex);
  }),
  TypedReducer<SettingsUIState, UpdateSettingsTemplate>((state, action) {
    return state.rebuild((b) => b..selectedTemplate = action.selectedTemplate);
  }),
  TypedReducer<SettingsUIState, UpdatedSettingUI>((state, action) {
    return state
        .rebuild((b) => b..updatedAt = DateTime.now().millisecondsSinceEpoch);
  }),
  TypedReducer<SettingsUIState, ToggleShowNewSettings>((state, action) {
    return state.rebuild((b) => b..showNewSettings = !state.showNewSettings);
  }),
  TypedReducer<SettingsUIState, ToggleShowPdfPreview>((state, action) {
    return state.rebuild((b) => b..showPdfPreview = !state.showPdfPreview);
  }),
]);
