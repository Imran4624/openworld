import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/config/entity_state_config.dart';
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/data/models/dynamic_fields/dynamic_fields_modal.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/event/event_actions.dart';
import 'package:flutter_boilerplate/redux/profile/profile_actions.dart';
import 'package:flutter_boilerplate/redux/profile_operation/profile_operation_state.dart';
import 'package:flutter_boilerplate/ui/auth/login_vm.dart';
import 'package:flutter_boilerplate/utils/localization.dart';
import 'package:flutter_boilerplate/utils/platforms.dart';

// ignore_for_file: constant_identifier_names

class ProjectConfig {
  static AppType appType = AppType.opw;
  static double? getContainerPadding(double deviceWidth) {
    if(appType == AppType.opw) {
      if (deviceWidth > 1440) {
      return 140.0;
    }else if (deviceWidth > 1024) {
      return 100.0;
    }
      return null;
    }
    if (deviceWidth > 1440) {
      return 140.0;
    }
    return null;
  }

  static double? maxContainerPaddingForWidth(double deviceWidth) {
    switch (appType) {
      default:
        return getContainerPadding(deviceWidth);
    }
  }

  static bool get autoMessageFromAdminEnabled {
    switch (appType) {
      default:
        return false;
    }
  }
  static bool get isSidePaddingEnabled {
    switch (appType) {
      default:
        return true;
    }
  }

  static String get autoMessageFromAdminText {
    switch (appType) {
      default:
        return '';
    }
  }

  //#region App
  static bool get isDemo {
    switch (appType) {
      default:
        return true;
    }
  }

  static bool get isTesting {
    switch (appType) {
      default:
        return true;
    }
  }
  static bool get showBarcodeSubtitle {
    switch (appType) {
      default:
        return true;
    }
  }

  static bool get isTopbarScroollableForFullWidthEntities {
    switch (appType) {
      default:
        return false;
    }
  }

  static bool get isLoggingEnabled {
    switch (appType) {
      default:
        return true;
    }
  }

  static bool get enableGoogleAnalytics {
    switch (appType) {
      default:
        return false;
    }
  }

  static bool get sendAccountApprovedEmail {
    switch (appType) {
      default:
        return false;
    }
  }

  static bool get onboardingQuestionsOnSignupDisabled {
    switch (appType) {
      default:
        return false;
    }
  }

  static bool get openEntityFromUrlEnabled {
    switch (appType) {
      default:
        return false;
    }
  }

  static bool get showMenuDrawer {
    switch (appType) {
      default:
        return false;
    }
  }

  static bool showTopBar(String route, bool hiddenOverride) {
    if (hiddenOverride) return false;
    if (route.contains('_isPreview')) return false;
    switch (appType) {
      default:
        return false;
    }
  }

  static bool showTickOnEntity(EntityType entityType) {
    switch (entityType) {
      case EntityType.photo:
        return false;
      default:
        return true;
    }
  }

  static bool get showMyProfileInUserMenu {
    switch (appType) {
      default:
        return false;
    }
  }

  static bool get showEditProfileInUserMenu {
    switch (appType) {
      default:
        return true;
    }
  }

  static bool get devicePreviewEnabled {
    switch (appType) {
      default:
        return false;
    }
  }

  static String defaultEntityImage(EntityType entityType) {
    switch (entityType) {
      case EntityType.event:
        return 'assets/boilerplate/images/defaultEventPhoto.png';
      default:
        return 'assets/boilerplate/images/icon.png';
    }
  }

  static LoginViewType loginViewType() {
    switch (appType) {
      default:
        return LoginViewType.legacy;
    }
  }

  static String logoPath(bool isDarkMode) {
    switch (appType) {
      default:
        return 'assets/opw/logo.png';
    }
  }

  static String getPrivacyPolicyUrl() {
    switch (appType) {
      default:
        return '';
    }
  }

  static String getStorageType() {
    switch (appType) {
      default:
        return StorageType.firebase.toString();
    }
  }

  static bool enablePhoneLogin() {
    switch (appType) {
      default:
        return false;
    }
  }

  static bool showSelectLoginMethodTabs() {
    switch (appType) {
      default:
        return false;
    }
  }

  static String getTermsAndConditionsUrl() {
    switch (appType) {
      default:
        return '';
    }
  }

