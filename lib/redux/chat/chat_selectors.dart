import 'package:flutter_boilerplate/data/models/chat_model.dart';
import 'package:flutter_boilerplate/redux/static/static_state.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:memoize/memoize.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/ui/list_ui_state.dart';

var memoizedDropdownChatList = memo5((BuiltMap<String, ChatEntity> chatMap,
        BuiltList<String> chatList,
        StaticState staticState,
        BuiltMap<String, UserEntity> userMap,
        String? clientId) =>
    dropdownChatsSelector(chatMap, chatList, staticState, userMap, clientId));

List<String> dropdownChatsSelector(
    BuiltMap<String, ChatEntity> chatMap,
    BuiltList<String> chatList,
    StaticState staticState,
    BuiltMap<String, UserEntity> userMap,
    String? clientId) {
  final list = chatList.where((chatId) {
    final chat = chatMap[chatId];
    if (chat == null) {
      return false;
    }
    /*
    if (clientId != null && clientId > 0 && chat.clientId != clientId) {
      return false;
    }
    */
    return chat.isActive;
  }).toList();

  list.sort((chatAId, chatBId) {
    final chatA = chatMap[chatAId]!;
    final chatB = chatMap[chatBId]!;

    // STARTER: primary field - do not remove comment
    return chatA.compareTo(chatB, ChatFields.isGroupChat, true);
  });

  return list;
}

var memoizedFilteredChatList = memo4((SelectionState selectionState,
        BuiltMap<String, ChatEntity> chatMap,
        BuiltList<String> chatList,
        ListUIState chatListState) =>
    filteredChatsSelector(selectionState, chatMap, chatList, chatListState));

List<String> filteredChatsSelector(
    SelectionState selectionState,
    BuiltMap<String, ChatEntity> chatMap,
    BuiltList<String> chatList,
    ListUIState chatListState) {
  final filterEntityId = selectionState.filterEntityId;

  final filteredList = chatList.where((chatId) {
    final chat = chatMap[chatId];
    if (chat == null) {
      return false;
    }

    if (filterEntityId != null && chat.id != filterEntityId) {
      return false;
    }

    if (!chat.matchesStates(chatListState.stateFilters)) {
      return false;
    }

    // Uncomment if using custom filters in future
    // if (chatListState.custom1Filters.isNotEmpty &&
    //     !chatListState.custom1Filters.contains(chat.customValue1)) {
    //   return false;
    // } else if (chatListState.custom2Filters.isNotEmpty &&
    //     !chatListState.custom2Filters.contains(chat.customValue2)) {
    //   return false;
    // } else if (chatListState.custom3Filters.isNotEmpty &&
    //     !chatListState.custom3Filters.contains(chat.customValue3)) {
    //   return false;
    // } else if (chatListState.custom4Filters.isNotEmpty &&
    //     !chatListState.custom4Filters.contains(chat.customValue4)) {
    //   return false;
    // }

    return chat.matchesFilter(chatListState.filter);
  }).toList();

  filteredList.sort((chatAId, chatBId) {
    final chatA = chatMap[chatAId]!;
    final chatB = chatMap[chatBId]!;
    return chatB.lastActive.compareTo(chatA.lastActive);
  });

  final uniqueChats = <String, String>{};
  for (final chatId in filteredList) {
    final chat = chatMap[chatId];
    if (chat != null) {
      uniqueChats[chat.id] = chatId;
    }
  }

  final sortedUniqueChatIds = uniqueChats.values.toList();
  sortedUniqueChatIds.sort((chatAId, chatBId) {
    final chatA = chatMap[chatAId]!;
    final chatB = chatMap[chatBId]!;
    return chatB.lastActive.compareTo(chatA.lastActive);
  });

  return sortedUniqueChatIds;
}
