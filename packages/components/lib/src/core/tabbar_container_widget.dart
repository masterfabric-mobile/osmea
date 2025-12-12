import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:osmea_components/osmea_components.dart';
import 'package:osmea_components/src/core/container_widget.dart';

/// 📑 **OSMEA Core TabBar Container**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/components
///
/// A foundational container widget that serves as the base for all
/// tabbar container-based components in the OSMEA UI Kit.
/// Extends CoreContainer with tabbar-specific features.
///
/// {@category Core}
/// {@subCategory Widgets}
///
/// Features:
/// * 📑 TabBar-specific container styling
/// * 🎨 Variant-based appearance
/// * 📏 Size-aware dimensions
/// * 🔄 Position-aware layout
/// * 📊 Indicator support
/// * ✂️ Custom clipping behavior
/// * 🪟 Glass effect support
/// * 📦 Border support for outlined variants
///
/// ```dart
/// CoreTabBarContainer(
///   variant: TabBarVariant.primary,
///   size: TabBarSize.medium,
///   position: TabBarPosition.top,
///   child: tabBarContent,
/// )
/// ```
///
/// Properties:
/// * 🎨 [variant] - TabBar visual style
/// * 📏 [size] - TabBar size configuration
/// * 📍 [position] - TabBar position
/// * 🔄 [style] - TabBar behavior style
/// * 📊 [indicatorStyle] - Tab indicator styling
///
/// See also:
/// * [CoreContainer] - Base container widget
/// * [TabBarVariant] - Style variants
/// * [TabBarSize] - Size variants
/// * [TabBarPosition] - Position options

abstract class CoreTabBarContainer extends CoreContainer {
  const CoreTabBarContainer({
    super.key,
    super.customTheme,
    super.alignment,
    super.padding,
    super.color,
    super.decoration,
    super.foregroundDecoration,
    super.width,
    super.height,
    super.constraints,
    super.margin,
    super.transform,
    super.transformAlignment,
    super.child,
    super.clipBehavior = Clip.antiAlias,
    this.variant = TabBarVariant.primary,
    this.size = TabBarSize.medium,
    this.position = TabBarPosition.top,
    this.style = TabBarStyle.fixed,
    this.indicatorStyle = TabBarIndicatorStyle.line,
    this.backgroundColor,
    this.borderColor,
    this.shadowColor,
    this.indicatorColor,
    this.borderRadius,
    this.elevation,
    this.enableGlassEffect = false,
  });

  /// 🎨 The visual style variant of the tabbar container
  final TabBarVariant variant;

  /// 📏 The size of the tabbar container
  final TabBarSize size;

  /// 📍 The position of the tabbar container
  final TabBarPosition position;

  /// 🔄 The behavior style of the tabbar
  final TabBarStyle style;

  /// 📊 The indicator style for tabs
  final TabBarIndicatorStyle indicatorStyle;

  /// 🎨 Custom background color that overrides the default variant background
  final Color? backgroundColor;

  /// 🔲 Border color for outlined variants
  final Color? borderColor;

  /// ✨ Shadow color for elevated tabbars
  final Color? shadowColor;

  /// 📊 Color for tab indicators
  final Color? indicatorColor;

  /// ⭕ Custom border radius
  final BorderRadius? borderRadius;

  /// ✨ Elevation/shadow depth
  final double? elevation;

  /// 🪟 Whether to enable glass effect for glass variant
  final bool enableGlassEffect;

  /// 🎯 Get effective background color based on variant
  Color? getEffectiveBackgroundColor(BuildContext context) {
    if (backgroundColor != null) return backgroundColor;

    final colorScheme = Theme.of(context).colorScheme;

    switch (variant) {
      case TabBarVariant.primary:
        return colorScheme.primary;
      case TabBarVariant.secondary:
        // Use a light gray background for segmented control look
        return OsmeaColors.ash;
      case TabBarVariant.outlined:
        return OsmeaColors.transparent;
      case TabBarVariant.glass:
        return colorScheme.surface.withValues(alpha: 0.8);
      case TabBarVariant.transparent:
        return OsmeaColors.transparent;
    }
  }

  /// 🔲 Get effective border color based on variant
  Color? getEffectiveBorderColor(BuildContext context) {
    if (borderColor != null) return borderColor;

    final colorScheme = Theme.of(context).colorScheme;

    switch (variant) {
      case TabBarVariant.outlined:
        return colorScheme.outline;
      case TabBarVariant.glass:
        return colorScheme.outline.withValues(alpha: 0.3);
      default:
        return null;
    }
  }

