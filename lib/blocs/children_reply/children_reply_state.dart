part of 'children_reply_bloc.dart';

@immutable
abstract class ChildrenReplyState extends Equatable {
  const ChildrenReplyState();

  @override
  List<Object> get props => [];
}

class ChildrenReplyEmpty extends ChildrenReplyState {}

class ChildrenReplyLoading extends ChildrenReplyState {}

class ChildrenReplyLoaded extends ChildrenReplyState {
  final List<Reply> childrenReplies;
  final bool hasReachedMax;
  final int pageNumber;
  final int repliesLeft;

  const ChildrenReplyLoaded({
    @required this.childrenReplies,
    this.hasReachedMax,
    this.pageNumber = 1,
    this.repliesLeft,
  }) : assert(childrenReplies != null);

  ChildrenReplyLoaded copyWith({
    List<Reply> childrenReplies,
    bool hasReachedMax,
    int pageNumber,
    int repliesLeft,
    bool isLoading,
  }) {
    return ChildrenReplyLoaded(
      childrenReplies: childrenReplies ?? this.childrenReplies,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      pageNumber: pageNumber ?? this.pageNumber,
      repliesLeft: repliesLeft ?? this.repliesLeft,
    );
  }

  @override
  List<Object> get props =>
      [childrenReplies, hasReachedMax, pageNumber, this.repliesLeft];

  @override
  String toString() =>
      'ChildrenReplyLoaded { childrenReplies: ${childrenReplies.length}, hasReachedMax: $hasReachedMax }';
}

class ChildrenReplyError extends ChildrenReplyState {}

class ChildrenReplyAdding extends ChildrenReplyState {}

class ChildrenReplyAdded extends ChildrenReplyState {
  final Reply reply;

  const ChildrenReplyAdded({@required this.reply}) : assert(reply != null);

  @override
  List<Object> get props => [reply];

  @override
  String toString() => 'ChildrenReplyAdded';
}

class AddChildrenReplyError extends ChildrenReplyState {}

class ChildrenReplyDeleting extends ChildrenReplyState {}

class ChildrenReplyDeleted extends ChildrenReplyState {
  final count;

  ChildrenReplyDeleted({@required this.count});

  @override
  List<Object> get props => [count];
}

class DeleteChildrenReplyError extends ChildrenReplyState {}
