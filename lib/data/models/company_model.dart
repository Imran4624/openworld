// Package imports:
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

// Project imports:
import 'package:flutter_boilerplate/.env.dart';
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/data/models/account_model.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/main_app.dart';
import 'package:flutter_boilerplate/project_config.dart';
import 'package:flutter_boilerplate/utils/formatting.dart';
import 'package:flutter_boilerplate/utils/localization.dart';
import 'package:flutter_boilerplate/utils/strings.dart';

part 'company_model.g.dart';

class CompanyFields {
  static const String name = 'name';
  static const String email = 'email';
  static const String address1 = 'address1';
  static const String address2 = 'address2';
  static const String city = 'city';
  static const String postalCode = 'postal_code';
  static const String country = 'country';
  static const String vatNumber = 'vat_number';
  static const String idNumber = 'id_number';
  static const String state = 'state';
  static const String phone = 'phone';
  static const String website = 'website';
  static const String custom1 = 'custom1';
  static const String custom2 = 'custom2';
  static const String custom3 = 'custom3';
  static const String custom4 = 'custom4';
  static const String cityStatePostal = 'city_state_postal';
  static const String postalCityState = 'postal_city_state';
  static const String postalCity = 'postal_city';
}

abstract class CompanyEntity extends Object
    with BaseEntity
    implements Built<CompanyEntity, CompanyEntityBuilder> {
  factory CompanyEntity() {
    return _$CompanyEntity._(
      entityType: EntityType.company,
      id: '',
      updatedAt: 0,
      archivedAt: 0,
      assignedUserId: '',
      createdAt: 0,
      createdUserId: '',
      isChanged: false,
      isDeleted: false,
      settings: SettingsEntity(),
      sizeId: '',
      industryId: '',
      enabledModules: 0,
      firstMonthOfYear: '0',
      isLarge: false,
      isDisabled: false,
      sessionTimeout: 0,
      passwordTimeout: 30 * 60 * 1000,
      oauthPasswordRequired: false,
      markdownEnabled: true,
      markdownEmailEnabled: true,
      useCommaAsDecimalPlace: false,
      smtpHost: '',
      smtpPort: 587,
      smtpEncryption: SMTP_ENCRYPTION_TLS,
      smtpUsername: '',
      smtpPassword: '',
      smtpLocalDomain: '',
      smtpVerifyPeer: true,
      users: BuiltList<UserEntity>(),
      customFields: BuiltMap<String, String>(),
      activities: BuiltList<ActivityEntity>(),
      designs: BuiltList<DesignEntity>(),
    );
  }

  CompanyEntity._();

  static const USE_ALWAYS = 'always';
  static const USE_OPTION = 'option';
  static const USE_OFF = 'off';

  static const SMTP_ENCRYPTION_TLS = 'TLS';
  static const SMTP_ENCRYPTION_STARTTLS = 'STARTTLS';

  @override
  @memoized
  int get hashCode;

  @BuiltValueField(wireName: 'size_id')
  String get sizeId;

  @BuiltValueField(wireName: 'industry_id')
  String get industryId;
  @BuiltValueField(wireName: 'is_large')
  bool get isLarge;
  @BuiltValueField(wireName: 'is_disabled')
  bool get isDisabled;
  @BuiltValueField(wireName: 'first_month_of_year')
  String get firstMonthOfYear;
  @BuiltValueField(wireName: 'session_timeout')
  int get sessionTimeout;

  @BuiltValueField(wireName: 'default_password_timeout')
  int get passwordTimeout;

  @BuiltValueField(wireName: 'oauth_password_required')
  bool get oauthPasswordRequired;
  @BuiltValueField(wireName: 'markdown_enabled')
  bool get markdownEnabled;

  @BuiltValueField(wireName: 'markdown_email_enabled')
  bool get markdownEmailEnabled;

  @BuiltValueField(wireName: 'use_comma_as_decimal_place')
  bool get useCommaAsDecimalPlace;
  @BuiltValueField(wireName: 'smtp_host')
  String get smtpHost;

  @BuiltValueField(wireName: 'smtp_port')
  int get smtpPort;

  @BuiltValueField(wireName: 'smtp_encryption')
  String get smtpEncryption;

  @BuiltValueField(wireName: 'smtp_username')
  String get smtpUsername;

  @BuiltValueField(wireName: 'smtp_password')
  String get smtpPassword;

  @BuiltValueField(wireName: 'smtp_local_domain')
  String get smtpLocalDomain;

  @BuiltValueField(wireName: 'smtp_verify_peer')
  bool get smtpVerifyPeer;

  BuiltList<ActivityEntity> get activities;

  BuiltList<UserEntity> get users;

  BuiltList<DesignEntity> get designs;

  @BuiltValueField(wireName: 'custom_fields')
  BuiltMap<String, String> get customFields;

  SettingsEntity get settings;
  @BuiltValueField(wireName: 'enabled_modules')
  int get enabledModules;
  String get displayName => settings.name ?? '';

  @override
  bool get isActive => true;

  @override
  bool matchesFilter(String? filter) {
    for (final user in users) {
      if (user.matchesFilter(filter)) {
        return true;
      }
    }
    return matchesStrings(
      haystacks: [],
      needle: filter,
    );
  }

  @override
  String? matchesFilterValue(String? filter) {
    for (final user in users) {
      final value = user.matchesFilterValue(filter);
      if (value != null) {
        return value;
      }
    }

    return matchesStringsValue(
      haystacks: [],
      needle: filter,
    );
  }

  @override
  double? get listDisplayAmount => null;

  @override
  FormatNumberType? get listDisplayAmountType => null;

  @override
  String get listDisplayName => settings.name ?? '';

  bool hasCustomField(String field) => getCustomFieldLabel(field).isNotEmpty;

  bool get hasName => (settings.name ?? '').isNotEmpty;

  bool get hasCustomSurcharge => false;

  bool hasCustomProductField(String label) {
    return false;
  }

  String getCustomFieldLabel(String field) {
    field = field.replaceFirst('\$', '');
    if (customFields.containsKey(field)) {
      return customFields[field]!.split('|').first;
    } else {
      return '';
    }
  }

  String getCustomFieldType(String? field) {
    if ((customFields[field] ?? '').contains('|')) {
      final value = customFields[field]!.split('|').last;
      if ([kFieldTypeSingleLineText, kFieldTypeDate, kFieldTypeSwitch]
          .contains(value)) {
        return value;
      } else {
        return kFieldTypeDropdown;
      }
    } else {
      return kFieldTypeMultiLineText;
    }
  }

  String formatCustomFieldValue(String field, String value) {
    final context = navigatorKey.currentContext!;
    final type = getCustomFieldType(field);
    final localization = AppLocalization.of(context);

    if (type == kFieldTypeDate) {
      value = formatDate(value, context);
    } else if (type == kFieldTypeSwitch) {
      value = value == kSwitchValueYes ? localization!.yes : localization!.no;
    }

    return getCustomFieldLabel(field) + ': $value';
  }

  List<String> getCustomFieldValues(String field, {bool excludeBlank = false}) {
    final values = customFields[field];

    if (values == null || !values.contains('|')) {
      return [];
    } else {
      final parts = values.split('|');
      final data = parts.last.split(',');

      if (parts.length == 2) {
        if ([kFieldTypeDate, kFieldTypeSwitch, kFieldTypeSingleLineText]
            .contains(parts[1])) {
          return [];
        }
      }

      if (excludeBlank) {
        return data.where((data) => data.isNotEmpty).toList();
      } else {
        return data;
      }
    }
  }

  // TODO make sure to clear everything
  CompanyEntity get coreCompany => rebuild((b) => b); //it was clearning designs

  bool isModuleEnabled(EntityType? entityType) {
    // if (entityType == EntityType.document &&
    //     enabledModules & kModuleDocuments == 0) {
    //   return false;
    // }

    return true;
  }

  int get daysActive =>
      DateTime.now().difference(convertTimestampToDate(createdAt)).inDays;

  String get currencyId => settings.currencyId ?? kDefaultCurrencyId;

  String get languageId => settings.languageId ?? kDefaultLanguageId;

  bool get supportsQrIban => settings.countryId == kCountrySwitzerland;

  // ignore: unused_element
  static void _initializeBuilder(CompanyEntityBuilder builder) => builder
    ..entityType = EntityType.company
    ..sessionTimeout = 0
    ..passwordTimeout = 30 * 60 * 1000
    ..oauthPasswordRequired = false
    ..markdownEnabled = true
    ..markdownEmailEnabled = true
    ..useCommaAsDecimalPlace = false
    ..sizeId = ''
    ..industryId = ''
    ..isLarge = false
    ..isDisabled = false
    ..firstMonthOfYear = ''
    ..enabledModules = 0
    ..createdAt = 0
    ..updatedAt = 0
    ..archivedAt = 0
    ..id = ''
    ..smtpHost = ''
    ..smtpPort = 587
    ..smtpEncryption = SMTP_ENCRYPTION_TLS
    ..smtpUsername = ''
    ..smtpPassword = ''
    ..smtpLocalDomain = ''
    ..smtpVerifyPeer = true;

  static Serializer<CompanyEntity> get serializer => _$companyEntitySerializer;
}

