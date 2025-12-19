import 'package:built_value/built_value.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/data/models/chat/last_message_modal.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'package:flutter_boilerplate/utils/formatting.dart';
import 'package:flutter_boilerplate/utils/strings.dart';

part 'chat_model.g.dart';

abstract class ChatMessageEntity
    implements Built<ChatMessageEntity, ChatMessageEntityBuilder> {
  factory ChatMessageEntity({
    String? messageId,
    String? chatId,
    String? senderId,
    String? content,
    String? replyTo,
    bool? isViewOnce,
    MessageStatus? status,
    BuiltList<ChatMessageAttachment>? attachments,
    BuiltMap<String, bool>? viewedBy,
  }) {
    return _$ChatMessageEntity._(
      messageId: messageId ?? BaseEntity.nextId,
      chatId: chatId ?? '',
      senderId: senderId ?? '',
      content: content ?? '',
      replyTo: replyTo ?? '',
      status: status ?? MessageStatus.delivered,
      attachments: attachments ?? BuiltList<ChatMessageAttachment>(),
      createdAt: DateTime.now().millisecondsSinceEpoch,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
      isViewOnce: isViewOnce ?? false,
      viewedBy: BuiltMap<String, bool>(),
    );
  }

  ChatMessageEntity._();

  @override
  @memoized
  int get hashCode;

  String get messageId;
  String get chatId;
  String get senderId;
  String get content;
  String get replyTo;
  MessageStatus get status;
  BuiltList<ChatMessageAttachment> get attachments;
  int get createdAt;
  int get updatedAt;
  bool get isViewOnce;
  BuiltMap<String, bool> get viewedBy;

  DateTime get createdAtDate => DateTime.fromMillisecondsSinceEpoch(createdAt);
  DateTime get updatedAtDate => DateTime.fromMillisecondsSinceEpoch(updatedAt);

  static void _initializeBuilder(ChatMessageEntityBuilder builder) => builder
    ..messageId = BaseEntity.nextId
    ..chatId = ''
    ..senderId = ''
    ..content = ''
    ..replyTo = ''
    ..isViewOnce = false
    ..status = MessageStatus.delivered
    ..attachments.replace(BuiltList<ChatMessageAttachment>())
    ..createdAt = DateTime.now().millisecondsSinceEpoch
    ..updatedAt = DateTime.now().millisecondsSinceEpoch;

  static Serializer<ChatMessageEntity> get serializer =>
      _$chatMessageEntitySerializer;
}

abstract class ChatMessageAttachment
    implements Built<ChatMessageAttachment, ChatMessageAttachmentBuilder> {
  factory ChatMessageAttachment({
    String? url,
    String? thumbnailUrl,
    String? type,
    String? name,
  }) {
    return _$ChatMessageAttachment._(
      url: url ?? '',
      thumbnailUrl: thumbnailUrl ?? '',
      type: type ?? '',
      name: name ?? '',
    );
  }

  ChatMessageAttachment._();

  @override
  @memoized
  int get hashCode;

  String get url;
  String get thumbnailUrl;
  String get type;
  String get name;

  static void _initializeBuilder(ChatMessageAttachmentBuilder builder) =>
      builder
        ..url = ''
        ..thumbnailUrl = ''
        ..type = ''
        ..name = '';

  static Serializer<ChatMessageAttachment> get serializer =>
      _$chatMessageAttachmentSerializer;
}

abstract class ChatFilter implements Built<ChatFilter, ChatFilterBuilder> {
  factory ChatFilter() {
    return _$ChatFilter._(
      searchTerm: '',
      stateFilter: EntityState.active,
      sortField: ChatFields.lastMessage,
      sortAscending: true,
      limit: kChatLoadLimit,
    );
  }

  ChatFilter._();

  @override
  @memoized
  int get hashCode;

  String get searchTerm;
  EntityState get stateFilter;
  String get sortField;
  bool get sortAscending;
  int get limit;

  Map<String, dynamic> toFirebaseQuery() {
    final Map<String, dynamic> filters = {};

    if (searchTerm.isNotEmpty) {
      filters['title'] = searchTerm.toLowerCase();
    }

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

    return {
      'filters': filters,
      'sort_field': sortField,
      'sort_ascending': sortAscending,
      'limit': limit
    };
  }

  static Serializer<ChatFilter> get serializer => _$chatFilterSerializer;
}

abstract class ChatListResponse
    implements Built<ChatListResponse, ChatListResponseBuilder> {
  factory ChatListResponse([void Function(ChatListResponseBuilder) updates]) =
      _$ChatListResponse;
  ChatListResponse._();

  @override
  @memoized
  int get hashCode;

  BuiltList<ChatEntity> get data;

  static Serializer<ChatListResponse> get serializer =>
      _$chatListResponseSerializer;
}

abstract class ChatItemResponse
    implements Built<ChatItemResponse, ChatItemResponseBuilder> {
  factory ChatItemResponse([void Function(ChatItemResponseBuilder) updates]) =
      _$ChatItemResponse;
  ChatItemResponse._();

  @override
  @memoized
  int get hashCode;

  ChatEntity get data;

  static Serializer<ChatItemResponse> get serializer =>
      _$chatItemResponseSerializer;
}

