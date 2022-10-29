import 'package:json_annotation/json_annotation.dart';
import 'package:tweety_mobile/models/user.dart';

part 'notification_data.g.dart';

@JsonSerializable()
class NotificationData {
  String message;
  User notifier;
  String link;
  String type;
  // ignore: prefer_typing_uninitialized_variables
  final arg;
  String? screen;

  NotificationData({
    required this.message,
    required this.notifier,
    required this.link,
    required this.type,
    this.screen,
    this.arg,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) =>
      _$NotificationDataFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationDataToJson(this);
}