abstract class UserCompanyEntity
    implements Built<UserCompanyEntity, UserCompanyEntityBuilder> {
  factory UserCompanyEntity(bool reportErrors) {
    return _$UserCompanyEntity._(
      isAdmin: false,
      isOwner: false,
      permissions: '',
      permissionsUpdatedAt: 0,
      settings: UserSettingsEntity(),
      company: CompanyEntity(),
      user: UserEntity(),
      account: AccountEntity(reportErrors),
      notifications: BuiltMap<String, BuiltList<String>>().rebuild((b) => b
        ..[kNotificationChannelEmail] =
            BuiltList<String>(<String>[kNotificationsAll])),
    );
  }

  UserCompanyEntity._();

  @override
  @memoized
  int get hashCode;

  @BuiltValueField(wireName: 'is_admin')
  bool get isAdmin;

  @BuiltValueField(wireName: 'is_owner')
  bool get isOwner;

  @BuiltValueField(wireName: 'permissions_updated_at')
  int get permissionsUpdatedAt;

  String get permissions;

  BuiltMap<String, BuiltList<String>> get notifications;

  CompanyEntity get company;

  UserEntity get user;

  AccountEntity get account;

  UserSettingsEntity get settings;

  bool can(UserPermission permission, EntityType? entityType) {
    final allPermissions = permissions.isNotEmpty
        ? permissions
        : ProjectConfig.mockLoginPermission;
    if (entityType == null) {
      return false;
    }

    // if (!company.isModuleEnabled(entityType)) {
    //   return false;
    // }

    if (Config.DEMO_MODE) {
      return true;
    }

    // if (isAdmin) {
    //   return true;
    // }

    return allPermissions.contains('${permission}_all') ||
        allPermissions.contains('${permission}_${entityType.snakeCase}');
  }

  bool receivesAllNotifications(String channel) =>
      notifications.containsKey(channel) &&
      notifications[channel]!.contains(kNotificationsAll);

  bool canView(EntityType? entityType) => can(UserPermission.view, entityType);

  bool canGuestViewEntity(EntityType? entityType) {
    return ProjectConfig.mockLoginPermission
        .contains('${UserPermission.view}_${entityType!.snakeCase}');
  }

  bool canEdit(EntityType? entityType) => can(UserPermission.edit, entityType);

  bool canCreate(EntityType? entityType) =>
      can(UserPermission.create, entityType);

  bool canViewCreateOrEdit(EntityType? entityType) =>
      canView(entityType) || canCreate(entityType) || canEdit(entityType);

  bool canEditEntity(BaseEntity? entity) {
    if (entity == null) {
      return false;
    }

    if (entity.isNew) {
      return canCreate(entity.entityType);
    } else {
      return canEdit(entity.entityType) || user.canEdit(entity);
    }
  }

  bool get canViewDashboard {
    // if (isAdmin) {
    //   return true;
    // }

    return permissions.contains(kPermissionViewDashboard);
  }

  // ignore: unused_element
  static void _initializeBuilder(UserCompanyEntityBuilder builder) => builder
    ..user.replace(UserEntity())
    ..account.replace(AccountEntity(false))
    ..settings.replace(UserSettingsEntity())
    ..notifications.replace(BuiltMap<String, BuiltList<String>>().rebuild((b) =>
        b
          ..[kNotificationChannelEmail] =
              BuiltList<String>(<String>[kNotificationsAll])))
    ..permissionsUpdatedAt = 0;

  static Serializer<UserCompanyEntity> get serializer =>
      _$userCompanyEntitySerializer;
}

