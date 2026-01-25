import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:osmea_components/src/core/container_widget.dart';
import 'package:osmea_components/src/utils/appbar_extensions.dart';
import 'package:osmea_components/src/components/buttons/button.dart';
import 'package:osmea_components/src/components/text/text.dart';
import 'package:osmea_components/src/utils/sizer_extensions.dart';
import 'package:osmea_components/src/utils/text_extensions.dart';
import 'package:osmea_components/src/enums/enums.dart';
import 'package:osmea_components/src/components.dart';

/// 🎯 **OSMEA Components Library - AppBar**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/osmea/components
///
/// A comprehensive application bar component that implements beautiful designs
/// and multiple variants defined in the OSMEA design system.
///
/// {@category Components}
/// {@subCategory AppBar}
///
/// Features:
/// * 🎨 Multiple design variants (primary, secondary, standard, surface, glass, gradient, outlined, elevated, transparent)
/// * 📏 Five size options (compact, standard, comfortable, large, extraLarge)
/// * 🔄 Flexible behavior types (fixed, scrollable, collapsible, floating, pinned, expandable)
/// * 🎭 Sharp visual style for consistent design language
/// * 🎮 Multiple action types support
/// * ♿ Full accessibility support
/// * 🌐 RTL/LTR language support
/// * 📱 Responsive design
/// * 🎭 Custom theming capabilities
///
/// ```dart
/// OsmeaAppBar(
///   variant: AppBarVariant.primary,
///   size: AppBarSize.standard,
///   type: AppBarType.fixed,
///   style: AppBarStyle.sharp,
///   title: Text('Beautiful App'),
///   actions: [
///     AppBarAction(
///       type: AppBarActionType.search,
///       icon: Icon(Icons.search),
///       onPressed: () => openSearch(),
///     ),
///   ],
/// )
/// ```
///
/// See also:
/// * [AppBarVariant] - Style variants enum
/// * [AppBarSize] - Size variants enum
/// * [AppBarType] - Behavior types enum
/// * [AppBarStyle] - Visual style options enum
/// * [AppBarAction] - Individual action button

/// 📄 **AppBar Action Data Class**
///
/// Represents a single action button in the AppBar.

/// 🎯 **OsmeaAppBar**
///
/// A comprehensive application bar component for the OSMEA UI Kit.
/// Features beautiful designs, multiple variants, and full customization.
///
/// **Features:**
/// - 📏 Multiple size variants (compact to extraLarge)
/// - 🎨 Beautiful design variants with modern aesthetics
/// - 🔄 Flexible behavior types for different scroll interactions
/// - 🎭 Sharp visual style for consistent design language
/// - 🎮 Multiple action types with smart positioning
/// - ✨ Built-in animations and hover effects
/// - 🔧 Fully customizable
///
/// **Example:**
/// ```dart
/// OsmeaAppBar(
///   variant: AppBarVariant.primary,
///   size: AppBarSize.comfortable,
///   type: AppBarType.scrollable,
///   style: AppBarStyle.sharp,
///   title: Text('My Beautiful App'),
///   subtitle: Text('Premium Experience'),
///   leading: Icon(Icons.menu),
///   actions: [
///     AppBarAction(
///       type: AppBarActionType.search,
///       icon: Icon(Icons.search),
///       onPressed: () => openSearch(),
///     ),
///     AppBarAction(
///       type: AppBarActionType.more,
///       icon: Icon(Icons.more_vert),
///       onPressed: () => showMenu(),
///     ),
///   ],
/// )
/// ```
class OsmeaAppBar extends CoreContainer implements PreferredSizeWidget {
  const OsmeaAppBar({
    super.key,
    super.customTheme,
    this.title,
    this.subtitle,
    this.leading,
    this.actions = const [],
    this.size = AppBarSize.standard,
    this.variant = AppBarVariant.standard,
    this.type = AppBarType.fixed,
    this.style = AppBarStyle.sharp,
    this.backgroundColor,
    this.foregroundColor,
    this.shadowColor,
    this.surfaceTintColor,
    this.titleTextColor,
    this.subtitleTextColor,
    this.iconColor,
    this.actionColor,
    super.padding,
    super.margin,
    this.animationDuration,
    this.elevation,
    this.borderRadius,
    this.centerTitle = false,
    this.titleAlignment = AppBarTitleAlignment.left,
    this.titleSpacing,
    this.toolbarOpacity = 1.0,
    this.bottomOpacity = 1.0,
    this.leadingWidth,
    this.automaticallyImplyLeading = true,
    this.excludeHeaderSemantics = false,
    this.primary = true,
    this.scrolledUnderElevation,
    this.notificationPredicate,
    this.onTitleTap,
    this.onLeadingTap,
    this.bottom,
    this.flexibleSpace,
    this.clipBehavior = Clip.none,
  });

