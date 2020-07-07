import 'package:flutter/material.dart';

class NavigationModel {
  String title;
  IconData icon;
  NavigationModel({this.title, this.icon});
}

List<NavigationModel> navItems = [
  NavigationModel(
    title: 'Profile',
    icon: Icons.person,
  ),
  NavigationModel(
    title: 'Settings',
    icon: Icons.settings,
  ),
  // NavigationModel(
  //   title: 'help',
  //   icon: Icons.help_outline,
  // ),
];

final TextStyle navItemStyle = TextStyle(fontSize: 18, color: Colors.black);

final TextStyle navItemSelectedStyle =
    TextStyle(fontSize: 18, color: Colors.white);
