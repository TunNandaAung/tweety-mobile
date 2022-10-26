part of 'children_reply_bloc.dart';

@immutable
abstract class ChildrenReplyEvent extends Equatable {}

class FetchChildrenReply extends ChildrenReplyEvent {
  final int parentID;
  final int childrenCount;

  FetchChildrenReply({required this.parentID, required this.childrenCount});

  @override
  List<Object> get props => [];
}

class AddChildrenReply extends ChildrenReplyEvent {
  final int tweetID;
  final String body;
  final File? image;
  final int? parentID;

  AddChildrenReply({
    required this.tweetID,
    required this.body,
    this.image,
    this.parentID,
  });

  @override
  List<Object> get props => [];
}

class DeleteChildrenReply extends ChildrenReplyEvent {
  final Reply reply;

  DeleteChildrenReply({required this.reply});

  @override
  List<Object> get props => [];
}
