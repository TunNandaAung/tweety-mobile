import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tweety_mobile/models/user.dart';
import 'package:tweety_mobile/repositories/follow_repository.dart';

part 'followers_list_event.dart';
part 'followers_list_state.dart';

class FollowersListBloc extends Bloc<FollowersListEvent, FollowersListState> {
  final FollowRepository followRepository;

  FollowersListBloc({@required this.followRepository})
      : assert(followRepository != null),
        super(FollowersListEmpty());

  @override
  Stream<FollowersListState> mapEventToState(
    FollowersListEvent event,
  ) async* {
    if (event is FetchFollowersList) {
      yield* _mapFetchFollowersListToState(event);
    } else if (event is RefreshFollowersList) {
      yield* _mapRefreshFollowersListToState(event);
    }
  }

  Stream<FollowersListState> _mapFetchFollowersListToState(
      FetchFollowersList event) async* {
    final currentState = state;

    if (!_hasReachedMax(currentState)) {
      try {
        if (currentState is FollowersListEmpty) {
          final userPaginator = await followRepository.getFollowers(
              username: event.user.username, pageNumber: 1);

          yield FollowersListLoaded(
              users: userPaginator.users,
              hasReachedMax: userPaginator.lastPage == 1 ? true : false);
          return;
        }

        if (currentState is FollowersListLoaded) {
          var pageNumber = currentState.pageNumber + 1;
          final userPaginator = await followRepository.getFollowers(
              username: event.user.username, pageNumber: pageNumber);

          yield userPaginator.users.isEmpty
              ? currentState.copyWith(hasReachedMax: true)
              : FollowersListLoaded(
                  users: currentState.users + userPaginator.users,
                  hasReachedMax: false,
                  pageNumber: pageNumber,
                );
        }
      } catch (_) {
        yield FollowersListError();
      }
    }
  }

  bool _hasReachedMax(FollowersListState state) =>
      state is FollowersListLoaded && state.hasReachedMax;

  Stream<FollowersListState> _mapRefreshFollowersListToState(
      RefreshFollowersList event) async* {
    try {
      final userPaginator = await followRepository.getFollowers(
          username: event.user.username, pageNumber: 1);
      yield FollowersListLoaded(
          users: userPaginator.users,
          hasReachedMax: userPaginator.lastPage == 1 ? true : false);
      return;
    } catch (_) {
      yield state;
    }
  }
}
