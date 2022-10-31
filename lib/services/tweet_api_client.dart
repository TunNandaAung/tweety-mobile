import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';

import 'package:tweety_mobile/constants/api_constants.dart';
import 'package:tweety_mobile/models/tweet.dart';
import 'package:tweety_mobile/models/tweet_paginator.dart';
import 'package:tweety_mobile/preferences/preferences.dart';

class TweetApiClient {
  static const baseUrl = ApiConstants.BASE_URL;
  final http.Client httpClient;

  TweetApiClient({http.Client? httpClient})
      : httpClient = httpClient ?? http.Client();

  Future<TweetPaginator> fetchTweets(int pageNumber) async {
    final url = '$baseUrl/tweets?page=$pageNumber&page[number]=$pageNumber';

    final token = Prefer.prefs.getString('token');

    final response = await httpClient.get(
      Uri.parse(url),
      headers: requestHeaders(token!),
    );
    print(response.statusCode);
    if (response.statusCode != 200) {
      throw Exception('Error getting tweets.');
    }

    final tweetsJson = jsonDecode(response.body)['data'];

    return TweetPaginator.fromJson(tweetsJson);
  }

  Future<TweetPaginator> fetchUserTweets(
      String username, int pageNumber) async {
    final url =
        '$baseUrl/profiles/$username/tweets?page=$pageNumber&page[number]=$pageNumber';

    final token = Prefer.prefs.getString('token');

    final response = await httpClient.get(
      Uri.parse(url),
      headers: requestHeaders(token!),
    );
    print(response.statusCode);
    if (response.statusCode != 200) {
      throw Exception('Error getting tweets.');
    }

    final tweetsJson = jsonDecode(response.body)['data'];

    return TweetPaginator.fromJson(tweetsJson);
  }

  Future<Tweet> publishTweet(String body, {File? image}) async {
    const url = '$baseUrl/tweets';

    final token = Prefer.prefs.getString('token');

    final request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['body'] = body;

    if (image != null) {
      var stream = http.ByteStream(Stream.castFrom(image.openRead()));
      var length = await image.length();
      var multipartFile = MultipartFile("image", stream, length,
          filename: basename(image.path),
          contentType: MediaType('multipart', 'form-data'));
      request.files.add(multipartFile);
    }

    Map<String, String> authHeaders = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    request.headers.addAll(authHeaders);
    final res = await request.send();

    if (res.statusCode != 201) {
      var response = await http.Response.fromStream(res);
      print(response.body);
      throw Exception('Error publish tweets');
    }
    var response = await http.Response.fromStream(res);
    print(jsonDecode(response.body));

    final tweetJson = jsonDecode(response.body)['data'];
    print(Tweet.fromJson(tweetJson));

    return Tweet.fromJson(tweetJson);
  }

  Future<void> deleteTweet(int tweetID) async {
    final url = '$baseUrl/tweets/$tweetID';

    final token = Prefer.prefs.getString('token');

    final response = await httpClient.delete(
      Uri.parse(url),
      headers: requestHeaders(token!),
    );
    print(response.statusCode);
    if (response.statusCode != 200) {
      throw Exception('Error Deleting tweets.');
    }

    return;
  }
}
