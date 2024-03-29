import 'package:flutter/material.dart';

enum AppTheme { Light, Dark }

final appThemeData = {
  AppTheme.Light: ThemeData(
    brightness: Brightness.light,
    // primaryColor: Color(0xFF4299E1),
    colorScheme: ThemeData().colorScheme.copyWith(
          primary: const Color(0xFF47D5FE),
        ),
    primaryColor: const Color(0xFF47D5FE),
    cardColor: Colors.white,
    canvasColor: Colors.black12,
    hintColor: const Color(0xFF718096),
    scaffoldBackgroundColor: const Color(0xFFf3f6fb),
    appBarTheme: const AppBarTheme(
      iconTheme: IconThemeData(color: Colors.black),
      toolbarTextStyle: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w600,
      ),
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w600,
        fontSize: 18.0,
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      selectionHandleColor:
          const Color(0xFF47D5FE).withOpacity(0.2), // Change bubble to red
      cursorColor: Colors.black,
    ),
    splashColor: const Color(0xFFEDF2F7),
    dividerColor: Colors.grey[500],
    bottomAppBarTheme: const BottomAppBarTheme(color: Color(0xFFEDF2F7)),
    popupMenuTheme: const PopupMenuThemeData(color: Color(0xFFEDF0F6)),
    tabBarTheme: const TabBarTheme(
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
    textTheme: const TextTheme(
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
    colorScheme: ThemeData().colorScheme.copyWith(
          primary: const Color(0xFF47D5FE),
        ),
    primaryColor: const Color(0xFF47D5FE),
    cardColor: const Color(0xFF2d3447),
    canvasColor: Colors.transparent,
    hintColor: const Color(0xFF718096),
    scaffoldBackgroundColor: const Color(0xFF1A202C),
    appBarTheme: const AppBarTheme(
      iconTheme: IconThemeData(color: Colors.white),
      toolbarTextStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: 18.0,
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      selectionHandleColor:
          const Color(0xFF47D5FE).withOpacity(0.2), // Change bubble to red
      cursorColor: Colors.white,
    ),
    splashColor: const Color(0xFF718096),
    dividerColor: Colors.grey[500],
    bottomAppBarTheme: const BottomAppBarTheme(color: Color(0xFF2D3748)),
    popupMenuTheme: const PopupMenuThemeData(color: Color(0xFF2d3447)),
    tabBarTheme: const TabBarTheme(
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
    textTheme: const TextTheme(
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
