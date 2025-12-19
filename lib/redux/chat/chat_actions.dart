import 'dart:async';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/utils/completers.dart';
import 'package:flutter_boilerplate/utils/localization.dart';
import 'package:flutter_boilerplate/ui/app/entities/entity_actions_dialog.dart';

class ViewChatList implements PersistUI {
  ViewChatList({this.force = false, this.page = 0});

  final bool force;
  final int page;

  @override
  String toString() {
    return 'ViewChatList';
  }
}

class ViewChat implements PersistUI, PersistPrefs {
  ViewChat({
    this.chatId,
    this.force = false,
  });

  final String? chatId;
  final bool force;

  @override
  String toString() {
    return 'ViewChat';
  }
}

class ViewMessage implements PersistUI, PersistPrefs {
  ViewMessage({
    this.chatId,
    this.force = false,
  });

  final String? chatId;
  final bool force;

  @override
  String toString() {
    return 'ViewMessage';
  }
}

class EditChat implements PersistUI, PersistPrefs {
  EditChat({
    required this.chat,
    this.completer,
    this.force = false,
  });

  final ChatEntity chat;
  final Completer? completer;
  final bool force;

  @override
  String toString() {
    return 'EditChat';
  }
}

class UpdateChat implements PersistUI {
  UpdateChat(this.chat);

  final ChatEntity chat;

  @override
  String toString() {
    return 'UpdateChat';
  }
}

class LoadChat {
  LoadChat({this.completer, this.chatId});

  final Completer? completer;
  final String? chatId;

  @override
  String toString() {
    return 'LoadChat';
  }
}

class LoadChatActivity {
  LoadChatActivity({this.completer, this.chatId});

  final Completer? completer;
  final String? chatId;

  @override
  String toString() {
    return 'LoadChatActivity';
  }
}

class UpdateLastDocumentAction {
  UpdateLastDocumentAction(this.lastDocument);
  final DocumentSnapshot? lastDocument;

  @override
  String toString() {
    return 'UpdateLastDocumentAction';
  }
}

class UpdateLastMessageDocumentAction {
  UpdateLastMessageDocumentAction(this.lastDocument);
  final DocumentSnapshot? lastDocument;

  @override
  String toString() {
    return 'UpdateLastMessageDocumentAction';
  }
}

class LoadChatRequest implements StartLoading {
  @override
  String toString() {
    return 'LoadChatRequest';
  }
}

class LoadChatFailure implements StopLoading {
  LoadChatFailure(this.error);

  final dynamic error;

  @override
  String toString() {
    return 'LoadChatFailure{error: $error}';
  }
}

class LoadChatSuccess implements StopLoading, PersistData {
  LoadChatSuccess(this.chat);

  final ChatEntity chat;

  @override
  String toString() {
    return 'LoadChatSuccess';
  }
}

// class LoadChatsRequest implements StartLoading {}

class LoadChatsFailure implements StopLoading {
  LoadChatsFailure(this.error);

  final dynamic error;

  @override
  String toString() {
    return 'LoadChatsFailure{error: $error}';
  }
}

class LoadChatsSuccess implements StopLoading {
  LoadChatsSuccess(this.chats, {this.isRefresh = false});

  final BuiltList<ChatEntity> chats;
  final bool isRefresh;

  @override
  String toString() {
    return 'LoadChatsSuccess';
  }
}

class CreateOrOpenChatRequest implements StartLoading {
  CreateOrOpenChatRequest({
    required this.targetEmail,
    required this.context,
    this.completer,
  });

  final String targetEmail;
  final BuildContext context;
  final Completer? completer;

  @override
  String toString() {
    return 'CreateOrOpenChatRequest';
  }
}

class CreateOrOpenChatSuccess implements StopLoading {
  CreateOrOpenChatSuccess(this.chat);
  final ChatEntity chat;

  @override
  String toString() {
    return 'CreateOrOpenChatSuccess';
  }
}

class CreateOrOpenChatFailure implements StopLoading {
  CreateOrOpenChatFailure(this.error);
  final Object error;

