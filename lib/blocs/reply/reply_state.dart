part of 'reply_bloc.dart';

abstract class ReplyState extends Equatable {
  const ReplyState();

  @override
  List<Object> get props => [];
}

class ReplyEmpty extends ReplyState {}

class ReplyLoading extends ReplyState {}

class ReplyLoaded extends ReplyState {
  final List<Reply> replies;
  final bool hasReachedMax;
  final int pageNumber;

  const ReplyLoaded(
      {@required this.replies, this.hasReachedMax, this.pageNumber = 1})
      : assert(replies != null);

  ReplyLoaded copyWith({
    List<Reply> replies,
    bool hasReachedMax,
    int pageNumber,
  }) {
    return ReplyLoaded(
      replies: replies ?? this.replies,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      pageNumber: pageNumber ?? this.pageNumber,
    );
  }

  @override
  List<Object> get props => [replies, hasReachedMax, pageNumber];

  @override
  String toString() =>
      'ReplyLoaded { replies: ${replies.length}, hasReachedMax: $hasReachedMax }';
}

class ReplyError extends ReplyState {}

class ReplyAdding extends ReplyState {}

class ReplyAdded extends ReplyState {
  final Reply reply;

  const ReplyAdded({@required this.reply}) : assert(reply != null);

  @override
  List<Object> get props => [reply];

  @override
  String toString() => 'ReplyAdded';
}

class AddReplyError extends ReplyState {}

class ReplyDeleting extends ReplyState {}

class ReplyDeleted extends ReplyState {
  final count;

  ReplyDeleted({@required this.count});

  @override
  List<Object> get props => [count];
}

class DeleteReplyError extends ReplyState {}

class SingleReplyLoading extends ReplyState {}

class SingleReplyLoaded extends ReplyState {
  final Reply reply;

  const SingleReplyLoaded({@required this.reply}) : assert(reply != null);

  @override
  List<Object> get props => [reply];
}

class SingleReplyError extends ReplyState {}
