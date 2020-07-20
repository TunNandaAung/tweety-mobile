part of 'followers_list_bloc.dart';

abstract class FollowersListState extends Equatable {
  const FollowersListState();

  @override
  List<Object> get props => [];
}

class FollowersListEmpty extends FollowersListState {}

class FollowersListLoading extends FollowersListState {}

class FollowersListLoaded extends FollowersListState {
  final List<User> users;
  final bool hasReachedMax;
  final int pageNumber;

  const FollowersListLoaded(
      {@required this.users, this.hasReachedMax, this.pageNumber = 1})
      : assert(users != null);

  FollowersListLoaded copyWith({
    List<User> users,
    bool hasReachedMax,
    int pageNumber,
  }) {
    return FollowersListLoaded(
      users: users ?? this.users,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      pageNumber: pageNumber ?? this.pageNumber,
    );
  }

  @override
  List<Object> get props => [users, hasReachedMax, pageNumber];

  @override
  String toString() =>
      'FollowersLoaded { user: ${users.length}, hasReachedMax: $hasReachedMax }';
}

class FollowersListError extends FollowersListState {}
