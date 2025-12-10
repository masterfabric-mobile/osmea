import 'package:flutter/material.dart';
import 'package:osmea_components/osmea_components.dart';
import 'package:osmea_components/src/components/column/column.dart';
import 'package:osmea_components/src/components/row/row.dart';
import 'package:osmea_components/src/components/wrap/wrap.dart';
import 'package:osmea_components/src/core/row_widget.dart';

/// 📑 **OSMEA Core TabBar Row**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/components
///
/// A foundational row widget that serves as the base for all
/// tabbar row-based components in the OSMEA UI Kit.
/// Extends CoreRow with tabbar-specific features.
///
/// {@category Core}
/// {@subCategory Widgets}
///
/// Features:
/// * 📑 TabBar-specific row layout
/// * 🎨 Variant-aware spacing
/// * 📏 Size-aware alignment
/// * 🔄 Position-aware direction
/// * 📊 Style-aware distribution
/// * ↔️ Scrollable support
/// * 📱 Responsive behavior
/// * ⚡ Performance optimized
///
/// ```dart
/// CoreTabBarRow(
///   variant: TabBarVariant.primary,
///   size: TabBarSize.medium,
///   position: TabBarPosition.top,
///   style: TabBarStyle.fixed,
///   children: tabs,
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
/// * [CoreRow] - Base row widget
/// * [TabBarVariant] - Style variants
/// * [TabBarSize] - Size variants
/// * [TabBarPosition] - Position options

abstract class CoreTabBarRow extends CoreRow {
  const CoreTabBarRow({
    super.key,
    super.customTheme,
    super.mainAxisAlignment,
    super.mainAxisSize,
    super.crossAxisAlignment,
    super.textDirection,
    super.verticalDirection,
    super.textBaseline,
    super.children = const <Widget>[],
    this.variant = TabBarVariant.primary,
    this.size = TabBarSize.medium,
    this.position = TabBarPosition.top,
    this.style = TabBarStyle.fixed,
    this.indicatorStyle = TabBarIndicatorStyle.line,
    this.spacing,
    this.runSpacing,
    this.enableAnimation = true,
    this.animationDuration,
    this.scrollController,
    this.physics,
    this.clipBehavior = Clip.none,
  });

  /// 🎨 The visual style variant of the tabbar row
  final TabBarVariant variant;

  /// 📏 The size of the tabbar row
  final TabBarSize size;

  /// 📍 The position of the tabbar row
  final TabBarPosition position;

  /// 🔄 The behavior style of the tabbar
  final TabBarStyle style;

  /// 📊 The indicator style for tabs
  final TabBarIndicatorStyle indicatorStyle;

  /// ↔️ Spacing between tabs (overrides size-based spacing)
  final double? spacing;

  /// ↕️ Run spacing for wrapped tabs
  final double? runSpacing;

  /// ⚡ Whether to enable animations
  final bool enableAnimation;

  /// ⏱️ Animation duration for tab transitions
  final Duration? animationDuration;

  /// 🎯 Scroll controller for scrollable tabs
  final ScrollController? scrollController;

  /// 🎮 Scroll physics for scrollable tabs
  final ScrollPhysics? physics;

  /// ✂️ Clipping behavior for row content
  final Clip clipBehavior;

  /// 🎯 Get effective main axis alignment based on style and position
  MainAxisAlignment getEffectiveMainAxisAlignment() {
    if (mainAxisAlignment != MainAxisAlignment.start) {
      return mainAxisAlignment;
    }

    // Use style-based alignment if no custom alignment specified
    switch (style) {
      case TabBarStyle.fixed:
        return position.isHorizontal
            ? MainAxisAlignment.spaceEvenly
            : MainAxisAlignment.start;
      case TabBarStyle.scrollable:
        return MainAxisAlignment.start;
    }
  }

  /// 📏 Get effective main axis size based on style
  MainAxisSize getEffectiveMainAxisSize() {
    if (mainAxisSize != MainAxisSize.max) {
      return mainAxisSize;
    }

    // Use style-based size if no custom size specified
    switch (style) {
      case TabBarStyle.fixed:
        return MainAxisSize.max;
      case TabBarStyle.scrollable:
        return MainAxisSize.min;
    }
  }

  /// 📐 Get effective cross axis alignment based on position
  CrossAxisAlignment getEffectiveCrossAxisAlignment() {
    if (crossAxisAlignment != CrossAxisAlignment.center) {
      return crossAxisAlignment;
    }

    // Use position-based alignment if no custom alignment specified
    switch (position) {
      case TabBarPosition.top:
      case TabBarPosition.bottom:
        return CrossAxisAlignment.center;
    }
  }

  /// ↔️ Get effective spacing between tabs
  double getEffectiveSpacing(BuildContext context) {
    if (spacing != null) return spacing!;

    // For secondary variant, no spacing between tabs (segmented control style)
    if (variant == TabBarVariant.secondary) {
      return 0.0;
    }

    // TDesign style minimal spacing for other variants
    return 4.0;
  }

  /// ↕️ Get effective run spacing for wrapped tabs
  double getEffectiveRunSpacing(BuildContext context) {
    if (runSpacing != null) return runSpacing!;

    final sizeConfig = size.config(context);
    return sizeConfig.tabSpacing * 0.5;
  }

