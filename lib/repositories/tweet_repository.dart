import 'dart:io';

import 'package:meta/meta.dart';
import 'package:tweety_mobile/models/tweet.dart';
import 'package:tweety_mobile/models/tweet_paginator.dart';
import 'package:tweety_mobile/services/tweet_api_client.dart';

class TweetRepository {
  final TweetApiClient tweetApiClient;

  TweetRepository({@required this.tweetApiClient})
      : assert(tweetApiClient != null);

  Future<TweetPaginator> getTweets(int pageNumber) async {
    return tweetApiClient.fetchTweets(pageNumber);
  }

  Future<TweetPaginator> getUserTweets(
      {String username, int pageNumber}) async {
    return tweetApiClient.fetchUserTweets(username, pageNumber);
  }

  Future<Tweet> publishTweet(String body, {File image}) async {
    return tweetApiClient.publishTweet(body, image: image);
  }
}
