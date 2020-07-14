part of 'explore_bloc.dart';

abstract class ExploreState extends Equatable {
  const ExploreState();
  @override
  List<Object> get props => [];
}

class ExploreInitial extends ExploreState {}

class ExploreUserLoading extends ExploreState {}

class ExploreError extends ExploreState {}

class ExploreUserLoaded extends ExploreState {
  final List<User> users;

  const ExploreUserLoaded({@required this.users});

  @override
  List<Object> get props => [users];
}