  static String defaultImage = 'images/defaultUserThumbnail.jpg';
  static String defaultUserIcon = 'assets/loopjam/images/defaultUserIcon.png';
  
  static String get defaultUserLocation {
    switch (appType) {
      default:
        return 'San Francisco';
    }
  }
  
  static Map<String, double> get defaultLocationCoordinates {
    switch (appType) {
      default:
        return {'latitude': 37.7749, 'longitude': -122.4194}; 
    }
  }
  
  static AppType get currentAppType => appType;
  //#endregion

  //#region Auth & Onboarding

  static bool get emailConfirmationEnabled {
    switch (appType) {
      default:
        return false;
    }
  }

  static String defaultNewUserStatus() {
    switch (appType) {
      default:
        return kEntityStateActive;
    }
  }

  static String defaultSettingsToOpenInDesktopView() {
    switch (appType) {
   
      default:
        return kSettingsDeviceSettings;
    }
  }

  static String defaultNewPhotoStatus() {
    switch (appType) {
      
      default:
        return kEntityStateActive;
    }
  }

  static String defaultNewProductStatus() {
    switch (appType) {
      default:
        return kEntityStateActive;
    }
  }

  static String defaultNewPostStatus() {
    switch (appType) {
      default:
        return kEntityStateActive;
    }
  }

  static EntityType get defaultEntityForLoggedInUser {
    switch (appType) {
      default:
        return EntityType.event;
    }
  }

  static PersistUI getDefaultEntityActionForLoggedInUser() {
    switch (ProjectConfig.defaultEntityForLoggedInUser) {
      case EntityType.event:
        return ViewEventList();
      default:
        return ViewProfileList();
    }
  }

  static EntityType get defaultEntityForGuestUser {
    switch (appType) {
      default:
        return EntityType.auth;
    }
  }

  static String get defaultRouteForGuestUser {
    switch (appType) {
      default:
        return LoginScreen.route;
    }
  }

  static IconData? get likeOrWaveIcon {
    switch (appType) {
      default:
        return Icons.favorite_border;
    }
  }
  static IconData get profileEntityDrawerIcon {
    switch (appType) {
      default:
        return Icons.person;
    }
  }

  static String get likeOrWaveRequestSent {
    switch (appType) {
      default:
        return "Match request sent";
    }
  }

  static String get matchOrWaveText {
    switch (appType) {
      default:
        return "Match";
    }
  }

  static String get matchedOrConnectedText {
    switch (appType) {
      default:
        return "Matched";
    }
  }

  static String get likeOrWaveNotificationText {
    switch (appType) {
      default:
        return "liked your profile";
    }
  }

  static String get profileModuleDisplayName {
    switch (appType) {
      default:
        return "Profile";
    }
  }

  static String get alertMessageForLikeOrWave {
    switch (appType) {
      default:
        return "You have already liked this profile";
    }
  }

  static String get alertMessageForLikedMeOrWavedMe {
    switch (appType) {
      default:
        return "This profile has liked you. Accept to match!";
    }
  }

  static String get alertMessageForMatchedOrWaved {
    switch (appType) {
      default:
        return "You are matched with this profile!";
    }
  }

  static String get accountIsDeletedMessageOnLogin {
    switch (appType) {
      default:
        return "Your account is blocked, Please contact the adminstrator.";
    }
  }

  static String get matchesOrConnections {
    switch (appType) {
      default:
        return 'Matches';
    }
  }

  static String get matchesOrConnectionsTabName {
    switch (appType) {
      default:
        return 'Matches';
    }
  }

  static String get iLikedOrIWaved {
    switch (appType) {
      default:
        return 'I Liked';
    }
  }

  static String get likedMeOrWavedMe {
    switch (appType) {
      default:
        return 'Liked me';
    }
  }

  static String profileOperationTabName(String tabName) {
    switch (tabName) {
      case ProfileOperationTab.likes:
        return iLikedOrIWaved;
      case ProfileOperationTab.likedMe:
        return likedMeOrWavedMe;
      case ProfileOperationTab.matches:
        return matchesOrConnectionsTabName;
      default:
        return tabName;
    }
  }

  static String? getTitleByEntityType(
      AppLocalization? localization, EntityType entityType) {
    if (entityType == EntityType.photo) {
      return 'Photos';
    }
    if (entityType == EntityType.social) {
      return 'Posts';
    }
    if (entityType == EntityType.product) {
      return 'Products';
    }
    return localization?.lookup('${entityType}s');
  }

