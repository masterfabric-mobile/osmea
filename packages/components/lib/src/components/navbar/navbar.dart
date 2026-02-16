import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:osmea_components/osmea_components.dart';
import 'package:osmea_components/src/components/text/text.dart';
import 'package:osmea_components/src/core/container_widget.dart';

/// 🧭 **OSMEA Components Library - Navbar**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/components
///
/// A comprehensive navigation bar component that implements all variants
/// defined in the OSMEA design system with full customization support.
///
/// {@category Components}
/// {@subCategory Navigation}
///
/// Features:
/// * 🎨 Sector-based style variants (retailMain, retailSidebar, healthcareMinimal, financeBordered, mediaOverlay, socialGlass, enterpriseMain, enterpriseSidebar)
/// * 🎭 Multiple design styles (iconOnly, iconWithText, iconWithSubtext, textOnly, iconAndTextHorizontal, appBar, appBarWithSearch, drawerTrigger, topTabBar)
/// * 🎯 Multiple indicator styles (none, line, dot, fill, border, underline)
/// * 📏 Three size options (small, medium, large)
/// * 📍 Flexible positioning (top, bottom, left, right, floating)
/// * 📋 Subtext/caption support for detailed navigation items
/// * 🍔 Mobile app bar with hamburger menu, title, and actions
/// * 🔍 Search bar integration for app bars
/// * 🎯 Interactive navbar items with states
/// * ♿ Full accessibility support
/// * 🌐 RTL/LTR language support
/// * 📱 Responsive design
/// * 🎭 Custom theming capabilities
///
/// **Bottom Navigation Bar (E-commerce):**
/// ```dart
/// OsmeaNavbar(
///   variant: NavbarVariant.retailMain,
///   size: NavbarSize.medium,
///   position: NavbarPosition.bottom,
///   style: NavbarStyle.iconWithText,
///   indicatorStyle: NavbarIndicatorStyle.line,
///   items: [
///     NavbarItem(text: 'Home', icon: Icon(Icons.home)),
///     NavbarItem(text: 'Search', icon: Icon(Icons.search)),
///     NavbarItem(text: 'Profile', icon: Icon(Icons.person)),
///   ],
/// )
/// ```
///
/// **App Bar with Hamburger Menu (Enterprise):**
/// ```dart
/// OsmeaNavbar(
///   variant: NavbarVariant.retailMain,
///   position: NavbarPosition.top,
///   style: NavbarStyle.appBar,
///   items: [
///     NavbarItem(
///       text: 'My App',
///       title: 'My App',
///       leadingIcon: IconButton(
///         icon: Icon(Icons.menu),
///         onPressed: () => Scaffold.of(context).openDrawer(),
///       ),
///       trailingActions: [
///         IconButton(icon: Icon(Icons.search), onPressed: () {}),
///         IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
///       ],
///     ),
///   ],
/// )
/// ```
///
/// **App Bar with Search (E-commerce):**
/// ```dart
/// OsmeaNavbar(
///   variant: NavbarVariant.retailMain,
///   position: NavbarPosition.top,
///   style: NavbarStyle.appBarWithSearch,
///   items: [
///     NavbarItem(
///       text: 'Search',
///       leadingIcon: IconButton(
///         icon: Icon(Icons.menu),
///         onPressed: () => Scaffold.of(context).openDrawer(),
///       ),
///       searchBar: TextField(
///         decoration: InputDecoration(hintText: 'Search...'),
///       ),
///       trailingActions: [
///         IconButton(icon: Icon(Icons.filter_list), onPressed: () {}),
///       ],
///     ),
///   ],
/// )
/// ```
///
/// **Navbar with Custom Border (Healthcare):**
/// ```dart
/// OsmeaNavbar(
///   variant: NavbarVariant.healthcareMinimal,
///   position: NavbarPosition.bottom,
///   showBorder: true,
///   borderWidth: 2.0,
///   borderColor: OsmeaColors.nordicBlue,
///   borderStyle: BorderStyle.solid,
///   items: navigationItems,
/// )
/// ```
///
/// See also:
/// * [NavbarVariant] - Style variants enum
/// * [NavbarStyle] - Design style patterns enum
/// * [NavbarIndicatorStyle] - Indicator style enum
/// * [NavbarSize] - Size variants enum
/// * [NavbarPosition] - Position options enum
/// * [NavbarItem] - Individual navigation item

/// 📄 **Navbar Item Data Class**
///
/// Represents a single item in the navigation bar.
/// Contains all necessary information for rendering and interaction.
class NavbarItem {
  const NavbarItem({
    required this.text,
    this.icon,
    this.subtext,
    this.onTap,
    this.state = NavbarItemState.inactive,
    this.badge,
    this.tooltip,
    this.route,
    this.iconAnimationTrigger,
    this.animationType = NavbarItemAnimationType.none,
    this.animationTrigger,
    this.animationDuration,
    this.animationCurve = Curves.elasticOut,
    // Mobile app bar specific properties
    this.leadingIcon,
    this.trailingActions,
    this.title,
    this.searchBar,
  });

  /// 📝 Display text for the navbar item
  final String text;

  /// 🎯 Optional icon for the navbar item
  final Widget? icon;

  /// 📋 Optional subtext/caption for the navbar item
  /// Displayed below the main text when style supports it
  final String? subtext;

  /// 🖱️ Callback when item is tapped
  final VoidCallback? onTap;

  /// 🔄 Current state of the navbar item
  final NavbarItemState state;

  /// 🔴 Optional badge (notification count, etc.)
  final Widget? badge;

  /// 💬 Tooltip text for accessibility
  final String? tooltip;

  /// 🛣️ Route path for navigation
  final String? route;

  /// 🍔 Leading icon (hamburger menu, back button, etc.) for app bar style
  /// Displayed on the left side of app bar
  final Widget? leadingIcon;

  /// ⚙️ Trailing action buttons (search, notifications, etc.) for app bar style
  /// Displayed on the right side of app bar
  final List<Widget>? trailingActions;

  /// 📋 Title text for app bar style
  /// Overrides text property when style is appBar or appBarWithSearch
  final String? title;

  /// 🔍 Search bar widget for appBarWithSearch style
  /// Custom search bar implementation
  final Widget? searchBar;

  /// 🎬 Optional animation trigger value for icon animation
  /// When this value changes, icon animation will be triggered
  /// Useful for animated icons like favorite/wishlist icons
  final int? iconAnimationTrigger;

  /// 🎭 Animation type for the navbar item
  /// Determines what kind of animation to apply when trigger changes
  final NavbarItemAnimationType animationType;

  /// 🎯 Animation trigger value
  /// When this value changes, the animation will be triggered
  /// Can be any value (int, String, etc.) - any change triggers animation
  final dynamic animationTrigger;

  /// ⏱️ Custom animation duration
  /// If null, uses navbar's default animation duration
  final Duration? animationDuration;

  /// 📈 Animation curve
  /// Controls the animation easing
  final Curve animationCurve;

  /// Create a copy with modified properties
  NavbarItem copyWith({
    String? text,
    Widget? icon,
    String? subtext,
    VoidCallback? onTap,
    NavbarItemState? state,
    Widget? badge,
    String? tooltip,
    String? route,
    int? iconAnimationTrigger,
    NavbarItemAnimationType? animationType,
    dynamic animationTrigger,
    Duration? animationDuration,
    Curve? animationCurve,
    Widget? leadingIcon,
    List<Widget>? trailingActions,
    String? title,
    Widget? searchBar,
  }) {
    return NavbarItem(
      text: text ?? this.text,
      icon: icon ?? this.icon,
      subtext: subtext ?? this.subtext,
      onTap: onTap ?? this.onTap,
      state: state ?? this.state,
      badge: badge ?? this.badge,
      tooltip: tooltip ?? this.tooltip,
      route: route ?? this.route,
      iconAnimationTrigger: iconAnimationTrigger ?? this.iconAnimationTrigger,
      animationType: animationType ?? this.animationType,
      animationTrigger: animationTrigger ?? this.animationTrigger,
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
      leadingIcon: leadingIcon ?? this.leadingIcon,
      trailingActions: trailingActions ?? this.trailingActions,
      title: title ?? this.title,
      searchBar: searchBar ?? this.searchBar,
    );
  }
}

/// 🧭 **OsmeaNavbar**
///
/// A comprehensive navigation bar component for the OSMEA UI Kit.
/// Features flexible positioning, multiple variants, and full customization.
///
/// **Features:**
/// - 📏 Multiple size variants (small, medium, large)
/// - 🎨 Theme-aware colors and styles
/// - 🎭 Multiple design styles (iconOnly, iconWithText, iconWithSubtext, textOnly, iconAndTextHorizontal, appBar, appBarWithSearch, drawerTrigger, topTabBar)
/// - 🎯 Multiple indicator styles (none, line, dot, fill, border, underline)
/// - 📍 Flexible positioning options (top, bottom, left, right, floating)
/// - 📋 Subtext/caption support for detailed navigation
/// - 🔲 Customizable border (width, style, color)
/// - 🍔 Mobile app bar with hamburger menu, title, and actions
/// - 🔍 Search bar integration for app bars
/// - 🎯 Interactive navbar items with states
/// - ✨ Built-in animations and hover effects
/// - 🔧 Fully customizable
///
/// **Example:**
/// ```dart
/// OsmeaNavbar(
///   variant: NavbarVariant.retailMain,
///   size: NavbarSize.medium,
///   position: NavbarPosition.bottom,
///   style: NavbarStyle.iconWithText,
///   indicatorStyle: NavbarIndicatorStyle.line,
///   indicatorColor: OsmeaColors.nordicBlue,
///   items: navigationItems,
/// )
/// ```
class OsmeaNavbar extends CoreContainer {
  const OsmeaNavbar({
    super.key,
    super.customTheme,
    required this.items,
    this.size = NavbarSize.medium,
    this.variant = NavbarVariant.retailMain,
    this.position = NavbarPosition.top,
    this.style,
    this.indicatorStyle = NavbarIndicatorStyle.none,
    this.backgroundColor,
    this.textColor,
    this.activeColor,
    this.inactiveColor,
    this.borderColor,
    this.shadowColor,
    this.indicatorColor,
    this.borderWidth,
    this.borderStyle,
    this.showBorder,
    super.padding,
    super.margin,
    this.animationDuration,
    this.elevation,
    this.borderRadius,
    this.showLabels = true,
    this.showIcons = true,
    this.centerItems = true,
    this.scrollable = false,
    this.onItemTap,
    this.currentIndex = 0,
  }) : assert(items.length > 0, 'Navbar must have at least one item');

  /// 📋 List of navigation items
  final List<NavbarItem> items;

  /// 📏 The size of the navbar
  final NavbarSize size;

  /// 🎨 The visual style variant of the navbar
  final NavbarVariant variant;

  /// 📍 The position of the navbar
  final NavbarPosition position;

  /// 🎭 The design style/layout pattern of the navbar
  /// If null, automatically determined based on items and position
  final NavbarStyle? style;

  /// 🎯 The indicator style for active items
  final NavbarIndicatorStyle indicatorStyle;

  /// 🎨 Custom background color that overrides the default variant background
  final Color? backgroundColor;