class ChatFields {
  static const String isGroupChat = 'isGroupChat';
  static const String groupName = 'groupName';
  static const String status = 'status';
  static const String centityType = 'centityType';
  static const String centityId = 'centityId';
  static const String groupThumbnail = 'groupThumbnail';
  static const String lastMessage = 'lastMessage';
  static const String lastActive = 'lastActive';
  static const String unreadCount = 'unreadCount';
}

abstract class ChatEntity extends Object
    with BaseEntity
    implements Built<ChatEntity, ChatEntityBuilder> {
  factory ChatEntity({String? id, AppState? state}) {
    return _$ChatEntity._(
      id: id ?? BaseEntity.nextId,
      isChanged: false,
      isDeleted: false,
      createdAt: 0,
      updatedAt: 0,
      createdUserId: '',
      assignedUserId: '',
      archivedAt: 0,
      isGroupChat: false,
      groupName: '',
      status: ChatStatus.inProgress,
      centityType: CEntityType.none,
      centityId: '',
      groupThumbnail: '',
      lastMessage: LastMessageEntity(),
      lastActive: DateTime.now().millisecondsSinceEpoch,
      unreadCounts: BuiltMap<String, int>(),
      participantsIds: BuiltList<String>(),
      participants: BuiltList<ChatParticipantEntity>(),
    );
  }

  ChatEntity._();

  @override
  @memoized
  int get hashCode;

  bool get isGroupChat;
  String get groupName;
  ChatStatus get status;
  CEntityType get centityType;
  String get centityId;
  String get groupThumbnail;
  LastMessageEntity get lastMessage;
  int get lastActive;
  BuiltMap<String, int> get unreadCounts;
  BuiltList<String> get participantsIds;
  BuiltList<ChatParticipantEntity> get participants;

  int getUnreadCount(String userId) => unreadCounts[userId] ?? 0;

  int getTotalUnreadCount(String currentUserId) =>
      getUnreadCount(currentUserId);

  DateTime get lastActiveDate =>
      DateTime.fromMillisecondsSinceEpoch(lastActive);

  @override
  EntityType get entityType => EntityType.chat;

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

  int compareTo(ChatEntity chat, String sortField, bool sortAscending) {
    int response = 0;
    final chatA = sortAscending ? this : chat;
    final chatB = sortAscending ? chat : this;

    switch (sortField) {
      case ChatFields.isGroupChat:
        response = chatA.isGroupChat
            .toString()
            .compareTo(chatB.isGroupChat.toString());
        break;
      case ChatFields.groupName:
        response = chatA.groupName.compareTo(chatB.groupName);
        break;
      case ChatFields.status:
        response = chatA.status.index.compareTo(chatB.status.index);
        break;
      case ChatFields.centityType:
        response = chatA.centityType.index.compareTo(chatB.centityType.index);
        break;
      case ChatFields.centityId:
        response = chatA.centityId.compareTo(chatB.centityId);
        break;
      case ChatFields.groupThumbnail:
        response = chatA.groupThumbnail.compareTo(chatB.groupThumbnail);
        break;
      case ChatFields.lastActive:
        response = chatA.lastActive.compareTo(chatB.lastActive);
        break;
      default:
    logError('sort by chat.$sortField is not implemented');
        break;
    }

    if (response == 0) {
      return chatA.groupName.compareTo(chatB.groupName);
    } else {
      return response;
    }
  }

  @override
  bool matchesFilter(String? filter) {
    return matchesStrings(
      haystacks: [
        isGroupChat.toString(),
        groupName,
        status.toString(),
        centityType.toString(),
        centityId,
        groupThumbnail,
        lastActive.toString(),
      ],
      needle: filter,
    );
  }

  @override
  String? matchesFilterValue(String? filter) {
    return matchesStringsValue(
      haystacks: [
        isGroupChat.toString(),
        groupName,
        status.toString(),
        centityType.toString(),
        centityId,
        groupThumbnail,
        lastActive.toString(),
      ],
      needle: filter,
    )!;
  }

  @override
  String get listDisplayName => groupName;

  @override
  double get listDisplayAmount => 0;

  @override
  FormatNumberType get listDisplayAmountType => FormatNumberType.int;

  static Serializer<ChatEntity> get serializer => _$chatEntitySerializer;
}

abstract class ChatParticipantEntity
    implements Built<ChatParticipantEntity, ChatParticipantEntityBuilder> {
  factory ChatParticipantEntity({
    String? userId,
    String? userName,
    String? userThumbnail,
    ParticipantRole? role,
    int? addedAt,
  }) {
    return _$ChatParticipantEntity._(
      userId: userId ?? '',
      userName: userName ?? '',
      userThumbnail: userThumbnail ?? '',
      role: role ?? ParticipantRole.member,
      addedAt: addedAt ?? DateTime.now().millisecondsSinceEpoch,
    );
  }

  ChatParticipantEntity._();

  @override
  @memoized
  int get hashCode;

  String get userId;
  String get userName;
  String get userThumbnail;
  ParticipantRole get role;
  int get addedAt;

  DateTime get addedAtDate => DateTime.fromMillisecondsSinceEpoch(addedAt);

  static void _initializeBuilder(ChatParticipantEntityBuilder builder) =>
      builder
        ..userId = ''
        ..userName = ''
        ..userThumbnail = ''
        ..role = ParticipantRole.member
        ..addedAt = DateTime.now().millisecondsSinceEpoch;

  static Serializer<ChatParticipantEntity> get serializer =>
      _$chatParticipantEntitySerializer;
}
