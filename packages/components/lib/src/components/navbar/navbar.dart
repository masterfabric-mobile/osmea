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
/// * 🎨 Multiple style variants (primary, secondary, transparent, glass, outlined)
/// * 📏 Three size options (small, medium, large)
/// * 📍 Flexible positioning (top, bottom, left, right, floating)
/// * 🎯 Interactive navbar items with states
/// * ♿ Full accessibility support
/// * 🌐 RTL/LTR language support
/// * 📱 Responsive design
/// * 🎭 Custom theming capabilities
///
/// ```dart
/// OsmeaNavbar(
///   variant: NavbarVariant.primary,
///   size: NavbarSize.medium,
///   position: NavbarPosition.top,
///   items: [
///     NavbarItem(
///       text: 'Home',
///       icon: Icon(Icons.home),
///       onTap: () => Navigator.pushNamed(context, '/home'),
///     ),
///     NavbarItem(
///       text: 'Profile',
///       icon: Icon(Icons.person),
///       onTap: () => Navigator.pushNamed(context, '/profile'),
///     ),
///   ],
/// )
/// ```
///
/// See also:
/// * [NavbarVariant] - Style variants enum
/// * [NavbarSize] - Size variants enum
/// * [NavbarPosition] - Position options enum
/// * [NavbarType] - Type variants enum
/// * [NavbarItem] - Individual navigation item

/// 📄 **Navbar Item Data Class**
///
/// Represents a single item in the navigation bar.
/// Contains all necessary information for rendering and interaction.
class NavbarItem {
  const NavbarItem({
    required this.text,
    this.icon,
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
  });

  /// 📝 Display text for the navbar item
  final String text;

