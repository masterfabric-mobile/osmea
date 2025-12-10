import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:osmea_components/osmea_components.dart';
import 'package:osmea_components/src/components/container/container.dart';
import 'package:osmea_components/src/components/stack/stack.dart';
import 'package:osmea_components/src/core/tabbar_container_widget.dart';
import 'package:osmea_components/src/core/tabbar_row_widget.dart';
import 'package:osmea_components/src/components/text/text.dart';
import 'tabbar_cubit.dart';
import 'tabbar_state.dart';

/// 📑 **OSMEA TabBar Component**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/components
///
/// A comprehensive tabbar component that implements all variants
/// defined in the OSMEA design system with full customization support.
/// Combines CoreTabBarContainer and CoreTabBarRow functionality.
///
/// {@category Components}
/// {@subCategory Navigation}
///
/// Features:
/// * 📑 Multiple style variants (primary, secondary, outlined, glass, transparent)
/// * 📏 Three size options (small, medium, large)
/// * 📍 Flexible positioning (top, bottom, left, right)
/// * 🔄 Two behavior styles (fixed, scrollable)
/// * 📊 Multiple indicator styles (line, dot, fill, border, none)
/// * 🎯 Interactive tab items with states
/// * ♿ Full accessibility support
/// * 🌐 RTL/LTR language support
/// * 📱 Responsive design
/// * 🎭 Custom theming capabilities
/// * ⚡ Smooth animations
///
/// ```dart
/// OsmeaTabBar(
///   variant: TabBarVariant.primary,
///   size: TabBarSize.medium,
///   position: TabBarPosition.top,
///   style: TabBarStyle.fixed,
///   tabs: [
///     TabItem(
///       text: 'Home',
///       icon: Icon(Icons.home),
///       onTap: () => handleHomeTab(),
///     ),
///     TabItem(
///       text: 'Profile',
///       icon: Icon(Icons.person),
///       onTap: () => handleProfileTab(),
///     ),
///   ],
/// )
/// ```
///
/// See also:
/// * [TabBarVariant] - Style variants enum
/// * [TabBarSize] - Size variants enum
/// * [TabBarPosition] - Position options enum
/// * [TabBarStyle] - Behavior styles enum
/// * [TabItem] - Individual tab item

/// 📄 **Tab Item Data Class**
///
/// Represents a single item in the tab bar.
/// Contains all necessary information for rendering and interaction.
class TabItem {
  const TabItem({
    required this.text,
    this.icon,
    this.onTap,
    this.state = TabState.inactive,
    this.badge,
    this.tooltip,
    this.route,
    this.enabled = true,
    this.dropdownItems,
    this.isDropdown = false,
  });

  /// 📝 Display text for the tab item
  final String text;

  /// 🎯 Optional icon for the tab item
  final Widget? icon;

  /// 🖱️ Callback when tab is tapped
  final VoidCallback? onTap;

  /// 🔄 Current state of the tab item
  final TabState state;

  /// 🔴 Optional badge (notification count, etc.)
  final Widget? badge;

  /// 💬 Tooltip text for accessibility
  final String? tooltip;

  /// 🛣️ Route path for navigation
  final String? route;

  /// ✅ Whether the tab is enabled
  final bool enabled;

  /// 📝 Dropdown menu items (if this is a dropdown tab)
  final List<DropdownMenuItem<String>>? dropdownItems;

  /// 📝 Whether this tab has dropdown functionality
  final bool isDropdown;

  /// Create a copy with modified properties
  TabItem copyWith({
    String? text,
    Widget? icon,
    VoidCallback? onTap,
    TabState? state,
    Widget? badge,
    String? tooltip,
    String? route,
    bool? enabled,
    List<DropdownMenuItem<String>>? dropdownItems,
    bool? isDropdown,
  }) {
    return TabItem(
      text: text ?? this.text,
      icon: icon ?? this.icon,
      onTap: onTap ?? this.onTap,
      state: state ?? this.state,
      badge: badge ?? this.badge,
      tooltip: tooltip ?? this.tooltip,
      route: route ?? this.route,
      enabled: enabled ?? this.enabled,
      dropdownItems: dropdownItems ?? this.dropdownItems,
      isDropdown: isDropdown ?? this.isDropdown,
    );
  }
}

