part of 'like_dislike_bloc.dart';

abstract class LikeDislikeState extends Equatable {
  const LikeDislikeState();
  @override
  List<Object> get props => [];
}

class LikeDislikeInitial extends LikeDislikeState {}

class Liked extends LikeDislikeState {
  final LikeDislike like;

  Liked({@required this.like});

  @override
  List<Object> get props => [like];
}

class Disliked extends LikeDislikeState {}

class RemoveLikeDislike extends LikeDislikeState {}

class LikeDislikeError extends LikeDislikeState {}
