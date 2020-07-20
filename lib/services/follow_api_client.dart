import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:tweety_mobile/constants/api_constants.dart';
import 'package:tweety_mobile/models/user.dart';
import 'package:tweety_mobile/models/user_paginator.dart';
import 'package:tweety_mobile/preferences/preferences.dart';

class FollowApiClient {
  static const baseUrl = ApiConstants.BASE_URL;
  final http.Client httpClient;

  FollowApiClient({@required this.httpClient}) : assert(httpClient != null);

  Future<User> toggleFollow(String username) async {
    final url = '$baseUrl/profiles/$username/follow';

    final token = Prefer.prefs.getString('token');

    final response = await this.httpClient.post(
          url,
          headers: requestHeaders(token),
        );
    print(response.statusCode);
    if (response.statusCode != 200) {
      throw Exception('Error following user.');
    }

    final userJson = jsonDecode(response.body)['data'];
    return User.fromJson(userJson);
  }

  Future<UserPaginator> fetchFollowing(String username, int pageNumber) async {
    final url =
        '$baseUrl/profiles/$username/following?page=$pageNumber&page[number]=$pageNumber';

    final token = Prefer.prefs.getString('token');

    final response = await this.httpClient.get(
          url,
          headers: requestHeaders(token),
        );
    print(response.statusCode);
    if (response.statusCode != 200) {
      throw Exception('Error getting following list.');
    }

    final usersJson = jsonDecode(response.body)['data'];

    return UserPaginator.fromJson(usersJson);
  }

  Future<UserPaginator> fetchFollowers(String username, int pageNumber) async {
    final url =
        '$baseUrl/profiles/$username/followers?page=$pageNumber&page[number]=$pageNumber';

    final token = Prefer.prefs.getString('token');

    final response = await this.httpClient.get(
          url,
          headers: requestHeaders(token),
        );
    print(response.statusCode);
    if (response.statusCode != 200) {
      throw Exception('Error getting followers list.');
    }

    final usersJson = jsonDecode(response.body)['data'];

    return UserPaginator.fromJson(usersJson);
  }
}
