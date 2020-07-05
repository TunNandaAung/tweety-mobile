// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reply_paginator.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReplyPaginator _$ReplyPaginatorFromJson(Map<String, dynamic> json) {
  return ReplyPaginator(
    currentPage: json['current_page'] as int,
    lastPage: json['last_page'] as int,
    replies: (json['data'] as List)
        ?.map(
            (e) => e == null ? null : Reply.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ReplyPaginatorToJson(ReplyPaginator instance) =>
    <String, dynamic>{
      'current_page': instance.currentPage,
      'last_page': instance.lastPage,
      'data': instance.replies,
    };
