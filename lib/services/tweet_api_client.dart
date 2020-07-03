import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tweety_mobile/constants/api_constants.dart';
import 'package:tweety_mobile/models/tweet_paginator.dart';
import 'package:tweety_mobile/preferences/preferences.dart';
import 'package:meta/meta.dart';

class TweetApiClient {
  static const baseUrl =
      ApiConstants.BASE_URL; //url generated with `valet share command`
  final http.Client httpClient;

  TweetApiClient({@required this.httpClient}) : assert(httpClient != null);

  Future<TweetPaginator> fetchTweets(int pageNumber) async {
    final url = '$baseUrl/tweets?page=$pageNumber&page[number]=$pageNumber';

    print(url);

    final token = Prefer.prefs.getString('token');

    final response = await this.httpClient.get(
          url,
          headers: requestHeaders(token),
        );
    print(response.statusCode);
    if (response.statusCode != 200) {
      throw Exception('Error getting tweets.');
    }

    final tweetsJson = jsonDecode(response.body)['data'];

    return TweetPaginator.fromJson(tweetsJson);
  }
}
