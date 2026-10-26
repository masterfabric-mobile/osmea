/// 🍞 **OSMEA Toast Extensions**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/components
///
/// Extensions for toast functionality in the OSMEA UI Kit.
/// Provides convenient extension methods on BuildContext for showing toasts.
///
/// {@category Utils}
/// {@subCategory Toast}

import 'package:flutter/material.dart';
import 'package:osmea_components/osmea_components.dart';
import 'package:osmea_components/src/components/toast/toast.dart'
    show ToastManager;

/// 🍞 **Toast Context Extensions**
///
/// Extensions that provide a convenient way to show toast notifications
/// directly from any BuildContext with a fluent API.
extension OsmeaToastContextExtension on BuildContext {
  /// Shows a toast notification with full customization options
  ///
  /// Example:
  /// ```dart
  /// context.showToast(
  ///   title: 'Title',
  ///   message: 'This is a toast message',
  ///   type: ToastType.success,
  ///   position: ToastPosition.bottom,
  /// );
  /// ```
  void showToast({
    String? title,
    required String message,
    ToastType type = ToastType.info,
    ToastStyle style = ToastStyle.defaultStyle,
    ToastPosition position = ToastPosition.bottom,
    ToastAnimation animation = ToastAnimation.slide,
    Duration? duration,
    bool stacked = true,
    int maxToasts = 5,
  }) {
    // Use the ToastManager to handle the toast
    ToastManager().showToast(
      context: this,
      title: title,
      message: message,
      type: type,
      style: style,
      position: position,
      animation: animation,
      duration: duration,
      stacked: stacked,
      maxToasts: maxToasts,
    );
  }

  /// Shows a success toast notification
  ///
  /// Example:
  /// ```dart
  /// context.toastSuccess('Operation completed successfully');
  /// ```
  void toastSuccess(
    String message, {
    String? title,
    ToastStyle style = ToastStyle.defaultStyle,
    ToastPosition position = ToastPosition.bottom,
    ToastAnimation animation = ToastAnimation.slide,
    Duration? duration,
    bool stacked = true,
    int maxToasts = 5,
  }) =>
      showToast(
        title: title ?? 'Success',
        message: message,
        type: ToastType.success,
        style: style,
        position: position,
        animation: animation,
        duration: duration,
        stacked: stacked,
        maxToasts: maxToasts,
      );

  /// Shows an error toast notification
  ///
  /// Example:
  /// ```dart
  /// context.toastError('Something went wrong');
  /// ```
  void toastError(
    String message, {
    String? title,
    ToastStyle style = ToastStyle.defaultStyle,
    ToastPosition position = ToastPosition.bottom,
    ToastAnimation animation = ToastAnimation.slide,
    Duration? duration,
    bool stacked = true,
    int maxToasts = 5,
  }) =>
      showToast(
        title: title ?? 'Error',
        message: message,
        type: ToastType.error,
        style: style,
        position: position,
        animation: animation,
        duration: duration,
        stacked: stacked,
        maxToasts: maxToasts,
      );

  /// Shows a warning toast notification
  ///
  /// Example:
  /// ```dart
  /// context.toastWarning('Low battery');
  /// ```
  void toastWarning(
    String message, {
    String? title,
    ToastStyle style = ToastStyle.defaultStyle,
    ToastPosition position = ToastPosition.bottom,
    ToastAnimation animation = ToastAnimation.slide,
    Duration? duration,
    bool stacked = true,
    int maxToasts = 5,
  }) =>
      showToast(
        title: title ?? 'Warning',
        message: message,
        type: ToastType.warning,
        style: style,
        position: position,
        animation: animation,
        duration: duration,
        stacked: stacked,
        maxToasts: maxToasts,
      );

  /// Shows an info toast notification
  ///
  /// Example:
  /// ```dart
  /// context.toastInfo('New update available');
  /// ```
  void toastInfo(
    String message, {
    String? title,
    ToastStyle style = ToastStyle.defaultStyle,
    ToastPosition position = ToastPosition.bottom,
    ToastAnimation animation = ToastAnimation.slide,
    Duration? duration,
    bool stacked = true,
    int maxToasts = 5,
  }) =>
      showToast(
        title: title ?? 'Information',
        message: message,
        type: ToastType.info,
        style: style,
        position: position,
        animation: animation,
        duration: duration,
        stacked: stacked,
        maxToasts: maxToasts,
      );

  /// Hides all currently visible toasts
  ///
  /// Example:
  /// ```dart
  /// context.hideAllToasts();
  /// ```
  void hideAllToasts() {
    ToastManager().hideAllToasts();
  }

  /// Shows a quick toast notification (2 seconds duration)
  ///
  /// Example:
  /// ```dart
  /// context.quickToast('Copied to clipboard');
  /// ```
  void quickToast(
    String message, {
    ToastType type = ToastType.info,
    ToastPosition position = ToastPosition.bottom,
  }) =>
      showToast(
        message: message,
        type: type,
        style: ToastStyle.minimal,
        position: position,
        duration: const Duration(seconds: 2),
      );

