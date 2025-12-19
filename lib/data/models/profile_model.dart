import 'package:built_value/built_value.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'package:flutter_boilerplate/utils/formatting.dart';
import 'package:flutter_boilerplate/utils/strings.dart';

part 'profile_model.g.dart';

abstract class ProfileReport
    implements Built<ProfileReport, ProfileReportBuilder> {
  factory ProfileReport({
    String? userId,
    String? comment,
    int? timestamp,
  }) {
    return _$ProfileReport._(
      userId: userId ?? '',
      comment: comment ?? '',
      timestamp: timestamp ?? 0,
    );
  }

  ProfileReport._();

  @override
  @memoized
  int get hashCode;

  String get userId;
  String get comment;
  int get timestamp;

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'comment': comment,
      'timestamp': timestamp,
    };
  }

  static ProfileReport fromMap(Map<String, dynamic> data) {
    return ProfileReport(
      userId: data['userId']?.toString() ?? '',
      comment: data['comment']?.toString() ?? '',
      timestamp: data['timestamp'] as int? ?? 0,
    );
  }

  static Serializer<ProfileReport> get serializer => _$profileReportSerializer;
}

abstract class ProfileFilter
    implements Built<ProfileFilter, ProfileFilterBuilder> {
  factory ProfileFilter() {
    return _$ProfileFilter._(
      searchTerm: '',
      stateFilter: EntityState.active,
      sortField: ProfileFields.name,
      sortAscending: true,
      currentUserId: '',
      preferredGender: '',
      limit: 10,
      dynamicFieldsFilters: BuiltMap<String, dynamic>(),
    );
  }

  ProfileFilter._();

  @override
  @memoized
  int get hashCode;

  String get searchTerm;
  EntityState get stateFilter;
  String get sortField;
  bool get sortAscending;
  String get currentUserId;
  String get preferredGender;
  int get limit;
  BuiltMap<String, dynamic> get dynamicFieldsFilters;

  Map<String, dynamic> toFirebaseQuery() {
    final Map<String, dynamic> filters = {};

    // Handle search term
    if (searchTerm.isNotEmpty) {
      filters['title'] = searchTerm.toLowerCase();
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
      case EntityState.reported:
        filters['reported'] = true;
        break;
    }

    if (dynamicFieldsFilters.isNotEmpty) {
      final Map<String, dynamic> dynamicFieldsFilters = {};

      dynamicFieldsFilters.forEach((key, value) {
        if (value is Map<String, dynamic>) {
          dynamicFieldsFilters[key] = value;
        } else if (value is List) {
          dynamicFieldsFilters[key] = {'in': value};
        } else {
          dynamicFieldsFilters[key] = value;
        }
      });

      filters['dynamic_fields'] = dynamicFieldsFilters;
    }

    return {
      'filters': filters,
      'sort_field': sortField,
      'sort_ascending': sortAscending,
      'limit': limit
    };
  }

  static Serializer<ProfileFilter> get serializer => _$profileFilterSerializer;
}

abstract class UserCompany implements Built<UserCompany, UserCompanyBuilder> {
  factory UserCompany({
    String? companyId,
    String? companyName,
  }) {
    return _$UserCompany._(
      companyId: companyId ?? '',
      companyName: companyName ?? '',
    );
  }

  UserCompany._();

  @override
  @memoized
  int get hashCode;

  String get companyId;
  String get companyName;

  Map<String, dynamic> toMap() {
    return {
      'companyId': companyId,
      'companyName': companyName,
    };
  }

  static UserCompany fromMap(Map<String, dynamic> data) {
    return UserCompany(
      companyId: data['companyId']?.toString() ?? '',
      companyName: data['companyName']?.toString() ?? '',
    );
  }

  static Serializer<UserCompany> get serializer => _$userCompanySerializer;
}

abstract class ProfileListResponse
    implements Built<ProfileListResponse, ProfileListResponseBuilder> {
  factory ProfileListResponse(
          [void Function(ProfileListResponseBuilder) updates]) =
      _$ProfileListResponse;

  ProfileListResponse._();

  @override
  @memoized
  int get hashCode;

  BuiltList<ProfileEntity> get data;

  static Serializer<ProfileListResponse> get serializer =>
      _$profileListResponseSerializer;
}

