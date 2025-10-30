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
  final int wishlistCount;

  const AppNavbar({
    super.key,
    required this.currentIndex,
    this.onItemTap,
    this.wishlistCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AuthStorageHelper().isAuthenticated(),
      builder: (context, snapshot) {
        final isAuthenticated = snapshot.data ?? false;

        return OsmeaComponents.navbar(
          variant: NavbarVariant.transparent,
          size: NavbarSize.medium,
          position: NavbarPosition.bottom,
          currentIndex: currentIndex,
          borderColor: OsmeaColors.silver,
          elevation: .5,
          backgroundColor: OsmeaColors.white,
          items: _getNavbarItems(context, isAuthenticated),
          onItemTap:
              onItemTap ??
              (index) => _navigateToPage(context, index, isAuthenticated),
        );
      },
    );
  }

  /// Get navbar items (5 items: Home, Search, Saved, Cart, Profile/Sign In)
  List<NavbarItem> _getNavbarItems(BuildContext context, bool isAuthenticated) {
    final count = wishlistCount;

    return [
      NavbarItem(
        text: 'Home',
        icon: Icon(Icons.home_outlined),
        onTap: () => context.go('/home'),
        tooltip: 'Home',
      ),
      NavbarItem(
        text: 'Search',
        icon: Icon(Icons.search_outlined),
        onTap: () => context.go('/search'),
        tooltip: 'Search',
      ),
      NavbarItem(
        text: 'Saved',
        icon: Icon(count > 0 ? Icons.favorite : Icons.favorite_outline),
        onTap: () => context.go('/saved'),
        tooltip: 'Saved Items',
      ),
      NavbarItem(
        text: 'Cart',
        icon: Icon(Icons.shopping_cart_outlined),
        onTap: () => context.go('/cart'),
        tooltip: 'Shopping Cart',
      ),
      NavbarItem(
        text: isAuthenticated ? 'Profile' : 'Sign In',
        icon: Icon(
          isAuthenticated ? Icons.person_outline : Icons.login_outlined,
        ),
        onTap: () {
          if (isAuthenticated) {
            // Navigate to profile page (todo: create profile view)
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Profile feature coming soon!'),
                backgroundColor: OsmeaColors.nordicBlue,
              ),
            );
          } else {
            // Navigate to sign in page
            context.go('/auth');
          }
        },
        tooltip: isAuthenticated ? 'Profile' : 'Sign In',
      ),
    ];
  }

  /// Navigate to page based on index
  void _navigateToPage(BuildContext context, int index, bool isAuthenticated) {
    switch (index) {
      case 0: // Home
        context.go('/home');
        break;
      case 1: // Search
        context.go('/search');
        break;
      case 2: // Saved
        context.go('/saved');
        break;
      case 3: // Cart
        context.go('/cart');
        break;
      case 4: // Profile/Sign In
        if (isAuthenticated) {
          // Navigate to profile page (todo: create profile view)
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Profile feature coming soon!'),
              backgroundColor: OsmeaColors.nordicBlue,
            ),
          );
        } else {
          // Navigate to sign in page
          context.go('/auth');
        }
        break;
    }
  }
}
