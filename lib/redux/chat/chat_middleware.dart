import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/data/models/chat/last_message_modal.dart';
import 'package:flutter_boilerplate/redux/auth/auth_actions.dart';
import 'package:flutter_boilerplate/services/session_managment_service.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
// import 'package:flutter_boilerplate/data/models/chat_model.dart';
import 'package:flutter_boilerplate/ui/chat/message_view/message_screen.dart';
import 'package:redux/redux.dart';
import 'package:built_collection/built_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_boilerplate/main_app.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/ui/ui_actions.dart';
import 'package:flutter_boilerplate/ui/chat/chat_screen.dart';
import 'package:flutter_boilerplate/ui/chat/create/create_chat_vm.dart';
import 'package:flutter_boilerplate/redux/chat/chat_actions.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/data/repositories/chat_repository.dart';
import 'package:flutter_boilerplate/redux/notification/notification_actions.dart'
    as notification_actions;
import 'package:flutter_boilerplate/ui/dynamic_fields/dynamic_fields_presenter.dart';


List<Middleware<AppState>> createStoreChatsMiddleware([
  ChatRepository repository = const ChatRepository(),
]) {
  final viewChatList = _viewChatList();
  final viewMessage = _viewMessage(repository);
  final editChat = _editChat();
  final createOrOpenChat = _createOrOpenChat(repository);
  final loadChats = _loadChats(repository);
  final loadChat = _loadChat(repository);
  final saveChat = _saveChat(repository);
  final archiveChat = _archiveChat(repository);
  final deleteChat = _deleteChat(repository);
  final restoreChat = _restoreChat(repository);
  final updateFilter = _updateFilter(repository);
  final loadMessages = _loadMessages(repository);
  final watchMessages = _watchMessages(repository);
  final sendMessage = _sendMessage(repository);
  final deleteMessage = _deleteMessage(repository);
  final viewOnceMessage = _viewOnceMessage(repository);

  return [
    TypedMiddleware<AppState, ViewChatList>(viewChatList),
    TypedMiddleware<AppState, ViewMessage>(viewMessage),
    TypedMiddleware<AppState, EditChat>(editChat),
    TypedMiddleware<AppState, CreateOrOpenChatRequest>(createOrOpenChat),
    TypedMiddleware<AppState, LoadChats>(loadChats),
    TypedMiddleware<AppState, LoadChat>(loadChat),
    TypedMiddleware<AppState, SaveChatRequest>(saveChat),
    TypedMiddleware<AppState, ArchiveChatsRequest>(archiveChat),
    TypedMiddleware<AppState, DeleteChatsRequest>(deleteChat),
    TypedMiddleware<AppState, RestoreChatsRequest>(restoreChat),
    TypedMiddleware<AppState, UpdateChatFilter>(updateFilter),
    TypedMiddleware<AppState, LoadMessages>(loadMessages),
    TypedMiddleware<AppState, WatchMessages>(watchMessages),
    TypedMiddleware<AppState, SendMessageRequest>(sendMessage),
    TypedMiddleware<AppState, ViewOnceMessageRequest>(viewOnceMessage),
    TypedMiddleware<AppState, DeleteMessageRequest>(deleteMessage),
  ];
}

Middleware<AppState> _editChat() {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as EditChat;

    next(action);

    store.dispatch(UpdateCurrentRoute(CreateChatScreen.route));

    if (store.state.prefState.isMobile) {
      navigatorKey.currentState!.pushNamed(CreateChatScreen.route);
    }
  };
}

Middleware<AppState> _createOrOpenChat(ChatRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction,
      NextDispatcher next) async {
    final action = dynamicAction as CreateOrOpenChatRequest;

    try {
      await ChatRepository.createOrOpenChat(action.context, action.targetEmail);
      action.completer?.complete();
    } catch (error) {
      logError(' Error in createOrOpenChat middleware: $error');
      store.dispatch(CreateOrOpenChatFailure(error));
      action.completer?.completeError(error);
    }

    next(action);
  };
}

