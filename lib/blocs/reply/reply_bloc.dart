import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:tweety_mobile/models/reply.dart';
import 'package:tweety_mobile/repositories/reply_repository.dart';
import 'package:tweety_mobile/utils/helpers.dart';

part 'reply_event.dart';
part 'reply_state.dart';

const throttleDuration = Duration(milliseconds: 100);

class ReplyBloc extends Bloc<ReplyEvent, ReplyState> {
  final ReplyRepository replyRepository;

  ReplyBloc({this.replyRepository}) : super(ReplyEmpty()) {
    on<FetchReply>(
      _onFetchReply,
      transformer: throttleDroppable(throttleDuration),
    );
    on<RefreshReply>(
      _onRefreshReply,
      transformer: throttleDroppable(throttleDuration),
    );
    on<AddReply>(
      _onAddReply,
      transformer: throttleDroppable(throttleDuration),
    );
    on<DeleteReply>(
      _onDeleteReply,
      transformer: throttleDroppable(throttleDuration),
    );
    on<FetchSingleReply>(
      _onFetchSingleReply,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  Future<void> _onFetchReply(FetchReply event, Emitter<ReplyState> emit) async {
    final currentState = state;
    if (!_hasReachedMax(currentState, event)) {
      try {
        if (currentState is ReplyEmpty) {
          final replyPaginator = await replyRepository.getReplies(
              tweetID: event.tweetID, pageNumber: 1);
          return emit(ReplyLoaded(
            replies: replyPaginator.replies,
            hasReachedMax: replyPaginator.lastPage == 1 ? true : false,
          ));
        }

        if (currentState is ReplyLoaded) {
          var pageNumber = currentState.pageNumber + 1;
          final replyPaginator = await replyRepository.getReplies(
              tweetID: event.tweetID, pageNumber: pageNumber);

          emit(replyPaginator.replies.isEmpty
              ? ReplyLoaded(
                  replies: currentState.replies,
                  hasReachedMax: true,
                  pageNumber: currentState.pageNumber,
                )
              : ReplyLoaded(
                  replies: currentState.replies + replyPaginator.replies,
                  hasReachedMax: false,
                  pageNumber: pageNumber,
                ));
        }
      } catch (_) {
        emit(ReplyError());
      }
    }
  }

  bool _hasReachedMax(ReplyState state, FetchReply event) {
    return state is ReplyLoaded && state.hasReachedMax;
  }

  Future<void> _onRefreshReply(
      RefreshReply event, Emitter<ReplyState> emit) async {
    try {
      final replyPaginator = await replyRepository.getReplies(
          tweetID: event.tweetID, pageNumber: 1);
      return emit(ReplyLoaded(
        replies: replyPaginator.replies,
        hasReachedMax: replyPaginator.lastPage == 1 ? true : false,
      ));
    } catch (_) {
      emit(state);
    }
  }

  Future<void> _onAddReply(AddReply event, Emitter<ReplyState> emit) async {
    final currentState = state;
    try {
      final reply = await replyRepository.addReply(event.tweetID, event.body,
          image: event.image);
      if (currentState is ReplyLoaded) {
        final List<Reply> updatedReplies = List.from(currentState.replies)
          ..add(reply);

        emit(ReplyAdded(reply: reply));
        emit(currentState.copyWith(replies: updatedReplies));
      } else
        emit(ReplyAdded(reply: reply));
    } catch (e) {
      emit(AddReplyError());
    }
    // emit(AddReplyError());
  }

  Future<void> _onDeleteReply(
      DeleteReply event, Emitter<ReplyState> emit) async {
    final currentState = state;
    if (currentState is ReplyLoaded) {
      try {
        await replyRepository.deleteReply(event.reply.id);

        final List<Reply> updatedReplies =
            _removeReply(currentState.replies, event);

        // emit(TweetLoading());
        emit(ReplyDeleted(count: event.reply.childrenCount + 1));
        emit(currentState.copyWith(
          replies: updatedReplies,
        ));
      } catch (e) {
        emit(DeleteReplyError());
        emit(currentState);
      }
    }
  }

  List<Reply> _removeReply(List<Reply> repies, DeleteReply event) {
    return repies.where((reply) => reply.id != event.reply.id).toList();
  }

  Future<void> _onFetchSingleReply(
      FetchSingleReply event, Emitter<ReplyState> emit) async {
    emit(SingleReplyLoading());
    try {
      final reply = await replyRepository.getReply(replyID: event.replyID);
      emit(SingleReplyLoaded(reply: reply));
    } catch (e) {
      emit(SingleReplyError());
    }
  }
}
