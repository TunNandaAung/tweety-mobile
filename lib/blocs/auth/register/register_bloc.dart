import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tweety_mobile/models/auth.dart';
import 'package:tweety_mobile/preferences/preferences.dart';
import 'package:tweety_mobile/repositories/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final UserRepository userRepository;

  RegisterBloc({required this.userRepository}) : super(RegisterInitial()) {
    on<Submitted>(_onSubmitted);
    on<UploadRegisterImages>(_onUploadRegisterImages);
  }

  Future<void> _onSubmitted(
      Submitted event, Emitter<RegisterState> emit) async {
    emit(RegisterLoading());
    try {
      final Auth auth = await userRepository.register(
        event.name,
        event.username,
        event.email,
        event.password,
        event.passwordConfirmation,
      );
      storeUserData(auth.token, auth.userID, auth.username);
      emit(RegisterSuccess());
    } catch (e) {
      emit(RegisterFailureMessage(errorMessage: e.toString()));
    }
  }

  Future<void> _onUploadRegisterImages(
      UploadRegisterImages event, Emitter<RegisterState> emit) async {
    emit(RegisterImagesUploading());
    try {
      await userRepository.uploadImages(
          avatar: event.avatar, banner: event.banner);
      emit(RegisterImagesSuccess());
    } catch (e) {
      emit(RegisterError());
    }
  }

  void storeUserData(String token, int userID, String username) async {
    Prefer.prefs = await SharedPreferences.getInstance();
    Prefer.prefs.setString('token', token);
    Prefer.prefs.setInt('userID', userID);
    Prefer.prefs.setString('username', username);
  }
}
