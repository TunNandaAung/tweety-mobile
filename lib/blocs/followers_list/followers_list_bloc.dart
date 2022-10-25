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

  FollowersListBloc({this.followRepository}) : super(FollowersListEmpty()) {
    on<FetchFollowersList>(_onFetchFollowersList);
    on<RefreshFollowersList>(_onRefreshFollowersList);
  }

  Future<void> _onFetchFollowersList(
      FetchFollowersList event, Emitter<FollowersListState> emit) async {
    final currentState = state;

    if (!_hasReachedMax(currentState)) {
      try {
        if (currentState is FollowersListEmpty) {
          final userPaginator = await followRepository.getFollowers(
              username: event.user.username, pageNumber: 1);

          return emit(FollowersListLoaded(
            users: userPaginator.users,
            hasReachedMax: userPaginator.lastPage == 1 ? true : false,
          ));
        }

        if (currentState is FollowersListLoaded) {
          var pageNumber = currentState.pageNumber + 1;
          final userPaginator = await followRepository.getFollowers(
              username: event.user.username, pageNumber: pageNumber);

          emit(
            userPaginator.users.isEmpty
                ? currentState.copyWith(hasReachedMax: true)
                : FollowersListLoaded(
                    users: currentState.users + userPaginator.users,
                    hasReachedMax: false,
                    pageNumber: pageNumber,
                  ),
          );
        }
      } catch (_) {
        emit(FollowersListError());
      }
    }
  }

  bool _hasReachedMax(FollowersListState state) =>
      state is FollowersListLoaded && state.hasReachedMax;

  Future<void> _onRefreshFollowersList(
      RefreshFollowersList event, Emitter<FollowersListState> emit) async {
    try {
      final userPaginator = await followRepository.getFollowers(
          username: event.user.username, pageNumber: 1);
      return emit(
        FollowersListLoaded(
            users: userPaginator.users,
            hasReachedMax: userPaginator.lastPage == 1 ? true : false),
      );
    } catch (_) {
      emit(state);
    }
  }
}
