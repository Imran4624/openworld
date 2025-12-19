class Constants {
  //static String get hostedApiUrl => kReleaseMode ? kAppProductionUrl : kAppStagingUrl;
  static String get hostedApiUrl => kAppProductionUrl;
}

class DynamicFieldsConstants {
  //static String get hostedApiUrl => kReleaseMode ? kAppProductionUrl : kAppStagingUrl;
  static String get images => 'images';
  static String get name => 'name';
  static String get email => 'email';
  static String get age => 'age';
  static String get dob => 'dob';
  static String get gender => 'gender';
  static String get socialLinks => 'social_links';
  static String get reason => 'reason_for_joining';
}

class DrawerActions {
  static String get changePassword => 'changePassword';
  static String get editProfile => 'editProfile';
  static String get myProfile => 'myProfile';
  static String get logout => 'logout';
  static String get login => 'login';
  static String get deleteAccount => 'deleteAccount';
  static String get connectAccount => 'connectAccount';
}
enum OriginatorType {
  defaultType,
  guest,
}

extension OriginatorTypeExtension on OriginatorType {
  String get value {
    switch (this) {
      case OriginatorType.defaultType:
        return 'default';
      case OriginatorType.guest:
        return 'guest';
    }
  }

  static OriginatorType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'guest':
        return OriginatorType.guest;
      case 'default':
      default:
        return OriginatorType.defaultType;
    }
  }
}

class AttendeeStatus {
  static String get guest => 'Guest';
  static String get main => 'Main';
  static String get pending => 'pending';
  static String get approved => 'approved';
  static String get rejected => 'rejected';
  static String get owner => 'owner';
}
class RSPV {
  static String get yes => 'Yes';
  static String get no => 'No';
  static String get maybe => 'Maybe';
  static String get request => 'request';
}

class EventOperationType {
  static const int saved = 1;
  static const int viewed = 2;
}

class CallToActionType {
  static const String thirdParty = 'thirdParty';
}

const String kClientVersion = '5.0.171';
const String kMinServerVersion = '5.0.4';

const String kDefaultName = 'Name not provided';
const String kMyAccount = 'My Account';
const String kSiteUrl = 'https://flutterboilerplate.com';
const String kAppProductionUrl = 'https://domain.co';
const String kAppReactUrl = 'https://app.abc.co';
const String kAppStagingUrl = 'https://staging.abc.co';
const String kAppStagingNetUrl = 'https://flutterboilerplate.net';
const String kAppLargeTestUrl = 'https://testv5.domain.co';
const String kFlutterDemoUrl = 'https://demo.flutterboilerplate.com';
const String kReactDemoUrl = 'https://react.domain.co/demo';
const String kGoogleApiKey =
    'AIzaSyAkyoOQkXsMJMt7zw-gyuInIPU9Z3--Vxk&libraries=places';
const String kAzureMapsApiKey =
    '3ku1comgJOz9pvekJDfUKfX2SNd5U0AHX011kw931MRv9u1olqNgJQQJ99BEACYeBjFg9drfAAAgAZMP26zc';
const String kWhiteLabelUrl =
    'https://flutterboilerplate.domain.co/client/subscriptions/O5xe7Rwd7r/purchase?account_key=AsFmBAeLXF0IKf7tmi0eiyZfmWW9hxMT&product_id=3';
const String kBankingURL = 'https://flutterboilerplate.com/banking';
const String kReferralURL = 'https://flutterboilerplate.com/referrals';
const String kTransifexURL =
    'https://www.transifex.com/invoice-ninja/invoice-ninja';
const String kWebhookSiteURL = 'https://requestcatcher.com';
const String kZipTaxURL = 'https://zip-tax.com';
const String kSourceCodeBackend =
    'https://github.com/flutterboilerplate/flutterboilerplate/tree/v5-stable';
const String kSourceCodeFrontend =
    'https://github.com/flutterboilerplate/admin-portal';
