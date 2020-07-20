// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_paginator.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserPaginator _$UserPaginatorFromJson(Map<String, dynamic> json) {
  return UserPaginator(
    currentPage: json['current_page'] as int,
    lastPage: json['last_page'] as int,
    users: (json['data'] as List)
        ?.map(
            (e) => e == null ? null : User.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$UserPaginatorToJson(UserPaginator instance) =>
    <String, dynamic>{
      'current_page': instance.currentPage,
      'last_page': instance.lastPage,
      'data': instance.users,
    };
