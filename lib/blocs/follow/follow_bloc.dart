import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tweety_mobile/models/user.dart';
import 'package:tweety_mobile/repositories/follow_repository.dart';

part 'follow_event.dart';
part 'follow_state.dart';

class FollowBloc extends Bloc<FollowEvent, FollowState> {
  final FollowRepository followRepository;

  FollowBloc({@required this.followRepository})
      : assert(followRepository != null),
        super(FollowInitial());

  @override
  Stream<FollowState> mapEventToState(
    FollowEvent event,
  ) async* {
    if (event is FollowUser) {
      yield* _mapFollowUserToState(event);
    } else if (event is UnfollowUser) {
      yield* _mapUnfollowUserToState(event);
    }
  }

  Stream<FollowState> _mapFollowUserToState(FollowUser event) async* {
    try {
      final user = await followRepository.toggleFollow(event.user.username);
      yield Followed(user: user);
    } catch (e) {
      yield FollowError();
    }
  }

  Stream<FollowState> _mapUnfollowUserToState(UnfollowUser event) async* {
    try {
      final user = await followRepository.toggleFollow(event.user.username);
      yield Unfollowed(user: user);
    } catch (e) {
      yield FollowError();
    }
  }
}
