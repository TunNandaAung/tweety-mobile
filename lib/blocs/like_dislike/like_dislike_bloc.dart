import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tweety_mobile/models/like_dislike.dart';
import 'package:tweety_mobile/models/like_dislike_repository.dart';

part 'like_dislike_event.dart';
part 'like_dislike_state.dart';

class LikeDislikeBloc extends Bloc<LikeDislikeEvent, LikeDislikeState> {
  final LikeDislikeRepository likeDislikeRepository;

  LikeDislikeBloc({this.likeDislikeRepository}) : super(LikeDislikeInitial()) {
    on<Like>(_onLike);
    on<Dislike>(_onDislike);
  }

  Future<void> _onLike(Like event, Emitter<LikeDislikeState> emit) async {
    try {
      final response = await likeDislikeRepository.like(
          id: event.tweetID, subject: event.subject);

      emit(Liked(like: response));
    } catch (e) {
      emit(LikeDislikeError());
    }
  }

  Future<void> _onDislike(Dislike event, Emitter<LikeDislikeState> emit) async {
    try {
      final response = await likeDislikeRepository.dislike(
          id: event.tweetID, subject: event.subject);

      emit(Disliked(dislike: response));
    } catch (e) {
      emit(LikeDislikeError());
    }
  }
}
