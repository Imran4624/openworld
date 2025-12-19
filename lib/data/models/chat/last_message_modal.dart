import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:flutter_boilerplate/data/models/chat_model.dart';

part 'last_message_modal.g.dart';

abstract class LastMessageEntity
    implements Built<LastMessageEntity, LastMessageEntityBuilder> {
  factory LastMessageEntity({
    String? messageId,
    String? senderId,
    String? content,
    int? createdAt,
    BuiltList<ChatMessageAttachment>? attachments,
  }) {
    return _$LastMessageEntity._(
      messageId: messageId ?? '',
      senderId: senderId ?? '',
      content: content ?? '',
      createdAt: createdAt ?? DateTime.now().millisecondsSinceEpoch,
      attachments: attachments ?? BuiltList<ChatMessageAttachment>([]),
    );
  }

  LastMessageEntity._();

  String get messageId;
  String get senderId;
  String get content;
  int get createdAt;

  BuiltList<ChatMessageAttachment>? get attachments;

  DateTime get createdAtDate => DateTime.fromMillisecondsSinceEpoch(createdAt);

  static Serializer<LastMessageEntity> get serializer =>
      _$lastMessageEntitySerializer;

  static void _initializeBuilder(LastMessageEntityBuilder builder) => builder
    ..messageId = ''
    ..senderId = ''
    ..content = ''
    ..createdAt = DateTime.now().millisecondsSinceEpoch
    ..attachments = null;
}
