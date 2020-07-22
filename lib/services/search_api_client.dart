import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import 'package:tweety_mobile/constants/api_constants.dart';
import 'package:tweety_mobile/models/tweet.dart';
import 'package:tweety_mobile/preferences/preferences.dart';
import 'package:tweety_mobile/models/user.dart';

class SearchApiClient {
  static const baseUrl =
      ApiConstants.BASE_URL; //url generated with `valet share command`
  final http.Client httpClient;

  SearchApiClient({@required this.httpClient}) : assert(httpClient != null);

  Future<List<User>> searchUsers(String query) async {
    final url = '$baseUrl/search?type=user&q=$query';

    final token = Prefer.prefs.getString('token');

    final response = await this.httpClient.get(
          url,
          headers: requestHeaders(token),
        );
    print(response.statusCode);
    if (response.statusCode != 200) {
      throw Exception('Error getting users.');
    }

    final userJson = jsonDecode(response.body)['data'] as List;

    return userJson.map((user) => User.fromJson(user)).toList();
  }

  Future<List<Tweet>> searchTweets(String query) async {
    final url = '$baseUrl/search?type=tweet&q=$query';

    final token = Prefer.prefs.getString('token');

    final response = await this.httpClient.get(
          url,
          headers: requestHeaders(token),
        );
    print(response.statusCode);
    if (response.statusCode != 200) {
      throw Exception('Error getting tweets.');
    }

    final tweetJson = jsonDecode(response.body)['data'] as List;

    return tweetJson.map((tweet) => Tweet.fromJson(tweet)).toList();
  }
}
