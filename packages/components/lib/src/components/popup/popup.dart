// ignore_for_file: overridden_fields

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:osmea_components/osmea_components.dart';
import 'package:osmea_components/src/core/container_widget.dart';
import 'package:osmea_components/src/enums/popup_enums.dart';
import 'package:osmea_components/src/utils/popup_extensions.dart';

/// 📋 **OSMEA Components Library**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/components
///
/// A comprehensive popup component that implements all variants defined
/// in the OSMEA design system with full customization support.
///
/// {@category Components}
/// {@subCategory Popup}
///
/// Features:
/// * 📏 Three size options (small, medium, large)
/// * 🎨 Multiple style variants (modal, alert, dialog, tooltip)
/// * 🔄 Interactive states (hidden, visible, animating, loading)
/// * 📍 Multiple position options (center, corners, edges)
/// * 🎬 Various animation types (fade, scale, slide, slideAndFade)
/// * ♿ Full accessibility support
/// * 🌐 RTL/LTR language support
/// * 📱 Responsive design
/// * 🎭 Custom theming capabilities
///
/// ```dart
/// OsmeaPopup(
///   size: PopupSize.medium,
///   variant: PopupVariant.modal,
///   position: PopupPosition.center,
///   child: YourContent(),
/// )
/// ```
///
/// See also:
/// * [PopupSize] - Size variants enum
/// * [PopupVariant] - Style variants enum
/// * [PopupState] - Interactive states enum
/// * [PopupPosition] - Position options enum

/// 📋 **OsmeaPopup**
///
/// A comprehensive popup component for the OSMEA UI Kit.
/// Features smooth animations, flexible positioning, and complete customization.
///
/// ---
///
/// **Features:**
/// - 📏 Multiple size variants (small, medium, large)
/// - 🎨 Theme-aware colors and styles
/// - ✨ Built-in animations and positioning
/// - 🎯 Loading and various states
/// - 🔧 Fully customizable
/// - 📱 Responsive design
///
/// ---
/// _Example:_
/// ```dart
/// OsmeaPopup.show(
///   context: context,
///   size: PopupSize.medium,
///   variant: PopupVariant.modal,
///   position: PopupPosition.center,
///   title: 'Settings',
///   child: SettingsContent(),
///   onDismiss: () => Navigator.pop(context),
/// )
/// ```

class OsmeaPopup extends CoreContainer {
  const OsmeaPopup({
    super.key,
    super.customTheme,
    required this.child,
    this.size = PopupSize.medium,
    this.variant = PopupVariant.modal,
    this.state = PopupState.visible,
    this.position = PopupPosition.center,
    this.animationType = PopupAnimationType.scale,
    this.title,
    this.titleStyle,
    this.subtitle,
    this.subtitleStyle,
    this.headerActions,
    this.footer,
    this.isDismissible = true,
    this.onDismiss,
    this.onStateChanged,
    this.backgroundColor,
    this.barrierColor,
    this.elevation,
    super.padding,
    super.margin,
    this.animationDuration,
    this.constraints,
    this.shape,
    this.showCloseButton = true,
    this.closeButtonIcon,
    this.autoDismiss,
    this.width,
    this.height,
  });

  /// 👶 The main content widget displayed in the popup
  @override
  final Widget child;

  /// 📏 The size of the popup
  final PopupSize size;

  /// 🎨 The visual style variant of the popup
  final PopupVariant variant;

  /// 🔄 The current interactive state of the popup
  final PopupState state;

  /// 📍 The position of the popup on screen
  final PopupPosition position;

  /// 🎬 The animation type for showing/hiding
  final PopupAnimationType animationType;

  /// 📝 Optional title displayed at the top
  final String? title;

  /// 🎨 Custom text style for the title
  final TextStyle? titleStyle;

  /// 📄 Optional subtitle displayed below title
  final String? subtitle;

  /// 🎨 Custom text style for the subtitle
  final TextStyle? subtitleStyle;

  /// 🎯 Optional action widgets in the header (e.g., close button)
  final List<Widget>? headerActions;

  /// 🔘 Optional footer widget (e.g., action buttons)
  final Widget? footer;

  /// 🚫 Whether the popup can be dismissed by tapping outside
  final bool isDismissible;

  /// 🔔 Callback triggered when the popup is dismissed
  final VoidCallback? onDismiss;

  /// 🔄 Callback triggered when the popup state changes
  final ValueChanged<PopupState>? onStateChanged;

  /// 🎨 Custom background color that overrides the default variant background
  final Color? backgroundColor;

  /// 🎭 Custom barrier color for modal variants
  final Color? barrierColor;

  /// ⬆️ Custom elevation for dialog variants
  final double? elevation;

  /// ⏱️ Duration for popup animations
  final Duration? animationDuration;

