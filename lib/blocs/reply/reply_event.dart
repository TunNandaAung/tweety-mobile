part of 'reply_bloc.dart';

abstract class ReplyEvent extends Equatable {
  const ReplyEvent();
}

class FetchReply extends ReplyEvent {
  final int tweetID;

  FetchReply({@required this.tweetID});

  @override
  List<Object> get props => [tweetID];
}

class RefreshReply extends ReplyEvent {
  final int tweetID;

  RefreshReply({@required this.tweetID});

  @override
  List<Object> get props => [tweetID];
}

class AddReply extends ReplyEvent {
  final int tweetID;
  final String body;
  final File image;

  const AddReply({@required this.tweetID, @required this.body, this.image})
      : assert(body != null);

  @override
  List<Object> get props => [];
}
