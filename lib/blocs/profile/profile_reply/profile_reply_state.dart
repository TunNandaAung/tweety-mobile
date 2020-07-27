part of 'profile_reply_bloc.dart';

abstract class ProfileReplyState extends Equatable {
  const ProfileReplyState();

  @override
  List<Object> get props => [];
}

class ProfileReplyInitial extends ProfileReplyState {}

class ProfileReplyLoading extends ProfileReplyState {}

class ProfileReplyLoaded extends ProfileReplyState {
  final List<Reply> replies;
  final bool hasReachedMax;
  final int pageNumber;

  const ProfileReplyLoaded(
      {@required this.replies, this.hasReachedMax, this.pageNumber = 1})
      : assert(replies != null);

  ProfileReplyLoaded copyWith({
    List<Reply> replies,
    bool hasReachedMax,
    int pageNumber,
  }) {
    return ProfileReplyLoaded(
      replies: replies ?? this.replies,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      pageNumber: pageNumber ?? this.pageNumber,
    );
  }

  @override
  List<Object> get props => [replies, hasReachedMax, pageNumber];

  @override
  String toString() =>
      'ProfileReplyLoaded { replies: ${replies.length}, hasReachedMax: $hasReachedMax }';
}

class ProfileReplyError extends ProfileReplyState {}
