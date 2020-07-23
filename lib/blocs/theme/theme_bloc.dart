import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tweety_mobile/preferences/preferences.dart';
import 'package:tweety_mobile/theme/app_theme.dart';

part 'theme_event.dart';

class ThemeBloc extends Bloc<ThemeEvent, AppTheme> {
  ThemeBloc() : super(AppTheme.values[Prefer.themeIndexPref]);

  @override
  Stream<AppTheme> mapEventToState(
    ThemeEvent event,
  ) async* {
    if (event is ThemeChanged) {
      yield event.theme;
      Prefer.prefs = await SharedPreferences.getInstance();
      Prefer.prefs.setInt('theme', event.theme.index);
      Prefer.themeIndexPref = event.theme.index;
      print('App Theme: ${event.theme}');
    }
  }
}
