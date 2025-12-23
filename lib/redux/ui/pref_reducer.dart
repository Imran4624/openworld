// Dart imports:
import 'dart:math';

// Package imports:
import 'package:built_collection/built_collection.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter_boilerplate/project_config.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/data/models/entities.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/redux/company/company_actions.dart';
import 'package:flutter_boilerplate/redux/dashboard/dashboard_actions.dart';
import 'package:flutter_boilerplate/redux/design/design_actions.dart';
import 'package:flutter_boilerplate/redux/settings/settings_actions.dart';
import 'package:flutter_boilerplate/redux/ui/pref_state.dart';
import 'package:flutter_boilerplate/redux/ui/ui_actions.dart';
import 'package:flutter_boilerplate/redux/user/user_actions.dart';

// STARTER: import - do not remove comment
import 'package:flutter_boilerplate/redux/payment/payment_actions.dart';

import 'package:flutter_boilerplate/redux/product/product_actions.dart';

import 'package:flutter_boilerplate/redux/photo/photo_actions.dart';

import 'package:flutter_boilerplate/redux/notification/notification_actions.dart';

import 'package:flutter_boilerplate/redux/profile_operation/profile_operation_actions.dart';

import 'package:flutter_boilerplate/redux/profile/profile_actions.dart';

import 'package:flutter_boilerplate/redux/event/event_actions.dart';

import 'package:flutter_boilerplate/redux/chat/chat_actions.dart';

PrefState prefReducer(
    PrefState state, dynamic action, String selectedCompanyId) {
  return state.rebuild((b) => b
    ..companyPrefs[selectedCompanyId] =
        companyPrefReducer(state.companyPrefs[selectedCompanyId], action)
    ..appLayout = layoutReducer(state.appLayout, action)
    ..rowsPerPage = rowsPerPageReducer(state.rowsPerPage, action)
    ..moduleLayout = moduleLayoutReducer(state.moduleLayout, action)
    ..statementIncludes
        .replace(statementIncludesReducer(state.statementIncludes, action))
    ..isPreviewVisible = isPreviewVisibleReducer(state.isPreviewVisible, action)
    ..menuSidebarMode = manuSidebarReducer(state.menuSidebarMode, action)
    ..historySidebarMode =
        historySidebarReducer(state.historySidebarMode, action)
    ..hideTaskExtensionBanner =
        hideTaskExtensionBannerReducer(state.hideTaskExtensionBanner, action)
    ..hideGatewayWarning =
        hideGatewayWarningReducer(state.hideGatewayWarning, action)
    ..hideReviewApp = hideReviewAppReducer(state.hideReviewApp, action)
    ..hideOneYearReviewApp =
        hideOneYearReviewAppReducer(state.hideOneYearReviewApp, action)
    ..hideTwoYearReviewApp =
        hideTwoYearReviewAppReducer(state.hideTwoYearReviewApp, action)
    ..textScaleFactor = textScaleFactorReducer(state.textScaleFactor, action)
    ..isMenuVisible = menuVisibleReducer(state.isMenuVisible, action)
    ..isHistoryVisible = historyVisibleReducer(state.isHistoryVisible, action)
    ..darkModeType = darkModeTypeReducer(state.darkModeType, action)
    ..enableDarkModeSystem =
        darkModeSystemReducer(state.enableDarkModeSystem, action)
    ..enableTooltips = enableTooltipsReducer(state.enableTooltips, action)
    ..enableFlexibleSearch =
        enableFlexibleSearchReducer(state.enableFlexibleSearch, action)
    ..enableNativeBrowser =
        enableNativeBrowserReducer(state.enableNativeBrowser, action)
    ..persistData = persistDataReducer(state.persistData, action)
    ..showKanban = showKanbanReducer(state.showKanban, action)
    ..isFilterVisible = isFilterVisibleReducer(state.isFilterVisible, action)
    ..longPressSelectionIsDefault =
        longPressReducer(state.longPressSelectionIsDefault, action)
    ..tapSelectedToEdit =
        tapSelectedToEditReducer(state.tapSelectedToEdit, action)
    ..donwloadsFolder = downloadsFolderReducer(state.donwloadsFolder, action)
    ..requireAuthentication =
        requireAuthenticationReducer(state.requireAuthentication, action)
    ..colorTheme = colorThemeReducer(state.colorTheme, action)
    ..darkColorTheme = darkColorThemeReducer(state.darkColorTheme, action)
    ..customColors.replace(customColorsReducer(state.customColors, action))
    ..darkCustomColors
        .replace(darkCustomColorsReducer(state.darkCustomColors, action))
    ..useSidebarEditor
        .replace(sidebarEditorReducer(state.useSidebarEditor, action))
    ..useSidebarViewer
        .replace(sidebarViewerReducer(state.useSidebarViewer, action))
    ..sortFields.replace(sortFieldsReducer(state.sortFields, action))
    ..editAfterSaving = editAfterSavingReducer(state.editAfterSaving, action)
    ..enableTouchEvents =
        enableTouchEventsReducer(state.enableTouchEvents, action)
    ..showPdfPreview = showPdfPreviewReducer(state.showPdfPreview, action)
    ..showPdfPreviewSideBySide = showPdfPreviewSideBySideReducer(
        state.showPdfPreviewSideBySide, action));
}

