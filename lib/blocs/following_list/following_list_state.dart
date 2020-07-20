part of 'following_list_bloc.dart';

abstract class FollowingListState extends Equatable {
  const FollowingListState();

  @override
  List<Object> get props => [];
}

class FollowingListEmpty extends FollowingListState {}

class FollowingListLoading extends FollowingListState {}

class FollowingListLoaded extends FollowingListState {
  final List<User> users;
  final bool hasReachedMax;
  final int pageNumber;

  const FollowingListLoaded(
      {@required this.users, this.hasReachedMax, this.pageNumber = 1})
      : assert(users != null);

  FollowingListLoaded copyWith({
    List<User> users,
    bool hasReachedMax,
    int pageNumber,
  }) {
    return FollowingListLoaded(
      users: users ?? this.users,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      pageNumber: pageNumber ?? this.pageNumber,
    );
  }

  @override
  List<Object> get props => [users, hasReachedMax, pageNumber];

  @override
  String toString() =>
      'FollowingLoaded { user: ${users.length}, hasReachedMax: $hasReachedMax }';
}

class FollowingListError extends FollowingListState {}
