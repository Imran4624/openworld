// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<CompanyEntity> _$companyEntitySerializer =
    new _$CompanyEntitySerializer();
Serializer<UserCompanyEntity> _$userCompanyEntitySerializer =
    new _$UserCompanyEntitySerializer();
Serializer<UserSettingsEntity> _$userSettingsEntitySerializer =
    new _$UserSettingsEntitySerializer();
Serializer<CompanyItemResponse> _$companyItemResponseSerializer =
    new _$CompanyItemResponseSerializer();

class _$CompanyEntitySerializer implements StructuredSerializer<CompanyEntity> {
  @override
  final Iterable<Type> types = const [CompanyEntity, _$CompanyEntity];
  @override
  final String wireName = 'CompanyEntity';

  @override
  Iterable<Object?> serialize(Serializers serializers, CompanyEntity object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'size_id',
      serializers.serialize(object.sizeId,
          specifiedType: const FullType(String)),
      'industry_id',
      serializers.serialize(object.industryId,
          specifiedType: const FullType(String)),
      'is_large',
      serializers.serialize(object.isLarge,
          specifiedType: const FullType(bool)),
      'is_disabled',
      serializers.serialize(object.isDisabled,
          specifiedType: const FullType(bool)),
      'first_month_of_year',
      serializers.serialize(object.firstMonthOfYear,
          specifiedType: const FullType(String)),
      'session_timeout',
      serializers.serialize(object.sessionTimeout,
          specifiedType: const FullType(int)),
      'default_password_timeout',
      serializers.serialize(object.passwordTimeout,
          specifiedType: const FullType(int)),
      'oauth_password_required',
      serializers.serialize(object.oauthPasswordRequired,
          specifiedType: const FullType(bool)),
      'markdown_enabled',
      serializers.serialize(object.markdownEnabled,
          specifiedType: const FullType(bool)),
      'markdown_email_enabled',
      serializers.serialize(object.markdownEmailEnabled,
          specifiedType: const FullType(bool)),
      'use_comma_as_decimal_place',
      serializers.serialize(object.useCommaAsDecimalPlace,
          specifiedType: const FullType(bool)),
      'smtp_host',
      serializers.serialize(object.smtpHost,
          specifiedType: const FullType(String)),
      'smtp_port',
      serializers.serialize(object.smtpPort,
          specifiedType: const FullType(int)),
      'smtp_encryption',
      serializers.serialize(object.smtpEncryption,
          specifiedType: const FullType(String)),
      'smtp_username',
      serializers.serialize(object.smtpUsername,
          specifiedType: const FullType(String)),
      'smtp_password',
      serializers.serialize(object.smtpPassword,
          specifiedType: const FullType(String)),
      'smtp_local_domain',
      serializers.serialize(object.smtpLocalDomain,
          specifiedType: const FullType(String)),
      'smtp_verify_peer',
      serializers.serialize(object.smtpVerifyPeer,
          specifiedType: const FullType(bool)),
      'activities',
      serializers.serialize(object.activities,
          specifiedType: const FullType(
              BuiltList, const [const FullType(ActivityEntity)])),
      'users',
      serializers.serialize(object.users,
          specifiedType:
              const FullType(BuiltList, const [const FullType(UserEntity)])),
      'designs',
      serializers.serialize(object.designs,
          specifiedType:
              const FullType(BuiltList, const [const FullType(DesignEntity)])),
      'custom_fields',
      serializers.serialize(object.customFields,
          specifiedType: const FullType(BuiltMap,
              const [const FullType(String), const FullType(String)])),
      'settings',
      serializers.serialize(object.settings,
          specifiedType: const FullType(SettingsEntity)),
      'enabled_modules',
      serializers.serialize(object.enabledModules,
          specifiedType: const FullType(int)),
      'created_at',
      serializers.serialize(object.createdAt,
          specifiedType: const FullType(int)),
      'updated_at',
      serializers.serialize(object.updatedAt,
          specifiedType: const FullType(int)),
      'archived_at',
      serializers.serialize(object.archivedAt,
          specifiedType: const FullType(int)),
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
    ];
    Object? value;
    value = object.isChanged;
    if (value != null) {
      result
        ..add('isChanged')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.isDeleted;
    if (value != null) {
      result
        ..add('is_deleted')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.isReported;
    if (value != null) {
      result
        ..add('reported')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.createdUserId;
    if (value != null) {
      result
        ..add('user_id')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.assignedUserId;
    if (value != null) {
      result
        ..add('assigned_user_id')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.entityType;
    if (value != null) {
      result
        ..add('entity_type')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(EntityType)));
    }
    return result;
  }

  @override
  CompanyEntity deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new CompanyEntityBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'size_id':
          result.sizeId = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'industry_id':
          result.industryId = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'is_large':
          result.isLarge = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
        case 'is_disabled':
          result.isDisabled = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
        case 'first_month_of_year':
          result.firstMonthOfYear = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'session_timeout':
          result.sessionTimeout = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'default_password_timeout':
          result.passwordTimeout = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'oauth_password_required':
          result.oauthPasswordRequired = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
        case 'markdown_enabled':
          result.markdownEnabled = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
        case 'markdown_email_enabled':
          result.markdownEmailEnabled = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
        case 'use_comma_as_decimal_place':
          result.useCommaAsDecimalPlace = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
        case 'smtp_host':
          result.smtpHost = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'smtp_port':
          result.smtpPort = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'smtp_encryption':
          result.smtpEncryption = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'smtp_username':
          result.smtpUsername = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'smtp_password':
          result.smtpPassword = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'smtp_local_domain':
          result.smtpLocalDomain = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'smtp_verify_peer':
          result.smtpVerifyPeer = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
        case 'activities':
          result.activities.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(ActivityEntity)]))!
              as BuiltList<Object?>);
          break;
        case 'users':
          result.users.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(UserEntity)]))!
              as BuiltList<Object?>);
          break;
        case 'designs':
          result.designs.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(DesignEntity)]))!
              as BuiltList<Object?>);
          break;
        case 'custom_fields':
          result.customFields.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltMap,
                  const [const FullType(String), const FullType(String)]))!);
          break;
        case 'settings':
          result.settings.replace(serializers.deserialize(value,
                  specifiedType: const FullType(SettingsEntity))!
              as SettingsEntity);
          break;
        case 'enabled_modules':
          result.enabledModules = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'isChanged':
          result.isChanged = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'created_at':
          result.createdAt = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'updated_at':
          result.updatedAt = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'archived_at':
          result.archivedAt = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'is_deleted':
          result.isDeleted = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'reported':
          result.isReported = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'user_id':
          result.createdUserId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'assigned_user_id':
          result.assignedUserId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'entity_type':
          result.entityType = serializers.deserialize(value,
              specifiedType: const FullType(EntityType)) as EntityType?;
          break;
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$UserCompanyEntitySerializer
    implements StructuredSerializer<UserCompanyEntity> {
  @override
  final Iterable<Type> types = const [UserCompanyEntity, _$UserCompanyEntity];
  @override
  final String wireName = 'UserCompanyEntity';

  @override
  Iterable<Object?> serialize(Serializers serializers, UserCompanyEntity object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'is_admin',
      serializers.serialize(object.isAdmin,
          specifiedType: const FullType(bool)),
      'is_owner',
      serializers.serialize(object.isOwner,
          specifiedType: const FullType(bool)),
      'permissions_updated_at',
      serializers.serialize(object.permissionsUpdatedAt,
          specifiedType: const FullType(int)),
      'permissions',
      serializers.serialize(object.permissions,
          specifiedType: const FullType(String)),
      'notifications',
      serializers.serialize(object.notifications,
          specifiedType: const FullType(BuiltMap, const [
            const FullType(String),
            const FullType(BuiltList, const [const FullType(String)])
          ])),
      'company',
      serializers.serialize(object.company,
          specifiedType: const FullType(CompanyEntity)),
      'user',
      serializers.serialize(object.user,
          specifiedType: const FullType(UserEntity)),
      'account',
      serializers.serialize(object.account,
          specifiedType: const FullType(AccountEntity)),
      'settings',
      serializers.serialize(object.settings,
          specifiedType: const FullType(UserSettingsEntity)),
    ];

    return result;
  }

  @override
  UserCompanyEntity deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new UserCompanyEntityBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'is_admin':
          result.isAdmin = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
        case 'is_owner':
          result.isOwner = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
        case 'permissions_updated_at':
          result.permissionsUpdatedAt = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'permissions':
          result.permissions = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'notifications':
          result.notifications.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltMap, const [
                const FullType(String),
                const FullType(BuiltList, const [const FullType(String)])
              ]))!);
          break;
        case 'company':
          result.company.replace(serializers.deserialize(value,
              specifiedType: const FullType(CompanyEntity))! as CompanyEntity);
          break;
        case 'user':
          result.user.replace(serializers.deserialize(value,
              specifiedType: const FullType(UserEntity))! as UserEntity);
          break;
        case 'account':
          result.account.replace(serializers.deserialize(value,
              specifiedType: const FullType(AccountEntity))! as AccountEntity);
          break;
        case 'settings':
          result.settings.replace(serializers.deserialize(value,
                  specifiedType: const FullType(UserSettingsEntity))!
              as UserSettingsEntity);
          break;
      }
    }

    return result.build();
  }
}