BuiltMap<EntityType, PrefStateSortField> _resortFields(
    BuiltMap<EntityType, PrefStateSortField> value,
    EntityType entityType,
    String field) {
  final sortField =
      value[entityType] ?? PrefStateSortField(field, field != 'number');
  final directon = sortField.rebuild((b) => b
    ..ascending = sortField.field != field || !sortField.ascending
    ..field = field);
  return value.rebuild((b) => b..[entityType] = directon);
}

Reducer<BuiltMap<EntityType, PrefStateSortField>> sortFieldsReducer =
    combineReducers([
  TypedReducer<BuiltMap<EntityType, PrefStateSortField>, SortUsers>(
      (value, action) => _resortFields(value, EntityType.user, action.field)),
  TypedReducer<BuiltMap<EntityType, PrefStateSortField>, SortDesigns>(
      (value, action) => _resortFields(value, EntityType.design, action.field)),
  // TODO add to starter.sh
]);

Reducer<BuiltMap<EntityType, bool>> sidebarEditorReducer = combineReducers([
  TypedReducer<BuiltMap<EntityType, bool>, ToggleEditorLayout>((value, action) {
    final entityType = action.entityType!.baseType;
    if (value.containsKey(entityType)) {
      return value.rebuild((b) => b..[entityType] = !value[entityType]!);
    } else {
      return value.rebuild((b) => b..[entityType] = true);
    }
  }),
]);

Reducer<BuiltMap<EntityType, bool>> sidebarViewerReducer = combineReducers([
  TypedReducer<BuiltMap<EntityType, bool>, ToggleViewerLayout>((value, action) {
    final entityType = action.entityType!.baseType;
    if (value.containsKey(entityType)) {
      return value.rebuild((b) => b..[entityType] = !value[entityType]!);
    } else {
      return value.rebuild((b) => b..[entityType] = true);
    }
  }),
]);

Reducer<bool> menuVisibleReducer = combineReducers([
  TypedReducer<bool, UpdateUserPreferences>((value, action) {
    return action.sidebar == AppSidebar.menu ? !value : value;
  }),
  TypedReducer<bool, UpdateUserPreferences>((value, action) {
    switch (action.menuMode) {
      case AppSidebarMode.visible:
        return true;
      case AppSidebarMode.collapse:
      case AppSidebarMode.float:
        return false;
      default:
        return value;
    }
  }),
]);

Reducer<double> textScaleFactorReducer = combineReducers([
  TypedReducer<double, UpdateUserPreferences>((value, action) {
    return action.textScaleFactor ?? value;
  }),
]);

Reducer<bool> historyVisibleReducer = combineReducers([
  TypedReducer<bool, UpdateUserPreferences>((value, action) {
    return action.sidebar == AppSidebar.history ? !value : value;
  }),
  TypedReducer<bool, UpdateUserPreferences>((value, action) {
    return action.historyMode == AppSidebarMode.visible
        ? true
        : action.historyMode == AppSidebarMode.float
            ? false
            : value;
  }),
]);

/*
Reducer<String> filterReducer = combineReducers([
  TypedReducer<String, FilterCompany>((filter, action) {
    return action.filter;
  }),
]);
*/

Reducer<bool> hideTaskExtensionBannerReducer = combineReducers([
  TypedReducer<bool, DismissTaskExtensionBanner>((filter, action) {
    return true;
  }),
]);

Reducer<bool> hideGatewayWarningReducer = combineReducers([
  TypedReducer<bool, DismissGatewayWarningPermanently>((filter, action) {
    return true;
  }),
]);

