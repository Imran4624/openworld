import 'dart:async';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_boilerplate/redux/ui/entity_ui_state.dart';
import 'package:flutter_boilerplate/redux/ui/list_ui_state.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/ui/pref_state.dart';

part 'product_state.g.dart';

abstract class ProductState
    implements Built<ProductState, ProductStateBuilder> {
  factory ProductState() {
    return _$ProductState._(
      map: BuiltMap<String, ProductEntity>(),
      list: BuiltList<String>(),
      lastDocument: null,
      filter: ProductFilter(),
    );
  }
  ProductState._();

  @override
  @memoized
  int get hashCode;

  BuiltMap<String, ProductEntity> get map;
  BuiltList<String> get list;

  DocumentSnapshot? get lastDocument;
  ProductFilter get filter;

  ProductEntity get(String productId) {
    return map[productId] ?? ProductEntity(id: productId);
  }

  ProductState loadProducts(BuiltList<ProductEntity> products) {
    final map = Map<String, ProductEntity>.fromIterable(
      products,
      key: (dynamic item) => item.id,
      value: (dynamic item) => item,
    );

    return rebuild((b) => b
      ..map.addAll(map)
      ..list.replace((map.keys.toList() + list.toList()).toSet().toList()));
  }

  static Serializer<ProductState> get serializer => _$productStateSerializer;
}

abstract class ProductUIState extends Object
    with EntityUIState
    implements Built<ProductUIState, ProductUIStateBuilder> {
  factory ProductUIState(PrefStateSortField? sortField) {
    return _$ProductUIState._(
      listUIState: ListUIState(
        // STARTER: primary field - do not remove comment
        sortField?.field ?? ProductFields.name,
        sortAscending: sortField?.ascending,
      ),
      editing: ProductEntity(),
      selectedId: '',
      tabIndex: 0,
      dynamicFields: BuiltMap<String, dynamic>(),
    );
  }
  ProductUIState._();

  @override
  @memoized
  int get hashCode;

  ProductEntity? get editing;

  BuiltMap<String, dynamic> get dynamicFields;

  @override
  bool get isCreatingNew => editing?.isNew ?? false;

  @override
  String get editingId => editing?.id ?? '';

  static Serializer<ProductUIState> get serializer =>
      _$productUIStateSerializer;
}
