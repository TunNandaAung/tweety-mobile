import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tweety_mobile/models/auth.dart';
import 'package:tweety_mobile/preferences/preferences.dart';
import 'package:tweety_mobile/repositories/user_repository.dart';
import 'package:tweety_mobile/utils/helpers.dart';
import 'package:tweety_mobile/utils/validators.dart';

part 'login_event.dart';
part 'login_state.dart';

const throttleDuration = Duration(milliseconds: 500);

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository userRepository;

  LoginBloc({
    this.userRepository,
  }) : super(LoginState.empty()) {
    on<EmailChanged>(
      _onEmailChanged,
      transformer: throttleDroppable(throttleDuration),
    );
    on<PasswordChanged>(
      _onPasswordChanged,
      transformer: throttleDroppable(throttleDuration),
    );
    on<ForgotPasswordPressed>(_onForgotPasswordPressed);
    on<LoginWithCredentialsPressed>(_onLoginWithCredentialsPressed);
  }

  Future<void> _onEmailChanged(
      EmailChanged event, Emitter<LoginState> emit) async {
    emit(state.update(
      isEmailValid: Validators.isValidEmail(event.email),
    ));
  }

  Future<void> _onPasswordChanged(
      PasswordChanged event, Emitter<LoginState> emit) async {
    emit(state.update(
      isPasswordValid: Validators.isValidPassword(event.password),
    ));
  }

  Future<void> _onForgotPasswordPressed(
      ForgotPasswordPressed event, Emitter<LoginState> emit) async {
    try {
      // await _userRepository.resetPassword(email);
      emit(LoginState.passwordResetMailSent());
    } catch (_) {
      emit(LoginState.passwordResetFailure());
    }
  }

  Future<void> _onLoginWithCredentialsPressed(
      LoginWithCredentialsPressed event, Emitter<LoginState> emit) async {
    emit(LoginState.loading());
    try {
      final Auth auth = await userRepository.loginWithCredentials(
          event.email, event.password);
      storeUserData(auth.token, auth.userID, auth.username);
      emit(LoginState.success());
    } catch (_) {
      emit(LoginState.failure());
    }
  }

  void storeUserData(String token, int userID, String name) async {
    Prefer.prefs = await SharedPreferences.getInstance();
    Prefer.prefs.setString('token', token);
    Prefer.prefs.setInt('userID', userID);
    Prefer.prefs.setString('username', name);
  }
}