TypedMiddleware<AppState, ViewMessage> _viewMessage(ChatRepository repository) {
  return TypedMiddleware<AppState, ViewMessage>(
      (Store<AppState> store, ViewMessage action, NextDispatcher next) async {
    next(action);

    store.dispatch(UpdateCurrentRoute(MessageScreen.route));

    if (store.state.prefState.isMobile) {
      navigatorKey.currentState!.pushNamed(MessageScreen.route);
    }

    final state = store.state;
    final currentUserId = getLoggedInUserId(store);
    final chatId = action.chatId;

    if (chatId != null) {
      final chat = await repository.loadItem(chatId);

      var updatedUnreadCounts =
          Map<String, int>.from(chat.unreadCounts.toMap());
      updatedUnreadCounts[currentUserId] = 0;

      final updatedChat = chat.rebuild((b) => b
        ..unreadCounts
            .replace(BuiltMap<String, int>.from(updatedUnreadCounts)));

      try {
        await repository.saveData(
            store.state.credentials, updatedChat, chat.participants.toList());

        store.dispatch(SaveChatSuccess(updatedChat));
      } catch (error) {
        logError(' Error updating unread count: $error');
      }
    }
  });
}

Middleware<AppState> _viewChatList() {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as ViewChatList;

    next(action);

    if (store.state.staticState.isStale) {
      store.dispatch(RefreshData());
    }

    store.dispatch(UpdateCurrentRoute(ChatScreen.route));

    if (store.state.prefState.isMobile) {
      navigatorKey.currentState!.pushNamedAndRemoveUntil(
          ChatScreen.route, (Route<dynamic> route) => false);
    }
  };
}

