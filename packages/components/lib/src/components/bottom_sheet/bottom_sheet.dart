import 'package:flutter/material.dart';
import 'package:osmea_components/osmea_components.dart';
import 'package:osmea_components/src/core/container_widget.dart';

/// 📋 **OSMEA Components Library**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/components
///
/// A comprehensive bottom sheet component that implements all variants defined
/// in the OSMEA design system with full customization support.
///
/// {@category Components}
/// {@subCategory BottomSheet}
///
/// Features:
/// * 📏 Three size options (small, medium, large)
/// * 🎨 Multiple style variants (standard, modal, persistent, floating)
/// * 🔄 Interactive states (collapsed, expanded, dragging, animating)
/// * 🎯 Drag handle customization
/// * ♿ Full accessibility support
/// * 🌐 RTL/LTR language support
/// * 📱 Responsive design
/// * 🎭 Custom theming capabilities
///
/// ```dart
/// OsmeaBottomSheet(
///   size: BottomSheetSize.medium,
///   variant: BottomSheetVariant.modal,
///   handle: BottomSheetHandle.visible,
///   child: YourContent(),
/// )
/// ```
///
/// See also:
/// * [BottomSheetSize] - Size variants enum
/// * [BottomSheetVariant] - Style variants enum
/// * [BottomSheetState] - Interactive states enum
/// * [BottomSheetHandle] - Handle options enum

/// 📋 **OsmeaBottomSheet**
///
/// A comprehensive bottom sheet component for the OSMEA UI Kit.
/// Features smooth animations, drag interactions, and complete customization.
///
/// ---
///
/// **Features:**
/// - 📏 Multiple size variants (small, medium, large)
/// - 🎨 Theme-aware colors and styles
/// - ✨ Built-in animations and drag interactions
/// - 🎯 Loading and various states
/// - 🔧 Fully customizable
/// - 📱 Responsive design
///
/// ---
/// _Example:_
/// ```dart
/// OsmeaBottomSheet(
///   size: BottomSheetSize.medium,
///   variant: BottomSheetVariant.modal,
///   handle: BottomSheetHandle.visible,
///   title: 'Settings',
///   child: SettingsContent(),
///   onDismiss: () => Navigator.pop(context),
/// )
/// ```

class OsmeaBottomSheet extends CoreContainer {
  const OsmeaBottomSheet({
    super.key,
    super.customTheme,
    required this.child,
    this.size = BottomSheetSize.medium,
    this.variant = BottomSheetVariant.standard,
    this.state = BottomSheetState.expanded,
    this.handle = BottomSheetHandle.auto,
    this.animationType = BottomSheetAnimationType.slide,
    this.title,
    this.titleStyle,
    this.subtitle,
    this.subtitleStyle,
    this.headerActions,
    this.footer,
    this.isDismissible = true,
    this.enableDrag = true,
    this.onDismiss,
    this.onStateChanged,
    this.backgroundColor,
    this.barrierColor,
    this.elevation,
    super.padding,
    super.margin,
    this.animationDuration,
    this.isScrollControlled = true,
    this.constraints,
    this.showDragIndicator = true,
    this.shape,
    // Action Bar properties
    this.leftAction,
    this.rightAction,
    this.showActionBorder = true,
    this.actionBarBackgroundColor,
    this.actionBarBorderColor,
  });

  /// 👶 The main content widget displayed in the bottom sheet
  @override
  // ignore: overridden_fields
  final Widget child;

  /// 📏 The size of the bottom sheet
  final BottomSheetSize size;

  /// 🎨 The visual style variant of the bottom sheet
  final BottomSheetVariant variant;

  /// 🔄 The current interactive state of the bottom sheet
  final BottomSheetState state;

  /// 📍 The drag handle visibility option
  final BottomSheetHandle handle;

  /// 🎬 The animation type for showing/hiding
  final BottomSheetAnimationType animationType;

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

