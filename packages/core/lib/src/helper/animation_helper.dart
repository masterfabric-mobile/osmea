/*
 * Animation Helper
 * ----------------
 * Utility widgets and functions for common animations and transitions.
 *
 * Copyright (c) 2025, OSMEA Team
 * https://github.com/masterfabric-mobile/osmea/tree/dev/packages/core
 */

import 'package:flutter/material.dart';
import 'asset_config_helper.dart';

/// Creates a staggered animation for list items
/// Provides smooth fade-in and slide-up animation with delay based on index
class StaggeredAnimation extends StatelessWidget {
  final Widget child;
  final int index;
  final Duration baseDuration;
  final Curve curve;

  const StaggeredAnimation({
    super.key,
    required this.child,
    required this.index,
    this.baseDuration = const Duration(milliseconds: 300),
    this.curve = Curves.easeOut,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: baseDuration + Duration(milliseconds: index * 50),
      curve: curve,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

/// Animated button with scale effect on press
/// Provides tactile feedback with scale animation when pressed
class AnimatedButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Duration animationDuration;
  final double scaleFactor;

  const AnimatedButton({
    super.key,
    required this.child,
    this.onPressed,
    this.animationDuration = const Duration(milliseconds: 150),
    this.scaleFactor = 0.95,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scaleFactor,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onPressed?.call();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: ScaleTransition(scale: _scaleAnimation, child: widget.child),
    );
  }
}

/// Animated card with scale effect on press
/// Provides visual feedback with scale animation when pressed
/// Does not modify the child's design - only adds animation
class AnimatedCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double scaleFactor;
  final Duration animationDuration;

  const AnimatedCard({
    super.key,
    required this.child,
    this.onTap,
    this.scaleFactor = 0.98,
    this.animationDuration = const Duration(milliseconds: 150),
  });

  @override
  State<AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scaleFactor,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onTap?.call();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: widget.child,
      ),
    );
  }
}

/// Haptic feedback helper
/// Provides haptic feedback functionality with config-based enable/disable
class HapticHelper {
  /// Trigger light haptic feedback if enabled in config
  static Future<void> lightImpact() async {
    try {
      final configHelper = AssetConfigHelper();
      final enabled = configHelper.getBool(
        'ui_configuration.enable_haptic_feedback',
        true,
      );
      if (enabled) {
        // HapticFeedback.lightImpact(); // Uncomment when haptic package is added
      }
    } catch (e) {
      // Silently fail if haptic is not available
    }
  }

  /// Trigger medium haptic feedback if enabled in config
  static Future<void> mediumImpact() async {
    try {
      final configHelper = AssetConfigHelper();
      final enabled = configHelper.getBool(
        'ui_configuration.enable_haptic_feedback',
        true,
      );
      if (enabled) {
        // HapticFeedback.mediumImpact();
      }
    } catch (e) {
      // Silently fail if haptic is not available
    }
  }

  /// Trigger heavy haptic feedback if enabled in config
  static Future<void> heavyImpact() async {
    try {
      final configHelper = AssetConfigHelper();
      final enabled = configHelper.getBool(
        'ui_configuration.enable_haptic_feedback',
        true,
      );
      if (enabled) {
        // HapticFeedback.heavyImpact();
      }
    } catch (e) {
      // Silently fail if haptic is not available
    }
  }
}
