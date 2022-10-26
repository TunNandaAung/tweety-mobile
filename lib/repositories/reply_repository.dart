import 'dart:io';

import 'package:tweety_mobile/models/reply.dart';
import 'package:tweety_mobile/models/reply_paginator.dart';
import 'package:tweety_mobile/services/reply_api_client.dart';

class ReplyRepository {
  final ReplyApiClient replyApiClient;

  ReplyRepository({ReplyApiClient? replyApiClient})
      : replyApiClient = replyApiClient ?? ReplyApiClient();

  Future<ReplyPaginator> getReplies(
      {required int tweetID, required int pageNumber}) async {
    return replyApiClient.fetchReplies(tweetID, pageNumber);
  }

  Future<Reply> getReply({required int replyID}) async {
    return replyApiClient.fetchReply(replyID);
  }

  Future<ReplyPaginator> getChildrenReplies(
      {required int parentID, required int pageNumber}) async {
    return replyApiClient.fetchChildrenReplies(parentID, pageNumber);
  }

  Future<Reply> addReply(int tweetID, String body, {File? image}) async {
    return replyApiClient.addReply(tweetID, body, image: image);
  }

  Future<Reply> addChildren(int tweetID, String body,
      {File? image, int? parentID}) async {
    return replyApiClient.addReply(tweetID, body,
        image: image, parentID: parentID);
  }

  Future<void> deleteReply(int replyID) async {
    return replyApiClient.deleteReply(replyID);
  }

  Future<ReplyPaginator> getUserReplies(
      {required String username, required int pageNumber}) async {
    return replyApiClient.fetchUserReplies(username, pageNumber);
  }
}