  /// 🚫 Whether the sheet can be dismissed by tapping outside
  final bool isDismissible;

  /// 👆 Whether the sheet supports drag gestures
  final bool enableDrag;

  /// 🔔 Callback triggered when the sheet is dismissed
  final VoidCallback? onDismiss;

  /// 🔄 Callback triggered when the sheet state changes
  final ValueChanged<BottomSheetState>? onStateChanged;

  /// 🎨 Custom background color that overrides the default variant background
  final Color? backgroundColor;

  /// 🎭 Custom barrier color for modal variants
  final Color? barrierColor;

  /// ⬆️ Custom elevation for floating variants
  final double? elevation;

  /// ⏱️ Duration for sheet animations
  final Duration? animationDuration;

  /// 📏 Whether the sheet height is controlled by content
  final bool isScrollControlled;

  /// 📐 Additional constraints for the sheet
  @override
  // ignore: overridden_fields
  final BoxConstraints? constraints;

  /// 👁️ Whether to show the drag indicator handle
  final bool showDragIndicator;

  /// 🔲 Custom shape for the bottom sheet
  final ShapeBorder? shape;

  /// 👈 **Left Action** - Action button to be shown on the left side (close, back, etc.)
  final Widget? leftAction;

  /// �� **Right Action** - Action button to be shown on the right side (forward, save, etc.)
  final Widget? rightAction;

  /// 🔲 **Show Action Border** - Whether to show a border under the action bar
  final bool showActionBorder;

  /// 🎨 **Action Bar Background Color** - Background color of the action bar
  final Color? actionBarBackgroundColor;

  /// 🎨 **Action Bar Border Color** - Border color of the action bar
  final Color? actionBarBorderColor;

  // Computed properties based on state
  bool get isCollapsed => state == BottomSheetState.collapsed;
  bool get isExpanded => state == BottomSheetState.expanded;
  bool get isDragging => state == BottomSheetState.dragging;
  bool get isAnimating => state == BottomSheetState.animating;
  bool get shouldShowHandle =>
      handle == BottomSheetHandle.visible ||
      (handle == BottomSheetHandle.auto && enableDrag && showDragIndicator);

  @override
  Widget buildWidget(BuildContext context) {
    final config = size.config(context);
    final colors = _getBottomSheetColors(context);
    final effectiveShape = shape ?? _getDefaultShape(context);

    return _buildBottomSheet(context, config, colors, effectiveShape);
  }

  Widget _buildBottomSheet(
    BuildContext context,
    BottomSheetSizeConfig config,
    _BottomSheetColors colors,
    ShapeBorder effectiveShape,
  ) {
    Widget content = Container(
      constraints: constraints ??
          BoxConstraints(
            maxHeight: config.height,
            minHeight:
                variant == BottomSheetVariant.persistent ? config.height : 0,
          ),
      decoration: BoxDecoration(
        color: backgroundColor ?? colors.background,
        borderRadius: config.borderRadius,
        boxShadow: _getShadow(context),
      ),
      child: _buildContent(context, config, colors),
    );

    // Wrap with gesture detector for drag functionality
    if (enableDrag && !isCollapsed) {
      content = GestureDetector(
        onPanStart: (_) => _onDragStart(),
        onPanUpdate: (details) => _onDragUpdate(context, details),
        onPanEnd: (details) => _onDragEnd(context, details),
        child: content,
      );
    }

    return content;
  }

