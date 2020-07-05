import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tweety_mobile/models/reply.dart';
import 'package:tweety_mobile/repositories/reply_repository.dart';

part 'reply_event.dart';
part 'reply_state.dart';

class ReplyBloc extends Bloc<ReplyEvent, ReplyState> {
  final ReplyRepository replyRepository;

  ReplyBloc({@required this.replyRepository})
      : assert(replyRepository != null),
        super(ReplyEmpty());

  @override
  Stream<ReplyState> mapEventToState(ReplyEvent event) async* {
    if (event is FetchReply) {
      yield* _mapFetchReplyToState(event);
    } else if (event is RefreshReply) {
      yield* _mapRefreshReplyToState(event);
    }
  }

  Stream<ReplyState> _mapFetchReplyToState(FetchReply event) async* {
    final currentState = state;

    if (!_hasReachedMax(currentState)) {
      try {
        if (currentState is ReplyEmpty) {
          final replyPaginator = await replyRepository.getReplies(
              tweetID: event.tweetID, pageNumber: 1);
          yield ReplyLoaded(
              replies: replyPaginator.replies,
              hasReachedMax: replyPaginator.lastPage == 1 ? true : false);
          return;
        }

        if (currentState is ReplyLoaded) {
          var pageNumber = currentState.pageNumber + 1;
          final replyPaginator = await replyRepository.getReplies(
              tweetID: event.tweetID, pageNumber: pageNumber);

          yield replyPaginator.replies.isEmpty
              ? ReplyLoaded(
                  replies: currentState.replies,
                  hasReachedMax: true,
                  pageNumber: currentState.pageNumber,
                )
              : ReplyLoaded(
                  replies: currentState.replies + replyPaginator.replies,
                  hasReachedMax: false,
                  pageNumber: pageNumber,
                );
        }
      } catch (_) {
        yield ReplyError();
      }
    }
  }

  bool _hasReachedMax(ReplyState state) =>
      state is ReplyLoaded && state.hasReachedMax;

  Stream<ReplyState> _mapRefreshReplyToState(RefreshReply event) async* {
    try {
      final replyPaginator = await replyRepository.getReplies(
          tweetID: event.tweetID, pageNumber: 1);
      yield ReplyLoaded(
          replies: replyPaginator.replies,
          hasReachedMax: replyPaginator.lastPage == 1 ? true : false);
      return;
    } catch (_) {
      yield state;
    }
  }
}
