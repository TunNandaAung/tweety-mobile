import 'package:json_annotation/json_annotation.dart';
import 'package:tweety_mobile/models/user.dart';

part 'notification_data.g.dart';

@JsonSerializable()
class NotificationData {
  String message;
  User notifier;
  String link;
  String type;
  @JsonKey(nullable: true)
  final arg;

  @JsonKey(nullable: true)
  String screen;

  NotificationData(
      {this.message, this.notifier, this.link, this.screen, this.arg});

  factory NotificationData.fromJson(Map<String, dynamic> json) =>
      _$NotificationDataFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationDataToJson(this);
}
