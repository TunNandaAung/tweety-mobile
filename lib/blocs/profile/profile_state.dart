part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class AvatarLoaded extends ProfileState {
  final String avatar;

  const AvatarLoaded({@required this.avatar});

  @override
  List<Object> get props => [avatar];
}

class ProfileEmpty extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final User user;

  const ProfileLoaded({@required this.user}) : assert(user != null);

  @override
  List<Object> get props => [user];
}

class ProfileError extends ProfileState {}

class ProfileInfoUpdateSuccess extends ProfileState {}

class ProfileInfoUpdating extends ProfileState {}

class ProfileEmailUpdating extends ProfileState {}

class ProfilePasswordUpdating extends ProfileState {}

class ProfilePasswordUpdateSuccess extends ProfileState {}

class ProfileErrorMessage extends ProfileState {
  final String errorMessage;

  const ProfileErrorMessage({@required this.errorMessage})
      : assert(errorMessage != null);

  @override
  List<Object> get props => [errorMessage];
}

class ResetPasswordRequestLoading extends ProfileState {}

class ResetPasswordRequestSuccess extends ProfileState {}
