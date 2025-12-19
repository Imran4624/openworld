// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<ChatMessageEntity> _$chatMessageEntitySerializer =
    new _$ChatMessageEntitySerializer();
Serializer<ChatMessageAttachment> _$chatMessageAttachmentSerializer =
    new _$ChatMessageAttachmentSerializer();
Serializer<ChatFilter> _$chatFilterSerializer = new _$ChatFilterSerializer();
Serializer<ChatListResponse> _$chatListResponseSerializer =
    new _$ChatListResponseSerializer();
Serializer<ChatItemResponse> _$chatItemResponseSerializer =
    new _$ChatItemResponseSerializer();
Serializer<ChatEntity> _$chatEntitySerializer = new _$ChatEntitySerializer();
Serializer<ChatParticipantEntity> _$chatParticipantEntitySerializer =
    new _$ChatParticipantEntitySerializer();

class _$ChatMessageEntitySerializer
    implements StructuredSerializer<ChatMessageEntity> {
  @override
  final Iterable<Type> types = const [ChatMessageEntity, _$ChatMessageEntity];
  @override
  final String wireName = 'ChatMessageEntity';

  @override
  Iterable<Object?> serialize(Serializers serializers, ChatMessageEntity object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'messageId',
      serializers.serialize(object.messageId,
          specifiedType: const FullType(String)),
      'chatId',
      serializers.serialize(object.chatId,
          specifiedType: const FullType(String)),
      'senderId',
      serializers.serialize(object.senderId,
          specifiedType: const FullType(String)),
      'content',
      serializers.serialize(object.content,
          specifiedType: const FullType(String)),
      'replyTo',
      serializers.serialize(object.replyTo,
          specifiedType: const FullType(String)),
      'status',
      serializers.serialize(object.status,
          specifiedType: const FullType(MessageStatus)),
      'attachments',
      serializers.serialize(object.attachments,
          specifiedType: const FullType(
              BuiltList, const [const FullType(ChatMessageAttachment)])),
      'createdAt',
      serializers.serialize(object.createdAt,
          specifiedType: const FullType(int)),
      'updatedAt',
      serializers.serialize(object.updatedAt,
          specifiedType: const FullType(int)),
      'isViewOnce',
      serializers.serialize(object.isViewOnce,
          specifiedType: const FullType(bool)),
      'viewedBy',
      serializers.serialize(object.viewedBy,
          specifiedType: const FullType(
              BuiltMap, const [const FullType(String), const FullType(bool)])),
    ];

    return result;
  }

  @override
  ChatMessageEntity deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ChatMessageEntityBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'messageId':
          result.messageId = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'chatId':
          result.chatId = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'senderId':
          result.senderId = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'content':
          result.content = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'replyTo':
          result.replyTo = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'status':
          result.status = serializers.deserialize(value,
              specifiedType: const FullType(MessageStatus))! as MessageStatus;
          break;
        case 'attachments':
          result.attachments.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltList, const [
                const FullType(ChatMessageAttachment)
              ]))! as BuiltList<Object?>);
          break;
        case 'createdAt':
          result.createdAt = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'updatedAt':
          result.updatedAt = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'isViewOnce':
          result.isViewOnce = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
        case 'viewedBy':
          result.viewedBy.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltMap,
                  const [const FullType(String), const FullType(bool)]))!);
          break;
      }
    }

    return result.build();
  }
}

class _$ChatMessageAttachmentSerializer
    implements StructuredSerializer<ChatMessageAttachment> {
  @override
  final Iterable<Type> types = const [
    ChatMessageAttachment,
    _$ChatMessageAttachment
  ];
  @override
  final String wireName = 'ChatMessageAttachment';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, ChatMessageAttachment object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'url',
      serializers.serialize(object.url, specifiedType: const FullType(String)),
      'thumbnailUrl',
      serializers.serialize(object.thumbnailUrl,
          specifiedType: const FullType(String)),
      'type',
      serializers.serialize(object.type, specifiedType: const FullType(String)),
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  ChatMessageAttachment deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ChatMessageAttachmentBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'url':
          result.url = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'thumbnailUrl':
          result.thumbnailUrl = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'type':
          result.type = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$ChatFilterSerializer implements StructuredSerializer<ChatFilter> {
  @override
  final Iterable<Type> types = const [ChatFilter, _$ChatFilter];
  @override
  final String wireName = 'ChatFilter';

  @override
  Iterable<Object?> serialize(Serializers serializers, ChatFilter object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'searchTerm',
      serializers.serialize(object.searchTerm,
          specifiedType: const FullType(String)),
      'stateFilter',
      serializers.serialize(object.stateFilter,
          specifiedType: const FullType(EntityState)),
      'sortField',
      serializers.serialize(object.sortField,
          specifiedType: const FullType(String)),
      'sortAscending',
      serializers.serialize(object.sortAscending,
          specifiedType: const FullType(bool)),
      'limit',
      serializers.serialize(object.limit, specifiedType: const FullType(int)),
    ];

    return result;
  }

  @override
  ChatFilter deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ChatFilterBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'searchTerm':
          result.searchTerm = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'stateFilter':
          result.stateFilter = serializers.deserialize(value,
              specifiedType: const FullType(EntityState))! as EntityState;
          break;
        case 'sortField':
          result.sortField = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'sortAscending':
          result.sortAscending = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
        case 'limit':
          result.limit = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
      }
    }

    return result.build();
  }
}

class _$ChatListResponseSerializer
    implements StructuredSerializer<ChatListResponse> {
  @override
  final Iterable<Type> types = const [ChatListResponse, _$ChatListResponse];
  @override
  final String wireName = 'ChatListResponse';

  @override
  Iterable<Object?> serialize(Serializers serializers, ChatListResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'data',
      serializers.serialize(object.data,
          specifiedType:
              const FullType(BuiltList, const [const FullType(ChatEntity)])),
    ];

    return result;
  }

  @override
  ChatListResponse deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ChatListResponseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'data':
          result.data.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(ChatEntity)]))!
              as BuiltList<Object?>);
          break;
      }
    }

    return result.build();
  }
}

