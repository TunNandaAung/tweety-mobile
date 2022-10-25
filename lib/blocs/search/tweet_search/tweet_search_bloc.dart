import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tweety_mobile/models/tweet.dart';
import 'package:tweety_mobile/preferences/preferences.dart';
import 'package:tweety_mobile/repositories/search_repository.dart';
import 'package:tweety_mobile/utils/helpers.dart';

part 'tweet_search_event.dart';
part 'tweet_search_state.dart';

const tweetSearchThrottleDuration = Duration(milliseconds: 300);

class TweetSearchBloc extends Bloc<TweetSearchEvent, TweetSearchState> {
  final SearchRepository searchRepository;

  TweetSearchBloc({@required this.searchRepository})
      : super(TweetSearchState.initial()) {
    on<TweetSearchEvent>(
      _onTweetSearch,
      transformer: throttleDroppable(tweetSearchThrottleDuration),
    );
  }

  Future<void> _onTweetSearch(
      TweetSearchEvent event, Emitter<TweetSearchState> emit) async {
    emit(TweetSearchState.loading());
    try {
      List<Tweet> tweets = await searchRepository.searchTweets(event.query);
      _saveToRecentSearch(event.query);
      emit(TweetSearchState.success(tweets));
    } catch (_) {
      emit(TweetSearchState.error());
    }
  }

  void _saveToRecentSearch(String query) async {
    Set<String> allSearches =
        Prefer.prefs.getStringList("recent_searches")?.toSet() ?? {};

    allSearches = {query, ...allSearches};
    Prefer.prefs.setStringList("recent_searches", allSearches.toList());
  }
}
