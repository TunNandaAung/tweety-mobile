part of 'reply_bloc.dart';

abstract class ReplyEvent extends Equatable {
  const ReplyEvent();
}

class FetchReply extends ReplyEvent {
  final int tweetID;

  const FetchReply({required this.tweetID});

  @override
  List<Object> get props => [tweetID];
}

class FetchSingleReply extends ReplyEvent {
  final int replyID;

  const FetchSingleReply({required this.replyID});

  @override
  List<Object> get props => [replyID];
}

class RefreshReply extends ReplyEvent {
  final int tweetID;

  const RefreshReply({required this.tweetID});

  @override
  List<Object> get props => [tweetID];
}

class AddReply extends ReplyEvent {
  final int tweetID;
  final String body;
  final File? image;

  const AddReply({required this.tweetID, required this.body, this.image});

  @override
  List<Object> get props => [];
}

class DeleteReply extends ReplyEvent {
  final Reply reply;

  const DeleteReply({required this.reply});

  @override
  List<Object> get props => [];
}
