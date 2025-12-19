import 'package:built_value/built_value.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/utils/formatting.dart';
import 'package:flutter_boilerplate/utils/strings.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';

part 'product_model.g.dart';

abstract class ProductFilter
    implements Built<ProductFilter, ProductFilterBuilder> {
  factory ProductFilter() {
    return _$ProductFilter._(
      searchTerm: '',
      stateFilter: EntityState.active,
      sortField: ProductFields.name,
      sortAscending: true,
      limit: 10,
      dynamicFieldsFilters: BuiltMap<String, dynamic>(),
    );
  }

  ProductFilter._();

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

  static Serializer<ProductFilter> get serializer => _$productFilterSerializer;
}

abstract class ProductListResponse
    implements Built<ProductListResponse, ProductListResponseBuilder> {
  factory ProductListResponse(
          [void Function(ProductListResponseBuilder) updates]) =
      _$ProductListResponse;

  ProductListResponse._();

  @override
  @memoized
  int get hashCode;

  BuiltList<ProductEntity> get data;

  static Serializer<ProductListResponse> get serializer =>
      _$productListResponseSerializer;
}

abstract class ProductItemResponse
    implements Built<ProductItemResponse, ProductItemResponseBuilder> {
  factory ProductItemResponse(
          [void Function(ProductItemResponseBuilder) updates]) =
      _$ProductItemResponse;

  ProductItemResponse._();

  @override
  @memoized
  int get hashCode;

  ProductEntity get data;

  static Serializer<ProductItemResponse> get serializer =>
      _$productItemResponseSerializer;
}

class ProductFields {
  // STARTER: fields - do not remove comment
  static const String name = 'name';
  static const String dynamicFields = 'dynamicFields';
}

abstract class ProductEntity extends Object
    with BaseEntity
    implements Built<ProductEntity, ProductEntityBuilder> {
  factory ProductEntity({String? id, AppState? state}) {
    return _$ProductEntity._(
      id: id ?? BaseEntity.nextId,
      isChanged: false,
      isDeleted: false,
      createdAt: 0,
      updatedAt: 0,
      createdUserId: '',
      assignedUserId: '',
      archivedAt: 0,
      isProductCompleted: false,
      dynamicFields: BuiltMap<String, dynamic>(),
      // STARTER: constructor - do not remove comment
      name: '',
    );
  }

  ProductEntity._();

  @override
  @memoized
  int get hashCode;

  // STARTER: properties - do not remove comment
  String get name;

  @BuiltValueField(serialize: true)
  BuiltMap<String, dynamic> get dynamicFields;

  bool get isProductCompleted;

  @override
  EntityType get entityType => EntityType.product;

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

  int compareTo(ProductEntity product, String sortField, bool sortAscending) {
    int response = 0;
    final productA = sortAscending ? this : product;
    final productB = sortAscending ? product : this;

    switch (sortField) {
      // STARTER: sort switch - do not remove comment
      case ProductFields.name:
        response = productA.name.compareTo(productB.name);
        break;

      default:
    logError('sort by product.$sortField is not implemented');
        break;
    }

    if (response == 0) {
      // STARTER: sort default - do not remove comment
      return productA.name.compareTo(productB.name);
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

  @override
  FormatNumberType get listDisplayAmountType => FormatNumberType.int;

  static ProductEntity fromJson(Map<String, dynamic> data, String id) {
    int createdAt = 0;
    int updatedAt = 0;

    if (data['created_at'] != null) {
      createdAt = data['created_at'] is int
          ? data['created_at']
          : (data['created_at'] is Map
              ? data['created_at']['_seconds'] ?? 0
              : 0);
    }

    if (data['updated_at'] != null) {
      updatedAt = data['updated_at'] is int
          ? data['updated_at']
          : (data['updated_at'] is Map
              ? data['updated_at']['_seconds'] ?? 0
              : 0);
    }

    final dynamicFields = data['dynamic_fields'] ?? {};

    return ProductEntity(id: id).rebuild((b) => b
      ..name = data['name'] ?? ''
      ..dynamicFields = MapBuilder(Map<String, dynamic>.from(dynamicFields))
      ..createdAt = createdAt
      ..updatedAt = updatedAt
      ..archivedAt = data['archived_at'] ?? 0
      ..isDeleted = data['is_deleted'] ?? false
      ..createdUserId = data['user_id'] ?? ''
      ..assignedUserId = data['assigned_user_id'] ?? ''
      ..isChanged = data['is_changed'] ?? false
      ..isProductCompleted = data['is_product_completed'] ?? false);
  }

  @override
  String get listDisplayName => '';

  @override
  double get listDisplayAmount => 0;

  static Serializer<ProductEntity> get serializer => _$productEntitySerializer;
}