class _$UserSettingsEntitySerializer
    implements StructuredSerializer<UserSettingsEntity> {
  @override
  final Iterable<Type> types = const [UserSettingsEntity, _$UserSettingsEntity];
  @override
  final String wireName = 'UserSettingsEntity';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, UserSettingsEntity object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'table_columns',
      serializers.serialize(object.tableColumns,
          specifiedType: const FullType(BuiltMap, const [
            const FullType(String),
            const FullType(BuiltList, const [const FullType(String)])
          ])),
    ];
    Object? value;
    value = object.accentColor;
    if (value != null) {
      result
        ..add('accent_color')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  UserSettingsEntity deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new UserSettingsEntityBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'accent_color':
          result.accentColor = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'table_columns':
          result.tableColumns.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltMap, const [
                const FullType(String),
                const FullType(BuiltList, const [const FullType(String)])
              ]))!);
          break;
      }
    }

    return result.build();
  }
}

class _$CompanyItemResponseSerializer
    implements StructuredSerializer<CompanyItemResponse> {
  @override
  final Iterable<Type> types = const [
    CompanyItemResponse,
    _$CompanyItemResponse
  ];
  @override
  final String wireName = 'CompanyItemResponse';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, CompanyItemResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'data',
      serializers.serialize(object.data,
          specifiedType: const FullType(CompanyEntity)),
    ];

    return result;
  }

  @override
  CompanyItemResponse deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new CompanyItemResponseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'data':
          result.data.replace(serializers.deserialize(value,
              specifiedType: const FullType(CompanyEntity))! as CompanyEntity);
          break;
      }
    }

    return result.build();
  }
}

