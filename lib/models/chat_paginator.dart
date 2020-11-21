import 'package:json_annotation/json_annotation.dart';
import 'package:tweety_mobile/models/chat.dart';

part 'chat_paginator.g.dart';

@JsonSerializable()
class ChatPaginator {
  @JsonKey(name: 'current_page')
  int currentPage;

  @JsonKey(name: 'last_page')
  int lastPage;

  @JsonKey(name: 'data')
  List<Chat> chats;

  ChatPaginator({
    this.currentPage,
    this.lastPage,
    this.chats,
  });

  factory ChatPaginator.fromJson(Map<String, dynamic> json) =>
      _$ChatPaginatorFromJson(json);

  Map<String, dynamic> toJson() => _$ChatPaginatorToJson(this);
}