/// 📑 **OsmeaTabBar**
///
/// A comprehensive tabbar component for the OSMEA UI Kit.
/// Features flexible positioning, multiple variants, and full customization.
/// Inherits from CoreTabBarContainer for container functionality.
///
/// **Features:**
/// - 📏 Multiple size variants (small, medium, large)
/// - 🎨 Theme-aware colors and styles
/// - 📍 Flexible positioning options
/// - 🔄 Different behavior styles (fixed, scrollable)
/// - 📊 Multiple indicator styles
/// - 🎯 Interactive tab items
/// - ✨ Built-in animations and hover effects
/// - 🔧 Fully customizable
///
/// **Example:**
/// ```dart
/// OsmeaTabBar(
///   variant: TabBarVariant.primary,
///   size: TabBarSize.medium,
///   position: TabBarPosition.top,
///   style: TabBarStyle.fixed,
///   tabs: tabItems,
/// )
/// ```
class OsmeaTabBar extends CoreTabBarContainer {
  const OsmeaTabBar({
    super.key,
    super.customTheme,
    required this.tabs,
    super.size = TabBarSize.medium,
    super.variant = TabBarVariant.primary,
    super.position = TabBarPosition.top,
    super.style = TabBarStyle.fixed,
    super.indicatorStyle = TabBarIndicatorStyle.line,
    super.backgroundColor,
    super.borderColor,
    super.shadowColor,
    super.indicatorColor,
    this.activeFillColor,
    super.padding,
    super.margin,
    super.borderRadius,
    super.elevation,
    super.enableGlassEffect = false,
    this.textColor,
    this.activeTextColor,
    this.inactiveTextColor,
    this.iconColor,
    this.activeIconColor,
    this.inactiveIconColor,
    this.animationDuration,
    this.onTabTap,
    this.currentIndex = 0,
    this.showLabels = true,
    this.showIcons = true,
    this.enableAnimation = true,
    this.scrollController,
    this.physics,
    this.spacing,
    this.runSpacing,
  }) : assert(tabs.length > 0, 'TabBar must have at least one tab');

  /// 📋 List of tab items
  final List<TabItem> tabs;

  /// 🎯 Specific color for the tabbar's text, overriding theme defaults
  final Color? textColor;

  /// ✅ Color for active/selected tab text
  final Color? activeTextColor;

  final Color? activeFillColor;

  /// ⚪ Color for inactive/unselected tab text
  final Color? inactiveTextColor;

  /// 🎨 Color for tab icons
  final Color? iconColor;

  /// ✅ Color for active/selected tab icons
  final Color? activeIconColor;

  /// ⚪ Color for inactive/unselected tab icons
  final Color? inactiveIconColor;

  /// ⏱️ Duration for tab animations
  final Duration? animationDuration;

  /// 🖱️ Callback when any tab is tapped (with index)
  final ValueChanged<int>? onTabTap;

  /// 📍 Currently selected tab index
  final int currentIndex;

  /// 📝 Whether to show text labels
  final bool showLabels;

  /// 🎯 Whether to show icons
  final bool showIcons;

  /// ⚡ Whether to enable animations
  final bool enableAnimation;

  /// 🎯 Scroll controller for scrollable tabs
  final ScrollController? scrollController;

  /// 🎮 Scroll physics for scrollable tabs
  final ScrollPhysics? physics;

  /// ↔️ Custom spacing between tabs
  final double? spacing;

  /// ↕️ Run spacing for wrapped tabs
  final double? runSpacing;

  @override
  Widget buildWidget(BuildContext context) {
    // Provide TabBarCubit if not already available
    return BlocProvider<TabBarCubit>(
      create: (context) => TabBarCubit(initialIndex: currentIndex),
      child: BlocBuilder<TabBarCubit, TabBarState>(
        builder: (context, state) {
          // Build the internal row that contains the tabs
          final tabRow = _TabBarRow(
            variant: variant,
            size: size,
            position: position,
            style: style,
            indicatorStyle: indicatorStyle,
            spacing: spacing,
            runSpacing: runSpacing,
            enableAnimation: enableAnimation,
            animationDuration: animationDuration,
            scrollController: scrollController,
            physics: physics,
            children: _buildTabWidgets(context, state),
          );

          // Remove all constraints and let content size naturally
          return tabRow;
        },
      ),
    );
  }

