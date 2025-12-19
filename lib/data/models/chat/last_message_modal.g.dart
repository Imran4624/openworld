// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'last_message_modal.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<LastMessageEntity> _$lastMessageEntitySerializer =
    new _$LastMessageEntitySerializer();

class _$LastMessageEntitySerializer
    implements StructuredSerializer<LastMessageEntity> {
  @override
  final Iterable<Type> types = const [LastMessageEntity, _$LastMessageEntity];
  @override
  final String wireName = 'LastMessageEntity';

  @override
  Iterable<Object?> serialize(Serializers serializers, LastMessageEntity object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'messageId',
      serializers.serialize(object.messageId,
          specifiedType: const FullType(String)),
      'senderId',
      serializers.serialize(object.senderId,
          specifiedType: const FullType(String)),
      'content',
      serializers.serialize(object.content,
          specifiedType: const FullType(String)),
      'createdAt',
      serializers.serialize(object.createdAt,
          specifiedType: const FullType(int)),
    ];
    Object? value;
    value = object.attachments;
    if (value != null) {
      result
        ..add('attachments')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(
                BuiltList, const [const FullType(ChatMessageAttachment)])));
    }
    return result;
  }

  @override
  LastMessageEntity deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new LastMessageEntityBuilder();

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
        case 'senderId':
          result.senderId = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'content':
          result.content = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'createdAt':
          result.createdAt = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'attachments':
          result.attachments.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltList, const [
                const FullType(ChatMessageAttachment)
              ]))! as BuiltList<Object?>);
          break;
      }
    }

    return result.build();
  }
}

class _$LastMessageEntity extends LastMessageEntity {
  @override
  final String messageId;
  @override
  final String senderId;
  @override
  final String content;
  @override
  final int createdAt;
  @override
  final BuiltList<ChatMessageAttachment>? attachments;

  factory _$LastMessageEntity(
          [void Function(LastMessageEntityBuilder)? updates]) =>
      (new LastMessageEntityBuilder()..update(updates))._build();

  _$LastMessageEntity._(
      {required this.messageId,
      required this.senderId,
      required this.content,
      required this.createdAt,
      this.attachments})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        messageId, r'LastMessageEntity', 'messageId');
    BuiltValueNullFieldError.checkNotNull(
        senderId, r'LastMessageEntity', 'senderId');
    BuiltValueNullFieldError.checkNotNull(
        content, r'LastMessageEntity', 'content');
    BuiltValueNullFieldError.checkNotNull(
        createdAt, r'LastMessageEntity', 'createdAt');
  }

  @override
  LastMessageEntity rebuild(void Function(LastMessageEntityBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LastMessageEntityBuilder toBuilder() =>
      new LastMessageEntityBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LastMessageEntity &&
        messageId == other.messageId &&
        senderId == other.senderId &&
        content == other.content &&
        createdAt == other.createdAt &&
        attachments == other.attachments;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, messageId.hashCode);
    _$hash = $jc(_$hash, senderId.hashCode);
    _$hash = $jc(_$hash, content.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, attachments.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LastMessageEntity')
          ..add('messageId', messageId)
          ..add('senderId', senderId)
          ..add('content', content)
          ..add('createdAt', createdAt)
          ..add('attachments', attachments))
        .toString();
  }
}

class LastMessageEntityBuilder
    implements Builder<LastMessageEntity, LastMessageEntityBuilder> {
  _$LastMessageEntity? _$v;

  String? _messageId;
  String? get messageId => _$this._messageId;
  set messageId(String? messageId) => _$this._messageId = messageId;

  String? _senderId;
  String? get senderId => _$this._senderId;
  set senderId(String? senderId) => _$this._senderId = senderId;

  String? _content;
  String? get content => _$this._content;
  set content(String? content) => _$this._content = content;

  int? _createdAt;
  int? get createdAt => _$this._createdAt;
  set createdAt(int? createdAt) => _$this._createdAt = createdAt;

  ListBuilder<ChatMessageAttachment>? _attachments;
  ListBuilder<ChatMessageAttachment> get attachments =>
      _$this._attachments ??= new ListBuilder<ChatMessageAttachment>();
  set attachments(ListBuilder<ChatMessageAttachment>? attachments) =>
      _$this._attachments = attachments;

  LastMessageEntityBuilder() {
    LastMessageEntity._initializeBuilder(this);
  }

  LastMessageEntityBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _messageId = $v.messageId;
      _senderId = $v.senderId;
      _content = $v.content;
      _createdAt = $v.createdAt;
      _attachments = $v.attachments?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LastMessageEntity other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$LastMessageEntity;
  }

  @override
  void update(void Function(LastMessageEntityBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LastMessageEntity build() => _build();

  _$LastMessageEntity _build() {
    _$LastMessageEntity _$result;
    try {
      _$result = _$v ??
          new _$LastMessageEntity._(
              messageId: BuiltValueNullFieldError.checkNotNull(
                  messageId, r'LastMessageEntity', 'messageId'),
              senderId: BuiltValueNullFieldError.checkNotNull(
                  senderId, r'LastMessageEntity', 'senderId'),
              content: BuiltValueNullFieldError.checkNotNull(
                  content, r'LastMessageEntity', 'content'),
              createdAt: BuiltValueNullFieldError.checkNotNull(
                  createdAt, r'LastMessageEntity', 'createdAt'),
              attachments: _attachments?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'attachments';
        _attachments?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'LastMessageEntity', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