const String kSourceCodeFrontendSDK =
    'https://pub.dev/packages/flutterboilerplate';

const String kPlayStoreAppId = 'com.example.boilerplate';
const String kAppStoreAppId = 'id1503970375';

const String kMicrosoftAppStoreId = '9N3F2BBCFDR6';
const String kAppleStoreUrl =
    'https://apps.apple.com/us/app/invoice-ninja-v5/$kAppStoreAppId';
const String kGoogleStoreUrl =
    'https://play.google.com/store/apps/details?id=$kPlayStoreAppId';
const String kGoogleFDroidUrl =
    'https://f-droid.org/packages/com.example.boilerplate';
const String kMacOSUrl = 'https://apps.apple.com/app/$kAppStoreAppId';
const String kLinuxUrl = 'https://snapcraft.io/flutterboilerplate';
const String kWindowsUrl =
    'https://apps.microsoft.com/store/detail/invoice-ninja/$kMicrosoftAppStoreId';

const String kSlackUrl = 'http://slack.flutterboilerplate.com';
const String kGitHubUrl = 'https://github.com/flutterboilerplate';
const String kTwitterUrl = 'https://twitter.com/flutterboilerplate';
const String kFacebookUrl = 'https://www.facebook.com/flutterboilerplate';
const String kYouTubeUrl =
    'https://www.youtube.com/channel/UCXAHcBvhW05PDtWYIq7WDFA/videos';

const String kTemplatesYouTubeUrl =
    'https://www.youtube.com/watch?v=kfG5vvcbYes';
const String kTemplatesDocsUrl =
    'https://flutterboilerplate.github.io/en/templates';

const String kYodleeCoverageUrl =
    'https://www.yodlee.com/open-banking/data-connections';
const String kNordigenCoverageUrl =
    'https://gocardless.com/bank-account-data/coverage';
const String kNordigenOverviewUrl = 'https://gocardless.com/bank-account-data';

const String kTaskExtensionUrl =
    'https://chromewebstore.google.com/detail/invoice-ninja-tasks/dlfcbfdpemfnjbjlladogijcchfmmaaf';
const String kTaskExtensionYouTubeUrl =
    'https://www.youtube.com/watch?v=UL0OklMJTEA&ab_channel=FlutterBoilerplate';

const String kAppleOAuthClientId = 'com.flutterboilerplate.client';
const String kAppleOAuthRedirectUrl = 'https://domain.co/auth/apple';

const String kReleaseNotesUrl =
    'https://github.com/flutterboilerplate/flutterboilerplate/releases';
const String kDocsUrl = 'https://flutterboilerplate.github.io/en';
const String kCacBecomeMember =
    'https://www.tickettailor.com/events/cocktailsconversation/store';
const String kDocsCustomDomainUrl = '$kDocsUrl/hosted-custom-domain';
const String kDocsCustomDesignUrl = '$kDocsUrl/custom-fields';
const String kDocsCustomFieldsUrl = '$kDocsUrl/custom-fields/#custom-fields';
const String kDocsEmailVariablesUrl =
    '$kDocsUrl/email-customization/#payment-email-customization';
const String kDocsStripeConnectUrl = '$kDocsUrl/hosted-stripe';

const String kPHPDateFormatsUrl =
    'https://www.php.net/manual/en/datetime.format.php#refsect1-datetime.format-parameters';
const String kForumUrl = 'https://forum.flutterboilerplate.com';
const String kApiDocsUrl = 'https://api-docs.domain.co';
const String kZapierUrl = 'https://zapier.com/apps/invoice-ninja';
const String kGatewayFeeHelpURL =
    'https://support.stripe.com/questions/passing-the-stripe-fee-on-to-customers';

