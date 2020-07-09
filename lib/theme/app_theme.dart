import 'package:flutter/material.dart';

enum AppTheme { Light }

final appThemeData = {
  AppTheme.Light: ThemeData(
    brightness: Brightness.light,
    primaryColor: Color(0xFF4299E1),
    cardColor: Colors.white,
    hintColor: Color(0xFF718096),
    scaffoldBackgroundColor: Color(0xFFf3f6fb),
    appBarTheme: AppBarTheme(
      textTheme: TextTheme(
        caption: TextStyle(color: Colors.black),
      ),
      iconTheme: IconThemeData(color: Colors.black),
    ),
    dividerColor: Colors.grey[500],
    tabBarTheme: TabBarTheme(
      labelStyle: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
      unselectedLabelStyle: TextStyle(
        color: Color(0xFF718096),
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
      unselectedLabelColor: Colors.grey,
      labelColor: Colors.black,
    ),
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
      bodyText2: TextStyle(
        color: Color(0xFF718096),
        fontSize: 14,
      ),
      headline6: TextStyle(
        color: Color(0xFF4299E1),
        fontSize: 18,
        fontWeight: FontWeight.w400,
      ),
    ),
  ),
};
