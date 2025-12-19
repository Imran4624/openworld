// Dart imports:
import 'dart:ui';

// Flutter imports:

// Package imports:
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:flutter_boilerplate/data/models/static/app_theme.dart';
import 'package:flutter_boilerplate/redux/dashboard/dashboard_state.dart';
import 'package:flutter_boilerplate/redux/dynamicField/dynamic_field_state.dart';
import 'package:flutter_boilerplate/redux/settings/settings_state.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'package:flutter_boilerplate/ui/chat/message_view/message_screen.dart';
import 'package:flutter_boilerplate/ui/event/view/event_view_vm.dart';
import 'package:flutter_boilerplate/ui/profile_operation/view/profile_operation_view_vm.dart';
import 'package:timeago/timeago.dart' as timeago;

// Project imports:
import 'package:flutter_boilerplate/.env.dart';
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/data/models/account_model.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/project_config.dart';
import 'package:flutter_boilerplate/redux/auth/auth_state.dart';
import 'package:flutter_boilerplate/redux/company/company_state.dart';
import 'package:flutter_boilerplate/redux/design/design_state.dart';
import 'package:flutter_boilerplate/redux/static/static_state.dart';
import 'package:flutter_boilerplate/redux/ui/entity_ui_state.dart';
import 'package:flutter_boilerplate/redux/ui/list_ui_state.dart';
import 'package:flutter_boilerplate/redux/ui/pref_state.dart';
import 'package:flutter_boilerplate/redux/ui/ui_state.dart';
import 'package:flutter_boilerplate/redux/user/user_state.dart';
import 'package:flutter_boilerplate/data/models/app_version_model.dart';
import 'package:flutter_boilerplate/ui/design/edit/design_edit_vm.dart';
import 'package:flutter_boilerplate/utils/colors.dart';
import 'package:flutter_boilerplate/utils/formatting.dart';
// STARTER: import - do not remove comment
import 'package:flutter_boilerplate/redux/payment/payment_state.dart';
import 'package:flutter_boilerplate/ui/payment/edit/payment_edit_vm.dart';

import 'package:flutter_boilerplate/redux/product/product_state.dart';
import 'package:flutter_boilerplate/ui/product/edit/product_edit_vm.dart';

import 'package:flutter_boilerplate/redux/social/social_state.dart';
import 'package:flutter_boilerplate/ui/social/edit/social_edit_vm.dart';

import 'package:flutter_boilerplate/redux/photo/photo_state.dart';
import 'package:flutter_boilerplate/ui/photo/edit/photo_edit_vm.dart';

import 'package:flutter_boilerplate/redux/workout/workout_state.dart';
import 'package:flutter_boilerplate/ui/workout/edit/workout_edit_vm.dart';

import 'package:flutter_boilerplate/redux/notification/notification_state.dart';
import 'package:flutter_boilerplate/ui/notification/edit/notification_edit_vm.dart';

import 'package:flutter_boilerplate/redux/profile_operation/profile_operation_state.dart';
import 'package:flutter_boilerplate/ui/profile_operation/edit/profile_operation_edit_vm.dart';

import 'package:flutter_boilerplate/redux/profile/profile_state.dart';
import 'package:flutter_boilerplate/ui/profile/edit/profile_edit_vm.dart';
import 'package:flutter_boilerplate/ui/profile/view/profile_view_vm.dart';

import 'package:flutter_boilerplate/redux/event/event_state.dart';
import 'package:flutter_boilerplate/ui/event/edit/event_edit_vm.dart';

import 'package:flutter_boilerplate/redux/chat/chat_state.dart';
import 'package:flutter_boilerplate/ui/chat/create/create_chat_vm.dart';

part 'app_state.g.dart';