  /// 📐 Additional constraints for the popup
  @override
  final BoxConstraints? constraints;

  /// 🔲 Custom shape for the popup
  final ShapeBorder? shape;

  /// ❌ Whether to show the close button in header
  final bool showCloseButton;

  /// 🎯 Custom close button icon
  final Widget? closeButtonIcon;

  /// ⏰ Auto dismiss duration (null means no auto dismiss)
  final Duration? autoDismiss;

  /// 📏 Custom width (overrides size-based width)
  @override
  final double? width;

  /// 📏 Custom height (overrides content-based height)
  @override
  final double? height;

  // Computed properties based on state
  bool get isHidden => state == PopupState.hidden;
  bool get isVisible => state == PopupState.visible;
  bool get isAnimating => state == PopupState.animating;
  bool get isLoading => state == PopupState.loading;

  @override
  Widget buildWidget(BuildContext context) {
    return _PopupContent(
      popup: this,
    );
  }

  /// 🚀 **Static method to show popup**
  ///
  /// Convenient method to show popup with built-in navigation and state management.
  ///
  /// ```dart
  /// OsmeaPopup.show(
  ///   context: context,
  ///   child: MyContent(),
  ///   variant: PopupVariant.modal,
  /// );
  /// ```
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    PopupSize size = PopupSize.medium,
    PopupVariant variant = PopupVariant.modal,
    PopupPosition position = PopupPosition.center,
    PopupAnimationType animationType = PopupAnimationType.scale,
    String? title,
    TextStyle? titleStyle,
    String? subtitle,
    TextStyle? subtitleStyle,
    List<Widget>? headerActions,
    Widget? footer,
    bool isDismissible = true,
    VoidCallback? onDismiss,
    ValueChanged<PopupState>? onStateChanged,
    Color? backgroundColor,
    Color? barrierColor,
    double? elevation,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Duration? animationDuration,
    BoxConstraints? constraints,
    ShapeBorder? shape,
    bool showCloseButton = true,
    Widget? closeButtonIcon,
    Duration? autoDismiss,
    double? width,
    double? height,
    bool useRootNavigator = false,
    RouteSettings? routeSettings,
  }) {
    switch (variant) {
      case PopupVariant.modal:
        return showDialog<T>(
          context: context,
          barrierDismissible: isDismissible,
          barrierColor: barrierColor ?? context.popupBarrierColor,
          useRootNavigator: useRootNavigator,
          routeSettings: routeSettings,
          builder: (context) => OsmeaPopup(
            size: size,
            variant: variant,
            state: PopupState.visible,
            position: position,
            animationType: animationType,
            title: title,
            titleStyle: titleStyle,
            subtitle: subtitle,
            subtitleStyle: subtitleStyle,
            headerActions: headerActions,
            footer: footer,
            isDismissible: isDismissible,
            onDismiss: onDismiss,
            onStateChanged: onStateChanged,
            backgroundColor: backgroundColor,
            barrierColor: barrierColor,
            elevation: elevation,
            padding: padding,
            margin: margin,
            animationDuration: animationDuration,
            constraints: constraints,
            shape: shape,
            showCloseButton: showCloseButton,
            closeButtonIcon: closeButtonIcon,
            autoDismiss: autoDismiss,
            width: width,
            height: height,
            child: child,
          ),
        );

      case PopupVariant.alert:
      case PopupVariant.dialog:
        return showDialog<T>(
          context: context,
          barrierDismissible: isDismissible,
          barrierColor: barrierColor ?? context.popupBarrierColorLight,
          useRootNavigator: useRootNavigator,
          routeSettings: routeSettings,
          builder: (context) => OsmeaPopup(
            size: size,
            variant: variant,
            state: PopupState.visible,
            position: position,
            animationType: animationType,
            title: title,
            titleStyle: titleStyle,
            subtitle: subtitle,
            subtitleStyle: subtitleStyle,
            headerActions: headerActions,
            footer: footer,
            isDismissible: isDismissible,
            onDismiss: onDismiss,
            onStateChanged: onStateChanged,
            backgroundColor: backgroundColor,
            barrierColor: barrierColor,
            elevation: elevation,
            padding: padding,
            margin: margin,
            animationDuration: animationDuration,
            constraints: constraints,
            shape: shape,
            showCloseButton: showCloseButton,
            closeButtonIcon: closeButtonIcon,
            autoDismiss: autoDismiss,
            width: width,
            height: height,
            child: child,
          ),
        );

      case PopupVariant.tooltip:
        // For tooltips, use overlay instead of dialog
        return _showTooltipPopup<T>(
          context: context,
          child: OsmeaPopup(
            size: size,
            variant: variant,
            state: PopupState.visible,
            position: position,
            animationType: animationType,
            title: title,
            titleStyle: titleStyle,
            subtitle: subtitle,
            subtitleStyle: subtitleStyle,
            headerActions: headerActions,
            footer: footer,
            isDismissible: isDismissible,
            onDismiss: onDismiss,
            onStateChanged: onStateChanged,
            backgroundColor: backgroundColor,
            barrierColor: barrierColor,
            elevation: elevation,
            padding: padding,
            margin: margin,
            animationDuration: animationDuration,
            constraints: constraints,
            shape: shape,
            showCloseButton: showCloseButton,
            closeButtonIcon: closeButtonIcon,
            autoDismiss: autoDismiss,
            width: width,
            height: height,
            child: child,
          ),
          position: position,
          isDismissible: isDismissible,
          autoDismiss: autoDismiss,
        );
    }
  }

  /// Helper method for tooltip popups using overlay
  static Future<T?> _showTooltipPopup<T>({
    required BuildContext context,
    required Widget child,
    required PopupPosition position,
    required bool isDismissible,
    Duration? autoDismiss,
  }) {
    final completer = Completer<T?>();
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => _TooltipOverlay<T>(
        position: position,
        onDismiss: () {
          overlayEntry.remove();
          if (!completer.isCompleted) {
            completer.complete(null);
          }
        },
        isDismissible: isDismissible,
        child: child,
      ),
    );

    Overlay.of(context).insert(overlayEntry);

    // Auto dismiss if specified
    if (autoDismiss != null) {
      Timer(autoDismiss, () {
        if (overlayEntry.mounted) {
          overlayEntry.remove();
          if (!completer.isCompleted) {
            completer.complete(null);
          }
        }
      });
    }

    return completer.future;
  }
}

