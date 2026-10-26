/// 📋 **OSMEA Popup Extensions**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/components
///
/// Comprehensive popup styling utilities for the OSMEA Design System.
/// This file contains extensions for:
///
/// - 📏 Popup sizes (small, medium, large)
/// - 📦 Padding configurations
/// - 🔲 Border radius utilities
/// - 🎨 Animation helpers
/// - 📍 Position calculations
///
/// @author OSMEA UI Team
/// @category Components
/// @subcategory Utils

import 'package:flutter/material.dart';
import 'package:osmea_components/src/enums/popup_enums.dart';
import 'package:osmea_components/src/utils/sizer_extensions.dart';

/// 📋 **Popup Size Extensions**
///
/// Provides consistent popup sizing across the OSMEA UI Kit.
/// Use these extensions to maintain visual hierarchy and user experience.
///
/// ---
///
/// **Size Categories:**
/// - `small` 🔸: Quick actions and simple content (320px width)
/// - `medium` 🔶: Standard content and forms (480px width)
/// - `large` 🔷: Detailed content and complex forms (640px width)
///
/// ---
///
/// _Example:_
/// ```dart
/// showDialog(
///   context: context,
///   builder: (context) => Dialog(
///     child: Container(
///       width: context.popupWidthMedium,
///       padding: context.popupPaddingMedium,
///       child: YourContent(),
///     ),
///   ),
/// )
/// ```
extension PopupSizeExtension on BuildContext {
  /// 🔸 **Small Popup**
  /// - Width: 320px (min 280px, max 360px)
  /// - Use for: Alerts, confirmations, simple forms
  double get popupWidthSmall {
    final screenWidth = MediaQuery.of(this).size.width;
    final calculatedWidth = screenWidth * 0.85; // 85% of screen width
    return calculatedWidth.clamp(280.0, 360.0);
  }

  /// 🔶 **Medium Popup** (Recommended)
  /// - Width: 480px (min 400px, max 520px)
  /// - Use for: Standard forms, content display
  double get popupWidthMedium {
    final screenWidth = MediaQuery.of(this).size.width;
    final calculatedWidth = screenWidth * 0.9; // 90% of screen width
    return calculatedWidth.clamp(400.0, 520.0);
  }

  /// 🔷 **Large Popup**
  /// - Width: 640px (min 560px, max 720px)
  /// - Use for: Complex forms, detailed content
  double get popupWidthLarge {
    final screenWidth = MediaQuery.of(this).size.width;
    final calculatedWidth = screenWidth * 0.95; // 95% of screen width
    return calculatedWidth.clamp(560.0, 720.0);
  }

  /// Dynamic width based on content with constraints
  double popupWidthDynamic({
    required double contentWidth,
    double maxWidthRatio = 0.9,
    double minWidth = 280.0,
  }) {
    final screenWidth = MediaQuery.of(this).size.width;
    final maxWidth = screenWidth * maxWidthRatio;
    return (contentWidth + 48).clamp(minWidth, maxWidth); // +48 for padding
  }

  /// Maximum height for popups (80% of screen height)
  double get popupMaxHeight {
    final screenHeight = MediaQuery.of(this).size.height;
    return screenHeight * 0.8;
  }
}

/// 📦 **Popup Padding Extensions**
///
/// Provides appropriate padding for different popup sizes and content.
extension PopupPaddingExtension on BuildContext {
  /// Small Popup Padding
  EdgeInsets get popupPaddingSmall => EdgeInsets.all(normalValue);

  /// Medium Popup Padding (Recommended)
  EdgeInsets get popupPaddingMedium => EdgeInsets.all(normalValue * 1.25);

  /// Large Popup Padding
  EdgeInsets get popupPaddingLarge => EdgeInsets.all(normalValue * 1.5);

  /// Content padding (inner content area)
  EdgeInsets get popupContentPadding => EdgeInsets.symmetric(
        horizontal: normalValue,
        vertical: lowValue,
      );

  /// Header padding (for titles, close buttons)
  EdgeInsets get popupHeaderPadding => EdgeInsets.only(
        top: normalValue,
        left: normalValue,
        right: normalValue,
        bottom: lowValue,
      );

  /// Footer padding (for action buttons)
  EdgeInsets get popupFooterPadding => EdgeInsets.only(
        top: lowValue,
        left: normalValue,
        right: normalValue,
        bottom: normalValue,
      );
}

/// 🔲 **Popup Border Radius Extensions**
///
/// Provides consistent border radius for popup components.
extension PopupBorderRadiusExtension on BuildContext {
  /// Standard popup border radius
  BorderRadius get popupBorderRadius => BorderRadius.circular(radiusLow * 2);

  /// Small popup border radius
  BorderRadius get popupBorderRadiusSmall =>
      BorderRadius.circular(radiusLow * 1.5);

  /// Large popup border radius
  BorderRadius get popupBorderRadiusLarge =>
      BorderRadius.circular(radiusLow * 2.5);

