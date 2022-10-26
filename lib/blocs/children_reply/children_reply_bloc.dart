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

  ChildrenReplyBloc({required this.replyRepository})
      : super(ChildrenReplyEmpty()) {
    on<FetchChildrenReply>(_onFetchChildrenReply);

    on<AddChildrenReply>(_onAddChildrenReply);
    on<DeleteChildrenReply>(_onDeleteChildrenReply);
  }

  bool _hasChildrenReachedMax(ChildrenReplyState state) {
    return state is ChildrenReplyLoaded && state.hasReachedMax;
  }

  Future<void> _onFetchChildrenReply(
      FetchChildrenReply event, Emitter<ChildrenReplyState> emit) async {
    final currentState = state;
    if (!_hasChildrenReachedMax(currentState)) {
      try {
        if (currentState is ChildrenReplyEmpty) {
          emit(ChildrenReplyLoading());

          final replyPaginator = await replyRepository.getChildrenReplies(
              parentID: event.parentID, pageNumber: 1);

          return emit(ChildrenReplyLoaded(
            childrenReplies: replyPaginator.replies,
            hasReachedMax: replyPaginator.lastPage == 1 ? true : false,
            repliesLeft: event.childrenCount - replyPaginator.replies.length,
          ));
        }

        if (currentState is ChildrenReplyLoaded) {
          emit(ChildrenReplyLoading());

          var pageNumber = currentState.pageNumber + 1;

          final replyPaginator = await replyRepository.getChildrenReplies(
              parentID: event.parentID, pageNumber: pageNumber);

          emit(replyPaginator.replies.isEmpty
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
                ));
        }
      } catch (_) {
        emit(ChildrenReplyError());
      }
    }
  }

  Future<void> _onAddChildrenReply(
      AddChildrenReply event, Emitter<ChildrenReplyState> emit) async {
    final currentState = state;
    try {
      final reply = await replyRepository.addChildren(
        event.tweetID,
        event.body,
        image: event.image,
        parentID: event.parentID,
      );
      if (currentState is ChildrenReplyLoaded) {
        final List<Reply> updatedReplies =
            List.from(currentState.childrenReplies)..insert(0, reply);

        emit(ChildrenReplyAdded(reply: reply));
        emit(currentState.copyWith(childrenReplies: updatedReplies));
      } else {
        emit(ChildrenReplyAdded(reply: reply));
        emit(ChildrenReplyEmpty());
      }
    } catch (e) {
      emit(AddChildrenReplyError());
    }
    // emit(AddReplyError();
  }

  Future<void> _onDeleteChildrenReply(
      DeleteChildrenReply event, Emitter<ChildrenReplyState> emit) async {
    final currentState = state;
    if (currentState is ChildrenReplyLoaded) {
      try {
        await replyRepository.deleteReply(event.reply.id);

        final List<Reply> updatedReplies =
            _removeReply(currentState.childrenReplies, event);

        emit(ChildrenReplyDeleted(count: 1));

        emit(currentState.copyWith(
          childrenReplies: updatedReplies,
        ));
      } catch (e) {
        emit(DeleteChildrenReplyError());
        emit(currentState);
      }
    }
  }

  List<Reply> _removeReply(List<Reply> repies, DeleteChildrenReply event) {
    return repies.where((reply) => reply.id != event.reply.id).toList();
  }
}