Reducer<bool> hideReviewAppReducer = combineReducers([
  TypedReducer<bool, DismissReviewAppPermanently>((filter, action) {
    return true;
  }),
  TypedReducer<bool, DismissOneYearReviewAppPermanently>((filter, action) {
    return true;
  }),
  TypedReducer<bool, DismissTwoYearReviewAppPermanently>((filter, action) {
    return true;
  }),
]);

Reducer<bool> hideOneYearReviewAppReducer = combineReducers([
  TypedReducer<bool, DismissOneYearReviewAppPermanently>((filter, action) {
    return true;
  }),
  TypedReducer<bool, DismissTwoYearReviewAppPermanently>((filter, action) {
    return true;
  }),
]);

Reducer<bool> hideTwoYearReviewAppReducer = combineReducers([
  TypedReducer<bool, DismissTwoYearReviewAppPermanently>((filter, action) {
    return true;
  }),
]);

Reducer<int> filterClearedAtReducer = combineReducers([
  TypedReducer<int, FilterCompany>((filterClearedAt, action) {
    return action.filter == null
        ? DateTime.now().millisecondsSinceEpoch
        : filterClearedAt;
  }),
]);

Reducer<AppLayout> layoutReducer = combineReducers([
  TypedReducer<AppLayout, UpdateUserPreferences>((layout, action) {
    return action.appLayout ?? layout;
  }),
]);

Reducer<ModuleLayout?> moduleLayoutReducer = combineReducers([
  TypedReducer<ModuleLayout?, UpdateUserPreferences>((moduleLayout, action) {
    if (action.moduleLayout != null) {
      return action.moduleLayout;
    } else if (action.appLayout != null) {
      return (action.appLayout == AppLayout.desktop)
          ? ModuleLayout.table
          : ModuleLayout.list;
    }

    return moduleLayout;
  }),
  TypedReducer<ModuleLayout?, SwitchListTableLayout>((moduleLayout, action) {
    if (moduleLayout == ModuleLayout.list) {
      return ModuleLayout.table;
    } else {
      return ModuleLayout.list;
    }
  }),
]);

Reducer<int> rowsPerPageReducer = combineReducers([
  TypedReducer<int, UpdateUserPreferences>((numRows, action) {
    return action.rowsPerPage ?? numRows;
  }),
]);

Reducer<AppSidebarMode> manuSidebarReducer = combineReducers([
  TypedReducer<AppSidebarMode, UpdateUserPreferences>((mode, action) {
    return action.menuMode ?? mode;
  }),
]);

Reducer<AppSidebarMode> historySidebarReducer = combineReducers([
  TypedReducer<AppSidebarMode, UpdateUserPreferences>((mode, action) {
    return action.historyMode ?? mode;
  }),
]);

Reducer<String> darkModeTypeReducer = combineReducers([
  TypedReducer<String, UpdateUserPreferences>((enableDarkMode, action) {
    return action.darkModeType ?? enableDarkMode;
  }),
]);

Reducer<bool> darkModeSystemReducer = combineReducers([
  TypedReducer<bool, UpdateUserPreferences>((enableDarkMode, action) {
    return action.enableDarkModeSystem ?? enableDarkMode;
  }),
]);

Reducer<BuiltList<String>> statementIncludesReducer = combineReducers([
  TypedReducer<BuiltList<String>, UpdateUserPreferences>((includes, action) {
    return action.statementIncludes ?? includes;
  }),
]);

Reducer<bool> enableTooltipsReducer = combineReducers([
  TypedReducer<bool, UpdateUserPreferences>((enableTooltips, action) {
    return action.enableTooltips ?? enableTooltips;
  }),
]);

Reducer<bool> enableFlexibleSearchReducer = combineReducers([
  TypedReducer<bool, UpdateUserPreferences>((enableFlexibleSearch, action) {
    return action.flexibleSearch ?? enableFlexibleSearch;
  }),
]);

Reducer<bool> enableNativeBrowserReducer = combineReducers([
  TypedReducer<bool, UpdateUserPreferences>((enableNativeBrowser, action) {
    return action.enableNativeBrowser ?? enableNativeBrowser;
  }),
]);

Reducer<bool> persistDataReducer = combineReducers([
  TypedReducer<bool, UpdateUserPreferences>((persistData, action) {
    return action.persistData ?? persistData;
  }),
]);

Reducer<bool> showKanbanReducer = combineReducers([
  TypedReducer<bool, UpdateUserPreferences>((showKanban, action) {
    return action.showKanban ?? showKanban;
  }),
]);

