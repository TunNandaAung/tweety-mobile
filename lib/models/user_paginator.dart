import 'package:json_annotation/json_annotation.dart';
import 'package:tweety_mobile/models/user.dart';

part 'user_paginator.g.dart';

@JsonSerializable()
class UserPaginator {
  @JsonKey(name: 'current_page')
  int currentPage;

  @JsonKey(name: 'last_page')
  int lastPage;

  @JsonKey(name: 'data')
  List<User> users;

  UserPaginator({
    this.currentPage,
    this.lastPage,
    this.users,
  });

  factory UserPaginator.fromJson(Map<String, dynamic> json) =>
      _$UserPaginatorFromJson(json);

  Map<String, dynamic> toJson() => _$UserPaginatorToJson(this);
}
