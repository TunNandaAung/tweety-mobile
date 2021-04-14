import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'package:tweety_mobile/constants/api_constants.dart';
import 'package:tweety_mobile/models/reply.dart';
import 'package:tweety_mobile/models/reply_paginator.dart';
import 'package:tweety_mobile/preferences/preferences.dart';

class ReplyApiClient {
  static const baseUrl = ApiConstants.BASE_URL;
  final http.Client httpClient;

  ReplyApiClient({http.Client httpClient})
      : httpClient = httpClient ?? http.Client();

  Future<ReplyPaginator> fetchReplies(int tweetID, int pageNumber) async {
    final url =
        '$baseUrl/tweets/$tweetID/replies?page=$pageNumber&page[number]=$pageNumber';

    final token = Prefer.prefs.getString('token');

    final response = await this.httpClient.get(
          Uri.parse(url),
          headers: requestHeaders(token),
        );
    print(response.statusCode);
    if (response.statusCode != 200) {
      throw Exception('Error getting replies.');
    }

    final repliesJson = jsonDecode(response.body)['data'];

    return ReplyPaginator.fromJson(repliesJson);
  }

  Future<Reply> fetchReply(int replyID) async {
    final url = '$baseUrl/reply/$replyID';

    final token = Prefer.prefs.getString('token');

    final response = await this.httpClient.get(
          Uri.parse(url),
          headers: requestHeaders(token),
        );
    print(response.statusCode);
    if (response.statusCode != 200) {
      throw Exception('Error getting reply.');
    }

    final replyJson = jsonDecode(response.body)['data'];

    return Reply.fromJson(replyJson);
  }

  Future<ReplyPaginator> fetchUserReplies(
      String username, int pageNumber) async {
    final url =
        '$baseUrl/profiles/$username/replies?page=$pageNumber&page[number]=$pageNumber';

    final token = Prefer.prefs.getString('token');

    final response = await this.httpClient.get(
          Uri.parse(url),
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
          Uri.parse(url),
          headers: requestHeaders(token),
        );
    print(response.statusCode);
    if (response.statusCode != 200) {
      throw Exception('Error getting replies.');
    }

    final repliesJson = jsonDecode(response.body)['data'];

    return ReplyPaginator.fromJson(repliesJson);
  }

  Future<Reply> addReply(int tweetID, String body,
      {File image, int parentID}) async {
    final url = '$baseUrl/tweets/$tweetID/reply';

    final request = await prepareRequest(body, image, parentID, url);
    final response = await request.send();

    if (response.statusCode != 201) {
      var _response = await http.Response.fromStream(response);
      print(_response.body);
      throw Exception('Error adding reply');
    }
    var _response = await http.Response.fromStream(response);
    print(_response.body);

    final replyJson = jsonDecode(_response.body)['data'];

    return Reply.fromJson(replyJson);
  }

  Future<MultipartRequest> prepareRequest(
      String body, File image, int parentID, url) async {
    final token = Prefer.prefs.getString('token');

    final request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['body'] = body;

    if (parentID != null) {
      request.fields['parent_id'] = parentID.toString();
    }

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
    return request;
  }

  Future<void> deleteReply(int replyID) async {
    final url = '$baseUrl/replies/$replyID';

    final token = Prefer.prefs.getString('token');

    final response = await this.httpClient.delete(
          Uri.parse(url),
          headers: requestHeaders(token),
        );
    print(response.statusCode);
    if (response.statusCode != 200) {
      throw Exception('Error Deleting replies.');
    }

    return;
  }
}