Middleware<AppState> _archiveChat(ChatRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as ArchiveChatsRequest;
    final prevChats = action.chatIds
        .map((id) => store.state.chatState.map[id])
        .whereType<ChatEntity>()
        .toList();

    repository
        .bulkAction(
            store.state.credentials, action.chatIds, EntityAction.archive)
        .then((List<ChatEntity> chats) {
      store.dispatch(ArchiveChatsSuccess(chats));
      action.completer.complete(null);
    }).catchError((Object error) {
      logError(' Error in archiveChat middleware: $error');
      store.dispatch(ArchiveChatsFailure(prevChats));
      action.completer.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _deleteChat(ChatRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as DeleteChatsRequest;
    final prevChats = action.chatIds
        .map((id) => store.state.chatState.map[id])
        .whereType<ChatEntity>()
        .toList();

    repository
        .bulkAction(
            store.state.credentials, action.chatIds, EntityAction.delete)
        .then((List<ChatEntity> chats) {
      store.dispatch(DeleteChatsSuccess(chats));
      action.completer.complete(null);
    }).catchError((Object error) {
      logError(' Error in deleteChat middleware: $error');
      store.dispatch(DeleteChatsFailure(prevChats));
      action.completer.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _restoreChat(ChatRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as RestoreChatsRequest;
    final prevChats = action.chatIds
        .map((id) => store.state.chatState.map[id])
        .whereType<ChatEntity>()
        .toList();

    repository
        .bulkAction(
            store.state.credentials, action.chatIds, EntityAction.restore)
        .then((List<ChatEntity> chats) {
      store.dispatch(RestoreChatsSuccess(chats));
      action.completer.complete(null);
    }).catchError((Object error) {
      logError(' Error in restoreChat middleware: $error');
      store.dispatch(RestoreChatsFailure(prevChats));
      action.completer.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _saveChat(ChatRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as SaveChatRequest;

    if (allowChatWithXUsers == -1) {
      repository
          .saveData(store.state.credentials, action.chat!, action.participants)
          .then((ChatEntity chat) {
        if (action.chat!.isNew) {
          store.dispatch(AddChatSuccess(chat));
          if (action.isOpenChat) {
          store.dispatch(ViewMessage(chatId: chat.id));
          }
        } else {
          store.dispatch(SaveChatSuccess(chat));
        }
        action.completer?.complete(chat);
      }).catchError((Object error) {
        logError(' Error in saveChat middleware: $error');
        store.dispatch(SaveChatFailure(error));
        action.completer?.completeError(error);
      });
    } else {
      repository
          .loadListWithPagination(
              userId: getLoggedInUserId(store), chatCount: true)
          .then((response) {
        final chats = response['chats'] as BuiltList<ChatEntity>;
        if (chats.length <= allowChatWithXUsers) {
          repository
              .saveData(
                  store.state.credentials, action.chat!, action.participants)
              .then((ChatEntity chat) {
            if (action.chat!.isNew) {
              store.dispatch(AddChatSuccess(chat));

              store.dispatch(ViewMessage(chatId: chat.id));
            } else {
              store.dispatch(SaveChatSuccess(chat));
            }
            action.completer?.complete(chat);
          }).catchError((Object error) {
            logError(' Error in saveChat middleware: $error');
            store.dispatch(SaveChatFailure(error));
            action.completer?.completeError(error);
          });
        } else {
          store.dispatch(SaveChatFailure('error'));
          logWarning("you are out of chat limit");
        }
      }).catchError((Object error) {
        store.dispatch(SaveChatFailure(error));
        logError(' Error in saveChat middleware: $error');
      });
    }
    next(action);
  };
}

Middleware<AppState> _loadChat(ChatRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as LoadChat;

    store.dispatch(LoadChatRequest());
    repository.loadItem(action.chatId!).then((chat) {
      store.dispatch(LoadChatSuccess(chat));
      action.completer?.complete(null);
    }).catchError((Object error) {
      logError(' Error in loadChat middleware: $error');
      store.dispatch(LoadChatFailure(error));
      action.completer?.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _loadChats(ChatRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    if (store.state.isLoading) {
      return;
    }

    final action = dynamicAction as LoadChats;
    final state = store.state;
    final stateFilters = state.chatListState.stateFilters;
    final currentFilter = action.filter ?? state.chatState.filter;

    final filter = currentFilter.rebuild((b) {
      if (stateFilters.isNotEmpty) {
        b.stateFilter = stateFilters.first;
      } else {
        b.stateFilter = EntityState.active;
      }
    });

    final userId = getLoggedInUserId(store);
    store.dispatch(LoadChatsRequest(filter: filter, userId: userId));

    var lastDocument = state.chatState.lastDocument;
    if (action.isRefresh) {
      lastDocument = null;
      store.dispatch(UpdateLastDocumentAction(null));
    }

    repository
        .loadListWithPagination(
      lastDocument: lastDocument,
      limit: filter.limit,
      filter: filter,
      userId: userId,
    )
        .then((response) {
      final chats = response['chats'] as BuiltList<ChatEntity>;
      final newLastDocument = response['lastDocument'] as DocumentSnapshot?;

      store.dispatch(LoadChatsSuccess(chats, isRefresh: action.isRefresh));

      if (chats.isNotEmpty) {
        store.dispatch(UpdateLastDocumentAction(newLastDocument));
      }

      action.completer?.complete(null);
    }).catchError((Object error) {
      logError('$error');
      store.dispatch(LoadChatsFailure(error));
      action.completer?.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _updateFilter(ChatRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as UpdateChatFilter;

    if (action.filter.searchTerm != store.state.chatState.filter.searchTerm ||
        action.filter.stateFilter != store.state.chatState.filter.stateFilter) {
      next(action);

      store.dispatch(LoadChats(
        filter: action.filter,
        isRefresh: true,
      ));
    }
  };
}

TypedMiddleware<AppState, LoadMessages> _loadMessages(
    ChatRepository repository) {
  return TypedMiddleware<AppState, LoadMessages>(
      (Store<AppState> store, LoadMessages action, NextDispatcher next) async {
    if (action.completer?.isCompleted ?? false) {
      return;
    }

    if (action.chatId == null || action.chatId!.isEmpty) {
      logInfo('Skipping load messages - no chat ID provided');
      action.completer?.complete();
      return;
    }

    store.dispatch(LoadMessagesRequest());

    var lastMessageDocument = action.isRefresh
        ? null
        : store.state.chatState.messageState.lastMessageDocument;

    try {
      final response = await repository.loadMessages(
          store.state.credentials, action.chatId!,
          limit: action.limit, lastDocument: lastMessageDocument);
      final messages = response['messages'] as BuiltList<ChatMessageEntity>;
      final lastDocument = response['lastDocument'];
      store.dispatch(LoadMessagesSuccess(messages,
          isRefresh: lastMessageDocument == null ? true : action.isRefresh));
      if (messages.isNotEmpty) {
        store.dispatch(UpdateLastMessageDocumentAction(lastDocument));
      }

      action.completer?.complete();
    } catch (error) {
      logError(' Error in loadMessages middleware: $error');
      store.dispatch(LoadMessagesFailure(error));
      action.completer?.completeError(error);
    }

    next(action);
  });
}

Middleware<AppState> _watchMessages(ChatRepository repository) {
  StreamSubscription<List<ChatMessageEntity>>? subscription;

  return (Store<AppState> store, dynamic action, NextDispatcher next) async {
    if (action is WatchMessages) {
      if (action.chatId.isEmpty) {
        logInfo('Skipping watch messages - no chat ID provided');
        await subscription?.cancel();
        return;
      }

      store.dispatch(WatchMessagesRequest());

      await subscription?.cancel();

      try {
        final stream = repository.watchMessages(action.chatId);

        store.dispatch(UpdateMessageStream(stream));

        subscription = stream.listen(
          (messages) async {
            store.dispatch(WatchMessagesSuccess(messages));
            if (messages.isNotEmpty) {
              final lastMessage = messages.last;
              final chat = await repository.loadItem(action.chatId);
              final currentUserId = getLoggedInUserId(store);
              final selectedChatId = store.state.chatUIState.selectedId;

              if (chat != null) {
                var updatedUnreadCounts =
                    Map<String, int>.from(chat.unreadCounts.toMap());

                if (action.chatId == selectedChatId) {
                  updatedUnreadCounts[currentUserId] = 0;
                } else if (lastMessage.senderId == currentUserId) {
                  chat.participantsIds
                      .where((p) => p != currentUserId)
                      .forEach((p) {
                    updatedUnreadCounts[p] = (updatedUnreadCounts[p] ?? 0) + 1;
                  });
                }

                final updatedChat = chat.rebuild((b) => b
                  ..lastMessage.replace(LastMessageEntity(
                    messageId: lastMessage.messageId,
                    senderId: lastMessage.senderId,
                    content: lastMessage.content,
                    createdAt: lastMessage.createdAt,
                    attachments: lastMessage.attachments,
                  ))
                  ..unreadCounts
                      .replace(BuiltMap<String, int>.from(updatedUnreadCounts))
                  ..lastActive = DateTime.now().millisecondsSinceEpoch);

                store.dispatch(SaveChatSuccess(updatedChat));

                try {
                  await repository.saveData(
                    store.state.credentials,
                    updatedChat,
                    chat.participants.toList(),
                  );
                } catch (error) {
                  logError(' Error updating chat in Firebase: $error');
                }
              }
            }

            if (action.completer != null && !action.completer!.isCompleted) {
              action.completer!.complete();
            }
          },
          onError: (error) {
            logError(' Error watching messages: $error');
            store.dispatch(WatchMessagesFailure(error));
            if (action.completer != null && !action.completer!.isCompleted) {
              action.completer!.completeError(error);
            }
          },
        );
      } catch (e) {
        logError(' Error setting up message stream: $e');
        store.dispatch(WatchMessagesFailure(e));
        if (action.completer != null && !action.completer!.isCompleted) {
          action.completer!.completeError(e);
        }
      }
    } else if (action is UserLogout) {
      // Add cleanup on logout
      await subscription?.cancel();
      subscription = null;
    }

    next(action);
  };
}

Middleware<AppState> _sendMessage(ChatRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction,
      NextDispatcher next) async {
    final action = dynamicAction as SendMessageRequest;
    final state = store.state;
    final currentUser = state.profileState.loggedInUserProfile;

    if (currentUser == null) {
      store.dispatch(
          SendMessageFailure('User not logged in', ChatMessageEntity()));
      return;
    }

    try {
      var message = action.message!;
      if (message.chatId.isEmpty) {
        final existingChat = state.chatState.map.values.firstWhere(
          (chat) =>
              chat.participantsIds.contains(message.senderId) &&
              chat.participantsIds.contains(message.replyTo) &&
              chat.participantsIds.length == 2,
          orElse: () => ChatEntity(id: ''),
        );
        String chatId;
        ChatEntity hydratedChat;
        if (existingChat.id.isNotEmpty) {
          chatId = existingChat.id;
          hydratedChat = existingChat;
        } else {
          try {
            final chat = await getDataForChatCreation(
              repository: repository,
              message: message,
              currentUser: currentUser,
            );
            
            if (chat != null) {
              final completer = Completer<ChatEntity>();
              store.dispatch(SaveChatRequest(
                completer: completer,
                chat: chat,
                isOpenChat: false,
                participants: chat.participants.toList(),
              ));
              hydratedChat = await completer.future;
              chatId = hydratedChat.id;
            } else {
              store.dispatch(SendMessageFailure('error', ChatMessageEntity()));
              return;
            }
          } catch (error) {
            store.dispatch(SendMessageFailure(error.toString(), ChatMessageEntity()));
            return;
          }
        }
        message = message.rebuild((b) => b..chatId = chatId);
      }

      final savedMessage = await repository.saveMessage(
        store.state.credentials,
        message,
      );

      store.dispatch(notification_actions.SendNotificationAction(
        title: currentUser.name,
        sendTo: message.replyTo,
        body: message.content,
        data: {
          'type': 'message',
          'chatId': message.chatId,
          'messageId': savedMessage.messageId,
          'senderId': currentUser.id,
        },
      ));

      store.dispatch(SendMessageSuccess(savedMessage));
      action.completer?.complete(savedMessage);
    } catch (error) {
      logError(' Error sending message: $error');
      store.dispatch(SendMessageFailure(error, ChatMessageEntity()));
      action.completer?.completeError(error);
    }

    next(action);
  };
}

Middleware<AppState> _viewOnceMessage(ChatRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction,
      NextDispatcher next) async {
    final action = dynamicAction as ViewOnceMessageRequest;

    try {
      await repository.markMessageAsViewed(
        store.state.credentials,
        action.chatId,
        action.messageId,
        action.userId,
      );

      store.dispatch(ViewOnceMessageSuccess(action.messageId, action.userId));
      action.completer?.complete();
    } catch (error) {
      logError(' Error marking view-once message as viewed: $error');
      store.dispatch(ViewOnceMessageFailure(error));
      action.completer?.completeError(error);
    }

    next(action);
  };
}

Middleware<AppState> _deleteMessage(ChatRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction,
      NextDispatcher next) async {
    final action = dynamicAction as DeleteMessageRequest;

    try {
      await repository.deleteMessage(
        store.state.credentials,
        action.chatId,
        action.messageId,
      );

      store.dispatch(DeleteMessageSuccess(action.messageId));
      action.completer?.complete();
    } catch (error) {
      logError(' Error deleting message: $error');
      store.dispatch(DeleteMessageFailure(error));
      action.completer?.completeError(error);
    }

    next(action);
  };
}

Future<ChatEntity?> getDataForChatCreation({
  required ChatRepository repository,
  required ChatMessageEntity message,
  required ProfileEntity currentUser,
}) async {
  ProfileEntity? senderProfile;
  senderProfile = await repository.fetchChatParticipantProfile(message.senderId);
  if (senderProfile == null) {
    logError('Error in method:getDataForChatCreation Failed to fetch sender profile,senderProfileId: ${message.senderId}');
    return null;
  }
  ProfileEntity? receiverProfile;
  receiverProfile = await repository.fetchChatParticipantProfile(message.replyTo);
  if (receiverProfile == null) {
    logError('Error in method:getDataForChatCreation Failed to fetch receiver profile,receiverProfileId: ${message.replyTo}');
    return null;
  }

  String senderThumbnail = '';
  final imageUrls = senderProfile.dynamicFields.getImages('images');
  if (imageUrls.isNotEmpty) {
    senderThumbnail = imageUrls.first;
  }
  String receiverThumbnail = '';
  final receiverImageUrls = receiverProfile.dynamicFields.getImages('images');
  if (receiverImageUrls.isNotEmpty) {
    receiverThumbnail = receiverImageUrls.first;
  }

  final participants = [message.senderId, message.replyTo];

  final chat = ChatEntity().rebuild((b) => b
    ..isGroupChat = false
    ..status = ChatStatus.inProgress
    ..centityType = CEntityType.user
    ..centityId = message.senderId
    ..lastActive = DateTime.now().millisecondsSinceEpoch
    ..createdUserId = message.senderId
    ..participantsIds = ListBuilder<String>(participants)
    ..participants = ListBuilder<ChatParticipantEntity>([
      ChatParticipantEntity(userId: message.senderId, userName: senderProfile!.name, userThumbnail: senderThumbnail),
      ChatParticipantEntity(userId: message.replyTo, userName: receiverProfile!.name, userThumbnail: receiverThumbnail),
    ])
  );

  return chat;
}