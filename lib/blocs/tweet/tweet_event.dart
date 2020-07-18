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
  final File image;

  const PublishTweet({@required this.body, this.image}) : assert(body != null);

  @override
  List<Object> get props => [];
}

class UpdateReplyCount extends TweetEvent {
  final int tweetID;
  final int count;

  UpdateReplyCount({this.tweetID, this.count});

  @override
  List<Object> get props => [];
}

class DeleteTweet extends TweetEvent {
  final int tweetID;

  DeleteTweet({this.tweetID});

  @override
  List<Object> get props => [];
}
