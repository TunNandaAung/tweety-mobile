// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_paginator.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessagePaginator _$MessagePaginatorFromJson(Map<String, dynamic> json) =>
    MessagePaginator(
      currentPage: json['current_page'] as int,
      lastPage: json['last_page'] as int,
      messages: (json['data'] as List<dynamic>)
          .map((e) => Message.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MessagePaginatorToJson(MessagePaginator instance) =>
    <String, dynamic>{
      'current_page': instance.currentPage,
      'last_page': instance.lastPage,
      'data': instance.messages,
    };
