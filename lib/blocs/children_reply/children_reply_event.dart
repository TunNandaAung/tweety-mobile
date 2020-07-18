part of 'children_reply_bloc.dart';

@immutable
abstract class ChildrenReplyEvent extends Equatable {}

class FetchChildrenReply extends ChildrenReplyEvent {
  final int parentID;
  final int childrenCount;

  FetchChildrenReply({@required this.parentID, this.childrenCount});

  @override
  List<Object> get props => [];
}

class AddChildrenReply extends ChildrenReplyEvent {
  final int tweetID;
  final String body;
  final File image;
  final int parentID;

  AddChildrenReply(
      {@required this.tweetID, @required this.body, this.image, this.parentID})
      : assert(body != null);

  @override
  List<Object> get props => [];
}

class DeleteChildrenReply extends ChildrenReplyEvent {
  final Reply reply;

  DeleteChildrenReply({this.reply}) : assert(reply != null);

  @override
  List<Object> get props => [];
}