  /// Tooltip popup border radius
  BorderRadius get popupBorderRadiusTooltip => BorderRadius.circular(radiusLow);
}

/// 🎨 **Popup Animation Extensions**
///
/// Provides animation utilities for popup transitions.
extension PopupAnimationExtension on BuildContext {
  /// Standard popup animation duration
  Duration get popupAnimationDuration => const Duration(milliseconds: 250);

  /// Fast popup animation duration
  Duration get popupAnimationDurationFast => const Duration(milliseconds: 200);

  /// Slow popup animation duration
  Duration get popupAnimationDurationSlow => const Duration(milliseconds: 350);

  /// Popup animation curve
  Curve get popupAnimationCurve => Curves.easeOutCubic;

  /// Scale animation curve for attention-grabbing popups
  Curve get popupScaleAnimationCurve => Curves.elasticOut;
}

/// 📍 **Popup Position Extensions**
///
/// Provides position calculation utilities for popup placement.
extension PopupPositionExtension on BuildContext {
  /// Get alignment for popup position
  Alignment getPopupAlignment(PopupPosition position) {
    switch (position) {
      case PopupPosition.center:
        return Alignment.center;
      case PopupPosition.top:
        return Alignment.topCenter;
      case PopupPosition.bottom:
        return Alignment.bottomCenter;
      case PopupPosition.topLeft:
        return Alignment.topLeft;
      case PopupPosition.topRight:
        return Alignment.topRight;
      case PopupPosition.bottomLeft:
        return Alignment.bottomLeft;
      case PopupPosition.bottomRight:
        return Alignment.bottomRight;
    }
  }

  /// Get offset for slide animations based on position
  Offset getPopupSlideOffset(PopupPosition position) {
    switch (position) {
      case PopupPosition.top:
        return const Offset(0, -1);
      case PopupPosition.bottom:
        return const Offset(0, 1);
      case PopupPosition.topLeft:
        return const Offset(-1, -1);
      case PopupPosition.topRight:
        return const Offset(1, -1);
      case PopupPosition.bottomLeft:
        return const Offset(-1, 1);
      case PopupPosition.bottomRight:
        return const Offset(1, 1);
      case PopupPosition.center:
        return Offset.zero;
    }
  }

  /// Get margin based on popup position and size
  EdgeInsets getPopupMargin(PopupPosition position, PopupSize size) {
    double margin = normalValue;

    switch (size) {
      case PopupSize.small:
        margin = normalValue;
        break;
      case PopupSize.medium:
        margin = normalValue * 1.25;
        break;
      case PopupSize.large:
        margin = normalValue * 1.5;
        break;
    }

    switch (position) {
      case PopupPosition.center:
        return EdgeInsets.all(margin);
      case PopupPosition.top:
        return EdgeInsets.only(
          top: margin * 2,
          left: margin,
          right: margin,
          bottom: margin,
        );
      case PopupPosition.bottom:
        return EdgeInsets.only(
          top: margin,
          left: margin,
          right: margin,
          bottom: margin * 2,
        );
      case PopupPosition.topLeft:
        return EdgeInsets.only(
          top: margin * 2,
          left: margin * 2,
          right: margin,
          bottom: margin,
        );
      case PopupPosition.topRight:
        return EdgeInsets.only(
          top: margin * 2,
          left: margin,
          right: margin * 2,
          bottom: margin,
        );
      case PopupPosition.bottomLeft:
        return EdgeInsets.only(
          top: margin,
          left: margin * 2,
          right: margin,
          bottom: margin * 2,
        );
      case PopupPosition.bottomRight:
        return EdgeInsets.only(
          top: margin,
          left: margin,
          right: margin * 2,
          bottom: margin * 2,
        );
    }
  }
}

/// 🎭 **Popup Barrier Extensions**
///
/// Provides barrier styling for modal popups.
extension PopupBarrierExtension on BuildContext {
  /// Standard barrier color with opacity
  Color get popupBarrierColor => Colors.black.withValues(alpha: 0.5);

  /// Light barrier color for tooltips
  Color get popupBarrierColorLight => Colors.black.withValues(alpha: 0.2);

  /// Dark barrier color for important modals
  Color get popupBarrierColorDark => Colors.black.withValues(alpha: 0.7);
}

/// 🎨 **Popup Shadow Extensions**
///
/// Provides shadow styling for elevated popups.
extension PopupShadowExtension on BuildContext {
  /// Standard popup shadow
  List<BoxShadow> get popupShadow => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ];

  /// Light popup shadow for tooltips
  List<BoxShadow> get popupShadowLight => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];

  /// Heavy popup shadow for important modals
  List<BoxShadow> get popupShadowHeavy => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.15),
          blurRadius: 30,
          offset: const Offset(0, 15),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 15,
          offset: const Offset(0, 8),
        ),
      ];
}
