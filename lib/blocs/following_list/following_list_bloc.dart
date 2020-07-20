import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tweety_mobile/models/user.dart';
import 'package:tweety_mobile/repositories/follow_repository.dart';

part 'following_list_event.dart';
part 'following_list_state.dart';

class FollowingListBloc extends Bloc<FollowingListEvent, FollowingListState> {
  final FollowRepository followRepository;

  FollowingListBloc({@required this.followRepository})
      : assert(followRepository != null),
        super(FollowingListEmpty());

  @override
  Stream<FollowingListState> mapEventToState(
    FollowingListEvent event,
  ) async* {
    if (event is FetchFollowingList) {
      yield* _mapFetchFollowingListToState(event);
    } else if (event is RefreshFollowingList) {
      yield* _mapRefreshFollowingListToState(event);
    }
  }

  Stream<FollowingListState> _mapFetchFollowingListToState(
      FetchFollowingList event) async* {
    final currentState = state;

    if (!_hasReachedMax(currentState)) {
      try {
        if (currentState is FollowingListEmpty) {
          final userPaginator = await followRepository.getFollowing(
              username: event.user.username, pageNumber: 1);

          yield FollowingListLoaded(
              users: userPaginator.users,
              hasReachedMax: userPaginator.lastPage == 1 ? true : false);
          return;
        }

        if (currentState is FollowingListLoaded) {
          var pageNumber = currentState.pageNumber + 1;
          final userPaginator = await followRepository.getFollowing(
              username: event.user.username, pageNumber: pageNumber);

          yield userPaginator.users.isEmpty
              ? currentState.copyWith(hasReachedMax: true)
              : FollowingListLoaded(
                  users: currentState.users + userPaginator.users,
                  hasReachedMax: false,
                  pageNumber: pageNumber,
                );
        }
      } catch (_) {
        yield FollowingListError();
      }
    }
  }

  bool _hasReachedMax(FollowingListState state) =>
      state is FollowingListLoaded && state.hasReachedMax;

  Stream<FollowingListState> _mapRefreshFollowingListToState(
      RefreshFollowingList event) async* {
    try {
      final userPaginator = await followRepository.getFollowing(
          username: event.user.username, pageNumber: 1);
      yield FollowingListLoaded(
          users: userPaginator.users,
          hasReachedMax: userPaginator.lastPage == 1 ? true : false);
      return;
    } catch (_) {
      yield state;
    }
  }
}