const String kDebugModeUrl = '$kDocsUrl/self-host-debug-mode';
const String kCapterralUrl = 'https://www.capterra.com/p/145215/Invoice-Ninja';
const String kCronsHelpUrl =
    '$kDocsUrl/self-host-troubleshooting/#cron-not-running-queue-not-running';
const String kGitHubDiffUrl =
    'https://github.com/flutterboilerplate/flutterboilerplate/compare/vVERSION...v5-stable';
const String kGitHubLangUrl =
    'https://github.com/flutterboilerplate/flutterboilerplate/blob/master/resources/lang/en/texts.php';
const String kStatusCheckUrl = 'https://status.flutterboilerplate.com';
const String kGoogleAnalyticsUrl =
    'https://support.google.com/analytics/answer/1037249?hl=en';
const String kContactUsUrl = 'https://bestflutterboilerplate.com/contact-us';

enum AppEnvironment {
  hosted,
  selfhosted,
  testing,
  demo,
  staging,
  develop,
}

enum ImageViewType { thumbnail, thumbnailBig, detail }

enum ViewType {
  list,
  grid,
  gridImproved,
  columns,
}

enum EntityViewType {
  profileFilters,
  defaultEntity,
}

enum DynamicFieldSubmissionType {
  edit,
  create,
  search,
}

enum ChatStatus {
  inProgress,
  active,
  deleted,
}

enum CEntityType {
  none,
  user,
  company,
}

enum MessageStatus {
  delivered,
  read,
  systemGenerated,
  deleted,
}

enum ParticipantRole {
  admin,
  member,
}

class LikeType {
  static const int normal = 1;
  static const int superLike = 2;
  static const int discreet = 4;
}
class StorageType {
  static const int firebase = 1;
  static const int azure = 2;
}

class MatchStatus {
  static const int pending = 1;
  static const int matched = 2;
  static const int declined = 4;
  static const int photoRevealed = 8;
  static const int chatEnabled = 16;
}

class ProfileOperationType {
  static const int like = 1;
  static const int pass = 2;
  static const int block = 4;
  static const int report = 4;
  static const int match = 5;
  static const int favorite = 6;
}

const String kSharedPrefs = 'shared_prefs';
const String kSharedPrefUrl = 'url';
const String kSharedPrefToken = 'checksum';
const String kSharedPrefWidth = 'width';
const String kSharedPrefHeight = 'height';
const String kSharedPrefMaximized = 'maximized';
const String kSharedPrefHostOverride = 'host_override';
const String kSharedPrefCompanyId = 'company_id';
const String kSharedPrefLastEmail = 'last_email';
const String kSharedPrefDeviceId = 'device_id';
const String kLoggingCollectionName = 'logs';

const String kProductProPlanMonth = 'pro_plan';
const String kProductEnterprisePlanMonth_2 = 'enterprise_plan';
const String kProductEnterprisePlanMonth_5 = 'enterprise_plan_5';
const String kProductEnterprisePlanMonth_10 = 'enterprise_plan_10';
const String kProductEnterprisePlanMonth_20 = 'enterprise_plan_20';
const String kProductProPlanYear = 'pro_plan_annual';
const String kProductEnterprisePlanYear_2 = 'enterprise_plan_annual';
const String kProductEnterprisePlanYear_5 = 'enterprise_plan_annual_5';
const String kProductEnterprisePlanYear_10 = 'enterprise_plan_annual_10';
const String kProductEnterprisePlanYear_20 = 'enterprise_plan_annual_20';

const kProductPlans = [
  kProductProPlanMonth,
  kProductEnterprisePlanMonth_2,
  kProductEnterprisePlanMonth_5,
  kProductEnterprisePlanMonth_10,
  kProductEnterprisePlanMonth_20,
  kProductProPlanYear,
  kProductEnterprisePlanYear_2,
  kProductEnterprisePlanYear_5,
  kProductEnterprisePlanYear_10,
  kProductEnterprisePlanYear_20,
];

