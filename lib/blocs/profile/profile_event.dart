part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
}

class FetchProfile extends ProfileEvent {
  @override
  List<Object> get props => [];
}

class RefreshProfile extends ProfileEvent {
  @override
  List<Object> get props => [];
}

class GetAvatar extends ProfileEvent {
  @override
  List<Object> get props => [];
}

class UpdateProfileInfo extends ProfileEvent {
  final String name;
  final String shopAddress;
  final String phone;
  final String shopName;

  const UpdateProfileInfo({
    @required this.name,
    @required this.shopAddress,
    @required this.phone,
    @required this.shopName,
  });

  @override
  List<Object> get props => [name, shopAddress, phone, shopName];

  @override
  String toString() {
    return 'UpdateProfileInfo { name: $name, shopAddress: $shopAddress, phone: $phone, shopName: $shopName }';
  }
}

class UpdateProfileEmail extends ProfileEvent {
  final String password;
  final String email;

  const UpdateProfileEmail({
    @required this.password,
    @required this.email,
  });

  @override
  List<Object> get props => [email, password];

  @override
  String toString() {
    return 'UpdateProfileEMail { email: $email, password: $password}';
  }
}

class UpdateProfilePassword extends ProfileEvent {
  final String oldPassword;
  final String newPassword;
  final String newPasswordConfirmation;

  const UpdateProfilePassword({
    @required this.oldPassword,
    @required this.newPassword,
    @required this.newPasswordConfirmation,
  });

  @override
  List<Object> get props => [oldPassword, newPassword, newPasswordConfirmation];

  @override
  String toString() {
    return 'UpdateProfilePassword { oldPassword: $oldPassword, newPassword: $newPassword, newPasswordConfirmation: $newPasswordConfirmation }';
  }
}

class UpdateProfileImage extends ProfileEvent {
  final File image;

  const UpdateProfileImage({
    @required this.image,
  });

  @override
  List<Object> get props => [image];
}

class RequestPasswordResetInfo extends ProfileEvent {
  final String email;

  const RequestPasswordResetInfo({
    @required this.email,
  });

  @override
  List<Object> get props => [email];
}
