import 'dart:async';
import 'dart:core';
import 'package:built_collection/built_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/data/repositories/clients/firebase_client.dart';
import 'package:flutter_boilerplate/data/repositories/firebase_repository.dart';
import 'package:flutter_boilerplate/data/models/serializers.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/project_config.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/chat/chat_actions.dart';
import 'package:flutter_boilerplate/redux/ui/ui_actions.dart';
import 'package:flutter_boilerplate/services/session_managment_service.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'package:flutter_boilerplate/ui/app/dialogs/error_dialog.dart';
import 'package:flutter_boilerplate/ui/chat/message_view/message_screen.dart';
import 'package:flutter_redux/flutter_redux.dart';

class ChatRepository {
  const ChatRepository();

  static final FirebaseRepository _firebaseRepository =
      FirebaseRepository('chats');
  static final FirebaseRepository userRepo =
      FirebaseRepository(ProjectConfig.usersProfileCollectionName);
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<ChatEntity> loadItem(String entityId) async {
    final data = await _firebaseRepository.getItem(entityId);

    if (data != null) {
      return serializers.deserializeWith(ChatEntity.serializer, data)!;
    }
    throw Exception('Chat with ID $entityId not found');
  }

  Future<BuiltList<ChatEntity>> loadList(Credentials credentials) async {
    final response = await _firebaseRepository.getList();
    final dataList = response['data'] as List<Map<String, dynamic>>;
    final chats = dataList
        .map(
            (data) => serializers.deserializeWith(ChatEntity.serializer, data)!)
        .toList();

    return BuiltList<ChatEntity>(chats);
  }

  Future<ProfileEntity?> fetchChatParticipantProfile(String senderId) async {
    final data = await userRepo.getItem(senderId);
    if (data != null) {
      return ProfileMapper.dbToEntity(data, senderId);
    }
    logError(
        'Error in method:fetchChatParticipantProfile Failed to fetch sender profile,senderProfileId: $senderId');
    return null;
  }

  Future<Map<String, dynamic>> loadListWithPagination(
      {DocumentSnapshot? lastDocument,
      int limit = 10,
      ChatFilter? filter,
      String? userId,
      bool? chatCount = false}) async {
    Query query = _firestore.collection('chats');

    query = query.where('participantsIds', arrayContains: userId);

    query = query.orderBy('lastActive', descending: true);

    if (chatCount != null && chatCount) {
      query = query.where('is_deleted', isEqualTo: false);
    } else {
      if (filter != null) {
        final queryParams = filter.toFirebaseQuery();
        final filters = queryParams['filters'] as Map<String, dynamic>;

        if (filter.stateFilter == EntityState.archived) {
          query = query
              .where('is_deleted', isEqualTo: false)
              .where('archived_at', isGreaterThan: 0);
        } else if (filter.stateFilter == EntityState.deleted) {
          query = query.where('is_deleted', isEqualTo: true);
        } else {
          query = query
              .where('is_deleted', isEqualTo: false)
              .where('archived_at', isEqualTo: 0);
        }

        if (filters['title'] != null) {
          query = query.where('title',
              isGreaterThanOrEqualTo: filters['title'],
              isLessThanOrEqualTo: filters['title'] + '\uf8ff');
        }
      }
    }

    if (limit > 0) {
      query = query.limit(limit);
    }

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    final response = await _firebaseRepository.getList(
      customQuery: query,
      lastDocument: lastDocument,
      limit: limit,
    );

    final dataList = response['data'] as List<Map<String, dynamic>>;
    final lastDocumentSnapshot = response['lastDocument'] as DocumentSnapshot?;

    final chats = dataList
        .map(
            (data) => serializers.deserializeWith(ChatEntity.serializer, data)!)
        .toList();

    return {
      'chats': BuiltList<ChatEntity>(chats),
      'lastDocument': lastDocumentSnapshot,
    };
  }

  static Future<Map<String, dynamic>?> getChatByEmails(
      String userEmail1, String userEmail2) async {
    try {
      final user1Doc = await _firestore
          .collection(ProjectConfig.usersProfileCollectionName)
          .where('email', isEqualTo: userEmail1)
          .limit(1)
          .get();

      final user2Doc = await _firestore
          .collection(ProjectConfig.usersProfileCollectionName)
          .where('email', isEqualTo: userEmail2)
          .limit(1)
          .get();

      if (user1Doc.docs.isEmpty || user2Doc.docs.isEmpty) {
        return null;
      }

      final user1Id = user1Doc.docs.first.id;
      final user2Id = user2Doc.docs.first.id;

      final QuerySnapshot snapshot = await _firestore
          .collection('chats')
          .where('participantsIds', arrayContains: user1Id)
          .get();

      if (snapshot.docs.isEmpty) {
        return null;
      }

      for (var doc in snapshot.docs) {
        final List<dynamic> participantsIds = doc.get('participantsIds');
        if (participantsIds.contains(user1Id) &&
            participantsIds.contains(user2Id)) {
          return doc.data() as Map<String, dynamic>;
        }
      }
      return null;
    } catch (e) {
      logError(' Error getting chat: $e');
      return null;
    }
  }

