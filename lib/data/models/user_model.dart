// Package imports:
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';

// Project imports:
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/utils/formatting.dart';
import 'package:flutter_boilerplate/utils/strings.dart';

part 'user_model.g.dart';

abstract class UserFilter implements Built<UserFilter, UserFilterBuilder> {
  factory UserFilter() {
    return _$UserFilter._(
      searchTerm: '',
      stateFilter: EntityState.active,
      sortField: UserFields.firstName,
      sortAscending: true,
      limit: 10,
      dynamicFieldsFilters: BuiltMap<String, dynamic>(),
    );
  }

  UserFilter._();

  @override
  @memoized
  int get hashCode;

  String get searchTerm;
  EntityState get stateFilter;
  String get sortField;
  bool get sortAscending;
  int get limit;
  BuiltMap<String, dynamic> get dynamicFieldsFilters;

  Map<String, dynamic> toFirebaseQuery() {
    final Map<String, dynamic> filters = {};

    // Handle search term
    if (searchTerm.isNotEmpty) {
      filters['searchIndex'] = searchTerm.toLowerCase();
    }

    // Handle state filter
    switch (stateFilter) {
      case EntityState.active:
        filters['archived_at'] = 0;
        filters['is_deleted'] = false;
        break;
      case EntityState.archived:
        filters['archived_at_gt'] = 0;
        filters['is_deleted'] = false;
        break;
      case EntityState.deleted:
        filters['is_deleted'] = true;
        break;
    }

    if (dynamicFieldsFilters.isNotEmpty) {
      final Map<String, dynamic> dynamicFields = {};

      dynamicFieldsFilters.forEach((key, value) {
        if (value is Map<String, dynamic>) {
          dynamicFields[key] = value;
        } else if (value is List) {
          dynamicFields[key] = {'in': value};
        } else {
          dynamicFields[key] = value;
        }
      });

      filters['dynamic_fields'] = dynamicFields;
    }

    return {
      'filters': filters,
      'sort_field': sortField,
      'sort_ascending': sortAscending,
      'limit': limit
    };
  }

  static Serializer<UserFilter> get serializer => _$userFilterSerializer;
}

abstract class UserListResponse
    implements Built<UserListResponse, UserListResponseBuilder> {
  factory UserListResponse([void updates(UserListResponseBuilder b)]) =
      _$UserListResponse;

  UserListResponse._();

  @override
  @memoized
  int get hashCode;

  BuiltList<UserEntity> get data;

  static Serializer<UserListResponse> get serializer =>
      _$userListResponseSerializer;
}

abstract class UserItemResponse
    implements Built<UserItemResponse, UserItemResponseBuilder> {
  factory UserItemResponse([void updates(UserItemResponseBuilder b)]) =
      _$UserItemResponse;

  UserItemResponse._();

  @override
  @memoized
  int get hashCode;

  UserEntity get data;

  static Serializer<UserItemResponse> get serializer =>
      _$userItemResponseSerializer;
}

abstract class UserTwoFactorResponse
    implements Built<UserTwoFactorResponse, UserTwoFactorResponseBuilder> {
  factory UserTwoFactorResponse(
      [void updates(UserTwoFactorResponseBuilder b)]) = _$UserTwoFactorResponse;

  UserTwoFactorResponse._();

  @override
  @memoized
  int get hashCode;

  UserTwoFactorData get data;

  static Serializer<UserTwoFactorResponse> get serializer =>
      _$userTwoFactorResponseSerializer;
}

abstract class UserTwoFactorData
    implements Built<UserTwoFactorData, UserTwoFactorDataBuilder> {
  factory UserTwoFactorData([void updates(UserTwoFactorDataBuilder b)]) =
      _$UserTwoFactorData;

  UserTwoFactorData._();

  @override
  @memoized
  int get hashCode;

  String get secret;

  String get qrCode;

  static Serializer<UserTwoFactorData> get serializer =>
      _$userTwoFactorDataSerializer;
}

abstract class UserCompanyItemResponse
    implements Built<UserCompanyItemResponse, UserCompanyItemResponseBuilder> {
  factory UserCompanyItemResponse(
          [void updates(UserCompanyItemResponseBuilder b)]) =
      _$UserCompanyItemResponse;

  UserCompanyItemResponse._();

  @override
  @memoized
  int get hashCode;

  UserCompanyEntity get data;

  static Serializer<UserCompanyItemResponse> get serializer =>
      _$userCompanyItemResponseSerializer;
}

