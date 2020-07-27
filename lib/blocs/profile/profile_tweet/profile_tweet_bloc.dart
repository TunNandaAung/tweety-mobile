import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tweety_mobile/models/tweet.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tweety_mobile/repositories/tweet_repository.dart';

part 'profile_tweet_event.dart';
part 'profile_tweet_state.dart';

class ProfileTweetBloc extends Bloc<ProfileTweetEvent, ProfileTweetState> {
  final TweetRepository tweetRepository;

  ProfileTweetBloc({@required this.tweetRepository})
      : assert(tweetRepository != null),
        super(ProfileTweetInitial());

  @override
  Stream<Transition<ProfileTweetEvent, ProfileTweetState>> transformEvents(
    Stream<ProfileTweetEvent> events,
    TransitionFunction<ProfileTweetEvent, ProfileTweetState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<ProfileTweetState> mapEventToState(ProfileTweetEvent event) async* {
    if (event is FetchProfileTweet) {
      yield* _mapFetchProfileTweetToState(event);
    } else if (event is RefreshProfileTweet) {
      yield* _mapRefreshProfileTweetToState(event);
    }
  }

  Stream<ProfileTweetState> _mapFetchProfileTweetToState(
      FetchProfileTweet event) async* {
    final currentState = state;

    if (!_hasReachedMax(currentState)) {
      try {
        if (currentState is ProfileTweetInitial) {
          final tweetPaginator = await tweetRepository.getUserTweets(
              username: event.username, pageNumber: 1);
          yield ProfileTweetLoaded(
              tweets: tweetPaginator.tweets,
              hasReachedMax: tweetPaginator.lastPage == 1 ? true : false);
          return;
        }

        if (currentState is ProfileTweetLoaded) {
          var pageNumber = currentState.pageNumber + 1;
          final tweetPaginator = await tweetRepository.getUserTweets(
              username: event.username, pageNumber: pageNumber);

          yield tweetPaginator.tweets.isEmpty
              ? ProfileTweetLoaded(
                  tweets: currentState.tweets,
                  hasReachedMax: true,
                  pageNumber: currentState.pageNumber,
                )
              : ProfileTweetLoaded(
                  tweets: currentState.tweets + tweetPaginator.tweets,
                  hasReachedMax: false,
                  pageNumber: pageNumber,
                );
        }
      } catch (_) {
        yield ProfileTweetError();
      }
    }
  }

  bool _hasReachedMax(ProfileTweetState state) =>
      state is ProfileTweetLoaded && state.hasReachedMax;

  Stream<ProfileTweetState> _mapRefreshProfileTweetToState(
      RefreshProfileTweet event) async* {
    try {
      final tweetPaginator = await tweetRepository.getUserTweets(
          username: event.username, pageNumber: 1);
      yield ProfileTweetLoaded(
          tweets: tweetPaginator.tweets,
          hasReachedMax: tweetPaginator.lastPage == 1 ? true : false);
      return;
    } catch (_) {
      yield state;
    }
  }
}
