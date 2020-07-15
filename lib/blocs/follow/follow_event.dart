part of 'follow_bloc.dart';

abstract class FollowEvent extends Equatable {
  const FollowEvent();
}

class FollowUser extends FollowEvent {
  final User user;

  const FollowUser({
    @required this.user,
  });

  @override
  List<Object> get props => [user];

  @override
  String toString() {
    return 'FollowUser { User: $user }';
  }
}

class UnfollowUser extends FollowEvent {
  final User user;

  const UnfollowUser({
    @required this.user,
  });

  @override
  List<Object> get props => [user];

  @override
  String toString() {
    return 'UnfollowUser { User: $user }';
  }
}
