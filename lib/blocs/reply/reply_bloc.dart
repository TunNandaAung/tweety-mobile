import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
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
  Stream<Transition<ReplyEvent, ReplyState>> transformEvents(
    Stream<ReplyEvent> events,
    TransitionFunction<ReplyEvent, ReplyState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<ReplyState> mapEventToState(ReplyEvent event) async* {
    if (event is FetchReply) {
      yield* _mapFetchReplyToState(event);
    } else if (event is RefreshReply) {
      yield* _mapRefreshReplyToState(event);
    } else if (event is AddReply) {
      yield* _mapAddReplyToState(event);
    } else if (event is DeleteReply) {
      yield* _mapDeleteReplyToState(event);
    } else if (event is FetchSingleReply) {
      yield* _mapFetchSingleReplyToState(event);
    }
  }

  Stream<ReplyState> _mapFetchReplyToState(FetchReply event) async* {
    final currentState = state;
    if (!_hasReachedMax(currentState, event)) {
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

  bool _hasReachedMax(ReplyState state, FetchReply event) {
    return state is ReplyLoaded && state.hasReachedMax;
  }

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

  Stream<ReplyState> _mapAddReplyToState(AddReply event) async* {
    final currentState = state;
    try {
      final reply = await replyRepository.addReply(event.tweetID, event.body,
          image: event.image);
      if (currentState is ReplyLoaded) {
        final List<Reply> updatedReplies = List.from(currentState.replies)
          ..add(reply);

        yield ReplyAdded(reply: reply);
        yield currentState.copyWith(replies: updatedReplies);
      } else
        yield ReplyAdded(reply: reply);
    } catch (e) {
      yield AddReplyError();
    }
    // yield AddReplyError();
  }

  Stream<ReplyState> _mapDeleteReplyToState(DeleteReply event) async* {
    final currentState = state;
    if (currentState is ReplyLoaded) {
      try {
        await replyRepository.deleteReply(event.reply.id);

        final List<Reply> updatedReplies =
            _removeReply(currentState.replies, event);

        // yield TweetLoading();
        yield ReplyDeleted(count: event.reply.childrenCount + 1);
        yield currentState.copyWith(
          replies: updatedReplies,
        );
      } catch (e) {
        yield DeleteReplyError();
        yield currentState;
      }
    }
  }

  List<Reply> _removeReply(List<Reply> repies, DeleteReply event) {
    return repies.where((reply) => reply.id != event.reply.id).toList();
  }

  Stream<ReplyState> _mapFetchSingleReplyToState(
      FetchSingleReply event) async* {
    yield SingleReplyLoading();
    try {
      final reply = await replyRepository.getReply(replyID: event.replyID);
      yield SingleReplyLoaded(reply: reply);
    } catch (e) {
      yield SingleReplyError();
    }
  }
}
