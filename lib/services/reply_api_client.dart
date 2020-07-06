import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tweety_mobile/constants/api_constants.dart';
import 'package:tweety_mobile/models/reply_paginator.dart';
import 'package:tweety_mobile/preferences/preferences.dart';
import 'package:meta/meta.dart';

class ReplyApiClient {
  static const baseUrl = ApiConstants.BASE_URL;
  final http.Client httpClient;

  ReplyApiClient({@required this.httpClient}) : assert(httpClient != null);

  Future<ReplyPaginator> fetchReplies(int tweetID, int pageNumber) async {
    final url =
        '$baseUrl/tweets/$tweetID/replies?page=$pageNumber&page[number]=$pageNumber';

    final token = Prefer.prefs.getString('token');

    final response = await this.httpClient.get(
          url,
          headers: requestHeaders(token),
        );
    print(response.statusCode);
    if (response.statusCode != 200) {
      throw Exception('Error getting replies.');
    }

    final repliesJson = jsonDecode(response.body)['data'];

    return ReplyPaginator.fromJson(repliesJson);
  }

  Future<ReplyPaginator> fetchChildrenReplies(
      int parentID, int pageNumber) async {
    final url =
        '$baseUrl/replies/$parentID/children/json?page=$pageNumber&page[number]=$pageNumber';

    final token = Prefer.prefs.getString('token');

    final response = await this.httpClient.get(
          url,
          headers: requestHeaders(token),
        );
    print(response.statusCode);
    if (response.statusCode != 200) {
      throw Exception('Error getting replies.');
    }

    final repliesJson = jsonDecode(response.body)['data'];

    return ReplyPaginator.fromJson(repliesJson);
  }
}
