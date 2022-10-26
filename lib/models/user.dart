import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  int id;

  String name;
  String username;
  String avatar;
  String banner;
  String? description;

  String? email;

  @JsonKey(name: 'created_at')
  DateTime createdAt;

  @JsonKey(name: 'follows_count')
  int followsCount;

  @JsonKey(name: 'followers_count')
  int followersCount;

  @JsonKey(name: 'is_followed')
  bool isFollowed;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.banner,
    this.description,
    this.email,
    required this.avatar,
    required this.createdAt,
    required this.followsCount,
    required this.followersCount,
    required this.isFollowed,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