  /// 🎯 Optional icon for the navbar item
  final Widget? icon;

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
  }) {
    return NavbarItem(
      text: text ?? this.text,
      icon: icon ?? this.icon,
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
/// - 📍 Flexible positioning options
/// - 🔄 Different navbar types and behaviors
/// - 🎯 Interactive navbar items
/// - ✨ Built-in animations and hover effects
/// - 🔧 Fully customizable
///
/// **Example:**
/// ```dart
/// OsmeaNavbar(
///   variant: NavbarVariant.primary,
///   size: NavbarSize.medium,
///   position: NavbarPosition.top,
///   items: navigationItems,
/// )
/// ```
class OsmeaNavbar extends CoreContainer {
  const OsmeaNavbar({
    super.key,
    super.customTheme,
    required this.items,
    this.size = NavbarSize.medium,
    this.variant = NavbarVariant.primary,
    this.position = NavbarPosition.top,
    this.backgroundColor,
    this.textColor,
    this.activeColor,
    this.inactiveColor,
    this.borderColor,
    this.shadowColor,
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

    Widget navbar = _buildNavbar(context, config, colors);

    // Apply positioning wrapper
    navbar = _buildPositionWrapper(context, navbar, config);

    return navbar;
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
  ) {
    return Container(
      height: position.isHorizontal ? config.height : null,
      width: position.isVertical ? config.height : null,
      padding: padding ?? config.padding,
      margin: margin,
      decoration: _buildDecoration(colors, config),
      child: _buildContent(context, config, colors),
    );
  }

  Widget _buildContent(
    BuildContext context,
    NavbarSizeConfig config,
    _NavbarColors colors,
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
          children: itemWidgets
              .map((widget) => Expanded(
                    child: Center(child: widget),
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
  ) {
    final isActive = item.state == NavbarItemState.active;
    final isDisabled = item.state == NavbarItemState.disabled;
    final isLoading = item.state == NavbarItemState.loading;

    Widget child = Container(
      constraints: BoxConstraints(
        maxHeight: config.height,
        maxWidth: position.isHorizontal ? double.infinity : config.height,
        minHeight: config.height * 0.8,
      ),
      padding: config.itemPadding,
      child: _buildItemContent(context, item, config, colors, isActive),
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
        duration: item.animationDuration ?? animationDuration ?? context.animationMedium,
        curve: item.animationCurve,
        child: child,
      );
    }

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
          borderRadius: config.borderRadius,
          splashColor: colors.active.withValues(alpha: context.alpha20),
          highlightColor: colors.active.withValues(alpha: context.alpha10),
          child: child,
        ),
      ),
    );
  }

  Widget _buildItemContent(
    BuildContext context,
    NavbarItem item,
    NavbarSizeConfig config,
    _NavbarColors colors,
    bool isActive,
  ) {
    final textColor = isActive ? colors.active : colors.inactive;
    final List<Widget> children = [];

    // Add icon if present and should show
    if (item.icon != null && showIcons) {
      children.add(
        FittedBox(
          fit: contain,
          child: IconTheme(
            data: IconThemeData(
              size: config.iconSize,
              color: textColor,
            ),
            child: item.icon!,
          ),
        ),
      );
    }

    // Add text if should show labels
    if (showLabels) {
      TextStyle baseStyle;

      // Select appropriate text style based on navbar size
      switch (size) {
        case NavbarSize.small:
          baseStyle = OsmeaTextStyle.labelSmall(context);
          break;
        case NavbarSize.medium:
          baseStyle = OsmeaTextStyle.labelMedium(context);
          break;
        case NavbarSize.large:
          baseStyle = OsmeaTextStyle.labelLarge(context);
          break;
      }

      children.add(
        Flexible(
          flex: size == NavbarSize.large ? 2 : 1,
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Use FittedBox for smaller constraints to prevent overflow
              if (constraints.maxWidth < context.width80 ||
                  size == NavbarSize.small) {
                return FittedBox(
                  fit: scaleDown,
                  alignment: center,
                  child: OsmeaText(
                    item.text,
                    style: baseStyle.copyWith(
                      fontWeight: isActive ? context.semiBold : context.normal,
                      color: textColor,
                    ),
                    maxLines: 1,
                    overflow: ellipsis,
                    textAlign: textCenter,
                  ),
                );
              } else {
                return Text(
                  item.text,
                  style: baseStyle.copyWith(
                    fontWeight: isActive ? context.semiBold : context.normal,
                    color: textColor,
                  ),
                  maxLines: size == NavbarSize.large ? 2 : 1,
                  overflow: ellipsis,
                  textAlign: textCenter,
                );
              }
            },
          ),
        ),
      );
    }

    // Handle loading state
    if (item.state == NavbarItemState.loading) {
      children.clear();
      children.add(
        FittedBox(
          fit: contain,
          child: SizedBox(
            width: config.iconSize,
            height: config.iconSize,
            child: CircularProgressIndicator(
              strokeWidth: context.width2,
              valueColor: AlwaysStoppedAnimation<Color>(textColor),
            ),
          ),
        ),
      );
    }

    // Layout children based on navbar orientation
    if (position.isVertical || (item.icon != null && showLabels && showIcons)) {
      return Column(
        mainAxisSize: min,
        mainAxisAlignment: centerMain,
        crossAxisAlignment: crossCenter,
        children: children
            .expand((widget) => [
                  widget,
                  if (widget != children.last)
                    SizedBox(height: size == NavbarSize.large ? 6.0 : 4.0),
                ])
            .toList(),
      );
    } else {
      return Row(
        mainAxisSize: min,
        mainAxisAlignment: centerMain,
        crossAxisAlignment: crossCenter,
        children: children
            .expand((widget) => [
                  widget,
                  if (widget != children.last)
                    SizedBox(width: config.itemSpacing / 2),
                ])
            .toList(),
      );
    }
  }

  BoxDecoration _buildDecoration(
      _NavbarColors colors, NavbarSizeConfig config) {
    List<BoxShadow> shadows = [];

    if (variant != NavbarVariant.transparent &&
        (elevation ?? config.elevation) > 0) {
      shadows.add(
        BoxShadow(
          color: shadowColor ?? OsmeaColors.shadowLight,
          blurRadius: elevation ?? config.elevation,
          offset: Offset(0, position.isTop ? 2 : -2),
        ),
      );
    }

    Border? border;
    if (variant == NavbarVariant.outlined) {
      border = Border.all(
        color: borderColor ?? colors.border,
        width: 1.0,
      );
    }

    return BoxDecoration(
      color: backgroundColor ?? colors.background,
      borderRadius: borderRadius ?? config.borderRadius,
      boxShadow: shadows,
      border: border,
    );
  }

  _NavbarColors _getNavbarColors(BuildContext context) {
    switch (variant) {
      case NavbarVariant.primary:
        return _NavbarColors(
          background: OsmeaColors.nordicBlue,
          active: OsmeaColors.crystalBay,
          inactive: OsmeaColors.white.withValues(alpha: context.alpha80),
          border: OsmeaColors.deepSea,
        );

      case NavbarVariant.secondary:
        return _NavbarColors(
          background: OsmeaColors.ash,
          active: OsmeaColors.nordicBlue,
          inactive: OsmeaColors.pewter,
          border: OsmeaColors.silver,
        );

      case NavbarVariant.transparent:
        return _NavbarColors(
          background: OsmeaColors.transparent,
          active: activeColor ?? OsmeaColors.nordicBlue,
          inactive: inactiveColor ?? OsmeaColors.pewter,
          border: OsmeaColors.silver,
        );

      case NavbarVariant.glass:
        return _NavbarColors(
          background: OsmeaColors.white.withValues(alpha: context.alpha10),
          active: OsmeaColors.nordicBlue,
          inactive: OsmeaColors.pewter,
          border: OsmeaColors.silver.withValues(alpha: context.alpha30),
        );

      case NavbarVariant.outlined:
        return _NavbarColors(
          background: OsmeaColors.white,
          active: OsmeaColors.nordicBlue,
          inactive: OsmeaColors.pewter,
          border: OsmeaColors.silver,
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

class _AnimatedNavbarItemWrapperState
    extends State<_AnimatedNavbarItemWrapper>
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
