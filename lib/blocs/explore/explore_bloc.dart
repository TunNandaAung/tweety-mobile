import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tweety_mobile/models/user.dart';
import 'package:tweety_mobile/repositories/user_repository.dart';

part 'explore_event.dart';
part 'explore_state.dart';

class ExploreBloc extends Bloc<ExploreEvent, ExploreState> {
  final UserRepository userRepository;
  ExploreBloc({@required this.userRepository}) : super(ExploreInitial());

  @override
  Stream<ExploreState> mapEventToState(
    ExploreEvent event,
  ) async* {
    if (event is ExploreUser) {
      yield* _mapExploreUserToState(event);
    }
    if (event is RefreshExplore) {
      yield* _mapRefreshExploreToState(event);
    }
  }

  Stream<ExploreState> _mapExploreUserToState(event) async* {
    final currentState = state;
    if (currentState is ExploreUserLoaded) {
      yield currentState;
    } else {
      yield ExploreUserLoading();
      try {
        final users = await userRepository.explore();
        yield ExploreUserLoaded(users: users);
      } catch (e) {
        yield ExploreError();
      }
    }
  }

  Stream<ExploreState> _mapRefreshExploreToState(event) async* {
    try {
      final users = await userRepository.explore();
      yield ExploreUserLoaded(users: users);
    } catch (_) {
      yield state;
    }
  }
}
