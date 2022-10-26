part of 'auth_profile_bloc.dart';

abstract class AuthProfileState extends Equatable {
  const AuthProfileState();

  @override
  List<Object> get props => [];
}

class AvatarLoaded extends AuthProfileState {
  final String avatar;

  const AvatarLoaded({required this.avatar});

  @override
  List<Object> get props => [avatar];
}

class AuthProfileEmpty extends AuthProfileState {}

class AuthProfileLoading extends AuthProfileState {}

class AuthProfileLoaded extends AuthProfileState {
  final User user;

  const AuthProfileLoaded({required this.user});

  @override
  List<Object> get props => [user];
}

class AuthProfileError extends AuthProfileState {}

class AuthProfileInfoUpdateSuccess extends AuthProfileState {
  final User user;

  const AuthProfileInfoUpdateSuccess({required this.user});

  @override
  List<Object> get props => [user];
}

class AuthProfileInfoUpdating extends AuthProfileState {}

class AuthProfileEmailUpdating extends AuthProfileState {}

class AuthProfilePasswordUpdating extends AuthProfileState {}

class AuthProfilePasswordUpdateSuccess extends AuthProfileState {}

class AuthProfileErrorMessage extends AuthProfileState {
  final String errorMessage;

  const AuthProfileErrorMessage({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class ResetPasswordRequestLoading extends AuthProfileState {}

class ResetPasswordRequestSuccess extends AuthProfileState {}
