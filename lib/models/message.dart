import 'package:json_annotation/json_annotation.dart';
import 'package:tweety_mobile/models/user.dart';

part 'message.g.dart';

@JsonSerializable()
class Message {
  int id;

  @JsonKey(name: 'user_id')
  int userId;

  @JsonKey(name: 'chat_id')
  String chatId;

  String message;

  @JsonKey(name: 'created_at')
  DateTime createdAt;

  @JsonKey(name: 'updated_at')
  DateTime updatedAt;

  @JsonKey(name: 'read_at', nullable: true)
  DateTime readAt;

  User sender;

  Message({
    this.id,
    this.userId,
    this.chatId,
    this.message,
    this.createdAt,
    this.updatedAt,
    this.readAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);
}
