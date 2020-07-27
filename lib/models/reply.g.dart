// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reply.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reply _$ReplyFromJson(Map<String, dynamic> json) {
  return Reply(
    id: json['id'] as int,
    image: json['image'] as String,
    body: json['body'] as String,
    childrenCount: json['children_count'] as int,
    isLiked: json['is_liked'] as bool,
    isDisliked: json['is_disliked'] as bool,
    likesCount: json['likes_count'] as int,
    dislikesCount: json['dislikes_count'] as int,
    owner: json['owner'] == null
        ? null
        : User.fromJson(json['owner'] as Map<String, dynamic>),
    tweet: json['tweet'] == null
        ? null
        : Tweet.fromJson(json['tweet'] as Map<String, dynamic>),
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
  )..parent = json['parent'] == null
      ? null
      : Reply.fromJson(json['parent'] as Map<String, dynamic>);
}

Map<String, dynamic> _$ReplyToJson(Reply instance) => <String, dynamic>{
      'id': instance.id,
      'image': instance.image,
      'body': instance.body,
      'children_count': instance.childrenCount,
      'is_liked': instance.isLiked,
      'is_disliked': instance.isDisliked,
      'likes_count': instance.likesCount,
      'dislikes_count': instance.dislikesCount,
      'owner': instance.owner,
      'tweet': instance.tweet,
      'parent': instance.parent,
      'created_at': instance.createdAt?.toIso8601String(),
    };