abstract class ProfilePaginationResponse
    implements
        Built<ProfilePaginationResponse, ProfilePaginationResponseBuilder> {
  factory ProfilePaginationResponse({
    BuiltList<ProfileEntity>? profiles,
    DocumentSnapshot? lastDocument,
  }) {
    return _$ProfilePaginationResponse._(
      profiles: profiles ?? BuiltList<ProfileEntity>(),
      lastDocument: lastDocument,
    );
  }

  ProfilePaginationResponse._();

  @override
  @memoized
  int get hashCode;

  BuiltList<ProfileEntity> get profiles;

  @BuiltValueField(serialize: false)
  DocumentSnapshot? get lastDocument;

  static Serializer<ProfilePaginationResponse> get serializer =>
      _$profilePaginationResponseSerializer;
}

abstract class ProfileSingleResponse
    implements Built<ProfileSingleResponse, ProfileSingleResponseBuilder> {
  factory ProfileSingleResponse({
    ProfileEntity? profile,
    DocumentSnapshot? lastDocument,
  }) {
    return _$ProfileSingleResponse._(
      profile: profile,
      lastDocument: lastDocument,
    );
  }

  ProfileSingleResponse._();

  @override
  @memoized
  int get hashCode;

  ProfileEntity? get profile;

  @BuiltValueField(serialize: false)
  DocumentSnapshot? get lastDocument;

  static Serializer<ProfileSingleResponse> get serializer =>
      _$profileSingleResponseSerializer;
}

abstract class ProfileItemResponse
    implements Built<ProfileItemResponse, ProfileItemResponseBuilder> {
  factory ProfileItemResponse(
          [void Function(ProfileItemResponseBuilder) updates]) =
      _$ProfileItemResponse;

  ProfileItemResponse._();

  @override
  @memoized
  int get hashCode;

  ProfileEntity get data;

  static Serializer<ProfileItemResponse> get serializer =>
      _$profileItemResponseSerializer;
}

class ProfileFields {
  // STARTER: fields - do not remove comment
  static const String name = 'name';
  static const String dynamicFields = 'dynamicFields';
}

