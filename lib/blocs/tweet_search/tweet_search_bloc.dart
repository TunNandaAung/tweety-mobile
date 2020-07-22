import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tweety_mobile/models/tweet.dart';
import 'package:tweety_mobile/preferences/preferences.dart';
import 'package:tweety_mobile/repositories/search_repository.dart';

part 'tweet_search_event.dart';
part 'tweet_search_state.dart';

class TweetSearchBloc extends Bloc<TweetSearchEvent, TweetSearchState> {
  final SearchRepository searchRepository;

  TweetSearchBloc({@required this.searchRepository})
      : assert(searchRepository != null),
        super(TweetSearchState.initial());

  @override
  void onTransition(Transition<TweetSearchEvent, TweetSearchState> transition) {
    print(transition.toString());
    super.onTransition(transition);
  }

  @override
  Stream<Transition<TweetSearchEvent, TweetSearchState>> transformEvents(
    Stream<TweetSearchEvent> events,
    TransitionFunction<TweetSearchEvent, TweetSearchState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 300)),
      transitionFn,
    );
  }

  @override
  Stream<TweetSearchState> mapEventToState(
    TweetSearchEvent event,
  ) async* {
    yield TweetSearchState.loading();
    try {
      List<Tweet> tweets = await searchRepository.searchTweets(event.query);
      _saveToRecentSearch(event.query);
      yield TweetSearchState.success(tweets);
    } catch (_) {
      yield TweetSearchState.error();
    }
  }

  void _saveToRecentSearch(String query) async {
    Set<String> allSearches =
        Prefer.prefs.getStringList("recent_searches")?.toSet() ?? {};

    allSearches = {query, ...allSearches};
    Prefer.prefs.setStringList("recent_searches", allSearches.toList());
  }
}