  /// ⏱️ Get effective animation duration
  Duration getEffectiveAnimationDuration(BuildContext context) {
    if (animationDuration != null) return animationDuration!;

    return const Duration(milliseconds: 200);
  }

  /// 🎮 Get effective scroll physics
  ScrollPhysics getEffectiveScrollPhysics(BuildContext context) {
    if (physics != null) return physics!;

    switch (style) {
      case TabBarStyle.scrollable:
        return const BouncingScrollPhysics();
      case TabBarStyle.fixed:
        return const NeverScrollableScrollPhysics();
    }
  }

  /// 🔄 Get text direction based on position
  TextDirection? getEffectiveTextDirection(BuildContext context) {
    if (textDirection != null) return textDirection;

    return Directionality.of(context);
  }

  /// 📍 Check if tabs should be wrapped
  bool get shouldWrapTabs => style == TabBarStyle.scrollable;

  /// 📱 Check if row should be scrollable
  bool get shouldScroll => style == TabBarStyle.scrollable;

  /// ⚡ Check if animations should be enabled
  bool get shouldAnimate => enableAnimation;

  /// 🎯 Get axis direction based on position
  Axis get axis {
    switch (position) {
      case TabBarPosition.top:
      case TabBarPosition.bottom:
        return Axis.horizontal;
    }
  }

  /// 📐 Get flex direction based on position
  Axis get flexDirection => axis;

  /// 🎯 Build tabs with proper spacing
  List<Widget> buildTabsWithSpacing(BuildContext context, List<Widget> tabs) {
    if (tabs.isEmpty) return tabs;

    final effectiveSpacing = getEffectiveSpacing(context);
    final spacedTabs = <Widget>[];

    for (int i = 0; i < tabs.length; i++) {
      spacedTabs.add(tabs[i]);

      // Add spacing between tabs (except after last tab)
      if (i < tabs.length - 1) {
        if (axis == Axis.horizontal) {
          spacedTabs.add(SizedBox(width: effectiveSpacing));
        } else {
          spacedTabs.add(SizedBox(height: effectiveSpacing));
        }
      }
    }

    return spacedTabs;
  }

  /// 🎯 Build scrollable wrapper if needed
  Widget buildScrollableWrapper(BuildContext context, Widget child) {
    if (!shouldScroll) {
      return child;
    }

    return SingleChildScrollView(
      controller: scrollController,
      physics: getEffectiveScrollPhysics(context),
      scrollDirection: axis,
      clipBehavior: clipNone,
      child: child,
    );
  }

  /// ⚡ Build animated wrapper if needed
  Widget buildAnimatedWrapper(BuildContext context, Widget child) {
    if (!shouldAnimate) return child;

    return AnimatedContainer(
      duration: getEffectiveAnimationDuration(context),
      curve: easeInOut,
      child: child,
    );
  }

  @override
  Widget buildWidget(BuildContext context) {
    // Get effective properties
    final effectiveMainAxisAlignment = getEffectiveMainAxisAlignment();
    final effectiveMainAxisSize = getEffectiveMainAxisSize();
    final effectiveCrossAxisAlignment = getEffectiveCrossAxisAlignment();
    final effectiveTextDirection = getEffectiveTextDirection(context);

    // Build tabs with spacing
    final spacedChildren = buildTabsWithSpacing(context, children);

    Widget rowWidget;

    // Build based on position (horizontal or vertical)
    if (position.isHorizontal) {
      // For horizontal tabs, use better overflow protection
      if (style == TabBarStyle.fixed && children.length > 4) {
        // Auto wrap for better layout
        rowWidget = OsmeaWrap(
          direction: horizontal,
          alignment: WrapAlignment.spaceEvenly,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 6.0, // Slightly more spacing for better appearance
          runSpacing: 8.0, // Better run spacing
          children: children,
        );
      } else {
        // For secondary variant with fixed style, use start alignment since tabs are already Expanded
        final finalMainAxisAlignment =
            (variant == TabBarVariant.secondary && style == TabBarStyle.fixed)
                ? MainAxisAlignment.start
                : effectiveMainAxisAlignment;

        rowWidget = OsmeaRow(
          mainAxisAlignment: finalMainAxisAlignment,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: effectiveCrossAxisAlignment,
          textDirection: effectiveTextDirection,
          verticalDirection: verticalDirection,
          textBaseline: textBaseline,
          children: spacedChildren,
        );
      }
    } else {
      // For vertical tabs, use Column with overflow protection
      if (style == TabBarStyle.fixed && children.length > 6) {
        // Auto wrap for better layout
        rowWidget = OsmeaWrap(
          direction: vertical,
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 6.0,
          runSpacing: 8.0,
          children: children,
        );
      } else {
        rowWidget = OsmeaColumn(
          mainAxisAlignment: effectiveMainAxisAlignment,
          mainAxisSize: effectiveMainAxisSize,
          crossAxisAlignment: effectiveCrossAxisAlignment,
          textDirection: effectiveTextDirection,
          verticalDirection: verticalDirection,
          textBaseline: textBaseline,
          children: spacedChildren,
        );
      }
    }

    // Apply scrollable wrapper if needed
    rowWidget = buildScrollableWrapper(context, rowWidget);

    // Apply animated wrapper if needed
    rowWidget = buildAnimatedWrapper(context, rowWidget);

    return rowWidget;
  }
}
