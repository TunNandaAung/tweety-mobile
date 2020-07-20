part of 'followers_list_bloc.dart';

abstract class FollowersListEvent extends Equatable {
  const FollowersListEvent();
}

class FetchFollowersList extends FollowersListEvent {
  final User user;

  FetchFollowersList({@required this.user}) : assert(user != null);

  @override
  List<Object> get props => [];
}

class RefreshFollowersList extends FollowersListEvent {
  final User user;

  RefreshFollowersList({@required this.user}) : assert(user != null);

  @override
  List<Object> get props => [];
}