  static bool isAccessAllowedForGuestUser(String route) {
    return false;
  }

  static List<LoginType> get allowLoginTypes {
    switch (appType) {
      default:
        return [LoginType.google, LoginType.linkInEmail];
    }
  }

  static List<EntityType> relatedEntities(EntityType entityType) {
    switch (appType) {
      default:
        return [];
    }
  }

  static List<EntityType> fullWidthEntities() {
    switch (appType) {
      default:
        return [EntityType.profile, EntityType.event];
    }
  }

  static bool get showAppLogoOnAuthScreens {
    switch (appType) {
      default:
        return false;
    }
  }

  static QuestionType get onBoardingQuestionType {
    switch (appType) {
      default:
        return QuestionType.opw;
    }
  }
  //#endregion

  //#region User & Permissions create_all,view_all,edit_all,
  static String get mockLoginPermission {
    switch (appType) {
      default:
        return 'edit_event,create_event,view_event,view_profile,edit_profile';
    }
  }

  static bool canGuestViewEntity(EntityType? entityType) {
    return mockLoginPermission
        .contains('${UserPermission.view}_${entityType!.snakeCase}');
  }

  static bool get accountManagementEnabled {
    return true;
  }

  static const List<EntityType> allowUserManagementPermissionsForEntities = [
    EntityType.chat,
    EntityType.profile,
  ];

  static BuiltSet<EntityState> allowedEntityStateActions(
      bool isAdmin, EntityType entityType) {
    if (isAdmin) {
      if (entityType == EntityType.profile) {
        return BuiltSet.of([
          EntityState.active,
          EntityState.archived,
          EntityState.deleted,
          EntityState.reported
        ]);
      } else if (entityType == EntityType.chat) {
        return BuiltSet.of([
          EntityState.active,
          EntityState.archived,
          EntityState.deleted,
        ]);
      }  else {
        return EntityState.values;
      }
    }

    switch (entityType) {
      case EntityType.photo:
        switch (appType) {
          default:
            return BuiltSet.of([EntityState.active, EntityState.myEntities]);
        }
      case EntityType.product:
      case EntityType.social:
        return BuiltSet.of([EntityState.active, EntityState.myEntities]);
      case EntityType.profile:
      default:
        return BuiltSet.of([
          EntityState.active,
          EntityState.archived,
          EntityState.deleted,
        ]);
    }
  }

  static List<String> get accountDeletedReason {
    switch (appType) {
      default:
        return [
          'No longer need the service',
          'Found alternative solution',
          'Not satisfied with the app',
          'Other',
        ];
    }
  }

  //#endregion

  //#region Profile
  static bool get canUserPassProfiles {
    switch (appType) {
      default:
        return true;
    }
  }
  static bool get excludeLikedMatchedProfiles {
    switch (appType) {
      default:
        return false;
    }
  }
  static bool get showProfileOperationsButtons {
    switch (appType) {
      default:
        return false;
    }
  }
  static bool get showProfileChatOperationButtons {
    switch (appType) {
      default:
        return true;
    }
  }

  static bool showReportButtonByEntityType(EntityType entityType) {
    switch (entityType) {
      case EntityType.profile:
      case EntityType.social:
        return true;
      default:
        return false;
    }
  }

  static bool showActionButtonByEntityType(EntityType entityType) {
    switch (entityType) {
      case EntityType.profile:
            return false;
      case EntityType.social:
        return false;
      default:
        return true;
    }
  }

  static bool showAboutMe() {
    switch (appType) {
      default:
        return false;
    }
  }

  static bool showProfileFilters() {
    switch (appType) {
      default:
        return false;
    }
  }

  static bool showUpdateVersionDialog() {
    switch (appType) {
     
      default:
        return false;
    }
  }

  static bool removeProfileAfterOperationPerformed() {
    switch (appType) {
      default:
        return true;
    }
  }

  static List<String> get displayFieldIds {
    switch (appType) {
      default:
        return ['city'];
    }
  }

  static bool get applyOppositeGenderFilterInSearchingProfiles {
    switch (appType) {
      default:
        return true;
    }
  }

  static const String usersProfileCollectionName = 'users';
  //#endregion

  //#region Chat
  static bool get chatUploadingDocEnabled {
    return false;
  }

