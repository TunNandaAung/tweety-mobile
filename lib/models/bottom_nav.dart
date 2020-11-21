import 'package:flutter/material.dart';

class BottomNav {
  final String name;
  final IconData defaultIcon;
  final IconData activeIcon;

  BottomNav({this.name, this.defaultIcon, this.activeIcon});
}

List<BottomNav> bottomNavItems = [
  BottomNav(
    name: 'Tweets',
    defaultIcon: Icons.home,
    activeIcon: Icons.home,
  ),
  BottomNav(
    name: 'Explore',
    defaultIcon: Icons.search,
    activeIcon: Icons.search,
  ),
  BottomNav(
    name: 'Messages',
    defaultIcon: Icons.messenger_outline_rounded,
    activeIcon: Icons.messenger_rounded,
  ),
  BottomNav(
    name: 'Notificaitons',
    defaultIcon: Icons.notifications_none,
    activeIcon: Icons.notifications,
  ),
];
