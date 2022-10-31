import 'package:json_annotation/json_annotation.dart';
import 'package:tweety_mobile/models/tweet.dart';
import 'package:tweety_mobile/models/user.dart';

part 'reply.g.dart';

@JsonSerializable()
class Reply {
  int id;

  String? image;

  String body;

  @JsonKey(name: 'children_count')
  int childrenCount;

  @JsonKey(name: 'is_liked')
  bool isLiked;

  @JsonKey(name: 'is_disliked')
  bool isDisliked;

  @JsonKey(name: 'likes_count')
  int likesCount;

  @JsonKey(name: 'dislikes_count')
  int dislikesCount;

  User owner;

  Tweet tweet;

  Reply? parent;

  @JsonKey(name: 'created_at')
  DateTime createdAt;

  Reply({
    required this.id,
    this.image,
    required this.body,
    required this.childrenCount,
    required this.isLiked,
    required this.isDisliked,
    required this.likesCount,
    required this.dislikesCount,
    required this.owner,
    required this.tweet,
    required this.createdAt,
    this.parent,
  });

  factory Reply.fromJson(Map<String, dynamic> json) => _$ReplyFromJson(json);

  Map<String, dynamic> toJson() => _$ReplyToJson(this);
}
