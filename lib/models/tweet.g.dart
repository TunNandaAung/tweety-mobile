// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tweet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tweet _$TweetFromJson(Map<String, dynamic> json) {
  return Tweet(
    id: json['id'] as int,
    image: json['image'] as String,
    body: json['body'] as String,
    isLiked: json['is_liked'] as bool,
    isDisliked: json['is_disliked'] as bool,
    repliesCount: json['replies_count'] as int,
    likesCount: json['likes_count'] as int,
    dislikesCount: json['dislikes_count'] as int,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    user: json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$TweetToJson(Tweet instance) => <String, dynamic>{
      'id': instance.id,
      'image': instance.image,
      'body': instance.body,
      'is_liked': instance.isLiked,
      'is_disliked': instance.isDisliked,
      'replies_count': instance.repliesCount,
      'likes_count': instance.likesCount,
      'dislikes_count': instance.dislikesCount,
      'user': instance.user,
      'created_at': instance.createdAt?.toIso8601String(),
    };
