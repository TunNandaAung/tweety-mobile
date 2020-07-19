import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tweety_mobile/models/user.dart';
import 'package:tweety_mobile/preferences/preferences.dart';
import 'package:tweety_mobile/repositories/user_repository.dart';
import 'package:meta/meta.dart';

part 'auth_profile_event.dart';
part 'auth_profile_state.dart';

class AuthProfileBloc extends Bloc<AuthProfileEvent, AuthProfileState> {
  final UserRepository userRepository;

  AuthProfileBloc({@required this.userRepository})
      : assert(userRepository != null),
        super(AuthProfileEmpty());

  @override
  Stream<AuthProfileState> mapEventToState(AuthProfileEvent event) async* {
    if (event is FetchAuthProfile) {
      yield* _mapFetchAuthProfileToState(event);
    } else if (event is RefreshAuthProfile) {
      yield* _mapRefreshAuthProfileToState(event);
    } else if (event is UpdateAuthProfileInfo) {
      yield* _mapUpdateAuthProfileInfoToState(event);
    } else if (event is UpdateAuthProfilePassword) {
      yield* _mapUpdateAuthProfilePasswordToState(event);
    } else if (event is UpdateAuthProfileEmail) {
      yield* _mapUpdateAuthProfileEmailToState(event);
    } else if (event is RequestPasswordResetInfo) {
      yield* _mapRequestPasswordResetInfoToState(event);
    } else if (event is GetAvatar) {
      yield* _mapGetAvatarToState(event);
    } else if (event is ReloadAuthProfile) {
      yield* _mapReloadAuthProfileToState(event);
    } else if (event is UpdateAuthProfileEmail) {
      yield* _mapUpdateAuthProfileEmailToState(event);
    }
  }

  Stream<AuthProfileState> _mapFetchAuthProfileToState(
      FetchAuthProfile event) async* {
    final currentState = state;
    yield AuthProfileLoading();
    if (currentState is AuthProfileLoaded) {
      yield AuthProfileLoaded(user: currentState.user);
    } else {
      try {
        final user = await userRepository.getAuthUserInfo();
        yield AuthProfileLoaded(user: user);
      } catch (_) {
        yield AuthProfileError();
      }
    }
  }

  // Stream<ProfileState> _mapFetchProfileToState(FetchProfile event) async* {
  //   yield ProfileLoading();
  //   try {
  //     final user = await userRepository.getUserInfo();
  //     yield ProfileLoaded(user: user);
  //   } catch (_) {
  //     yield ProfileError();
  //   }
  // }

  Stream<AuthProfileState> _mapRefreshAuthProfileToState(
      RefreshAuthProfile event) async* {
    yield AuthProfileLoading();
    try {
      final user = await userRepository.getAuthUserInfo();
      yield AuthProfileLoaded(user: user);
    } catch (_) {
      yield AuthProfileError();
    }
  }

  Stream<AuthProfileState> _mapReloadAuthProfileToState(
      ReloadAuthProfile event) async* {
    yield AuthProfileLoaded(user: event.user);
  }

  Stream<AuthProfileState> _mapUpdateAuthProfileInfoToState(
      UpdateAuthProfileInfo event) async* {
    yield AuthProfileInfoUpdating();
    try {
      final user = await userRepository.updateProfile(
          name: event.name,
          username: event.username,
          description: event.description,
          avatar: event.avatar,
          banner: event.banner);

      Prefer.prefs.remove('userName');
      Prefer.prefs.setString('userName', user.username);

      yield AuthProfileInfoUpdateSuccess(user: user);
    } catch (e) {
      yield AuthProfileErrorMessage(errorMessage: e.message);
    }
  }

  Stream<AuthProfileState> _mapUpdateAuthProfilePasswordToState(
      UpdateAuthProfilePassword event) async* {
    yield AuthProfilePasswordUpdating();
    try {
      String token = await userRepository.updatePassword(
          event.oldPassword, event.newPassword, event.newPasswordConfirmation);
      Prefer.prefs.remove('token');
      Prefer.prefs.setString('token', token);
      yield AuthProfilePasswordUpdateSuccess();
    } catch (e) {
      yield AuthProfileErrorMessage(errorMessage: e.message);
    }
  }

  Stream<AuthProfileState> _mapUpdateAuthProfileEmailToState(
      UpdateAuthProfileEmail event) async* {
    yield AuthProfileEmailUpdating();
    try {
      final user =
          await userRepository.updateEmail(event.password, event.email);
      yield AuthProfileInfoUpdateSuccess(user: user);
    } catch (e) {
      yield AuthProfileErrorMessage(errorMessage: e.message);
    }
  }

  Stream<AuthProfileState> _mapRequestPasswordResetInfoToState(event) async* {
    yield ResetPasswordRequestLoading();
    try {
      await userRepository.requestPasswordResetInfo(event.email);
      yield ResetPasswordRequestSuccess();
    } catch (e) {
      yield AuthProfileErrorMessage(errorMessage: e.message);
    }
  }

  Stream<AuthProfileState> _mapGetAvatarToState(event) async* {
    try {
      String avatar = await userRepository.getAvatar();
      yield AvatarLoaded(avatar: avatar);
    } catch (e) {
      yield state;
    }
  }
}
