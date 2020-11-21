// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) {
  return Message(
    id: json['id'] as int,
    userId: json['user_id'] as int,
    chatId: json['chat_id'] as String,
    message: json['message'] as String,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    updatedAt: json['updated_at'] == null
        ? null
        : DateTime.parse(json['updated_at'] as String),
    readAt: json['read_at'] == null
        ? null
        : DateTime.parse(json['read_at'] as String),
  )..sender = json['sender'] == null
      ? null
      : User.fromJson(json['sender'] as Map<String, dynamic>);
}

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'chat_id': instance.chatId,
      'message': instance.message,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'read_at': instance.readAt?.toIso8601String(),
      'sender': instance.sender,
    };
