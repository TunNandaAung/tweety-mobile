import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tweety_mobile/models/tweet.dart';
import 'package:tweety_mobile/repositories/tweet_repository.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:tweety_mobile/utils/helpers.dart';

part 'profile_tweet_event.dart';
part 'profile_tweet_state.dart';

const throttleDuration = Duration(milliseconds: 500);

class ProfileTweetBloc extends Bloc<ProfileTweetEvent, ProfileTweetState> {
  final TweetRepository tweetRepository;

  ProfileTweetBloc({@required this.tweetRepository})
      : super(ProfileTweetInitial()) {
    on<FetchProfileTweet>(
      _onFetchProfileTweet,
      transformer: throttleDroppable(throttleDuration),
    );
    on<RefreshProfileTweet>(
      _onRefreshProfileTweet,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  Future<void> _onFetchProfileTweet(
      FetchProfileTweet event, Emitter<ProfileTweetState> emit) async {
    final currentState = state;

    if (!_hasReachedMax(currentState)) {
      try {
        if (currentState is ProfileTweetInitial) {
          final tweetPaginator = await tweetRepository.getUserTweets(
              username: event.username, pageNumber: 1);
          return emit(ProfileTweetLoaded(
            tweets: tweetPaginator.tweets,
            hasReachedMax: tweetPaginator.lastPage == 1 ? true : false,
          ));
        }

        if (currentState is ProfileTweetLoaded) {
          var pageNumber = currentState.pageNumber + 1;
          final tweetPaginator = await tweetRepository.getUserTweets(
              username: event.username, pageNumber: pageNumber);

          emit(tweetPaginator.tweets.isEmpty
              ? ProfileTweetLoaded(
                  tweets: currentState.tweets,
                  hasReachedMax: true,
                  pageNumber: currentState.pageNumber,
                )
              : ProfileTweetLoaded(
                  tweets: currentState.tweets + tweetPaginator.tweets,
                  hasReachedMax: false,
                  pageNumber: pageNumber,
                ));
        }
      } catch (_) {
        emit(ProfileTweetError());
      }
    }
  }

  bool _hasReachedMax(ProfileTweetState state) =>
      state is ProfileTweetLoaded && state.hasReachedMax;

  Future<void> _onRefreshProfileTweet(
      RefreshProfileTweet event, Emitter<ProfileTweetState> emit) async {
    try {
      final tweetPaginator = await tweetRepository.getUserTweets(
          username: event.username, pageNumber: 1);
      emit(ProfileTweetLoaded(
        tweets: tweetPaginator.tweets,
        hasReachedMax: tweetPaginator.lastPage == 1 ? true : false,
      ));
      return;
    } catch (_) {
      emit(state);
    }
  }
}