abstract class ProfileEntity extends Object
    with BaseEntity
    implements Built<ProfileEntity, ProfileEntityBuilder> {
  factory ProfileEntity({String? id, AppState? state}) {
    return _$ProfileEntity._(
      id: id ?? BaseEntity.nextId,
      isChanged: false,
      isDeleted: false,
      isAdmin: false,
      createdAt: 0,
      updatedAt: 0,
      createdUserId: '',
      assignedUserId: '',
      archivedAt: 0,
      isProfileCompleted: false,
      dynamicFields: BuiltMap<String, dynamic>(),
      likesProfileMap: BuiltMap<String, ProfileOperationEntity>(),
      likedMeProfileMap: BuiltMap<String, ProfileOperationEntity>(),
      matchesProfileMap: BuiltMap<String, ProfileOperationEntity>(),
      passesProfileMap: BuiltMap<String, ProfileOperationEntity>(),
      isReported: false,
      reportedBy: BuiltMap<String, ProfileReport>(),
      email: '',
      companyIds: BuiltList<String>(),
      // STARTER: constructor - do not remove comment
      name: '',
      paymentStatus: null,
      orgStripeAccountId: null,
    );
  }

  ProfileEntity._();

  @override
  @memoized
  int get hashCode;

  // STARTER: properties - do not remove comment
  String get name;
  String get email;
  BuiltList<String> get companyIds;

  @BuiltValueField(wireName: 'payment_status')
  String? get paymentStatus;

  @BuiltValueField(wireName: 'org_stripe_account_id')
  String? get orgStripeAccountId;

  @BuiltValueField(serialize: true)
  BuiltMap<String, dynamic> get dynamicFields;

  @BuiltValueField(serialize: false)
  BuiltMap<String, ProfileOperationEntity> get likesProfileMap;

  @BuiltValueField(serialize: false)
  BuiltMap<String, ProfileReport> get reportedBy;

  @BuiltValueField(serialize: false)
  BuiltMap<String, ProfileOperationEntity> get likedMeProfileMap;

  @BuiltValueField(serialize: false)
  BuiltMap<String, ProfileOperationEntity> get matchesProfileMap;

  @BuiltValueField(serialize: false)
  BuiltMap<String, ProfileOperationEntity> get passesProfileMap;

  bool get isProfileCompleted;
  bool get isAdmin;

  @override
  EntityType get entityType => EntityType.profile;

  bool hasInteractedWith(String profileId) {
    return likesProfileMap.containsKey(profileId) ||
        likedMeProfileMap.containsKey(profileId) ||
        matchesProfileMap.containsKey(profileId) ||
        passesProfileMap.containsKey(profileId);
  }

  Set<String> getInteractedProfileIds() {
    final Set<String> ids = {};
    ids.addAll(likesProfileMap.keys);
    ids.addAll(likedMeProfileMap.keys);
    ids.addAll(matchesProfileMap.keys);
    ids.addAll(passesProfileMap.keys);
    return ids;
  }

  @override
  List<EntityAction?> getActions({
    UserCompanyEntity? userCompany,
    bool includeEdit = false,
    bool multiselect = false,
    bool? isGuest,
    bool? isAuthor,
  }) {
    final actions = <EntityAction?>[];

    if (!isDeleted! &&
        !multiselect &&
        includeEdit &&
        userCompany?.canEditEntity(this) == true) {
      actions.add(EntityAction.edit);
    }

    if (!multiselect && userCompany?.canEditEntity(this) == true) {
      actions.add(EntityAction.purge);
    }

    if (actions.isNotEmpty) {
      actions.add(null);
    }

    return actions
      ..addAll(super.getActions(
        userCompany: userCompany,
        isGuest: isGuest,
        isAuthor: isAuthor,
      ));
  }

  int compareTo(ProfileEntity profile, String sortField, bool sortAscending) {
    int response = 0;
    final profileA = sortAscending ? this : profile;
    final profileB = sortAscending ? profile : this;

    switch (sortField) {
      // STARTER: sort switch - do not remove comment
      case ProfileFields.name:
        response = profileA.name.compareTo(profileB.name);
        break;

      default:
        logError('sort by profile.$sortField is not implemented');
        break;
    }

    if (response == 0) {
      // STARTER: sort default - do not remove comment
      return profileA.name.compareTo(profileB.name);
    } else {
      return response;
    }
  }

  @override
  bool matchesFilter(String? filter) {
    return matchesStrings(
      haystacks: [
        // STARTER: field names - do not remove comment
        name,
      ],
      needle: filter,
    );
  }

  @override
  String? matchesFilterValue(String? filter) {
    return matchesStringsValue(
      haystacks: [
        // STARTER: field names - do not remove comment
        name,
      ],
      needle: filter,
    )!;
  }

  static ProfileEntity fromFirestore(Map<String, dynamic> data, String id) {
    // Convert Firestore timestamp to int if needed
    int createdAt = 0;
    int updatedAt = 0;

    if (data['createdAt'] is Timestamp) {
      createdAt = (data['createdAt'] as Timestamp).seconds;
    } else if (data['created_at'] is int) {
      createdAt = data['created_at'];
    }

    if (data['updatedAt'] is Timestamp) {
      updatedAt = (data['updatedAt'] as Timestamp).seconds;
    } else if (data['updated_at'] is int) {
      updatedAt = data['updated_at'];
    }

    final dynamicFields = data['dynamicFields'] ?? {};

    final Map<String, ProfileOperationEntity> likesMap = {};
    final Map<String, ProfileOperationEntity> likedMeMap = {};
    final Map<String, ProfileOperationEntity> matchesMap = {};
    final Map<String, ProfileOperationEntity> passesMap = {};

    if (data['likesProfileMap'] != null && data['likesProfileMap'] is Map) {
      (data['likesProfileMap'] as Map).forEach((key, value) {
        if (key is String && value is Map) {
          try {
            final operation = ProfileOperationEntity().rebuild((b) {
              b.id = value['id'] ?? '';
              b.createdUserId = value['created_user_id'] ?? '';
              b.assignedUserId = value['assigned_user_id'] ?? '';
              b.type = value['type'] ?? 0;
              b.status = value['status'] ?? 0;
              b.comment = value['comment'] ?? '';
              b.createdAt = value['created_at'] ?? 0;
              b.updatedAt = value['updated_at'] ?? 0;
            });

            likesMap[key] = operation;
          } catch (e) {
            logError('Error parsing likesProfileMap entry: $e');
          }
        }
      });
    }

    if (data['likedMeProfileMap'] != null && data['likedMeProfileMap'] is Map) {
      (data['likedMeProfileMap'] as Map).forEach((key, value) {
        if (key is String && value is Map) {
          try {
            final operation = ProfileOperationEntity().rebuild((b) {
              b.id = value['id'] ?? '';
              b.createdUserId = value['created_user_id'] ?? '';
              b.assignedUserId = value['assigned_user_id'] ?? '';
              b.type = value['type'] ?? 0;
              b.status = value['status'] ?? 0;
              b.comment = value['comment'] ?? '';
              b.createdAt = value['created_at'] ?? 0;
              b.updatedAt = value['updated_at'] ?? 0;
            });

            likedMeMap[key] = operation;
          } catch (e) {
            logError('Error parsing likedMeProfileMap entry: $e');
          }
        }
      });
    }

    if (data['matchesProfileMap'] != null && data['matchesProfileMap'] is Map) {
      (data['matchesProfileMap'] as Map).forEach((key, value) {
        if (key is String && value is Map) {
          try {
            final operation = ProfileOperationEntity().rebuild((b) {
              b.id = value['id'] ?? '';
              b.createdUserId = value['created_user_id'] ?? '';
              b.assignedUserId = value['assigned_user_id'] ?? '';
              b.type = value['type'] ?? 0;
              b.status = value['status'] ?? 0;
              b.comment = value['comment'] ?? '';
              b.createdAt = value['created_at'] ?? 0;
              b.updatedAt = value['updated_at'] ?? 0;
            });

            matchesMap[key] = operation;
          } catch (e) {
            logError('Error parsing matchesProfileMap entry: $e');
          }
        }
      });
    }

    if (data['passesProfileMap'] != null && data['passesProfileMap'] is Map) {
      (data['passesProfileMap'] as Map).forEach((key, value) {
        if (key is String && value is Map) {
          try {
            final operation = ProfileOperationEntity().rebuild((b) {
              b.id = value['id'] ?? '';
              b.createdUserId = value['created_user_id'] ?? '';
              b.assignedUserId = value['assigned_user_id'] ?? '';
              b.type = value['type'] ?? 0;
              b.status = value['status'] ?? 0;
              b.comment = value['comment'] ?? '';
              b.createdAt = value['created_at'] ?? 0;
              b.updatedAt = value['updated_at'] ?? 0;
            });

            passesMap[key] = operation;
          } catch (e) {
            logError('Error parsing passesProfileMap entry: $e');
          }
        }
      });
    }

    List<String> companyIdsList = [];
    if (data['companyIds'] != null && data['companyIds'] is List) {
      companyIdsList = (data['companyIds'] as List)
          .map((id) => id?.toString() ?? '')
          .where((id) => id.isNotEmpty)
          .toList();
    }

    return ProfileEntity(id: id).rebuild((b) => b
      ..name = data['name'] ?? ''
      ..email = data['email'] ?? ''
      ..companyIds = ListBuilder(companyIdsList)
      ..dynamicFields = MapBuilder(Map<String, dynamic>.from(dynamicFields))
      ..likesProfileMap = MapBuilder(likesMap)
      ..likedMeProfileMap = MapBuilder(likedMeMap)
      ..matchesProfileMap = MapBuilder(matchesMap)
      ..passesProfileMap = MapBuilder(passesMap)
      ..createdAt = createdAt
      ..updatedAt = updatedAt
      ..archivedAt = data['archived_at'] ?? 0
      ..isAdmin = data['isAdmin'] ?? false
      ..isDeleted = data['is_deleted'] ?? false
      ..createdUserId = data['user_id'] ?? ''
      ..assignedUserId = data['assigned_user_id'] ?? ''
      ..isChanged = data['isChanged'] ?? false
      ..isProfileCompleted =
          data['is_profile_completed'] != null && !data['is_profile_completed'] ? data['is_profile_completed'] : data['isProfileCompleted'] ?? false
      ..isReported = data['reported'] ?? false
      ..reportedBy = MapBuilder(_buildReportedByMap(data['reportedBy'])));
  }

  static Map<String, ProfileReport> _buildReportedByMap(
      dynamic reportedByData) {
    final Map<String, ProfileReport> reportedByMap = {};

    if (reportedByData != null && reportedByData is Map) {
      reportedByData.forEach((key, value) {
        if (key is String && value is Map) {
          try {
            final report =
                ProfileReport.fromMap(Map<String, dynamic>.from(value));
            reportedByMap[key] = report;
          } catch (e) {
            logError('Error parsing reportedBy entry: $e');
          }
        }
      });
    }

    return reportedByMap;
  }

  @override
  String get listDisplayName => '';

  @override
  double get listDisplayAmount => 0;

  @override
  FormatNumberType get listDisplayAmountType => FormatNumberType.int;

  static Serializer<ProfileEntity> get serializer => _$profileEntitySerializer;
}

