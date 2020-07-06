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
