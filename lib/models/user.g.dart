// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    id: json['id'] as int,
    name: json['name'] as String,
    username: json['username'] as String,
    banner: json['banner'] as String,
    description: json['description'] as String,
    email: json['email'] as String,
    avatar: json['avatar'] as String,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    followsCount: json['follows_count'] as int,
    followersCount: json['followers_count'] as int,
    isFollowed: json['is_followed'] as bool,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'username': instance.username,
      'avatar': instance.avatar,
      'banner': instance.banner,
      'description': instance.description,
      'email': instance.email,
      'created_at': instance.createdAt?.toIso8601String(),
      'follows_count': instance.followsCount,
      'followers_count': instance.followersCount,
      'is_followed': instance.isFollowed,
    };
