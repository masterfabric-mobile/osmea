import 'package:flutter/material.dart';
import 'package:osmea_components/osmea_components.dart';
import 'package:osmea_components/src/components/center/center.dart';
import 'package:osmea_components/src/components/padding/padding.dart';
import 'package:osmea_components/src/core/container_widget.dart';
import 'package:osmea_components/src/components/text/text.dart';

/// 🏷️ **OSMEA Components Library - Badge**
///
/// Copyright (c) 2025, OSMEA Team,github.com/masterfabric-mobile/osmea/tree/dev/packages/components
///
/// A comprehensive badge component that implements all variants defined
/// in the OSMEA design system with full customization support.
///
/// {@category Components}
/// {@subCategory Badges}
///
/// Features:
/// * 🎨 Multiple style variants (primary, secondary, success, warning, danger, info, neutral, custom)
/// * 📏 Six size options (dot, extraSmall to extraLarge)
/// * 🎭 Multiple shape options (circular, rounded, pill, square, rectangle)
/// * 🔄 Interactive states (enabled, disabled, active, clickable)
/// * 📌 Positioning options (topRight, topLeft, bottomRight, bottomLeft, center, standalone)
/// * ♿ Full accessibility support
/// * 🌐 RTL/LTR language support
/// * 📱 Responsive design
/// * 🎭 Custom theming capabilities
///
/// ```dart
/// OsmeaBadge(
///   content: '8',
///   variant: BadgeVariant.primary,
///   size: BadgeSize.medium,
///   shape: BadgeShape.circular,
/// )
/// ```
///
/// See also:
/// * [BadgeVariant] - Style variants enum
/// * [BadgeSize] - Size variants enum
/// * [BadgeShape] - Shape variants enum
/// * [BadgeState] - Interactive states enum
/// * [BadgePosition] - Position options enum

/// 🏷️ **OsmeaBadge**
///
/// A comprehensive badge component for the OSMEA UI Kit.
/// Provides indicators, counters, and status markers with full customization.
///
/// ---
///
/// **Features:**
/// - 📌 Notification indicators
/// - 🔢 Count displays
/// - 🎯 Status markers
/// - 🏷️ Label badges
/// - 🔄 Positioned badges
/// - 🔘 Dot indicators
///
/// ---
/// _Example:_
/// ```dart
/// OsmeaBadge(
///   content: '3',
///   size: BadgeSize.medium,
///   variant: BadgeVariant.primary,
/// )
/// ```
class OsmeaBadge extends CoreContainer {
  /// Creates a badge with the specified properties.
  const OsmeaBadge({
    super.key,
    super.customTheme,
    this.content,
    this.size = BadgeSize.medium,
    this.variant = BadgeVariant.primary,
    this.style = BadgeStyle.normal,
    this.state = BadgeState.enabled,
    this.shape = BadgeShape.circular,
    this.position = BadgePosition.standalone,
    this.offset,
    this.maxCount,
    this.showZero = false,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.child,
    this.onTap,
    super.padding,
    super.margin,
    this.animationDuration = const Duration(milliseconds: 200),
  }) : assert(
          (size == BadgeSize.dot) || (content != null) || (child != null),
          'Either content, child, or dot size must be provided',
        );

  /// The text content to display in the badge.
  /// Can be a String (for numbers or short text) or null for dot badges.
  final dynamic content;

  /// The size variant of the badge.
  final BadgeSize size;

  /// The color/style variant of the badge.
  final BadgeVariant variant;

  /// The style of the badge.
  final BadgeStyle style;

  /// The interactive state of the badge.
  final BadgeState state;

  /// The shape of the badge.
  final BadgeShape shape;

  /// The position of the badge when used with a child widget.
  final BadgePosition position;

  /// Custom offset to adjust badge position.
  final Offset? offset;

  /// Maximum count to display before showing "+" suffix.
  /// For example, if maxCount = 99 and actual content is "125",
  /// it will display as "99+".
  final int? maxCount;

  /// Whether to show the badge when count is zero.
  final bool showZero;

  /// Optional custom background color, overriding the variant.
  final Color? backgroundColor;

