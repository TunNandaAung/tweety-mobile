import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tweety_mobile/models/user.dart';
import 'package:tweety_mobile/repositories/user_repository.dart';

part 'explore_event.dart';
part 'explore_state.dart';

class ExploreBloc extends Bloc<ExploreEvent, ExploreState> {
  final UserRepository userRepository;
  ExploreBloc({required this.userRepository}) : super(ExploreInitial()) {
    on<ExploreUser>(_onExploreUser);
    on<RefreshExplore>(_onRefreshExplore);
  }

  Future<void> _onExploreUser(
      ExploreUser event, Emitter<ExploreState> emit) async {
    final currentState = state;
    if (currentState is ExploreUserLoaded) {
      emit(currentState);
    } else {
      emit(ExploreUserLoading());
      try {
        final users = await userRepository.explore();
        emit(ExploreUserLoaded(users: users));
      } catch (e) {
        emit(ExploreError());
      }
    }
  }

  Future<void> _onRefreshExplore(
      RefreshExplore event, Emitter<ExploreState> emit) async {
    try {
      final users = await userRepository.explore();
      emit(ExploreUserLoaded(users: users));
    } catch (_) {
      emit(state);
    }
  }
}
