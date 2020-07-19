import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tweety_mobile/models/reply.dart';
import 'package:tweety_mobile/repositories/reply_repository.dart';

part 'children_reply_event.dart';
part 'children_reply_state.dart';

class ChildrenReplyBloc extends Bloc<ChildrenReplyEvent, ChildrenReplyState> {
  final ReplyRepository replyRepository;

  ChildrenReplyBloc({@required this.replyRepository})
      : assert(replyRepository != null),
        super(ChildrenReplyEmpty());

  @override
  Stream<ChildrenReplyState> mapEventToState(
    ChildrenReplyEvent event,
  ) async* {
    if (event is FetchChildrenReply) {
      yield* _mapFetchChildrenReplyToState(event);
    } else if (event is AddChildrenReply) {
      yield* _mapAddChildrenReplyToState(event);
    } else if (event is DeleteChildrenReply) {
      yield* _mapDeleteChildrenReplyToState(event);
    }
  }

  bool _hasChildrenReachedMax(ChildrenReplyState state) {
    return state is ChildrenReplyLoaded && state.hasReachedMax;
  }

  Stream<ChildrenReplyState> _mapFetchChildrenReplyToState(
      FetchChildrenReply event) async* {
    final currentState = state;
    if (!_hasChildrenReachedMax(currentState)) {
      try {
        if (currentState is ChildrenReplyEmpty) {
          yield ChildrenReplyLoading();

          final replyPaginator = await replyRepository.getChildrenReplies(
              parentID: event.parentID, pageNumber: 1);

          yield ChildrenReplyLoaded(
            childrenReplies: replyPaginator.replies,
            hasReachedMax: replyPaginator.lastPage == 1 ? true : false,
            repliesLeft: event.childrenCount - replyPaginator.replies.length,
          );
          return;
        }

        if (currentState is ChildrenReplyLoaded) {
          yield ChildrenReplyLoading();

          var pageNumber = currentState.pageNumber + 1;

          final replyPaginator = await replyRepository.getChildrenReplies(
              parentID: event.parentID, pageNumber: pageNumber);

          yield replyPaginator.replies.isEmpty
              ? currentState.copyWith(
                  hasReachedMax: true, repliesLeft: 0, isLoading: false)
              : ChildrenReplyLoaded(
                  childrenReplies:
                      currentState.childrenReplies + replyPaginator.replies,
                  hasReachedMax: false,
                  pageNumber: pageNumber,
                  repliesLeft: event.childrenCount -
                      (currentState.childrenReplies.length +
                          replyPaginator.replies.length),
                );
        }
      } catch (_) {
        yield ChildrenReplyError();
      }
    }
  }

  Stream<ChildrenReplyState> _mapAddChildrenReplyToState(
      AddChildrenReply event) async* {
    final currentState = state;
    try {
      final reply = await replyRepository.addChildren(event.tweetID, event.body,
          image: event.image, parentID: event.parentID);
      if (currentState is ChildrenReplyLoaded) {
        final List<Reply> updatedReplies =
            List.from(currentState.childrenReplies)..insert(0, reply);

        yield ChildrenReplyAdded(reply: reply);
        yield currentState.copyWith(childrenReplies: updatedReplies);
      } else {
        yield ChildrenReplyAdded(reply: reply);
        yield ChildrenReplyEmpty();
      }
    } catch (e) {
      yield AddChildrenReplyError();
    }
    // yield AddReplyError();
  }

  Stream<ChildrenReplyState> _mapDeleteChildrenReplyToState(
      DeleteChildrenReply event) async* {
    final currentState = state;
    if (currentState is ChildrenReplyLoaded) {
      try {
        await replyRepository.deleteReply(event.reply.id);

        final List<Reply> updatedReplies =
            _removeReply(currentState.childrenReplies, event);

        yield ChildrenReplyDeleted(count: 1);

        yield currentState.copyWith(
          childrenReplies: updatedReplies,
        );
      } catch (e) {
        yield DeleteChildrenReplyError();
        yield currentState;
      }
    }
  }

  List<Reply> _removeReply(List<Reply> repies, DeleteChildrenReply event) {
    return repies.where((reply) => reply.id != event.reply.id).toList();
  }
}
