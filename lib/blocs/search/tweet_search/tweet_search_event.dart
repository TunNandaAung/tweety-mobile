part of 'tweet_search_bloc.dart';

class TweetSearchEvent {
  final String query;

  const TweetSearchEvent(this.query);

  @override
  String toString() => 'TweetSearchEvent { query: $query }';
}