abstract class AppState implements Built<AppState, AppStateBuilder> {
  factory AppState({
    required PrefState? prefState,
    required bool reportErrors,
    required bool isWhiteLabeled,
    String? url,
    String? referralCode,
    String? currentRoute,
    AppVersionEntity? appVersion,
  }) {
    return _$AppState._(
      isLoading: false,
      isSaving: false,
      isTesting: false,
      isWhiteLabeled: isWhiteLabeled,
      lastError: '',
      authState: AuthState(
        url: url,
        referralCode: referralCode,
      ),
      staticState: StaticState(),
      userCompanyStates: BuiltList(
          List<int>.generate(kMaxNumberOfCompanies, (i) => i + 1)
              .map((index) => UserCompanyState(reportErrors))
              .toList()),
      companies: BuiltList<CompanyEntity>(),
      uiState: UIState(
          currentRoute: currentRoute,
          sortFields: prefState?.sortFields ??
              BuiltMap<EntityType, PrefStateSortField>()),
      prefState: prefState ?? PrefState(),
      appVersion: appVersion,
    );
  }

  AppState._();

  @override
  @memoized
  int get hashCode;

  bool get isLoading;

  bool get isSaving;

  bool get isTesting;

  bool get isWhiteLabeled;

  String get lastError;

  AuthState get authState;

  StaticState get staticState;

  PrefState get prefState;

  UIState get uiState;

  BuiltList<UserCompanyState> get userCompanyStates;

  BuiltList<CompanyEntity> get companies;

  AppVersionEntity? get appVersion;

  //factory AppState([void updates(AppStateBuilder b)]) = _$AppState;
  static Serializer<AppState> get serializer => _$appStateSerializer;

  UserCompanyState get userCompanyState =>
      userCompanyStates[uiState.selectedCompanyIndex];

  bool get isLoaded => userCompanyState.isLoaded;

  bool get isStale => userCompanyState.isStale || staticState.isStale;

  AccountEntity get account => userCompany.account;

  CompanyEntity get company => userCompanyState.company;


  UserEntity get user => userCompanyState.user;

  UserCompanyEntity get userCompany => userCompanyState.userCompany;

  String get token => 'Token'; //userCompany.token.token;

  // Credentials get credentials =>
  //     Credentials(token: userCompanyState.token.token, url: authState.url);

  Credentials get credentials =>
      Credentials(token: 'Token', url: authState.url); //this is temp code

  bool get hasAccentColor {
    if (isDemo) {
      return true;
    }

    final color = userCompany.settings.accentColor ?? '';

    if (color == '#ffffff' && !prefState.enableDarkMode) {
      return false;
    }

    return color.isNotEmpty;
  }

  bool get showReviewApp => !prefState.hideReviewApp && company.daysActive > 60;

  bool get showOneYearReviewApp =>
      !prefState.hideOneYearReviewApp && company.daysActive > 365;

  bool get showTwoYearReviewApp =>
      !prefState.hideTwoYearReviewApp && company.daysActive > 730;

  Color get greyColor => prefState.enableDarkMode
      ? AppTheme.dark.defaultColor
      : AppTheme.light.defaultColor;

  Color? get linkColor =>
      prefState.enableDarkMode ? AppTheme.dark.primary : AppTheme.light.primary;

  Color? get headerTextColor =>
      prefState.enableDarkMode ? AppTheme.dark.text : AppTheme.light.text;

  Color? get authHeadingTextColor =>
      prefState.enableDarkMode ? AppTheme.dark.text : AppTheme.light.text;

  Color? get accentColor {
    var color = userCompany.settings.accentColor ?? kDefaultAccentColor;

    if (color == '#ffffff' && !prefState.enableDarkMode) {
      color = kDefaultAccentColor;
    } else if (color == '#000000' && prefState.enableDarkMode) {
      color = kDefaultAccentColor;
    }

    return convertHexStringToColor(color);
  }

  List<HistoryRecord> get historyList =>
      prefState.companyPrefs[company.id]!.historyList.where((history) {
        final entityMap = getEntityMap(history.entityType);
        if (entityMap != null) {
          final entity = entityMap[history.id] as BaseEntity?;
          if (entity?.isDeleted == true) {
            return false;
          }
        }
        return true;
      }).toList();

  List<HistoryRecord> get unfilteredHistoryList =>
      prefState.companyPrefs[company.id]!.historyList.toList();