  static bool get chatViewOnceEnabled {
    return false;
  }

  static bool get showEditButton {
    switch (appType) {
      default:
        return true;
    }
  }

  static bool get blurImagesByDefault {
    switch (appType) {
      default:
        return true;
    }
  }

  static const double defaultBlurIntensity = 10.0;
  // {
  //   switch (appType) {
  //     default:
  //       return 10.0;
  //   }
  // }
  //#endregion

  //#region Menu & Drawer
  static bool get showBuyBanner {
    return false;
  }

  static bool showBecomeAMemberBanner() {
    switch (appType) {
      default:
        return false;
    }
  }

  static bool showVerifyPhoneNumberBanner() {
    switch (appType) {
      default:
        return false;
    }
  }

  static bool showOtpBanner() {
    switch (appType) {
      default:
        return false;
    }
  }

  static bool showAdminPanelFooter() {
    switch (appType) {
      default:
        return false;
    }
  }

  static bool showEntityDrawerTabByEntityType(EntityType entityType) {
    switch (entityType) {
      case EntityType.profile:
            return false;
      case EntityType.photo:
        return true;
      case EntityType.event:
            return true;
      case EntityType.payment:
        switch (appType) {
          default:
            return false;
        }
      case EntityType.notification:
      default:
        return true;
    }
  }
  //#endregion

  //#region Settings
  static bool get settingsEnabled {
    switch (appType) {
      default:
        return false;
    }
  }

  static bool get settingsShowUserDetailsSetting {
    switch (appType) {
      default:
        return false;
    }
  }

  static bool get showlayoutSetting {
    switch (appType) {
      default:
        return false;
    }
  }
  //#endregion

  //#region Report user

  static bool showReportedStateByEntityType(EntityType entityType) {
    switch (entityType) {
      case EntityType.profile:
        return false;
      case EntityType.photo:
        return EntityType.photo != entityType;
      case EntityType.social:
        return EntityType.social != entityType;
      case EntityType.product:
        return EntityType.product != entityType;
      default:
        return true;
    }
  }

  static bool showReportedState(EntityState state, EntityType entityType) {
    switch (state) {
      case EntityState.reported:
        return showReportedStateByEntityType(entityType);
      default:
        return false;
    }
  }

  static bool addReportToEntityActions(
      EntityType? entityType, EntityAction action) {
    switch (action) {
      case EntityAction.reported:
        return showReportedStateByEntityType(entityType!);
      default:
        return false;
    }
  }

  //#endregion

  //#region Entity Actions text (active/archive/delete)

  static String getEntityActionText(EntityType? entityType, EntityAction action,
      {BaseEntity? entity}) {
    switch (action) {
      case EntityAction.archive:
        return EntityStateManager.getArchiveActionText(entityType!, entity);
      case EntityAction.delete:
        return EntityStateManager.getDeleteActionText(entityType!, entity);
      case EntityAction.restore:
        return EntityStateManager.getRestoreActionText(entityType!, entity);
      case EntityAction.reported:
        return 'Reported';
      default:
        return action.name;
    }
  }

  //#endregion

  //#region UI & Layout
  static bool showTitleByEntityType(EntityType entityType) {
    switch (entityType) {
      case EntityType.chat:
      case EntityType.profile:
      case EntityType.product:
        return true;
      case EntityType.photo:
        return true;
      case EntityType.event:
        return appType != AppType.opw;
      default:
        return false;
    }
  }

  static bool showActionFiltersAndCheckBox(EntityType entityType) {
    switch (entityType) {
      case EntityType.profile:
      case EntityType.profileOperation:
        return false;
      case EntityType.event:
        return false;
      default:
        return true;
    }
  }

  static bool showFloatingCreateButton(EntityType entityType) {
    switch (entityType) {
      case EntityType.profile:
      case EntityType.profileOperation:
        return false;
      case EntityType.event:
        return false;
      case EntityType.photo:
        return true;
      default:
        return true;
    }
  }

  static bool showFloatingButtons(EntityType entityType) {
    switch (appType) {
      default:
        return false;
    }
  }

  static bool showPlusCreateButton(EntityType entityType) {
    switch (entityType) {
      case EntityType.event:
      return appType == AppType.opw;
      case EntityType.chat:
      case EntityType.profile:
      case EntityType.profileOperation:
        return false;
      case EntityType.photo:
        return true;
      default:
        return true;
    }
  }