class _$CompanyEntity extends CompanyEntity {
  @override
  final String sizeId;
  @override
  final String industryId;
  @override
  final bool isLarge;
  @override
  final bool isDisabled;
  @override
  final String firstMonthOfYear;
  @override
  final int sessionTimeout;
  @override
  final int passwordTimeout;
  @override
  final bool oauthPasswordRequired;
  @override
  final bool markdownEnabled;
  @override
  final bool markdownEmailEnabled;
  @override
  final bool useCommaAsDecimalPlace;
  @override
  final String smtpHost;
  @override
  final int smtpPort;
  @override
  final String smtpEncryption;
  @override
  final String smtpUsername;
  @override
  final String smtpPassword;
  @override
  final String smtpLocalDomain;
  @override
  final bool smtpVerifyPeer;
  @override
  final BuiltList<ActivityEntity> activities;
  @override
  final BuiltList<UserEntity> users;
  @override
  final BuiltList<DesignEntity> designs;
  @override
  final BuiltMap<String, String> customFields;
  @override
  final SettingsEntity settings;
  @override
  final int enabledModules;
  @override
  final bool? isChanged;
  @override
  final int createdAt;
  @override
  final int updatedAt;
  @override
  final int archivedAt;
  @override
  final bool? isDeleted;
  @override
  final bool? isReported;
  @override
  final String? createdUserId;
  @override
  final String? assignedUserId;
  @override
  final EntityType? entityType;
  @override
  final String id;

  factory _$CompanyEntity([void Function(CompanyEntityBuilder)? updates]) =>
      (new CompanyEntityBuilder()..update(updates))._build();

  _$CompanyEntity._(
      {required this.sizeId,
      required this.industryId,
      required this.isLarge,
      required this.isDisabled,
      required this.firstMonthOfYear,
      required this.sessionTimeout,
      required this.passwordTimeout,
      required this.oauthPasswordRequired,
      required this.markdownEnabled,
      required this.markdownEmailEnabled,
      required this.useCommaAsDecimalPlace,
      required this.smtpHost,
      required this.smtpPort,
      required this.smtpEncryption,
      required this.smtpUsername,
      required this.smtpPassword,
      required this.smtpLocalDomain,
      required this.smtpVerifyPeer,
      required this.activities,
      required this.users,
      required this.designs,
      required this.customFields,
      required this.settings,
      required this.enabledModules,
      this.isChanged,
      required this.createdAt,
      required this.updatedAt,
      required this.archivedAt,
      this.isDeleted,
      this.isReported,
      this.createdUserId,
      this.assignedUserId,
      this.entityType,
      required this.id})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(sizeId, r'CompanyEntity', 'sizeId');
    BuiltValueNullFieldError.checkNotNull(
        industryId, r'CompanyEntity', 'industryId');
    BuiltValueNullFieldError.checkNotNull(isLarge, r'CompanyEntity', 'isLarge');
    BuiltValueNullFieldError.checkNotNull(
        isDisabled, r'CompanyEntity', 'isDisabled');
    BuiltValueNullFieldError.checkNotNull(
        firstMonthOfYear, r'CompanyEntity', 'firstMonthOfYear');
    BuiltValueNullFieldError.checkNotNull(
        sessionTimeout, r'CompanyEntity', 'sessionTimeout');
    BuiltValueNullFieldError.checkNotNull(
        passwordTimeout, r'CompanyEntity', 'passwordTimeout');
    BuiltValueNullFieldError.checkNotNull(
        oauthPasswordRequired, r'CompanyEntity', 'oauthPasswordRequired');
    BuiltValueNullFieldError.checkNotNull(
        markdownEnabled, r'CompanyEntity', 'markdownEnabled');
    BuiltValueNullFieldError.checkNotNull(
        markdownEmailEnabled, r'CompanyEntity', 'markdownEmailEnabled');
    BuiltValueNullFieldError.checkNotNull(
        useCommaAsDecimalPlace, r'CompanyEntity', 'useCommaAsDecimalPlace');
    BuiltValueNullFieldError.checkNotNull(
        smtpHost, r'CompanyEntity', 'smtpHost');
    BuiltValueNullFieldError.checkNotNull(
        smtpPort, r'CompanyEntity', 'smtpPort');
    BuiltValueNullFieldError.checkNotNull(
        smtpEncryption, r'CompanyEntity', 'smtpEncryption');
    BuiltValueNullFieldError.checkNotNull(
        smtpUsername, r'CompanyEntity', 'smtpUsername');
    BuiltValueNullFieldError.checkNotNull(
        smtpPassword, r'CompanyEntity', 'smtpPassword');
    BuiltValueNullFieldError.checkNotNull(
        smtpLocalDomain, r'CompanyEntity', 'smtpLocalDomain');
    BuiltValueNullFieldError.checkNotNull(
        smtpVerifyPeer, r'CompanyEntity', 'smtpVerifyPeer');
    BuiltValueNullFieldError.checkNotNull(
        activities, r'CompanyEntity', 'activities');
    BuiltValueNullFieldError.checkNotNull(users, r'CompanyEntity', 'users');
    BuiltValueNullFieldError.checkNotNull(designs, r'CompanyEntity', 'designs');
    BuiltValueNullFieldError.checkNotNull(
        customFields, r'CompanyEntity', 'customFields');
    BuiltValueNullFieldError.checkNotNull(
        settings, r'CompanyEntity', 'settings');
    BuiltValueNullFieldError.checkNotNull(
        enabledModules, r'CompanyEntity', 'enabledModules');
    BuiltValueNullFieldError.checkNotNull(
        createdAt, r'CompanyEntity', 'createdAt');
    BuiltValueNullFieldError.checkNotNull(
        updatedAt, r'CompanyEntity', 'updatedAt');
    BuiltValueNullFieldError.checkNotNull(
        archivedAt, r'CompanyEntity', 'archivedAt');
    BuiltValueNullFieldError.checkNotNull(id, r'CompanyEntity', 'id');
  }

  @override
  CompanyEntity rebuild(void Function(CompanyEntityBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CompanyEntityBuilder toBuilder() => new CompanyEntityBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CompanyEntity &&
        sizeId == other.sizeId &&
        industryId == other.industryId &&
        isLarge == other.isLarge &&
        isDisabled == other.isDisabled &&
        firstMonthOfYear == other.firstMonthOfYear &&
        sessionTimeout == other.sessionTimeout &&
        passwordTimeout == other.passwordTimeout &&
        oauthPasswordRequired == other.oauthPasswordRequired &&
        markdownEnabled == other.markdownEnabled &&
        markdownEmailEnabled == other.markdownEmailEnabled &&
        useCommaAsDecimalPlace == other.useCommaAsDecimalPlace &&
        smtpHost == other.smtpHost &&
        smtpPort == other.smtpPort &&
        smtpEncryption == other.smtpEncryption &&
        smtpUsername == other.smtpUsername &&
        smtpPassword == other.smtpPassword &&
        smtpLocalDomain == other.smtpLocalDomain &&
        smtpVerifyPeer == other.smtpVerifyPeer &&
        activities == other.activities &&
        users == other.users &&
        designs == other.designs &&
        customFields == other.customFields &&
        settings == other.settings &&
        enabledModules == other.enabledModules &&
        isChanged == other.isChanged &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        archivedAt == other.archivedAt &&
        isDeleted == other.isDeleted &&
        isReported == other.isReported &&
        createdUserId == other.createdUserId &&
        assignedUserId == other.assignedUserId &&
        entityType == other.entityType &&
        id == other.id;
  }

  int? __hashCode;
  @override
  int get hashCode {
    if (__hashCode != null) return __hashCode!;
    var _$hash = 0;
    _$hash = $jc(_$hash, sizeId.hashCode);
    _$hash = $jc(_$hash, industryId.hashCode);
    _$hash = $jc(_$hash, isLarge.hashCode);
    _$hash = $jc(_$hash, isDisabled.hashCode);
    _$hash = $jc(_$hash, firstMonthOfYear.hashCode);
    _$hash = $jc(_$hash, sessionTimeout.hashCode);
    _$hash = $jc(_$hash, passwordTimeout.hashCode);
    _$hash = $jc(_$hash, oauthPasswordRequired.hashCode);
    _$hash = $jc(_$hash, markdownEnabled.hashCode);
    _$hash = $jc(_$hash, markdownEmailEnabled.hashCode);
    _$hash = $jc(_$hash, useCommaAsDecimalPlace.hashCode);
    _$hash = $jc(_$hash, smtpHost.hashCode);
    _$hash = $jc(_$hash, smtpPort.hashCode);
    _$hash = $jc(_$hash, smtpEncryption.hashCode);
    _$hash = $jc(_$hash, smtpUsername.hashCode);
    _$hash = $jc(_$hash, smtpPassword.hashCode);
    _$hash = $jc(_$hash, smtpLocalDomain.hashCode);
    _$hash = $jc(_$hash, smtpVerifyPeer.hashCode);
    _$hash = $jc(_$hash, activities.hashCode);
    _$hash = $jc(_$hash, users.hashCode);
    _$hash = $jc(_$hash, designs.hashCode);
    _$hash = $jc(_$hash, customFields.hashCode);
    _$hash = $jc(_$hash, settings.hashCode);
    _$hash = $jc(_$hash, enabledModules.hashCode);
    _$hash = $jc(_$hash, isChanged.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, archivedAt.hashCode);
    _$hash = $jc(_$hash, isDeleted.hashCode);
    _$hash = $jc(_$hash, isReported.hashCode);
    _$hash = $jc(_$hash, createdUserId.hashCode);
    _$hash = $jc(_$hash, assignedUserId.hashCode);
    _$hash = $jc(_$hash, entityType.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jf(_$hash);
    return __hashCode ??= _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CompanyEntity')
          ..add('sizeId', sizeId)
          ..add('industryId', industryId)
          ..add('isLarge', isLarge)
          ..add('isDisabled', isDisabled)
          ..add('firstMonthOfYear', firstMonthOfYear)
          ..add('sessionTimeout', sessionTimeout)
          ..add('passwordTimeout', passwordTimeout)
          ..add('oauthPasswordRequired', oauthPasswordRequired)
          ..add('markdownEnabled', markdownEnabled)
          ..add('markdownEmailEnabled', markdownEmailEnabled)
          ..add('useCommaAsDecimalPlace', useCommaAsDecimalPlace)
          ..add('smtpHost', smtpHost)
          ..add('smtpPort', smtpPort)
          ..add('smtpEncryption', smtpEncryption)
          ..add('smtpUsername', smtpUsername)
          ..add('smtpPassword', smtpPassword)
          ..add('smtpLocalDomain', smtpLocalDomain)
          ..add('smtpVerifyPeer', smtpVerifyPeer)
          ..add('activities', activities)
          ..add('users', users)
          ..add('designs', designs)
          ..add('customFields', customFields)
          ..add('settings', settings)
          ..add('enabledModules', enabledModules)
          ..add('isChanged', isChanged)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt)
          ..add('archivedAt', archivedAt)
          ..add('isDeleted', isDeleted)
          ..add('isReported', isReported)
          ..add('createdUserId', createdUserId)
          ..add('assignedUserId', assignedUserId)
          ..add('entityType', entityType)
          ..add('id', id))
        .toString();
  }
}

