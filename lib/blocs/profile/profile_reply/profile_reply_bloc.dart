import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tweety_mobile/models/reply.dart';
import 'package:tweety_mobile/repositories/reply_repository.dart';

part 'profile_reply_event.dart';
part 'profile_reply_state.dart';

class ProfileReplyBloc extends Bloc<ProfileReplyEvent, ProfileReplyState> {
  final ReplyRepository replyRepository;

  ProfileReplyBloc({@required this.replyRepository})
      : assert(replyRepository != null),
        super(ProfileReplyInitial());

  @override
  Stream<Transition<ProfileReplyEvent, ProfileReplyState>> transformEvents(
    Stream<ProfileReplyEvent> events,
    TransitionFunction<ProfileReplyEvent, ProfileReplyState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<ProfileReplyState> mapEventToState(ProfileReplyEvent event) async* {
    if (event is FetchProfileReply) {
      yield* _mapFetchProfileReplyToState(event);
    } else if (event is RefreshProfileReply) {
      yield* _mapRefreshProfileReplyToState(event);
    }
  }

  Stream<ProfileReplyState> _mapFetchProfileReplyToState(
      FetchProfileReply event) async* {
    final currentState = state;

    if (!_hasReachedMax(currentState)) {
      try {
        if (currentState is ProfileReplyInitial) {
          final replyPaginator = await replyRepository.getUserReplies(
              username: event.username, pageNumber: 1);
          yield ProfileReplyLoaded(
              replies: replyPaginator.replies,
              hasReachedMax: replyPaginator.lastPage == 1 ? true : false);
          return;
        }

        if (currentState is ProfileReplyLoaded) {
          var pageNumber = currentState.pageNumber + 1;
          final replyPaginator = await replyRepository.getUserReplies(
              username: event.username, pageNumber: pageNumber);

          yield replyPaginator.replies.isEmpty
              ? ProfileReplyLoaded(
                  replies: currentState.replies,
                  hasReachedMax: true,
                  pageNumber: currentState.pageNumber,
                )
              : ProfileReplyLoaded(
                  replies: currentState.replies + replyPaginator.replies,
                  hasReachedMax: false,
                  pageNumber: pageNumber,
                );
        }
      } catch (_) {
        yield ProfileReplyError();
      }
    }
  }

  bool _hasReachedMax(ProfileReplyState state) =>
      state is ProfileReplyLoaded && state.hasReachedMax;

  Stream<ProfileReplyState> _mapRefreshProfileReplyToState(
      RefreshProfileReply event) async* {
    try {
      final replyPaginator = await replyRepository.getUserReplies(
          username: event.username, pageNumber: 1);
      yield ProfileReplyLoaded(
          replies: replyPaginator.replies,
          hasReachedMax: replyPaginator.lastPage == 1 ? true : false);
      return;
    } catch (_) {
      yield state;
    }
  }
}
