import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tweety_mobile/models/tweet.dart';
import 'package:tweety_mobile/repositories/tweet_repository.dart';
import 'package:tweety_mobile/utils/helpers.dart';

part 'tweet_event.dart';
part 'tweet_state.dart';

const tweetThrottleDuration = Duration(milliseconds: 500);

class TweetBloc extends Bloc<TweetEvent, TweetState> {
  final TweetRepository tweetRepository;

  TweetBloc({@required this.tweetRepository}) : super(TweetEmpty()) {
    on<FetchTweet>(
      _onFetchTweet,
      transformer: throttleDroppable(tweetThrottleDuration),
    );
    on<RefreshTweet>(
      _onRefreshTweet,
      transformer: throttleDroppable(tweetThrottleDuration),
    );
    on<PublishTweet>(
      _onPublishTweet,
      transformer: throttleDroppable(tweetThrottleDuration),
    );
    on<UpdateReplyCount>(
      _onUpdateReplyCount,
      transformer: throttleDroppable(tweetThrottleDuration),
    );
    on<DeleteTweet>(
      _onDeleteTweet,
      transformer: throttleDroppable(tweetThrottleDuration),
    );
  }

  Future<void> _onFetchTweet(FetchTweet event, Emitter<TweetState> emit) async {
    final currentState = state;

    if (!_hasReachedMax(currentState)) {
      try {
        if (currentState is TweetEmpty) {
          final tweetPaginator = await tweetRepository.getTweets(1);
          return emit(TweetLoaded(
            tweets: tweetPaginator.tweets,
            hasReachedMax: tweetPaginator.lastPage == 1 ? true : false,
          ));
        }

        if (currentState is TweetLoaded) {
          var pageNumber = currentState.pageNumber + 1;
          final tweetPaginator = await tweetRepository.getTweets(pageNumber);

          emit(tweetPaginator.tweets.isEmpty
              ? TweetLoaded(
                  tweets: currentState.tweets,
                  hasReachedMax: true,
                  pageNumber: currentState.pageNumber,
                )
              : TweetLoaded(
                  tweets: currentState.tweets + tweetPaginator.tweets,
                  hasReachedMax: false,
                  pageNumber: pageNumber,
                ));
        }
      } catch (_) {
        emit(TweetError());
      }
    }
  }

  bool _hasReachedMax(TweetState state) =>
      state is TweetLoaded && state.hasReachedMax;

  Future<void> _onRefreshTweet(
      RefreshTweet event, Emitter<TweetState> emit) async {
    try {
      final tweetPaginator = await tweetRepository.getTweets(1);
      emit(TweetLoaded(
        tweets: tweetPaginator.tweets,
        hasReachedMax: tweetPaginator.lastPage == 1 ? true : false,
      ));
      return;
    } catch (_) {
      emit(state);
    }
  }

  Future<void> _onPublishTweet(
      PublishTweet event, Emitter<TweetState> emit) async {
    final currentState = state;

    try {
      final tweet =
          await tweetRepository.publishTweet(event.body, image: event.image);

      if (currentState is TweetLoaded) {
        final List<Tweet> updatedTweet = List.from(currentState.tweets)
          ..insert(0, tweet);
        emit(TweetPublished(tweet: tweet));

        emit(currentState.copyWith(tweets: updatedTweet));
      }
    } catch (_) {
      if (currentState is TweetLoaded) {
        emit(currentState);
        emit(PublishTweetError());
      }
    }
  }

  Future<void> _onUpdateReplyCount(
      UpdateReplyCount event, Emitter<TweetState> emit) async {
    final currentState = state;

    try {
      if (currentState is TweetLoaded) {
        final index = currentState.tweets
            .indexWhere((element) => element.id == event.tweetID);

        final tweet = currentState.tweets
            .firstWhere((element) => element.id == event.tweetID);

        final List<Tweet> updatedTweet = List.from(currentState.tweets)
          ..replaceRange(index, index + 1, [
            tweet.copyWith(
              repliesCount: event.count,
            )
          ]);

        emit(currentState.copyWith(tweets: updatedTweet));
      }
    } catch (_) {
      emit(state);
    }
  }

  Future<void> _onDeleteTweet(
      DeleteTweet event, Emitter<TweetState> emit) async {
    final currentState = state;
    if (currentState is TweetLoaded) {
      try {
        await tweetRepository.deleteTweet(event.tweetID);
        final List<Tweet> updatedTweets =
            _removeTweet(currentState.tweets, event);

        // emit(TweetLoading());
        emit(TweetDeleted());
        emit(currentState.copyWith(
          tweets: updatedTweets,
        ));
      } catch (e) {
        emit(DeleteTweetError());
        emit(currentState);
      }
    }
  }

  List<Tweet> _removeTweet(List<Tweet> tweets, DeleteTweet event) {
    return tweets.where((tweet) => tweet.id != event.tweetID).toList();
  }
}