  bool? shouldSelectEntity(
      {EntityType? entityType, List<String?>? entityList}) {
    final entityUIState = getUIState(entityType);

    if (prefState.isMobile ||
        !prefState.isPreviewVisible ||
        uiState.isEditing ||
        (prefState.isModuleList && entityType!.hasFullWidthViewer) ||
        entityType!.isSetting ||
        (entityList!.isEmpty && (entityUIState!.selectedId ?? '').isEmpty)) {
      return false;
    }

    if ((entityUIState!.selectedId ?? '').isEmpty ||
        !entityList.contains(entityUIState.selectedId)) {
      return true;
    } else if (unfilteredHistoryList.isNotEmpty &&
        uiState.isViewing &&
        unfilteredHistoryList.first.entityType != entityType) {
      // check if this needs to be added to the history
      return null;
    }

    return false;
  }

  BaseEntity? getEntity(EntityType? type, String? id) {
    final map = getEntityMap(type);

    return map != null ? map[id] as BaseEntity? : null;
  }

  BuiltMap<String?, SelectableEntity?>? getEntityMap(EntityType? type) {
    switch (type) {
      // STARTER: states switch map - do not remove comment
      case EntityType.payment:
        return paymentState.map;

      case EntityType.product:
        return productState.map;

      case EntityType.social:
        return socialState.map;

      case EntityType.photo:
        return photoState.map;

      case EntityType.workout:
        return workoutState.map;

      case EntityType.notification:
        return notificationState.map;

      case EntityType.profileOperation:
        return profileOperationState.map;

      case EntityType.profile:
        return profileState.map;

      case EntityType.event:
        return eventState.map;

      case EntityType.chat:
        return chatState.map;

      case EntityType.design:
        return designState.map;
      case EntityType.user:
        return userState.map;
      case EntityType.currency:
        return staticState.currencyMap;
      case EntityType.country:
        return staticState.countryMap;
      case EntityType.language:
        return staticState.languageMap;
      case EntityType.industry:
        return staticState.industryMap;
      case EntityType.size:
        return staticState.sizeMap;
      case EntityType.dateFormat:
        return staticState.dateFormatMap;
      case EntityType.timezone:
        return staticState.timezoneMap;
      case EntityType.company:
        return BuiltMap(Map<String?, SelectableEntity?>.fromIterable(
          companies,
          key: (dynamic item) => item.id,
          value: (dynamic item) => item,
        ));
      case EntityType.dashboard:
      case EntityType.settings:
        return null;
      default:
        logError('getEntityMap()) $type not found');
        return null;
    }
  }

  BuiltList<String>? getEntityList(EntityType type) {
    switch (type) {
      // STARTER: states switch list - do not remove comment
      case EntityType.payment:
        return paymentState.list;

      case EntityType.product:
        return productState.list;

      case EntityType.social:
        return socialState.list;

      case EntityType.photo:
        return photoState.list;

      case EntityType.workout:
        return workoutState.list;

      case EntityType.notification:
        return notificationState.list;

      case EntityType.profileOperation:
        return profileOperationState.list;

      case EntityType.profile:
        return profileState.list;

      case EntityType.event:
        return eventState.list;

      case EntityType.chat:
        return chatState.list;

      case EntityType.design:
        return designState.list;
      case EntityType.user:
        return userState.list;
      default:
        return null;
    }
  }

  SelectionState getUISelection(EntityType type) {
    final entityUIState = getUIState(type);

    return SelectionState(
      selectedId: entityUIState?.forceSelected == true 
          ? entityUIState?.selectedId 
          : null,
      filterEntityId: uiState.filterEntityId,
      filterEntityType: uiState.filterEntityType,
    );
  }

  EntityUIState? getUIState(EntityType? type) {
    switch (type) {
      // STARTER: states switch - do not remove comment
      case EntityType.payment:
        return paymentUIState;

      case EntityType.product:
        return productUIState;

      case EntityType.social:
        return socialUIState;

      case EntityType.photo:
        return photoUIState;

      case EntityType.workout:
        return workoutUIState;

      case EntityType.notification:
        return notificationUIState;

      case EntityType.profileOperation:
        return profileOperationUIState;

      case EntityType.profile:
        return profileUIState;

      case EntityType.event:
        return eventUIState;

      case EntityType.chat:
        return chatUIState;

      case EntityType.design:
        return designUIState;
      case EntityType.user:
        return userUIState;
      default:
        return null;
    }
  }