class UserFields {
  static const String firstName = 'first_name';
  static const String lastName = 'last_name';
  static const String email = 'email';
  static const String phone = 'phone';
  static const String updatedAt = 'updated_at';
  static const String custom1 = 'custom1';
  static const String custom2 = 'custom2';
  static const String custom3 = 'custom3';
  static const String custom4 = 'custom4';
}

abstract class UserEntity extends Object
    with BaseEntity, SelectableEntity
    implements Built<UserEntity, UserEntityBuilder> {
  factory UserEntity(
      {String? id, AppState? state, UserCompanyEntity? userCompany}) {
    return _$UserEntity._(
      id: id ?? BaseEntity.nextId,
      isChanged: false,
      createdUserId: '',
      createdAt: 0,
      assignedUserId: '',
      firstName: '',
      lastName: '',
      email: '',
      phone: '',
      updatedAt: 0,
      archivedAt: 0,
      isDeleted: false,
      customValue1: '',
      customValue2: '',
      customValue3: '',
      customValue4: '',
      oauthProvider: '',
      isTwoFactorEnabled: false,
      hasPassword: false,
      lastEmailAddress: '',
      oauthUserToken: '',
      password: '',
      phoneVerified: false,
      languageId: '',
      userCompany: userCompany,
      userLoggedInNotification: true,
      referralCode: '',
      referralMeta: BuiltMap<String, int>(),
    );
  }

  UserEntity._();

  static const OAUTH_PROVIDER_GOOGLE = 'google';
  static const OAUTH_PROVIDER_MICROSOFT = 'microsoft';
  static const OAUTH_PROVIDER_APPLE = 'apple';

  @override
  @memoized
  int get hashCode;

  @override
  EntityType get entityType {
    return EntityType.user;
  }

  @BuiltValueField(wireName: 'first_name')
  String get firstName;

  @BuiltValueField(wireName: 'last_name')
  String get lastName;

  String get email;

  String get phone;

  String get password;

  @BuiltValueField(wireName: 'email_verified_at')
  int? get emailVerifiedAt;

  @BuiltValueField(wireName: 'verified_phone_number')
  bool get phoneVerified;

  @BuiltValueField(wireName: 'custom_value1')
  String get customValue1;

  @BuiltValueField(wireName: 'custom_value2')
  String get customValue2;

  @BuiltValueField(wireName: 'custom_value3')
  String get customValue3;

  @BuiltValueField(wireName: 'custom_value4')
  String get customValue4;

  @BuiltValueField(wireName: 'google_2fa_secret')
  bool get isTwoFactorEnabled;

  @BuiltValueField(wireName: 'has_password')
  bool get hasPassword;

  @BuiltValueField(wireName: 'last_confirmed_email_address')
  String get lastEmailAddress;

  @BuiltValueField(wireName: 'oauth_user_token')
  String get oauthUserToken;

  @BuiltValueField(wireName: 'company_user')
  UserCompanyEntity? get userCompany;

  @BuiltValueField(wireName: 'oauth_provider_id')
  String get oauthProvider;

  @BuiltValueField(wireName: 'language_id')
  String get languageId;

  @BuiltValueField(wireName: 'user_logged_in_notification')
  bool get userLoggedInNotification;

  @BuiltValueField(wireName: 'referral_code')
  String get referralCode;

  @BuiltValueField(wireName: 'referral_meta')
  BuiltMap<String, int> get referralMeta;

  String get fullName => (firstName + ' ' + lastName).trim();

  String get referralUrl =>
      'https://app.invoicing.co/#/register?rc=$referralCode';

  bool canEdit(BaseEntity entity) =>
      entity.createdUserId == id || entity.assignedUserId == id;

  @override
  String get listDisplayName {
    return fullName.isNotEmpty ? fullName : email;
  }

  int compareTo(UserEntity? user, String sortField, bool sortAscending) {
    int response = 0;
    final UserEntity? userA = sortAscending ? this : user;
    final UserEntity? userB = sortAscending ? user : this;

    switch (sortField) {
      case UserFields.lastName:
        response = userA!.lastName
            .toLowerCase()
            .compareTo(userB!.lastName.toLowerCase());
        break;
      case UserFields.firstName:
        response = userA!.firstName
            .toLowerCase()
            .compareTo(userB!.firstName.toLowerCase());
        break;
      case UserFields.email:
        response = userA!.email.compareTo(userB!.email);
        break;
      default:
          logError('sort by user.$sortField is not implemented');
        break;
    }

    return response;
  }

  static UserEntity fromMap(Map<String, dynamic> map) {
    int createdAt = 0;
    int updatedAt = 0;

    if (map['createdAt'] is Timestamp) {
      createdAt = (map['createdAt'] as Timestamp).seconds;
    } else if (map['created_at'] is int) {
      createdAt = map['created_at'];
    }

    if (map['updatedAt'] is Timestamp) {
      updatedAt = (map['updatedAt'] as Timestamp).seconds;
    } else if (map['updated_at'] is int) {
      updatedAt = map['updated_at'];
    }

    return UserEntity(id: map['id']).rebuild((b) => b
      ..createdUserId = map['createdUserId'] ?? ''
      ..assignedUserId = map['assignedUserId'] ?? ''
      ..firstName = map['name'] ?? map['firstName'] ?? ''
      ..lastName = map['lastName'] ?? ''
      ..email = map['email'] ?? ''
      ..phone = map['phone'] ?? ''
      ..createdAt = createdAt
      ..updatedAt = updatedAt
      ..archivedAt = map['archivedAt'] ?? 0
      ..isDeleted = map['isDeleted'] ?? false
      ..customValue1 = map['customValue1'] ?? ''
      ..customValue2 = map['customValue2'] ?? ''
      ..customValue3 = map['customValue3'] ?? ''
      ..customValue4 = map['customValue4'] ?? ''
      ..oauthProvider = map['oauthProvider'] ?? ''
      ..phoneVerified = map['phoneVerified'] ?? false
      ..isTwoFactorEnabled = map['isTwoFactorEnabled'] ?? false
      ..hasPassword = map['hasPassword'] ?? false);
  }

  @override
  bool matchesFilter(String? filter) {
    return matchesStrings(
      haystacks: [
        firstName,
        lastName,
        email,
        phone,
        customValue1,
        customValue2,
        customValue3,
        customValue4,
      ],
      needle: filter,
    );
  }

  @override
  String? matchesFilterValue(String? filter) {
    return matchesStringsValue(
      haystacks: [
        firstName,
        lastName,
        email,
        phone,
        customValue1,
        customValue2,
        customValue3,
        customValue4,
      ],
      needle: filter,
    );
  }

  @override
  List<EntityAction?> getActions(
      {UserCompanyEntity? userCompany,
      bool includeEdit = false,
      bool includePreview = false,
      bool multiselect = false,
      bool? isGuest,
      bool? isAuthor}) {
    final actions = <EntityAction?>[];

    if (!isDeleted! && !multiselect) {
      if (includeEdit && userCompany!.canEditEntity(this)) {
        actions.add(EntityAction.edit);
      }
    }

    if (userCompany!.isAdmin || userCompany.isOwner) {
      if (!isDeleted! && !isEmailVerified) {
        actions.add(EntityAction.resendInvite);
      }

      actions.add(EntityAction.remove);
    }

    if (actions.isNotEmpty && actions.last != null) {
      actions.add(null);
    }

    return actions
      ..addAll(super.getActions(
        userCompany: userCompany,
        isGuest: isGuest,
        isAuthor: isAuthor,
      ));
  }

  @override
  double? get listDisplayAmount => null;

  @override
  FormatNumberType? get listDisplayAmountType => null;

  bool get isConnectedToOAuth => isConnectedToGoogle || isConnectedToMicrosoft;

  bool get isConnectedToGoogle =>
      oauthProvider == UserEntity.OAUTH_PROVIDER_GOOGLE;

  bool get isConnectedToApple =>
      oauthProvider == UserEntity.OAUTH_PROVIDER_APPLE;

  bool get isConnectedToMicrosoft =>
      oauthProvider == UserEntity.OAUTH_PROVIDER_MICROSOFT;

  bool get isConnectedToEmail =>
      isConnectedToOAuth && oauthUserToken.isNotEmpty;

  bool get isEmailVerified => emailVerifiedAt != null;

  // ignore: unused_element
  static void _initializeBuilder(UserEntityBuilder builder) => builder
    ..isTwoFactorEnabled = false
    ..hasPassword = false
    ..phoneVerified = false
    ..password = ''
    ..lastEmailAddress = ''
    ..oauthUserToken = ''
    ..languageId = ''
    ..userLoggedInNotification = true
    ..referralCode = ''
    ..referralMeta.replace(BuiltMap<String, int>());

  static Serializer<UserEntity> get serializer => _$userEntitySerializer;
}
