import 'package:built_value/built_value.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'package:flutter_boilerplate/utils/formatting.dart';
import 'package:flutter_boilerplate/utils/strings.dart';

part 'photo_model.g.dart';

abstract class PhotoFilter implements Built<PhotoFilter, PhotoFilterBuilder> {
  factory PhotoFilter() {
    return _$PhotoFilter._(
      searchTerm: '',
      stateFilter: EntityState.active,
      sortField: PhotoFields.category,
      sortAscending: true,
      limit: 20,
    );
  }

  PhotoFilter._();

  @override
  @memoized
  int get hashCode;

  String get searchTerm;
  EntityState get stateFilter;
  String get sortField;
  bool get sortAscending;
  int get limit;

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

    return {
      'filters': filters,
      'sort_field': sortField,
      'sort_ascending': sortAscending,
      'limit': limit
    };
  }

  static Serializer<PhotoFilter> get serializer => _$photoFilterSerializer;
}

abstract class PhotoListResponse
    implements Built<PhotoListResponse, PhotoListResponseBuilder> {
  factory PhotoListResponse([void Function(PhotoListResponseBuilder) updates]) =
      _$PhotoListResponse;

  PhotoListResponse._();

  @override
  @memoized
  int get hashCode;

  BuiltList<PhotoEntity> get data;

  static Serializer<PhotoListResponse> get serializer =>
      _$photoListResponseSerializer;
}

abstract class PhotoItemResponse
    implements Built<PhotoItemResponse, PhotoItemResponseBuilder> {
  factory PhotoItemResponse([void Function(PhotoItemResponseBuilder) updates]) =
      _$PhotoItemResponse;

  PhotoItemResponse._();

  @override
  @memoized
  int get hashCode;

  PhotoEntity get data;

  static Serializer<PhotoItemResponse> get serializer =>
      _$photoItemResponseSerializer;
}

class PhotoFields {
  // STARTER: fields - do not remove comment
  static const String category = 'category';
  static const String storageType = 'storageType';
  static const String url = 'url';
  static const String isProcessed = 'isProcessed';
  static const String tags = 'tags';
}

abstract class PhotoEntity extends Object
    with BaseEntity
    implements Built<PhotoEntity, PhotoEntityBuilder> {
  factory PhotoEntity({String? id, AppState? state}) {
    return _$PhotoEntity._(
      id: id ?? BaseEntity.nextId,
      isChanged: false,
      isDeleted: false,
      createdAt: 0,
      updatedAt: 0,
      createdUserId: '',
      assignedUserId: '',
      archivedAt: 0,
      // STARTER: constructor - do not remove comment
      category: '',
      storageType: 0,
      url: '',
      isProcessed: false,
      tags: '',
      reportsMap: null,
      reported: null,
    );
  }

  PhotoEntity._();

  @override
  @memoized
  int get hashCode;

  // STARTER: properties - do not remove comment
  String get category;
  int get storageType;
  String get url;
  bool get isProcessed;
  String get tags;

  @BuiltValueField(serialize: false)
  Map<String, dynamic>? get reportsMap;
  bool? get reported;

  @override
  EntityType get entityType => EntityType.photo;

  @override
  bool matchesStates(BuiltList<EntityState> states) {
    if (states.isEmpty) {
      return true;
    }

    for (final state in states) {
      bool matches = false;

      switch (state) {
        case EntityState.active:
          matches = isActive && !isArchived && (isDeleted != true);
          break;
        case EntityState.archived:
          matches = isArchived && (isDeleted != true);
          break;
        case EntityState.deleted:
          matches = isDeleted == true;
          break;
        case EntityState.reported:
          matches = reported == true;
          break;
        case EntityState.myEntities:
          matches = true;
          break;
        case EntityState.activeAndMineEntities:
          matches = true;
          break;
        default:
          matches = false;
          break;
      }

      if (matches) {
        return true;
      }
    }

    return false;
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

    final author = isAuthor == true;
    final guest = isGuest == true;

    if (guest) {
      return [];
    }

    if (!isDeleted! &&
        !multiselect &&
        includeEdit &&
        (userCompany?.canEditEntity(this) == true || author)) {
      actions.add(EntityAction.edit);
    }

    if (!multiselect && (userCompany?.canEditEntity(this) == true || author)) {
      actions.add(EntityAction.purge);
    }
    if (multiselect && (userCompany?.canEditEntity(this) == true || author)) {
      actions.add(EntityAction.purge);
    }

    if ((author || userCompany?.canEditEntity(this) == true) &&
        !isDeleted! &&
        !multiselect &&
        !isProcessed) {
      actions.add(EntityAction.approve);
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

  int compareTo(PhotoEntity photo, String sortField, bool sortAscending) {
    int response = 0;
    final photoA = sortAscending ? this : photo;
    final photoB = sortAscending ? photo : this;

    switch (sortField) {
      // STARTER: sort switch - do not remove comment
      case PhotoFields.category:
        response = photoA.category.compareTo(photoB.category);
        break;

      case PhotoFields.url:
        response = photoA.url.compareTo(photoB.url);
        break;

      case PhotoFields.tags:
        response = photoA.tags.compareTo(photoB.tags);
        break;

      default:
        logError('sort by photo.$sortField is not implemented');
        break;
    }

    if (response == 0) {
      // STARTER: sort default - do not remove comment
      return photoA.category.compareTo(photoB.category);
    } else {
      return response;
    }
  }

  @override
  bool matchesFilter(String? filter) {
    return matchesStrings(
      haystacks: [
        // STARTER: field names - do not remove comment
        category,
        url,
        tags,
      ],
      needle: filter,
    );
  }

  @override
  String? matchesFilterValue(String? filter) {
    return matchesStringsValue(
      haystacks: [
        // STARTER: field names - do not remove comment
        category,
        url,
        tags,
      ],
      needle: filter,
    )!;
  }

  @override
  String get listDisplayName => '';

  @override
  double get listDisplayAmount => 0;

  @override
  FormatNumberType get listDisplayAmountType => FormatNumberType.int;

  static Serializer<PhotoEntity> get serializer => _$photoEntitySerializer;
}
