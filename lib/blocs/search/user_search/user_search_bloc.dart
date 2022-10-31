import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:tweety_mobile/models/user.dart';
import 'package:tweety_mobile/preferences/preferences.dart';
import 'package:tweety_mobile/repositories/search_repository.dart';
import 'package:tweety_mobile/utils/helpers.dart';

part 'user_search_event.dart';
part 'user_search_state.dart';

const userThrottleDuration = Duration(milliseconds: 300);

class UserSearchBloc extends Bloc<UserSearchEvent, UserSearchState> {
  final SearchRepository searchRepository;

  UserSearchBloc({required this.searchRepository})
      : super(UserSearchState.initial()) {
    on<UserSearchEvent>(
      _onUserSearch,
      transformer: throttleDroppable(userThrottleDuration),
    );
  }

  Future<void> _onUserSearch(
      UserSearchEvent event, Emitter<UserSearchState> emit) async {
    emit(UserSearchState.loading());
    try {
      List<User> users = await searchRepository.searchUsers(event.query);
      _saveToRecentSearch(event.query);
      emit(UserSearchState.success(users));
    } catch (_) {
      emit(UserSearchState.error());
    }
  }

  void _saveToRecentSearch(String query) async {
    Set<String> allSearches =
        Prefer.prefs.getStringList("recent_searches")?.toSet() ?? {};

    allSearches = {query, ...allSearches};
    Prefer.prefs.setStringList("recent_searches", allSearches.toList());
  }
}
