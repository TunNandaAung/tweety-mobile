import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
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
  Stream<Transition<TweetEvent, TweetState>> transformEvents(
    Stream<TweetEvent> events,
    TransitionFunction<TweetEvent, TweetState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<TweetState> mapEventToState(TweetEvent event) async* {
    if (event is FetchTweet) {
      yield* _mapFetchTweetToState(event);
    } else if (event is RefreshTweet) {
      yield* _mapRefreshTweetToState(event);
    } else if (event is PublishTweet) {
      yield* _mapPublishTweetToState(event);
    } else if (event is UpdateReplyCount) {
      yield* _mapUpdateReplyCountToState(event);
    } else if (event is DeleteTweet) {
      yield* _mapDeleteTweetToState(event);
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

  Stream<TweetState> _mapPublishTweetToState(PublishTweet event) async* {
    final currentState = state;

    try {
      final tweet =
          await tweetRepository.publishTweet(event.body, image: event.image);

      if (currentState is TweetLoaded) {
        final List<Tweet> updatedTweet = List.from(currentState.tweets)
          ..insert(0, tweet);
        yield TweetPublished(tweet: tweet);

        yield currentState.copyWith(tweets: updatedTweet);
      }
    } catch (_) {
      if (currentState is TweetLoaded) {
        yield currentState;
        yield PublishTweetError();
      }
    }
  }

  Stream<TweetState> _mapUpdateReplyCountToState(
      UpdateReplyCount event) async* {
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

        yield currentState.copyWith(tweets: updatedTweet);
      }
    } catch (_) {
      yield state;
    }
  }

  Stream<TweetState> _mapDeleteTweetToState(DeleteTweet event) async* {
    final currentState = state;
    if (currentState is TweetLoaded) {
      try {
        await tweetRepository.deleteTweet(event.tweetID);
        final List<Tweet> updatedTweets =
            _removeTweet(currentState.tweets, event);

        // yield TweetLoading();
        yield TweetDeleted();
        yield currentState.copyWith(
          tweets: updatedTweets,
        );
      } catch (e) {
        yield DeleteTweetError();
        yield currentState;
      }
    }
  }

  List<Tweet> _removeTweet(List<Tweet> tweets, DeleteTweet event) {
    return tweets.where((tweet) => tweet.id != event.tweetID).toList();
  }
}
