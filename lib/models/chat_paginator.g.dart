// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_paginator.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatPaginator _$ChatPaginatorFromJson(Map<String, dynamic> json) {
  return ChatPaginator(
    currentPage: json['current_page'] as int,
    lastPage: json['last_page'] as int,
    chats: (json['data'] as List)
        ?.map(
            (e) => e == null ? null : Chat.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ChatPaginatorToJson(ChatPaginator instance) =>
    <String, dynamic>{
      'current_page': instance.currentPage,
      'last_page': instance.lastPage,
      'data': instance.chats,
    };
