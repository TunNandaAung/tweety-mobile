import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tweety_mobile/models/user.dart';
import 'package:tweety_mobile/repositories/follow_repository.dart';

part 'following_list_event.dart';
part 'following_list_state.dart';

class FollowingListBloc extends Bloc<FollowingListEvent, FollowingListState> {
  final FollowRepository followRepository;

  FollowingListBloc({required this.followRepository})
      : super(FollowingListEmpty()) {
    on<FetchFollowingList>(_onFetchFollowingList);
    on<RefreshFollowingList>(_onRefreshFollowingList);
  }

  Future<void> _onFetchFollowingList(
      FetchFollowingList event, Emitter<FollowingListState> emit) async {
    final currentState = state;

    if (!_hasReachedMax(currentState)) {
      try {
        if (currentState is FollowingListEmpty) {
          final userPaginator = await followRepository.getFollowing(
              username: event.user.username, pageNumber: 1);

          return emit(FollowingListLoaded(
              users: userPaginator.users,
              hasReachedMax: userPaginator.lastPage == 1 ? true : false));
        }

        if (currentState is FollowingListLoaded) {
          var pageNumber = currentState.pageNumber + 1;
          final userPaginator = await followRepository.getFollowing(
              username: event.user.username, pageNumber: pageNumber);

          emit(userPaginator.users.isEmpty
              ? currentState.copyWith(hasReachedMax: true)
              : FollowingListLoaded(
                  users: currentState.users + userPaginator.users,
                  hasReachedMax: false,
                  pageNumber: pageNumber,
                ));
        }
      } catch (_) {
        emit(FollowingListError());
      }
    }
  }

  bool _hasReachedMax(FollowingListState state) =>
      state is FollowingListLoaded && state.hasReachedMax;

  Future<void> _onRefreshFollowingList(
      RefreshFollowingList event, Emitter<FollowingListState> emit) async {
    try {
      final userPaginator = await followRepository.getFollowing(
          username: event.user.username, pageNumber: 1);
      return emit(FollowingListLoaded(
        users: userPaginator.users,
        hasReachedMax: userPaginator.lastPage == 1 ? true : false,
      ));
    } catch (_) {
      emit(state);
    }
  }
}
