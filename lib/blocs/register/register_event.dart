part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class Submitted extends RegisterEvent {
  final String name;
  final String username;
  final String email;
  final String password;
  final String passwordConfirmation;

  const Submitted({
    @required this.name,
    @required this.username,
    @required this.email,
    @required this.password,
    @required this.passwordConfirmation,
  });

  @override
  List<Object> get props =>
      [name, username, email, password, passwordConfirmation];

  @override
  String toString() {
    return 'Submitted { name:$name, username:$username, email: $email, password: $password, passwordConfirmation: $passwordConfirmation}';
  }
}

class UploadRegisterImages extends RegisterEvent {
  final File avatar;
  final File banner;

  const UploadRegisterImages({@required this.avatar, @required this.banner});

  @override
  List<Object> get props => [avatar, banner];

  @override
  String toString() {
    return 'UploadRegisterImages';
  }
}
