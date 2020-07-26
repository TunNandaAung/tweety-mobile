part of 'profile_reply_bloc.dart';

abstract class ProfileReplyEvent extends Equatable {
  const ProfileReplyEvent();
}

class FetchProfileReply extends ProfileReplyEvent {
  final String username;

  const FetchProfileReply({@required this.username});

  @override
  List<Object> get props => [];
}

class RefreshProfileReply extends ProfileReplyEvent {
  final String username;

  const RefreshProfileReply({@required this.username});
  @override
  List<Object> get props => [];
}
