part of 'login_bloc.dart';

@immutable
class LoginState {
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;
  final bool isPasswordResetMailSent;
  final bool isPasswordResetFailure;

  bool get isFormValid => isEmailValid && isPasswordValid;

  LoginState(
      {@required this.isEmailValid,
      @required this.isPasswordValid,
      @required this.isSubmitting,
      @required this.isSuccess,
      @required this.isFailure,
      @required this.isPasswordResetMailSent,
      @required this.isPasswordResetFailure});

  factory LoginState.empty() {
    return LoginState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      isPasswordResetMailSent: false,
      isPasswordResetFailure: false,
    );
  }

  factory LoginState.loading() {
    return LoginState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
      isPasswordResetMailSent: false,
      isPasswordResetFailure: false,
    );
  }

  factory LoginState.failure() {
    return LoginState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
      isPasswordResetMailSent: false,
      isPasswordResetFailure: false,
    );
  }

  factory LoginState.success() {
    return LoginState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
      isPasswordResetMailSent: false,
      isPasswordResetFailure: false,
    );
  }

  factory LoginState.passwordResetMailSent() {
    return LoginState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      isPasswordResetMailSent: true,
      isPasswordResetFailure: false,
    );
  }

  factory LoginState.passwordResetFailure() {
    return LoginState(
        isEmailValid: true,
        isPasswordValid: true,
        isSubmitting: false,
        isSuccess: false,
        isFailure: false,
        isPasswordResetMailSent: false,
        isPasswordResetFailure: true);
  }

  LoginState update({
    bool isEmailValid,
    bool isPasswordValid,
  }) {
    return copyWith(
      isEmailValid: isEmailValid,
      isPasswordValid: isPasswordValid,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      isPasswordResetMailSent: false,
      isPasswordResetFailure: false,
    );
  }

  LoginState copyWith(
      {bool isEmailValid,
      bool isPasswordValid,
      bool isSubmitEnabled,
      bool isSubmitting,
      bool isSuccess,
      bool isFailure,
      bool isPasswordResetFailure,
      bool isPasswordResetMailSent}) {
    return LoginState(
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
      isPasswordResetMailSent:
          isPasswordResetMailSent ?? this.isPasswordResetMailSent,
      isPasswordResetFailure:
          isPasswordResetFailure ?? this.isPasswordResetFailure,
    );
  }

  @override
  String toString() {
    return '''LoginState {
      isEmailValid: $isEmailValid,
      isPasswordValid: $isPasswordValid,
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      isFailure: $isFailure,
      isPasswordResetMailSent: $isPasswordResetMailSent
      isPasswordResetFailure: $isPasswordResetFailure
    }''';
  }
}