class _$ChatItemResponseSerializer
    implements StructuredSerializer<ChatItemResponse> {
  @override
  final Iterable<Type> types = const [ChatItemResponse, _$ChatItemResponse];
  @override
  final String wireName = 'ChatItemResponse';

  @override
  Iterable<Object?> serialize(Serializers serializers, ChatItemResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'data',
      serializers.serialize(object.data,
          specifiedType: const FullType(ChatEntity)),
    ];

    return result;
  }

  @override
  ChatItemResponse deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ChatItemResponseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'data':
          result.data.replace(serializers.deserialize(value,
              specifiedType: const FullType(ChatEntity))! as ChatEntity);
          break;
      }
    }

    return result.build();
  }
}

class _$ChatEntitySerializer implements StructuredSerializer<ChatEntity> {
  @override
  final Iterable<Type> types = const [ChatEntity, _$ChatEntity];
  @override
  final String wireName = 'ChatEntity';

  @override
  Iterable<Object?> serialize(Serializers serializers, ChatEntity object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'isGroupChat',
      serializers.serialize(object.isGroupChat,
          specifiedType: const FullType(bool)),
      'groupName',
      serializers.serialize(object.groupName,
          specifiedType: const FullType(String)),
      'status',
      serializers.serialize(object.status,
          specifiedType: const FullType(ChatStatus)),
      'centityType',
      serializers.serialize(object.centityType,
          specifiedType: const FullType(CEntityType)),
      'centityId',
      serializers.serialize(object.centityId,
          specifiedType: const FullType(String)),
      'groupThumbnail',
      serializers.serialize(object.groupThumbnail,
          specifiedType: const FullType(String)),
      'lastMessage',
      serializers.serialize(object.lastMessage,
          specifiedType: const FullType(LastMessageEntity)),
      'lastActive',
      serializers.serialize(object.lastActive,
          specifiedType: const FullType(int)),
      'unreadCounts',
      serializers.serialize(object.unreadCounts,
          specifiedType: const FullType(
              BuiltMap, const [const FullType(String), const FullType(int)])),
      'participantsIds',
      serializers.serialize(object.participantsIds,
          specifiedType:
              const FullType(BuiltList, const [const FullType(String)])),
      'participants',
      serializers.serialize(object.participants,
          specifiedType: const FullType(
              BuiltList, const [const FullType(ChatParticipantEntity)])),
      'created_at',
      serializers.serialize(object.createdAt,
          specifiedType: const FullType(int)),
      'updated_at',
      serializers.serialize(object.updatedAt,
          specifiedType: const FullType(int)),
      'archived_at',
      serializers.serialize(object.archivedAt,
          specifiedType: const FullType(int)),
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
    ];
    Object? value;
    value = object.isChanged;
    if (value != null) {
      result
        ..add('isChanged')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.isDeleted;
    if (value != null) {
      result
        ..add('is_deleted')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.isReported;
    if (value != null) {
      result
        ..add('reported')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.createdUserId;
    if (value != null) {
      result
        ..add('user_id')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.assignedUserId;
    if (value != null) {
      result
        ..add('assigned_user_id')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  ChatEntity deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ChatEntityBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'isGroupChat':
          result.isGroupChat = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
        case 'groupName':
          result.groupName = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'status':
          result.status = serializers.deserialize(value,
              specifiedType: const FullType(ChatStatus))! as ChatStatus;
          break;
        case 'centityType':
          result.centityType = serializers.deserialize(value,
              specifiedType: const FullType(CEntityType))! as CEntityType;
          break;
        case 'centityId':
          result.centityId = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'groupThumbnail':
          result.groupThumbnail = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'lastMessage':
          result.lastMessage.replace(serializers.deserialize(value,
                  specifiedType: const FullType(LastMessageEntity))!
              as LastMessageEntity);
          break;
        case 'lastActive':
          result.lastActive = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'unreadCounts':
          result.unreadCounts.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltMap,
                  const [const FullType(String), const FullType(int)]))!);
          break;
        case 'participantsIds':
          result.participantsIds.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(String)]))!
              as BuiltList<Object?>);
          break;
        case 'participants':
          result.participants.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltList, const [
                const FullType(ChatParticipantEntity)
              ]))! as BuiltList<Object?>);
          break;
        case 'isChanged':
          result.isChanged = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'created_at':
          result.createdAt = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'updated_at':
          result.updatedAt = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'archived_at':
          result.archivedAt = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'is_deleted':
          result.isDeleted = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'reported':
          result.isReported = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'user_id':
          result.createdUserId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'assigned_user_id':
          result.assignedUserId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$ChatParticipantEntitySerializer
    implements StructuredSerializer<ChatParticipantEntity> {
  @override
  final Iterable<Type> types = const [
    ChatParticipantEntity,
    _$ChatParticipantEntity
  ];
  @override
  final String wireName = 'ChatParticipantEntity';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, ChatParticipantEntity object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'userId',
      serializers.serialize(object.userId,
          specifiedType: const FullType(String)),
      'userName',
      serializers.serialize(object.userName,
          specifiedType: const FullType(String)),
      'userThumbnail',
      serializers.serialize(object.userThumbnail,
          specifiedType: const FullType(String)),
      'role',
      serializers.serialize(object.role,
          specifiedType: const FullType(ParticipantRole)),
      'addedAt',
      serializers.serialize(object.addedAt, specifiedType: const FullType(int)),
    ];

    return result;
  }

  @override
  ChatParticipantEntity deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ChatParticipantEntityBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'userId':
          result.userId = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'userName':
          result.userName = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'userThumbnail':
          result.userThumbnail = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'role':
          result.role = serializers.deserialize(value,
                  specifiedType: const FullType(ParticipantRole))!
              as ParticipantRole;
          break;
        case 'addedAt':
          result.addedAt = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
      }
    }

    return result.build();
  }
}

