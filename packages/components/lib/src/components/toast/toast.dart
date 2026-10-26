import 'package:flutter/material.dart';
import 'package:osmea_components/src/components/align/align.dart';
import 'package:osmea_components/src/components/column/column.dart';
import 'package:osmea_components/src/components/container/container.dart';
import 'package:osmea_components/src/components/expanded/expanded.dart';
import 'package:osmea_components/src/components/padding/padding.dart';
import 'package:osmea_components/src/components/row/row.dart';
import 'package:osmea_components/src/components/stack/stack.dart';
import 'package:osmea_components/src/components/text/text.dart';
import 'package:osmea_components/src/enums/toast_enums.dart';
import 'package:osmea_components/src/enums/button_enums.dart';
import 'package:osmea_components/src/styles/colors.dart';
import 'package:osmea_components/src/utils/sizer_extensions.dart';
import 'package:osmea_components/src/utils/text_extensions.dart';
import 'package:osmea_components/src/utils/toast_extensions.dart';
import 'package:osmea_components/src/components.dart';
import 'package:osmea_components/src/styles/text_style.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:osmea_components/src/components/toast/cubit/toast_cubit.dart';
import 'package:osmea_components/src/components/toast/cubit/toast_state.dart';
import 'dart:async';
import 'package:osmea_components/src/core/container_widget.dart';

/// Global toast overlay handler that manages toast positioning and display
class GlobalToastOverlay {
  /// Singleton instance for the GlobalToastOverlay
  static final GlobalToastOverlay _instance = GlobalToastOverlay._internal();

  /// Factory constructor that returns the singleton instance
  factory GlobalToastOverlay() => _instance;

  /// Private constructor for singleton pattern
  GlobalToastOverlay._internal();

  /// Overlay entry for the toast system
  OverlayEntry? _overlayEntry;

  /// Flag to track if overlay has been initialized
  bool _isShown = false;

  /// Creates and ensures the toast overlay is present in the widget tree
  /// This will create a single overlay entry that handles all toast notifications
  void ensureOverlay(BuildContext context) {
    if (_isShown && _overlayEntry != null) return;

    // Create a new overlay entry if needed
    _overlayEntry = OverlayEntry(
      builder: (_) => const _ToastOverlayWidget(),
    );

    // Insert into the root overlay
    Overlay.of(context, rootOverlay: true).insert(_overlayEntry!);
    _isShown = true;
  }
}

/// Private widget that builds the toast overlay using BlocBuilder
class _ToastOverlayWidget extends StatelessWidget {
  const _ToastOverlayWidget();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ToastCubit, List<ToastState>>(
      bloc: ToastCubit.instance,
      builder: (context, toasts) {
        if (toasts.isEmpty) return const SizedBox.shrink();

        // Group toasts by position
        final Map<ToastPosition, List<ToastState>> groupedToasts = {
          ToastPosition.top: [],
          ToastPosition.center: [],
          ToastPosition.bottom: [],
        };

        // Organize toasts by position
        for (final toast in toasts) {
          if (toast.visible) {
            // Only include visible toasts in the grouping
            groupedToasts[toast.position]!.add(toast);
          }
        }

        // Sort each group by creation time (newest at the end for proper stacking)
        for (final position in ToastPosition.values) {
          groupedToasts[position]!
              .sort((a, b) => a.createdAt.compareTo(b.createdAt));
        }

        return OsmeaStack(
          fit: expand,
          children: [
            // Top positioned toasts
            if (groupedToasts[ToastPosition.top]!.isNotEmpty)
              _PositionedToastGroup(
                position: ToastPosition.top,
                toasts: groupedToasts[ToastPosition.top]!,
              ),

            // Center positioned toasts
            if (groupedToasts[ToastPosition.center]!.isNotEmpty)
              _PositionedToastGroup(
                position: ToastPosition.center,
                toasts: groupedToasts[ToastPosition.center]!,
              ),

            // Bottom positioned toasts
            if (groupedToasts[ToastPosition.bottom]!.isNotEmpty)
              _PositionedToastGroup(
                position: ToastPosition.bottom,
                toasts: groupedToasts[ToastPosition.bottom]!,
              ),
          ],
        );
      },
    );
  }
}

/// Widget that displays a group of toasts at a specific position
class _PositionedToastGroup extends StatelessWidget {
  final ToastPosition position;
  final List<ToastState> toasts;

  const _PositionedToastGroup({
    required this.position,
    required this.toasts,
  });

