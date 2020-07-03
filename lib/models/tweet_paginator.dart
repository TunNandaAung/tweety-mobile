import 'package:json_annotation/json_annotation.dart';
import 'package:tweety_mobile/models/tweet.dart';

part 'tweet_paginator.g.dart';

@JsonSerializable()
class TweetPaginator {
  @JsonKey(name: 'current_page')
  int currentPage;

  @JsonKey(name: 'last_page')
  int lastPage;

  @JsonKey(name: 'data')
  List<Tweet> tweets;

  TweetPaginator({
    this.currentPage,
    this.lastPage,
    this.tweets,
  });

  factory TweetPaginator.fromJson(Map<String, dynamic> json) =>
      _$TweetPaginatorFromJson(json);

  Map<String, dynamic> toJson() => _$TweetPaginatorToJson(this);
}