  static bool showBackArrowByEntityType(EntityType entityType) {
    switch (entityType) {
      case EntityType.profile:
        return false;
      default:
        return true;
    }
  }

  static bool showEntityActinsByEntityType(EntityType entityType) {
    switch (entityType) {
      case EntityType.chat:
      case EntityType.profile:
        return false;
      default:
        return true;
    }
  }

  static bool showSearchInputFieldByEntityType(EntityType entityType) {
    switch (entityType) {
      case EntityType.profile:
      case EntityType.chat:
      case EntityType.profileOperation:
      case EntityType.event:
      case EntityType.photo:
        return false;
      case EntityType.settings:
        switch (appType) {
          default:
            return true;
        }
      default:
        return true;
    }
  }

  static bool showMultiselectCheckboxByEntityType(
      EntityType entityType, AppState state) {
    switch (entityType) {
      case EntityType.profile:
      case EntityType.profileOperation:
      case EntityType.event:
        return false;
      // return appType == AppType.loopjam;
      case EntityType.photo:
        return state.photoState.filter.stateFilter == EntityState.myEntities;
      default:
        return true;
    }
  }

  static bool showSaveButtonByEntityType(EntityType entityType) {
    switch (entityType) {
      case EntityType.profile:
        return false;
      default:
        return true;
    }
  }

  static bool showBottomCheckBoxAndFiltersByEntityType(
      EntityType entityType, bool isAdmin) {
    switch (entityType) {
      case EntityType.chat:
        return true;
      case EntityType.event:
        return false;
      case EntityType.profileOperation:
        return false;
      case EntityType.profile:
        switch (appType) {
          default:
            return false;
        }
      default:
        return true;
    }
  }

  static bool removePadding(EntityType entityType) {
    switch (entityType) {
      case EntityType.chat:
      case EntityType.event:
        return true;
      default:
        return false;
    }
  }
  //#endregion

  //#region Misc Features
  static bool get showActivityLog {
    switch (appType) {
      default:
        return false;
    }
  }

  static bool get newDashboardViewByAppType {
    switch (appType) {
      default:
        return false;
    }
  }

  static bool get showDashboard {
    switch (appType) {
      default:
        return false;
    }
  }

  static bool get showDownloadForm {
    switch (appType) {
      default:
        return false;
    }
  }

  static bool get showSortingButton {
    switch (appType) {
      default:
        return false;
    }
  }

  static bool get showAttachmentButton {
    switch (appType) {
      default:
        return false;
    }
  }
  //#endregion

  static bool enableDeepLink(EntityType entityType) {
    switch (appType) {
      default:
        return false;
    }
  }

  static String getEntityDetailUrl(EntityType entityType, String entityId,
      {OriginatorType? originator}) {
    final baseUrl = _getBaseEntityUrl(entityType, entityId);
    return baseUrl;
  }

  static String _getBaseEntityUrl(EntityType entityType, String entityId) {
        switch (entityType) {
          case EntityType.event:
            return '/event/view?id=$entityId';
          case EntityType.photo:
            return '/photo/view?id=$entityId';
          case EntityType.profile:
            return '/profile/view?id=$entityId';
          default:
            return '';
        }
  }

  static List<EntityType> enabledEntitiesToUpdateUrl() {
    switch (appType) {
      default:
        return [];
    }
  }

  //#region Event Edit Fields Configuration
  static List<String> getEventEditFields() {
    switch (appType) {
      default:
        return [
          'name',
          'description',
          'start',
          'callToAction',
          'currency',
          'images',
          'status',
          'venue',
          'ticketTypes',
          'ticketGroups',
        ];
    }
  }

  static bool showEditEventUIForFullScreen() {
    switch (appType) {
      default:
        return false;
    }
  }
  static bool isLimitRemoved() {
    switch (appType) {
      default:
        return true;
    }
  }

  static bool downloadBarcodeEnabled() {
    switch (appType) {
      default:
        return false;
    }
  }

  static bool showClearFilterCrossButton() {
    switch (appType) {
      default:
        return false;
    }
  }

  static bool autoPopulateLocationEnabled() {
    switch (appType) {
      default:
        return false;
    }
  }

  static bool searchLocationGiveSuggestionsEnabled() {
    switch (appType) {
      default:
        return true;
    }
  }

