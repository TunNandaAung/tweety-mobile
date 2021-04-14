import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tweety_mobile/constants/api_constants.dart';
import 'package:tweety_mobile/models/chat.dart';
import 'package:tweety_mobile/models/chat_paginator.dart';
import 'package:tweety_mobile/models/message.dart';
import 'package:tweety_mobile/models/message_paginator.dart';
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
          Uri.parse(url),
          headers: requestHeaders(token),
        );
    if (response.statusCode != 200) {
      throw Exception('Error getting chat list.');
    }

    final chatListJson = jsonDecode(response.body)['data'];

    return ChatPaginator.fromJson(chatListJson);
  }

  Future<MessagePaginator> fetchMessages(String chatId, int pageNumber) async {
    final url = '$baseUrl/chat/$chatId/messages?page=$pageNumber';

    final token = Prefer.prefs.getString('token');

    final response = await this.httpClient.get(
          Uri.parse(url),
          headers: requestHeaders(token),
        );
    print(response.statusCode);
    if (response.statusCode != 200) {
      throw Exception('Error getting chat list.');
    }

    final messagesJson = jsonDecode(response.body)['data'];

    return MessagePaginator.fromJson(messagesJson);
  }

  Future<Message> sendMessage(String chatId, String message) async {
    final url = '$baseUrl/chat/$chatId/messages';

    final token = Prefer.prefs.getString('token');

    final response = await this.httpClient.post(
          Uri.parse(url),
          headers: requestHeaders(token),
          body: jsonEncode(
            <String, String>{'message': message},
          ),
        );

    if (response.statusCode != 201) {
      throw Exception('Error sending message');
    }

    return Message.fromJson(jsonDecode(response.body)['data']);
  }

  Future<void> markAsRead(String chatId, String username) async {
    final url = '$baseUrl/chat/$chatId/messages/$username/read';

    final token = Prefer.prefs.getString('token');

    await this.httpClient.patch(
          Uri.parse(url),
          headers: requestHeaders(token),
        );
  }

  Future<Chat> getChatRoom(String username) async {
    final url = '$baseUrl/chat/$username';

    final token = Prefer.prefs.getString('token');

    final response = await this.httpClient.get(
          Uri.parse(url),
          headers: requestHeaders(token),
        );
    print(response);
    if (response.statusCode != 200) {
      throw Exception('Error getting chat room!');
    }
    print(response.body);

    return Chat.fromJson(jsonDecode(response.body)['data']);
  }
}