  static Future<void> createOrOpenChat(
      BuildContext context, String targetEmail) async {
    final store = StoreProvider.of<AppState>(context);
    final firebaseClient = FirebaseClient();
    final loggedInUserId = getLoggedInUserId(store);

    final existingChat =
        await getChatByEmails(store.state.authState.email, targetEmail);

    if (existingChat != null) {
      final chat =
          serializers.deserializeWith(ChatEntity.serializer, existingChat);
      if (!store.state.chatState.list.contains(chat!.id)) {
        store.dispatch(AddChatSuccess(chat));
      }
      if (store.state.chatState.map.containsKey(chat.id)) {
        store.dispatch(ViewMessage(chatId: chat.id));
      } else {
        store.dispatch(AddChatSuccess(chat));
        store.dispatch(ViewMessage(chatId: chat.id));
      }
      return;
    }

    Map<String, dynamic>? user =
        await firebaseClient.getUserByEmail(targetEmail);

    if (user == null) {
      showDialog<ErrorDialog>(
        context: context,
        builder: (BuildContext context) => ErrorDialog('User not found'),
      );
      return;
    }

    String currentUserThumbnail = '';
    final currentUserProfile = store.state.profileState.loggedInUserProfile;
    if (currentUserProfile.dynamicFields.containsKey('images') &&
        currentUserProfile.dynamicFields['images'] is List &&
        (currentUserProfile.dynamicFields['images'] as List).isNotEmpty) {
      final images = currentUserProfile.dynamicFields['images'] as List;
      if (images.first is Map && (images.first as Map).containsKey('url')) {
        currentUserThumbnail = (images.first as Map)['url'] as String;
      }
    }

    String targetUserThumbnail = '';
    if (user.containsKey('dynamicFields') &&
        user['dynamicFields'] is Map &&
        (user['dynamicFields'] as Map).containsKey('images') &&
        (user['dynamicFields']['images'] is List) &&
        (user['dynamicFields']['images'] as List).isNotEmpty) {
      final images = user['dynamicFields']['images'] as List;
      if (images.first is Map && (images.first as Map).containsKey('url')) {
        targetUserThumbnail = (images.first as Map)['url'] as String;
      }
    }

    final initialParticipants = [
      ChatParticipantEntity(
        userId: loggedInUserId,
        userName: store.state.profileState.loggedInUserProfile.name.isNotEmpty
            ? store.state.profileState.loggedInUserProfile.name
            : store.state.authState.email.isNotEmpty
                ? store.state.authState.email.split('@')[0]
                : kParticipantName,
        userThumbnail: currentUserThumbnail,
      ),
      ChatParticipantEntity(
        userId: user['id'],
        userName:
            user[DynamicFieldsConstants.name] ?? targetEmail.split('@')[0],
        userThumbnail: targetUserThumbnail,
      ),
    ];
    final initialParticipantsIds = [loggedInUserId, user['id']];

    final chat = ChatEntity();

    final updatedChat = chat.rebuild((b) => b
      ..isGroupChat = chat.groupName.isNotEmpty
      ..status = ChatStatus.inProgress
      ..centityType = CEntityType.user
      ..centityId = loggedInUserId
      ..lastActive = DateTime.now().millisecondsSinceEpoch
      ..unreadCounts.addAll({
        loggedInUserId: 0,
        user['id']: 0,
      })
      ..createdUserId = loggedInUserId
      ..isChanged = false
      ..participantsIds =
          ListBuilder<String>({...initialParticipantsIds}.toList())
      ..participants.replace((chat.participants.toBuilder()
            ..addAll(initialParticipants))
          .build()));

    final Completer<ChatEntity> completer = Completer<ChatEntity>();
    store.dispatch(SaveChatRequest(
        completer: completer,
        chat: updatedChat,
        participants: initialParticipants));

    try {
      final savedChat = await completer.future;
      if (!store.state.chatState.map.containsKey(savedChat.id)) {
        store.dispatch(AddChatSuccess(savedChat));
      }
      final currentChatId = store.state.chatUIState.selectedId;
      if (currentChatId != savedChat.id) {
        if (store.state.prefState.isMobile) {
          store.dispatch(UpdateCurrentRoute(MessageScreen.route));
          Navigator.of(context).pushNamed(MessageScreen.route);
        } else {
          viewEntity(entity: savedChat);
        }
      }
    } catch (error) {
      showDialog<ErrorDialog>(
          context: context,
          builder: (BuildContext context) => ErrorDialog(error));
    }
  }