const double kMobileLayoutWidth = 700;
const double kMobileDialogPadding = 12;
const double kDrawerWidthMobile = 272;
const double kDrawerWidthDesktop = 210;
const double kTableColumnGap = 16;
const double kTopBottomBarHeight = 50;
const double kDialogWidth = 400;
const double kDashboardPanelHeight = 543; // TODO remove this
const double kDashboardPanelHeightWeb = 539; // TODO remove this
const double kListNumberWidth = 100;
const double kBorderRadius = 2;

const double kTabletLayoutWidth = 1100;
const double kTabletDialogPadding = 250;

const double kTableColumnWidthMin = 80;
const double kTableColumnWidthMax = 200;

const int kTableListWidthCutoff = 550;
const int kDefaultAnimationDuration = 500;

const int kCardTypeVisa = 1;
const int kCardTypeMasterCard = 2;
const int kCardTypeAmEx = 4;
const int kCardTypeDiners = 8;
const int kCardTypeDiscover = 16;
const int kMaxImageSizeInKb = 12;

const String kPaymentTypeVisa = '5';
const String kPaymentTypeMasterCard = '6';
const String kPaymentTypeAmEx = '7';
const String kPaymentTypeDiners = '9';
const String kPaymentTypeDiscover = '8';
const String kPaymentTypeCredit = '32';

const String kPlanFree = '';
const String kPlanPro = 'pro';
const String kPlanEnterprise = 'enterprise';
const String kPlanWhiteLabel = 'white_label';

const String kBrightnessLight = 'light';
const String kBrightnessDark = 'dark';
const String kBrightnessSytem = 'system';

const String kColorThemeLight = 'light';
const String kColorThemeDark = 'dark';

const double kGutterWidth = 16;
const double kLighterOpacity = .6;
const double KButtonHeight = 40;
const double KButtonWidth = 400;

const int kMaxNumberOfCompanies = 10;
const int kMaxNumberOfHistory = 50;
const int kMaxPostSeconds = 120;
const int kMaxRawPostSeconds = 600;
const int kMaxEntitiesPerBulkAction = 100;
const int kMaxRecordsPerPage = 5000;
const int kMillisecondsToTimerRefreshData =
    1000 * 60 * 60 * 24 * 1000; // 1000 days
const int kMillisecondsToRefreshData = 1000 * 60 * 60 * 24 * 1000; // 1000 days
const int kUpdatedAtBufferSeconds = 600;
const int kMillisecondsToRefreshActivities = 1000 * 60 * 60 * 24; // 1 day
const int kMillisecondsToRefreshStaticData = 1000 * 60 * 60 * 24; // 1 day
const int kMillisecondsToDebounceUpdate = 500; // .5 second
const int kMillisecondsToDebounceSave = 1500; // 1.5 seconds
const int kMillisecondsToDebounceWrite = 3000; // 3 seconds
const int kMessageLoadLimit = 20;
const int kChatLoadLimit = 10;
const int kEventLoadLimit = 20;

const String kLanguageEnglish = '1';
const String kParticipantName = 'Name Not Found';

const String kCurrencyAll = '-1';
const String kCurrencyUSDollar = '1';
const String kCurrencyEuro = '3';

const String kCountryUnitedStates = '840';
const String kCountryAustralia = '36';
const String kCountryCanada = '124';
const String kCountrySwitzerland = '756';

const String kDocumentStatusPublic = '-1';
const String kDocumentStatusPrivate = '-2';
const String kDocumentStatusImage = '-3';
const String kDocumentStatusPDF = '-4';
const String kDocumentStatusOther = '-5';