  @override
  String toString() {
    return 'CreateOrOpenChatFailure{error: $error}';
  }
}

class SaveChatRequest implements StartSaving {
  SaveChatRequest({
    this.completer,
    this.chat,
    this.isOpenChat = true,
    this.participants,
  });

  final Completer? completer;
  final ChatEntity? chat;
  final bool isOpenChat ;
  final List<ChatParticipantEntity>? participants;

  @override
  String toString() {
    return 'SaveChatRequest';
  }
}

class SaveChatSuccess implements StopSaving, PersistData, PersistUI {
  SaveChatSuccess(this.chat);

  final ChatEntity chat;

  @override
  String toString() {
    return 'SaveChatSuccess';
  }
}

class AddChatSuccess implements StopSaving, PersistData, PersistUI {
  AddChatSuccess(this.chat);

  final ChatEntity chat;

  @override
  String toString() {
    return 'AddChatSuccess';
  }
}

class SaveChatFailure implements StopSaving {
  SaveChatFailure(this.error);

  final Object error;

  @override
  String toString() {
    return 'SaveChatFailure{error: $error}';
  }
}

class ArchiveChatsRequest implements StartSaving {
  ArchiveChatsRequest(this.completer, this.chatIds);

  final Completer completer;
  final List<String> chatIds;

  @override
  String toString() {
    return 'ArchiveChatsRequest';
  }
}

class ArchiveChatsSuccess implements StopSaving, PersistData {
  ArchiveChatsSuccess(this.chats);

  final List<ChatEntity> chats;

  @override
  String toString() {
    return 'ArchiveChatsSuccess';
  }
}

class ArchiveChatsFailure implements StopSaving {
  ArchiveChatsFailure(this.chats);

  final List<ChatEntity> chats;

  @override
  String toString() {
    return 'ArchiveChatsFailure{chats: $chats}';
  }
}

class DeleteChatsRequest implements StartSaving {
  DeleteChatsRequest(this.completer, this.chatIds);

  final Completer completer;
  final List<String> chatIds;

  @override
  String toString() {
    return 'DeleteChatsRequest';
  }
}

class PurgeChatsRequest implements StartSaving {
  PurgeChatsRequest(this.completer, this.chatIds);

  final Completer completer;
  final List<String> chatIds;

  @override
  String toString() {
    return 'PurgeChatsRequest';
  }
}

class DeleteChatsSuccess implements StopSaving, PersistData {
  DeleteChatsSuccess(this.chats);

  final List<ChatEntity> chats;

  @override
  String toString() {
    return 'DeleteChatsSuccess';
  }
}

class PurgeChatsSuccess implements StopSaving, PersistData {
  PurgeChatsSuccess(this.chats);

  final List<ChatEntity> chats;

  @override
  String toString() {
    return 'PurgeChatsSuccess';
  }
}

class DeleteChatsFailure implements StopSaving {
  DeleteChatsFailure(this.chats);

  final List<ChatEntity> chats;
}

class PurgeChatsFailure implements StopSaving {
  PurgeChatsFailure(this.chats);

  final List<ChatEntity> chats;
}

class RestoreChatsRequest implements StartSaving {
  RestoreChatsRequest(this.completer, this.chatIds);

  final Completer completer;
  final List<String> chatIds;

  @override
  String toString() {
    return 'RestoreChatsRequest';
  }
}

class RestoreChatsSuccess implements StopSaving, PersistData {
  RestoreChatsSuccess(this.chats);

  final List<ChatEntity> chats;

  @override
  String toString() {
    return 'RestoreChatsSuccess';
  }
}

class RestoreChatsFailure implements StopSaving {
  RestoreChatsFailure(this.chats);

  final List<ChatEntity> chats;
}

class FilterChats implements PersistUI {
  FilterChats(this.filter);

  final String filter;

  @override
  String toString() {
    return 'FilterChats';
  }
}

class SortChats implements PersistUI, PersistPrefs {
  SortChats(this.field);

  final String field;

  @override
  String toString() {
    return 'SortChats';
  }
}

class FilterChatsByState implements PersistUI {
  FilterChatsByState(this.state);

