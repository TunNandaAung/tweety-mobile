import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tweety_mobile/models/user.dart';
import 'package:tweety_mobile/preferences/preferences.dart';
import 'package:tweety_mobile/repositories/search_repository.dart';

part 'user_search_event.dart';
part 'user_search_state.dart';

class UserSearchBloc extends Bloc<UserSearchEvent, UserSearchState> {
  final SearchRepository searchRepository;

  UserSearchBloc({@required this.searchRepository})
      : assert(searchRepository != null),
        super(UserSearchState.initial());

  @override
  void onTransition(Transition<UserSearchEvent, UserSearchState> transition) {
    print(transition.toString());
    super.onTransition(transition);
  }

  @override
  Stream<Transition<UserSearchEvent, UserSearchState>> transformEvents(
    Stream<UserSearchEvent> events,
    TransitionFunction<UserSearchEvent, UserSearchState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 300)),
      transitionFn,
    );
  }

  @override
  Stream<UserSearchState> mapEventToState(
    UserSearchEvent event,
  ) async* {
    yield UserSearchState.loading();
    try {
      List<User> users = await searchRepository.searchUsers(event.query);
      _saveToRecentSearch(event.query);
      yield UserSearchState.success(users);
    } catch (_) {
      yield UserSearchState.error();
    }
  }

  void _saveToRecentSearch(String query) async {
    Set<String> allSearches =
        Prefer.prefs.getStringList("recent_searches")?.toSet() ?? {};

    allSearches = {query, ...allSearches};
    Prefer.prefs.setStringList("recent_searches", allSearches.toList());
  }
}