const String kGatewayTypeCreditCard = '1';
const String kGatewayTypeBankTransfer = '2';
const String kGatewayTypePayPal = '3';
const String kGatewayTypeCrypto = '4';
const String kGatewayTypeCustom = '5';
const String kGatewayTypeAlipay = '6';
const String kGatewayTypeSofort = '7';
const String kGatewayTypeApplePay = '8';
const String kGatewayTypeSEPA = '9';
const String kGatewayTypeCredit = '10';
const String kGatewayTypeKBC = '11';
const String kGatewayTypeBancontact = '12';
const String kGatewayTypeIDeal = '13';
const String kGatewayTypeHosted = '14';
const String kGatewayTypeGiropay = '15';
const String kGatewayTypePrzelewy24 = '16';
const String kGatewayTypeEPS = '17';
const String kGatewayTypeDirectDebit = '18';
const String kGatewayTypeACSS = '19';
const String kGatewayTypeBECS = '20';
const String kGatewayTypeInstantBankPay = '21';
const String kGatewayTypeFPX = '22';
const String kGatewayTypeKlarna = '23';
const String kGatewayTypeBacs = '24';
const String kGatewayTypeVenmo = '25';
const String kGatewayTypeMercadoPago = '26';
const String kGatewayTypeMyBank = '27';
const String kGatewayTypePayLater = '28';
const String kGatewayTypeAdvancedCards = '29';

const kGatewayTypes = {
  kGatewayTypeCreditCard: 'credit_card',
  kGatewayTypeBankTransfer: 'bank_transfer',
  kGatewayTypePayPal: 'paypal',
  kGatewayTypeCrypto: 'crypto',
  kGatewayTypeCustom: 'custom',
  kGatewayTypeAlipay: 'alipay',
  kGatewayTypeSofort: 'sofort',
  kGatewayTypeApplePay: 'apple_pay',
  kGatewayTypeSEPA: 'sepa',
  kGatewayTypeCredit: 'credit',
  kGatewayTypeKBC: 'kbc',
  kGatewayTypeBancontact: 'bancontact',
  kGatewayTypeIDeal: 'ideal',
  kGatewayTypeHosted: 'hosted',
  kGatewayTypeGiropay: 'giropay',
  kGatewayTypePrzelewy24: 'przelewy24',
  kGatewayTypeDirectDebit: 'direct_debit',
  kGatewayTypeEPS: 'eps',
  kGatewayTypeACSS: 'acss',
  kGatewayTypeBECS: 'becs',
  kGatewayTypeInstantBankPay: 'instant_bank_pay',
  kGatewayTypeFPX: 'fpx',
  kGatewayTypeKlarna: 'klarna',
  kGatewayTypeBacs: 'bacs',
  kGatewayTypeVenmo: 'venmo',
  kGatewayTypeMercadoPago: 'mercado_pago',
  kGatewayTypeMyBank: 'my_bank',
  kGatewayTypePayLater: 'pay_later',
  kGatewayTypeAdvancedCards: 'advanced_cards',
};

const String kNotificationChannelEmail = 'email';
const String kNotificationChannelSlack = 'slack';

const String kPlatformWindows = 'Windows';
const String kPlatformLinux = 'Linux';
const String kPlatformMacOS = 'macOS';
const String kPlatformAndroid = 'Android';
const String kPlatformiPhone = 'iPhone';

const String kNotificationsAll = 'all_notifications';
const String kNotificationsAllUser = 'all_user_notifications';
const String kNotificationsTaskAssigned = 'task_assigned';

const kNotificationEvents = [kNotificationsTaskAssigned];

const String kGatewayStripe = 'd14dd26a37cecc30fdd65700bfb55b23';
const String kGatewayStripeConnect = 'd14dd26a47cecc30fdd65700bfb67b34';
const String kGatewayGoCardlessOAuth = 'b9886f9257f0c6ee7c302f1c74475f6c';
const String kGatewayAuthorizeNet = '3b6621f970ab18887c4f6dca78d3f8bb';
const String kGatewayCheckoutCom = '3758e7f7c6f4cecf0f4f348b9a00f456';
const String kGatewayPayPalREST = '80af24a6a691230bbec33e930ab40665';
const String kGatewayPayPalExpress = '38f2c48af60c7dd69e04248cbb24c36e';
const String kGatewayPayPalPlatform = '80af24a6a691230bbec33e930ab40666';
const String kGatewayWePay = '8fdeed552015b3c7b44ed6c8ebd9e992';
const String kGatewayCustom = '54faab2ab6e3223dbe848b1686490baa';

