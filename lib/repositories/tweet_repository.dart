import 'package:meta/meta.dart';
import 'package:tweety_mobile/models/tweet_paginator.dart';
import 'package:tweety_mobile/services/tweet_api_client.dart';

class TweetRepository {
  final TweetApiClient tweetApiClient;

  TweetRepository({@required this.tweetApiClient})
      : assert(tweetApiClient != null);

  Future<TweetPaginator> getTweets(int pageNumber) async {
    return tweetApiClient.fetchTweets(pageNumber);
  }
}