  final EntityState state;

  @override
  String toString() {
    return 'FilterChatsByState';
  }
}

// class FilterChatsByCustom1 implements PersistUI {
//   FilterChatsByCustom1(this.value);

//   final String value;
// }

// class FilterChatsByCustom2 implements PersistUI {
//   FilterChatsByCustom2(this.value);

//   final String value;
// }

// class FilterChatsByCustom3 implements PersistUI {
//   FilterChatsByCustom3(this.value);

//   final String value;
// }

// class FilterChatsByCustom4 implements PersistUI {
//   FilterChatsByCustom4(this.value);

//   final String value;
// }

class StartChatMultiselect {
  StartChatMultiselect();

  @override
  String toString() {
    return 'StartChatMultiselect';
  }
}

class AddToChatMultiselect {
  AddToChatMultiselect({required this.entity});

  final BaseEntity entity;

  @override
  String toString() {
    return 'AddToChatMultiselect';
  }
}

class RemoveFromChatMultiselect {
  RemoveFromChatMultiselect({required this.entity});

  final BaseEntity entity;

  @override
  String toString() {
    return 'RemoveFromChatMultiselect';
  }
}

class ClearChatMultiselect {
  ClearChatMultiselect();

  @override
  String toString() {
    return 'ClearChatMultiselect';
  }
}

class UpdateChatTab implements PersistUI {
  UpdateChatTab({this.tabIndex});

  final int? tabIndex;

  @override
  String toString() {
    return 'UpdateChatTab';
  }
}

class UpdateChatFilter implements PersistUI {
  UpdateChatFilter(this.filter);
  final ChatFilter filter;

  @override
  String toString() {
    return 'UpdateChatFilter';
  }
}

class LoadChats {
  LoadChats({
    this.completer,
    this.filter,
    this.userId,
    this.page = 0,
    this.isRefresh = false,
  });

  final Completer? completer;
  final ChatFilter? filter;
  final String? userId;
  final int page;
  final bool isRefresh;

  @override
  String toString() {
    return 'LoadChats';
  }
}

class LoadChatsRequest implements StartLoading {
  LoadChatsRequest({
    this.filter,
    this.userId,
  });
  final ChatFilter? filter;
  final String? userId;

  @override
  String toString() {
    return 'LoadChatsRequest';
  }
}

class LoadMessages {
  LoadMessages({
    this.completer,
    this.chatId,
    this.limit = 20,
    this.isRefresh = false,
  });

  final Completer? completer;
  final String? chatId;
  final int limit;
  final bool isRefresh;

  @override
  String toString() {
    return 'LoadMessages';
  }
}

class LoadMessagesRequest implements StartLoading {
  @override
  String toString() {
    return 'LoadMessagesRequest';
  }
}

class LoadMessagesFailure implements StopLoading, StopSaving {
  LoadMessagesFailure(this.error);
  final dynamic error;

  @override
  String toString() {
    return 'LoadMessagesFailure{error: $error}';
  }
}

class LoadMessagesSuccess implements StopLoading, StopSaving {
  LoadMessagesSuccess(this.messages, {this.isRefresh = false});
  final BuiltList<ChatMessageEntity> messages;
  final bool isRefresh;

  @override
  String toString() {
    return 'LoadMessagesSuccess';
  }
}

class SendMessageRequest {
  SendMessageRequest({this.completer, this.message});

  final Completer? completer;
  final ChatMessageEntity? message;

  @override
  String toString() {
    return 'SendMessageRequest';
  }
}

class SendMessageSuccess {
  SendMessageSuccess(this.message);

  final ChatMessageEntity message;

  @override
  String toString() {
    return 'SendMessageSuccess';
  }
}

class SendMessageFailure {
  SendMessageFailure(this.error, this.message);

  final ChatMessageEntity message;
  final Object error;

  @override
  String toString() {
    return 'SendMessageFailure{error: $error, message: $message}';
  }
}

class DeleteMessageRequest implements StartSaving {
  DeleteMessageRequest(
      {this.completer, required this.chatId, required this.messageId});