  /// 📝 The primary title widget
  final Widget? title;

  /// 📄 Optional subtitle widget
  final Widget? subtitle;

  /// ⬅️ Widget to display before the title (typically menu or back button)
  final Widget? leading;

  /// ➡️ List of action widgets to display after the title
  final List<AppBarAction> actions;

  /// 📏 The size of the AppBar
  final AppBarSize size;

  /// 🎨 The visual style variant of the AppBar
  final AppBarVariant variant;

  /// 🔄 The behavior type of the AppBar
  final AppBarType type;

  /// 🎭 The visual style approach of the AppBar
  final AppBarStyle style;

  /// 🎨 Custom background color that overrides the default variant background
  final Color? backgroundColor;

  /// 🎯 Custom foreground color for all content
  final Color? foregroundColor;

  /// ✨ Custom shadow color
  final Color? shadowColor;

  /// 🌊 Surface tint color for Material 3
  final Color? surfaceTintColor;

  /// 📝 Specific color for the title text
  final Color? titleTextColor;

  /// 📄 Specific color for the subtitle text
  final Color? subtitleTextColor;

  /// 🎯 Color for icons
  final Color? iconColor;

  /// 🎮 Color for action buttons
  final Color? actionColor;

  /// ⏱️ Duration for AppBar animations
  final Duration? animationDuration;

  /// ✨ Elevation/shadow depth
  final double? elevation;

  /// ⭕ Custom border radius
  final BorderRadius? borderRadius;

  /// 🎯 Whether to center the title
  final bool centerTitle;

  /// � Title text alignment
  final AppBarTitleAlignment titleAlignment;

  /// �📏 Custom spacing around the title
  final double? titleSpacing;

  /// 👁️ Opacity of the toolbar
  final double toolbarOpacity;

  /// 👁️ Opacity of the bottom widget
  final double bottomOpacity;

  /// 📏 Width of the leading widget area
  final double? leadingWidth;

  /// 🔙 Whether to automatically imply leading widget
  final bool automaticallyImplyLeading;

  /// ♿ Whether to exclude header semantics
  final bool excludeHeaderSemantics;

  /// 🔝 Whether this is a primary app bar
  final bool primary;

  /// ✨ Elevation when scrolled under
  final double? scrolledUnderElevation;

  /// 📜 Predicate for scroll notifications
  final ScrollNotificationPredicate? notificationPredicate;

  /// 🖱️ Callback when title is tapped
  final VoidCallback? onTitleTap;

  /// 🖱️ Callback when leading is tapped
  final VoidCallback? onLeadingTap;

  /// ⬇️ Widget to display at the bottom of the AppBar
  final PreferredSizeWidget? bottom;

  /// 🌈 Widget to display behind the toolbar
  final Widget? flexibleSpace;

  /// ✂️ Clip behavior for the AppBar
  @override
  // ignore: overridden_fields
  final Clip clipBehavior;

  @override
  Size get preferredSize {
    final bottomHeight = bottom?.preferredSize.height ?? 0.0;
    // Static fallback heights for PreferredSizeWidget
    late final double height;
    switch (size) {
      case AppBarSize.compact:
        height = 48.0;
        break;
      case AppBarSize.standard:
        height = 56.0;
        break;
      case AppBarSize.comfortable:
        height = 64.0;
        break;
      case AppBarSize.large:
        height = 72.0;
        break;
      case AppBarSize.extraLarge:
        height = 80.0;
        break;
    }
    return Size.fromHeight(height + bottomHeight);
  }

  @override
  Widget buildWidget(BuildContext context) {
    final sizeConfig = size.getConfig(context);
    final variantConfig = variant.getConfig(context);
    final styleConfig = style.getConfig(context);

    return _buildAppBar(context, sizeConfig, variantConfig, styleConfig);
  }