  /// 🎯 Specific color for the navbar's text, overriding theme defaults
  final Color? textColor;

  /// ✅ Color for active/selected items
  final Color? activeColor;

  /// ⚪ Color for inactive/unselected items
  final Color? inactiveColor;

  /// 🔲 Border color for outlined variants
  final Color? borderColor;

  /// ✨ Shadow color for elevated navbars
  final Color? shadowColor;

  /// 🎯 Color for the active indicator (line, dot, fill, etc.)
  final Color? indicatorColor;

  /// 📏 Border width (thickness)
  /// If null, uses default based on variant (1.0 for outlined, 0.0 for others)
  final double? borderWidth;

  /// 🎨 Border style (solid, dashed, dotted)
  /// If null, uses BorderStyle.solid
  final BorderStyle? borderStyle;

  /// 🔲 Whether to show border
  /// If null, automatically determined based on variant
  /// true for outlined variant, false for others
  final bool? showBorder;

  /// ⏱️ Duration for navbar animations
  final Duration? animationDuration;

  /// ✨ Elevation/shadow depth
  final double? elevation;

  /// ⭕ Custom border radius
  final BorderRadius? borderRadius;

  /// 📝 Whether to show text labels
  final bool showLabels;

  /// 🎯 Whether to show icons
  final bool showIcons;

  /// 🎯 Whether to center navbar items
  final bool centerItems;

  /// ↔️ Whether navbar items are scrollable
  final bool scrollable;

  /// 🖱️ Callback when any item is tapped (with index)
  final ValueChanged<int>? onItemTap;

  /// 📍 Currently selected item index
  final int currentIndex;

  @override
  Widget buildWidget(BuildContext context) {
    final config = size.config(context);
    final colors = _getNavbarColors(context);
    final effectiveStyle = _getEffectiveStyle();

    Widget navbar = _buildNavbar(context, config, colors, effectiveStyle);

    // Apply positioning wrapper
    navbar = _buildPositionWrapper(context, navbar, config);

    return navbar;
  }

  /// Determine the effective style based on items and position
  NavbarStyle _getEffectiveStyle() {
    if (style != null) return style!;

    // Special case: iconGrid variant should always show only icons
    if (variant == NavbarVariant.iconGrid) {
      return NavbarStyle.iconOnly;
    }

    // Auto-determine style based on items and position
    final hasIcons = items.any((item) => item.icon != null);
    final hasSubtext = items.any((item) => item.subtext != null);
    final hasLeadingIcon = items.any((item) => item.leadingIcon != null);
    final hasTrailingActions = items.any((item) =>
        item.trailingActions != null && item.trailingActions!.isNotEmpty);
    final hasSearchBar = items.any((item) => item.searchBar != null);
    final isBottomNav = position == NavbarPosition.bottom;
    final isTopNav = position == NavbarPosition.top;

    // Check for mobile app bar patterns
    if (hasLeadingIcon && (hasTrailingActions || hasSearchBar)) {
      if (hasSearchBar) {
        return NavbarStyle.appBarWithSearch;
      }
      return NavbarStyle.appBar;
    }

    // Check for drawer trigger
    if (hasLeadingIcon && items.length == 1 && !hasIcons) {
      return NavbarStyle.drawerTrigger;
    }

    // Check for tab bar
    if (isTopNav && items.length > 1 && hasIcons) {
      return NavbarStyle.topTabBar;
    }

    // Standard patterns
    if (!hasIcons && showIcons) {
      return NavbarStyle.textOnly;
    } else if (hasSubtext) {
      return NavbarStyle.iconWithSubtext;
    } else if (isBottomNav || isTopNav) {
      if (!showLabels) {
        return NavbarStyle.iconOnly;
      } else if (position.isHorizontal) {
        return NavbarStyle.iconWithText;
      } else {
        return NavbarStyle.iconAndTextHorizontal;
      }
    } else {
      return NavbarStyle.iconAndTextHorizontal;
    }
  }

  Widget _buildPositionWrapper(
    BuildContext context,
    Widget navbar,
    NavbarSizeConfig config,
  ) {
    switch (position) {
      case NavbarPosition.floating:
        return Stack(
          children: [
            Positioned(
              top: config.height,
              left: context.normalValue,
              right: context.normalValue,
              child: navbar,
            ),
          ],
        );
      default:
        return navbar;
    }
  }

  Widget _buildNavbar(
    BuildContext context,
    NavbarSizeConfig config,
    _NavbarColors colors,
    NavbarStyle effectiveStyle,
  ) {
    final variantStyle = _getVariantStyle(context, config);

    Widget navbar = Container(
      height: position.isHorizontal ? config.height : null,
      width: position.isVertical ? config.height : null,
      margin: margin,
      decoration: _buildDecoration(context, config, colors),
      child: ClipRect(
        child: SizedBox(
          height: position.isHorizontal ? config.height : null,
          width: position.isVertical ? config.height : null,
          child: _buildContent(context, config, colors, effectiveStyle),
        ),
      ),
    );

    // Apply variant-specific effects (blur for glass, etc.)
    navbar = _applyVariantEffects(context, navbar, variantStyle);

    return navbar;
  }