Reducer<bool> isFilterVisibleReducer = combineReducers([
  TypedReducer<bool, UpdateUserPreferences>((value, action) {
    return action.isFilterVisible ?? value;
  }),
]);

Reducer<bool> longPressReducer = combineReducers([
  TypedReducer<bool, UpdateUserPreferences>(
      (longPressSelectionIsDefault, action) {
    return action.longPressSelectionIsDefault ?? longPressSelectionIsDefault;
  }),
]);

Reducer<bool> tapSelectedToEditReducer = combineReducers([
  TypedReducer<bool, UpdateUserPreferences>((tapSelectedToEdit, action) {
    return action.tapSelectedToEdit ?? tapSelectedToEdit;
  }),
]);

Reducer<String> downloadsFolderReducer = combineReducers([
  TypedReducer<String, UpdateUserPreferences>((downloadsFolder, action) {
    return action.downloadsFolder ?? downloadsFolder;
  }),
]);

Reducer<bool> isPreviewVisibleReducer = combineReducers([
  TypedReducer<bool, TogglePreviewSidebar>((value, action) {
    return !value;
  }),
  TypedReducer<bool, UpdateUserPreferences>((isPreviewEnabled, action) {
    return action.isPreviewVisible ?? isPreviewEnabled;
  }),
  // TODO add to starter.sh
]);

Reducer<bool> requireAuthenticationReducer = combineReducers([
  TypedReducer<bool, UpdateUserPreferences>((requireAuthentication, action) {
    return action.requireAuthentication ?? requireAuthentication;
  }),
]);

Reducer<String> colorThemeReducer = combineReducers([
  TypedReducer<String, UpdateUserPreferences>((currentColorTheme, action) {
    return action.colorTheme ?? currentColorTheme;
  }),
]);

Reducer<String> darkColorThemeReducer = combineReducers([
  TypedReducer<String, UpdateUserPreferences>((currentColorTheme, action) {
    return action.darkColorTheme ?? currentColorTheme;
  }),
]);

Reducer<bool> showPdfPreviewReducer = combineReducers([
  TypedReducer<bool, UpdateUserPreferences>((value, action) {
    return action.showPdfPreview ?? value;
  }),
]);

Reducer<bool> showPdfPreviewSideBySideReducer = combineReducers([
  TypedReducer<bool, UpdateUserPreferences>((value, action) {
    return action.showPdfPreviewSideBySide ?? value;
  }),
]);

Reducer<bool> editAfterSavingReducer = combineReducers([
  TypedReducer<bool, UpdateUserPreferences>((value, action) {
    return action.editAfterSaving ?? value;
  }),
]);

Reducer<bool> enableTouchEventsReducer = combineReducers([
  TypedReducer<bool, UpdateUserPreferences>((value, action) {
    return action.enableTouchEvents ?? value;
  }),
]);

Reducer<BuiltMap<String, String>> customColorsReducer = combineReducers([
  TypedReducer<BuiltMap<String, String>, UpdateUserPreferences>(
      (customColors, action) {
    return action.customColors ?? customColors;
  }),
]);

Reducer<BuiltMap<String, String>> darkCustomColorsReducer = combineReducers([
  TypedReducer<BuiltMap<String, String>, UpdateUserPreferences>(
      (customColors, action) {
    return action.darkCustomColors ?? customColors;
  }),
]);

