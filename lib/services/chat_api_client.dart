import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tweety_mobile/constants/api_constants.dart';
import 'package:tweety_mobile/models/chat_paginator.dart';
import 'package:tweety_mobile/preferences/preferences.dart';

class ChatApiClient {
  static const baseUrl = ApiConstants.BASE_URL;
  final http.Client httpClient;

  ChatApiClient({http.Client httpClient})
      : httpClient = httpClient ?? http.Client();

  Future<ChatPaginator> fetchChatList(int pageNumber) async {
    final url = '$baseUrl/chat?page=$pageNumber';

    final token = Prefer.prefs.getString('token');

    final response = await this.httpClient.get(
          url,
          headers: requestHeaders(token),
        );
    print(response.statusCode);
    if (response.statusCode != 200) {
      throw Exception('Error getting chat list.');
    }

    final repliesJson = jsonDecode(response.body)['data'];

    return ChatPaginator.fromJson(repliesJson);
  }
}
