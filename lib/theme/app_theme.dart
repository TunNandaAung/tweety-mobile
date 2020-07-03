import 'package:flutter/material.dart';

enum AppTheme { Light }

final appThemeData = {
  AppTheme.Light: ThemeData(
    brightness: Brightness.light,
    primaryColor: Color(0xFF4299E1),
  ),
};