const String kClientPortalModeSubdomain = 'subdomain';
const String kClientPortalModeDomain = 'domain';
const String kClientPortalModeIFrame = 'iframe';

const String kGenerateNumberWhenSaved = 'when_saved';
const String kGenerateNumberWhenSent = 'when_sent';

const String kDesignHeader = 'header';
const String kDesignBody = 'body';
const String kDesignFooter = 'footer';
const String kDesignProducts = 'product';
const String kDesignTasks = 'task';
const String kDesignIncludes = 'includes';

const String kEmailDesignPlain = 'plain';
const String kEmailDesignLight = 'light';
const String kEmailDesignDark = 'dark';
const String kEmailDesignCustom = 'custom';

const String kEntityStateActive = 'active';
const String kEntityStateArchived = 'archived';
const String kEntityStateDeleted = 'deleted';
const String kEntityStateReported = 'reported';

const String kFieldTypeSingleLineText = 'single_line_text';
const String kFieldTypeMultiLineText = 'multi_line_text';
const String kFieldTypeDropdown = 'dropdown';
const String kFieldTypeDate = 'date';
const String kFieldTypeSwitch = 'switch';

const String kSwitchValueYes = 'yes';
const String kSwitchValueNo = 'no';

const String kTaskStatusLogged = '-1';
const String kTaskStatusRunning = '-2';
const String kTaskStatusInvoiced = '-3';

const kTaskStatuses = {
  kTaskStatusLogged: 'logged',
  kTaskStatusRunning: 'running',
  kTaskStatusInvoiced: 'invoiced',
};

const String kMain = 'main';
const String kSettings = 'settings';
const String kDashboard = 'dashboard';
const String kReports = 'reports';
const String kKanban = 'kanban';
const String kMarathonMap = 'marathon_map';
const String kAboutUs = 'about-us';

const String kSettingsCompanyDetails = 'company_details';
const String kSettingsUserDetails = 'user_details';
const String kSettingsLocalization = 'localization';
const String kSettingsPaymentSettings = 'payment_settings';
const String kSettingsCompanyGateways = 'company_gateways';
const String kSettingsCompanyGatewaysView = 'company_gateways/view';
const String kSettingsCompanyGatewaysEdit = 'company_gateways/edit';
const String kSettingsTaxSettings = 'tax_settings';
const String kSettingsTaxRates = 'tax_settings_rates';
const String kSettingsTaxRatesView = 'tax_settings_rates/view';
const String kSettingsTaxRatesEdit = 'tax_settings_rates/edit';
const String kSettingsProducts = 'product_settings';
const String kSettingsTasks = 'task_settings';
const String kSettingsExpenses = 'expense_settings';
const String kSettingsImportExport = 'import_export';
const String kSettingsDeviceSettings = 'device_settings';
const String kSettingsCustomFields = 'custom_fields';
const String kSettingsCustomDesigns = 'custom_designs';
const String kSettingsCustomDesignsView = 'custom_designs/view';
const String kSettingsCustomDesignsEdit = 'custom_designs/edit';
const String kSettingsGeneratedNumbers = 'generated_numbers';
const String kSettingsWorkflowSettings = 'workflow_settings';
const String kSettingsInvoiceDesign = 'invoice_design';
const String kSettingsClientPortal = 'client_portal';
const String kSettingsEmailSettings = 'email_settings';
const String kSettingsTemplatesAndReminders = 'templates_and_reminders';
const String kSettingsDataVisualizations = 'data_visualizations';
const String kSettingsApiTokens = 'api_tokens';
const String kSettingsUserManagement = 'user_management';
const String kSettingsUserManagementView = 'user_management/view';
const String kSettingsUserManagementEdit = 'user_management/edit';
const String kSettingsAccountManagement = 'account_management';
const String kSettingsTokens = 'tokens';
const String kSettingsTokenView = 'token/view';
const String kSettingsTokenEdit = 'token/edit';
const String kSettingsWebhooks = 'webhook';
const String kSettingsWebhookView = 'webhook/view';
const String kSettingsWebhookEdit = 'webhook/edit';
const String kSettingsTaskStatuses = 'task_status';
const String kSettingsTaskStatusView = 'task_status/view';
const String kSettingsTaskStatusEdit = 'task_status/edit';

