part of 'mention_bloc.dart';

abstract class MentionState extends Equatable {
  const MentionState();
  @override
  List<Object> get props => [];
}

class MentionInitial extends MentionState {}

class MentionUserLoading extends MentionState {}

class MentionUserError extends MentionState {}

class MentionUserLoaded extends MentionState {
  final String query;
  final List<User> users;

  const MentionUserLoaded({@required this.users, this.query});

  @override
  List<Object> get props => [users];
}