class _$ChatMessageEntity extends ChatMessageEntity {
  @override
  final String messageId;
  @override
  final String chatId;
  @override
  final String senderId;
  @override
  final String content;
  @override
  final String replyTo;
  @override
  final MessageStatus status;
  @override
  final BuiltList<ChatMessageAttachment> attachments;
  @override
  final int createdAt;
  @override
  final int updatedAt;
  @override
  final bool isViewOnce;
  @override
  final BuiltMap<String, bool> viewedBy;

  factory _$ChatMessageEntity(
          [void Function(ChatMessageEntityBuilder)? updates]) =>
      (new ChatMessageEntityBuilder()..update(updates))._build();

  _$ChatMessageEntity._(
      {required this.messageId,
      required this.chatId,
      required this.senderId,
      required this.content,
      required this.replyTo,
      required this.status,
      required this.attachments,
      required this.createdAt,
      required this.updatedAt,
      required this.isViewOnce,
      required this.viewedBy})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        messageId, r'ChatMessageEntity', 'messageId');
    BuiltValueNullFieldError.checkNotNull(
        chatId, r'ChatMessageEntity', 'chatId');
    BuiltValueNullFieldError.checkNotNull(
        senderId, r'ChatMessageEntity', 'senderId');
    BuiltValueNullFieldError.checkNotNull(
        content, r'ChatMessageEntity', 'content');
    BuiltValueNullFieldError.checkNotNull(
        replyTo, r'ChatMessageEntity', 'replyTo');
    BuiltValueNullFieldError.checkNotNull(
        status, r'ChatMessageEntity', 'status');
    BuiltValueNullFieldError.checkNotNull(
        attachments, r'ChatMessageEntity', 'attachments');
    BuiltValueNullFieldError.checkNotNull(
        createdAt, r'ChatMessageEntity', 'createdAt');
    BuiltValueNullFieldError.checkNotNull(
        updatedAt, r'ChatMessageEntity', 'updatedAt');
    BuiltValueNullFieldError.checkNotNull(
        isViewOnce, r'ChatMessageEntity', 'isViewOnce');
    BuiltValueNullFieldError.checkNotNull(
        viewedBy, r'ChatMessageEntity', 'viewedBy');
  }

  @override
  ChatMessageEntity rebuild(void Function(ChatMessageEntityBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatMessageEntityBuilder toBuilder() =>
      new ChatMessageEntityBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatMessageEntity &&
        messageId == other.messageId &&
        chatId == other.chatId &&
        senderId == other.senderId &&
        content == other.content &&
        replyTo == other.replyTo &&
        status == other.status &&
        attachments == other.attachments &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        isViewOnce == other.isViewOnce &&
        viewedBy == other.viewedBy;
  }

  int? __hashCode;
  @override
  int get hashCode {
    if (__hashCode != null) return __hashCode!;
    var _$hash = 0;
    _$hash = $jc(_$hash, messageId.hashCode);
    _$hash = $jc(_$hash, chatId.hashCode);
    _$hash = $jc(_$hash, senderId.hashCode);
    _$hash = $jc(_$hash, content.hashCode);
    _$hash = $jc(_$hash, replyTo.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, attachments.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, isViewOnce.hashCode);
    _$hash = $jc(_$hash, viewedBy.hashCode);
    _$hash = $jf(_$hash);
    return __hashCode ??= _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChatMessageEntity')
          ..add('messageId', messageId)
          ..add('chatId', chatId)
          ..add('senderId', senderId)
          ..add('content', content)
          ..add('replyTo', replyTo)
          ..add('status', status)
          ..add('attachments', attachments)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt)
          ..add('isViewOnce', isViewOnce)
          ..add('viewedBy', viewedBy))
        .toString();
  }
}