class ProfileMapper {
  static Map<String, dynamic> entityToDb(ProfileEntity entity) {
    final data = <String, dynamic>{};
    data['id'] = entity.id;
    data['name'] = entity.name;
    data['email'] =
        entity.email.isNotEmpty ? entity.email.trim().toLowerCase() : '';
    data['created_at'] = entity.createdAt;
    data['updated_at'] = entity.updatedAt;
    data['archived_at'] = entity.archivedAt;
    data['is_deleted'] = entity.isDeleted ?? false;
    data['created_user_id'] = entity.createdUserId ?? '';
    data['assigned_user_id'] = entity.assignedUserId ?? '';
    data['is_profile_completed'] = entity.isProfileCompleted;
    data['isAdmin'] = entity.isAdmin;
    data['isChanged'] = entity.isChanged ?? false;

    if (entity.companyIds.isNotEmpty) {
      data['companyIds'] = entity.companyIds.toList();
    }

    if (entity.dynamicFields.isNotEmpty) {
      data['dynamicFields'] =
          Map<String, dynamic>.from(entity.dynamicFields.toMap());
    }

    if (entity.isReported != null && entity.isReported!) {
      data['reported'] = entity.isReported;
      if (entity.reportedBy.isNotEmpty) {
        final reportedByMap = <String, dynamic>{};
        entity.reportedBy.forEach((key, report) {
          reportedByMap[key] = report.toMap();
        });
        data['reportedBy'] = reportedByMap;
      }
    }

    return data;
  }

