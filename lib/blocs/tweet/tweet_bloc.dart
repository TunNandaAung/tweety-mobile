import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tweety_mobile/models/tweet.dart';
import 'package:tweety_mobile/repositories/tweet_repository.dart';

part 'tweet_event.dart';
part 'tweet_state.dart';

class TweetBloc extends Bloc<TweetEvent, TweetState> {
  final TweetRepository tweetRepository;

  TweetBloc({@required this.tweetRepository})
      : assert(tweetRepository != null),
        super(TweetEmpty());

  @override
  Stream<TweetState> mapEventToState(TweetEvent event) async* {
    if (event is FetchTweet) {
      yield* _mapFetchTweetToState(event);
    } else if (event is RefreshTweet) {
      yield* _mapRefreshTweetToState(event);
    }
  }

  Stream<TweetState> _mapFetchTweetToState(FetchTweet event) async* {
    final currentState = state;

    if (!_hasReachedMax(currentState)) {
      try {
        if (currentState is TweetEmpty) {
          final tweetPaginator = await tweetRepository.getTweets(1);
          yield TweetLoaded(
              tweets: tweetPaginator.tweets,
              hasReachedMax: tweetPaginator.lastPage == 1 ? true : false);
          return;
        }

        if (currentState is TweetLoaded) {
          var pageNumber = currentState.pageNumber + 1;
          final tweetPaginator = await tweetRepository.getTweets(pageNumber);

          yield tweetPaginator.tweets.isEmpty
              ? TweetLoaded(
                  tweets: currentState.tweets,
                  hasReachedMax: true,
                  pageNumber: currentState.pageNumber,
                )
              : TweetLoaded(
                  tweets: currentState.tweets + tweetPaginator.tweets,
                  hasReachedMax: false,
                  pageNumber: pageNumber,
                );
        }
      } catch (_) {
        yield TweetError();
      }
    }
  }

  bool _hasReachedMax(TweetState state) =>
      state is TweetLoaded && state.hasReachedMax;

  Stream<TweetState> _mapRefreshTweetToState(RefreshTweet event) async* {
    try {
      final tweetPaginator = await tweetRepository.getTweets(1);
      yield TweetLoaded(
          tweets: tweetPaginator.tweets,
          hasReachedMax: tweetPaginator.lastPage == 1 ? true : false);
      return;
    } catch (_) {
      yield state;
    }
  }
}
