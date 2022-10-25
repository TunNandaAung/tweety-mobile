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

  FollowBloc({this.followRepository}) : super(FollowInitial()) {
    on<FollowUser>(_onFollowUser);
    on<UnfollowUser>(_onUnfollowUser);
  }

  Future<void> _onFollowUser(
      FollowUser event, Emitter<FollowState> emit) async {
    try {
      final user = await followRepository.toggleFollow(event.user.username);
      emit(Followed(user: user));
    } catch (e) {
      emit(FollowError());
    }
  }

  Future<void> _onUnfollowUser(
      UnfollowUser event, Emitter<FollowState> emit) async {
    try {
      final user = await followRepository.toggleFollow(event.user.username);
      emit(Unfollowed(user: user));
    } catch (e) {
      emit(FollowError());
    }
  }
}
