import 'package:flutter/material.dart';

enum AppTheme { Light }

final appThemeData = {
  AppTheme.Light: ThemeData(
    brightness: Brightness.light,
    primaryColor: Color(0xFF4299E1),
    cardColor: Colors.white,
    scaffoldBackgroundColor: Color(0xFFf3f6fb),
    appBarTheme: AppBarTheme(
        textTheme: TextTheme(
      caption: TextStyle(color: Colors.black),
    )),
    dividerColor: Colors.grey[500],
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