  final Completer? completer;
  final String chatId;
  final String messageId;

  @override
  String toString() {
    return 'DeleteMessageRequest';
  }
}

class DeleteMessageSuccess implements StopSaving, PersistData {
  DeleteMessageSuccess(this.messageId);

  final String messageId;

  @override
  String toString() {
    return 'DeleteMessageSuccess';
  }
}

class DeleteMessageFailure implements StopSaving {
  DeleteMessageFailure(this.error);

  final Object error;

  @override
  String toString() {
    return 'DeleteMessageFailure{error: $error}';
  }
}

class WatchMessages {
  WatchMessages({
    this.completer,
    required this.chatId,
  });

  final Completer? completer;
  final String chatId;

  @override
  String toString() {
    return 'WatchMessages';
  }
}

class WatchMessagesRequest {
  @override
  String toString() {
    return 'WatchMessagesRequest';
  }
}

class WatchMessagesSuccess implements StopLoading {
  WatchMessagesSuccess(this.messages);
  final List<ChatMessageEntity> messages;

  @override
  String toString() {
    return 'WatchMessagesSuccess';
  }
}

class WatchMessagesFailure implements StopLoading {
  WatchMessagesFailure(this.error);
  final Object error;

  @override
  String toString() {
    return 'WatchMessagesFailure{error: $error}';
  }
}

class UpdateMessageStream {
  UpdateMessageStream(this.stream);
  final Stream<List<ChatMessageEntity>> stream;

  @override
  String toString() {
    return 'UpdateMessageStream';
  }
}

class StopWatchingMessages {
  StopWatchingMessages(this.chatId);
  final String chatId;

  @override
  String toString() {
    return 'StopWatchingMessages';
  }
}

class ViewOnceMessageRequest {
  ViewOnceMessageRequest({
    this.completer,
    required this.chatId,
    required this.messageId,
    required this.userId,
  });

  final Completer? completer;
  final String chatId;
  final String messageId;
  final String userId;

  @override
  String toString() {
    return 'ViewOnceMessageRequest';
  }
}

class ViewOnceMessageSuccess implements StopSaving, PersistData {
  ViewOnceMessageSuccess(this.messageId, this.userId);
  final String messageId;
  final String userId;

  @override
  String toString() {
    return 'ViewOnceMessageSuccess';
  }
}

class ViewOnceMessageFailure implements StopSaving {
  ViewOnceMessageFailure(this.error);
  final Object error;

  @override
  String toString() {
    return 'ViewOnceMessageFailure{error: $error}';
  }
}

void handleChatAction(
    BuildContext context, List<BaseEntity> chats, EntityAction action) {
  if (chats.isEmpty) {
    return;
  }

  final store = StoreProvider.of<AppState>(context);
  final localization = AppLocalization.of(context)!;
  final chat = chats.first as ChatEntity;
  final chatIds = chats.map((chat) => chat.id).toList();

  switch (action) {
    case EntityAction.restore:
      store.dispatch(RestoreChatsRequest(
          snackBarCompleter<Null>(localization.restoredChat), chatIds));
      break;
    case EntityAction.archive:
      store.dispatch(ArchiveChatsRequest(
          snackBarCompleter<Null>(localization.archivedChat), chatIds));
      break;
    case EntityAction.delete:
      store.dispatch(DeleteChatsRequest(
          snackBarCompleter<Null>(localization.deletedChat), chatIds));
      break;
    case EntityAction.toggleMultiselect:
      if (!store.state.chatListState.isInMultiselect()) {
        store.dispatch(StartChatMultiselect());
      }

      if (chats.isEmpty) {
        break;
      }

      for (final chat in chats) {
        if (!store.state.chatListState.isSelected(chat.id)) {
          store.dispatch(AddToChatMultiselect(entity: chat));
        } else {
          store.dispatch(RemoveFromChatMultiselect(entity: chat));
        }
      }
      break;
    case EntityAction.more:
      showEntityActionsDialog(
        entities: [chat],
      );
      break;
    default:
  logError('unhandled action $action in chat_actions');
      break;
  }
}
