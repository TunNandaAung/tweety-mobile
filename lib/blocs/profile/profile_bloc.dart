import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tweety_mobile/models/user.dart';
import 'package:tweety_mobile/preferences/preferences.dart';
import 'package:tweety_mobile/repositories/user_repository.dart';
import 'package:meta/meta.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository userRepository;

  ProfileBloc({@required this.userRepository})
      : assert(userRepository != null),
        super(ProfileEmpty());

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is FetchProfile) {
      yield* _mapFetchProfileToState(event);
    } else if (event is RefreshProfile) {
      yield* _mapRefreshProfileToState(event);
    } else if (event is UpdateProfileInfo) {
      yield* _mapUpdateProfileInfoToState(event);
    } else if (event is UpdateProfilePassword) {
      yield* _mapUpdateProfilePasswordToState(event);
    } else if (event is UpdateProfileEmail) {
      yield* _mapUpdateProfileEmailToState(event);
    } else if (event is UpdateProfileImage) {
      yield* _mapUpdateProfileImageToState(event);
    } else if (event is RequestPasswordResetInfo) {
      yield* _mapRequestPasswordResetInfoToState(event);
    } else if (event is GetAvatar) {
      yield* _mapGetAvatarToState(event);
    }
  }

  Stream<ProfileState> _mapFetchProfileToState(FetchProfile event) async* {
    final currentState = state;
    yield ProfileLoading();
    if (currentState is ProfileLoaded) {
      yield ProfileLoaded(user: currentState.user);
    } else {
      try {
        final user = await userRepository.getUserInfo();
        yield ProfileLoaded(user: user);
      } catch (_) {
        yield ProfileError();
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

  Stream<ProfileState> _mapRefreshProfileToState(RefreshProfile event) async* {
    yield ProfileLoading();
    try {
      final user = await userRepository.getUserInfo();
      yield ProfileLoaded(user: user);
    } catch (_) {
      yield ProfileError();
    }
  }

  Stream<ProfileState> _mapUpdateProfileInfoToState(
      UpdateProfileInfo event) async* {
    yield ProfileInfoUpdating();
    try {
      await userRepository.updateInfo(
          event.name, event.shopAddress, event.phone, event.shopName);
      yield ProfileInfoUpdateSuccess();
    } catch (_) {
      yield ProfileError();
    }
  }

  Stream<ProfileState> _mapUpdateProfilePasswordToState(
      UpdateProfilePassword event) async* {
    yield ProfilePasswordUpdating();
    try {
      String token = await userRepository.updatePassword(
          event.oldPassword, event.newPassword, event.newPasswordConfirmation);
      Prefer.prefs.remove('token');
      Prefer.prefs.setString('token', token);
      yield ProfilePasswordUpdateSuccess();
    } catch (e) {
      yield ProfileErrorMessage(errorMessage: e.message);
    }
  }

  Stream<ProfileState> _mapUpdateProfileEmailToState(
      UpdateProfileEmail event) async* {
    yield ProfileInfoUpdating();
    try {
      await userRepository.updateEmail(event.password, event.email);
      yield ProfileInfoUpdateSuccess();
    } catch (e) {
      yield ProfileErrorMessage(errorMessage: e.message);
    }
  }

  Stream<ProfileState> _mapUpdateProfileImageToState(
      UpdateProfileImage event) async* {
    yield ProfileInfoUpdating();
    try {
      await userRepository.updateImage(event.image);
      yield ProfileInfoUpdateSuccess();
    } catch (e) {
      yield ProfileErrorMessage(errorMessage: e.message);
    }
  }

  Stream<ProfileState> _mapRequestPasswordResetInfoToState(event) async* {
    yield ResetPasswordRequestLoading();
    try {
      await userRepository.requestPasswordResetInfo(event.email);
      yield ResetPasswordRequestSuccess();
    } catch (e) {
      yield ProfileErrorMessage(errorMessage: e.message);
    }
  }

  Stream<ProfileState> _mapGetAvatarToState(event) async* {
    try {
      String avatar = await userRepository.getAvatar();
      yield AvatarLoaded(avatar: avatar);
    } catch (e) {
      yield state;
    }
  }
}