const List<String> kAdvancedSettings = [
  kSettingsUserManagement,
];

const String kPdfFieldsClientDetails = 'client_details';
const String kPdfFieldsCompanyDetails = 'company_details';
const String kPdfFieldsCompanyAddress = 'company_address';
const String kPdfFieldsInvoiceDetails = 'invoice_details';
const String kPdfFieldsQuoteDetails = 'quote_details';
const String kPdfFieldsCreditDetails = 'credit_details';
const String kPdfFieldsProductColumns = 'product_columns';
const String kPdfFieldsProductQuoteColumns = 'product_quote_columns';
const String kPdfFieldsVendorDetails = 'vendor_details';
const String kPdfFieldsPurchaseOrderDetails = 'purchase_order_details';
const String kPdfFieldsTaskColumns = 'task_columns';
const String kPdfFieldsTotalFields = 'total_columns';

const String kPdfFields = '';
const String kPermissionCreateAll = 'create_all';
const String kPermissionViewAll = 'view_all';
const String kPermissionEditAll = 'edit_all';
const String kPermissionViewReports = 'view_reports';
const String kPermissionViewDashboard = 'view_dashboard';

const String kDefaultCurrencyId = '1';
const String kDefaultLanguageId = '1';
const String kDefaultDateFormat = '5';
const String kDefaultAccentColor = '#2F7DC3';
const String kDefaultDarkSelectedColorMenu = '#1E252F';
const String kDefaultDarkSelectedColor = '#253750';
const String kDefaultDarkBorderColor = '#393A3C';
const String kDefaultLightSelectedColorMenu = '#f2faff';
const String kDefaultLightSelectedColor = '#e5f5ff';
const String kDefaultLightBorderColor = '#dfdfdf';

const String kTaxRegionUnitedStates = 'US';
const String kTaxRegionEurope = 'EU';
const String kTaxRegionAustralia = 'AU';

const String kReportGroupDay = 'day';
const String kReportGroupWeek = 'week';
const String kReportGroupMonth = 'month';
const String kReportGroupQuarter = 'quarter';
const String kReportGroupYear = 'year';

const String kRoundTo1Minute = '1_minute';
const String kRoundTo5Minutes = '5_minutes';
const String kRoundTo15Minutes = '15_minutes';
const String kRoundTo30Minutes = '30_minutes';
const String kRoundTo1Hour = '1_hour';
const String kRoundTo1Day = '1_day';
const String kRoundToCustom = 'custom';

const kTaskRoundingOptions = {
  kRoundTo1Minute: 60,
  kRoundTo5Minutes: 60 * 5,
  kRoundTo15Minutes: 60 * 15,
  kRoundTo30Minutes: 60 * 30,
  kRoundTo1Hour: 60 * 60,
  kRoundTo1Day: 60 * 60 * 24,
  kRoundToCustom: 0,
};

const int kModuleTasks = 8;
const int kModuleProjects = 32;
const int kModuleDocuments = 128;

const int allowChatWithXUsers = -1;

const Map<int, String> kModules = {
  kModuleProjects: 'projects',
  kModuleTasks: 'tasks',
  kModuleDocuments: 'documents',
};

