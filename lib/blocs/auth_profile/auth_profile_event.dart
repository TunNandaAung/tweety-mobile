part of 'auth_profile_bloc.dart';

abstract class AuthProfileEvent extends Equatable {
  const AuthProfileEvent();
}

class FetchAuthProfile extends AuthProfileEvent {
  @override
  List<Object> get props => [];
}

class RefreshAuthProfile extends AuthProfileEvent {
  @override
  List<Object> get props => [];
}

class GetAvatar extends AuthProfileEvent {
  @override
  List<Object> get props => [];
}

class UpdateAuthProfileInfo extends AuthProfileEvent {
  final String name;
  final String username;
  final String description;
  final File avatar;
  final File banner;

  const UpdateAuthProfileInfo(
      {@required this.name,
      @required this.username,
      @required this.description,
      @required this.avatar,
      @required this.banner});

  @override
  List<Object> get props => [name, username, description, avatar, banner];

  @override
  String toString() {
    return 'UpdateAuthProfileInfo { name: $name, username: $username, description: $description }';
  }
}

class UpdateAuthProfileEmail extends AuthProfileEvent {
  final String password;
  final String email;

  const UpdateAuthProfileEmail({
    @required this.password,
    @required this.email,
  });

  @override
  List<Object> get props => [email, password];

  @override
  String toString() {
    return 'UpdateAuthProfileEMail { email: $email, password: $password}';
  }
}

class UpdateAuthProfilePassword extends AuthProfileEvent {
  final String oldPassword;
  final String newPassword;
  final String newPasswordConfirmation;

  const UpdateAuthProfilePassword({
    @required this.oldPassword,
    @required this.newPassword,
    @required this.newPasswordConfirmation,
  });

  @override
  List<Object> get props => [oldPassword, newPassword, newPasswordConfirmation];

  @override
  String toString() {
    return 'UpdateAuthProfilePassword { oldPassword: $oldPassword, newPassword: $newPassword, newPasswordConfirmation: $newPasswordConfirmation }';
  }
}

class UpdateAuthProfileImage extends AuthProfileEvent {
  final File image;

  const UpdateAuthProfileImage({
    @required this.image,
  });

  @override
  List<Object> get props => [image];
}

class RequestPasswordResetInfo extends AuthProfileEvent {
  final String email;

  const RequestPasswordResetInfo({
    @required this.email,
  });

  @override
  List<Object> get props => [email];
}

class ReloadAuthProfile extends AuthProfileEvent {
  final User user;

  const ReloadAuthProfile({@required this.user});

  @override
  List<Object> get props => [];
}
