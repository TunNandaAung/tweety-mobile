part of 'followers_list_bloc.dart';

abstract class FollowersListEvent extends Equatable {
  const FollowersListEvent();
}

class FetchFollowersList extends FollowersListEvent {
  final User user;

  const FetchFollowersList({required this.user});

  @override
  List<Object> get props => [];
}

class RefreshFollowersList extends FollowersListEvent {
  final User user;

  const RefreshFollowersList({required this.user});

  @override
  List<Object> get props => [];
}