  /// Optional custom text color, overriding the variant.
  final Color? textColor;

  /// Optional custom border color, overriding the variant.
  final Color? borderColor;

  /// Optional child widget that the badge will be positioned relative to.
  // ignore: annotate_overrides, overridden_fields
  final Widget? child;

  /// Callback when the badge is tapped.
  /// If provided, the badge will be treated as interactive.
  final VoidCallback? onTap;

  /// Duration for animations (appearing, state changes).
  final Duration animationDuration;

  /// Returns content to be displayed in the badge, applying maxCount logic.
  String? _getDisplayContent() {
    if (content == null) return null;
    if (content is int && maxCount != null && content > maxCount!) {
      return '$maxCount+';
    }
    return content.toString();
  }

  /// Determines if the badge should be visible.
  bool _isVisible() {
    if (size == BadgeSize.dot) return true;
    if (content == null) return false;
    if (content is int && content == 0) return showZero;
    return true;
  }

  @override
  Widget buildWidget(BuildContext context) {
    // Get size and variant configurations
    final sizeConfig = size.config(context);

    // Determine the base color according to variant
    Color baseColor;

    switch (variant) {
      case BadgeVariant.primary:
        baseColor = OsmeaColors.nordicBlue;
        break;
      case BadgeVariant.secondary:
        baseColor = OsmeaColors.pewter;
        break;
      case BadgeVariant.success:
        baseColor = OsmeaColors.forestHeart;
        break;
      case BadgeVariant.warning:
        baseColor = OsmeaColors.sunsetGlow;
        break;
      case BadgeVariant.danger:
        baseColor = OsmeaColors.amberFlame;
        break;
      case BadgeVariant.info:
        baseColor = OsmeaColors.crystalBay;
        break;
      case BadgeVariant.neutral:
        baseColor = OsmeaColors.silver;
        break;
      case BadgeVariant.custom:
        baseColor = backgroundColor ?? OsmeaColors.nordicBlue;
        break;
    }

    Color bgColor;
    Color txtColor;
    Color borderClr;

    switch (style) {
      case BadgeStyle.soft:
        bgColor =
            baseColor.withAlpha((context.alpha15 * 255).toInt()); // %15 opacity
        txtColor = baseColor;
        borderClr = OsmeaColors.transparent;
        break;
      case BadgeStyle.outlined:
        bgColor = OsmeaColors.transparent;
        txtColor = baseColor;
        borderClr = baseColor;
        break;
      case BadgeStyle.ghost:
        bgColor = OsmeaColors.transparent;
        txtColor =
            baseColor.withAlpha((context.alpha80 * 255).toInt()); // %80 opacity
        borderClr = OsmeaColors.transparent;
        break;
      case BadgeStyle.mixed:
        bgColor =
            baseColor.withAlpha((context.alpha10 * 255).toInt()); // %10 opacity
        txtColor = baseColor;
        borderClr =
            baseColor.withAlpha((context.alpha30 * 255).toInt()); // %30 opacity
        break;
      case BadgeStyle.normal:
        bgColor = baseColor;
        txtColor = OsmeaColors.white;
        borderClr = baseColor;
        break;
    }

    // Check if this is an icon badge (has both child and content, or is positioned on another widget)
    final hasIcon = (child != null && content != null) ||
        position != BadgePosition.standalone;

    final isInteractive = onTap != null && state != BadgeState.disabled;
    final displayContent = _getDisplayContent();
    final isVisible = _isVisible();

    // Don't render if not visible
    if (!isVisible) return const SizedBox.shrink();

    // Determine if we should force circular shape for icon badges
    final effectiveShape = hasIcon ? BadgeShape.circular : shape;
    final effectiveBorderRadius = effectiveShape.getBorderRadius(size, context);

    // Badge widget
    final badge = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: state == BadgeState.disabled ? null : onTap,
        borderRadius: context.borderRadiusNormal,
        splashColor: isInteractive
            ? OsmeaColors.white
                .withAlpha((context.alpha20 * 255).toInt()) // %20 opacity
            : OsmeaColors.transparent,
        hoverColor: isInteractive
            ? OsmeaColors.white
                .withAlpha((context.alpha10 * 255).toInt()) // %10 opacity
            : OsmeaColors.transparent,
        child: AnimatedContainer(
          duration: context.animationMedium,
          height: size == BadgeSize.dot
              ? sizeConfig.dotSize ?? sizeConfig.height
              : sizeConfig.height,
          // Handle size constraints appropriately for different badge types
          constraints: size == BadgeSize.dot
              ? BoxConstraints(
                  minWidth: context.width8,
                  minHeight: context.width8,
                  maxWidth: context.width8,
                  maxHeight: context.width8,
                )
              : hasIcon && position != BadgePosition.standalone
                  ? BoxConstraints(
                      // Notification badge on parent
                      minWidth:
                          content == null ? context.width8 : context.width16,
                      minHeight:
                          content == null ? context.width8 : context.width16,
                      maxHeight:
                          content == null ? context.width8 : context.width16,
                    )
                  : BoxConstraints(
                      // Normal standalone badge
                      minWidth: context.width16,
                      minHeight: size == BadgeSize.small
                          ? context.width20
                          : context.width24,
                      // Flexible width based on content
                    ),
          padding: padding ??
              (size == BadgeSize.dot ||
                      (hasIcon && position != BadgePosition.standalone)
                  ? context
                      .paddingZero // No padding for dot badges and notification badges
                  : EdgeInsets.symmetric(
                      horizontal:
                          content != null && content.toString().length <= 2
                              ? context.spacing4
                              : context.spacing8,
                      vertical: context.spacing2,
                    )),
          decoration: BoxDecoration(
            color: backgroundColor ?? bgColor,
            borderRadius: effectiveBorderRadius,
            border: style == BadgeStyle.outlined
                ? Border.all(
                    color: borderColor ?? borderClr,
                    width: sizeConfig.borderWidth ?? 1.0,
                  )
                : null,
          ),
          child: size == BadgeSize.dot
              ? null
              : OsmeaCenter(
                  child: OsmeaPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.spacing2,
                      vertical: hasIcon &&
                              content != null &&
                              content.toString().length <= 2
                          ? context.spacingZero
                          : context.width1,
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: OsmeaText(
                        displayContent!,
                        variant: OsmeaTextVariant.labelSmall,
                        color: textColor ?? txtColor,
                        fontSize: hasIcon &&
                                position != BadgePosition.standalone
                            ? context.fontSizeTiny // 8 - Notification badge
                            : (size == BadgeSize.small ||
                                    content.toString().length > 3)
                                ? context
                                    .fontSizeExtraSmall // 10 - Small badge or long content
                                : context.fontSizeSmall, // 12 - Normal badge
                        fontWeight: context.medium,
                        lineHeight:
                            context.lineHeightTight, // Compact text (1.0)
                        letterSpacing: context.letterSpacingTight,
                        maxLines: context.maxLineOne,
                        overflow: ellipsis,
                        textAlign: textCenter,
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );

    // If no child is provided, return the badge directly
    if (child == null) {
      return badge;
    }

    // Otherwise, position the badge relative to the child
    return Stack(
      clipBehavior: clipNone,
      children: [
        child!,
        // Position badge relative to parent using Positioned instead of Positioned.fill
        Positioned(
          // Position based on badge position enum
          top: position == BadgePosition.topLeft ||
                  position == BadgePosition.topRight
              ? -context.width4
              : null,
          bottom: position == BadgePosition.bottomLeft ||
                  position == BadgePosition.bottomRight
              ? -context.width4
              : null,
          left: position == BadgePosition.topLeft ||
                  position == BadgePosition.bottomLeft
              ? -context.width4
              : null,
          right: position == BadgePosition.topRight ||
                  position == BadgePosition.bottomRight
              ? -context.width4
              : null,
          // Center badge if position is center
          child: position == BadgePosition.center
              ? OsmeaCenter(child: badge)
              : Transform.translate(
                  offset: offset ??
                      (position == BadgePosition.standalone
                          ? context.offsetZero
                          : context.offsetZero),
                  child: badge,
                ),
        ),
      ],
    );
  }
}