  static bool showEditPhotoButton() {
    switch (appType) {
      default:
        return false;
    }
  }

  static bool showEditPhotoDialog() {
    switch (appType) {
      default:
        return false;
    }
  }

  static bool showDetailBottomButtonsForFullScreen() {
    switch (appType) {
      default:
        return true;
    }
  }

  static bool showRelatedEntitiesTopbarForFullScreen() {
    switch (appType) {
      default:
        return true;
    }
  }

  static bool showMyEventsAndAllEventsDropdown(EntityType entityType) {
    switch (entityType) {
      default:
        return false;
    }
  }

  static bool showCreateEditInDialog(EntityType entityType) {
    switch (appType) {
      default:
        return false;
    }
  }

  static String defaultHelperTextForNoRecords() {
    switch (appType) {
      default:
        return 'See your moments and create events to share with friends here.';
    }
  }

  static bool defaultBackgroundImageForNoRecords(EntityType entityType) {
    switch (entityType) {
      default:
        return false;
    }
  }

  static ViewType listViewType(EntityType entityType) {
    switch (appType) {
      default:
        return ViewType.list;
    }
  }

  static bool showMyEventsAndAllEventsTabs() {
    switch (appType) {
      default:
        return false;
    }
  }

  static bool showTopbarBackground() {
    switch (appType) {
      default:
        return true;
    }
  }

  static bool showTopbarForPhotos(BuildContext context, bool originatorIsGuest,
      {bool isEventAuthor = false}) {
    switch (appType) {
      default:
        return isDesktop(context);
    }
  }

  static bool showEntityTopBar(String route, bool isMobile, {EntityType? entityType}) {
    switch (appType) {
      default:
        return false;
    }
  }

  static String? defaultThemeLightOrDark() {
    switch (appType) {
      default:
        return kBrightnessLight;
    }
  }

  static bool swipingProfilesEnabled( bool isAdmin) {
    switch (appType) {
      default:
        return false;
    }
  }
  //#endregion

  static Map<String, dynamic> get pricingRulesJson => {
        "pricingRules": {
          "rules": [
            {
              "planName": "Free",
              "billingType": "free",
              "startDate": "2024-01-01T00:00:00Z",
              "endDate": "2030-01-01T00:00:00Z",
              "entities": [
                {
                  "entityType": "event",
                  "rules": {
                    "maxCreate": 1,
                    "storagePerEntityMB": 500,
                    "capabilities": {
                      "hostUploads": true,
                      "guestUploads": false,
                      "shareEnabled": false
                    }
                  }
                },
                {
                  "entityType": "dating",
                  "rules": {
                    "dailyMatchLimit": 3,
                    "capabilities": {
                      "canSendMessages": false,
                      "canSeeProfiles": true
                    }
                  }
                }
              ]
            },
            {
              "planName": "Paid",
              "billingType": "paid",
              "startDate": "2024-01-01T00:00:00Z",
              "endDate": "2030-01-01T00:00:00Z",
              "entities": [
                {
                  "entityType": "event",
                  "rules": {
                    "maxCreate": 999999,
                    "storagePerEntityMB": 500,
                    "capabilities": {
                      "hostUploads": true,
                      "guestUploads": true,
                      "shareEnabled": true
                    },
                    "lifecycle": {
                      "activeDuration": {"value": 12, "unit": "months"},
                      "states": {
                        "onActivate": "active",
                        "onExpiry": "view_only"
                      }
                    }
                  }
                },
                {
                  "entityType": "dating",
                  "rules": {
                    "dailyMatchLimit": 10,
                    "capabilities": {
                      "canSendMessages": true,
                      "canSeeProfiles": true
                    }
                  }
                }
              ]
            }
          ]
        }
      };

  static String get stripeGuestLandingPagePriceId =>
      "price_1SYNF6PlYE40TDcBdMZa88bM";
  static double get guestLandingPagePrice => 59.0; 
}

enum AppType {
   boilerplate,
  loopjam,
  boilerplatelocal,
  mis,
  cac,
  datingdemo,
  datingdemozawaj,
  lm,
  lp,
  lvc,
  opw,
  events121,
}

enum LoginViewType {
  legacy,
  improved,
}

enum LoginType {
  google,
  email,
  apple,
  phone,
  linkInEmail,
}