  ListUIState getListState(EntityType? type) {
    final entityUIState = getUIState(type);
    if (entityUIState == null) {
      return ListUIState('id');
    }
    return entityUIState.listUIState;
  }

  // STARTER: state getters - do not remove comment
  PaymentState get paymentState => userCompanyState.paymentState;
  ListUIState get paymentListState => uiState.paymentUIState.listUIState;
  PaymentUIState get paymentUIState => uiState.paymentUIState;

  ProductState get productState => userCompanyState.productState;
  ListUIState get productListState => uiState.productUIState.listUIState;
  ProductUIState get productUIState => uiState.productUIState;

  SocialState get socialState => userCompanyState.socialState;
  ListUIState get socialListState => uiState.socialUIState.listUIState;
  SocialUIState get socialUIState => uiState.socialUIState;

  PhotoState get photoState => userCompanyState.photoState;
  ListUIState get photoListState => uiState.photoUIState.listUIState;
  PhotoUIState get photoUIState => uiState.photoUIState;

  WorkoutState get workoutState => userCompanyState.workoutState;
  ListUIState get workoutListState => uiState.workoutUIState.listUIState;
  WorkoutUIState get workoutUIState => uiState.workoutUIState;

  NotificationState get notificationState => userCompanyState.notificationState;
  ListUIState get notificationListState =>
      uiState.notificationUIState.listUIState;
  NotificationUIState get notificationUIState => uiState.notificationUIState;

  ProfileOperationState get profileOperationState =>
      userCompanyState.profileOperationState;
  ListUIState get profileOperationListState =>
      uiState.profileOperationUIState.listUIState;
  ProfileOperationUIState get profileOperationUIState =>
      uiState.profileOperationUIState;

  ProfileState get profileState => userCompanyState.profileState;
  ListUIState get profileListState => uiState.profileUIState.listUIState;
  ProfileUIState get profileUIState => uiState.profileUIState;

  EventState get eventState => userCompanyState.eventState;
  ListUIState get eventListState => uiState.eventUIState.listUIState;
  EventUIState get eventUIState => uiState.eventUIState;

  ChatState get chatState => userCompanyState.chatState;
  DynamicFieldState get dynamicFieldState => userCompanyState.dynamicFieldState;
  ListUIState get chatListState => uiState.chatUIState.listUIState;
  ChatUIState get chatUIState => uiState.chatUIState;

  DesignState get designState => userCompanyState.designState;

  ListUIState get designListState => uiState.designUIState.listUIState;

  DesignUIState get designUIState => uiState.designUIState;

  UserState get userState => userCompanyState.userState;

  ListUIState get userListState => uiState.userUIState.listUIState;

  UserUIState get userUIState => uiState.userUIState;

  SettingsUIState get settingsUIState => uiState.settingsUIState;

  bool hasChanges() {
    switch (uiState.currentRoute) {
      // STARTER: ui state change - do not remove comment
      case PaymentEditScreen.route:
        return paymentUIState.editing!.isChanged == true;

      case ProductEditScreen.route:
        return productUIState.editing!.isChanged == true;

      case SocialEditScreen.route:
        return socialUIState.editing!.isChanged == true;

      case PhotoEditScreen.route:
        return photoUIState.editing!.isChanged == true;

      case WorkoutEditScreen.route:
        return workoutUIState.editing!.isChanged == true;

      case NotificationEditScreen.route:
        return notificationUIState.editing!.isChanged == true;

      case ProfileOperationEditScreen.route:
        return profileOperationUIState.editing!.isChanged == true;

      case ProfileEditScreen.route:
        return profileUIState.editing!.isChanged == true;

      case EventEditScreen.route:
        return eventUIState.editing!.isChanged == true;

      case CreateChatScreen.route:
        return chatUIState.editing!.isChanged == true;

      case DesignEditScreen.route:
        return designUIState.editing!.isChanged == true;
    }

    if (uiState.isInSettings) {
      return settingsUIState.isChanged;
    }

    if (uiState.currentRoute.endsWith('/edit')) {
      throw 'AppState.hasChanges is not defined for ${uiState.currentRoute}';
    }

    return false;
  }

