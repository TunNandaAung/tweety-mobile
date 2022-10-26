part of 'following_list_bloc.dart';

abstract class FollowingListEvent extends Equatable {
  const FollowingListEvent();
}

class FetchFollowingList extends FollowingListEvent {
  final User user;

  FetchFollowingList({required this.user});

  @override
  List<Object> get props => [];
}

class RefreshFollowingList extends FollowingListEvent {
  final User user;

  RefreshFollowingList({required this.user});

  @override
  List<Object> get props => [];
}
