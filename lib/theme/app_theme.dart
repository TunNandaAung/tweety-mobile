import 'package:flutter/material.dart';

enum AppTheme { Light, Dark }

final appThemeData = {
  AppTheme.Light: ThemeData(
    brightness: Brightness.light,
    // primaryColor: Color(0xFF4299E1),
    primaryColor: Color(0xFF47D5FE),
    cardColor: Colors.white,
    canvasColor: Colors.black12,
    hintColor: Color(0xFF718096),
    scaffoldBackgroundColor: Color(0xFFf3f6fb),
    appBarTheme: AppBarTheme(
      textTheme: TextTheme(
        caption: TextStyle(color: Colors.black),
      ),
      iconTheme: IconThemeData(color: Colors.black),
    ),
    textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.white),
    splashColor: Color(0xFFEDF2F7),
    dividerColor: Colors.grey[500],
    bottomAppBarTheme: BottomAppBarTheme(color: Color(0xFFEDF2F7)),
    popupMenuTheme: PopupMenuThemeData(color: Color(0xFFEDF0F6)),
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
      headline5: TextStyle(
        color: Colors.black,
        fontSize: 20.0,
        fontWeight: FontWeight.w500,
      ),
      caption: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
      button: TextStyle(
        color: Colors.white,
        fontSize: 14.0,
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
        color: Color(0xFF47D5FE),
        fontSize: 18,
        fontWeight: FontWeight.w400,
      ),
      subtitle1: TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.w400,
      ),
    ),
  ),
  AppTheme.Dark: ThemeData(
    brightness: Brightness.light,
    primaryColor: Color(0xFF47D5FE),
    cardColor: Color(0xFF2d3447),
    canvasColor: Colors.transparent,
    hintColor: Color(0xFF718096),
    scaffoldBackgroundColor: Color(0xFF1A202C),
    appBarTheme: AppBarTheme(
      textTheme: TextTheme(
        caption: TextStyle(color: Colors.white),
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.white),
    splashColor: Color(0xFF718096),
    dividerColor: Colors.grey[500],
    bottomAppBarTheme: BottomAppBarTheme(color: Color(0xFF2D3748)),
    popupMenuTheme: PopupMenuThemeData(color: Color(0xFF2d3447)),
    tabBarTheme: TabBarTheme(
      labelStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
      unselectedLabelStyle: TextStyle(
        color: Color(0xFF718096),
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
      unselectedLabelColor: Colors.grey,
      labelColor: Colors.white,
    ),
    textTheme: TextTheme(
      headline5: TextStyle(
        color: Colors.white,
        fontSize: 20.0,
        fontWeight: FontWeight.w500,
      ),
      caption: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
      button: TextStyle(
        color: Colors.white,
        fontSize: 14.0,
      ),
      bodyText1: TextStyle(
        color: Colors.white,
        fontSize: 14.0,
      ),
      bodyText2: TextStyle(
        color: Color(0xFF718096),
        fontSize: 14,
      ),
      headline6: TextStyle(
        color: Color(0xFF47D5FE),
        fontSize: 18,
        fontWeight: FontWeight.w400,
      ),
      subtitle1: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w400,
      ),
    ),
  ),
};
