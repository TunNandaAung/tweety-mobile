part of 'follow_bloc.dart';

abstract class FollowState extends Equatable {
  const FollowState();
  @override
  List<Object> get props => [];
}

class FollowInitial extends FollowState {}

class Followed extends FollowState {
  final User user;

  const Followed({required this.user});
}

class Unfollowed extends FollowState {
  final User user;

  const Unfollowed({required this.user});
}

class FollowError extends FollowState {}
