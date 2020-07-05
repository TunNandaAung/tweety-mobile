part of 'tweet_bloc.dart';

abstract class TweetEvent extends Equatable {
  const TweetEvent();
}

class FetchTweet extends TweetEvent {
  @override
  List<Object> get props => [];
}

class RefreshTweet extends TweetEvent {
  @override
  List<Object> get props => [];
}
