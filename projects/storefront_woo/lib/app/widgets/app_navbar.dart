/*
 * AppNavbar
 * ---------
 * Centralized navigation bar for the storefront app.
 * Provides consistent navigation across all views.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:go_router/go_router.dart';

/// Centralized navigation bar widget
class AppNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int)? onItemTap;

  const AppNavbar({super.key, required this.currentIndex, this.onItemTap});

  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.navbar(
      variant: NavbarVariant.transparent,
      size: NavbarSize.medium,
      position: NavbarPosition.bottom,
      currentIndex: currentIndex,
      elevation: 0,
      backgroundColor: OsmeaColors.white,
      items: _getNavbarItems(context),
      onItemTap: onItemTap ?? (index) => _navigateToPage(context, index),
    );
  }

  /// Get navbar items
  List<NavbarItem> _getNavbarItems(BuildContext context) {
    return [
      NavbarItem(
        text: 'Home',
        icon: Icon(Icons.home_outlined),
        tooltip: 'Home',
      ),
      NavbarItem(
        text: 'Search',
        icon: Icon(Icons.search_outlined),
        tooltip: 'Search Products',
      ),
      NavbarItem(
        text: 'Cart',
        icon: Icon(Icons.shopping_cart_outlined),
        tooltip: 'Shopping Cart',
      ),
      NavbarItem(
        text: 'Wishlist',
        icon: Icon(Icons.favorite_outline),
        tooltip: 'Wishlist',
      ),
    ];
  }

  /// Navigate to page based on index
  void _navigateToPage(BuildContext context, int index) {
    switch (index) {
      case 0:
        // Home
        context.go('/home');
        break;
      case 1:
        // Search
        context.go('/search');
        break;
      case 2:
        // Cart
        context.go('/cart');
        break;
      case 3:
        // Wishlist
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Wishlist feature coming soon!'),
            backgroundColor: OsmeaColors.nordicBlue,
          ),
        );
        break;
      default:
        // Default to home if index is out of range
        context.go('/home');
        break;
    }
  }
}
