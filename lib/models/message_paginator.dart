import 'package:json_annotation/json_annotation.dart';
import 'package:tweety_mobile/models/message.dart';

part 'message_paginator.g.dart';

@JsonSerializable()
class MessagePaginator {
  @JsonKey(name: 'current_page')
  int currentPage;

  @JsonKey(name: 'last_page')
  int lastPage;

  @JsonKey(name: 'data')
  List<Message> messages;

  MessagePaginator({
    this.currentPage,
    this.lastPage,
    this.messages,
  });

  factory MessagePaginator.fromJson(Map<String, dynamic> json) =>
      _$MessagePaginatorFromJson(json);

  Map<String, dynamic> toJson() => _$MessagePaginatorToJson(this);
}
