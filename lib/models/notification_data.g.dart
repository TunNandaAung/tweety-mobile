// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationData _$NotificationDataFromJson(Map<String, dynamic> json) =>
    NotificationData(
      message: json['message'] as String,
      notifier: User.fromJson(json['notifier'] as Map<String, dynamic>),
      link: json['link'] as String,
      type: json['type'] as String,
      screen: json['screen'] as String?,
      arg: json['arg'],
    );

Map<String, dynamic> _$NotificationDataToJson(NotificationData instance) =>
    <String, dynamic>{
      'message': instance.message,
      'notifier': instance.notifier,
      'link': instance.link,
      'type': instance.type,
      'arg': instance.arg,
      'screen': instance.screen,
    };