class CompanyEntityBuilder
    implements Builder<CompanyEntity, CompanyEntityBuilder> {
  _$CompanyEntity? _$v;

  String? _sizeId;
  String? get sizeId => _$this._sizeId;
  set sizeId(String? sizeId) => _$this._sizeId = sizeId;

  String? _industryId;
  String? get industryId => _$this._industryId;
  set industryId(String? industryId) => _$this._industryId = industryId;

  bool? _isLarge;
  bool? get isLarge => _$this._isLarge;
  set isLarge(bool? isLarge) => _$this._isLarge = isLarge;

  bool? _isDisabled;
  bool? get isDisabled => _$this._isDisabled;
  set isDisabled(bool? isDisabled) => _$this._isDisabled = isDisabled;

  String? _firstMonthOfYear;
  String? get firstMonthOfYear => _$this._firstMonthOfYear;
  set firstMonthOfYear(String? firstMonthOfYear) =>
      _$this._firstMonthOfYear = firstMonthOfYear;

  int? _sessionTimeout;
  int? get sessionTimeout => _$this._sessionTimeout;
  set sessionTimeout(int? sessionTimeout) =>
      _$this._sessionTimeout = sessionTimeout;

  int? _passwordTimeout;
  int? get passwordTimeout => _$this._passwordTimeout;
  set passwordTimeout(int? passwordTimeout) =>
      _$this._passwordTimeout = passwordTimeout;

  bool? _oauthPasswordRequired;
  bool? get oauthPasswordRequired => _$this._oauthPasswordRequired;
  set oauthPasswordRequired(bool? oauthPasswordRequired) =>
      _$this._oauthPasswordRequired = oauthPasswordRequired;

  bool? _markdownEnabled;
  bool? get markdownEnabled => _$this._markdownEnabled;
  set markdownEnabled(bool? markdownEnabled) =>
      _$this._markdownEnabled = markdownEnabled;

  bool? _markdownEmailEnabled;
  bool? get markdownEmailEnabled => _$this._markdownEmailEnabled;
  set markdownEmailEnabled(bool? markdownEmailEnabled) =>
      _$this._markdownEmailEnabled = markdownEmailEnabled;

  bool? _useCommaAsDecimalPlace;
  bool? get useCommaAsDecimalPlace => _$this._useCommaAsDecimalPlace;
  set useCommaAsDecimalPlace(bool? useCommaAsDecimalPlace) =>
      _$this._useCommaAsDecimalPlace = useCommaAsDecimalPlace;

  String? _smtpHost;
  String? get smtpHost => _$this._smtpHost;
  set smtpHost(String? smtpHost) => _$this._smtpHost = smtpHost;

  int? _smtpPort;
  int? get smtpPort => _$this._smtpPort;
  set smtpPort(int? smtpPort) => _$this._smtpPort = smtpPort;

  String? _smtpEncryption;
  String? get smtpEncryption => _$this._smtpEncryption;
  set smtpEncryption(String? smtpEncryption) =>
      _$this._smtpEncryption = smtpEncryption;

  String? _smtpUsername;
  String? get smtpUsername => _$this._smtpUsername;
  set smtpUsername(String? smtpUsername) => _$this._smtpUsername = smtpUsername;

  String? _smtpPassword;
  String? get smtpPassword => _$this._smtpPassword;
  set smtpPassword(String? smtpPassword) => _$this._smtpPassword = smtpPassword;

  String? _smtpLocalDomain;
  String? get smtpLocalDomain => _$this._smtpLocalDomain;
  set smtpLocalDomain(String? smtpLocalDomain) =>
      _$this._smtpLocalDomain = smtpLocalDomain;

  bool? _smtpVerifyPeer;
  bool? get smtpVerifyPeer => _$this._smtpVerifyPeer;
  set smtpVerifyPeer(bool? smtpVerifyPeer) =>
      _$this._smtpVerifyPeer = smtpVerifyPeer;

  ListBuilder<ActivityEntity>? _activities;
  ListBuilder<ActivityEntity> get activities =>
      _$this._activities ??= new ListBuilder<ActivityEntity>();
  set activities(ListBuilder<ActivityEntity>? activities) =>
      _$this._activities = activities;

  ListBuilder<UserEntity>? _users;
  ListBuilder<UserEntity> get users =>
      _$this._users ??= new ListBuilder<UserEntity>();
  set users(ListBuilder<UserEntity>? users) => _$this._users = users;

  ListBuilder<DesignEntity>? _designs;
  ListBuilder<DesignEntity> get designs =>
      _$this._designs ??= new ListBuilder<DesignEntity>();
  set designs(ListBuilder<DesignEntity>? designs) => _$this._designs = designs;

  MapBuilder<String, String>? _customFields;
  MapBuilder<String, String> get customFields =>
      _$this._customFields ??= new MapBuilder<String, String>();
  set customFields(MapBuilder<String, String>? customFields) =>
      _$this._customFields = customFields;

  SettingsEntityBuilder? _settings;
  SettingsEntityBuilder get settings =>
      _$this._settings ??= new SettingsEntityBuilder();
  set settings(SettingsEntityBuilder? settings) => _$this._settings = settings;

  int? _enabledModules;
  int? get enabledModules => _$this._enabledModules;
  set enabledModules(int? enabledModules) =>
      _$this._enabledModules = enabledModules;

  bool? _isChanged;
  bool? get isChanged => _$this._isChanged;
  set isChanged(bool? isChanged) => _$this._isChanged = isChanged;

  int? _createdAt;
  int? get createdAt => _$this._createdAt;
  set createdAt(int? createdAt) => _$this._createdAt = createdAt;

  int? _updatedAt;
  int? get updatedAt => _$this._updatedAt;
  set updatedAt(int? updatedAt) => _$this._updatedAt = updatedAt;

  int? _archivedAt;
  int? get archivedAt => _$this._archivedAt;
  set archivedAt(int? archivedAt) => _$this._archivedAt = archivedAt;

  bool? _isDeleted;
  bool? get isDeleted => _$this._isDeleted;
  set isDeleted(bool? isDeleted) => _$this._isDeleted = isDeleted;

  bool? _isReported;
  bool? get isReported => _$this._isReported;
  set isReported(bool? isReported) => _$this._isReported = isReported;

  String? _createdUserId;
  String? get createdUserId => _$this._createdUserId;
  set createdUserId(String? createdUserId) =>
      _$this._createdUserId = createdUserId;

  String? _assignedUserId;
  String? get assignedUserId => _$this._assignedUserId;
  set assignedUserId(String? assignedUserId) =>
      _$this._assignedUserId = assignedUserId;

  EntityType? _entityType;
  EntityType? get entityType => _$this._entityType;
  set entityType(EntityType? entityType) => _$this._entityType = entityType;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  CompanyEntityBuilder() {
    CompanyEntity._initializeBuilder(this);
  }

  CompanyEntityBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _sizeId = $v.sizeId;
      _industryId = $v.industryId;
      _isLarge = $v.isLarge;
      _isDisabled = $v.isDisabled;
      _firstMonthOfYear = $v.firstMonthOfYear;
      _sessionTimeout = $v.sessionTimeout;
      _passwordTimeout = $v.passwordTimeout;
      _oauthPasswordRequired = $v.oauthPasswordRequired;
      _markdownEnabled = $v.markdownEnabled;
      _markdownEmailEnabled = $v.markdownEmailEnabled;
      _useCommaAsDecimalPlace = $v.useCommaAsDecimalPlace;
      _smtpHost = $v.smtpHost;
      _smtpPort = $v.smtpPort;
      _smtpEncryption = $v.smtpEncryption;
      _smtpUsername = $v.smtpUsername;
      _smtpPassword = $v.smtpPassword;
      _smtpLocalDomain = $v.smtpLocalDomain;
      _smtpVerifyPeer = $v.smtpVerifyPeer;
      _activities = $v.activities.toBuilder();
      _users = $v.users.toBuilder();
      _designs = $v.designs.toBuilder();
      _customFields = $v.customFields.toBuilder();
      _settings = $v.settings.toBuilder();
      _enabledModules = $v.enabledModules;
      _isChanged = $v.isChanged;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _archivedAt = $v.archivedAt;
      _isDeleted = $v.isDeleted;
      _isReported = $v.isReported;
      _createdUserId = $v.createdUserId;
      _assignedUserId = $v.assignedUserId;
      _entityType = $v.entityType;
      _id = $v.id;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CompanyEntity other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$CompanyEntity;
  }

  @override
  void update(void Function(CompanyEntityBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CompanyEntity build() => _build();

  _$CompanyEntity _build() {
    _$CompanyEntity _$result;
    try {
      _$result = _$v ??
          new _$CompanyEntity._(
              sizeId: BuiltValueNullFieldError.checkNotNull(
                  sizeId, r'CompanyEntity', 'sizeId'),
              industryId: BuiltValueNullFieldError.checkNotNull(
                  industryId, r'CompanyEntity', 'industryId'),
              isLarge: BuiltValueNullFieldError.checkNotNull(
                  isLarge, r'CompanyEntity', 'isLarge'),
              isDisabled: BuiltValueNullFieldError.checkNotNull(
                  isDisabled, r'CompanyEntity', 'isDisabled'),
              firstMonthOfYear: BuiltValueNullFieldError.checkNotNull(
                  firstMonthOfYear, r'CompanyEntity', 'firstMonthOfYear'),
              sessionTimeout: BuiltValueNullFieldError.checkNotNull(
                  sessionTimeout, r'CompanyEntity', 'sessionTimeout'),
              passwordTimeout: BuiltValueNullFieldError.checkNotNull(
                  passwordTimeout, r'CompanyEntity', 'passwordTimeout'),
              oauthPasswordRequired: BuiltValueNullFieldError.checkNotNull(
                  oauthPasswordRequired, r'CompanyEntity', 'oauthPasswordRequired'),
              markdownEnabled: BuiltValueNullFieldError.checkNotNull(markdownEnabled, r'CompanyEntity', 'markdownEnabled'),
              markdownEmailEnabled: BuiltValueNullFieldError.checkNotNull(markdownEmailEnabled, r'CompanyEntity', 'markdownEmailEnabled'),
              useCommaAsDecimalPlace: BuiltValueNullFieldError.checkNotNull(useCommaAsDecimalPlace, r'CompanyEntity', 'useCommaAsDecimalPlace'),
              smtpHost: BuiltValueNullFieldError.checkNotNull(smtpHost, r'CompanyEntity', 'smtpHost'),
              smtpPort: BuiltValueNullFieldError.checkNotNull(smtpPort, r'CompanyEntity', 'smtpPort'),
              smtpEncryption: BuiltValueNullFieldError.checkNotNull(smtpEncryption, r'CompanyEntity', 'smtpEncryption'),
              smtpUsername: BuiltValueNullFieldError.checkNotNull(smtpUsername, r'CompanyEntity', 'smtpUsername'),
              smtpPassword: BuiltValueNullFieldError.checkNotNull(smtpPassword, r'CompanyEntity', 'smtpPassword'),
              smtpLocalDomain: BuiltValueNullFieldError.checkNotNull(smtpLocalDomain, r'CompanyEntity', 'smtpLocalDomain'),
              smtpVerifyPeer: BuiltValueNullFieldError.checkNotNull(smtpVerifyPeer, r'CompanyEntity', 'smtpVerifyPeer'),
              activities: activities.build(),
              users: users.build(),
              designs: designs.build(),
              customFields: customFields.build(),
              settings: settings.build(),
              enabledModules: BuiltValueNullFieldError.checkNotNull(enabledModules, r'CompanyEntity', 'enabledModules'),
              isChanged: isChanged,
              createdAt: BuiltValueNullFieldError.checkNotNull(createdAt, r'CompanyEntity', 'createdAt'),
              updatedAt: BuiltValueNullFieldError.checkNotNull(updatedAt, r'CompanyEntity', 'updatedAt'),
              archivedAt: BuiltValueNullFieldError.checkNotNull(archivedAt, r'CompanyEntity', 'archivedAt'),
              isDeleted: isDeleted,
              isReported: isReported,
              createdUserId: createdUserId,
              assignedUserId: assignedUserId,
              entityType: entityType,
              id: BuiltValueNullFieldError.checkNotNull(id, r'CompanyEntity', 'id'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'activities';
        activities.build();
        _$failedField = 'users';
        users.build();
        _$failedField = 'designs';
        designs.build();
        _$failedField = 'customFields';
        customFields.build();
        _$failedField = 'settings';
        settings.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'CompanyEntity', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$UserCompanyEntity extends UserCompanyEntity {
  @override
  final bool isAdmin;
  @override
  final bool isOwner;
  @override
  final int permissionsUpdatedAt;
  @override
  final String permissions;
  @override
  final BuiltMap<String, BuiltList<String>> notifications;
  @override
  final CompanyEntity company;
  @override
  final UserEntity user;
  @override
  final AccountEntity account;
  @override
  final UserSettingsEntity settings;

  factory _$UserCompanyEntity(
          [void Function(UserCompanyEntityBuilder)? updates]) =>
      (new UserCompanyEntityBuilder()..update(updates))._build();

  _$UserCompanyEntity._(
      {required this.isAdmin,
      required this.isOwner,
      required this.permissionsUpdatedAt,
      required this.permissions,
      required this.notifications,
      required this.company,
      required this.user,
      required this.account,
      required this.settings})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        isAdmin, r'UserCompanyEntity', 'isAdmin');
    BuiltValueNullFieldError.checkNotNull(
        isOwner, r'UserCompanyEntity', 'isOwner');
    BuiltValueNullFieldError.checkNotNull(
        permissionsUpdatedAt, r'UserCompanyEntity', 'permissionsUpdatedAt');
    BuiltValueNullFieldError.checkNotNull(
        permissions, r'UserCompanyEntity', 'permissions');
    BuiltValueNullFieldError.checkNotNull(
        notifications, r'UserCompanyEntity', 'notifications');
    BuiltValueNullFieldError.checkNotNull(
        company, r'UserCompanyEntity', 'company');
    BuiltValueNullFieldError.checkNotNull(user, r'UserCompanyEntity', 'user');
    BuiltValueNullFieldError.checkNotNull(
        account, r'UserCompanyEntity', 'account');
    BuiltValueNullFieldError.checkNotNull(
        settings, r'UserCompanyEntity', 'settings');
  }

  @override
  UserCompanyEntity rebuild(void Function(UserCompanyEntityBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserCompanyEntityBuilder toBuilder() =>
      new UserCompanyEntityBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserCompanyEntity &&
        isAdmin == other.isAdmin &&
        isOwner == other.isOwner &&
        permissionsUpdatedAt == other.permissionsUpdatedAt &&
        permissions == other.permissions &&
        notifications == other.notifications &&
        company == other.company &&
        user == other.user &&
        account == other.account &&
        settings == other.settings;
  }

  int? __hashCode;
  @override
  int get hashCode {
    if (__hashCode != null) return __hashCode!;
    var _$hash = 0;
    _$hash = $jc(_$hash, isAdmin.hashCode);
    _$hash = $jc(_$hash, isOwner.hashCode);
    _$hash = $jc(_$hash, permissionsUpdatedAt.hashCode);
    _$hash = $jc(_$hash, permissions.hashCode);
    _$hash = $jc(_$hash, notifications.hashCode);
    _$hash = $jc(_$hash, company.hashCode);
    _$hash = $jc(_$hash, user.hashCode);
    _$hash = $jc(_$hash, account.hashCode);
    _$hash = $jc(_$hash, settings.hashCode);
    _$hash = $jf(_$hash);
    return __hashCode ??= _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UserCompanyEntity')
          ..add('isAdmin', isAdmin)
          ..add('isOwner', isOwner)
          ..add('permissionsUpdatedAt', permissionsUpdatedAt)
          ..add('permissions', permissions)
          ..add('notifications', notifications)
          ..add('company', company)
          ..add('user', user)
          ..add('account', account)
          ..add('settings', settings))
        .toString();
  }
}

class UserCompanyEntityBuilder
    implements Builder<UserCompanyEntity, UserCompanyEntityBuilder> {
  _$UserCompanyEntity? _$v;

  bool? _isAdmin;
  bool? get isAdmin => _$this._isAdmin;
  set isAdmin(bool? isAdmin) => _$this._isAdmin = isAdmin;

  bool? _isOwner;
  bool? get isOwner => _$this._isOwner;
  set isOwner(bool? isOwner) => _$this._isOwner = isOwner;

  int? _permissionsUpdatedAt;
  int? get permissionsUpdatedAt => _$this._permissionsUpdatedAt;
  set permissionsUpdatedAt(int? permissionsUpdatedAt) =>
      _$this._permissionsUpdatedAt = permissionsUpdatedAt;

  String? _permissions;
  String? get permissions => _$this._permissions;
  set permissions(String? permissions) => _$this._permissions = permissions;

  MapBuilder<String, BuiltList<String>>? _notifications;
  MapBuilder<String, BuiltList<String>> get notifications =>
      _$this._notifications ??= new MapBuilder<String, BuiltList<String>>();
  set notifications(MapBuilder<String, BuiltList<String>>? notifications) =>
      _$this._notifications = notifications;

  CompanyEntityBuilder? _company;
  CompanyEntityBuilder get company =>
      _$this._company ??= new CompanyEntityBuilder();
  set company(CompanyEntityBuilder? company) => _$this._company = company;

  UserEntityBuilder? _user;
  UserEntityBuilder get user => _$this._user ??= new UserEntityBuilder();
  set user(UserEntityBuilder? user) => _$this._user = user;

  AccountEntityBuilder? _account;
  AccountEntityBuilder get account =>
      _$this._account ??= new AccountEntityBuilder();
  set account(AccountEntityBuilder? account) => _$this._account = account;

  UserSettingsEntityBuilder? _settings;
  UserSettingsEntityBuilder get settings =>
      _$this._settings ??= new UserSettingsEntityBuilder();
  set settings(UserSettingsEntityBuilder? settings) =>
      _$this._settings = settings;

  UserCompanyEntityBuilder() {
    UserCompanyEntity._initializeBuilder(this);
  }

  UserCompanyEntityBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _isAdmin = $v.isAdmin;
      _isOwner = $v.isOwner;
      _permissionsUpdatedAt = $v.permissionsUpdatedAt;
      _permissions = $v.permissions;
      _notifications = $v.notifications.toBuilder();
      _company = $v.company.toBuilder();
      _user = $v.user.toBuilder();
      _account = $v.account.toBuilder();
      _settings = $v.settings.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserCompanyEntity other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$UserCompanyEntity;
  }

  @override
  void update(void Function(UserCompanyEntityBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserCompanyEntity build() => _build();

  _$UserCompanyEntity _build() {
    _$UserCompanyEntity _$result;
    try {
      _$result = _$v ??
          new _$UserCompanyEntity._(
              isAdmin: BuiltValueNullFieldError.checkNotNull(
                  isAdmin, r'UserCompanyEntity', 'isAdmin'),
              isOwner: BuiltValueNullFieldError.checkNotNull(
                  isOwner, r'UserCompanyEntity', 'isOwner'),
              permissionsUpdatedAt: BuiltValueNullFieldError.checkNotNull(
                  permissionsUpdatedAt,
                  r'UserCompanyEntity',
                  'permissionsUpdatedAt'),
              permissions: BuiltValueNullFieldError.checkNotNull(
                  permissions, r'UserCompanyEntity', 'permissions'),
              notifications: notifications.build(),
              company: company.build(),
              user: user.build(),
              account: account.build(),
              settings: settings.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'notifications';
        notifications.build();
        _$failedField = 'company';
        company.build();
        _$failedField = 'user';
        user.build();
        _$failedField = 'account';
        account.build();
        _$failedField = 'settings';
        settings.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'UserCompanyEntity', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$UserSettingsEntity extends UserSettingsEntity {
  @override
  final String? accentColor;
  @override
  final BuiltMap<String, BuiltList<String>> tableColumns;

  factory _$UserSettingsEntity(
          [void Function(UserSettingsEntityBuilder)? updates]) =>
      (new UserSettingsEntityBuilder()..update(updates))._build();

  _$UserSettingsEntity._({this.accentColor, required this.tableColumns})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        tableColumns, r'UserSettingsEntity', 'tableColumns');
  }

  @override
  UserSettingsEntity rebuild(
          void Function(UserSettingsEntityBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserSettingsEntityBuilder toBuilder() =>
      new UserSettingsEntityBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserSettingsEntity &&
        accentColor == other.accentColor &&
        tableColumns == other.tableColumns;
  }

  int? __hashCode;
  @override
  int get hashCode {
    if (__hashCode != null) return __hashCode!;
    var _$hash = 0;
    _$hash = $jc(_$hash, accentColor.hashCode);
    _$hash = $jc(_$hash, tableColumns.hashCode);
    _$hash = $jf(_$hash);
    return __hashCode ??= _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UserSettingsEntity')
          ..add('accentColor', accentColor)
          ..add('tableColumns', tableColumns))
        .toString();
  }
}

class UserSettingsEntityBuilder
    implements Builder<UserSettingsEntity, UserSettingsEntityBuilder> {
  _$UserSettingsEntity? _$v;

  String? _accentColor;
  String? get accentColor => _$this._accentColor;
  set accentColor(String? accentColor) => _$this._accentColor = accentColor;

  MapBuilder<String, BuiltList<String>>? _tableColumns;
  MapBuilder<String, BuiltList<String>> get tableColumns =>
      _$this._tableColumns ??= new MapBuilder<String, BuiltList<String>>();
  set tableColumns(MapBuilder<String, BuiltList<String>>? tableColumns) =>
      _$this._tableColumns = tableColumns;

  UserSettingsEntityBuilder() {
    UserSettingsEntity._initializeBuilder(this);
  }

  UserSettingsEntityBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _accentColor = $v.accentColor;
      _tableColumns = $v.tableColumns.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserSettingsEntity other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$UserSettingsEntity;
  }

  @override
  void update(void Function(UserSettingsEntityBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserSettingsEntity build() => _build();

  _$UserSettingsEntity _build() {
    _$UserSettingsEntity _$result;
    try {
      _$result = _$v ??
          new _$UserSettingsEntity._(
              accentColor: accentColor, tableColumns: tableColumns.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'tableColumns';
        tableColumns.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'UserSettingsEntity', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$CompanyItemResponse extends CompanyItemResponse {
  @override
  final CompanyEntity data;

  factory _$CompanyItemResponse(
          [void Function(CompanyItemResponseBuilder)? updates]) =>
      (new CompanyItemResponseBuilder()..update(updates))._build();

  _$CompanyItemResponse._({required this.data}) : super._() {
    BuiltValueNullFieldError.checkNotNull(data, r'CompanyItemResponse', 'data');
  }

  @override
  CompanyItemResponse rebuild(
          void Function(CompanyItemResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CompanyItemResponseBuilder toBuilder() =>
      new CompanyItemResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CompanyItemResponse && data == other.data;
  }

  int? __hashCode;
  @override
  int get hashCode {
    if (__hashCode != null) return __hashCode!;
    var _$hash = 0;
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jf(_$hash);
    return __hashCode ??= _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CompanyItemResponse')
          ..add('data', data))
        .toString();
  }
}

class CompanyItemResponseBuilder
    implements Builder<CompanyItemResponse, CompanyItemResponseBuilder> {
  _$CompanyItemResponse? _$v;

  CompanyEntityBuilder? _data;
  CompanyEntityBuilder get data => _$this._data ??= new CompanyEntityBuilder();
  set data(CompanyEntityBuilder? data) => _$this._data = data;

  CompanyItemResponseBuilder();

  CompanyItemResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CompanyItemResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$CompanyItemResponse;
  }

  @override
  void update(void Function(CompanyItemResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CompanyItemResponse build() => _build();

  _$CompanyItemResponse _build() {
    _$CompanyItemResponse _$result;
    try {
      _$result = _$v ?? new _$CompanyItemResponse._(data: data.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'CompanyItemResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
