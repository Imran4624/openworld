import 'dart:async';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_boilerplate/redux/ui/entity_ui_state.dart';
import 'package:flutter_boilerplate/redux/ui/list_ui_state.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/ui/pref_state.dart';

part 'social_state.g.dart';

abstract class SocialState implements Built<SocialState, SocialStateBuilder> {
  factory SocialState() {
    return _$SocialState._(
      map: BuiltMap<String, SocialEntity>(),
      list: BuiltList<String>(),
      lastDocument: null,
      filter: SocialFilter(),
    );
  }
  SocialState._();

  @override
  @memoized
  int get hashCode;

  BuiltMap<String, SocialEntity> get map;
  BuiltList<String> get list;

  DocumentSnapshot? get lastDocument;
  SocialFilter get filter;

  SocialEntity get(String socialId) {
    return map[socialId] ?? SocialEntity(id: socialId);
  }

  SocialState loadSocials(BuiltList<SocialEntity> clients) {
    final map = Map<String, SocialEntity>.fromIterable(
      clients,
      key: (dynamic item) => item.id,
      value: (dynamic item) => item,
    );

    return rebuild((b) => b
      ..map.addAll(map)
      ..list.replace((map.keys.toList() + list.toList()).toSet().toList()));
  }

  static Serializer<SocialState> get serializer => _$socialStateSerializer;
}

abstract class SocialUIState extends Object
    with EntityUIState
    implements Built<SocialUIState, SocialUIStateBuilder> {
  factory SocialUIState(PrefStateSortField? sortField) {
    return _$SocialUIState._(
      listUIState: ListUIState(
        // STARTER: primary field - do not remove comment
        sortField?.field ?? SocialFields.userDisplayName,
        sortAscending: sortField?.ascending,
      ),
      editing: SocialEntity(),
      selectedId: '',
      tabIndex: 0,
    );
  }
  SocialUIState._();

  @override
  @memoized
  int get hashCode;

  SocialEntity? get editing;

  @override
  bool get isCreatingNew => editing?.isNew ?? false;

  @override
  String get editingId => editing?.id ?? '';

  static Serializer<SocialUIState> get serializer => _$socialUIStateSerializer;
}
