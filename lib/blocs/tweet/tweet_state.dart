part of 'tweet_bloc.dart';

abstract class TweetState extends Equatable {
  const TweetState();

  @override
  List<Object> get props => [];
}

class TweetEmpty extends TweetState {}

class TweetLoading extends TweetState {}

class TweetLoaded extends TweetState {
  final List<Tweet> tweets;
  final bool hasReachedMax;
  final int pageNumber;

  const TweetLoaded(
      {@required this.tweets, this.hasReachedMax, this.pageNumber = 1})
      : assert(tweets != null);

  TweetLoaded copyWith({
    List<Tweet> tweets,
    bool hasReachedMax,
    int pageNumber,
  }) {
    return TweetLoaded(
      tweets: tweets ?? this.tweets,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      pageNumber: pageNumber ?? this.pageNumber,
    );
  }

  @override
  List<Object> get props => [tweets, hasReachedMax, pageNumber];

  @override
  String toString() =>
      'TweetLoaded { tweets: ${tweets.length}, hasReachedMax: $hasReachedMax }';
}

class TweetError extends TweetState {}

class TweetPublishing extends TweetState {}

class TweetPublished extends TweetState {
  final Tweet tweet;

  const TweetPublished({@required this.tweet}) : assert(tweet != null);

  @override
  List<Object> get props => [tweet];
}

class PublishTweetError extends TweetState {}

class TweetDeleting extends TweetState {}

class TweetDeleted extends TweetState {}

class DeleteTweetError extends TweetState {}
