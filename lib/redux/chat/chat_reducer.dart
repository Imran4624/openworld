import 'package:flutter_boilerplate/constants.dart';
import 'package:redux/redux.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/company/company_actions.dart';
import 'package:flutter_boilerplate/redux/ui/entity_ui_state.dart';
import 'package:flutter_boilerplate/redux/chat/chat_actions.dart';
import 'package:flutter_boilerplate/redux/ui/list_ui_state.dart';
import 'package:flutter_boilerplate/redux/chat/chat_state.dart';

EntityUIState chatUIReducer(ChatUIState state, dynamic action) {
  return state.rebuild((b) => b
    ..listUIState.replace(chatListReducer(state.listUIState, action))
    ..editing.replace(editingReducer(state.editing, action)!)
    ..selectedId = selectedIdReducer(state.selectedId, action)
    ..forceSelected = forceSelectedReducer(state.forceSelected, action)
    ..tabIndex = tabIndexReducer(state.tabIndex, action));
}

final forceSelectedReducer = combineReducers<bool?>([
  TypedReducer<bool?, ViewChat>((completer, action) => true),
  TypedReducer<bool?, ViewMessage>((completer, action) => true),
  TypedReducer<bool?, ViewChatList>((completer, action) => false),
  TypedReducer<bool?, FilterChatsByState>((completer, action) => false),
  TypedReducer<bool?, FilterChats>((completer, action) => false),
]);

final tabIndexReducer = combineReducers<int?>([
  TypedReducer<int?, UpdateChatTab>((completer, action) => action.tabIndex),
  TypedReducer<int?, PreviewEntity>((completer, action) => 0),
]);

Reducer<String?> selectedIdReducer = combineReducers([
  TypedReducer<String?, ArchiveChatsSuccess>((completer, action) => ''),
  TypedReducer<String?, DeleteChatsSuccess>((completer, action) => ''),
  TypedReducer<String?, PurgeChatsSuccess>((completer, action) => ''),
  TypedReducer<String?, PreviewEntity>((selectedId, action) =>
      action.entityType == EntityType.chat ? action.entityId : selectedId),
  TypedReducer<String?, ViewChat>(
      (String? selectedId, dynamic action) => action.chatId),
  TypedReducer<String?, ViewMessage>(
      (String? selectedId, dynamic action) => action.chatId),
  TypedReducer<String?, AddChatSuccess>(
      (String? selectedId, dynamic action) => action.chat.id),
  TypedReducer<String?, SelectCompany>(
      (selectedId, action) => action.clearSelection ? '' : selectedId),
  TypedReducer<String?, ClearEntityFilter>((selectedId, action) => ''),
  TypedReducer<String?, SortChats>((selectedId, action) => ''),
  TypedReducer<String?, FilterChats>((selectedId, action) => ''),
  TypedReducer<String?, FilterChatsByState>((selectedId, action) => ''),
  TypedReducer<String?, FilterByEntity>(
      (selectedId, action) => action.clearSelection
          ? ''
          : action.entityType == EntityType.chat
              ? action.entityId
              : selectedId),
]);

final editingReducer = combineReducers<ChatEntity?>([
  TypedReducer<ChatEntity?, SaveChatSuccess>(_updateEditing),
  TypedReducer<ChatEntity?, AddChatSuccess>(_updateEditing),
  TypedReducer<ChatEntity?, RestoreChatsSuccess>((chats, action) {
    return action.chats[0];
  }),
  TypedReducer<ChatEntity?, ArchiveChatsSuccess>((chats, action) {
    return action.chats[0];
  }),
  TypedReducer<ChatEntity?, DeleteChatsSuccess>((chats, action) {
    return action.chats[0];
  }),
  TypedReducer<ChatEntity?, PurgeChatsSuccess>((chats, action) {
    return action.chats[0];
  }),
  TypedReducer<ChatEntity?, EditChat>(_updateEditing),
  TypedReducer<ChatEntity?, UpdateChat>((chat, action) {
    return action.chat.rebuild((b) => b..isChanged = true);
  }),
  TypedReducer<ChatEntity?, DiscardChanges>(_clearEditing),
]);

ChatEntity _clearEditing(ChatEntity? chat, dynamic action) {
  return ChatEntity();
}

ChatEntity? _updateEditing(ChatEntity? chat, dynamic action) {
  return action.chat;
}