  /// Apply variant-specific visual effects
  Widget _applyVariantEffects(
    BuildContext context,
    Widget child,
    _NavbarVariantStyle variantStyle,
  ) {
    switch (variant) {
      case NavbarVariant.socialGlass:
        // Apply blur effect for glass morphism
        return ClipRRect(
          borderRadius: variantStyle.borderRadius,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: child,
          ),
        );

      case NavbarVariant.mediaOverlay:
        // No additional effects for overlay
        return child;

      default:
        // No special effects for other variants
        return child;
    }
  }

  Widget _buildContent(
    BuildContext context,
    NavbarSizeConfig config,
    _NavbarColors colors,
    NavbarStyle effectiveStyle,
  ) {
    final itemWidgets = items.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      final isActive =
          index == currentIndex || item.state == NavbarItemState.active;

      return _buildNavbarItem(
        context,
        item.copyWith(state: isActive ? NavbarItemState.active : item.state),
        config,
        colors,
        index,
        effectiveStyle,
      );
    }).toList();

    Widget content;

    if (position.isHorizontal) {
      // Horizontal navbar (top/bottom)
      if (scrollable) {
        content = SingleChildScrollView(
          scrollDirection: horizontal,
          child: Row(
            mainAxisSize: min,
            children: itemWidgets,
          ),
        );
      } else if (centerItems) {
        content = Row(
          mainAxisAlignment: spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: itemWidgets
              .map((widget) => Expanded(
                    child: widget,
                  ))
              .toList(),
        );
      } else {
        content = Row(
          mainAxisAlignment: start,
          children: itemWidgets
              .map((widget) => Flexible(
                    child: widget,
                  ))
              .toList(),
        );
      }
    } else {
      // Vertical navbar (left/right)
      if (scrollable) {
        content = SingleChildScrollView(
          child: Column(
            mainAxisSize: min,
            children: itemWidgets,
          ),
        );
      } else if (centerItems) {
        content = Column(
          mainAxisAlignment: spaceEvenly,
          children: itemWidgets,
        );
      } else {
        content = Column(
          mainAxisAlignment: start,
          children: itemWidgets,
        );
      }
    }

    return content;
  }

  Widget _buildNavbarItem(
    BuildContext context,
    NavbarItem item,
    NavbarSizeConfig config,
    _NavbarColors colors,
    int index,
    NavbarStyle effectiveStyle,
  ) {
    final isActive = item.state == NavbarItemState.active;
    final isDisabled = item.state == NavbarItemState.disabled;
    final isLoading = item.state == NavbarItemState.loading;

    // Get variant-specific item padding
    final variantItemPadding = _getVariantItemPadding(context, config);

    // Build item content
    Widget itemContent = _buildItemContent(
      context,
      item,
      config,
      colors,
      isActive,
      effectiveStyle,
    );

    // Build variant-specific item container with design differences
    Widget child = _buildVariantItemContainer(
      context,
      itemContent,
      variantItemPadding,
      config,
      colors,
      isActive,
    );

    if (item.tooltip != null) {
      child = Tooltip(
        message: item.tooltip!,
        child: child,
      );
    }

    if (item.badge != null) {
      child = Stack(
        clipBehavior: clipNone,
        children: [
          child,
          Positioned(
            top: 0,
            right: 0,
            child: item.badge!,
          ),
        ],
      );
    }

    // Apply animation wrapper if animation is enabled
    if (item.animationType != NavbarItemAnimationType.none &&
        item.animationTrigger != null) {
      child = _AnimatedNavbarItemWrapper(
        animationType: item.animationType,
        animationTrigger: item.animationTrigger,
        duration: item.animationDuration ??
            animationDuration ??
            context.animationMedium,
        curve: item.animationCurve,
        child: child,
      );
    }

    // Apply variant-specific indicator/design
    child = _applyVariantItemDesign(
      context,
      child,
      item,
      colors,
      isActive,
      effectiveStyle,
      config,
    );

    return AnimatedContainer(
      duration: animationDuration ?? context.animationMedium,
      curve: easeInOutCubic,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isDisabled || isLoading
              ? null
              : () {
                  if (onItemTap != null) onItemTap!(index);
                  if (item.onTap != null) item.onTap!();
                },
          borderRadius: _getVariantItemBorderRadius(context),
          splashColor: colors.active.withValues(alpha: context.alpha20),
          highlightColor: colors.active.withValues(alpha: context.alpha10),
          child: child,
        ),
      ),
    );
  }

  /// Build variant-specific item container with completely different designs
  /// Each variant has a UNIQUE visual design that is immediately distinguishable
  Widget _buildVariantItemContainer(
    BuildContext context,
    Widget content,
    EdgeInsetsGeometry padding,
    NavbarSizeConfig config,
    _NavbarColors colors,
    bool isActive,
  ) {
    final effectiveIndicatorColor = indicatorColor ?? colors.active;

    switch (variant) {
      case NavbarVariant.retailMain:
        // 🛒 RETAIL MAIN - Flat, standard design
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: isActive
                ? effectiveIndicatorColor.withValues(alpha: context.alpha20)
                : colors.background.withValues(alpha: context.alpha50),
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: padding,
          clipBehavior: Clip.hardEdge,
          child: Center(child: content),
        );

      case NavbarVariant.dottedOutline:
        // 🔘 DOTTED OUTLINE - Top line indicator with minimal design
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: padding,
          clipBehavior: Clip.hardEdge,
          child: Center(child: content),
        );

      case NavbarVariant.healthcareMinimal:
        // 🏥 HEALTHCARE MINIMAL - Flat, minimal border design
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: isActive
                ? effectiveIndicatorColor.withValues(alpha: context.alpha10)
                : Colors.white,
            borderRadius: BorderRadius.circular(4.0),
            border: Border.all(
              color: isActive
                  ? effectiveIndicatorColor.withValues(alpha: context.alpha40)
                  : colors.border.withValues(alpha: context.alpha30),
              width: isActive ? 1.5 : 1.0,
            ),
          ),
          padding: padding,
          clipBehavior: Clip.hardEdge,
          child: Center(child: content),
        );

      case NavbarVariant.outlinedMinimal:
        // 🪟 OUTLINED MINIMAL - Temiz, ince kenarlık tasarımı
        return Container(
          decoration: BoxDecoration(
            color: isActive
                ? effectiveIndicatorColor.withValues(alpha: context.alpha15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(100.0),
            border: isActive
                ? Border.all(
                    color: effectiveIndicatorColor,
                    width: 0.5,
                  )
                : null,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: context.lowValue * 0.8,
            vertical: context.lowValue * 0.5,
          ),
          clipBehavior: Clip.hardEdge,
          child: Center(
            child: SizedBox(
              width: config.iconSize,
              height: config.iconSize,
              child: Center(child: content),
            ),
          ),
        );

      case NavbarVariant.mediaOverlay:
        // 🎬 MEDIA OVERLAY - Şeffaf, düz tasarım
        return Container(
          width: double.infinity,
          height: double.infinity,
          clipBehavior: Clip.none,
          child: Center(child: content),
        );

      case NavbarVariant.socialGlass:
        // 📱 SOCIAL GLASS - Flat, rounded design
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: isActive
                ? effectiveIndicatorColor.withValues(alpha: context.alpha20)
                : colors.background.withValues(alpha: context.alpha40),
            borderRadius: BorderRadius.circular(20.0),
            border: isActive
                ? null
                : Border.all(
                    color: colors.border.withValues(alpha: context.alpha20),
                    width: 0.5,
                  ),
          ),
          padding: padding,
          clipBehavior: Clip.hardEdge,
          child: Center(child: content),
        );

      case NavbarVariant.enterpriseMain:
        // 🏢 ENTERPRISE MAIN - Flat design with bottom border
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isActive ? effectiveIndicatorColor : Colors.transparent,
                width: isActive ? 3.0 : 0.0,
              ),
            ),
          ),
          padding: padding,
          clipBehavior: Clip.hardEdge,
          child: Center(child: content),
        );

      case NavbarVariant.iconGrid:
        // 🔳 ICON GRID - Grid-based icon navigation
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: isActive
                ? effectiveIndicatorColor.withValues(alpha: context.alpha15)
                : Colors.transparent,
            border: Border.all(
              color: colors.border.withValues(alpha: context.alpha20),
              width: 1.0,
            ),
          ),
          padding: padding,
          clipBehavior: Clip.hardEdge,
          child: Center(child: content),
        );

      case NavbarVariant.floatingCards:
        // 📱 FLOATING CARDS - Clean elevated cards with subtle shadows
        return Container(
          width: double.infinity,
          height: double.infinity,
          margin: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 4.0,
                offset: const Offset(0, 2.0),
                spreadRadius: 0,
              ),
            ],
          ),
          padding: padding,
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              transform: Matrix4.identity()..scale(isActive ? 1.02 : 1.0),
              child: content,
            ),
          ),
        );
      case NavbarVariant.pillShaped:
        // 🎯 PILL SHAPED - Hap şekilli tasarım
        return Container(
          decoration: BoxDecoration(
            color: isActive
                ? effectiveIndicatorColor.withValues(alpha: context.alpha25)
                : colors.background.withValues(alpha: context.alpha45),
            borderRadius: BorderRadius.circular(24.0),
            border: isActive
                ? null
                : Border.all(
                    color: colors.border.withValues(alpha: context.alpha25),
                    width: 0.8,
                  ),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: context.lowValue * 0.8,
            vertical: context.lowValue * 0.5,
          ),
          clipBehavior: Clip.hardEdge,
          child: Center(
            child: SizedBox(
              width: config.iconSize,
              height: config.iconSize,
              child: Center(child: content),
            ),
          ),
        );

      case NavbarVariant.minimal:
        // ✨ MINIMAL - Sadece icon rengi değişir, tamamen şeffaf
        return Container(
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: context.lowValue * 0.8,
            vertical: context.lowValue * 0.5,
          ),
          clipBehavior: Clip.hardEdge,
          child: Center(
            child: SizedBox(
              width: config.iconSize,
              height: config.iconSize,
              child: Center(child: content),
            ),
          ),
        );

      case NavbarVariant.solidOutlined:
        // 🎯 SOLID OUTLINED - Solid arka plan + border
        return Container(
          decoration: BoxDecoration(
            color: isActive ? effectiveIndicatorColor : Colors.transparent,
            borderRadius: BorderRadius.circular(100.0),
            border: isActive
                ? Border.all(
                    color: effectiveIndicatorColor,
                    width: 0.5,
                  )
                : null,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: context.lowValue * 0.8,
            vertical: context.lowValue * 0.5,
          ),
          clipBehavior: Clip.hardEdge,
          child: Center(
            child: SizedBox(
              width: config.iconSize,
              height: config.iconSize,
              child: Center(child: content),
            ),
          ),
        );

      case NavbarVariant.minimalDot:
        // ⭕ MINIMAL DOT - Şeffaf, dot indicator ile
        return Container(
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: context.lowValue * 0.8,
            vertical: context.lowValue * 0.5,
          ),
          clipBehavior: Clip.hardEdge,
          child: Center(
            child: SizedBox(
              width: config.iconSize,
              height: config.iconSize,
              child: Center(child: content),
            ),
          ),
        );

      case NavbarVariant.brutalist:
        // ⬛ BRUTALIST - Sharp corners, bold border design
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white, // Always white background - text is readable
            border: isActive
                ? Border.all(
                    color: Colors.black,
                    width: 0.5, // Bold border only for active item
                  )
                : null, // No border for inactive items
            borderRadius: BorderRadius.zero, // Sharp corners
            boxShadow: isActive
                ? [
                    // Brutalist hard shadow - no blur, offset only
                    const BoxShadow(
                      color: Colors.black,
                      offset: Offset(3, 3), // Hard, geometric shadow
                      blurRadius: 0, // Blur yok - brutalist
                    ),
                  ]
                : null,
          ),
          padding: padding,
          clipBehavior: Clip.hardEdge,
          child: Center(child: content),
        );

      case NavbarVariant.badgeIndicator:
        // 🔘 BADGE INDICATOR - Badge style, flat design
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: isActive
                ? effectiveIndicatorColor.withValues(alpha: context.alpha15)
                : colors.background.withValues(alpha: context.alpha35),
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: isActive
                  ? effectiveIndicatorColor.withValues(alpha: context.alpha35)
                  : colors.border.withValues(alpha: context.alpha25),
              width: isActive ? 1.5 : 0.8,
            ),
          ),
          padding: padding,
          clipBehavior: Clip.hardEdge,
          child: Center(child: content),
        );

      case NavbarVariant.neumorphic:
        // 🌙 NEUMORPHIC - Soft 3D effect design
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: isActive
                ? colors.background.withValues(alpha: context.alpha90)
                : colors.background.withValues(alpha: context.alpha70),
            borderRadius: BorderRadius.circular(12.0),
          ),
          padding: padding,
          clipBehavior: Clip.hardEdge,
          child: Center(child: content),
        );

      case NavbarVariant.cardFloating:
        // 🎴 CARD FLOATING - Flat, standard card design
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: isActive
                ? Colors.white
                : colors.background.withValues(alpha: context.alpha50),
            borderRadius: BorderRadius.circular(12.0),
            border: isActive
                ? null
                : Border.all(
                    color: colors.border.withValues(alpha: context.alpha30),
                    width: 0.8,
                  ),
          ),
          padding: padding,
          clipBehavior: Clip.hardEdge,
          child: Center(child: content),
        );

      case NavbarVariant.bubble:
        // 🫧 BUBBLE - Playful bubble design
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: isActive
                ? effectiveIndicatorColor.withValues(alpha: context.alpha30)
                : colors.background.withValues(alpha: context.alpha20),
            borderRadius: BorderRadius.circular(30.0),
          ),
          padding: padding,
          clipBehavior: Clip.hardEdge,
          child: Center(child: content),
        );

      case NavbarVariant.glassyBlur:
        // ✨ GLASSY BLUR - Glassmorphism design
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: isActive
                ? effectiveIndicatorColor.withValues(alpha: context.alpha25)
                : colors.background.withValues(alpha: context.alpha15),
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(
              color: isActive
                  ? Colors.white.withValues(alpha: context.alpha50)
                  : Colors.white.withValues(alpha: context.alpha30),
              width: 1.0,
            ),
          ),
          padding: padding,
          clipBehavior: Clip.hardEdge,
          child: Center(child: content),
        );

      case NavbarVariant.markerTab:
        // 📍 MARKER TAB - Tab with marker indicator
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          padding: padding,
          clipBehavior: Clip.hardEdge,
          child: Center(child: content),
        );

      case NavbarVariant.stepped:
        // 🔲 STEPPED - Stepped design
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: isActive
                ? effectiveIndicatorColor.withValues(alpha: context.alpha20)
                : colors.background.withValues(alpha: context.alpha10),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8.0),
              topRight: Radius.circular(8.0),
            ),
            border: Border(
              top: BorderSide(
                color: isActive
                    ? effectiveIndicatorColor
                    : colors.border.withValues(alpha: context.alpha30),
                width: isActive ? 3.0 : 1.0,
              ),
            ),
          ),
          padding: padding,
          clipBehavior: Clip.hardEdge,
          child: Center(child: content),
        );

      case NavbarVariant.ribbon:
        // 🎪 RIBBON - Ribbon design
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: isActive
                ? effectiveIndicatorColor.withValues(alpha: context.alpha30)
                : colors.background.withValues(alpha: context.alpha20),
            borderRadius: BorderRadius.circular(4.0),
          ),
          padding: padding,
          clipBehavior: Clip.hardEdge,
          child: Center(child: content),
        );
    }
  }

  /// Apply variant-specific visual design (indicators, effects) - Each variant has unique design
  Widget _applyVariantItemDesign(
    BuildContext context,
    Widget child,
    NavbarItem item,
    _NavbarColors colors,
    bool isActive,
    NavbarStyle effectiveStyle,
    NavbarSizeConfig config,
  ) {
    final effectiveIndicatorColor = indicatorColor ?? colors.active;

    // Don't show indicator if text is present
    final hasText = showLabels && item.text.isNotEmpty;

    // Always apply variant-specific design first
    Widget result = child;

    switch (variant) {
      case NavbarVariant.retailMain:
        // 🛒 Already handled in container (full segment fill)
        return child;

      case NavbarVariant.dottedOutline:
        // 🔘 TOP INDICATOR BAR - Colored line indicator at top
        if (!isActive) return child;
        return Stack(
          clipBehavior: clipNone,
          alignment: Alignment.topCenter,
          children: [
            child,
            Positioned(
              top: 0,
              left: config.iconSize * 0.2,
              right: config.iconSize * 0.2,
              child: Container(
                height: 2.0,
                decoration: BoxDecoration(
                  color: effectiveIndicatorColor,
                  borderRadius: BorderRadius.circular(1.0),
                ),
              ),
            ),
          ],
        );

      case NavbarVariant.healthcareMinimal:
        // 🏥 DOT INDICATOR - Small dot at bottom/right (only when no text)
        if (hasText) return child;
        return Stack(
          clipBehavior: clipNone,
          children: [
            child,
            Positioned(
              bottom: position.isHorizontal ? 6.0 : null,
              top: position.isHorizontal ? null : 6.0,
              right: position.isHorizontal ? 6.0 : null,
              left: position.isHorizontal ? null : 6.0,
              child: Container(
                width: 6.0,
                height: 6.0,
                decoration: BoxDecoration(
                  color: effectiveIndicatorColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        );

      case NavbarVariant.outlinedMinimal:
        // 🪟 Already handled in container (outlined minimal)
        return child;

      case NavbarVariant.minimal:
        // 🎯 MINIMAL - No additional design
        return child;

      case NavbarVariant.solidOutlined:
        // 🎨 SOLID OUTLINED - Already handled in container
        return child;

      case NavbarVariant.minimalDot:
        // ⭕ MINIMAL DOT - Dot indicator below icon
        if (hasText || !isActive) return child;
        return Stack(
          clipBehavior: clipNone,
          children: [
            child,
            Positioned(
              bottom: -4.0,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 4.0,
                  height: 4.0,
                  decoration: BoxDecoration(
                    color: effectiveIndicatorColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ],
        );

      case NavbarVariant.mediaOverlay:
        // 🎬 MEDIA OVERLAY - Flat underline indicator (only when no text)
        if (hasText) return child;
        return Stack(
          clipBehavior: clipNone,
          children: [
            child,
            // Underline - centered, shorter than full width
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: config.iconSize * 0.8,
                  height: 2.0,
                  decoration: BoxDecoration(
                    color: effectiveIndicatorColor,
                    borderRadius: BorderRadius.circular(1.0),
                  ),
                ),
              ),
            ),
          ],
        );

      case NavbarVariant.socialGlass:
        // 📱 Already handled in container (pill-shaped)
        return child;

      case NavbarVariant.enterpriseMain:
        // 🏢 Already handled in container (bottom line)
        return child;

      case NavbarVariant.iconGrid:
        // 🔳 Already handled in container (grid)
        return child;

      case NavbarVariant.floatingCards:
        // 📱 Already handled in container (floating cards)
        return child;

      case NavbarVariant.pillShaped:
        // 💊 PILL SHAPED - Active item with white content
        // Container already has filled background, no extra styling needed here
        return child;

      case NavbarVariant.brutalist:
        // ⬛ Already handled in container (brutalist)
        return child;

      case NavbarVariant.badgeIndicator:
        // 🔘 BADGE INDICATOR - Badge above item (only when no text)
        if (hasText) return child;
        return Stack(
          clipBehavior: clipNone,
          children: [
            child,
            Positioned(
              top: -4.0,
              right: position.isHorizontal ? null : -4.0,
              left: position.isHorizontal ? -4.0 : null,
              child: Container(
                width: 12.0,
                height: 12.0,
                decoration: BoxDecoration(
                  color: effectiveIndicatorColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2.0,
                  ),
                ),
              ),
            ),
          ],
        );

      case NavbarVariant.neumorphic:
        // 🌙 Already handled in container (neumorphic)
        return child;

      case NavbarVariant.cardFloating:
        // 🎴 Already handled in container (floating card)
        result = child;
        break;

      case NavbarVariant.bubble:
        // 🫧 Already handled in container (bubble)
        return child;

      case NavbarVariant.glassyBlur:
        // ✨ Already handled in container (glassy blur)
        return child;

      case NavbarVariant.markerTab:
        // 📍 MARKER TAB - Marker indicator (only when no text)
        if (hasText) return child;
        return Stack(
          clipBehavior: clipNone,
          children: [
            child,
            Positioned(
              bottom: position.isHorizontal ? 2.0 : null,
              left: position.isHorizontal ? 0 : 2.0,
              right: position.isHorizontal ? 0 : null,
              child: Center(
                child: Container(
                  width: 6.0,
                  height: 6.0,
                  decoration: BoxDecoration(
                    color: effectiveIndicatorColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ],
        );

      case NavbarVariant.stepped:
        // 🔲 Already handled in container (stepped)
        return child;

      case NavbarVariant.ribbon:
        // 🎪 Already handled in container (ribbon)
        return child;
    }

    // If user explicitly set indicatorStyle AND item is active AND no text, apply it as additional style
    // Don't show indicator if text is present
    if (isActive && indicatorStyle != NavbarIndicatorStyle.none && !hasText) {
      result = _applyIndicatorStyle(
        context,
        result,
        effectiveIndicatorColor,
        config,
      );
    }

    return result;
  }

  /// Apply indicator style based on indicatorStyle parameter
  Widget _applyIndicatorStyle(
    BuildContext context,
    Widget child,
    Color effectiveIndicatorColor,
    NavbarSizeConfig config,
  ) {
    switch (indicatorStyle) {
      case NavbarIndicatorStyle.none:
        return child;

      case NavbarIndicatorStyle.line:
        // Thin line indicator
        return Stack(
          clipBehavior: clipNone,
          children: [
            child,
            Positioned(
              bottom: position.isHorizontal ? 0 : null,
              top: position.isHorizontal ? null : 0,
              left: position.isHorizontal ? null : 0,
              right: position.isHorizontal ? null : 0,
              child: Center(
                child: Container(
                  height: position.isHorizontal ? 2.0 : null,
                  width: position.isHorizontal ? null : 2.0,
                  constraints: BoxConstraints(
                    maxWidth:
                        position.isHorizontal ? config.iconSize * 0.6 : 2.0,
                    maxHeight:
                        position.isHorizontal ? 2.0 : config.iconSize * 0.6,
                  ),
                  decoration: BoxDecoration(
                    color: effectiveIndicatorColor,
                    borderRadius: BorderRadius.circular(1.0),
                  ),
                ),
              ),
            ),
          ],
        );

      case NavbarIndicatorStyle.dot:
        // Dot indicator
        return Stack(
          clipBehavior: clipNone,
          children: [
            child,
            Positioned(
              bottom: position.isHorizontal ? 4.0 : null,
              top: position.isHorizontal ? null : 4.0,
              right: position.isHorizontal ? 4.0 : null,
              left: position.isHorizontal ? null : 4.0,
              child: Container(
                width: 8.0,
                height: 8.0,
                decoration: BoxDecoration(
                  color: effectiveIndicatorColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        );

      case NavbarIndicatorStyle.fill:
        // Already handled in container
        return child;

      case NavbarIndicatorStyle.border:
        // Already handled in container
        return child;

      case NavbarIndicatorStyle.underline:
        // Underline indicator
        return Stack(
          clipBehavior: clipNone,
          children: [
            child,
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: config.iconSize * 0.8,
                  height: 3.0,
                  decoration: BoxDecoration(
                    color: effectiveIndicatorColor,
                    borderRadius: BorderRadius.circular(1.5),
                  ),
                ),
              ),
            ),
          ],
        );

      case NavbarIndicatorStyle.gradient:
        // Gradient fill indicator
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                effectiveIndicatorColor,
                effectiveIndicatorColor.withValues(alpha: context.alpha70),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: child,
        );

      case NavbarIndicatorStyle.badge:
        // Badge indicator
        return Stack(
          clipBehavior: clipNone,
          children: [
            child,
            Positioned(
              top: -4.0,
              right: position.isHorizontal ? null : -4.0,
              left: position.isHorizontal ? -4.0 : null,
              child: Container(
                width: 12.0,
                height: 12.0,
                decoration: BoxDecoration(
                  color: effectiveIndicatorColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2.0,
                  ),
                ),
              ),
            ),
          ],
        );

      case NavbarIndicatorStyle.capsule:
        // Capsule-shaped indicator
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: context.normalValue * 0.75,
            vertical: context.lowValue * 0.5,
          ),
          decoration: BoxDecoration(
            color: effectiveIndicatorColor.withValues(alpha: context.alpha25),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: child,
        );
    }
  }

  /// Get variant-specific border radius for item - Each variant has unique radius
  BorderRadius _getVariantItemBorderRadius(BuildContext context) {
    switch (variant) {
      case NavbarVariant.retailMain:
        return BorderRadius.circular(8.0);
      case NavbarVariant.dottedOutline:
        return BorderRadius.circular(8.0);
      case NavbarVariant.healthcareMinimal:
        return BorderRadius.circular(4.0);
      case NavbarVariant.outlinedMinimal:
        return BorderRadius.circular(100.0); // Pill-shaped
      case NavbarVariant.mediaOverlay:
        return BorderRadius.circular(12.0);
      case NavbarVariant.socialGlass:
        return BorderRadius.circular(20.0);
      case NavbarVariant.enterpriseMain:
        return BorderRadius.zero;
      case NavbarVariant.iconGrid:
        return BorderRadius.zero;
      case NavbarVariant.floatingCards:
        return BorderRadius.circular(12.0);
      case NavbarVariant.pillShaped:
        return BorderRadius.circular(24.0);
      case NavbarVariant.brutalist:
        return BorderRadius.zero;
      case NavbarVariant.badgeIndicator:
        return BorderRadius.circular(8.0);
      case NavbarVariant.neumorphic:
        return BorderRadius.circular(12.0);
      case NavbarVariant.cardFloating:
        return BorderRadius.circular(12.0);
      case NavbarVariant.bubble:
        return BorderRadius.circular(30.0);
      case NavbarVariant.glassyBlur:
        return BorderRadius.circular(16.0);
      case NavbarVariant.markerTab:
        return BorderRadius.circular(4.0);
      case NavbarVariant.stepped:
        return const BorderRadius.only(
          topLeft: Radius.circular(8.0),
          topRight: Radius.circular(8.0),
        );
      case NavbarVariant.ribbon:
        return BorderRadius.circular(4.0);
      case NavbarVariant.minimal:
      case NavbarVariant.solidOutlined:
      case NavbarVariant.minimalDot:
        return BorderRadius.circular(100.0); // Pill-shaped
    }
  }

  /// Get variant-specific item padding
  EdgeInsetsGeometry _getVariantItemPadding(
    BuildContext context,
    NavbarSizeConfig config,
  ) {
    final basePadding = config.itemPadding as EdgeInsets;

    switch (variant) {
      case NavbarVariant.retailMain:
        // Minimal padding for compact look
        return EdgeInsets.symmetric(
          horizontal: basePadding.horizontal * 0.6,
          vertical: basePadding.vertical * 0.15,
        );

      case NavbarVariant.dottedOutline:
        return EdgeInsets.symmetric(
          horizontal: basePadding.horizontal * 0.6,
          vertical: basePadding.vertical * 0.4,
        );

      case NavbarVariant.healthcareMinimal:
        // Minimal padding for clean look
        return EdgeInsets.symmetric(
          horizontal: basePadding.horizontal * 0.6,
          vertical: basePadding.vertical * 0.4,
        );

      case NavbarVariant.outlinedMinimal:
        // Pill-shaped item padding - minimal
        return EdgeInsets.symmetric(
          horizontal: basePadding.horizontal * 0.2,
          vertical: basePadding.vertical * 0.2,
        );

      case NavbarVariant.mediaOverlay:
        // Minimal padding to prevent overflow
        return EdgeInsets.symmetric(
          horizontal: basePadding.horizontal * 0.6,
          vertical: basePadding.vertical * 0.4,
        );

      case NavbarVariant.socialGlass:
        // Minimal padding to prevent overflow
        return EdgeInsets.symmetric(
          horizontal: basePadding.horizontal * 0.6,
          vertical: basePadding.vertical * 0.4,
        );

      case NavbarVariant.enterpriseMain:
        return config.itemPadding;

      case NavbarVariant.iconGrid:
        return EdgeInsets.symmetric(
          horizontal: basePadding.horizontal * 0.5,
          vertical: basePadding.vertical * 0.5,
        );

      case NavbarVariant.floatingCards:
        return EdgeInsets.symmetric(
          horizontal: basePadding.horizontal * 0.4,
          vertical: basePadding.vertical * 0.3,
        );

      case NavbarVariant.pillShaped:
        return EdgeInsets.symmetric(
          horizontal: basePadding.horizontal * 0.6,
          vertical: basePadding.vertical * 0.4,
        );

      case NavbarVariant.brutalist:
        return EdgeInsets.symmetric(
          horizontal: basePadding.horizontal * 0.5,
          vertical: basePadding.vertical * 0.4,
        );

      case NavbarVariant.badgeIndicator:
        return EdgeInsets.symmetric(
          horizontal: basePadding.horizontal * 0.6,
          vertical: basePadding.vertical * 0.4,
        );

      case NavbarVariant.neumorphic:
        return EdgeInsets.symmetric(
          horizontal: basePadding.horizontal * 0.6,
          vertical: basePadding.vertical * 0.4,
        );

      case NavbarVariant.cardFloating:
        return EdgeInsets.symmetric(
          horizontal: basePadding.horizontal * 0.6,
          vertical: basePadding.vertical * 0.4,
        );

      case NavbarVariant.bubble:
        return EdgeInsets.symmetric(
          horizontal: basePadding.horizontal * 0.5,
          vertical: basePadding.vertical * 0.4,
        );

      case NavbarVariant.glassyBlur:
        return EdgeInsets.symmetric(
          horizontal: basePadding.horizontal * 0.6,
          vertical: basePadding.vertical * 0.4,
        );

      case NavbarVariant.markerTab:
        return EdgeInsets.symmetric(
          horizontal: basePadding.horizontal * 0.6,
          vertical: basePadding.vertical * 0.4,
        );

      case NavbarVariant.stepped:
        return EdgeInsets.symmetric(
          horizontal: basePadding.horizontal * 0.6,
          vertical: basePadding.vertical * 0.4,
        );

      case NavbarVariant.ribbon:
        return EdgeInsets.symmetric(
          horizontal: basePadding.horizontal * 0.6,
          vertical: basePadding.vertical * 0.4,
        );

      case NavbarVariant.minimal:
      case NavbarVariant.solidOutlined:
      case NavbarVariant.minimalDot:
        // Minimal styles item padding
        return EdgeInsets.symmetric(
          horizontal: basePadding.horizontal * 0.2,
          vertical: basePadding.vertical * 0.2,
        );
    }
  }

  Widget _buildItemContent(
    BuildContext context,
    NavbarItem item,
    NavbarSizeConfig config,
    _NavbarColors colors,
    bool isActive,
    NavbarStyle effectiveStyle,
  ) {
    // Smart text color handling based on variant and state
    Color textColor;

    // Special variants with specific color rules
    if (variant == NavbarVariant.outlinedMinimal ||
        variant == NavbarVariant.pillShaped ||
        variant == NavbarVariant.minimal ||
        variant == NavbarVariant.minimalDot) {
      // Use activeColor for icons
      textColor = isActive ? colors.active : colors.inactive;
    } else if (variant == NavbarVariant.solidOutlined) {
      // White text on solid background when active
      textColor = isActive ? OsmeaColors.white : colors.inactive;
    } else if (variant == NavbarVariant.brutalist) {
      // Inverted colors for brutalist
      textColor = isActive ? OsmeaColors.white : OsmeaColors.black;
    } else if (variant == NavbarVariant.enterpriseMain) {
      // Always white for dark enterprise background
      textColor = OsmeaColors.white;
    } else {
      // Default: use theme colors
      textColor = isActive ? colors.active : colors.inactive;
    }

    final subtextColor = textColor.withValues(alpha: context.alpha70);

    // Handle loading state
    if (item.state == NavbarItemState.loading) {
      return Center(
        child: SizedBox(
          width: config.iconSize,
          height: config.iconSize,
          child: CircularProgressIndicator(
            strokeWidth: context.width2,
            valueColor: AlwaysStoppedAnimation<Color>(textColor),
          ),
        ),
      );
    }

    // Build content based on style
    switch (effectiveStyle) {
      case NavbarStyle.iconOnly:
        return _buildIconOnlyContent(context, item, config, textColor);

      case NavbarStyle.iconWithText:
        return _buildIconWithTextContent(
          context,
          item,
          config,
          textColor,
          isActive,
        );

      case NavbarStyle.iconWithSubtext:
        return _buildIconWithSubtextContent(
          context,
          item,
          config,
          textColor,
          subtextColor,
          isActive,
        );

      case NavbarStyle.textOnly:
        return _buildTextOnlyContent(
          context,
          item,
          config,
          textColor,
          isActive,
        );

      case NavbarStyle.iconAndTextHorizontal:
        return _buildIconAndTextHorizontalContent(
          context,
          item,
          config,
          textColor,
          isActive,
        );

      case NavbarStyle.appBar:
        return _buildAppBarContent(
          context,
          item,
          config,
          textColor,
          colors,
        );

      case NavbarStyle.appBarWithSearch:
        return _buildAppBarWithSearchContent(
          context,
          item,
          config,
          textColor,
          colors,
        );

      case NavbarStyle.drawerTrigger:
        return _buildDrawerTriggerContent(
          context,
          item,
          config,
          textColor,
        );

      case NavbarStyle.topTabBar:
        return _buildTopTabBarContent(
          context,
          item,
          config,
          textColor,
          isActive,
        );

      case NavbarStyle.segmentedControl:
        return _buildSegmentedControlContent(
          context,
          item,
          config,
          textColor,
          isActive,
        );

      case NavbarStyle.floatingBottomBar:
        return _buildFloatingBottomBarContent(
          context,
          item,
          config,
          textColor,
          isActive,
        );

      case NavbarStyle.denseCompact:
        return _buildDenseCompactContent(
          context,
          item,
          config,
          textColor,
          isActive,
        );

      case NavbarStyle.collapsible:
        return _buildCollapsibleContent(
          context,
          item,
          config,
          textColor,
          isActive,
        );

      case NavbarStyle.navigationRail:
        return _buildNavigationRailContent(
          context,
          item,
          config,
          textColor,
          isActive,
        );

      case NavbarStyle.bottomSheetNav:
        return _buildBottomSheetNavContent(
          context,
          item,
          config,
          textColor,
          isActive,
        );
    }
  }

  /// Build icon-only content
  Widget _buildIconOnlyContent(
    BuildContext context,
    NavbarItem item,
    NavbarSizeConfig config,
    Color iconColor,
  ) {
    if (item.icon == null) return const SizedBox.shrink();

    return Center(
      child: IconTheme(
        data: IconThemeData(
          size: config.iconSize,
          color: iconColor,
        ),
        child: item.icon!,
      ),
    );
  }

  /// Build icon with text content (icon above text)
  Widget _buildIconWithTextContent(
    BuildContext context,
    NavbarItem item,
    NavbarSizeConfig config,
    Color textColor,
    bool isActive,
  ) {
    final List<Widget> children = [];

    // Add icon if present and should show
    if (item.icon != null && showIcons) {
      children.add(
        IconTheme(
          data: IconThemeData(
            size: config.iconSize * 0.9,
            color: textColor,
          ),
          child: item.icon!,
        ),
      );
    }

    // Add text if should show labels
    if (showLabels) {
      final baseStyle = _getTextStyleForSize(context);
      children.add(const SizedBox(height: 0.5));
      children.add(
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth:
                position.isHorizontal ? config.height * 0.8 : double.infinity,
          ),
          child: OsmeaText(
            item.text,
            style: baseStyle.copyWith(
              fontWeight: isActive ? context.semiBold : context.normal,
              color: textColor,
              fontSize: config.fontSize * 0.6, // Compact text
            ),
            maxLines: 1,
            overflow: ellipsis,
            textAlign: textCenter,
          ),
        ),
      );
    }

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: config.height,
        minHeight: 0,
      ),
      child: Column(
        mainAxisSize: min,
        mainAxisAlignment: centerMain,
        crossAxisAlignment: crossCenter,
        children: children,
      ),
    );
  }

  /// Build icon with subtext content
  Widget _buildIconWithSubtextContent(
    BuildContext context,
    NavbarItem item,
    NavbarSizeConfig config,
    Color textColor,
    Color subtextColor,
    bool isActive,
  ) {
    final List<Widget> children = [];

    // Add icon if present and should show
    if (item.icon != null && showIcons) {
      children.add(
        IconTheme(
          data: IconThemeData(
            size: config.iconSize * 0.9,
            color: textColor,
          ),
          child: item.icon!,
        ),
      );
    }

    // Add text if should show labels
    if (showLabels) {
      final baseStyle = _getTextStyleForSize(context);
      final captionStyle = _getCaptionStyleForSize(context);

      children.add(const SizedBox(height: 0.5));
      children.add(
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth:
                position.isHorizontal ? config.height * 0.8 : double.infinity,
          ),
          child: OsmeaText(
            item.text,
            style: baseStyle.copyWith(
              fontWeight: isActive ? context.semiBold : context.normal,
              color: textColor,
              fontSize: config.fontSize * 0.6, // Compact text
            ),
            maxLines: 1,
            overflow: ellipsis,
            textAlign: textCenter,
          ),
        ),
      );

      // Add subtext if available
      if (item.subtext != null && item.subtext!.isNotEmpty) {
        children.add(const SizedBox(height: 0.5));
        children.add(
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth:
                  position.isHorizontal ? config.height * 0.8 : double.infinity,
            ),
            child: OsmeaText(
              item.subtext!,
              style: captionStyle.copyWith(
                color: subtextColor,
                fontSize: config.fontSize * 0.55,
              ),
              maxLines: 1,
              overflow: ellipsis,
              textAlign: textCenter,
            ),
          ),
        );
      }
    }

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: config.height,
        minHeight: 0,
      ),
      child: Column(
        mainAxisSize: min,
        mainAxisAlignment: centerMain,
        crossAxisAlignment: crossCenter,
        children: children,
      ),
    );
  }

  /// Build text-only content
  Widget _buildTextOnlyContent(
    BuildContext context,
    NavbarItem item,
    NavbarSizeConfig config,
    Color textColor,
    bool isActive,
  ) {
    if (!showLabels) return const SizedBox.shrink();

    final baseStyle = _getTextStyleForSize(context);

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth:
              position.isHorizontal ? config.height * 0.8 : double.infinity,
        ),
        child: OsmeaText(
          item.text,
          style: baseStyle.copyWith(
            fontWeight: isActive ? context.semiBold : context.normal,
            color: textColor,
            fontSize: config.fontSize * 0.65,
          ),
          maxLines: 1,
          overflow: ellipsis,
          textAlign: textCenter,
        ),
      ),
    );
  }

  /// Build icon and text horizontal content
  Widget _buildIconAndTextHorizontalContent(
    BuildContext context,
    NavbarItem item,
    NavbarSizeConfig config,
    Color textColor,
    bool isActive,
  ) {
    final List<Widget> children = [];

    // Add icon if present and should show
    if (item.icon != null && showIcons) {
      children.add(
        IconTheme(
          data: IconThemeData(
            size: config.iconSize,
            color: textColor,
          ),
          child: item.icon!,
        ),
      );
      children.add(SizedBox(
          width:
              config.itemSpacing / 2)); // Can't be const due to dynamic value
    }

    // Add text if should show labels
    if (showLabels) {
      final baseStyle = _getTextStyleForSize(context);
      children.add(
        Flexible(
          child: OsmeaText(
            item.text,
            style: baseStyle.copyWith(
              fontWeight: isActive ? context.semiBold : context.normal,
              color: textColor,
              fontSize: config.fontSize * 0.65,
            ),
            maxLines: 1,
            overflow: ellipsis,
            textAlign: textStart,
          ),
        ),
      );
    }

    return Row(
      mainAxisSize: min,
      mainAxisAlignment: centerMain,
      crossAxisAlignment: crossCenter,
      children: children,
    );
  }

  /// Get text style based on navbar size
  TextStyle _getTextStyleForSize(BuildContext context) {
    switch (size) {
      case NavbarSize.small:
        return OsmeaTextStyle.labelSmall(context);
      case NavbarSize.medium:
        return OsmeaTextStyle.labelMedium(context);
      case NavbarSize.large:
        return OsmeaTextStyle.labelLarge(context);
    }
  }

  /// Get caption style for subtext based on navbar size
  TextStyle _getCaptionStyleForSize(BuildContext context) {
    switch (size) {
      case NavbarSize.small:
        return OsmeaTextStyle.captionSmall(context);
      case NavbarSize.medium:
        return OsmeaTextStyle.captionMedium(context);
      case NavbarSize.large:
        return OsmeaTextStyle.captionLarge(context);
    }
  }

  /// Build app bar content (hamburger menu + title + actions)
  Widget _buildAppBarContent(
    BuildContext context,
    NavbarItem item,
    NavbarSizeConfig config,
    Color textColor,
    _NavbarColors colors,
  ) {
    final List<Widget> children = [];

    // Leading icon (hamburger menu or back button)
    if (item.leadingIcon != null) {
      children.add(
        IconTheme(
          data: IconThemeData(
            size: config.iconSize,
            color: textColor,
          ),
          child: item.leadingIcon!,
        ),
      );
      children.add(SizedBox(width: context.normalValue * 0.5));
    }

    // Title
    final titleText = item.title ?? item.text;
    if (titleText.isNotEmpty) {
      final titleStyle = _getTextStyleForSize(context).copyWith(
        fontWeight: context.semiBold,
        color: textColor,
        fontSize: config.fontSize * 0.7,
      );
      children.add(
        Expanded(
          child: OsmeaText(
            titleText,
            style: titleStyle,
            maxLines: 1,
            overflow: ellipsis,
            textAlign: textStart,
          ),
        ),
      );
    }

    // Trailing actions
    if (item.trailingActions != null && item.trailingActions!.isNotEmpty) {
      children.add(SizedBox(width: context.normalValue * 0.5));
      children.add(
        Row(
          mainAxisSize: min,
          children: item.trailingActions!
              .map((action) => Padding(
                    padding: EdgeInsets.only(left: context.lowValue * 0.5),
                    child: action,
                  ))
              .toList(),
        ),
      );
    }

    return Row(
      mainAxisAlignment: spaceBetween,
      crossAxisAlignment: crossCenter,
      children: children,
    );
  }

  /// Build app bar with search content
  Widget _buildAppBarWithSearchContent(
    BuildContext context,
    NavbarItem item,
    NavbarSizeConfig config,
    Color textColor,
    _NavbarColors colors,
  ) {
    final List<Widget> children = [];

    // Leading icon (hamburger menu)
    if (item.leadingIcon != null) {
      children.add(
        IconTheme(
          data: IconThemeData(
            size: config.iconSize,
            color: textColor,
          ),
          child: item.leadingIcon!,
        ),
      );
      children.add(SizedBox(width: context.normalValue * 0.5));
    }

    // Search bar or title
    if (item.searchBar != null) {
      children.add(Expanded(child: item.searchBar!));
    } else {
      final titleText = item.title ?? item.text;
      if (titleText.isNotEmpty) {
        final titleStyle = _getTextStyleForSize(context).copyWith(
          fontWeight: context.semiBold,
          color: textColor,
          fontSize: config.fontSize * 0.7,
        );
        children.add(
          Expanded(
            child: OsmeaText(
              titleText,
              style: titleStyle,
              maxLines: 1,
              overflow: ellipsis,
              textAlign: textStart,
            ),
          ),
        );
      }
    }

    // Trailing actions
    if (item.trailingActions != null && item.trailingActions!.isNotEmpty) {
      children.add(SizedBox(width: context.normalValue * 0.5));
      children.add(
        Row(
          mainAxisSize: min,
          children: item.trailingActions!
              .map((action) => Padding(
                    padding: EdgeInsets.only(left: context.lowValue * 0.5),
                    child: action,
                  ))
              .toList(),
        ),
      );
    }

    return Row(
      mainAxisAlignment: spaceBetween,
      crossAxisAlignment: crossCenter,
      children: children,
    );
  }

  /// Build drawer trigger content (hamburger menu button)
  Widget _buildDrawerTriggerContent(
    BuildContext context,
    NavbarItem item,
    NavbarSizeConfig config,
    Color iconColor,
  ) {
    // Use leadingIcon if provided, otherwise use default hamburger icon
    final icon = item.leadingIcon ??
        Icon(
          Icons.menu,
          size: config.iconSize,
          color: iconColor,
        );

    return Center(
      child: IconTheme(
        data: IconThemeData(
          size: config.iconSize,
          color: iconColor,
        ),
        child: icon,
      ),
    );
  }

  /// Build top tab bar content
  Widget _buildTopTabBarContent(
    BuildContext context,
    NavbarItem item,
    NavbarSizeConfig config,
    Color textColor,
    bool isActive,
  ) {
    final List<Widget> children = [];

    // Add icon if present
    if (item.icon != null && showIcons) {
      children.add(
        IconTheme(
          data: IconThemeData(
            size: config.iconSize * 0.8, // Slightly smaller for tabs
            color: textColor,
          ),
          child: item.icon!,
        ),
      );
      if (showLabels) {
        children.add(SizedBox(width: context.lowValue * 0.5));
      }
    }

    // Add text if should show labels
    if (showLabels) {
      final baseStyle = _getTextStyleForSize(context);
      children.add(
        Flexible(
          child: OsmeaText(
            item.text,
            style: baseStyle.copyWith(
              fontWeight: isActive ? context.semiBold : context.normal,
              color: textColor,
              fontSize: config.fontSize * 0.65,
            ),
            maxLines: 1,
            overflow: ellipsis,
            textAlign: textCenter,
          ),
        ),
      );
    }

    return Row(
      mainAxisSize: min,
      mainAxisAlignment: centerMain,
      crossAxisAlignment: crossCenter,
      children: children,
    );
  }

  /// Build segmented control content (iOS-style)
  Widget _buildSegmentedControlContent(
    BuildContext context,
    NavbarItem item,
    NavbarSizeConfig config,
    Color textColor,
    bool isActive,
  ) {
    final List<Widget> children = [];

    if (item.icon != null && showIcons) {
      children.add(
        IconTheme(
          data: IconThemeData(
            size: config.iconSize * 0.75,
            color: textColor,
          ),
          child: item.icon!,
        ),
      );
      if (showLabels) {
        children.add(SizedBox(width: context.lowValue * 0.5));
      }
    }

    if (showLabels && item.text.isNotEmpty) {
      final baseStyle = _getTextStyleForSize(context);
      children.add(
        Flexible(
          child: OsmeaText(
            item.text,
            style: baseStyle.copyWith(
              fontWeight: isActive ? context.semiBold : context.normal,
              color: textColor,
              fontSize: config.fontSize * 0.6,
            ),
            maxLines: 1,
            overflow: ellipsis,
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.lowValue * 0.75,
        vertical: context.lowValue * 0.5,
      ),
      child: Row(
        mainAxisSize: min,
        mainAxisAlignment: centerMain,
        crossAxisAlignment: crossCenter,
        children: children,
      ),
    );
  }

  /// Build floating bottom bar content
  Widget _buildFloatingBottomBarContent(
    BuildContext context,
    NavbarItem item,
    NavbarSizeConfig config,
    Color textColor,
    bool isActive,
  ) {
    // Similar to iconWithText but with more spacing
    return _buildIconWithTextContent(
      context,
      item,
      config,
      textColor,
      isActive,
    );
  }

  /// Build dense/compact content
  Widget _buildDenseCompactContent(
    BuildContext context,
    NavbarItem item,
    NavbarSizeConfig config,
    Color textColor,
    bool isActive,
  ) {
    final List<Widget> children = [];

    if (item.icon != null && showIcons) {
      children.add(
        IconTheme(
          data: IconThemeData(
            size: config.iconSize * 0.85,
            color: textColor,
          ),
          child: item.icon!,
        ),
      );
      if (showLabels) {
        children.add(SizedBox(width: context.lowValue * 0.25));
      }
    }

    if (showLabels && item.text.isNotEmpty) {
      final baseStyle = _getTextStyleForSize(context);
      children.add(
        Flexible(
          child: OsmeaText(
            item.text,
            style: baseStyle.copyWith(
              fontWeight: isActive ? context.semiBold : context.normal,
              color: textColor,
              fontSize: config.fontSize * 0.65,
            ),
            maxLines: 1,
            overflow: ellipsis,
          ),
        ),
      );
    }

    return Row(
      mainAxisSize: min,
      mainAxisAlignment: centerMain,
      crossAxisAlignment: crossCenter,
      children: children,
    );
  }

  /// Build collapsible content
  Widget _buildCollapsibleContent(
    BuildContext context,
    NavbarItem item,
    NavbarSizeConfig config,
    Color textColor,
    bool isActive,
  ) {
    // Can collapse to icon-only or expand to icon+text
    if (showLabels) {
      return _buildIconWithTextContent(
        context,
        item,
        config,
        textColor,
        isActive,
      );
    }
    return _buildIconOnlyContent(
      context,
      item,
      config,
      textColor,
    );
  }

  /// Build navigation rail content (Material 3)
  Widget _buildNavigationRailContent(
    BuildContext context,
    NavbarItem item,
    NavbarSizeConfig config,
    Color textColor,
    bool isActive,
  ) {
    final List<Widget> children = [];

    if (item.icon != null && showIcons) {
      children.add(
        IconTheme(
          data: IconThemeData(
            size: config.iconSize,
            color: textColor,
          ),
          child: item.icon!,
        ),
      );
    }

    if (showLabels && item.text.isNotEmpty) {
      children.add(SizedBox(height: context.lowValue * 0.25));
      final baseStyle = _getTextStyleForSize(context);
      children.add(
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth:
                position.isHorizontal ? config.height * 0.8 : double.infinity,
          ),
          child: OsmeaText(
            item.text,
            style: baseStyle.copyWith(
              fontWeight: isActive ? context.semiBold : context.normal,
              color: textColor,
              fontSize: config.fontSize * 0.6,
            ),
            maxLines: 2,
            overflow: ellipsis,
            textAlign: textCenter,
          ),
        ),
      );
    }

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: config.height,
        minHeight: 0,
      ),
      child: Column(
        mainAxisSize: min,
        mainAxisAlignment: centerMain,
        crossAxisAlignment: crossCenter,
        children: children,
      ),
    );
  }

  /// Build bottom sheet navigation content
  Widget _buildBottomSheetNavContent(
    BuildContext context,
    NavbarItem item,
    NavbarSizeConfig config,
    Color textColor,
    bool isActive,
  ) {
    // Similar to iconWithText but optimized for bottom sheet
    return _buildIconWithTextContent(
      context,
      item,
      config,
      textColor,
      isActive,
    );
  }

  BoxDecoration _buildDecoration(
      BuildContext context, NavbarSizeConfig config, _NavbarColors colors) {
    // Get variant-specific style properties
    final variantStyle = _getVariantStyle(context, config);

    List<BoxShadow> shadows = [];

    // Shadows removed - flat, standard design
    // shadows list remains empty

    // Determine if border should be shown
    final shouldShowBorder = showBorder ?? variantStyle.hasBorder;

    Border? border;
    if (shouldShowBorder) {
      final effectiveBorderWidth = borderWidth ?? variantStyle.borderWidth;

      if (effectiveBorderWidth > 0) {
        final effectiveBorderStyle = borderStyle ?? variantStyle.borderStyle;
        final effectiveBorderColor = borderColor ?? colors.border;

        border = Border.all(
          color: effectiveBorderColor,
          width: effectiveBorderWidth,
          style: effectiveBorderStyle,
        );
      }
    }

    return BoxDecoration(
      color: backgroundColor ?? colors.background,
      borderRadius: borderRadius ?? variantStyle.borderRadius,
      boxShadow: shadows,
      border: border,
    );
  }

  /// Get variant-specific style properties
  _NavbarVariantStyle _getVariantStyle(
      BuildContext context, NavbarSizeConfig config) {
    switch (variant) {
      case NavbarVariant.retailMain:
        // Modern, rounded, with shadow - e-commerce friendly
        final borderRadius = position.isBottom
            ? BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              )
            : position.isTop
                ? BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  )
                : BorderRadius.circular(20);
        return _NavbarVariantStyle(
          borderRadius: borderRadius,
          elevation: 0.0,
          shadowSpread: 0.0,
          hasBorder: false,
          borderWidth: 0.0,
          borderStyle: BorderStyle.solid,
        );

      case NavbarVariant.dottedOutline:
        // Dotted outline - creative style
        return _NavbarVariantStyle(
          borderRadius: BorderRadius.circular(12.0),
          elevation: 0.0,
          shadowSpread: 0.0,
          hasBorder: true,
          borderWidth: 2.0,
          borderStyle: BorderStyle.solid,
        );

      case NavbarVariant.healthcareMinimal:
        // Very clean, minimal border, flat design
        return _NavbarVariantStyle(
          borderRadius: BorderRadius.zero,
          elevation: 0.0,
          shadowSpread: 0.0,
          hasBorder: true,
          borderWidth: 1.0,
          borderStyle: BorderStyle.solid,
        );

      case NavbarVariant.outlinedMinimal:
        // Pill-shaped hamburger navbar style
        return _NavbarVariantStyle(
          borderRadius: BorderRadius.circular(100.0),
          elevation: 2.0,
          shadowSpread: 0.0,
          hasBorder: true,
          borderWidth: 1.0,
          borderStyle: BorderStyle.solid,
        );

      case NavbarVariant.minimal:
      case NavbarVariant.solidOutlined:
      case NavbarVariant.minimalDot:
        // Minimal pill-shaped styles
        return _NavbarVariantStyle(
          borderRadius: BorderRadius.circular(100.0),
          elevation: 2.0,
          shadowSpread: 0.0,
          hasBorder: false,
          borderWidth: 0.0,
          borderStyle: BorderStyle.solid,
        );

      case NavbarVariant.mediaOverlay:
        // Floating, no border, no shadow (transparent overlay)
        return _NavbarVariantStyle(
          borderRadius: BorderRadius.zero,
          elevation: 0.0,
          shadowSpread: 0.0,
          hasBorder: false,
          borderWidth: 0.0,
          borderStyle: BorderStyle.solid,
        );

      case NavbarVariant.socialGlass:
        // Glass morphism, rounded, subtle shadow
        final borderRadius = position.isBottom
            ? BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              )
            : position.isTop
                ? BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  )
                : BorderRadius.circular(24);
        return _NavbarVariantStyle(
          borderRadius: borderRadius,
          elevation: 0.0,
          shadowSpread: 0.0,
          hasBorder: false,
          borderWidth: 0.0,
          borderStyle: BorderStyle.solid,
        );

      case NavbarVariant.enterpriseMain:
        // Corporate, flat, subtle shadow
        return _NavbarVariantStyle(
          borderRadius: BorderRadius.zero,
          elevation: 0.0,
          shadowSpread: 0.0,
          hasBorder: false,
          borderWidth: 0.0,
          borderStyle: BorderStyle.solid,
        );

      case NavbarVariant.iconGrid:
        // Grid-based icon navigation
        return _NavbarVariantStyle(
          borderRadius: BorderRadius.zero,
          elevation: 0.0,
          shadowSpread: 0.0,
          hasBorder: true,
          borderWidth: 1.0,
          borderStyle: BorderStyle.solid,
        );

      case NavbarVariant.floatingCards:
        // Floating cards style
        return _NavbarVariantStyle(
          borderRadius: BorderRadius.circular(12.0),
          elevation: 4.0,
          shadowSpread: 0.0,
          hasBorder: false,
          borderWidth: 0.0,
          borderStyle: BorderStyle.solid,
        );

      case NavbarVariant.pillShaped:
        // Pill/capsule shaped style
        return _NavbarVariantStyle(
          borderRadius: BorderRadius.circular(28.0),
          elevation: 0.0,
          shadowSpread: 0.0,
          hasBorder: false,
          borderWidth: 0.0,
          borderStyle: BorderStyle.solid,
        );

      case NavbarVariant.brutalist:
        // Brutalist design - bold borders, hard shadow
        return _NavbarVariantStyle(
          borderRadius: BorderRadius.zero,
          elevation: 0.0, // Using custom shadow
          shadowSpread: 0.0,
          hasBorder: true,
          borderWidth: 2.5,
          borderStyle: BorderStyle.solid,
        );

      case NavbarVariant.badgeIndicator:
        // Badge style with subtle elevation
        return _NavbarVariantStyle(
          borderRadius: BorderRadius.circular(12.0),
          elevation: 0.0,
          shadowSpread: 0.0,
          hasBorder: false,
          borderWidth: 0.0,
          borderStyle: BorderStyle.solid,
        );

      case NavbarVariant.neumorphic:
        // Neumorphic soft 3D design
        return _NavbarVariantStyle(
          borderRadius: BorderRadius.circular(16.0),
          elevation: 0.0,
          shadowSpread: 0.0,
          hasBorder: false,
          borderWidth: 0.0,
          borderStyle: BorderStyle.solid,
        );

      case NavbarVariant.cardFloating:
        // Floating card with prominent shadow
        return _NavbarVariantStyle(
          borderRadius: BorderRadius.circular(16.0),
          elevation: 12.0,
          shadowSpread: 0.0,
          hasBorder: false,
          borderWidth: 0.0,
          borderStyle: BorderStyle.solid,
        );

      case NavbarVariant.bubble:
        // Playful bubble style
        return _NavbarVariantStyle(
          borderRadius: BorderRadius.circular(30.0),
          elevation: 0.0,
          shadowSpread: 0.0,
          hasBorder: false,
          borderWidth: 0.0,
          borderStyle: BorderStyle.solid,
        );

      case NavbarVariant.glassyBlur:
        // Glassmorphism style
        return _NavbarVariantStyle(
          borderRadius: BorderRadius.circular(20.0),
          elevation: 0.0,
          shadowSpread: 0.0,
          hasBorder: true,
          borderWidth: 1.0,
          borderStyle: BorderStyle.solid,
        );

      case NavbarVariant.markerTab:
        // Marker tab style
        return _NavbarVariantStyle(
          borderRadius: BorderRadius.zero,
          elevation: 0.0,
          shadowSpread: 0.0,
          hasBorder: false,
          borderWidth: 0.0,
          borderStyle: BorderStyle.solid,
        );

      case NavbarVariant.stepped:
        // Stepped/stair-like design
        return _NavbarVariantStyle(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12.0),
            topRight: Radius.circular(12.0),
          ),
          elevation: 0.0,
          shadowSpread: 0.0,
          hasBorder: false,
          borderWidth: 0.0,
          borderStyle: BorderStyle.solid,
        );

      case NavbarVariant.ribbon:
        // Ribbon/banner style
        return _NavbarVariantStyle(
          borderRadius: BorderRadius.circular(4.0),
          elevation: 0.0,
          shadowSpread: 0.0,
          hasBorder: false,
          borderWidth: 0.0,
          borderStyle: BorderStyle.solid,
        );
    }
  }

  _NavbarColors _getNavbarColors(BuildContext context) {
    switch (variant) {
      case NavbarVariant.retailMain:
        return _NavbarColors(
          background: backgroundColor ?? OsmeaColors.nordicBlue,
          active: activeColor ?? OsmeaColors.crystalBay,
          inactive: inactiveColor ??
              OsmeaColors.white.withValues(alpha: context.alpha80),
          border: borderColor ?? OsmeaColors.deepSea,
        );

      case NavbarVariant.dottedOutline:
        return _NavbarColors(
          background: backgroundColor ?? OsmeaColors.white,
          active: activeColor ?? OsmeaColors.nordicBlue,
          inactive: inactiveColor ?? OsmeaColors.pewter,
          border: borderColor ?? OsmeaColors.nordicBlue,
        );

      case NavbarVariant.healthcareMinimal:
        return _NavbarColors(
          background: backgroundColor ?? OsmeaColors.white,
          active: activeColor ?? OsmeaColors.nordicBlue,
          inactive: inactiveColor ?? OsmeaColors.pewter,
          border: borderColor ?? OsmeaColors.silver,
        );

      case NavbarVariant.outlinedMinimal:
        return _NavbarColors(
          background: backgroundColor ?? OsmeaColors.white,
          active: activeColor ?? OsmeaColors.nordicBlue,
          inactive: inactiveColor ?? OsmeaColors.pewter,
          border: borderColor ?? OsmeaColors.silver,
        );

      case NavbarVariant.mediaOverlay:
        return _NavbarColors(
          background: backgroundColor ?? OsmeaColors.transparent,
          active: activeColor ?? OsmeaColors.nordicBlue,
          inactive: inactiveColor ?? OsmeaColors.pewter,
          border: borderColor ?? OsmeaColors.silver,
        );

      case NavbarVariant.socialGlass:
        return _NavbarColors(
          background: backgroundColor ?? OsmeaColors.white.withValues(alpha: context.alpha10),
          active: activeColor ?? OsmeaColors.nordicBlue,
          inactive: inactiveColor ?? OsmeaColors.pewter,
          border: borderColor ?? OsmeaColors.silver.withValues(alpha: context.alpha30),
        );

      case NavbarVariant.enterpriseMain:
        return _NavbarColors(
          background: backgroundColor ?? OsmeaColors.nordicBlue,
          active: activeColor ?? OsmeaColors.crystalBay,
          inactive: inactiveColor ?? OsmeaColors.white.withValues(alpha: context.alpha80),
          border: borderColor ?? OsmeaColors.deepSea,
        );

      case NavbarVariant.iconGrid:
        return _NavbarColors(
          background: backgroundColor ?? OsmeaColors.white,
          active: activeColor ?? OsmeaColors.nordicBlue,
          inactive: inactiveColor ?? OsmeaColors.pewter,
          border: borderColor ?? OsmeaColors.silver,
        );

      case NavbarVariant.floatingCards:
        return _NavbarColors(
          background: backgroundColor ?? Colors.transparent,
          active: activeColor ?? Colors.grey.shade800,
          inactive: inactiveColor ?? Colors.grey.shade500,
          border: borderColor ?? Colors.transparent,
        );

      case NavbarVariant.pillShaped:
        return _NavbarColors(
          background: backgroundColor ?? OsmeaColors.white,
          active: activeColor ?? OsmeaColors.nordicBlue,
          inactive: inactiveColor ?? OsmeaColors.pewter,
          border: borderColor ?? OsmeaColors.silver,
        );

      case NavbarVariant.minimal:
      case NavbarVariant.solidOutlined:
      case NavbarVariant.minimalDot:
        return _NavbarColors(
          background: backgroundColor ?? OsmeaColors.white,
          active: activeColor ?? OsmeaColors.nordicBlue,
          inactive: inactiveColor ?? OsmeaColors.pewter,
          border: borderColor ?? OsmeaColors.silver,
        );

      case NavbarVariant.brutalist:
        return _NavbarColors(
          background: backgroundColor ?? OsmeaColors.white,
          active: activeColor ?? OsmeaColors.black,
          inactive: inactiveColor ?? OsmeaColors.pewter,
          border: borderColor ?? OsmeaColors.black,
        );

      case NavbarVariant.badgeIndicator:
        return _NavbarColors(
          background: backgroundColor ?? OsmeaColors.white,
          active: activeColor ?? OsmeaColors.nordicBlue,
          inactive: inactiveColor ?? OsmeaColors.pewter,
          border: borderColor ?? OsmeaColors.silver,
        );

      case NavbarVariant.neumorphic:
        return _NavbarColors(
          background: backgroundColor ?? OsmeaColors.ash,
          active: activeColor ?? OsmeaColors.nordicBlue,
          inactive: inactiveColor ?? OsmeaColors.pewter,
          border: borderColor ?? OsmeaColors.silver,
        );

      case NavbarVariant.cardFloating:
        return _NavbarColors(
          background: backgroundColor ?? OsmeaColors.white,
          active: activeColor ?? OsmeaColors.nordicBlue,
          inactive: inactiveColor ?? OsmeaColors.pewter,
          border: borderColor ?? OsmeaColors.silver,
        );

      case NavbarVariant.bubble:
        return _NavbarColors(
          background: backgroundColor ?? OsmeaColors.white,
          active: activeColor ?? OsmeaColors.nordicBlue,
          inactive: inactiveColor ?? OsmeaColors.pewter,
          border: borderColor ?? OsmeaColors.silver,
        );

      case NavbarVariant.glassyBlur:
        return _NavbarColors(
          background: backgroundColor ?? OsmeaColors.white.withValues(alpha: context.alpha15),
          active: activeColor ?? OsmeaColors.nordicBlue,
          inactive: inactiveColor ?? OsmeaColors.pewter,
          border: borderColor ?? OsmeaColors.white.withValues(alpha: context.alpha50),
        );

      case NavbarVariant.markerTab:
        return _NavbarColors(
          background: backgroundColor ?? OsmeaColors.white,
          active: activeColor ?? OsmeaColors.nordicBlue,
          inactive: inactiveColor ?? OsmeaColors.pewter,
          border: borderColor ?? OsmeaColors.silver,
        );

      case NavbarVariant.stepped:
        return _NavbarColors(
          background: backgroundColor ?? OsmeaColors.white,
          active: activeColor ?? OsmeaColors.nordicBlue,
          inactive: inactiveColor ?? OsmeaColors.pewter,
          border: borderColor ?? OsmeaColors.silver,
        );

      case NavbarVariant.ribbon:
        return _NavbarColors(
          background: backgroundColor ?? OsmeaColors.nordicBlue,
          active: activeColor ?? OsmeaColors.crystalBay,
          inactive: inactiveColor ?? OsmeaColors.white.withValues(alpha: context.alpha80),
          border: borderColor ?? OsmeaColors.deepSea,
        );
    }
  }
}

