part of 'explore_bloc.dart';

abstract class ExploreEvent extends Equatable {
  const ExploreEvent();
}

class ExploreUser extends ExploreEvent {
  @override
  List<Object> get props => [];
}

class RefreshExplore extends ExploreEvent {
  @override
  List<Object> get props => [];
}
