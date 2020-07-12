part of 'like_dislike_bloc.dart';

abstract class LikeDislikeEvent extends Equatable {
  const LikeDislikeEvent();
}

class Like extends LikeDislikeEvent {
  final int tweetID;
  final String subject;

  const Like({
    @required this.tweetID,
    @required this.subject,
  });
  @override
  List<Object> get props => [tweetID];
}

class Dislike extends LikeDislikeEvent {
  final int tweetID;
  final String subject;

  const Dislike({
    @required this.tweetID,
    @required this.subject,
  });
  @override
  List<Object> get props => [tweetID];
}
