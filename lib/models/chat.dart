import 'package:json_annotation/json_annotation.dart';
import 'package:tweety_mobile/models/message.dart';
import 'package:tweety_mobile/models/user.dart';

part 'chat.g.dart';

@JsonSerializable()
class Chat {
  String id;

  @JsonKey(name: 'created_at')
  DateTime createdAt;

  @JsonKey(name: 'updated_at')
  DateTime updatedAt;

  List<Message> messages;

  List<User> participants;

  Chat({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.messages,
    this.participants,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);

  Map<String, dynamic> toJson() => _$ChatToJson(this);
}