  /// 🎯 Build individual tab widgets
  List<Widget> _buildTabWidgets(BuildContext context, TabBarState state) {
    final tabWidgets = tabs.asMap().entries.map((entry) {
      final index = entry.key;
      final tab = entry.value;
      final isActive =
          index == state.selectedIndex || tab.state == TabState.active;

      return _buildTabWidget(
        context,
        tab.copyWith(state: isActive ? TabState.active : tab.state),
        index,
        state,
      );
    }).toList();

    // For fixed style, wrap tabs in Expanded to ensure equal width distribution
    if (style == TabBarStyle.fixed && position.isHorizontal) {
      return tabWidgets
          .map((tab) => Expanded(
                child: tab,
              ))
          .toList();
    }

    return tabWidgets;
  }

  /// 🎯 Build individual tab widget
  Widget _buildTabWidget(
      BuildContext context, TabItem tab, int index, TabBarState state) {
    final isActive = tab.state == TabState.active;
    final isDisabled = tab.state == TabState.disabled || !tab.enabled;
    final isLoading = tab.state == TabState.loading;

    // Get effective colors
    final effectiveTextColor = _getEffectiveTextColor(context, isActive);
    final effectiveIconColor = _getEffectiveIconColor(context, isActive);

    // Adjust padding based on variant - minimal horizontal padding, keep vertical
    // For secondary variant, use minimal horizontal padding to reduce row width
    final tabPadding = variant == TabBarVariant.secondary
        ? const EdgeInsets.symmetric(horizontal: 0, vertical: 20)
        : const EdgeInsets.symmetric(horizontal: 16, vertical: 12);

    // Adjust border radius based on variant - must match container for seamless look
    final tabBorderRadius = variant == TabBarVariant.secondary
        ? BorderRadius.circular(10)
        : BorderRadius.circular(13);

    // For secondary variant with fixed style, remove constraints to allow equal expansion
    // Also ensure width fills available space
    final tabConstraints =
        (variant == TabBarVariant.secondary && style == TabBarStyle.fixed)
            ? null
            : _getTabConstraints(context);

    Widget tabContent = OsmeaContainer(
      padding: tabPadding,
      constraints: tabConstraints,
      width: (variant == TabBarVariant.secondary && style == TabBarStyle.fixed)
          ? double.infinity
          : null,
      decoration: BoxDecoration(
        color: _getTabBackgroundColor(context, isActive),
        borderRadius: tabBorderRadius,
      ),
      child: _buildTabContent(
        context,
        tab,
        effectiveTextColor,
        effectiveIconColor,
        isActive,
        isLoading,
      ),
    );

    // Add tooltip if specified
    if (tab.tooltip != null) {
      tabContent = Tooltip(
        message: tab.tooltip!,
        child: tabContent,
      );
    }

    // Add badge if specified
    if (tab.badge != null) {
      tabContent = OsmeaStack(
        clipBehavior: clipNone,
        children: [
          tabContent,
          Positioned(
            top: -4,
            right: -4,
            child: tab.badge!,
          ),
        ],
      );
    }

    // Simple tap handling for better compatibility
    Widget tappableTab;

    if (tab.isDropdown &&
        tab.dropdownItems != null &&
        tab.dropdownItems!.isNotEmpty) {
      // Dropdown tab with simple gesture detection
      tappableTab = GestureDetector(
        onTap: isDisabled || isLoading
            ? null
            : () {
                // Use Cubit for state management
                context.read<TabBarCubit>().selectTab(index);
                if (onTabTap != null) onTabTap!(index);
                if (tab.onTap != null) tab.onTap!();
              },
        child: PopupMenuButton<String>(
          onSelected: (value) {
            // Handle dropdown selection with Cubit
            context.read<TabBarCubit>().selectDropdownItem(value);
          },
          itemBuilder: (context) =>
              tab.dropdownItems!.cast<PopupMenuEntry<String>>(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                tabContent,
                const SizedBox(width: 4),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 16,
                  color: effectiveTextColor,
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      // Regular tab with simple gesture detection
      tappableTab = GestureDetector(
        onTap: isDisabled || isLoading
            ? null
            : () {
                // Use Cubit for state management
                context.read<TabBarCubit>().selectTab(index);
                if (onTabTap != null) onTabTap!(index);
                if (tab.onTap != null) tab.onTap!();
              },
        child: tabContent,
      );
    }

    // Add indicator if needed
    if (indicatorStyle != TabBarIndicatorStyle.none && isActive) {
      return Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          tappableTab,
          _buildIndicator(context),
        ],
      );
    }

    return tappableTab;
  }

  /// 🎯 Build tab content (icon + text)
  Widget _buildTabContent(
    BuildContext context,
    TabItem tab,
    Color textColor,
    Color iconColor,
    bool isActive,
    bool isLoading,
  ) {
    final List<Widget> children = [];

    // Add icon if present and should show
    if (tab.icon != null && showIcons) {
      Widget iconWidget = IconTheme(
        data: IconThemeData(
          size: 16, // Smaller for mobile
          color: iconColor,
        ),
        child: tab.icon!,
      );

      // Add consistent constraints for all orientations
      iconWidget = ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 16,
          maxHeight: 16,
        ),
        child: iconWidget,
      );

      children.add(iconWidget);
    }

