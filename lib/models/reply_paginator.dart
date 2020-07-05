import 'package:json_annotation/json_annotation.dart';
import 'package:tweety_mobile/models/reply.dart';

part 'reply_paginator.g.dart';

@JsonSerializable()
class ReplyPaginator {
  @JsonKey(name: 'current_page')
  int currentPage;

  @JsonKey(name: 'last_page')
  int lastPage;

  @JsonKey(name: 'data')
  List<Reply> replies;

  ReplyPaginator({
    this.currentPage,
    this.lastPage,
    this.replies,
  });

  factory ReplyPaginator.fromJson(Map<String, dynamic> json) =>
      _$ReplyPaginatorFromJson(json);

  Map<String, dynamic> toJson() => _$ReplyPaginatorToJson(this);
}