  Widget _buildAppBar(
    BuildContext context,
    AppBarSizeConfig sizeConfig,
    AppBarVariantConfig variantConfig,
    AppBarShapeConfig styleConfig,
  ) {
    return AppBar(
      title: _buildTitle(context, sizeConfig, variantConfig),
      leading: _buildLeading(context, sizeConfig, variantConfig),
      actions: _buildActions(context, sizeConfig, variantConfig),
      backgroundColor: _getBackgroundColor(variantConfig),
      foregroundColor: foregroundColor ?? variantConfig.foregroundColor,
      shadowColor: shadowColor ?? variantConfig.shadowColor,
      surfaceTintColor: surfaceTintColor ?? Colors.transparent,
      elevation: elevation ?? variantConfig.elevation,
      scrolledUnderElevation:
          scrolledUnderElevation ?? (elevation ?? variantConfig.elevation),
      centerTitle: titleAlignment.shouldCenter,
      titleSpacing: titleSpacing ??
          (titleAlignment == AppBarTitleAlignment.left
              ? context.spacing4
              : null),
      toolbarOpacity: toolbarOpacity,
      bottomOpacity: bottomOpacity,
      leadingWidth: leadingWidth ??
          (titleAlignment == AppBarTitleAlignment.left
              ? context.width40 + context.spacing4
              : null),
      automaticallyImplyLeading: automaticallyImplyLeading,
      excludeHeaderSemantics: excludeHeaderSemantics,
      primary: primary,
      notificationPredicate:
          notificationPredicate ?? defaultScrollNotificationPredicate,
      bottom: bottom,
      flexibleSpace:
          _buildFlexibleSpace(context, sizeConfig, variantConfig, styleConfig),
      clipBehavior: clipBehavior,
      shape: _buildShape(context, variantConfig, styleConfig),
      toolbarHeight: sizeConfig.height,
    );
  }

  Widget? _buildTitle(
    BuildContext context,
    AppBarSizeConfig sizeConfig,
    AppBarVariantConfig variantConfig,
  ) {
    if (title == null && subtitle == null) return null;

    Widget titleWidget = title ?? const SizedBox.shrink();

    // Apply text styling if title is Text widget
    if (title is Text) {
      final textWidget = title as Text;

      titleWidget = OsmeaText(
        textWidget.data ?? '',
        variant: _getTitleTextVariant(size),
        color: titleTextColor ?? variantConfig.foregroundColor,
        textAlign: titleAlignment.textAlign,
        maxLines: 1,
        overflow: context.ellipsis,
      );
    }

    // Add subtitle if present
    if (subtitle != null) {
      Widget subtitleWidget = subtitle!;

      if (subtitle is Text) {
        final textWidget = subtitle as Text;

        subtitleWidget = OsmeaText(
          textWidget.data ?? '',
          variant: _getSubtitleTextVariant(size),
          color: subtitleTextColor ??
              variantConfig.foregroundColor.withValues(alpha: 0.7),
          textAlign: titleAlignment.textAlign,
          maxLines: 1,
          overflow: context.ellipsis,
        );
      }

      titleWidget = Column(
        mainAxisSize: min,
        crossAxisAlignment: titleAlignment == AppBarTitleAlignment.left
            ? crossStart
            : titleAlignment == AppBarTitleAlignment.right
                ? crossEnd
                : crossCenter,
        children: [
          titleWidget,
          context.emptySizedHeightBoxLow,
          subtitleWidget,
        ],
      );
    }

    // Add tap gesture if callback provided
    if (onTitleTap != null) {
      titleWidget = GestureDetector(
        onTap: onTitleTap,
        child: titleWidget,
      );
    }

    return titleWidget;
  }

  Widget? _buildLeading(
    BuildContext context,
    AppBarSizeConfig sizeConfig,
    AppBarVariantConfig variantConfig,
  ) {
    if (leading == null) return null;

    Widget leadingWidget = leading!;

    // Apply icon theming if leading is an icon
    if (leading is Icon) {
      leadingWidget = IconTheme(
        data: IconThemeData(
          color: iconColor ?? variantConfig.foregroundColor,
          size: sizeConfig.iconSize,
        ),
        child: leading!,
      );
    }

    // Add tap gesture if callback provided
    if (onLeadingTap != null) {
      leadingWidget = GestureDetector(
        onTap: onLeadingTap,
        child: leadingWidget,
      );
    }

    // Wrap in Container with reduced padding for tighter spacing
    return Container(
      alignment: centerLeft,
      padding: EdgeInsets.only(left: context.spacing8, right: context.spacing4),
      child: leadingWidget,
    );
  }

  List<Widget> _buildActions(
    BuildContext context,
    AppBarSizeConfig sizeConfig,
    AppBarVariantConfig variantConfig,
  ) {
    return actions
        .map((action) =>
            _buildAction(context, action, sizeConfig, variantConfig))
        .toList();
  }