  /// 📊 Get effective indicator color based on variant
  Color getEffectiveIndicatorColor(BuildContext context) {
    if (indicatorColor != null) return indicatorColor!;

    final colorScheme = Theme.of(context).colorScheme;

    switch (variant) {
      case TabBarVariant.primary:
        return colorScheme.onPrimary;
      case TabBarVariant.secondary:
        return colorScheme.primary;
      case TabBarVariant.outlined:
      case TabBarVariant.glass:
      case TabBarVariant.transparent:
        return colorScheme.primary;
    }
  }

  /// ⭕ Get effective border radius based on size and position
  BorderRadius getEffectiveBorderRadius(BuildContext context) {
    if (borderRadius != null) return borderRadius!;

    // Different radius based on position
    switch (position) {
      case TabBarPosition.top:
        return BorderRadius.only(
          topLeft: Radius.circular(size.sizeFactor * 8.0),
          topRight: Radius.circular(size.sizeFactor * 8.0),
        );
      case TabBarPosition.bottom:
        return BorderRadius.only(
          bottomLeft: Radius.circular(size.sizeFactor * 8.0),
          bottomRight: Radius.circular(size.sizeFactor * 8.0),
        );
    }
  }

  /// ✨ Get effective elevation based on variant
  double getEffectiveElevation(BuildContext context) {
    if (elevation != null) return elevation!;

    switch (variant) {
      case TabBarVariant.primary:
        return 2.0;
      case TabBarVariant.secondary:
        return 1.0;
      case TabBarVariant.glass:
        return 4.0;
      case TabBarVariant.outlined:
      case TabBarVariant.transparent:
        return 0.0;
    }
  }

  /// 🪟 Check if variant needs backdrop blur
  bool get needsBackdropBlur =>
      variant == TabBarVariant.glass && enableGlassEffect;

  /// 🔲 Check if variant needs border
  bool get needsBorder =>
      variant == TabBarVariant.outlined || variant == TabBarVariant.glass;

  /// 📊 Check if indicator should be shown
  bool get shouldShowIndicator => indicatorStyle != TabBarIndicatorStyle.none;

  /// 📐 Get container constraints based on position and size
  BoxConstraints getEffectiveConstraints(BuildContext context) {
    if (constraints != null) return constraints!;

    final screenSize = MediaQuery.of(context).size;

    switch (position) {
      case TabBarPosition.top:
      case TabBarPosition.bottom:
        return BoxConstraints(
          minHeight: 64,
          maxHeight: 80,
          minWidth: 0,
          maxWidth:
              math.min(screenSize.width - 16, 400), // Limit width for mobile
        );
    }
  }

  /// 🎨 Build container decoration based on variant
  BoxDecoration buildTabBarDecoration(BuildContext context) {
    final effectiveBackgroundColor = getEffectiveBackgroundColor(context);
    final effectiveBorderColor = getEffectiveBorderColor(context);

    // Adjust border radius for secondary variant (segmented control style)
    // Container radius should be slightly larger than tab radius for visual harmony
    final containerRadius = variant == TabBarVariant.secondary
        ? BorderRadius.circular(12)
        : BorderRadius.circular(13);

    return BoxDecoration(
      color: effectiveBackgroundColor ?? OsmeaColors.snow,
      borderRadius: containerRadius,
      border: needsBorder && effectiveBorderColor != null
          ? Border.all(color: effectiveBorderColor, width: 1.0)
          : null,
    );
  }

  /// 📐 Get effective padding based on variant
  EdgeInsetsGeometry? getEffectivePadding(BuildContext context) {
    if (padding != null) return padding;

    // For secondary variant, use minimal equal padding for clean look
    if (variant == TabBarVariant.secondary) {
      return const EdgeInsets.all(2.0);
    }

    // Default padding for other variants
    return const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0);
  }

  @override
  Widget build(BuildContext context) {
    Widget container = OsmeaComponents.container(
      key: key,
      alignment: alignment,
      padding: getEffectivePadding(context),
      decoration: decoration ?? buildTabBarDecoration(context),
      foregroundDecoration: foregroundDecoration,
      width: width,
      height: height,
      constraints: constraints ?? getEffectiveConstraints(context),
      margin: margin,
      transform: transform,
      transformAlignment: transformAlignment,
      clipBehavior: clipNone,
      child: buildWidget(context),
    );

    // Apply glass effect if needed
    if (needsBackdropBlur) {
      container = OsmeaComponents.clipRRect(
        borderRadius: getEffectiveBorderRadius(context),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: container,
        ),
      );
    }

    return container;
  }
}
