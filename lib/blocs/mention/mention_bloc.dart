import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:meta/meta.dart';

part 'mention_event.dart';
part 'mention_state.dart';

class MentionBloc extends Bloc<MentionEvent, MentionState> {
  MentionBloc() : super(MentionInitial());

  @override
  Stream<Transition<MentionEvent, MentionState>> transformEvents(
    Stream<MentionEvent> events,
    TransitionFunction<MentionEvent, MentionState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 300)),
      transitionFn,
    );
  }

  @override
  Stream<MentionState> mapEventToState(
    MentionEvent event,
  ) async* {
    if (event is FindMentionedUser) {
      yield* _mapFindMentionedUserToState(event);
    }
  }

  Stream<MentionState> _mapFindMentionedUserToState(
      FindMentionedUser event) async* {
    yield MentionUserLoading();
    try {
      await Future.delayed(Duration(milliseconds: 500));
      yield MentionUserLoaded(
          query: event.query,
          usernames: ['jane', 'john', 'saz', 'vader', 'jeffrey']);
    } catch (e) {
      yield MentionUserError();
    }
  }
}