  Widget _buildAction(
    BuildContext context,
    AppBarAction action,
    AppBarSizeConfig sizeConfig,
    AppBarVariantConfig variantConfig,
  ) {
    Widget actionWidget;

    // If text is provided, show only text (no icon)
    if (action.text != null) {
      actionWidget = InkWell(
        onTap: action.isEnabled ? action.onPressed : null,
        borderRadius: context.borderRadiusNormal,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: context.spacing8, vertical: context.spacing8),
          child: OsmeaText(
            action.text!,
            variant: OsmeaTextVariant.bodySmall,
            color: action.color ?? actionColor ?? variantConfig.foregroundColor,
            textAlign: textCenter,
          ),
        ),
      );
    } else {
      // Default button behavior for icon-only actions
      actionWidget = OsmeaButton(
        onPressed: action.isEnabled ? action.onPressed : null,
        variant: ButtonVariant.ghost,
        size: ButtonSize.small,
        icon: action.icon,
        iconPosition: IconPosition.only,
        tooltip: action.tooltip,
        backgroundColor: Colors.transparent,
        textColor: action.color ?? actionColor ?? variantConfig.foregroundColor,
      );
    }

    // Add badge if present - position it over the "n" in "Notifications"
    if (action.badge != null) {
      actionWidget = Stack(
        clipBehavior: context.clipNone,
        children: [
          actionWidget,
          // Position badge precisely over the "n" in "Notifications"
          Positioned(
            top: -context.spacing4,
            left: action.text != null
                ? context.spacing6
                : -context.spacing2, // Position over the "n" (first letter)
            child: action.badge!,
          ),
        ],
      );
    }

    return actionWidget;
  }

  Widget? _buildFlexibleSpace(
    BuildContext context,
    AppBarSizeConfig sizeConfig,
    AppBarVariantConfig variantConfig,
    AppBarShapeConfig styleConfig,
  ) {
    if (flexibleSpace != null) return flexibleSpace;

    // Handle gradient variant
    if (variant.hasGradient && variantConfig.gradient != null) {
      return Container(
        decoration: BoxDecoration(
          gradient: variantConfig.gradient,
          borderRadius: borderRadius ?? styleConfig.borderRadius,
        ),
      );
    }

    // Handle glass effect
    if (variant == AppBarVariant.glass) {
      return ClipRRect(
        borderRadius: borderRadius ?? styleConfig.borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(
              sigmaX: context.spacing10, sigmaY: context.spacing10),
          child: Container(
            decoration: BoxDecoration(
              color: variantConfig.backgroundColor
                  .withValues(alpha: variantConfig.opacity),
              borderRadius: borderRadius ?? styleConfig.borderRadius,
              border: variant.hasBorder
                  ? Border.all(
                      color: variantConfig.borderColor,
                      width: styleConfig.borderWidth,
                    )
                  : null,
            ),
          ),
        ),
      );
    }

    return null;
  }

  ShapeBorder? _buildShape(
    BuildContext context,
    AppBarVariantConfig variantConfig,
    AppBarShapeConfig styleConfig,
  ) {
    final effectiveBorderRadius = borderRadius ?? styleConfig.borderRadius;

    if (effectiveBorderRadius != BorderRadius.zero || variant.hasBorder) {
      return RoundedRectangleBorder(
        borderRadius: effectiveBorderRadius,
        side: variant.hasBorder
            ? BorderSide(
                color: variantConfig.borderColor,
                width: styleConfig.borderWidth,
              )
            : BorderSide.none,
      );
    }

    return null;
  }

  Color _getBackgroundColor(AppBarVariantConfig variantConfig) {
    if (backgroundColor != null) return backgroundColor!;

    // Handle transparent variants
    if (variant.isTransparent) {
      return variantConfig.backgroundColor
          .withValues(alpha: variantConfig.opacity);
    }

    return variantConfig.backgroundColor;
  }

  /// Get appropriate text variant for title based on size
  OsmeaTextVariant _getTitleTextVariant(AppBarSize size) {
    switch (size) {
      case AppBarSize.compact:
        return OsmeaTextVariant.bodyMedium;
      case AppBarSize.standard:
        return OsmeaTextVariant.bodyLarge;
      case AppBarSize.comfortable:
        return OsmeaTextVariant.titleSmall;
      case AppBarSize.large:
        return OsmeaTextVariant.titleMedium;
      case AppBarSize.extraLarge:
        return OsmeaTextVariant.titleLarge;
    }
  }

  /// Get appropriate text variant for subtitle based on size
  OsmeaTextVariant _getSubtitleTextVariant(AppBarSize size) {
    switch (size) {
      case AppBarSize.compact:
        return OsmeaTextVariant.bodySmall;
      case AppBarSize.standard:
        return OsmeaTextVariant.bodySmall;
      case AppBarSize.comfortable:
        return OsmeaTextVariant.bodyMedium;
      case AppBarSize.large:
        return OsmeaTextVariant.bodyMedium;
      case AppBarSize.extraLarge:
        return OsmeaTextVariant.bodyLarge;
    }
  }
}
