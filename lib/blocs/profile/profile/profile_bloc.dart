import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tweety_mobile/models/user.dart';
import 'package:tweety_mobile/repositories/user_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository userRepository;

  ProfileBloc({this.userRepository}) : super(ProfileInitial()) {
    on<FetchProfile>(_onFetchProfileToState);
    on<RefreshProfile>(_onRefreshProfileToState);
  }

  bool _sameProfile(ProfileState state, username) =>
      state is ProfileLoaded && state.user.username == username;

  Future<void> _onFetchProfileToState(
      FetchProfile event, Emitter<ProfileState> emit) async {
    final currentState = state;

    if (!_sameProfile(currentState, event.username)) {
      emit(ProfileLoading());
      try {
        final user = await userRepository.getUserInfo(event.username);
        emit(ProfileLoaded(user: user));
      } catch (_) {
        emit(ProfileError());
      }
    } else {
      emit(currentState);
    }
  }

  Future<void> _onRefreshProfileToState(
      RefreshProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoaded(user: event.user));
  }
}
