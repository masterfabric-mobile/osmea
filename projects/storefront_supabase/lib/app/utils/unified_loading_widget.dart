/*
 * UnifiedLoadingWidget
 * --------------------
 * Unified loading widget that reads configuration from app_config.json
 * Used across all views for consistent loading experience
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';

/// Unified loading widget that reads from app_config.json
/// All views should use this for consistent loading experience
class UnifiedLoadingWidget extends StatelessWidget {
  final Function(String) goRoute;
  final List<String>? loadingSteps;
  final LoadingModelType loadingType;

  const UnifiedLoadingWidget({
    super.key,
    required this.goRoute,
    this.loadingSteps,
    this.loadingType = LoadingModelType.dataLoading,
  });

  /// Get loading steps from config or use provided steps
  List<String> _getLoadingSteps() {
    if (loadingSteps != null && loadingSteps!.isNotEmpty) {
      return loadingSteps!;
    }

    // Try to get steps from config
    try {
      final configHelper = AssetConfigHelper();
      final config = configHelper.getObject('loading_configuration');
      if (config != null) {
        final steps = config['steps'] as List<dynamic>?;
        if (steps != null && steps.isNotEmpty) {
          return steps.map((s) => s.toString()).toList();
        }
      }
    } catch (e) {
      debugPrint('⚠️ Failed to load loading steps from config: $e');
    }

    // Default fallback steps
    return ['Loading...'];
  }

  /// Get step duration from config
  Duration _getStepDuration() {
    try {
      final configHelper = AssetConfigHelper();
      final config = configHelper.getObject('loading_configuration');
      if (config != null) {
        final durationMs = config['step_duration_milliseconds'] as int?;
        if (durationMs != null && durationMs > 0) {
          return Duration(milliseconds: durationMs);
        }
      }
    } catch (e) {
      debugPrint('⚠️ Failed to load step duration from config: $e');
    }

    // Default fallback
    return const Duration(milliseconds: 750);
  }

  /// Get show progress from config (disabled - no percent display)
  bool _getShowProgress() {
    try {
      final configHelper = AssetConfigHelper();
      final config = configHelper.getObject('loading_configuration');
      if (config != null) {
        return config['show_progress_indicator'] as bool? ?? false;
      }
    } catch (e) {
      debugPrint('⚠️ Failed to load show progress from config: $e');
    }

    // Default to false - no percent display
    return false;
  }

  /// Get show cancel button from config (disabled - no cancel functionality)
  bool _getShowCancelButton() {
    try {
      final configHelper = AssetConfigHelper();
      final config = configHelper.getObject('loading_configuration');
      if (config != null) {
        return config['tap_to_dismiss_enabled'] as bool? ?? false;
      }
    } catch (e) {
      debugPrint('⚠️ Failed to load show cancel button from config: $e');
    }

    // Default to false - no cancel button
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return LoadingScreen(
      goRoute: goRoute,
      loadingType: loadingType,
      loadingSteps: _getLoadingSteps(),
      stepDuration: _getStepDuration(),
      showProgress: _getShowProgress(),
      showCancelButton: _getShowCancelButton(),
      // No onCompleted - let views handle their own state transitions
      // No interaction - loading completes automatically and view shows content
    );
  }
}

/// Helper function for simple loading (no steps)
Widget buildUnifiedLoading({
  required Function(String) goRoute,
  LoadingModelType loadingType = LoadingModelType.dataLoading,
}) {
  return UnifiedLoadingWidget(
    goRoute: goRoute,
    loadingType: loadingType,
  );
}
