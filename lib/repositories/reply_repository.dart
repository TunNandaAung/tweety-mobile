import 'package:meta/meta.dart';
import 'package:tweety_mobile/models/reply_paginator.dart';
import 'package:tweety_mobile/services/reply_api_client.dart';

class ReplyRepository {
  final ReplyApiClient replyApiClient;

  ReplyRepository({@required this.replyApiClient})
      : assert(replyApiClient != null);

  Future<ReplyPaginator> getReplies({int tweetID, int pageNumber}) async {
    return replyApiClient.fetchReplies(tweetID, pageNumber);
  }

  Future<ReplyPaginator> getChildrenReplies(
      {int parentID, int pageNumber}) async {
    return replyApiClient.fetchChildrenReplies(parentID, pageNumber);
  }
}
