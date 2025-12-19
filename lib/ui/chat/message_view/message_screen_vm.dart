import 'dart:async';
import 'dart:io';
import 'package:built_collection/built_collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/utils/platforms.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_boilerplate/data/models/chat_model.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/ui/ui_actions.dart';
import 'package:flutter_boilerplate/ui/chat/message_view/message_screen.dart';
import 'package:redux/redux.dart';
import 'package:flutter_boilerplate/redux/chat/chat_actions.dart';
import 'package:flutter_boilerplate/ui/chat/chat_screen.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'package:flutter_boilerplate/services/session_managment_service.dart';

class MessageScreenBuilder extends StatelessWidget {
  const MessageScreenBuilder({Key? key}) : super(key: key);

  static const String route = '/chat/view';

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, MessageScreenVM>(
      distinct: true,
      converter: MessageScreenVM.fromStore,
      onInitialBuild: (vm) => vm.onLoad(isRefresh: true),
      onWillChange: (previousVM, nextVM) {
        if (previousVM?.chat.id != nextVM.chat.id) {
          nextVM.onLoad();
        }
      },
      builder: (context, vm) {
        return MessageScreen(
          viewModel: vm,
          isFilter: false,
        );
      },
    );
  }
}

class MessageScreenVM {
  MessageScreenVM({
    required this.state,
    required this.chat,
    required this.messages,
    required this.streamedMessages,
    required this.messageStream,
    required this.currentUserId,
    required this.onLoad,
    required this.onSendMessage,
    required this.onBackPressed,
    required this.onViewOnceMessage,
  });

  final AppState state;
  final ChatEntity chat;
  final List<ChatMessageEntity> messages;
  final List<ChatMessageEntity> streamedMessages;
  final Stream<List<ChatMessageEntity>>? messageStream;
  final String currentUserId;
  final Function({bool isRefresh}) onLoad;
  final Function(BuildContext, String, List<PlatformFile>, bool) onSendMessage;
  final Function() onBackPressed;
  final Function(dynamic) onViewOnceMessage;

  static MessageScreenVM fromStore(Store<AppState> store) {
    final state = store.state;
    final chatId = state.chatUIState.selectedId;
    final chat = state.chatState.map[chatId] ?? ChatEntity();

    void _loadMessages({bool isRefresh = false}) async {
      if (chat.id.isNotEmpty) {
        final currentUserId = getLoggedInUserId(store);
        if (chat.unreadCounts.isNotEmpty &&
            chat.unreadCounts[currentUserId]! > 0) {
          var updatedUnreadCounts =
              Map<String, int>.from(chat.unreadCounts.toMap());
          updatedUnreadCounts[currentUserId] = 0;

          final updatedChat = chat.rebuild((b) => b
            ..unreadCounts
                .replace(BuiltMap<String, int>.from(updatedUnreadCounts))
            ..lastActive = DateTime.now().millisecondsSinceEpoch);

          final completer = Completer<ChatEntity>();
          store.dispatch(SaveChatRequest(
            completer: completer,
            chat: updatedChat,
            participants: chat.participants.toList(),
          ));
          await completer.future;
        }
      }

      final completer = Completer<void>();
      store.dispatch(
        LoadMessages(
          completer: completer,
          chatId: chatId,
          limit: kMessageLoadLimit,
          isRefresh: isRefresh,
        ),
      );

      await completer.future;

      store.dispatch(
        WatchMessages(chatId: chatId!),
      );
    }

    String _getContentType(String extension) {
      switch (extension) {
        case '.jpg':
        case '.jpeg':
          return 'image/jpeg';
        case '.png':
          return 'image/png';
        case '.pdf':
          return 'application/pdf';
        case '.doc':
        case '.docx':
          return 'application/msword';
        default:
          return 'application/octet-stream';
      }
    }

    Future<ChatMessageAttachment> _uploadAttachment(
        PlatformFile file, String chatId) async {
      try {
        final fileExtension = path.extension(file.name).toLowerCase();
        final isImage = ['.jpg', '.jpeg', '.png'].contains(fileExtension);

        final storageRef = FirebaseStorage.instance
            .ref()
            .child('chats')
            .child(chatId)
            .child('${DateTime.now().millisecondsSinceEpoch}_${file.name}');

        UploadTask uploadTask;
        if (isWeb()) {
          if (file.bytes == null || file.bytes!.isEmpty) {
            throw Exception('No file data available');
          }
          uploadTask = storageRef.putData(
            file.bytes!,
            SettableMetadata(contentType: _getContentType(fileExtension)),
          );
        } else {
          if (file.path == null) {
            throw Exception('No file path available');
          }
          uploadTask = storageRef.putFile(
            File(file.path!),
            SettableMetadata(contentType: _getContentType(fileExtension)),
          );
        }

        final snapshot = await uploadTask;
        final downloadUrl = await snapshot.ref.getDownloadURL();

        return ChatMessageAttachment(
          url: downloadUrl,
          thumbnailUrl: isImage ? downloadUrl : null,
          type: isImage ? 'image' : 'file',
          name: isImage ? '' : file.name,
        );
      } catch (e) {
        printL('Error uploading file ${file.name}: $e');
        rethrow;
      }
    }

    void onViewOnceMessage(ChatMessageEntity message) {
      final completer = Completer<void>();
      store.dispatch(ViewOnceMessageRequest(
        completer: completer,
        chatId: message.chatId,
        messageId: message.messageId,
        userId: getLoggedInUserId(store),
      ));
    }

    Future<void> _sendMessage(
        BuildContext context, String content, List<PlatformFile> files,
        {bool isViewOnce = false}) async {
      if (chatId == null || (content.isEmpty && files.isEmpty)) return;
      try {
        final attachmentFutures =
            files.map((file) => _uploadAttachment(file, chatId));
        final attachments = await Future.wait(attachmentFutures);

        final message = ChatMessageEntity(
          messageId: 'msg_${DateTime.now().millisecondsSinceEpoch}',
          chatId: chatId,
          content: content,
          senderId: getLoggedInUserId(store),
          replyTo: chat.participants
              .firstWhere((p) => p.userId != getLoggedInUserId(store))
              .userId,
          attachments: BuiltList<ChatMessageAttachment>(attachments),
          isViewOnce: isViewOnce,
        );

        printL(
            'isonceMessage == ${message.isViewOnce} from request == $isViewOnce}');
        final completer = Completer<void>();
        store.dispatch(SendMessageRequest(
          message: message,
          completer: completer,
        ));

        await completer.future;
      } catch (e) {
        printL('Error sending message: $e');
      }
    }

    return MessageScreenVM(
      state: state,
      chat: chat,
      messages: state.chatState.messageState.map.values
          .where((msg) => msg.chatId == chatId)
          .toList()
        ..sort((a, b) => a.createdAt.compareTo(b.createdAt)),
      streamedMessages: state.chatState.messageState.streamedMessages.toList(),
      messageStream: state.chatState.messageState.messageStream,
      currentUserId: getLoggedInUserId(store),
      onLoad: ({bool isRefresh = false}) => _loadMessages(isRefresh: isRefresh),
      onViewOnceMessage: (message) => onViewOnceMessage(message),
      onSendMessage: (context, content, files, isViewOnce) =>
          _sendMessage(context, content, files, isViewOnce: isViewOnce),
      onBackPressed: () {
        store.dispatch(UpdateCurrentRoute(ChatScreen.route));
      },
    );
  }
}