  @override
  Widget build(BuildContext context) {
    final List<ToastState> displayToasts =
        position == ToastPosition.bottom ? toasts.reversed.toList() : toasts;
    return Align(
      alignment: position.getAlignment(),
      child: SafeArea(
        child: OsmeaPadding(
          padding: position.getPadding(),
          child: OsmeaColumn(
            mainAxisSize: min,
            children: displayToasts
                .map((toast) => OsmeaPadding(
                      key: ValueKey(toast.id),
                      padding: context.onlyBottomPaddingLow,
                      child: OsmeaToast(
                        state: toast,
                        onClose: () => ToastManager().hideToast(toast.id),
                      ),
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}

/// Toast component for displaying notifications
class OsmeaToast extends CoreContainer {
  /// The state of the toast
  final ToastState state;

  /// Callback to close the toast
  final VoidCallback? onClose;

  const OsmeaToast({
    Key? key,
    required this.state,
    this.onClose,
  }) : super(key: key);

  /// Get color based on toast type using extension
  Color _typeColor(BuildContext context) {
    return state.type.getColor();
  }

  /// Get icon based on toast type using extension
  IconData _iconData() {
    return state.type.getIconData();
  }

  @override
  Widget buildWidget(BuildContext context) {
    // If toast is not visible, don't render anything
    if (!state.visible) {
      return const SizedBox.shrink();
    }

    // Calculate the maximum width for the toast
    final maxWidth = context.width320 < context.allWidth * 0.9
        ? context.width320
        : context.allWidth * 0.9;

    // Common style properties
    final borderRadius = context.borderRadiusNormal;
    final iconColor = state.style == ToastStyle.modern
        ? _typeColor(context)
        : OsmeaColors.white;
    final closeColor = state.style == ToastStyle.modern
        ? OsmeaColors.shark
        : OsmeaColors.white;
    final iconSize = context.iconSizeSmall;
    final padding = context.paddingNormal;

    // Build toast content based on style
    Widget toastContent = _buildToastContentByStyle(
      context,
      maxWidth,
      borderRadius,
      iconColor,
      closeColor,
      iconSize,
      padding,
    );

    // Apply animation based on type
    Widget animatedToast = _applyAnimation(context, toastContent);

    return animatedToast;
  }

  /// Build toast content based on style
  Widget _buildToastContentByStyle(
    BuildContext context,
    double maxWidth,
    BorderRadius borderRadius,
    Color iconColor,
    Color closeColor,
    double iconSize,
    EdgeInsets padding,
  ) {
    switch (state.style) {
      case ToastStyle.modern:
        return _buildModernToast(
            context, maxWidth, borderRadius, iconColor, closeColor, iconSize);

      case ToastStyle.minimal:
        return _buildMinimalToast(context, maxWidth, iconColor, iconSize);

      case ToastStyle.outline:
        return _buildOutlineToast(
            context, maxWidth, padding, iconColor, iconSize);

      case ToastStyle.defaultStyle:
        return _buildDefaultToast(
            context, maxWidth, borderRadius, padding, iconSize, closeColor);
    }
  }

  /// Build modern style toast
  Widget _buildModernToast(
    BuildContext context,
    double maxWidth,
    BorderRadius borderRadius,
    Color iconColor,
    Color closeColor,
    double iconSize,
  ) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: maxWidth,
        minHeight: 48,
      ),
      child: OsmeaContainer(
        decoration: BoxDecoration(
          color: OsmeaColors.white,
          borderRadius: borderRadius,
          boxShadow: [
            BoxShadow(
              color: OsmeaColors.shadowLight,
              blurRadius: context.blurRadiusHeavy,
              offset: context.offsetVertical4,
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(
          vertical: context.spacing8,
          horizontal: context.spacing12,
        ),
        child: IntrinsicHeight(
          child: OsmeaRow(
            crossAxisAlignment: crossCenter,
            children: [
              OsmeaContainer(
                width: context.width4,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: _typeColor(context),
                  borderRadius: context.borderRadiusLow,
                ),
              ),
              context.emptySizedWidthBoxNormal,
              Icon(_iconData(), color: iconColor, size: iconSize),
              context.emptySizedWidthBoxNormal,
              OsmeaExpanded(
                child: OsmeaColumn(
                  mainAxisAlignment: centerMain,
                  crossAxisAlignment: crossStart,
                  children: [
                    if (state.title != null) ...[
                      OsmeaText(
                        state.title!,
                        style: OsmeaTextStyle.labelMedium(context).copyWith(
                          color: _typeColor(context),
                          fontWeight: context.bold,
                          decoration: none,
                        ),
                        overflow: ellipsis,
                        maxLines: 1,
                      ),
                      SizedBox(height: context.spacing2),
                    ],
                    OsmeaText(
                      state.message,
                      style: OsmeaTextStyle.bodySmall(context).copyWith(
                        color: OsmeaColors.shark,
                        decoration: none,
                      ),
                      overflow: ellipsis,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              SizedBox(width: context.spacing4),
              _buildCloseButton(iconSize, closeColor),
            ],
          ),
        ),
      ),
    );
  }

  /// Build minimal style toast
  Widget _buildMinimalToast(
    BuildContext context,
    double maxWidth,
    Color iconColor,
    double iconSize,
  ) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: OsmeaContainer(
        decoration: BoxDecoration(
          color: OsmeaColors.snow,
          borderRadius: context.borderRadiusLow,
        ),
        padding: EdgeInsets.symmetric(
          vertical: context.spacing8,
          horizontal: context.spacing12,
        ),
        child: OsmeaRow(
          mainAxisSize: min,
          children: [
            Icon(_iconData(), color: _typeColor(context), size: iconSize),
            context.emptySizedWidthBoxNormal,
            OsmeaExpanded(
              child: OsmeaText(
                state.message,
                style: OsmeaTextStyle.bodySmall(context).copyWith(
                  color: _typeColor(context),
                  fontWeight: context.semiBold,
                  decoration: TextDecoration.none,
                ),
                overflow: ellipsis,
                maxLines: 2,
              ),
            ),
            context.emptySizedWidthBoxNormal,
            _buildCloseButton(iconSize, _typeColor(context)),
          ],
        ),
      ),
    );
  }

  /// Build outline style toast
  Widget _buildOutlineToast(
    BuildContext context,
    double maxWidth,
    EdgeInsets padding,
    Color iconColor,
    double iconSize,
  ) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: OsmeaContainer(
        decoration: BoxDecoration(
          color: OsmeaColors.white,
          borderRadius: context.borderRadiusNormal,
          border: Border.all(color: _typeColor(context), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: OsmeaColors.shadowLight,
              blurRadius: context.blurRadiusMedium,
              offset: context.offsetVertical2,
            ),
          ],
        ),
        padding: padding,
        child: OsmeaRow(
          mainAxisSize: min,
          crossAxisAlignment: crossCenter,
          children: [
            Icon(_iconData(), color: _typeColor(context), size: iconSize),
            context.emptySizedWidthBoxNormal,
            Expanded(
              child: OsmeaText(
                state.message,
                style: OsmeaTextStyle.bodySmall(context).copyWith(
                  color: _typeColor(context),
                  decoration: none,
                ),
                overflow: ellipsis,
                maxLines: 2,
              ),
            ),
            context.emptySizedWidthBoxNormal,
            _buildCloseButton(iconSize, _typeColor(context)),
          ],
        ),
      ),
    );
  }

  /// Build default style toast
  Widget _buildDefaultToast(
    BuildContext context,
    double maxWidth,
    BorderRadius borderRadius,
    EdgeInsets padding,
    double iconSize,
    Color closeColor,
  ) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: OsmeaContainer(
        decoration: BoxDecoration(
          color: _typeColor(context),
          borderRadius: borderRadius,
          boxShadow: [
            BoxShadow(
              color: OsmeaColors.shadowDark,
              blurRadius: context.blurRadiusMedium,
              offset: context.offsetVertical1,
            ),
          ],
        ),
        padding: padding,
        child: OsmeaRow(
          mainAxisSize: min,
          crossAxisAlignment: crossCenter,
          children: [
            Icon(_iconData(), color: OsmeaColors.white, size: iconSize),
            context.emptySizedWidthBoxNormal,
            OsmeaExpanded(
              child: OsmeaText(
                state.message,
                style: OsmeaTextStyle.bodySmall(context).copyWith(
                  color: OsmeaColors.white,
                  decoration: none,
                ),
                overflow: ellipsis,
                maxLines: 2,
              ),
            ),
            context.emptySizedWidthBoxNormal,
            _buildCloseButton(iconSize, OsmeaColors.white),
          ],
        ),
      ),
    );
  }

  /// Build close button
  Widget _buildCloseButton(double iconSize, Color color) {
    return OsmeaComponents.iconButton(
      icon: Icon(Icons.close, size: iconSize, color: color),
      onPressed: onClose,
      variant: ButtonVariant.ghost,
      size: ButtonSize.small,
      tooltip: 'Close',
      backgroundColor: OsmeaColors.transparent,
    );
  }

  /// Apply animation based on animation type using extension
  Widget _applyAnimation(BuildContext context, Widget content) {
    // Use the animation extension to apply the proper animation
    Widget animatedContent = state.animation.applyAnimation(
      child: content,
      visible: state.visible,
      position: state.position,
    );

    // Add a fade animation to all toasts for better UX
    return AnimatedOpacity(
      opacity: state.visible ? 1.0 : 0.0,
      duration: context.durationNormal,
      child: animatedContent,
    );
  }
}

Widget toastBuilder(ToastState state, VoidCallback onClose) =>
    OsmeaToast(state: state, onClose: onClose);

/// Toast Manager to handle toast operations and cubit interactions
/// This separates the cubit logic from the extensions
class ToastManager {
  /// Singleton instance
  static final ToastManager _instance = ToastManager._internal();

  /// Factory constructor
  factory ToastManager() => _instance;

  /// Private constructor
  ToastManager._internal();

  final List<_ToastEntry> _entries = [];
  final Map<String, Timer> _timers = {};
  static const int _defaultMaxToasts = 5;

  /// Show a toast notification
  void showToast({
    required BuildContext context,
    String? title,
    required String message,
    ToastType type = ToastType.info,
    ToastStyle style = ToastStyle.defaultStyle,
    ToastPosition position = ToastPosition.bottom,
    ToastAnimation animation = ToastAnimation.slide,
    Duration? duration,
    bool stacked = true,
    int maxToasts = _defaultMaxToasts,
  }) {
    final overlay = Overlay.of(context, rootOverlay: true);
    final id = UniqueKey().toString();
    final toastState = ToastState(
      id: id,
      visible: true,
      title: title,
      message: message,
      type: type,
      position: position,
      animation: animation,
      style: style,
      duration: duration ?? const Duration(seconds: 3),
    );

    // stacked control
    // If stacking is disabled, remove all previous toasts
    // If stacking is enabled and maxToasts is reached, remove the oldest toast
    // Only start the timer for the last (topmost) toast in the list
    if (!stacked) {
      for (final entry in _entries) {
        entry.overlayEntry.remove();
        _timers[entry.id]?.cancel();
        _timers.remove(entry.id);
      }
      _entries.clear();
    } else if (_entries.length >= maxToasts) {
      _timers[_entries.first.id]?.cancel();
      _entries.first.overlayEntry.remove();
      _entries.removeAt(0);
    }

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (ctx) => _SingleToastOverlay(
        state: toastState,
        onClose: () => hideToast(id),
        onAutoHide: () => hideToast(id),
      ),
    );
    _entries.add(_ToastEntry(id, entry));
    overlay.insert(entry);

    if (_entries.length == 1 || _entries.last.id == id) {
      _startAutoHideTimer(_entries.last.id, toastState.duration);
    }
  }

  void _startAutoHideTimer(String id, Duration duration) {
    _timers[id]?.cancel();
    _timers[id] = Timer(duration, () {
      hideToast(id);
    });
  }

  /// Hide all visible toasts
  void hideAllToasts() {
    for (final entry in _entries) {
      entry.overlayEntry.remove();
    }
    _entries.clear();
  }

  /// Hide a specific toast by ID
  void hideToast(String id) {
    final idx = _entries.indexWhere((e) => e.id == id);
    if (idx != -1) {
      _timers[id]?.cancel();
      _timers.remove(id);
      _entries[idx].overlayEntry.remove();
      _entries.removeAt(idx);
      if (_entries.isNotEmpty) {
        final nextId = _entries.last.id;
        _startAutoHideTimer(nextId, const Duration(seconds: 3));
      }
    }
  }
}

class _ToastEntry {
  final String id;
  final OverlayEntry overlayEntry;
  _ToastEntry(this.id, this.overlayEntry);
}

class _SingleToastOverlay extends StatelessWidget {
  final ToastState state;
  final VoidCallback onClose;
  final VoidCallback onAutoHide;
  const _SingleToastOverlay({
    required this.state,
    required this.onClose,
    required this.onAutoHide,
  });

  @override
  Widget build(BuildContext context) {
    Alignment alignment = state.position.getAlignment();
    EdgeInsets padding = state.position.getPadding();
    return IgnorePointer(
      ignoring: false,
      child: SafeArea(
        child: OsmeaStack(
          children: [
            OsmeaAlign(
              alignment: alignment,
              child: OsmeaPadding(
                padding: padding,
                child: OsmeaToast(
                  state: state,
                  onClose: onClose,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
