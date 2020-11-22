import 'package:meta/meta.dart';
import 'package:tweety_mobile/models/chat_paginator.dart';
import 'package:tweety_mobile/models/message.dart';
import 'package:tweety_mobile/models/message_paginator.dart';
import 'package:tweety_mobile/services/chat_api_client.dart';

class ChatRepository {
  final ChatApiClient chatApiClient;

  ChatRepository({ChatApiClient chatApiClient})
      : chatApiClient = chatApiClient ?? ChatApiClient();

  Future<ChatPaginator> getChatList({int pageNumber}) async {
    return chatApiClient.fetchChatList(pageNumber);
  }

  Future<MessagePaginator> getMessages(
      {@required String chatId, int pageNumber}) async {
    return chatApiClient.fetchMessages(chatId, pageNumber);
  }

  Future<Message> sendMessage(
      {@required String chatId, @required String message}) {
    return chatApiClient.sendMessage(chatId, message);
  }
}