/// Internal helper class for navbar colors
class _NavbarColors {
  final Color background;
  final Color active;
  final Color inactive;
  final Color border;

  const _NavbarColors({
    required this.background,
    required this.active,
    required this.inactive,
    required this.border,
  });
}

/// Internal helper class for variant-specific style properties
class _NavbarVariantStyle {
  final BorderRadius borderRadius;
  final double elevation;
  final double shadowSpread;
  final bool hasBorder;
  final double borderWidth;
  final BorderStyle borderStyle;

  const _NavbarVariantStyle({
    required this.borderRadius,
    required this.elevation,
    required this.shadowSpread,
    required this.hasBorder,
    required this.borderWidth,
    required this.borderStyle,
  });
}

/// Internal animated wrapper for navbar items
class _AnimatedNavbarItemWrapper extends StatefulWidget {
  final NavbarItemAnimationType animationType;
  final dynamic animationTrigger;
  final Duration duration;
  final Curve curve;
  final Widget child;

  const _AnimatedNavbarItemWrapper({
    required this.animationType,
    required this.animationTrigger,
    required this.duration,
    required this.curve,
    required this.child,
  });

  @override
  State<_AnimatedNavbarItemWrapper> createState() =>
      _AnimatedNavbarItemWrapperState();
}

class _AnimatedNavbarItemWrapperState extends State<_AnimatedNavbarItemWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _setupAnimation();
  }

  void _setupAnimation() {
    switch (widget.animationType) {
      case NavbarItemAnimationType.none:
        _animation = AlwaysStoppedAnimation(1.0);
        break;
      case NavbarItemAnimationType.scale:
        _animation = Tween<double>(begin: 1.0, end: 1.2).animate(
          CurvedAnimation(parent: _controller, curve: widget.curve),
        );
        break;
      case NavbarItemAnimationType.bounce:
        _animation = Tween<double>(begin: 1.0, end: 1.3).animate(
          CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
        );
        break;
      case NavbarItemAnimationType.pulse:
        _animation = Tween<double>(begin: 1.0, end: 1.15).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
        );
        break;
      case NavbarItemAnimationType.shake:
        _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: _controller, curve: widget.curve),
        );
        break;
    }
  }

  @override
  void didUpdateWidget(_AnimatedNavbarItemWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animationType != widget.animationType) {
      _setupAnimation();
    }
    // Trigger animation when trigger value changes
    if (oldWidget.animationTrigger != widget.animationTrigger) {
      _triggerAnimation();
    }
  }

  void _triggerAnimation() {
    if (widget.animationType == NavbarItemAnimationType.none) return;

    switch (widget.animationType) {
      case NavbarItemAnimationType.scale:
      case NavbarItemAnimationType.bounce:
        _controller.forward().then((_) {
          if (mounted) _controller.reverse();
        });
        break;
      case NavbarItemAnimationType.pulse:
        _controller.repeat(reverse: true);
        Future.delayed(widget.duration * 2, () {
          if (mounted) {
            _controller.stop();
            _controller.reset();
          }
        });
        break;
      case NavbarItemAnimationType.shake:
        _controller.forward().then((_) {
          if (mounted) _controller.reset();
        });
        break;
      case NavbarItemAnimationType.none:
        break;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.animationType) {
      case NavbarItemAnimationType.none:
        return widget.child;
      case NavbarItemAnimationType.scale:
      case NavbarItemAnimationType.bounce:
        return ScaleTransition(
          scale: _animation,
          child: widget.child,
        );
      case NavbarItemAnimationType.pulse:
        return AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform.scale(
              scale: _animation.value,
              child: widget.child,
            );
          },
        );
      case NavbarItemAnimationType.shake:
        return AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            // Shake animation: horizontal movement
            final shakeOffset = (widget.animationTrigger is int &&
                    (widget.animationTrigger as int) > 0)
                ? (widget.animationTrigger as int) % 2 == 0
                    ? 4.0
                    : -4.0
                : 0.0;
            return Transform.translate(
              offset: Offset(
                shakeOffset * _animation.value,
                0,
              ),
              child: widget.child,
            );
          },
        );
    }
  }
}

