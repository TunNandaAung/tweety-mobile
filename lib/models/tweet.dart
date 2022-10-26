import 'package:json_annotation/json_annotation.dart';
import 'package:tweety_mobile/models/user.dart';

part 'tweet.g.dart';

@JsonSerializable()
class Tweet {
  int id;

  String? image;

  String body;

  @JsonKey(name: 'is_liked')
  bool isLiked;

  @JsonKey(name: 'is_disliked')
  bool isDisliked;

  @JsonKey(name: 'replies_count')
  int repliesCount;

  @JsonKey(name: 'likes_count')
  int likesCount;

  @JsonKey(name: 'dislikes_count')
  int dislikesCount;

  User user;

  @JsonKey(name: 'created_at')
  DateTime createdAt;

  Tweet({
    required this.id,
    this.image,
    required this.body,
    required this.isLiked,
    required this.isDisliked,
    required this.repliesCount,
    required this.likesCount,
    required this.dislikesCount,
    required this.createdAt,
    required this.user,
  });

  factory Tweet.fromJson(Map<String, dynamic> json) => _$TweetFromJson(json);

  Map<String, dynamic> toJson() => _$TweetToJson(this);

  Tweet copyWith({
    int? id,
    String? image,
    String? body,
    bool? isLiked,
    bool? isDisliked,
    int? repliesCount,
    int? likesCount,
    int? dislikesCount,
    DateTime? createdAt,
    User? user,
  }) {
    return Tweet(
      id: id ?? this.id,
      image: image ?? this.image,
      body: body ?? this.body,
      isLiked: isLiked ?? this.isLiked,
      isDisliked: isDisliked ?? this.isDisliked,
      repliesCount: repliesCount ?? this.repliesCount,
      likesCount: likesCount ?? this.likesCount,
      dislikesCount: dislikesCount ?? this.dislikesCount,
      createdAt: createdAt ?? this.createdAt,
      user: user ?? this.user,
    );
  }
}