Reducer<String> currentRouteReducer = combineReducers([
  TypedReducer<String, UpdateCurrentRoute>((currentRoute, action) {
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

CompanyPrefState companyPrefReducer(CompanyPrefState? state, dynamic action) {
  state ??= CompanyPrefState();

  return state.rebuild((b) =>
      b..historyList.replace(historyReducer(state!.historyList, action)));
}

Reducer<BuiltList<HistoryRecord>> historyReducer = combineReducers([
  TypedReducer<BuiltList<HistoryRecord>, PurgeDataSuccess>(
      (historyList, action) {
    return BuiltList<HistoryRecord>();
  }),
  TypedReducer<BuiltList<HistoryRecord>, PopLastHistory>(
    (historyList, action) {
      if (historyList.isEmpty) {
        return historyList;
      } else {
        return historyList.rebuild((b) => b..removeAt(0));
      }
    },
  ),
  TypedReducer<BuiltList<HistoryRecord>, UpdateLastHistory>(
    (historyList, action) {
      if (historyList.isEmpty) {
        return historyList;
      }

      final history = historyList.first;

      return historyList.rebuild(
          (b) => b..[0] = history.rebuild((b) => b.page = action.page));
    },
  ),
  TypedReducer<BuiltList<HistoryRecord>, ViewDashboard>((historyList, action) =>
      _addToHistory(
          historyList, HistoryRecord(entityType: EntityType.dashboard))),
  TypedReducer<BuiltList<HistoryRecord>, ViewSettings>((historyList, action) =>
      _addToHistory(
          historyList,
          HistoryRecord(
              entityType: EntityType.settings,
              id: action.section ??
                  ProjectConfig.defaultSettingsToOpenInDesktopView()))),
  TypedReducer<BuiltList<HistoryRecord>, ViewUser>((historyList, action) =>
      _addToHistory(historyList,
          HistoryRecord(id: action.userId, entityType: EntityType.user))),
  TypedReducer<BuiltList<HistoryRecord>, ViewUserList>((historyList, action) =>
      _addToHistory(historyList, HistoryRecord(entityType: EntityType.user))),
  TypedReducer<BuiltList<HistoryRecord>, EditUser>((historyList, action) =>
      _addToHistory(historyList,
          HistoryRecord(id: action.user.id, entityType: EntityType.user))),
  // STARTER: history - do not remove comment
  TypedReducer<BuiltList<HistoryRecord>, ViewPayment>((historyList, action) =>
      _addToHistory(historyList,
          HistoryRecord(id: action.paymentId, entityType: EntityType.payment))),
  TypedReducer<BuiltList<HistoryRecord>, EditPayment>((historyList, action) =>
      _addToHistory(
          historyList,
          HistoryRecord(
              id: action.payment.id, entityType: EntityType.payment))),
  TypedReducer<BuiltList<HistoryRecord>, ViewPaymentList>(
      (historyList, action) => _addToHistory(historyList,
          HistoryRecord( entityType: EntityType.payment))),
  TypedReducer<BuiltList<HistoryRecord>, EditPayment>((historyList, action) =>
      _addToHistory(
          historyList, HistoryRecord(entityType: EntityType.payment))),

  TypedReducer<BuiltList<HistoryRecord>, ViewProduct>((historyList, action) =>
      _addToHistory(historyList,
          HistoryRecord(id: action.productId, entityType: EntityType.product))),
  TypedReducer<BuiltList<HistoryRecord>, EditProduct>((historyList, action) =>
      _addToHistory(
          historyList,
          HistoryRecord(
              id: action.product.id, entityType: EntityType.product))),
  TypedReducer<BuiltList<HistoryRecord>, ViewProductList>(
      (historyList, action) => _addToHistory(
          historyList, HistoryRecord(entityType: EntityType.product))),
  TypedReducer<BuiltList<HistoryRecord>, EditProduct>((historyList, action) =>
      _addToHistory(
          historyList, HistoryRecord(entityType: EntityType.product))),

  TypedReducer<BuiltList<HistoryRecord>, ViewPhoto>((historyList, action) =>
      _addToHistory(historyList,
          HistoryRecord(id: action.photoId, entityType: EntityType.photo))),
  TypedReducer<BuiltList<HistoryRecord>, EditPhoto>((historyList, action) =>
      _addToHistory(historyList,
          HistoryRecord(id: action.photo.id, entityType: EntityType.photo))),
  TypedReducer<BuiltList<HistoryRecord>, ViewPhotoList>((historyList, action) =>
      _addToHistory(historyList, HistoryRecord(entityType: EntityType.photo))),
  TypedReducer<BuiltList<HistoryRecord>, EditPhoto>((historyList, action) =>
      _addToHistory(historyList, HistoryRecord(entityType: EntityType.photo))),

  TypedReducer<BuiltList<HistoryRecord>, ViewNotification>(
      (historyList, action) => _addToHistory(
          historyList,
          HistoryRecord(
              id: action.notificationId, entityType: EntityType.notification))),
  TypedReducer<BuiltList<HistoryRecord>, EditNotification>(
      (historyList, action) => _addToHistory(
          historyList,
          HistoryRecord(
              id: action.notification.id,
              entityType: EntityType.notification))),
  TypedReducer<BuiltList<HistoryRecord>, ViewNotificationList>(
      (historyList, action) => _addToHistory(
          historyList, HistoryRecord(entityType: EntityType.notification))),
  TypedReducer<BuiltList<HistoryRecord>, EditNotification>(
      (historyList, action) => _addToHistory(
          historyList, HistoryRecord(entityType: EntityType.notification))),

  TypedReducer<BuiltList<HistoryRecord>, ViewProfileOperation>(
      (historyList, action) => _addToHistory(
          historyList,
          HistoryRecord(
              id: action.profileOperationId,
              entityType: EntityType.profileOperation))),
  TypedReducer<BuiltList<HistoryRecord>, EditProfileOperation>(
      (historyList, action) => _addToHistory(
          historyList,
          HistoryRecord(
              id: action.profileOperation.id,
              entityType: EntityType.profileOperation))),
  TypedReducer<BuiltList<HistoryRecord>, ViewProfileOperationList>(
      (historyList, action) => _addToHistory(
          historyList, HistoryRecord(entityType: EntityType.profileOperation))),
  TypedReducer<BuiltList<HistoryRecord>, EditProfileOperation>(
      (historyList, action) => _addToHistory(
          historyList, HistoryRecord(entityType: EntityType.profileOperation))),

  TypedReducer<BuiltList<HistoryRecord>, ViewProfile>((historyList, action) =>
      _addToHistory(historyList,
          HistoryRecord(id: action.profileId, entityType: EntityType.profile))),
  TypedReducer<BuiltList<HistoryRecord>, EditProfile>((historyList, action) =>
      _addToHistory(
          historyList,
          HistoryRecord(
              id: action.profile.id, entityType: EntityType.profile))),
  TypedReducer<BuiltList<HistoryRecord>, ViewProfileList>(
      (historyList, action) => _addToHistory(
          historyList, HistoryRecord(entityType: EntityType.profile))),
  TypedReducer<BuiltList<HistoryRecord>, EditProfile>((historyList, action) =>
      _addToHistory(
          historyList, HistoryRecord(entityType: EntityType.profile))),

  TypedReducer<BuiltList<HistoryRecord>, ViewEvent>((historyList, action) =>
      _addToHistory(historyList,
          HistoryRecord(id: action.eventId, entityType: EntityType.event))),
  TypedReducer<BuiltList<HistoryRecord>, EditEvent>((historyList, action) =>
      _addToHistory(historyList,
          HistoryRecord(id: action.event.id, entityType: EntityType.event))),
  TypedReducer<BuiltList<HistoryRecord>, ViewEventList>((historyList, action) =>
      _addToHistory(historyList, HistoryRecord(entityType: EntityType.event))),
  TypedReducer<BuiltList<HistoryRecord>, EditEvent>((historyList, action) =>
      _addToHistory(historyList, HistoryRecord(entityType: EntityType.event))),

  TypedReducer<BuiltList<HistoryRecord>, ViewChat>((historyList, action) =>
      _addToHistory(historyList,
          HistoryRecord(id: action.chatId, entityType: EntityType.chat))),
  TypedReducer<BuiltList<HistoryRecord>, EditChat>((historyList, action) =>
      _addToHistory(historyList,
          HistoryRecord(id: action.chat.id, entityType: EntityType.chat))),
  TypedReducer<BuiltList<HistoryRecord>, ViewChatList>((historyList, action) =>
      _addToHistory(historyList, HistoryRecord(entityType: EntityType.chat))),
  TypedReducer<BuiltList<HistoryRecord>, EditChat>((historyList, action) =>
      _addToHistory(historyList, HistoryRecord(entityType: EntityType.chat))),

  TypedReducer<BuiltList<HistoryRecord>, FilterByEntity>((historyList, action) {
    if (action.clearSelection) {
      return historyList;
    }
    return _addToHistory(historyList,
        HistoryRecord(id: action.entityId, entityType: action.entityType!));
  }),
]);

BuiltList<HistoryRecord> _addToHistory(
    BuiltList<HistoryRecord> list, HistoryRecord record) {
  // don't track new records
  if (record.id != null && record.id!.startsWith('-')) {
    return list;
  }

  if (record.entityType == EntityType.settings) {
    if ((record.id ?? '').endsWith('/edit')) {
      return list;
    }
  }

  final old = list.firstWhereOrNull((item) => item.matchesRecord(record));

  if (old != null) {
    return list.rebuild((b) => b
      ..remove(old)
      ..insert(0, record));
  } else {
    return list.rebuild((b) => b
      ..insert(0, record)
      ..sublist(0, min(kMaxNumberOfHistory, list.length + 1)));
  }
}
