import 'package:flutter/material.dart';

enum AppTheme { Light }

final appThemeData = {
  AppTheme.Light: ThemeData(
    brightness: Brightness.light,
    primaryColor: Color(0xFF4299E1),
    scaffoldBackgroundColor: Color(0xFFF7F7F7),
    textTheme: TextTheme(
      caption: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
      bodyText1: TextStyle(
        color: Colors.black,
        fontSize: 14.0,
      ),
    ),
  ),
};