/// Internal widget for popup content
class _PopupContent extends StatefulWidget {
  const _PopupContent({
    required this.popup,
  });

  final OsmeaPopup popup;

  @override
  State<_PopupContent> createState() => _PopupContentState();
}

class _PopupContentState extends State<_PopupContent>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  Timer? _autoDismissTimer;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _setupAutoDismiss();
  }

  void _setupAnimations() {
    final duration =
        widget.popup.animationDuration ?? context.popupAnimationDuration;

    _animationController = AnimationController(
      duration: duration,
      vsync: this,
    );

    switch (widget.popup.animationType) {
      case PopupAnimationType.fade:
        _fadeAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: _animationController,
          curve: context.popupAnimationCurve,
        ));
        break;

      case PopupAnimationType.scale:
        _scaleAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: _animationController,
          curve: context.popupScaleAnimationCurve,
        ));
        _fadeAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: _animationController,
          curve: context.popupAnimationCurve,
        ));
        break;

      case PopupAnimationType.slide:
        _slideAnimation = Tween<Offset>(
          begin: context.getPopupSlideOffset(widget.popup.position),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _animationController,
          curve: context.popupAnimationCurve,
        ));
        break;

      case PopupAnimationType.slideAndFade:
        _slideAnimation = Tween<Offset>(
          begin: context.getPopupSlideOffset(widget.popup.position),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _animationController,
          curve: context.popupAnimationCurve,
        ));
        _fadeAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: _animationController,
          curve: context.popupAnimationCurve,
        ));
        break;
    }

    if (widget.popup.state == PopupState.visible) {
      _animationController.forward();
    }
  }

  void _setupAutoDismiss() {
    if (widget.popup.autoDismiss != null) {
      _autoDismissTimer = Timer(widget.popup.autoDismiss!, () {
        _dismiss();
      });
    }
  }

  void _dismiss() {
    widget.popup.onDismiss?.call();
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _autoDismissTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: context.getPopupMargin(
        widget.popup.position,
        widget.popup.size,
      ),
      alignment: context.getPopupAlignment(widget.popup.position),
      child: _buildAnimatedContent(),
    );
  }

  Widget _buildAnimatedContent() {
    Widget content = _buildPopupContent();

    switch (widget.popup.animationType) {
      case PopupAnimationType.fade:
        return FadeTransition(
          opacity: _fadeAnimation,
          child: content,
        );

      case PopupAnimationType.scale:
        return FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: content,
          ),
        );

      case PopupAnimationType.slide:
        return SlideTransition(
          position: _slideAnimation,
          child: content,
        );

      case PopupAnimationType.slideAndFade:
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: content,
          ),
        );
    }
  }

  Widget _buildPopupContent() {
    return Material(
      type: MaterialType.card,
      color: _getBackgroundColor(),
      elevation: _getElevation(),
      shape: _getShape(),
      shadowColor: Theme.of(context).shadowColor,
      child: Container(
        width: _getWidth(),
        height: widget.popup.height,
        constraints: widget.popup.constraints ??
            BoxConstraints(
              maxHeight: context.popupMaxHeight,
            ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_hasHeader()) _buildHeader(),
            Flexible(
              child: Container(
                padding: _getContentPadding(),
                child: widget.popup.child,
              ),
            ),
            if (widget.popup.footer != null) _buildFooter(),
          ],
        ),
      ),
    );
  }

  bool _hasHeader() {
    return widget.popup.title != null ||
        widget.popup.subtitle != null ||
        widget.popup.showCloseButton ||
        (widget.popup.headerActions?.isNotEmpty ?? false);
  }

  Widget _buildHeader() {
    return Stack(
      children: [
        Container(
          padding: context.popupHeaderPadding,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.popup.title != null)
                      Text(
                        widget.popup.title!,
                        style: widget.popup.titleStyle ??
                            Theme.of(context).textTheme.titleLarge,
                      ),
                    if (widget.popup.subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        widget.popup.subtitle!,
                        style: widget.popup.subtitleStyle ??
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color:
                                      Theme.of(context).textTheme.bodySmall?.color,
                                ),
                      ),
                    ],
                  ],
                ),
              ),
              if (widget.popup.headerActions != null)
                ...widget.popup.headerActions!,
            ],
          ),
        ),
        // Close button positioned at top-right corner
        if (widget.popup.showCloseButton)
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              onPressed: _dismiss,
              icon: widget.popup.closeButtonIcon ?? const Icon(Icons.close),
              iconSize: 20,
              padding: EdgeInsets.all(8),
              visualDensity: VisualDensity.compact,
            ),
          ),
      ],
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: context.popupFooterPadding,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: widget.popup.footer!,
    );
  }

  Color _getBackgroundColor() {
    if (widget.popup.backgroundColor != null) {
      return widget.popup.backgroundColor!;
    }

    switch (widget.popup.variant) {
      case PopupVariant.modal:
      case PopupVariant.dialog:
        return Theme.of(context).dialogTheme.backgroundColor ?? Theme.of(context).colorScheme.surface;
      case PopupVariant.alert:
        return Theme.of(context).cardColor;
      case PopupVariant.tooltip:
        return Theme.of(context).tooltipTheme.decoration != null
            ? (Theme.of(context).tooltipTheme.decoration as BoxDecoration?)
                    ?.color ??
                Theme.of(context).colorScheme.inverseSurface
            : Theme.of(context).colorScheme.inverseSurface;
    }
  }

  double _getElevation() {
    if (widget.popup.elevation != null) {
      return widget.popup.elevation!;
    }

    switch (widget.popup.variant) {
      case PopupVariant.modal:
        return 24.0;
      case PopupVariant.dialog:
        return 8.0;
      case PopupVariant.alert:
        return 16.0;
      case PopupVariant.tooltip:
        return 4.0;
    }
  }

  ShapeBorder _getShape() {
    if (widget.popup.shape != null) {
      return widget.popup.shape!;
    }

    BorderRadius borderRadius;
    switch (widget.popup.size) {
      case PopupSize.small:
        borderRadius = context.popupBorderRadiusSmall;
        break;
      case PopupSize.medium:
        borderRadius = context.popupBorderRadius;
        break;
      case PopupSize.large:
        borderRadius = context.popupBorderRadiusLarge;
        break;
    }

    if (widget.popup.variant == PopupVariant.tooltip) {
      borderRadius = context.popupBorderRadiusTooltip;
    }

    return RoundedRectangleBorder(borderRadius: borderRadius);
  }

  double _getWidth() {
    if (widget.popup.width != null) {
      return widget.popup.width!;
    }

    switch (widget.popup.size) {
      case PopupSize.small:
        return context.popupWidthSmall;
      case PopupSize.medium:
        return context.popupWidthMedium;
      case PopupSize.large:
        return context.popupWidthLarge;
    }
  }

  EdgeInsets _getContentPadding() {
    if (widget.popup.padding != null) {
      return widget.popup.padding as EdgeInsets;
    }

    switch (widget.popup.size) {
      case PopupSize.small:
        return context.popupPaddingSmall;
      case PopupSize.medium:
        return context.popupPaddingMedium;
      case PopupSize.large:
        return context.popupPaddingLarge;
    }
  }
}

/// Overlay widget for tooltip popups
class _TooltipOverlay<T> extends StatelessWidget {
  const _TooltipOverlay({
    required this.child,
    required this.position,
    required this.onDismiss,
    required this.isDismissible,
  });

  final Widget child;
  final PopupPosition position;
  final VoidCallback onDismiss;
  final bool isDismissible;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: GestureDetector(
        onTap: isDismissible ? onDismiss : null,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.transparent,
          child: Align(
            alignment: context.getPopupAlignment(position),
            child: GestureDetector(
              onTap: () {}, // Prevent dismissal when tapping on content
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
