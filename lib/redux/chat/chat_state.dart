import 'dart:async';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_boilerplate/data/models/chat_model.dart';
import 'package:flutter_boilerplate/redux/ui/entity_ui_state.dart';
import 'package:flutter_boilerplate/redux/ui/list_ui_state.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/ui/pref_state.dart';

part 'chat_state.g.dart';

abstract class ChatState implements Built<ChatState, ChatStateBuilder> {
  factory ChatState() {
    return _$ChatState._(
      map: BuiltMap<String, ChatEntity>(),
      list: BuiltList<String>(),
      lastDocument: null,
      filter: ChatFilter(),
      messageState: MessageState(),
    );
  }
  ChatState._();

  @override
  @memoized
  int get hashCode;

  BuiltMap<String, ChatEntity> get map;
  BuiltList<String> get list;

  DocumentSnapshot? get lastDocument;
  ChatFilter get filter;
  MessageState get messageState;

  ChatEntity get(String chatId) {
    return map[chatId] ?? ChatEntity(id: chatId);
  }

  ChatState loadChats(BuiltList<ChatEntity> chats) {
    final map = Map<String, ChatEntity>.fromIterable(
      chats,
      key: (dynamic item) => item.id,
      value: (dynamic item) => item,
    );

    return rebuild((b) => b
      ..map.addAll(map)
      ..list.replace(chats.map((chat) => chat.id)));
  }

  static Serializer<ChatState> get serializer => _$chatStateSerializer;
}

abstract class MessageState
    implements Built<MessageState, MessageStateBuilder> {
  factory MessageState() {
    return _$MessageState._(
      map: BuiltMap<String, ChatMessageEntity>(),
      list: BuiltList<String>(),
      lastMessageDocument: null,
      messageStream: null,
      streamedMessages: BuiltList<ChatMessageEntity>(),
    );
  }

  MessageState._();

  @override
  @memoized
  int get hashCode;
  DocumentSnapshot? get lastMessageDocument;

  BuiltMap<String, ChatMessageEntity> get map;
  BuiltList<String> get list;

  @BuiltValueField(serialize: false)
  Stream<List<ChatMessageEntity>>? get messageStream;
  BuiltList<ChatMessageEntity> get streamedMessages;

  ChatMessageEntity? getMessage(String messageId) {
    return map[messageId];
  }

  MessageState loadMessages(BuiltList<ChatMessageEntity> messages) {
    final map = Map<String, ChatMessageEntity>.fromIterable(
      messages,
      key: (dynamic item) => item.messageId,
      value: (dynamic item) => item,
    );

    return rebuild((b) => b
      ..map.addAll(map)
      ..list.replace(map.keys.toList()));
  }

  static Serializer<MessageState> get serializer => _$messageStateSerializer;
}

abstract class ChatUIState extends Object
    with EntityUIState
    implements Built<ChatUIState, ChatUIStateBuilder> {
  factory ChatUIState(PrefStateSortField? sortField) {
    return _$ChatUIState._(
      listUIState: ListUIState(
        // STARTER: primary field - do not remove comment
        sortField?.field ?? ChatFields.lastActive,
        sortAscending: sortField?.ascending,
      ),
      editing: ChatEntity(),
      selectedId: '',
      tabIndex: 0,
      messageIds: BuiltList<String>(), // To track messages for current chat
    );
  }
  ChatUIState._();

  @override
  @memoized
  int get hashCode;

  ChatEntity? get editing;
  BuiltList<String> get messageIds;

  @override
  bool get isCreatingNew => editing?.isNew ?? false;

  @override
  String get editingId => editing?.id ?? '';

  static Serializer<ChatUIState> get serializer => _$chatUIStateSerializer;
}