const List<int> kPaymentTerms = [0, -1, 7, 10, 14, 15, 30, 60, 90];

const List<String> kLanguages = [
  'ar',
  'bg',
  'ca',
  'cs',
  'da',
  'de',
  'el',
  'en',
  'en_GB',
  'en_AU',
  'es',
  'es_ES',
  'et',
  'fa',
  'fi',
  'fr',
  'fr_CA',
  'fr_CH',
  'hu',
  'hr',
  'it',
  'ja',
  'lo_LA',
  'lt',
  'lv_LV',
  'mk_MK',
  'nb_NO',
  'nl',
  'pl',
  'pt_BR',
  'pt_PT',
  'ro',
  'ru_RU',
  'sk',
  'sl',
  'sq',
  'sr',
  'sv',
  'th',
  'tr_TR',
  'zh_TW',
];

List<String> kCustomLabels = [
  'address1',
  'address2',
  'amount',
  'balance',
  'country',
  'credit',
  'credit_card',
  'date',
  'description',
  'details',
  'discount',
  'due_date',
  'email',
  'from',
  'hours',
  'id_number',
  'invoice',
  'item',
  'line_total',
  'paid_to_date',
  'partial_due',
  'payment_date',
  'phone',
  'po_number',
  'product',
  'products',
  'quantity',
  'quote',
  'rate',
  'service',
  'statement',
  'subtotal',
  'surcharge',
  'tax',
  'taxes',
  'invoice_terms',
  'quote_terms',
  'credit_terms',
  'to',
  'total',
  'unit_cost',
  'valid_until',
  'vat_number',
  'website',
];

const kDaysOfTheWeek = {
  '0': 'sunday',
  '1': 'monday',
  '2': 'tuesday',
  '3': 'wednesday',
  '4': 'thursday',
  '5': 'friday',
  '6': 'saturday',
};

const kMonthsOfTheYear = {
  '1': 'january',
  '2': 'february',
  '3': 'march',
  '4': 'april',
  '5': 'may',
  '6': 'june',
  '7': 'july',
  '8': 'august',
  '9': 'september',
  '10': 'october',
  '11': 'november',
  '12': 'december',
};

//const kFrequencyOnce = '0';
const kFrequencyMonthly = '5';

const kStatementStatusAll = 'all';
const kStatementStatusPaid = 'paid';
const kStatementStatusUnpaid = 'unpaid';

const kFrequencies = {
  '1': 'freq_daily',
  '2': 'freq_weekly',
  '3': 'freq_two_weeks',
  '4': 'freq_four_weeks',
  '5': 'freq_monthly',
  '6': 'freq_two_months',
  '7': 'freq_three_months',
  '8': 'freq_four_months',
  '9': 'freq_six_months',
  '10': 'freq_annually',
  '11': 'freq_two_years',
  '12': 'freq_three_years',
};

const kPageLayouts = ['portrait', 'landscape'];

const kPageSizes = [
  'A5',
  'A4',
  'A3',
  'B5',
  'B4',
  'JIS-B5',
  'JIS-B4',
  'letter',
  'legal',
  'ledger',
];

const String kDrawerKey = 'drawer_key';
const String kSelectCompanyDropdownKey = 'select_company_dropdown_key';

// https://github.com/flutterboilerplate/flutterboilerplate/blob/v5-develop/app/Models/Activity.php
const String kActivityCreateTask = '42';
const String kActivityUpdateTask = '43';
const String kActivityArchiveTask = '44';
const String kActivityDeleteTask = '45';
const String kActivityRestoreTask = '46';
const String kActivityCreateUser = '48';
const String kActivityUpdateUser = '49';
const String kActivityArchiveUser = '50';
const String kActivityDeleteUser = '51';
const String kActivityRestoreUser = '52';
const String kActivityComment = '141';
