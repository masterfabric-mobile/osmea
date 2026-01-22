/*
 * NavbarIconHelper
 * ----------------
 * Utility class to convert icon name strings to Material Icons IconData
 */

import 'package:flutter/material.dart';

/// Helper class for converting icon name strings to IconData
class NavbarIconHelper {
  /// Get IconData from icon name string
  /// Returns Icons.info_outline as fallback for unknown icons
  static IconData getIconData(String iconName) {
    switch (iconName) {
      // Home icons
      case 'home':
        return Icons.home;
      case 'home_outlined':
        return Icons.home_outlined;
      case 'home_rounded':
        return Icons.home_rounded;
      case 'home_filled':
        return Icons.home;

      // Search icons
      case 'search':
        return Icons.search;
      case 'search_outlined':
        return Icons.search_outlined;
      case 'search_rounded':
        return Icons.search_rounded;

      // Favorite/Saved icons
      case 'favorite':
        return Icons.favorite;
      case 'favorite_outline':
        return Icons.favorite_outline;
      case 'favorite_outlined':
        return Icons.favorite_outline;
      case 'favorite_rounded':
        return Icons.favorite_rounded;
      case 'favorite_border':
        return Icons.favorite_border;

      // Shopping cart icons
      case 'shopping_cart':
        return Icons.shopping_cart;
      case 'shopping_cart_outlined':
        return Icons.shopping_cart_outlined;
      case 'shopping_cart_rounded':
        return Icons.shopping_cart_rounded;
      case 'shopping_bag':
        return Icons.shopping_bag;
      case 'shopping_bag_outlined':
        return Icons.shopping_bag_outlined;

      // Person/Profile icons
      case 'person':
        return Icons.person;
      case 'person_outline':
        return Icons.person_outline;
      case 'person_outlined':
        return Icons.person_outline;
      case 'person_rounded':
        return Icons.person_rounded;
      case 'account_circle':
        return Icons.account_circle;
      case 'account_circle_outlined':
        return Icons.account_circle_outlined;

      // Login/Auth icons
      case 'login':
        return Icons.login;
      case 'login_outlined':
        return Icons.login_outlined;
      case 'login_rounded':
        return Icons.login_rounded;
      case 'lock':
        return Icons.lock;
      case 'lock_outline':
        return Icons.lock_outline;
      case 'lock_outlined':
        return Icons.lock_outline;

      // Other common icons
      case 'menu':
        return Icons.menu;
      case 'menu_outlined':
        return Icons.menu_outlined;
      case 'settings':
        return Icons.settings;
      case 'settings_outlined':
        return Icons.settings_outlined;
      case 'notifications':
        return Icons.notifications;
      case 'notifications_outlined':
        return Icons.notifications_outlined;
      case 'notifications_outline':
        return Icons.notifications_outlined;
      case 'info':
        return Icons.info;
      case 'info_outline':
        return Icons.info_outline;
      case 'info_outlined':
        return Icons.info_outline;
      
      // Admin icons
      case 'dashboard':
        return Icons.dashboard;
      case 'people':
        return Icons.people;
      case 'receipt':
        return Icons.receipt;
      case 'admin_panel_settings_outlined':
        return Icons.admin_panel_settings_outlined;
      case 'help_outline':
        return Icons.help_outline;
      case 'email_outlined':
        return Icons.email_outlined;
      case 'location_on_outlined':
        return Icons.location_on_outlined;
      case 'lock_reset_outlined':
        return Icons.lock_reset_outlined;
      case 'star_outline':
        return Icons.star_outline;

      // Default fallback
      default:
        return Icons.info_outline;
    }
  }
}