  bool supportsVersion(String version) {
    final parts = version.split('.');
    final int major = int.parse(parts[0]);
    final int minor = int.parse(parts[1]);
    final int patch = int.parse(parts[2]);

    try {
      final serverParts = account.currentVersion.split('.');
      final int serverMajor = int.parse(serverParts[0]);
      final int serverMinor = int.parse(serverParts[1]);
      final int serverPatch = int.parse(serverParts[2]);

      return serverMajor >= major &&
          serverMinor >= minor &&
          serverPatch >= patch;
    } catch (e) {
      return false;
    }
  }

  AppEnvironment get environment {
    if (isTesting) {
      return AppEnvironment.testing;
    } else if (isDemo) {
      return AppEnvironment.demo;
    } else if (isStaging) {
      return AppEnvironment.staging;
    } else if (isHosted) {
      return AppEnvironment.hosted;
    } else {
      return AppEnvironment.selfhosted;
    }
  }

  bool get reportErrors => account.reportErrors;

  bool get isHosted => account.isOld ? account.isHosted : authState.isHosted;

  bool get isSelfHosted => !isHosted;

  bool get isDemo => cleanApiUrl(authState.url) == kFlutterDemoUrl;

  bool get isStaging => cleanApiUrl(authState.url) == kAppStagingUrl;

  bool get isProPlan => isEnterprisePlan || account.plan == kPlanPro;

  bool get isTrial => isHosted && account.isTrial;

  bool get isEnterprisePlan => isSelfHosted || account.plan == kPlanEnterprise;

  bool get isPaidAccount => isSelfHosted
      ? (isWhiteLabeled || account.plan == kPlanWhiteLabel)
      : ((isProPlan || isEnterprisePlan) && !isTrial);

  bool get isUsingPostmark => [
        if (isHosted) SettingsEntity.EMAIL_SENDING_METHOD_POSTMARK_HOSTED,
        SettingsEntity.EMAIL_SENDING_METHOD_POSTMARK,
      ].contains(company.settings.emailSendingMethod);

  bool get isUserConfirmed {
    if (isSelfHosted) {
      return true;
    }

    return (user.emailVerifiedAt ?? 0) > 0;
  }

  bool get canAddCompany =>
      userCompany.isOwner && companies.length < 10 && !isDemo;

  bool get isMenuCollapsed {
    if (prefState.isMobile) {
      return false;
    }

    return (prefState.isFilterVisible &&
            prefState.showMenu &&
            !uiState.isInSettings &&
            uiState.filterEntityType != null) ||
        prefState.isMenuCollapsed;
  }

  bool get isFullScreen {
    bool isFullScreen = false;
    final mainRoute = '/' + uiState.mainRoute;
    final subRoute = uiState.subRoute;
    if (uiState.currentRoute == DesignEditScreen.route) {
      isFullScreen = true;
    } else if (uiState.currentRoute == EventEditScreen.route &&
        ProjectConfig.fullWidthEntities().contains(EntityType.event)) {
      isFullScreen = true;
    } else if (uiState.currentRoute.contains(EventViewScreen.route) &&
        ProjectConfig.fullWidthEntities().contains(EntityType.event)) {
      isFullScreen = true;
    } else if (uiState.currentRoute.contains(ProfileViewScreen.route)  &&
        ProjectConfig.fullWidthEntities().contains(EntityType.profile) ) {
      isFullScreen = true;
    } else if (uiState.currentRoute == ProfileEditScreen.route &&
        ProjectConfig.fullWidthEntities().contains(EntityType.profile)) {
      isFullScreen = true;
    } else if (uiState.currentRoute == MessageScreen.route &&
        uiState.previousRoute == ProfileOperationViewScreen.route) {
      isFullScreen = true;
    }

    return isFullScreen;
  }

  bool get hasRecentlyEnteredPassword {
    if (Config.DEMO_MODE) {
      return true;
    }

    if (authState.lastEnteredPasswordAt == 0) {
      return false;
    }

    final millisecondsSinceEnteredPassword =
        DateTime.now().millisecondsSinceEpoch - authState.lastEnteredPasswordAt;

    return millisecondsSinceEnteredPassword < company.passwordTimeout;
  }

  DashboardUIState get dashboardUIState => uiState.dashboardUIState;

  get clientState => null;

  get groupState => null;

  get invoiceState => null;

  get legacyPaymentState => null;

