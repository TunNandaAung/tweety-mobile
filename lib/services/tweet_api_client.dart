import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'package:meta/meta.dart';

import 'package:tweety_mobile/constants/api_constants.dart';
import 'package:tweety_mobile/models/tweet.dart';
import 'package:tweety_mobile/models/tweet_paginator.dart';
import 'package:tweety_mobile/preferences/preferences.dart';

class TweetApiClient {
  static const baseUrl = ApiConstants.BASE_URL;
  final http.Client httpClient;

  TweetApiClient({@required this.httpClient}) : assert(httpClient != null);

  Future<TweetPaginator> fetchTweets(int pageNumber) async {
    final url = '$baseUrl/tweets?page=$pageNumber&page[number]=$pageNumber';

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

  Future<TweetPaginator> fetchUserTweets(
      String username, int pageNumber) async {
    final url =
        '$baseUrl/profiles/$username/tweets?page=$pageNumber&page[number]=$pageNumber';

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

  Future<Tweet> publishTweet(String body, {File image}) async {
    final url = '$baseUrl/tweets';

    final token = Prefer.prefs.getString('token');

    final request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['body'] = body;

    if (image != null) {
      var stream = new http.ByteStream(Stream.castFrom(image.openRead()));
      var length = await image.length();
      var multipartFile = new MultipartFile("image", stream, length,
          filename: basename(image.path),
          contentType: MediaType('multipart', 'form-data'));
      request.files.add(multipartFile);
    }

    Map<String, String> _headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    request.headers.addAll(_headers);
    final response = await request.send();

    if (response.statusCode != 201) {
      var _response = await http.Response.fromStream(response);
      print(_response.body);
      throw Exception('Error publish tweets');
    }
    var _response = await http.Response.fromStream(response);
    print(jsonDecode(_response.body));

    final tweetJson = jsonDecode(_response.body)['data'];
    print(Tweet.fromJson(tweetJson));

    return Tweet.fromJson(tweetJson);
  }

  Future<void> deleteTweet(int tweetID) async {
    final url = '$baseUrl/tweets/$tweetID';

    final token = Prefer.prefs.getString('token');

    final response = await this.httpClient.delete(
          url,
          headers: requestHeaders(token),
        );
    print(response.statusCode);
    if (response.statusCode != 200) {
      throw Exception('Error Deleting tweets.');
    }

    return;
  }
}
