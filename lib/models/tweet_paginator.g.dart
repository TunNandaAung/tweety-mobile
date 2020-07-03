// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tweet_paginator.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TweetPaginator _$TweetPaginatorFromJson(Map<String, dynamic> json) {
  return TweetPaginator(
    currentPage: json['current_page'] as int,
    lastPage: json['last_page'] as int,
    tweets: (json['data'] as List)
        ?.map(
            (e) => e == null ? null : Tweet.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$TweetPaginatorToJson(TweetPaginator instance) =>
    <String, dynamic>{
      'current_page': instance.currentPage,
      'last_page': instance.lastPage,
      'data': instance.tweets,
    };
