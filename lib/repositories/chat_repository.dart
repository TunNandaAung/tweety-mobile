import 'package:tweety_mobile/models/chat_paginator.dart';
import 'package:tweety_mobile/services/chat_api_client.dart';

class ChatRepository {
  final ChatApiClient chatApiClient;

  ChatRepository({ChatApiClient chatApiClient})
      : chatApiClient = chatApiClient ?? ChatApiClient();

  Future<ChatPaginator> fetchChatList({int pageNumber}) async {
    return chatApiClient.fetchChatList(pageNumber);
  }
}