abstract class UserSettingsEntity
    implements Built<UserSettingsEntity, UserSettingsEntityBuilder> {
  factory UserSettingsEntity() {
    return _$UserSettingsEntity._(
      accentColor: kDefaultAccentColor,
      tableColumns: BuiltMap<String, BuiltList<String>>(),
    );
  }

  UserSettingsEntity._();

  @override
  @memoized
  int get hashCode;

  @BuiltValueField(wireName: 'accent_color')
  String? get accentColor;
  @BuiltValueField(wireName: 'table_columns')
  BuiltMap<String, BuiltList<String>> get tableColumns;
  List<String>? getTableColumns(EntityType entityType) {
    if (tableColumns.containsKey('$entityType')) {
      return tableColumns['$entityType']!.toList();
    } else {
      return null;
    }
  }

  String? get validatedAccentColor {
    if ((accentColor ?? '').isEmpty) {
      return kDefaultAccentColor;
    }

    if (accentColor!.toLowerCase() == '#ffffff') {
      return kDefaultAccentColor;
    }

    return accentColor;
  }

  // ignore: unused_element
  static void _initializeBuilder(UserSettingsEntityBuilder builder) => builder
    ..accentColor = kDefaultAccentColor
    ..tableColumns.replace(BuiltMap<String, BuiltList<String>>());

  static Serializer<UserSettingsEntity> get serializer =>
      _$userSettingsEntitySerializer;
}

abstract class CompanyItemResponse
    implements Built<CompanyItemResponse, CompanyItemResponseBuilder> {
  factory CompanyItemResponse([void updates(CompanyItemResponseBuilder b)]) =
      _$CompanyItemResponse;

  CompanyItemResponse._();

  @override
  @memoized
  int get hashCode;

  CompanyEntity get data;

  static Serializer<CompanyItemResponse> get serializer =>
      _$companyItemResponseSerializer;
}
