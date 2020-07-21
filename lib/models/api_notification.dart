import 'package:tweety_mobile/models/notification_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'api_notification.g.dart';

@JsonSerializable()
class ApiNotification {
  String id;

  String type;

  @JsonKey(name: 'notifiable_id')
  int notifiableID;

  NotificationData data;

  @JsonKey(name: 'read_at', nullable: true)
  DateTime readAt;

  @JsonKey(name: 'created_at')
  DateTime createdAt;

  ApiNotification(
    this.id,
    this.type,
    this.notifiableID,
    this.data,
    this.readAt,
    this.createdAt,
  );

  factory ApiNotification.fromJson(Map<String, dynamic> json) =>
      _$ApiNotificationFromJson(json);

  Map<String, dynamic> toJson() => _$ApiNotificationToJson(this);
}
