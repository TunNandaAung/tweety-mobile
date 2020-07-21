// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiNotification _$ApiNotificationFromJson(Map<String, dynamic> json) {
  return ApiNotification(
    json['id'] as String,
    json['type'] as String,
    json['notifiable_id'] as int,
    json['data'] == null
        ? null
        : NotificationData.fromJson(json['data'] as Map<String, dynamic>),
    json['read_at'] == null ? null : DateTime.parse(json['read_at'] as String),
    json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
  );
}

Map<String, dynamic> _$ApiNotificationToJson(ApiNotification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'notifiable_id': instance.notifiableID,
      'data': instance.data,
      'read_at': instance.readAt?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
    };