final chatListReducer = combineReducers<ListUIState>([
  TypedReducer<ListUIState, SortChats>(_sortChats),
  TypedReducer<ListUIState, FilterChatsByState>(_filterChatsByState),
  TypedReducer<ListUIState, FilterChats>(_filterChats),
  TypedReducer<ListUIState, StartChatMultiselect>(_startListMultiselect),
  TypedReducer<ListUIState, AddToChatMultiselect>(_addToListMultiselect),
  TypedReducer<ListUIState, RemoveFromChatMultiselect>(
      _removeFromListMultiselect),
  TypedReducer<ListUIState, ClearChatMultiselect>(_clearListMultiselect),
  TypedReducer<ListUIState, ViewChatList>(_viewChatList),
  TypedReducer<ListUIState, FilterByEntity>((state, action) => state.rebuild(
        (b) => b
          ..filter = null
          ..filterClearedAt = DateTime.now().millisecondsSinceEpoch,
      )),
]);

ListUIState _viewChatList(ListUIState chatListState, ViewChatList action) {
  return chatListState.rebuild((b) => b
    ..selectedIds = null
    ..filter = null
    ..filterClearedAt = DateTime.now().millisecondsSinceEpoch);
}

ListUIState _filterChatsByState(
    ListUIState chatListState, FilterChatsByState action) {
  if (chatListState.stateFilters.contains(action.state)) {
    return chatListState.rebuild((b) => b
      ..stateFilters.clear()
      ..stateFilters.add(EntityState.active));
  } else {
    return chatListState.rebuild((b) => b
      ..stateFilters.clear()
      ..stateFilters.add(action.state));
  }
}

ListUIState _filterChats(ListUIState chatListState, FilterChats action) {
  return chatListState.rebuild((b) => b
    ..filter = action.filter
    ..filterClearedAt = action.filter == null
        ? DateTime.now().millisecondsSinceEpoch
        : chatListState.filterClearedAt);
}

ListUIState _sortChats(ListUIState chatListState, SortChats action) {
  return chatListState.rebuild((b) => b
    ..sortAscending = b.sortField != action.field || !b.sortAscending!
    ..sortField = action.field);
}

ListUIState _startListMultiselect(
    ListUIState productListState, StartChatMultiselect action) {
  return productListState.rebuild((b) => b..selectedIds = ListBuilder());
}

ListUIState _addToListMultiselect(
    ListUIState productListState, AddToChatMultiselect action) {
  return productListState.rebuild((b) => b..selectedIds.add(action.entity.id));
}

ListUIState _removeFromListMultiselect(
    ListUIState productListState, RemoveFromChatMultiselect action) {
  return productListState
      .rebuild((b) => b..selectedIds.remove(action.entity.id));
}

ListUIState _clearListMultiselect(
    ListUIState productListState, ClearChatMultiselect action) {
  return productListState.rebuild((b) => b..selectedIds = null);
}

final chatsReducer = combineReducers<ChatState>([
  TypedReducer<ChatState, SaveChatSuccess>(_updateChat),
  TypedReducer<ChatState, AddChatSuccess>(_addChat),
  TypedReducer<ChatState, LoadChatsSuccess>(_setLoadedChats),
  TypedReducer<ChatState, LoadChatSuccess>(_setLoadedChat),
  TypedReducer<ChatState, UpdateLastDocumentAction>(_updateLastDocument),
  TypedReducer<ChatState, UpdateLastMessageDocumentAction>(
      _updateLastMessageDocument),
  TypedReducer<ChatState, UpdateChatFilter>(_updateChatFilter),
  // TypedReducer<ChatState, LoadCompanySuccess>(_setLoadedCompany), //uncomment this if you its dependant on selected company
  TypedReducer<ChatState, ArchiveChatsSuccess>(_archiveChatSuccess),
  TypedReducer<ChatState, DeleteChatsSuccess>(_deleteChatSuccess),
  TypedReducer<ChatState, PurgeChatsSuccess>(_purgeChatSuccess),
  TypedReducer<ChatState, RestoreChatsSuccess>(_restoreChatSuccess),
  TypedReducer<ChatState, LoadMessagesSuccess>(_loadMessagesChatSuccess),
  TypedReducer<ChatState, SendMessageSuccess>(_sendMessageChatSuccess),
  TypedReducer<ChatState, UpdateMessageStream>(_updateMessageStream),
  TypedReducer<ChatState, WatchMessagesSuccess>(_watchMessagesSuccess),
  TypedReducer<ChatState, SendMessageFailure>(_sendMessageFailure),
]);

ChatState _archiveChatSuccess(ChatState chatState, ArchiveChatsSuccess action) {
  final int currentTime = DateTime.now().millisecondsSinceEpoch;
  return chatState.rebuild((b) {
    for (final chat in action.chats) {
      b.map[chat.id] =
          chatState.map[chat.id]!.rebuild((b) => b..archivedAt = currentTime);
    }
  });
}

ChatState _updateChatFilter(ChatState chatState, UpdateChatFilter action) {
  return chatState.rebuild((b) => b..filter = action.filter.toBuilder());
}