  /// Shows a toast that appears on top of all other toasts, replacing any
  /// existing toast at the same position (non-stacking)
  ///
  /// Example:
  /// ```dart
  /// context.showSingleToast('Only one toast visible at a time');
  /// ```
  void showSingleToast({
    String? title,
    required String message,
    ToastType type = ToastType.info,
    ToastStyle style = ToastStyle.defaultStyle,
    ToastPosition position = ToastPosition.bottom,
    ToastAnimation animation = ToastAnimation.slide,
    Duration? duration,
  }) =>
      showToast(
        title: title,
        message: message,
        type: type,
        style: style,
        position: position,
        animation: animation,
        duration: duration,
        stacked: false, // Disable stacking to show only one toast
      );
}

/// 🍞 **Toast Position Extensions**
///
/// Extension on ToastPosition to get corresponding alignment and padding values.
/// This allows for consistent positioning of toast notifications across the app.
extension ToastPositionExtension on ToastPosition {
  /// Gets the alignment for this toast position
  Alignment getAlignment() {
    switch (this) {
      case ToastPosition.top:
        return Alignment.topCenter;
      case ToastPosition.center:
        return Alignment.center;
      case ToastPosition.bottom:
        return Alignment.bottomCenter;
    }
  }

  /// Gets the appropriate padding for this toast position
  EdgeInsets getPadding() {
    switch (this) {
      case ToastPosition.top:
        return const EdgeInsets.only(top: 16, left: 16, right: 16);
      case ToastPosition.center:
        return const EdgeInsets.symmetric(horizontal: 16);
      case ToastPosition.bottom:
        return const EdgeInsets.only(bottom: 16, left: 16, right: 16);
    }
  }

  /// Gets the slide offset for animations based on position
  Offset getSlideBeginOffset() {
    switch (this) {
      case ToastPosition.top:
        return const Offset(0.0, -1.0); // Slide from top
      case ToastPosition.bottom:
        return const Offset(0.0, 1.0); // Slide from bottom
      case ToastPosition.center:
        return const Offset(0.0, 0.5); // Slide from a little below center
    }
  }
}

/// 🍞 **Toast Type Extensions**
///
/// Extension on ToastType to get corresponding colors and icons.
/// This centralizes the visual properties of each toast type.
extension ToastTypeExtension on ToastType {
  /// Gets the appropriate color for this toast type
  Color getColor() {
    switch (this) {
      case ToastType.success:
        return OsmeaColors.forestHeart;
      case ToastType.error:
        return OsmeaColors.amberFlame;
      case ToastType.warning:
        return OsmeaColors.sunsetGlow;
      case ToastType.info:
        return OsmeaColors.nordicBlue;
    }
  }

  /// Gets the appropriate icon data for this toast type
  IconData getIconData() {
    switch (this) {
      case ToastType.success:
        return Icons.check_circle_outline;
      case ToastType.error:
        return Icons.error_outline;
      case ToastType.warning:
        return Icons.warning_amber_rounded;
      case ToastType.info:
        return Icons.info_outline;
    }
  }
}

/// 🍞 **Toast Animation Extensions**
///
/// Extension on ToastAnimation to handle animation properties and logic.
/// This centralizes animation behavior for each type of toast animation.
extension ToastAnimationExtension on ToastAnimation {
  /// Creates the appropriate animated widget for this animation type
  Widget applyAnimation({
    required Widget child,
    required bool visible,
    required ToastPosition position,
  }) {
    switch (this) {
      case ToastAnimation.fade:
        return AnimatedOpacity(
          opacity: visible ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          child: child,
        );

      case ToastAnimation.scale:
        return AnimatedScale(
          scale: visible ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          child: child,
        );

      case ToastAnimation.slide:
        final Offset beginOffset = position.getSlideBeginOffset();
        return AnimatedSlide(
          offset: visible ? Offset.zero : beginOffset,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          child: child,
        );
    }
  }
}

/// 🍞 **Toast Style Extensions**
///
/// Extension on ToastStyle to handle common styling logic.
/// This centralizes visual styling properties for each toast style.
extension ToastStyleExtension on ToastStyle {
  /// Gets whether this style uses light text and icons
  bool get usesLightContentColor {
    return this == ToastStyle.defaultStyle;
  }

  /// Gets the background color for this style (combined with toast type)
  Color getBackgroundColor(ToastType type) {
    switch (this) {
      case ToastStyle.defaultStyle:
        return type.getColor(); // Use the type color directly as background
      case ToastStyle.minimal:
        return OsmeaColors.snow;
      case ToastStyle.outline:
      case ToastStyle.modern:
        return OsmeaColors.white;
    }
  }

  /// Gets the text color for this style (combined with toast type)
  Color getTextColor(ToastType type) {
    switch (this) {
      case ToastStyle.defaultStyle:
        return OsmeaColors.white;
      case ToastStyle.minimal:
      case ToastStyle.outline:
        return type.getColor();
      case ToastStyle.modern:
        return OsmeaColors.shark;
    }
  }

  /// Gets the icon color for this style
  Color getIconColor(ToastType type) {
    switch (this) {
      case ToastStyle.modern:
        return type.getColor();
      case ToastStyle.defaultStyle:
        return OsmeaColors.white;
      case ToastStyle.minimal:
      case ToastStyle.outline:
        return type.getColor();
    }
  }

  /// Gets the close button color for this style
  Color getCloseButtonColor(ToastType type) {
    switch (this) {
      case ToastStyle.modern:
        return OsmeaColors.shark;
      case ToastStyle.defaultStyle:
        return OsmeaColors.white;
      case ToastStyle.minimal:
      case ToastStyle.outline:
        return type.getColor();
    }
  }
}