/// 🎬 **Animated Navbar Icon**
///
/// An animated icon widget that transitions between empty and filled states
/// with a scale animation. Perfect for favorite/wishlist icons in navigation bars.
///
/// **Features:**
/// - ✨ Smooth scale animation when state changes
/// - 🎨 Customizable colors for filled and empty states
/// - ⚡ Automatic animation trigger on value change
/// - 🎯 Configurable animation duration and curve
///
/// **Example:**
/// ```dart
/// AnimatedNavbarIcon(
///   value: wishlistCount,
///   filledIcon: Icons.favorite,
///   emptyIcon: Icons.favorite_outline,
///   filledColor: OsmeaColors.nordicBlue,
/// )
/// ```
class AnimatedNavbarIcon extends StatefulWidget {
  /// The trigger value that determines if icon should be filled
  /// When value > 0, shows filled icon; when value == 0, shows empty icon
  final int value;

  /// Icon to show when value > 0 (filled state)
  final IconData filledIcon;

  /// Icon to show when value == 0 (empty state)
  final IconData emptyIcon;

  /// Color for filled icon
  final Color? filledColor;

  /// Color for empty icon (defaults to theme default)
  final Color? emptyColor;

  /// Animation duration
  final Duration duration;

  /// Animation curve
  final Curve curve;

  /// Scale factor for animation (1.0 = no scale, 1.3 = 30% larger)
  final double scaleFactor;

  const AnimatedNavbarIcon({
    super.key,
    required this.value,
    this.filledIcon = Icons.favorite,
    this.emptyIcon = Icons.favorite_outline,
    this.filledColor,
    this.emptyColor,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.elasticOut,
    this.scaleFactor = 1.3,
  });

  @override
  State<AnimatedNavbarIcon> createState() => _AnimatedNavbarIconState();
}

class _AnimatedNavbarIconState extends State<AnimatedNavbarIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scaleFactor,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));
  }

  @override
  void didUpdateWidget(AnimatedNavbarIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    final isFilled = widget.value > 0;
    final wasFilled = oldWidget.value > 0;

    // Animate when value changes from 0 to >0 or vice versa
    if (isFilled != wasFilled) {
      _controller.forward().then((_) {
        if (mounted) {
          _controller.reverse();
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isFilled = widget.value > 0;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Icon(
        isFilled ? widget.filledIcon : widget.emptyIcon,
        color: isFilled ? widget.filledColor : widget.emptyColor,
      ),
    );
  }
}
