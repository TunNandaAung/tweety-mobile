import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tweety_mobile/repositories/user_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository userRepository;

  AuthenticationBloc({required this.userRepository})
      : super(AuthenticationInitial()) {
    on<AuthenticationStarted>(_onAuthenticationStarted);
    on<AuthenticationLoggedIn>(_onAuthenticationLoggedIn);
    on<AuthenticationLoggedOut>(_onAuthenticationLoggedOut);
  }

  Future<void> _onAuthenticationStarted(
      AuthenticationStarted event, Emitter<AuthenticationState> emit) async {
    final isSignedIn = await userRepository.isSignedIn();
    if (isSignedIn) {
      // final name = await userRepository.getUser();
      const name = 'Logged in';
      emit(const AuthenticationSuccess(name));
    } else {
      emit(AuthenticationFailure());
    }
  }

  Future<void> _onAuthenticationLoggedIn(
      AuthenticationLoggedIn event, Emitter<AuthenticationState> emit) async {
    // yield AuthenticationSuccess(await userRepository.getUser());
    emit(const AuthenticationSuccess("name"));
  }

  Future<void> _onAuthenticationLoggedOut(
      AuthenticationLoggedOut event, Emitter<AuthenticationState> emit) async {
    userRepository.logOut();
    emit(AuthenticationFailure());
  }
}
