// ignore_for_file: use_build_context_synchronously

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import '../widgets/common_appbar.dart';

class SnackbarExample extends StatelessWidget {
  const SnackbarExample({super.key});

  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.scaffold(
      backgroundColor: OsmeaColors.white,
      appBar: const OsmeaComponentsAppBar(
        screenKey: 'snackbar_example',
      ),
      body: SingleChildScrollView(
        padding: context.paddingNormal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSectionTitle('Snackbars with Actions'),
            context.emptySizedHeightBoxNormal,
            OsmeaComponents.button(
              text: 'Show Undo Snackbar',
              onPressed: () => _showSnackbarWithProgress(
                context,
                message: 'Item deleted',
                type: SnackbarType.success,
                actionLabel: 'Undo',
                actionLabelColor: OsmeaColors.white,
                onAction: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Undo pressed!')),
                  );
                },
              ),
            ),
            SizedBox(height: context.spacing12),
            OsmeaComponents.button(
              text: 'Show Retry Snackbar',
              onPressed: () => _showSnackbarWithProgress(
                context,
                message: 'Connection failed',
                type: SnackbarType.error,
                actionLabel: 'Retry',
                onAction: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Retry pressed!')),
                  );
                },
              ),
            ),
            SizedBox(height: context.spacing12),
            OsmeaComponents.button(
              text: 'Show Dismiss Snackbar',
              onPressed: () => _showSnackbarWithProgress(
                context,
                message: 'This action cannot be undone',
                type: SnackbarType.warning,
                actionLabel: 'Dismiss',
                onAction: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Dismiss pressed!')),
                  );
                },
              ),
            ),
            SizedBox(height: context.spacing32),
            _buildSectionTitle('Custom Snackbars'),
            context.emptySizedHeightBoxNormal,
            OsmeaComponents.button(
              text: 'Top Position Snackbar',
              onPressed: () => _showSnackbarWithProgress(
                context,
                message: 'This snackbar appears at the top!',
                type: SnackbarType.info,
                position: SnackbarPosition.top,
                duration: context.durationLong,
              ),
            ),
            SizedBox(height: context.spacing12),
            OsmeaComponents.button(
              text: 'Long Duration Snackbar',
              onPressed: () => _showSnackbarWithProgress(
                context,
                message: 'This snackbar stays for 8 seconds',
                type: SnackbarType.warning,
                duration: const Duration(seconds: 8),
              ),
            ),
            SizedBox(height: context.spacing12),
            OsmeaComponents.button(
              text: 'Quick Snackbar (2s)',
              onPressed: () => _showSnackbarWithProgress(
                context,
                message: 'Copied to clipboard!',
                type: SnackbarType.info,
                duration: context.durationLong,
              ),
            ),
            SizedBox(height: context.spacing32),
            _buildSectionTitle('Multiple Snackbars'),
            context.emptySizedHeightBoxNormal,
            OsmeaComponents.button(
              text: 'Show Multiple Snackbars',
              onPressed: () {
                _showSnackbarWithProgress(
                  context,
                  message: 'First snackbar',
                  type: SnackbarType.success,
                );
                Future.delayed(const Duration(milliseconds: 500), () {
                  _showSnackbarWithProgress(
                    context,
                    message: 'Second snackbar',
                    type: SnackbarType.info,
                  );
                });
                Future.delayed(const Duration(milliseconds: 1000), () {
                  _showSnackbarWithProgress(
                    context,
                    message: 'Third snackbar',
                    type: SnackbarType.warning,
                  );
                });
              },
            ),
            SizedBox(height: context.spacing12),
            OsmeaComponents.button(
              text: 'Quick Stack (5 snackbars)',
              onPressed: () {
                for (int i = 1; i <= 5; i++) {
                  Future.delayed(Duration(milliseconds: i * 200), () {
                    _showSnackbarWithProgress(
                      context,
                      message: 'Snackbar $i',
                      type: SnackbarType.values[i % SnackbarType.values.length],
                      duration: context.durationVeryLong,
                    );
                  });
                }
              },
            ),
            SizedBox(height: context.spacing12),
            OsmeaComponents.button(
              text: 'Top Position Stack',
              onPressed: () {
                for (int i = 1; i <= 3; i++) {
                  Future.delayed(Duration(milliseconds: i * 300), () {
                    _showSnackbarWithProgress(
                      context,
                      message: 'Top Snackbar $i',
                      type: SnackbarType.values[i % SnackbarType.values.length],
                      position: SnackbarPosition.top,
                      duration: context.timeoutQuick,
                    );
                  });
                }
              },
            ),
            SizedBox(height: context.spacing12),
            OsmeaComponents.button(
              text: 'Hide All Snackbars',
              onPressed: () => context.hideAllSnackbars(),
              variant: ButtonVariant.secondary,
            ),
            SizedBox(height: context.spacing32),
            _buildSectionTitle('Features Overview'),
            context.emptySizedHeightBoxNormal,
            OsmeaComponents.container(
              padding: context.paddingNormal,
              decoration: BoxDecoration(
                color: OsmeaColors.snow,
                borderRadius: context.borderRadiusLow,
                border: Border.all(color: OsmeaColors.platinum),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OsmeaComponents.text(
                    'Snackbar Features:',
                    variant: OsmeaTextVariant.titleMedium,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(height: context.spacing8),
                  _buildFeatureItem('• Action buttons (Undo, Retry, etc.)'),
                  _buildFeatureItem('• Progress bar showing remaining time'),
                  _buildFeatureItem('• Swipe to dismiss (horizontal)'),
                  _buildFeatureItem('• Slide animation from bottom'),
                  _buildFeatureItem('• Multiple snackbars support'),
                  _buildFeatureItem('• Custom duration (default: 4 seconds)'),
                  _buildFeatureItem('• Material Design styling'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return OsmeaComponents.text(
      title,
      variant: OsmeaTextVariant.titleLarge,
      fontWeight: FontWeight.bold,
      color: OsmeaColors.nordicBlue,
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: OsmeaComponents.text(
        text,
        variant: OsmeaTextVariant.bodyMedium,
        color: OsmeaColors.shark,
      ),
    );
  }

  void _showSnackbarWithProgress(
    BuildContext context, {
    required String message,
    required SnackbarType type,
    Duration duration = const Duration(seconds: 4),
    SnackbarPosition position = SnackbarPosition.bottom,
    String? actionLabel,
    VoidCallback? onAction,
    Color? actionLabelColor,
  }) {
    context.showSnackbar(
      message: message,
      type: type,
      duration: duration,
      position: position,
      actionLabel: actionLabel,
      onAction: onAction,
      actionLabelColor: actionLabelColor,
    );
  }
}