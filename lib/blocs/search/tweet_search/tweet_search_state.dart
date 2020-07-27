part of 'tweet_search_bloc.dart';

class TweetSearchState {
  final bool isLoading;
  final List<Tweet> tweets;
  final bool hasError;

  const TweetSearchState({
    this.isLoading,
    this.tweets,
    this.hasError,
  });

  factory TweetSearchState.initial() {
    return TweetSearchState(
      tweets: [],
      isLoading: false,
      hasError: false,
    );
  }

  factory TweetSearchState.loading() {
    return TweetSearchState(
      tweets: [],
      isLoading: true,
      hasError: false,
    );
  }

  factory TweetSearchState.success(List<Tweet> tweets) {
    return TweetSearchState(
      tweets: tweets,
      isLoading: false,
      hasError: false,
    );
  }

  factory TweetSearchState.error() {
    return TweetSearchState(
      tweets: [],
      isLoading: false,
      hasError: true,
    );
  }

  @override
  String toString() =>
      'TweetSearchState {tweets: ${tweets.toString()}, isLoading: $isLoading, hasError: $hasError }';
}
