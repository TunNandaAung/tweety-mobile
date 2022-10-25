import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tweety_mobile/preferences/preferences.dart';
import 'package:tweety_mobile/theme/app_theme.dart';

class ThemeCubit extends Cubit<AppTheme> {
  ThemeCubit() : super(AppTheme.values[Prefer.themeIndexPref]);

  Future<void> changeTheme(AppTheme theme) async {
    Prefer.prefs = await SharedPreferences.getInstance();
    Prefer.prefs.setInt('theme', theme.index);
    emit(theme);
  }
}
