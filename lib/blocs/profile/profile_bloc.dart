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

  ProfileBloc({@required this.userRepository})
      : assert(userRepository != null),
        super(ProfileInitial());

  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    if (event is FetchProfile) {
      yield* _mapFetchProfileToState(event);
    }
  }

  Stream<ProfileState> _mapFetchProfileToState(FetchProfile event) async* {
    yield ProfileLoading();
    try {
      final user = await userRepository.getUserInfo(event.username);
      yield ProfileLoaded(user: user);
    } catch (_) {
      yield ProfileError();
    }
  }
}