  static ProfileEntity dbToEntity(Map<String, dynamic> data, String id) {
    return ProfileEntity().rebuild((b) {
      b.id = id;
      b.name = data['name'] ?? '';
      b.email = data['email'] ?? '';
      b.isDeleted = data['is_deleted'] ?? false;
      b.createdAt = data['created_at'] ?? 0;
      b.updatedAt = data['updated_at'] ?? 0;
      b.archivedAt = data['archived_at'] ?? 0;
      b.createdUserId = data['created_user_id'] ?? data['user_id'] ?? '';
      b.assignedUserId = data['assigned_user_id'] ?? '';
      b.isProfileCompleted =
          data['isProfileCompleted'] ?? data['is_profile_completed'] ?? false;
      b.isAdmin = data['isAdmin'] ?? false;
      b.isChanged = data['isChanged'] ?? false;

      if (data['companyIds'] != null) {
        final companyIdsList = data['companyIds'] as List<dynamic>;
        final companyIds =
            companyIdsList.map<String>((id) => id.toString()).toList();
        b.companyIds.replace(companyIds);
      }

      if (data['dynamicFields'] != null) {
        for (final entry
            in (data['dynamicFields'] as Map<String, dynamic>).entries) {
          b.dynamicFields[entry.key] = entry.value;
        }
      }

      b.isReported = data['reported'] ?? false;
      if (data['reportedBy'] != null) {
        final reportedByMap = <String, ProfileReport>{};
        final rawReportedBy = data['reportedBy'] as Map;
        rawReportedBy.forEach((key, value) {
          if (key is String && value is Map) {
            try {
              final report =
                  ProfileReport.fromMap(Map<String, dynamic>.from(value));
              reportedByMap[key] = report;
            } catch (e) {
              logError('Error parsing reportedBy entry in dbToEntity: $e');
            }
          }
        });
        b.reportedBy = MapBuilder(reportedByMap);
      }
    });
  }
}
