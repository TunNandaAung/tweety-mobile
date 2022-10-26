import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tweety_mobile/models/user.dart';
import 'package:tweety_mobile/preferences/preferences.dart';
import 'package:tweety_mobile/repositories/user_repository.dart';

part 'auth_profile_event.dart';
part 'auth_profile_state.dart';

class AuthProfileBloc extends Bloc<AuthProfileEvent, AuthProfileState> {
  final UserRepository userRepository;

  AuthProfileBloc({required this.userRepository}) : super(AuthProfileEmpty()) {
    on<FetchAuthProfile>(_onFetchAuthProfile);
    on<RefreshAuthProfile>(_onRefreshAuthProfile);
    on<UpdateAuthProfileInfo>(_onUpdateAuthProfileInfo);
    on<UpdateAuthProfilePassword>(_onUpdateAuthProfilePassword);
    on<UpdateAuthProfileEmail>(_onUpdateAuthProfileEmail);
    on<RequestPasswordResetInfo>(_onRequestPasswordResetInfo);
    on<GetAvatar>(_onGetAvatar);
    on<ReloadAuthProfile>(_onReloadAuthProfile);
    on<UpdateAuthProfileEmail>(_onUpdateAuthProfileEmail);
  }

  Future<void> _onFetchAuthProfile(
      FetchAuthProfile event, Emitter<AuthProfileState> emit) async {
    final currentState = state;
    emit(AuthProfileLoading());
    if (currentState is AuthProfileLoaded) {
      emit(AuthProfileLoaded(user: currentState.user));
    } else {
      try {
        final user = await userRepository.getAuthUserInfo();
        emit(AuthProfileLoaded(user: user));
      } catch (_) {
        emit(AuthProfileError());
      }
    }
  }

  // Stream<ProfileState> _onFetchProfileToState(FetchProfile {
  //   emit(ProfileLoading());
  //   try {
  //     final user = await userRepository.getUserInfo();
  //     emit(ProfileLoaded(user: user));
  //   } catch (_) {
  //     emit(ProfileError());
  //   }
  // }

  Future<void> _onRefreshAuthProfile(
      RefreshAuthProfile event, Emitter<AuthProfileState> emit) async {
    emit(AuthProfileLoading());
    try {
      final user = await userRepository.getAuthUserInfo();
      emit(AuthProfileLoaded(user: user));
    } catch (_) {
      emit(AuthProfileError());
    }
  }

  Future<void> _onReloadAuthProfile(
      ReloadAuthProfile event, Emitter<AuthProfileState> emit) async {
    emit(AuthProfileLoaded(user: event.user));
  }

  Future<void> _onUpdateAuthProfileInfo(
      UpdateAuthProfileInfo event, Emitter<AuthProfileState> emit) async {
    emit(AuthProfileInfoUpdating());
    try {
      final user = await userRepository.updateProfile(
        name: event.name,
        username: event.username,
        description: event.description,
        avatar: event.avatar,
        banner: event.banner,
      );

      Prefer.prefs.remove('username');
      Prefer.prefs.setString('username', user.username);

      emit(AuthProfileInfoUpdateSuccess(user: user));
    } catch (e) {
      emit(AuthProfileErrorMessage(errorMessage: e.toString()));
    }
  }

  Future<void> _onUpdateAuthProfilePassword(
      UpdateAuthProfilePassword event, Emitter<AuthProfileState> emit) async {
    emit(AuthProfilePasswordUpdating());
    try {
      String token = await userRepository.updatePassword(
          event.oldPassword, event.newPassword, event.newPasswordConfirmation);
      Prefer.prefs.remove('token');
      Prefer.prefs.setString('token', token);
      emit(AuthProfilePasswordUpdateSuccess());
    } catch (e) {
      emit(AuthProfileErrorMessage(errorMessage: e.toString()));
    }
  }

  Future<void> _onUpdateAuthProfileEmail(
      UpdateAuthProfileEmail event, Emitter<AuthProfileState> emit) async {
    emit(AuthProfileEmailUpdating());
    try {
      final user =
          await userRepository.updateEmail(event.password, event.email);
      emit(AuthProfileInfoUpdateSuccess(user: user));
    } catch (e) {
      emit(AuthProfileErrorMessage(errorMessage: e.toString()));
    }
  }

  Future<void> _onRequestPasswordResetInfo(
      RequestPasswordResetInfo event, Emitter<AuthProfileState> emit) async {
    emit(ResetPasswordRequestLoading());
    try {
      await userRepository.requestPasswordResetInfo(event.email);
      emit(ResetPasswordRequestSuccess());
    } catch (e) {
      emit(AuthProfileErrorMessage(errorMessage: e.toString()));
    }
  }

  Future<void> _onGetAvatar(
      GetAvatar event, Emitter<AuthProfileState> emit) async {
    try {
      String avatar = await userRepository.getAvatar();
      emit(AvatarLoaded(avatar: avatar));
    } catch (e) {
      emit(state);
    }
  }
}