  Future<List<ChatEntity>> bulkAction(
      Credentials credentials, List<String> ids, EntityAction action) async {
    if (action == EntityAction.delete) {
      for (var id in ids) {
        final data = {'is_deleted': true};
        await _firebaseRepository.updateItem(id, data);
      }
    } else if (action == EntityAction.archive) {
      final int currentTime = DateTime.now().millisecondsSinceEpoch;
      for (var id in ids) {
        final data = {'archived_at': currentTime};
        await _firebaseRepository.updateItem(id, data);
      }
    } else if (action == EntityAction.restore) {
      for (var id in ids) {
        final data = {'archived_at': 0, 'is_deleted': false};
        await _firebaseRepository.updateItem(id, data);
      }
    }

    return ids.map((id) => ChatEntity(id: id)).toList();
  }

  Future<ChatEntity> saveData(
    Credentials credentials,
    ChatEntity chat,
    List<ChatParticipantEntity>? participants,
  ) async {
    final data = serializers.serializeWith(ChatEntity.serializer, chat)
        as Map<String, dynamic>;

    if (chat.id.isNotEmpty && chat.isNew ||
        !(await _firebaseRepository.itemExists(chat.id))) {
      final newId = _firestore.collection('chats').doc().id;
      data['id'] = newId;

      await _firebaseRepository.saveItem(newId, data);
      if (participants != null) {
        final batch = _firestore.batch();
        for (var participant in participants) {
          final participantData = serializers.serializeWith(
            ChatParticipantEntity.serializer,
            participant,
          ) as Map<String, dynamic>;

          final participantRef = _firestore
              .collection('chats')
              .doc(newId)
              .collection('participants')
              .doc();

          participantData['participantId'] = participantRef.id;
          batch.set(participantRef, participantData);
        }
        await batch.commit();
      }
      return chat.rebuild((b) => b..id = newId);
    } else {
      await _firebaseRepository.updateItem(chat.id, data);
      return chat;
    }
  }

  Future<Map<String, dynamic>> loadMessages(
    Credentials credentials,
    String chatId, {
    DocumentSnapshot? lastDocument,
    int limit = 20,
  }) async {
    final response = await _firebaseRepository.getMessages(
      chatId,
      lastDocument: lastDocument,
      limit: limit,
    );

    final dataList = response['data'] as List<Map<String, dynamic>>;
    final lastDocumentSnapshot = response['lastDocument'] as DocumentSnapshot?;
    final messages = dataList
        .map((data) =>
            serializers.deserializeWith(ChatMessageEntity.serializer, data)!)
        .toList();

    return {
      'messages': BuiltList<ChatMessageEntity>(messages),
      'lastDocument': lastDocumentSnapshot
    };
  }

  Stream<List<ChatMessageEntity>> watchMessages(String chatId) {
    final lastMessageTime = DateTime.now().millisecondsSinceEpoch;

    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .where('createdAt', isGreaterThan: lastMessageTime)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              data['messageId'] = doc.id;
              return serializers.deserializeWith(
                  ChatMessageEntity.serializer, data)!;
            }).toList());
  }

  Future<ChatMessageEntity> saveMessage(
    Credentials credentials,
    ChatMessageEntity message,
  ) async {
    final data = serializers.serializeWith(
        ChatMessageEntity.serializer, message) as Map<String, dynamic>;

    final responseData = await _firebaseRepository.saveMessage(
      message.chatId,
      data,
    );

    return serializers.deserializeWith(
        ChatMessageEntity.serializer, responseData)!;
  }

  Future<void> markMessagesAsRead(
    Credentials credentials,
    String chatId,
    List<String> messageIds,
  ) async {
    await _firebaseRepository.updateMessageStatus(
      chatId,
      messageIds,
      MessageStatus.read.toString(),
    );
  }

  Future<void> deleteMessage(
    Credentials credentials,
    String chatId,
    String messageId,
  ) async {
    await _firebaseRepository.updateMessageStatus(
      chatId,
      [messageId],
      MessageStatus.deleted.toString(),
    );
  }

  Future<void> markMessageAsViewed(
    Credentials credentials,
    String chatId,
    String messageId,
    String userId,
  ) async {
    final messageRef = _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId);

    final doc = await messageRef.get();
    if (!doc.exists) {
      throw Exception('Message not found');
    }

    final data = doc.data() as Map<String, dynamic>;
    final viewedBy = (data['viewedBy'] as Map<String, dynamic>?) ?? {};

    if (viewedBy[userId] == true) {
      return;
    }

    await messageRef.update({
      'viewedBy.$userId': true,
    });
  }
}