  get expenseState => null;

  get taskState => null;

  get projectState => null;

  get quoteState => null;

  @override
  String toString() {
    final companyUpdated = userCompanyState.lastUpdated == 0
        ? 'Blank'
        : timeago.format(convertTimestampToDate(
            (userCompanyState.lastUpdated / 1000).round()));

    final staticUpdated = staticState.updatedAt == null ||
            staticState.updatedAt == 0
        ? 'Blank'
        : timeago.format(
            convertTimestampToDate((staticState.updatedAt! / 1000).round()));

    final passwordUpdated = authState.lastEnteredPasswordAt == 0
        ? 'Blank'
        : timeago.format(convertTimestampToDate(
            (authState.lastEnteredPasswordAt / 1000).round()));

    //return 'latestVersion: ${account.latestVersion}';
    //return 'Last Updated: ${userCompanyStates.map((state) => state.lastUpdated).join(',')}';
    //return 'Names: ${userCompanyStates.map((state) => state.company.id).join(',')}';
    //return 'Client Count: ${userCompanyState.clientState.list.length}, Last Updated: ${userCompanyState.lastUpdated}';
    //return 'Token: ${credentials.token} - ${userCompanyStates.map((state) => state?.token?.token ?? '').where((name) => name.isNotEmpty).join(',')}';
    //return 'Payment Terms: ${company.settings.defaultPaymentTerms}';
    //return 'Invitations: ${uiState.invoiceUIState.editing.invitations}';
    //return 'Selection: ${clientUIState.selectedId}';
    //return '${clientState.map[clientUIState.selectedId].gatewayTokens}';
    //return 'gatewayId: ${companyGatewayState.map[companyGatewayUIState.selectedId].gatewayId}';
    //return 'Language Id: ${company.settings.languageId}';
    //return 'Rates: ${staticState.currencyMap.keys.map((key) => 'Rate: ${staticState.currencyMap[key].exchangeRate}').join(',')}';
    //return 'LOG: ${clientState.map[clientUIState.selectedId]?.systemLogs ?? ''}';
    //return 'FREQ: ${recurringInvoiceUIState.editing.frequencyId}';
    //return ' Logs: ${company.systemLogs}';

    /*
    var str = '\n\n\n';
    for (var userCompany in userCompanyStates) {
      //str += userCompany.company.id + ' => ' + userCompany.token.token + '\n';
      str += ' ' +
          userCompany.company.displayName +
          ' => ' +
          userCompany.clientState.list.length.toString() +
          ' ' +
          userCompany.lastUpdated.toString() +
          '\n';
    }
    return str;
    */

    return '\n\nURL: ${authState.url}'
        '\nRoute: ${uiState.currentRoute}'
        '\nPrevious: ${uiState.previousRoute}'
        '\nPreview: ${uiState.previewStack}'
        '\nFilter: ${uiState.filterEntityType} ${uiState.filterEntityId}'
        '\nIs Loading: ${isLoading ? 'Yes' : 'No'}'
        '\nIs Saving: ${isSaving ? 'Yes' : 'No'}'
        '\nIs Loaded: ${isLoaded ? 'Yes' : 'No'}'
        '\nis Large: ${(company.isLarge) ? 'Yes' : 'No'}'
        '\nCompany: $companyUpdated${userCompanyState.isStale ? ' [S]' : ''}'
        '\nStatic: $staticUpdated${staticState.isStale ? ' [S]' : ''}'
        '\nPassword: $passwordUpdated${hasRecentlyEnteredPassword ? '' : ' [S]'}'
        '\nAccent: $hasAccentColor ${userCompany.settings.accentColor ?? ''}'
        '\n';
  }
}

class Credentials {
  const Credentials({required this.url, required this.token});

  final String url;
  final String token;
}

class SelectionState {
  const SelectionState({
    this.selectedId,
    this.filterEntityId,
    this.filterEntityType,
  });

  final String? selectedId;
  final String? filterEntityId;
  final EntityType? filterEntityType;

  @override
  bool operator ==(Object other) {
    if (other is SelectionState) {
      return selectedId == other.selectedId &&
          filterEntityId == other.filterEntityId &&
          filterEntityType == other.filterEntityType;
    }
    return false;
  }
}
