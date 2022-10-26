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

class PublishTweet extends TweetEvent {
  final String body;
  final File? image;

  const PublishTweet({required this.body, this.image});

  @override
  List<Object> get props => [];
}

class UpdateReplyCount extends TweetEvent {
  final int tweetID;
  final int count;

  UpdateReplyCount({required this.tweetID, required this.count});

  @override
  List<Object> get props => [];
}

class DeleteTweet extends TweetEvent {
  final int tweetID;

  DeleteTweet({required this.tweetID});

  @override
  List<Object> get props => [];
}
