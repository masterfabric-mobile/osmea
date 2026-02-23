import 'package:flutter/material.dart';

class AppConstants {
  static const List<Map<String, dynamic>> navItems = [
    {
      'text': 'Home',
      'icon': Icons.home_outlined,
      'onTap': null,
    },
    {
      'text': 'Components',
      'icon': Icons.widgets_outlined,
      'onTap': null,
    },
    {
      'text': 'Info',
      'icon': Icons.info_outline,
      'onTap': null,
    },
  ];

  static const String appTitle = 'MasterFabric Components';
  static const String appSubtitle =
      'Explore our Flutter components and showcase';
}
