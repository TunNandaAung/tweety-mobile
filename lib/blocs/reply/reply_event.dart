part of 'reply_bloc.dart';

abstract class ReplyEvent extends Equatable {
  const ReplyEvent();
}

class FetchReply extends ReplyEvent {
  final int tweetID;

  FetchReply({@required this.tweetID});

  @override
  List<Object> get props => [];
}

class RefreshReply extends ReplyEvent {
  final int tweetID;

  RefreshReply({@required this.tweetID});

  @override
  List<Object> get props => [];
}
