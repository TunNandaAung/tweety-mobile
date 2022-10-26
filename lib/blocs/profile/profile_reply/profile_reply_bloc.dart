import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tweety_mobile/models/reply.dart';
import 'package:tweety_mobile/repositories/reply_repository.dart';
import 'package:tweety_mobile/utils/helpers.dart';

part 'profile_reply_event.dart';
part 'profile_reply_state.dart';

const throttleDuration = Duration(milliseconds: 500);

class ProfileReplyBloc extends Bloc<ProfileReplyEvent, ProfileReplyState> {
  final ReplyRepository replyRepository;

  ProfileReplyBloc({this.replyRepository}) : super(ProfileReplyInitial()) {
    on<FetchProfileReply>(
      _onFetchProfileReply,
      transformer: throttleDroppable(throttleDuration),
    );
    on<RefreshProfileReply>(
      _onRefreshProfileReply,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  Future<void> _onFetchProfileReply(
      FetchProfileReply event, Emitter<ProfileReplyState> emit) async {
    final currentState = state;

    if (!_hasReachedMax(currentState)) {
      try {
        if (currentState is ProfileReplyInitial) {
          final replyPaginator = await replyRepository.getUserReplies(
              username: event.username, pageNumber: 1);
          return emit(ProfileReplyLoaded(
            replies: replyPaginator.replies,
            hasReachedMax: replyPaginator.lastPage == 1 ? true : false,
          ));
        }

        if (currentState is ProfileReplyLoaded) {
          var pageNumber = currentState.pageNumber + 1;
          final replyPaginator = await replyRepository.getUserReplies(
              username: event.username, pageNumber: pageNumber);

          emit(replyPaginator.replies.isEmpty
              ? ProfileReplyLoaded(
                  replies: currentState.replies,
                  hasReachedMax: true,
                  pageNumber: currentState.pageNumber,
                )
              : ProfileReplyLoaded(
                  replies: currentState.replies + replyPaginator.replies,
                  hasReachedMax: false,
                  pageNumber: pageNumber,
                ));
        }
      } catch (_) {
        emit(ProfileReplyError());
      }
    }
  }

  bool _hasReachedMax(ProfileReplyState state) =>
      state is ProfileReplyLoaded && state.hasReachedMax;

  Future<void> _onRefreshProfileReply(
      RefreshProfileReply event, Emitter<ProfileReplyState> emit) async {
    try {
      final replyPaginator = await replyRepository.getUserReplies(
          username: event.username, pageNumber: 1);
      return emit(ProfileReplyLoaded(
          replies: replyPaginator.replies,
          hasReachedMax: replyPaginator.lastPage == 1 ? true : false));
    } catch (_) {
      emit(state);
    }
  }
}
