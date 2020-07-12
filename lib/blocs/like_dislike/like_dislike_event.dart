part of 'like_dislike_bloc.dart';

abstract class LikeDislikeEvent extends Equatable {
  const LikeDislikeEvent();
}

class LikeTweet extends LikeDislikeEvent {
  final int tweetID;

  const LikeTweet({
    @required this.tweetID,
  });
  @override
  List<Object> get props => [tweetID];
}

class DislikeTweet extends LikeDislikeEvent {
  final int tweetID;

  const DislikeTweet({
    @required this.tweetID,
  });
  @override
  List<Object> get props => [tweetID];
}
