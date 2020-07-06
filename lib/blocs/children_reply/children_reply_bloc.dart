import 'dart:async';
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
              ? currentState.copyWith(hasReachedMax: true, repliesLeft: 0)
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
}