// ChatState _deleteChatSuccess(ChatState chatState, DeleteChatsSuccess action) {
//   return chatState.rebuild((b) {
//     for (final chat in action.chats) {
//       b.map[chat.id] = chat;
//     }
//   });
// }

ChatState _deleteChatSuccess(ChatState chatState, DeleteChatsSuccess action) {
  return chatState.rebuild((b) {
    for (final chat in action.chats) {
      b.map[chat.id] =
          chatState.map[chat.id]!.rebuild((b) => b..isDeleted = true);
    }
  });
}

ChatState _purgeChatSuccess(ChatState chatState, PurgeChatsSuccess action) {
  return chatState.rebuild((b) {
    for (final chat in action.chats) {
      b.map.remove(chat.id);
      b.list.remove(chat.id);
    }
  });
}

ChatState _restoreChatSuccess(ChatState chatState, RestoreChatsSuccess action) {
  return chatState.rebuild((b) {
    for (final chat in action.chats) {
      b.map[chat.id] = chatState.map[chat.id]!.rebuild((b) => b
        ..isDeleted = false
        ..archivedAt = 0);
    }
  });
}

ChatState _addChat(ChatState chatState, AddChatSuccess action) {
  return chatState.rebuild((b) => b
    ..map[action.chat.id] = action.chat
    ..list.add(action.chat.id));
}

ChatState _updateChat(ChatState chatState, SaveChatSuccess action) {
  return chatState.rebuild((b) => b..map[action.chat.id] = action.chat);
}

ChatState _sendMessageChatSuccess(
    ChatState chatState, SendMessageSuccess action) {
  return chatState.rebuild((b) => b
    ..messageState.map[action.message.messageId] = action.message
    ..messageState.list.add(action.message.messageId));
}

ChatState _sendMessageFailure(
    ChatState messageState, SendMessageFailure action) {
  return messageState.rebuild((b) => b
    ..map.remove(action.message.messageId)
    ..list.remove(action.message.messageId));
}

ChatState _loadMessagesChatSuccess(
    ChatState chatState, LoadMessagesSuccess action) {
  return chatState.rebuild((b) {
    if (action.isRefresh) {
      b.messageState.map.clear();
      b.messageState.list.clear();
    }
    b
      ..messageState.map.addAll(Map.fromIterable(
            action.messages,
            key: (msg) => msg.messageId,
            value: (msg) => msg,
          ))
      ..messageState.list.replace(action.messages.map((msg) => msg.messageId));
  });
}

ChatState _watchMessagesSuccess(
    ChatState chatState, WatchMessagesSuccess action) {
  return chatState.rebuild(
      (b) => b..messageState.streamedMessages.replace(action.messages));
}

ChatState _updateMessageStream(
    ChatState chatState, UpdateMessageStream action) {
  return chatState
      .rebuild((b) => b..messageState.messageStream = action.stream);
}

ChatState _updateLastDocument(
    ChatState chatState, UpdateLastDocumentAction action) {
  return chatState.rebuild((b) => b..lastDocument = action.lastDocument);
}

ChatState _updateLastMessageDocument(
    ChatState chatState, UpdateLastMessageDocumentAction action) {
  return chatState.rebuild(
      (b) => b..messageState.lastMessageDocument = action.lastDocument);
}

ChatState _setLoadedChat(ChatState chatState, LoadChatSuccess action) {
  return chatState.rebuild((b) => b..map[action.chat.id] = action.chat);
}

ChatState _setLoadedChats(ChatState chatState, LoadChatsSuccess action) {
  return chatState.rebuild((b) {
    if (action.isRefresh) {
      b.list.clear();
      b.map.clear();
    }

    action.chats.forEach((chat) {
      b.map[chat.id] = chat;
      if (!b.list.build().contains(chat.id)) {
        b.list.add(chat.id);
      }
    });
  });
}

// ChatState _setLoadedCompany(ChatState chatState, LoadCompanySuccess action) {
//   final company = action.userCompany.company;
//   return chatState.loadChats(company.chats);
// }

MessageState messageReducer(MessageState state, dynamic action) {
  return _messageReducer(state, action);
}

Reducer<MessageState> _messageReducer = combineReducers([
  TypedReducer<MessageState, DeleteMessageSuccess>(_deleteMessageSuccess),
]);

MessageState _deleteMessageSuccess(
    MessageState messageState, DeleteMessageSuccess action) {
  return messageState.rebuild((b) {
    if (messageState.map.containsKey(action.messageId)) {
      b.map[action.messageId] = messageState.map[action.messageId]!.rebuild(
        (b) => b..status = MessageStatus.deleted,
      );
    }
  });
}
