import 'package:flutter/material.dart';

class NavigationModel {
  String title;
  IconData icon;
  NavigationModel({this.title, this.icon});
}

List<NavigationModel> navItems = [
  NavigationModel(title: 'favorite', icon: Icons.favorite_border),
  NavigationModel(
    title: 'settings',
    icon: Icons.settings,
  ),
  // NavigationModel(
  //   title: 'help',
  //   icon: Icons.help_outline,
  // ),
  NavigationModel(
    title: 'about',
    icon: Icons.info_outline,
  ),
];

final TextStyle navItemStyle = TextStyle(fontSize: 18, color: Colors.black);

final TextStyle navItemSelectedStyle =
    TextStyle(fontSize: 18, color: Colors.white);