  Widget _buildContent(
    BuildContext context,
    BottomSheetSizeConfig config,
    _BottomSheetColors colors,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Drag handle
        if (shouldShowHandle) _buildDragHandle(context),

        // Action bar (only in actionBar variant)
        if (variant == BottomSheetVariant.actionBar &&
            (leftAction != null || rightAction != null))
          _buildActionBar(context, colors),

        // Header (title, subtitle, actions)
        if (title != null || subtitle != null || headerActions != null)
          _buildHeader(context, colors),

        // Main content
        Flexible(
          child: SingleChildScrollView(
            padding: config.contentPadding,
            child: child,
          ),
        ),

        // Footer
        if (footer != null) _buildFooter(context),
      ],
    );
  }

  Widget _buildDragHandle(BuildContext context) {
    return Container(
      padding: context.bottomSheetHandlePadding,
      child: Center(
        child: Container(
          width: context.bottomSheetHandleSize.width,
          height: context.bottomSheetHandleSize.height,
          decoration: context.bottomSheetHandleDecoration,
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, _BottomSheetColors colors) {
    return Container(
      padding: context.bottomSheetHeaderPadding,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null)
                  Text(
                    title!,
                    style: titleStyle ?? _getDefaultTitleStyle(context, colors),
                  ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: subtitleStyle ??
                        _getDefaultSubtitleStyle(context, colors),
                  ),
                ],
              ],
            ),
          ),
          if (headerActions != null) ...headerActions!,
        ],
      ),
    );
  }

  Widget _buildActionBar(BuildContext context, _BottomSheetColors colors) {
    return Container(
      decoration: BoxDecoration(
        color: actionBarBackgroundColor ?? colors.background,
        border: showActionBorder
            ? Border(
                bottom: BorderSide(
                  color: actionBarBorderColor ?? colors.divider,
                  width: 1.0,
                ),
              )
            : null,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left action (e.g., close, back)
          leftAction ?? const SizedBox.shrink(),

          // Right action (e.g., forward, save)
          rightAction ?? const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: context.bottomSheetFooterPadding,
      child: footer!,
    );
  }

  _BottomSheetColors _getBottomSheetColors(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    switch (variant) {
      case BottomSheetVariant.standard:
        return _BottomSheetColors(
          background: colorScheme.surface,
          text: colorScheme.onSurface,
          divider: colorScheme.outline,
        );
      case BottomSheetVariant.modal:
        return _BottomSheetColors(
          background: colorScheme.surface,
          text: colorScheme.onSurface,
          divider: colorScheme.outline,
        );
      case BottomSheetVariant.persistent:
        return _BottomSheetColors(
          background: colorScheme.surfaceContainerHighest,
          text: colorScheme.onSurface,
          divider: colorScheme.outline,
        );
      case BottomSheetVariant.floating:
        return _BottomSheetColors(
          background: colorScheme.surface,
          text: colorScheme.onSurface,
          divider: colorScheme.outline,
        );
      case BottomSheetVariant.actionBar:
        return _BottomSheetColors(
          background: colorScheme.surface,
          text: colorScheme.onSurface,
          divider: colorScheme.outline,
        );
    }
  }

  ShapeBorder _getDefaultShape(BuildContext context) {
    final config = size.config(context);
    return RoundedRectangleBorder(
      borderRadius: variant == BottomSheetVariant.floating
          ? context.bottomSheetBorderRadiusFloating
          : config.borderRadius,
    );
  }

  List<BoxShadow>? _getShadow(BuildContext context) {
    if (variant == BottomSheetVariant.floating) {
      return [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: elevation ?? 8,
          offset: const Offset(0, -2),
        ),
      ];
    }
    return null;
  }

  TextStyle _getDefaultTitleStyle(
      BuildContext context, _BottomSheetColors colors) {
    return Theme.of(context).textTheme.headlineSmall!.copyWith(
          color: colors.text,
          fontWeight: FontWeight.w600,
        );
  }

  TextStyle _getDefaultSubtitleStyle(
      BuildContext context, _BottomSheetColors colors) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: colors.text.withValues(alpha: 0.7),
        );
  }

  void _onDragStart() {
    onStateChanged?.call(BottomSheetState.dragging);
  }

  void _onDragUpdate(BuildContext context, DragUpdateDetails details) {
    // Handle drag updates - can be extended for custom drag behavior
  }

  void _onDragEnd(BuildContext context, DragEndDetails details) {
    // Handle drag end - implement snap behavior
    if (details.velocity.pixelsPerSecond.dy > 300) {
      // Fast downward swipe - dismiss
      onDismiss?.call();
    } else {
      // Return to expanded state
      onStateChanged?.call(BottomSheetState.expanded);
    }
  }
}