    // Add text if should show labels
    if (showLabels) {
      Widget textWidget = OsmeaText(
        tab.text,
        style: TextStyle(
          fontSize: variant == TabBarVariant.secondary ? 14 : 13,
          fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          color: textColor,
          height: 1.3,
          letterSpacing: variant == TabBarVariant.secondary ? 0.0 : 0.1,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        softWrap: false,
      );

      children.add(textWidget);
    }

    // Handle loading state
    if (isLoading) {
      children.clear();
      children.add(
        SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2.0,
            valueColor: AlwaysStoppedAnimation<Color>(textColor),
          ),
        ),
      );
    }

    // Simple layout without ParentDataWidget issues
    if (position.isVertical || (tab.icon != null && showLabels && showIcons)) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children,
      );
    } else {
      // For horizontal layout, wrap text in Expanded if both icon and text exist
      if (children.length > 1 && showLabels && showIcons && tab.icon != null) {
        return Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            children[0], // Icon
            SizedBox(width: variant == TabBarVariant.secondary ? 4 : 8),
            Expanded(child: children[1]), // Text with expansion
          ],
        );
      }

      // For text only, center it properly and allow expansion
      return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children.map((child) => Expanded(child: child)).toList(),
      );
    }
  }

  /// 🎨 Get tab background color based on indicator style
  Color _getTabBackgroundColor(BuildContext context, bool isActive) {
    // For secondary variant, always show active tab with white background for segmented control look
    if (variant == TabBarVariant.secondary && isActive) {
      return activeFillColor ?? OsmeaColors.white;
    }

    // For fill indicator, use custom fill color or default indicator color
    if (indicatorStyle == TabBarIndicatorStyle.fill) {
      if (isActive) {
        return activeFillColor ?? getEffectiveIndicatorColor(context);
      }
      return OsmeaColors.transparent;
    }

    // For line, dot, border, and none indicators, keep tabs transparent (except secondary variant active tabs)
    if (indicatorStyle == TabBarIndicatorStyle.line ||
        indicatorStyle == TabBarIndicatorStyle.dot ||
        indicatorStyle == TabBarIndicatorStyle.none ||
        indicatorStyle == TabBarIndicatorStyle.border) {
      return OsmeaColors.transparent;
    }

    return OsmeaColors.transparent;
  }

  /// 🎯 Get effective text color
  Color _getEffectiveTextColor(BuildContext context, bool isActive) {
    if (isActive && activeTextColor != null) return activeTextColor!;
    if (!isActive && inactiveTextColor != null) return inactiveTextColor!;
    if (textColor != null) return textColor!;

    // For line, dot, border, and none indicators, use consistent text colors
    if (indicatorStyle == TabBarIndicatorStyle.line ||
        indicatorStyle == TabBarIndicatorStyle.dot ||
        indicatorStyle == TabBarIndicatorStyle.border ||
        indicatorStyle == TabBarIndicatorStyle.none) {
      switch (variant) {
        case TabBarVariant.primary:
          return isActive
              ? OsmeaColors.white
              : OsmeaColors.white.withValues(alpha: 0.7);
        case TabBarVariant.secondary:
          return isActive
              ? OsmeaColors.nordicBlue
              : OsmeaColors.pewter.withValues(alpha: 0.6);
        case TabBarVariant.outlined:
        case TabBarVariant.glass:
        case TabBarVariant.transparent:
          return isActive
              ? OsmeaColors.nordicBlue
              : OsmeaColors.pewter.withValues(alpha: 0.7);
      }
    }

    // For fill and border indicators, use contrasting colors
    switch (variant) {
      case TabBarVariant.primary:
        // For primary variant, active tabs should have dark text on white background
        return isActive
            ? OsmeaColors.nordicBlue
            : OsmeaColors.white.withValues(alpha: 0.8);
      case TabBarVariant.secondary:
        return isActive
            ? OsmeaColors.nordicBlue
            : OsmeaColors.white.withValues(alpha: 0.6);
      case TabBarVariant.outlined:
      case TabBarVariant.glass:
      case TabBarVariant.transparent:
        return isActive
            ? OsmeaColors.nordicBlue
            : OsmeaColors.white.withValues(alpha: 0.7);
    }
  }

  /// 🎯 Get effective icon color
  Color _getEffectiveIconColor(BuildContext context, bool isActive) {
    if (isActive && activeIconColor != null) return activeIconColor!;
    if (!isActive && inactiveIconColor != null) return inactiveIconColor!;
    if (iconColor != null) return iconColor!;

    return _getEffectiveTextColor(context, isActive);
  }

  /// 📐 Get tab constraints
  BoxConstraints? _getTabConstraints(BuildContext context) {
    // For secondary variant with fixed style, don't use constraints (let Expanded handle it)
    if (variant == TabBarVariant.secondary && style == TabBarStyle.fixed) {
      return null;
    }

    final screenWidth = MediaQuery.of(context).size.width;

    switch (position) {
      case TabBarPosition.top:
      case TabBarPosition.bottom:
        if (style == TabBarStyle.scrollable) {
          // Scrollable tabs can be wider
          return BoxConstraints(
            minWidth: 80,
            maxWidth: math.min(screenWidth * 0.6, 200),
            minHeight: 44,
            maxHeight: 60,
          );
        } else {
          // Fixed tabs should expand equally - constraints will be handled by Expanded widget
          return const BoxConstraints(
            minWidth: 80,
            minHeight: 44,
            maxHeight: 56,
          );
        }
    }
  }

  /// 📊 Build indicator widget
  Widget _buildIndicator(BuildContext context) {
    final indicatorColor = getEffectiveIndicatorColor(context);

    switch (indicatorStyle) {
      case TabBarIndicatorStyle.line:
        return Positioned(
          bottom: 4,
          child: Container(
            width: 40,
            height: 2,
            decoration: BoxDecoration(
              color: indicatorColor,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        );
      case TabBarIndicatorStyle.dot:
        return Positioned(
          bottom: 2,
          child: Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: indicatorColor,
              shape: BoxShape.circle,
            ),
          ),
        );
      case TabBarIndicatorStyle.fill:
        return const SizedBox
            .shrink(); // Fill indicator is handled by tab background
      case TabBarIndicatorStyle.border:
        return Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              color: OsmeaColors.transparent,
              border: Border.all(color: indicatorColor, width: 2.0),
              borderRadius: BorderRadius.circular(13),
            ),
          ),
        );
      case TabBarIndicatorStyle.none:
        return const SizedBox.shrink();
    }
  }
}

/// Internal TabBar Row implementation
class _TabBarRow extends CoreTabBarRow {
  const _TabBarRow({
    required super.variant,
    required super.size,
    required super.position,
    required super.style,
    required super.indicatorStyle,
    super.spacing,
    super.runSpacing,
    super.enableAnimation,
    super.animationDuration,
    super.scrollController,
    super.physics,
    required super.children,
  });
}
