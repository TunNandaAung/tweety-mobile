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

  LikeDislikeBloc({@required this.likeDislikeRepository})
      : super(LikeDislikeInitial());

  @override
  Stream<LikeDislikeState> mapEventToState(
    LikeDislikeEvent event,
  ) async* {
    if (event is LikeTweet) {
      yield* _mapLikeTweetToState(event);
    }
  }

  Stream<LikeDislikeState> _mapLikeTweetToState(LikeTweet event) async* {
    try {
      final response = await likeDislikeRepository.like(
          id: event.tweetID, subject: 'tweets');

      yield Liked(like: response);
    } catch (e) {
      yield LikeDislikeError();
    }
  }
}