/// Helper class for bottom sheet colors
class _BottomSheetColors {
  final Color background;
  final Color text;
  final Color divider;

  const _BottomSheetColors({
    required this.background,
    required this.text,
    required this.divider,
  });
}

/// 📋 **Static Bottom Sheet Helpers**
///
/// Utility methods for showing bottom sheets with common configurations
class OsmeaBottomSheetHelpers {
  /// Show a modal bottom sheet with standard configuration
  static Future<T?> showModal<T>({
    required BuildContext context,
    required Widget child,
    BottomSheetSize size = BottomSheetSize.medium,
    String? title,
    String? subtitle,
    List<Widget>? headerActions,
    Widget? footer,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
    Color? barrierColor,
    // Action bar parameters
    Widget? leftAction,
    Widget? rightAction,
    bool showActionBorder = true,
    Color? actionBarBackgroundColor,
    Color? actionBarBorderColor,
    // Animation parameters
    Duration? openDuration,
    Duration? closeDuration,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      builder: (context) => OsmeaBottomSheet(
        size: size,
        variant: (leftAction != null || rightAction != null)
            ? BottomSheetVariant.actionBar
            : BottomSheetVariant.modal,
        title: title,
        subtitle: subtitle,
        headerActions: headerActions,
        footer: footer,
        isDismissible: isDismissible,
        enableDrag: enableDrag,
        backgroundColor: backgroundColor,
        leftAction: leftAction,
        rightAction: rightAction,
        showActionBorder: showActionBorder,
        actionBarBackgroundColor: actionBarBackgroundColor,
        actionBarBorderColor: actionBarBorderColor,
        child: child,
      ),
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: Colors.transparent,
      barrierColor: barrierColor,
      isScrollControlled: true,
      transitionAnimationController: (openDuration != null || closeDuration != null)
          ? (AnimationController(
              vsync: Navigator.of(context),
              duration: openDuration ?? const Duration(milliseconds: 250),
              reverseDuration: closeDuration ?? const Duration(milliseconds: 250),
            )..forward())
          : null,
      shape: RoundedRectangleBorder(
        borderRadius: size.config(context).borderRadius,
      ),
    );
  }

  /// Show a persistent bottom sheet
  static PersistentBottomSheetController showPersistent({
    required BuildContext context,
    required Widget child,
    BottomSheetSize size = BottomSheetSize.medium,
    String? title,
    String? subtitle,
    List<Widget>? headerActions,
    Widget? footer,
    Color? backgroundColor,
    // Action bar parameters
    Widget? leftAction,
    Widget? rightAction,
    bool showActionBorder = true,
    Color? actionBarBackgroundColor,
    Color? actionBarBorderColor,
  }) {
    return Scaffold.of(context).showBottomSheet(
      (context) => OsmeaBottomSheet(
        size: size,
        variant: (leftAction != null || rightAction != null)
            ? BottomSheetVariant.actionBar
            : BottomSheetVariant.persistent,
        title: title,
        subtitle: subtitle,
        headerActions: headerActions,
        footer: footer,
        isDismissible: false,
        enableDrag: false,
        backgroundColor: backgroundColor,
        leftAction: leftAction,
        rightAction: rightAction,
        showActionBorder: showActionBorder,
        actionBarBackgroundColor: actionBarBackgroundColor,
        actionBarBorderColor: actionBarBorderColor,
        child: child,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: size.config(context).borderRadius,
      ),
      backgroundColor: backgroundColor,
    );
  }
}
