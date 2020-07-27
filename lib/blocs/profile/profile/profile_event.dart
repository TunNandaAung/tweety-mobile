part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
}

class FetchProfile extends ProfileEvent {
  final String username;

  const FetchProfile({@required this.username});

  @override
  List<Object> get props => [username];
}

class RefreshProfile extends ProfileEvent {
  final User user;

  const RefreshProfile({@required this.user});

  @override
  List<Object> get props => [];
}
