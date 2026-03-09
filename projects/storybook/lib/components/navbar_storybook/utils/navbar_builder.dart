import 'package:flutter/material.dart';
import 'package:osmea_components/osmea_components.dart';

/// Utility class for building navbar components with different configurations
/// 
/// This utility provides standardized methods for creating navbar instances
/// with various properties, ensuring consistency across all showcase examples.

class NavbarBuilder {
  /// Creates a basic navbar with standard properties
  static Widget buildBasicNavbar({
    required List<NavbarItem> items,
    required int currentIndex,
    required ValueChanged<int> onItemTap,
    NavbarSize size = NavbarSize.medium,
    NavbarVariant variant = NavbarVariant.retailMain,
    NavbarPosition position = NavbarPosition.bottom,
    double elevation = 4.0,
    bool showLabels = true,
    bool showIcons = true,
    bool centerItems = true,
    bool scrollable = false,
    Color? backgroundColor,
    Color? activeColor,
    BorderRadius? borderRadius,
    Duration? animationDuration,
  }) {
    return OsmeaNavbar(
      size: size,
      variant: variant,
      position: position,
      items: items,
      elevation: elevation,
      showLabels: showLabels,
      showIcons: showIcons,
      centerItems: centerItems,
      scrollable: scrollable,
      currentIndex: currentIndex,
      onItemTap: onItemTap,
      backgroundColor: backgroundColor,
      activeColor: activeColor,
      borderRadius: borderRadius,
      animationDuration: animationDuration,
    );
  }

  /// Creates a primary navbar with brand styling
  static Widget buildPrimaryNavbar({
    required List<NavbarItem> items,
    required int currentIndex,
    required ValueChanged<int> onItemTap,
    NavbarSize size = NavbarSize.medium,
    double elevation = 6.0,
    bool showLabels = true,
    bool showIcons = true,
  }) {
    return buildBasicNavbar(
      items: items,
      currentIndex: currentIndex,
      onItemTap: onItemTap,
      size: size,
      variant: NavbarVariant.retailMain,
      elevation: elevation,
      showLabels: showLabels,
      showIcons: showIcons,
      centerItems: true,
      scrollable: false,
    );
  }

  /// Creates a minimal navbar with neutral styling
  static Widget buildSecondaryNavbar({
    required List<NavbarItem> items,
    required int currentIndex,
    required ValueChanged<int> onItemTap,
    NavbarSize size = NavbarSize.medium,
    double elevation = 2.0,
    bool showLabels = false,
    bool showIcons = true,
  }) {
    return buildBasicNavbar(
      items: items,
      currentIndex: currentIndex,
      onItemTap: onItemTap,
      size: size,
      variant: NavbarVariant.minimal,
      elevation: elevation,
      showLabels: showLabels,
      showIcons: showIcons,
      centerItems: true,
      scrollable: false,
    );
  }

  /// Creates a transparent navbar for overlay usage
  static Widget buildTransparentNavbar({
    required List<NavbarItem> items,
    required int currentIndex,
    required ValueChanged<int> onItemTap,
    NavbarSize size = NavbarSize.medium,
    bool showLabels = false,
    bool showIcons = true,
  }) {
    return buildBasicNavbar(
      items: items,
      currentIndex: currentIndex,
      onItemTap: onItemTap,
      size: size,
      variant: NavbarVariant.mediaOverlay,
      elevation: 0.0,
      showLabels: showLabels,
      showIcons: showIcons,
      centerItems: true,
      scrollable: false,
    );
  }

  /// Creates a glass-effect navbar for modern designs
  static Widget buildGlassNavbar({
    required List<NavbarItem> items,
    required int currentIndex,
    required ValueChanged<int> onItemTap,
    NavbarSize size = NavbarSize.medium,
    double elevation = 8.0,
    bool showLabels = true,
    bool showIcons = true,
  }) {
    return buildBasicNavbar(
      items: items,
      currentIndex: currentIndex,
      onItemTap: onItemTap,
      size: size,
      variant: NavbarVariant.socialGlass,
      elevation: elevation,
      showLabels: showLabels,
      showIcons: showIcons,
      centerItems: true,
      scrollable: false,
      borderRadius: BorderRadius.circular(16),
    );
  }

  /// Creates an outlined navbar for minimal designs
  static Widget buildOutlinedNavbar({
    required List<NavbarItem> items,
    required int currentIndex,
    required ValueChanged<int> onItemTap,
    NavbarSize size = NavbarSize.medium,
    bool showLabels = true,
    bool showIcons = true,
  }) {
    return buildBasicNavbar(
      items: items,
      currentIndex: currentIndex,
      onItemTap: onItemTap,
      size: size,
      variant: NavbarVariant.outlinedMinimal,
      elevation: 0.0,
      showLabels: showLabels,
      showIcons: showIcons,
      centerItems: true,
      scrollable: false,
    );
  }

  /// Creates a demo navbar with multiple items for testing
  static Widget buildDemoNavbar({
    required int currentIndex,
    required ValueChanged<int> onItemTap,
    NavbarVariant variant = NavbarVariant.retailMain,
    NavbarSize size = NavbarSize.medium,
    int itemCount = 4,
    bool showBadges = false,
    bool showDifferentStates = false,
  }) {
    final icons = [
      Icons.home,
      Icons.search,
      Icons.favorite,
      Icons.shopping_cart,
      Icons.person,
      Icons.settings,
    ];
    
    final labels = [
      'Home',
      'Search',
      'Favorites',
      'Cart',
      'Profile',
      'Settings',
    ];

    final items = List.generate(itemCount, (index) {
      NavbarItemState itemState = NavbarItemState.inactive;
      
      if (showDifferentStates) {
        final states = [
          NavbarItemState.active,
          NavbarItemState.inactive,
          NavbarItemState.disabled,
          NavbarItemState.loading,
        ];
        itemState = states[index % states.length];
        if (itemState == NavbarItemState.active && currentIndex != index) {
          itemState = NavbarItemState.inactive;
        }
      } else {
        itemState = currentIndex == index ? NavbarItemState.active : NavbarItemState.inactive;
      }

      return NavbarItem(
        text: labels[index],
        icon: Icon(icons[index]),
        state: itemState,
        onTap: itemState == NavbarItemState.disabled || itemState == NavbarItemState.loading 
          ? null 
          : () => onItemTap(index),
        badge: showBadges && index == 1 ? const Text('3', style: TextStyle(fontSize: 10, color: Colors.white)) : null,
        tooltip: '${labels[index]} tab',
        route: '/navbar/${labels[index].toLowerCase()}',
      );
    });

    return buildBasicNavbar(
      items: items,
      currentIndex: currentIndex,
      onItemTap: onItemTap,
      size: size,
      variant: variant,
    );
  }
}
