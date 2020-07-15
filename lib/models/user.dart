import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  int id;

  String name;
  String username;
  String avatar;
  String banner;
  String description;

  @JsonKey(nullable: true)
  String email;

  @JsonKey(name: 'created_at')
  DateTime createdAt;

  @JsonKey(name: 'follows_count')
  int followsCount;

  @JsonKey(name: 'followers_count')
  int followersCount;

  @JsonKey(name: 'is_followed')
  bool isFollowed;

  User({
    this.id,
    this.name,
    this.username,
    this.banner,
    this.description,
    this.email,
    this.avatar,
    this.createdAt,
    this.followsCount,
    this.followersCount,
    this.isFollowed,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
