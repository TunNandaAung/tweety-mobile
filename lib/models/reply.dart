import 'package:json_annotation/json_annotation.dart';
import 'package:tweety_mobile/models/tweet.dart';
import 'package:tweety_mobile/models/user.dart';

part 'reply.g.dart';

@JsonSerializable()
class Reply {
  int id;

  @JsonKey(nullable: true)
  String image;
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

  @JsonKey(nullable: true)
  Reply parent;

  @JsonKey(name: 'created_at')
  DateTime createdAt;

  Reply({
    this.id,
    this.image,
    this.body,
    this.childrenCount,
    this.isLiked,
    this.isDisliked,
    this.likesCount,
    this.dislikesCount,
    this.owner,
    this.tweet,
    this.createdAt,
  });

  factory Reply.fromJson(Map<String, dynamic> json) => _$ReplyFromJson(json);

  Map<String, dynamic> toJson() => _$ReplyToJson(this);
}