class ChatMessageEntityBuilder
    implements Builder<ChatMessageEntity, ChatMessageEntityBuilder> {
  _$ChatMessageEntity? _$v;

  String? _messageId;
  String? get messageId => _$this._messageId;
  set messageId(String? messageId) => _$this._messageId = messageId;

  String? _chatId;
  String? get chatId => _$this._chatId;
  set chatId(String? chatId) => _$this._chatId = chatId;

  String? _senderId;
  String? get senderId => _$this._senderId;
  set senderId(String? senderId) => _$this._senderId = senderId;

  String? _content;
  String? get content => _$this._content;
  set content(String? content) => _$this._content = content;

  String? _replyTo;
  String? get replyTo => _$this._replyTo;
  set replyTo(String? replyTo) => _$this._replyTo = replyTo;

  MessageStatus? _status;
  MessageStatus? get status => _$this._status;
  set status(MessageStatus? status) => _$this._status = status;

  ListBuilder<ChatMessageAttachment>? _attachments;
  ListBuilder<ChatMessageAttachment> get attachments =>
      _$this._attachments ??= new ListBuilder<ChatMessageAttachment>();
  set attachments(ListBuilder<ChatMessageAttachment>? attachments) =>
      _$this._attachments = attachments;

  int? _createdAt;
  int? get createdAt => _$this._createdAt;
  set createdAt(int? createdAt) => _$this._createdAt = createdAt;

  int? _updatedAt;
  int? get updatedAt => _$this._updatedAt;
  set updatedAt(int? updatedAt) => _$this._updatedAt = updatedAt;

  bool? _isViewOnce;
  bool? get isViewOnce => _$this._isViewOnce;
  set isViewOnce(bool? isViewOnce) => _$this._isViewOnce = isViewOnce;

  MapBuilder<String, bool>? _viewedBy;
  MapBuilder<String, bool> get viewedBy =>
      _$this._viewedBy ??= new MapBuilder<String, bool>();
  set viewedBy(MapBuilder<String, bool>? viewedBy) =>
      _$this._viewedBy = viewedBy;

  ChatMessageEntityBuilder() {
    ChatMessageEntity._initializeBuilder(this);
  }

  ChatMessageEntityBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _messageId = $v.messageId;
      _chatId = $v.chatId;
      _senderId = $v.senderId;
      _content = $v.content;
      _replyTo = $v.replyTo;
      _status = $v.status;
      _attachments = $v.attachments.toBuilder();
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _isViewOnce = $v.isViewOnce;
      _viewedBy = $v.viewedBy.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatMessageEntity other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ChatMessageEntity;
  }

  @override
  void update(void Function(ChatMessageEntityBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChatMessageEntity build() => _build();

  _$ChatMessageEntity _build() {
    _$ChatMessageEntity _$result;
    try {
      _$result = _$v ??
          new _$ChatMessageEntity._(
              messageId: BuiltValueNullFieldError.checkNotNull(
                  messageId, r'ChatMessageEntity', 'messageId'),
              chatId: BuiltValueNullFieldError.checkNotNull(
                  chatId, r'ChatMessageEntity', 'chatId'),
              senderId: BuiltValueNullFieldError.checkNotNull(
                  senderId, r'ChatMessageEntity', 'senderId'),
              content: BuiltValueNullFieldError.checkNotNull(
                  content, r'ChatMessageEntity', 'content'),
              replyTo: BuiltValueNullFieldError.checkNotNull(
                  replyTo, r'ChatMessageEntity', 'replyTo'),
              status: BuiltValueNullFieldError.checkNotNull(
                  status, r'ChatMessageEntity', 'status'),
              attachments: attachments.build(),
              createdAt: BuiltValueNullFieldError.checkNotNull(
                  createdAt, r'ChatMessageEntity', 'createdAt'),
              updatedAt: BuiltValueNullFieldError.checkNotNull(
                  updatedAt, r'ChatMessageEntity', 'updatedAt'),
              isViewOnce:
                  BuiltValueNullFieldError.checkNotNull(isViewOnce, r'ChatMessageEntity', 'isViewOnce'),
              viewedBy: viewedBy.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'attachments';
        attachments.build();

        _$failedField = 'viewedBy';
        viewedBy.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'ChatMessageEntity', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$ChatMessageAttachment extends ChatMessageAttachment {
  @override
  final String url;
  @override
  final String thumbnailUrl;
  @override
  final String type;
  @override
  final String name;

  factory _$ChatMessageAttachment(
          [void Function(ChatMessageAttachmentBuilder)? updates]) =>
      (new ChatMessageAttachmentBuilder()..update(updates))._build();

  _$ChatMessageAttachment._(
      {required this.url,
      required this.thumbnailUrl,
      required this.type,
      required this.name})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(url, r'ChatMessageAttachment', 'url');
    BuiltValueNullFieldError.checkNotNull(
        thumbnailUrl, r'ChatMessageAttachment', 'thumbnailUrl');
    BuiltValueNullFieldError.checkNotNull(
        type, r'ChatMessageAttachment', 'type');
    BuiltValueNullFieldError.checkNotNull(
        name, r'ChatMessageAttachment', 'name');
  }

  @override
  ChatMessageAttachment rebuild(
          void Function(ChatMessageAttachmentBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatMessageAttachmentBuilder toBuilder() =>
      new ChatMessageAttachmentBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatMessageAttachment &&
        url == other.url &&
        thumbnailUrl == other.thumbnailUrl &&
        type == other.type &&
        name == other.name;
  }

  int? __hashCode;
  @override
  int get hashCode {
    if (__hashCode != null) return __hashCode!;
    var _$hash = 0;
    _$hash = $jc(_$hash, url.hashCode);
    _$hash = $jc(_$hash, thumbnailUrl.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jf(_$hash);
    return __hashCode ??= _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChatMessageAttachment')
          ..add('url', url)
          ..add('thumbnailUrl', thumbnailUrl)
          ..add('type', type)
          ..add('name', name))
        .toString();
  }
}

class ChatMessageAttachmentBuilder
    implements Builder<ChatMessageAttachment, ChatMessageAttachmentBuilder> {
  _$ChatMessageAttachment? _$v;

  String? _url;
  String? get url => _$this._url;
  set url(String? url) => _$this._url = url;

  String? _thumbnailUrl;
  String? get thumbnailUrl => _$this._thumbnailUrl;
  set thumbnailUrl(String? thumbnailUrl) => _$this._thumbnailUrl = thumbnailUrl;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  ChatMessageAttachmentBuilder() {
    ChatMessageAttachment._initializeBuilder(this);
  }

  ChatMessageAttachmentBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _url = $v.url;
      _thumbnailUrl = $v.thumbnailUrl;
      _type = $v.type;
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatMessageAttachment other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ChatMessageAttachment;
  }

  @override
  void update(void Function(ChatMessageAttachmentBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChatMessageAttachment build() => _build();

  _$ChatMessageAttachment _build() {
    final _$result = _$v ??
        new _$ChatMessageAttachment._(
            url: BuiltValueNullFieldError.checkNotNull(
                url, r'ChatMessageAttachment', 'url'),
            thumbnailUrl: BuiltValueNullFieldError.checkNotNull(
                thumbnailUrl, r'ChatMessageAttachment', 'thumbnailUrl'),
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'ChatMessageAttachment', 'type'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'ChatMessageAttachment', 'name'));
    replace(_$result);
    return _$result;
  }
}

class _$ChatFilter extends ChatFilter {
  @override
  final String searchTerm;
  @override
  final EntityState stateFilter;
  @override
  final String sortField;
  @override
  final bool sortAscending;
  @override
  final int limit;

  factory _$ChatFilter([void Function(ChatFilterBuilder)? updates]) =>
      (new ChatFilterBuilder()..update(updates))._build();

  _$ChatFilter._(
      {required this.searchTerm,
      required this.stateFilter,
      required this.sortField,
      required this.sortAscending,
      required this.limit})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        searchTerm, r'ChatFilter', 'searchTerm');
    BuiltValueNullFieldError.checkNotNull(
        stateFilter, r'ChatFilter', 'stateFilter');
    BuiltValueNullFieldError.checkNotNull(
        sortField, r'ChatFilter', 'sortField');
    BuiltValueNullFieldError.checkNotNull(
        sortAscending, r'ChatFilter', 'sortAscending');
    BuiltValueNullFieldError.checkNotNull(limit, r'ChatFilter', 'limit');
  }

  @override
  ChatFilter rebuild(void Function(ChatFilterBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatFilterBuilder toBuilder() => new ChatFilterBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatFilter &&
        searchTerm == other.searchTerm &&
        stateFilter == other.stateFilter &&
        sortField == other.sortField &&
        sortAscending == other.sortAscending &&
        limit == other.limit;
  }

  int? __hashCode;
  @override
  int get hashCode {
    if (__hashCode != null) return __hashCode!;
    var _$hash = 0;
    _$hash = $jc(_$hash, searchTerm.hashCode);
    _$hash = $jc(_$hash, stateFilter.hashCode);
    _$hash = $jc(_$hash, sortField.hashCode);
    _$hash = $jc(_$hash, sortAscending.hashCode);
    _$hash = $jc(_$hash, limit.hashCode);
    _$hash = $jf(_$hash);
    return __hashCode ??= _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChatFilter')
          ..add('searchTerm', searchTerm)
          ..add('stateFilter', stateFilter)
          ..add('sortField', sortField)
          ..add('sortAscending', sortAscending)
          ..add('limit', limit))
        .toString();
  }
}

class ChatFilterBuilder implements Builder<ChatFilter, ChatFilterBuilder> {
  _$ChatFilter? _$v;

  String? _searchTerm;
  String? get searchTerm => _$this._searchTerm;
  set searchTerm(String? searchTerm) => _$this._searchTerm = searchTerm;

  EntityState? _stateFilter;
  EntityState? get stateFilter => _$this._stateFilter;
  set stateFilter(EntityState? stateFilter) =>
      _$this._stateFilter = stateFilter;

  String? _sortField;
  String? get sortField => _$this._sortField;
  set sortField(String? sortField) => _$this._sortField = sortField;

  bool? _sortAscending;
  bool? get sortAscending => _$this._sortAscending;
  set sortAscending(bool? sortAscending) =>
      _$this._sortAscending = sortAscending;

  int? _limit;
  int? get limit => _$this._limit;
  set limit(int? limit) => _$this._limit = limit;

  ChatFilterBuilder();

  ChatFilterBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _searchTerm = $v.searchTerm;
      _stateFilter = $v.stateFilter;
      _sortField = $v.sortField;
      _sortAscending = $v.sortAscending;
      _limit = $v.limit;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatFilter other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ChatFilter;
  }

  @override
  void update(void Function(ChatFilterBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChatFilter build() => _build();

  _$ChatFilter _build() {
    final _$result = _$v ??
        new _$ChatFilter._(
            searchTerm: BuiltValueNullFieldError.checkNotNull(
                searchTerm, r'ChatFilter', 'searchTerm'),
            stateFilter: BuiltValueNullFieldError.checkNotNull(
                stateFilter, r'ChatFilter', 'stateFilter'),
            sortField: BuiltValueNullFieldError.checkNotNull(
                sortField, r'ChatFilter', 'sortField'),
            sortAscending: BuiltValueNullFieldError.checkNotNull(
                sortAscending, r'ChatFilter', 'sortAscending'),
            limit: BuiltValueNullFieldError.checkNotNull(
                limit, r'ChatFilter', 'limit'));
    replace(_$result);
    return _$result;
  }
}

class _$ChatListResponse extends ChatListResponse {
  @override
  final BuiltList<ChatEntity> data;

  factory _$ChatListResponse(
          [void Function(ChatListResponseBuilder)? updates]) =>
      (new ChatListResponseBuilder()..update(updates))._build();

  _$ChatListResponse._({required this.data}) : super._() {
    BuiltValueNullFieldError.checkNotNull(data, r'ChatListResponse', 'data');
  }

  @override
  ChatListResponse rebuild(void Function(ChatListResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatListResponseBuilder toBuilder() =>
      new ChatListResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatListResponse && data == other.data;
  }

  int? __hashCode;
  @override
  int get hashCode {
    if (__hashCode != null) return __hashCode!;
    var _$hash = 0;
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jf(_$hash);
    return __hashCode ??= _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChatListResponse')..add('data', data))
        .toString();
  }
}

class ChatListResponseBuilder
    implements Builder<ChatListResponse, ChatListResponseBuilder> {
  _$ChatListResponse? _$v;

  ListBuilder<ChatEntity>? _data;
  ListBuilder<ChatEntity> get data =>
      _$this._data ??= new ListBuilder<ChatEntity>();
  set data(ListBuilder<ChatEntity>? data) => _$this._data = data;

  ChatListResponseBuilder();

  ChatListResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatListResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ChatListResponse;
  }

  @override
  void update(void Function(ChatListResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChatListResponse build() => _build();

  _$ChatListResponse _build() {
    _$ChatListResponse _$result;
    try {
      _$result = _$v ?? new _$ChatListResponse._(data: data.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'ChatListResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$ChatItemResponse extends ChatItemResponse {
  @override
  final ChatEntity data;

  factory _$ChatItemResponse(
          [void Function(ChatItemResponseBuilder)? updates]) =>
      (new ChatItemResponseBuilder()..update(updates))._build();

  _$ChatItemResponse._({required this.data}) : super._() {
    BuiltValueNullFieldError.checkNotNull(data, r'ChatItemResponse', 'data');
  }

  @override
  ChatItemResponse rebuild(void Function(ChatItemResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatItemResponseBuilder toBuilder() =>
      new ChatItemResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatItemResponse && data == other.data;
  }

  int? __hashCode;
  @override
  int get hashCode {
    if (__hashCode != null) return __hashCode!;
    var _$hash = 0;
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jf(_$hash);
    return __hashCode ??= _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChatItemResponse')..add('data', data))
        .toString();
  }
}

class ChatItemResponseBuilder
    implements Builder<ChatItemResponse, ChatItemResponseBuilder> {
  _$ChatItemResponse? _$v;

  ChatEntityBuilder? _data;
  ChatEntityBuilder get data => _$this._data ??= new ChatEntityBuilder();
  set data(ChatEntityBuilder? data) => _$this._data = data;

  ChatItemResponseBuilder();

  ChatItemResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatItemResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ChatItemResponse;
  }

  @override
  void update(void Function(ChatItemResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChatItemResponse build() => _build();

  _$ChatItemResponse _build() {
    _$ChatItemResponse _$result;
    try {
      _$result = _$v ?? new _$ChatItemResponse._(data: data.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'ChatItemResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$ChatEntity extends ChatEntity {
  @override
  final bool isGroupChat;
  @override
  final String groupName;
  @override
  final ChatStatus status;
  @override
  final CEntityType centityType;
  @override
  final String centityId;
  @override
  final String groupThumbnail;
  @override
  final LastMessageEntity lastMessage;
  @override
  final int lastActive;
  @override
  final BuiltMap<String, int> unreadCounts;
  @override
  final BuiltList<String> participantsIds;
  @override
  final BuiltList<ChatParticipantEntity> participants;
  @override
  final bool? isChanged;
  @override
  final int createdAt;
  @override
  final int updatedAt;
  @override
  final int archivedAt;
  @override
  final bool? isDeleted;
  @override
  final bool? isReported;
  @override
  final String? createdUserId;
  @override
  final String? assignedUserId;
  @override
  final String id;

  factory _$ChatEntity([void Function(ChatEntityBuilder)? updates]) =>
      (new ChatEntityBuilder()..update(updates))._build();

  _$ChatEntity._(
      {required this.isGroupChat,
      required this.groupName,
      required this.status,
      required this.centityType,
      required this.centityId,
      required this.groupThumbnail,
      required this.lastMessage,
      required this.lastActive,
      required this.unreadCounts,
      required this.participantsIds,
      required this.participants,
      this.isChanged,
      required this.createdAt,
      required this.updatedAt,
      required this.archivedAt,
      this.isDeleted,
      this.isReported,
      this.createdUserId,
      this.assignedUserId,
      required this.id})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        isGroupChat, r'ChatEntity', 'isGroupChat');
    BuiltValueNullFieldError.checkNotNull(
        groupName, r'ChatEntity', 'groupName');
    BuiltValueNullFieldError.checkNotNull(status, r'ChatEntity', 'status');
    BuiltValueNullFieldError.checkNotNull(
        centityType, r'ChatEntity', 'centityType');
    BuiltValueNullFieldError.checkNotNull(
        centityId, r'ChatEntity', 'centityId');
    BuiltValueNullFieldError.checkNotNull(
        groupThumbnail, r'ChatEntity', 'groupThumbnail');
    BuiltValueNullFieldError.checkNotNull(
        lastMessage, r'ChatEntity', 'lastMessage');
    BuiltValueNullFieldError.checkNotNull(
        lastActive, r'ChatEntity', 'lastActive');
    BuiltValueNullFieldError.checkNotNull(
        unreadCounts, r'ChatEntity', 'unreadCounts');
    BuiltValueNullFieldError.checkNotNull(
        participantsIds, r'ChatEntity', 'participantsIds');
    BuiltValueNullFieldError.checkNotNull(
        participants, r'ChatEntity', 'participants');
    BuiltValueNullFieldError.checkNotNull(
        createdAt, r'ChatEntity', 'createdAt');
    BuiltValueNullFieldError.checkNotNull(
        updatedAt, r'ChatEntity', 'updatedAt');
    BuiltValueNullFieldError.checkNotNull(
        archivedAt, r'ChatEntity', 'archivedAt');
    BuiltValueNullFieldError.checkNotNull(id, r'ChatEntity', 'id');
  }

  @override
  ChatEntity rebuild(void Function(ChatEntityBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatEntityBuilder toBuilder() => new ChatEntityBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatEntity &&
        isGroupChat == other.isGroupChat &&
        groupName == other.groupName &&
        status == other.status &&
        centityType == other.centityType &&
        centityId == other.centityId &&
        groupThumbnail == other.groupThumbnail &&
        lastMessage == other.lastMessage &&
        lastActive == other.lastActive &&
        unreadCounts == other.unreadCounts &&
        participantsIds == other.participantsIds &&
        participants == other.participants &&
        isChanged == other.isChanged &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        archivedAt == other.archivedAt &&
        isDeleted == other.isDeleted &&
        isReported == other.isReported &&
        createdUserId == other.createdUserId &&
        assignedUserId == other.assignedUserId &&
        id == other.id;
  }

  int? __hashCode;
  @override
  int get hashCode {
    if (__hashCode != null) return __hashCode!;
    var _$hash = 0;
    _$hash = $jc(_$hash, isGroupChat.hashCode);
    _$hash = $jc(_$hash, groupName.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, centityType.hashCode);
    _$hash = $jc(_$hash, centityId.hashCode);
    _$hash = $jc(_$hash, groupThumbnail.hashCode);
    _$hash = $jc(_$hash, lastMessage.hashCode);
    _$hash = $jc(_$hash, lastActive.hashCode);
    _$hash = $jc(_$hash, unreadCounts.hashCode);
    _$hash = $jc(_$hash, participantsIds.hashCode);
    _$hash = $jc(_$hash, participants.hashCode);
    _$hash = $jc(_$hash, isChanged.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, archivedAt.hashCode);
    _$hash = $jc(_$hash, isDeleted.hashCode);
    _$hash = $jc(_$hash, isReported.hashCode);
    _$hash = $jc(_$hash, createdUserId.hashCode);
    _$hash = $jc(_$hash, assignedUserId.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jf(_$hash);
    return __hashCode ??= _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChatEntity')
          ..add('isGroupChat', isGroupChat)
          ..add('groupName', groupName)
          ..add('status', status)
          ..add('centityType', centityType)
          ..add('centityId', centityId)
          ..add('groupThumbnail', groupThumbnail)
          ..add('lastMessage', lastMessage)
          ..add('lastActive', lastActive)
          ..add('unreadCounts', unreadCounts)
          ..add('participantsIds', participantsIds)
          ..add('participants', participants)
          ..add('isChanged', isChanged)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt)
          ..add('archivedAt', archivedAt)
          ..add('isDeleted', isDeleted)
          ..add('isReported', isReported)
          ..add('createdUserId', createdUserId)
          ..add('assignedUserId', assignedUserId)
          ..add('id', id))
        .toString();
  }
}

class ChatEntityBuilder implements Builder<ChatEntity, ChatEntityBuilder> {
  _$ChatEntity? _$v;

  bool? _isGroupChat;
  bool? get isGroupChat => _$this._isGroupChat;
  set isGroupChat(bool? isGroupChat) => _$this._isGroupChat = isGroupChat;

  String? _groupName;
  String? get groupName => _$this._groupName;
  set groupName(String? groupName) => _$this._groupName = groupName;

  ChatStatus? _status;
  ChatStatus? get status => _$this._status;
  set status(ChatStatus? status) => _$this._status = status;

  CEntityType? _centityType;
  CEntityType? get centityType => _$this._centityType;
  set centityType(CEntityType? centityType) =>
      _$this._centityType = centityType;

  String? _centityId;
  String? get centityId => _$this._centityId;
  set centityId(String? centityId) => _$this._centityId = centityId;

  String? _groupThumbnail;
  String? get groupThumbnail => _$this._groupThumbnail;
  set groupThumbnail(String? groupThumbnail) =>
      _$this._groupThumbnail = groupThumbnail;

  LastMessageEntityBuilder? _lastMessage;
  LastMessageEntityBuilder get lastMessage =>
      _$this._lastMessage ??= new LastMessageEntityBuilder();
  set lastMessage(LastMessageEntityBuilder? lastMessage) =>
      _$this._lastMessage = lastMessage;

  int? _lastActive;
  int? get lastActive => _$this._lastActive;
  set lastActive(int? lastActive) => _$this._lastActive = lastActive;

  MapBuilder<String, int>? _unreadCounts;
  MapBuilder<String, int> get unreadCounts =>
      _$this._unreadCounts ??= new MapBuilder<String, int>();
  set unreadCounts(MapBuilder<String, int>? unreadCounts) =>
      _$this._unreadCounts = unreadCounts;

  ListBuilder<String>? _participantsIds;
  ListBuilder<String> get participantsIds =>
      _$this._participantsIds ??= new ListBuilder<String>();
  set participantsIds(ListBuilder<String>? participantsIds) =>
      _$this._participantsIds = participantsIds;

  ListBuilder<ChatParticipantEntity>? _participants;
  ListBuilder<ChatParticipantEntity> get participants =>
      _$this._participants ??= new ListBuilder<ChatParticipantEntity>();
  set participants(ListBuilder<ChatParticipantEntity>? participants) =>
      _$this._participants = participants;

  bool? _isChanged;
  bool? get isChanged => _$this._isChanged;
  set isChanged(bool? isChanged) => _$this._isChanged = isChanged;

  int? _createdAt;
  int? get createdAt => _$this._createdAt;
  set createdAt(int? createdAt) => _$this._createdAt = createdAt;

  int? _updatedAt;
  int? get updatedAt => _$this._updatedAt;
  set updatedAt(int? updatedAt) => _$this._updatedAt = updatedAt;

  int? _archivedAt;
  int? get archivedAt => _$this._archivedAt;
  set archivedAt(int? archivedAt) => _$this._archivedAt = archivedAt;

  bool? _isDeleted;
  bool? get isDeleted => _$this._isDeleted;
  set isDeleted(bool? isDeleted) => _$this._isDeleted = isDeleted;

  bool? _isReported;
  bool? get isReported => _$this._isReported;
  set isReported(bool? isReported) => _$this._isReported = isReported;

  String? _createdUserId;
  String? get createdUserId => _$this._createdUserId;
  set createdUserId(String? createdUserId) =>
      _$this._createdUserId = createdUserId;

  String? _assignedUserId;
  String? get assignedUserId => _$this._assignedUserId;
  set assignedUserId(String? assignedUserId) =>
      _$this._assignedUserId = assignedUserId;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  ChatEntityBuilder();

  ChatEntityBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _isGroupChat = $v.isGroupChat;
      _groupName = $v.groupName;
      _status = $v.status;
      _centityType = $v.centityType;
      _centityId = $v.centityId;
      _groupThumbnail = $v.groupThumbnail;
      _lastMessage = $v.lastMessage.toBuilder();
      _lastActive = $v.lastActive;
      _unreadCounts = $v.unreadCounts.toBuilder();
      _participantsIds = $v.participantsIds.toBuilder();
      _participants = $v.participants.toBuilder();
      _isChanged = $v.isChanged;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _archivedAt = $v.archivedAt;
      _isDeleted = $v.isDeleted;
      _isReported = $v.isReported;
      _createdUserId = $v.createdUserId;
      _assignedUserId = $v.assignedUserId;
      _id = $v.id;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatEntity other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ChatEntity;
  }

  @override
  void update(void Function(ChatEntityBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChatEntity build() => _build();

  _$ChatEntity _build() {
    _$ChatEntity _$result;
    try {
      _$result = _$v ??
          new _$ChatEntity._(
              isGroupChat: BuiltValueNullFieldError.checkNotNull(
                  isGroupChat, r'ChatEntity', 'isGroupChat'),
              groupName: BuiltValueNullFieldError.checkNotNull(
                  groupName, r'ChatEntity', 'groupName'),
              status: BuiltValueNullFieldError.checkNotNull(
                  status, r'ChatEntity', 'status'),
              centityType: BuiltValueNullFieldError.checkNotNull(
                  centityType, r'ChatEntity', 'centityType'),
              centityId: BuiltValueNullFieldError.checkNotNull(
                  centityId, r'ChatEntity', 'centityId'),
              groupThumbnail: BuiltValueNullFieldError.checkNotNull(
                  groupThumbnail, r'ChatEntity', 'groupThumbnail'),
              lastMessage: lastMessage.build(),
              lastActive: BuiltValueNullFieldError.checkNotNull(
                  lastActive, r'ChatEntity', 'lastActive'),
              unreadCounts: unreadCounts.build(),
              participantsIds: participantsIds.build(),
              participants: participants.build(),
              isChanged: isChanged,
              createdAt: BuiltValueNullFieldError.checkNotNull(
                  createdAt, r'ChatEntity', 'createdAt'),
              updatedAt:
                  BuiltValueNullFieldError.checkNotNull(updatedAt, r'ChatEntity', 'updatedAt'),
              archivedAt: BuiltValueNullFieldError.checkNotNull(archivedAt, r'ChatEntity', 'archivedAt'),
              isDeleted: isDeleted,
              isReported: isReported,
              createdUserId: createdUserId,
              assignedUserId: assignedUserId,
              id: BuiltValueNullFieldError.checkNotNull(id, r'ChatEntity', 'id'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'lastMessage';
        lastMessage.build();

        _$failedField = 'unreadCounts';
        unreadCounts.build();
        _$failedField = 'participantsIds';
        participantsIds.build();
        _$failedField = 'participants';
        participants.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'ChatEntity', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$ChatParticipantEntity extends ChatParticipantEntity {
  @override
  final String userId;
  @override
  final String userName;
  @override
  final String userThumbnail;
  @override
  final ParticipantRole role;
  @override
  final int addedAt;

  factory _$ChatParticipantEntity(
          [void Function(ChatParticipantEntityBuilder)? updates]) =>
      (new ChatParticipantEntityBuilder()..update(updates))._build();

  _$ChatParticipantEntity._(
      {required this.userId,
      required this.userName,
      required this.userThumbnail,
      required this.role,
      required this.addedAt})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        userId, r'ChatParticipantEntity', 'userId');
    BuiltValueNullFieldError.checkNotNull(
        userName, r'ChatParticipantEntity', 'userName');
    BuiltValueNullFieldError.checkNotNull(
        userThumbnail, r'ChatParticipantEntity', 'userThumbnail');
    BuiltValueNullFieldError.checkNotNull(
        role, r'ChatParticipantEntity', 'role');
    BuiltValueNullFieldError.checkNotNull(
        addedAt, r'ChatParticipantEntity', 'addedAt');
  }

  @override
  ChatParticipantEntity rebuild(
          void Function(ChatParticipantEntityBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatParticipantEntityBuilder toBuilder() =>
      new ChatParticipantEntityBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatParticipantEntity &&
        userId == other.userId &&
        userName == other.userName &&
        userThumbnail == other.userThumbnail &&
        role == other.role &&
        addedAt == other.addedAt;
  }

  int? __hashCode;
  @override
  int get hashCode {
    if (__hashCode != null) return __hashCode!;
    var _$hash = 0;
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jc(_$hash, userName.hashCode);
    _$hash = $jc(_$hash, userThumbnail.hashCode);
    _$hash = $jc(_$hash, role.hashCode);
    _$hash = $jc(_$hash, addedAt.hashCode);
    _$hash = $jf(_$hash);
    return __hashCode ??= _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChatParticipantEntity')
          ..add('userId', userId)
          ..add('userName', userName)
          ..add('userThumbnail', userThumbnail)
          ..add('role', role)
          ..add('addedAt', addedAt))
        .toString();
  }
}

class ChatParticipantEntityBuilder
    implements Builder<ChatParticipantEntity, ChatParticipantEntityBuilder> {
  _$ChatParticipantEntity? _$v;

  String? _userId;
  String? get userId => _$this._userId;
  set userId(String? userId) => _$this._userId = userId;

  String? _userName;
  String? get userName => _$this._userName;
  set userName(String? userName) => _$this._userName = userName;

  String? _userThumbnail;
  String? get userThumbnail => _$this._userThumbnail;
  set userThumbnail(String? userThumbnail) =>
      _$this._userThumbnail = userThumbnail;

  ParticipantRole? _role;
  ParticipantRole? get role => _$this._role;
  set role(ParticipantRole? role) => _$this._role = role;

  int? _addedAt;
  int? get addedAt => _$this._addedAt;
  set addedAt(int? addedAt) => _$this._addedAt = addedAt;

  ChatParticipantEntityBuilder() {
    ChatParticipantEntity._initializeBuilder(this);
  }

  ChatParticipantEntityBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _userId = $v.userId;
      _userName = $v.userName;
      _userThumbnail = $v.userThumbnail;
      _role = $v.role;
      _addedAt = $v.addedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatParticipantEntity other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ChatParticipantEntity;
  }

  @override
  void update(void Function(ChatParticipantEntityBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChatParticipantEntity build() => _build();

  _$ChatParticipantEntity _build() {
    final _$result = _$v ??
        new _$ChatParticipantEntity._(
            userId: BuiltValueNullFieldError.checkNotNull(
                userId, r'ChatParticipantEntity', 'userId'),
            userName: BuiltValueNullFieldError.checkNotNull(
                userName, r'ChatParticipantEntity', 'userName'),
            userThumbnail: BuiltValueNullFieldError.checkNotNull(
                userThumbnail, r'ChatParticipantEntity', 'userThumbnail'),
            role: BuiltValueNullFieldError.checkNotNull(
                role, r'ChatParticipantEntity', 'role'),
            addedAt: BuiltValueNullFieldError.checkNotNull(
                addedAt, r'ChatParticipantEntity', 'addedAt'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
