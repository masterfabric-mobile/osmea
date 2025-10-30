/*
 * HomeErrorWidget
 * ---------------
 * Error state widget for home view.
 * Displays error message with retry functionality.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:osmea_components/osmea_components.dart';

/// Error state widget for home view
class HomeErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const HomeErrorWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.center(
      child: OsmeaComponents.column(
        mainAxisAlignment: context.centerMain,
        children: [
          Icon(Icons.error_outline, size: context.iconSizeExtraHigh * 1.6, color: OsmeaColors.red),
          OsmeaComponents.sizedBox(height: context.spacing16),
          OsmeaComponents.text(
            message,
            textStyle: OsmeaTextStyle.bodyMedium(context),
            color: OsmeaColors.thunder,
            textAlign: context.textCenter,
          ),
          OsmeaComponents.sizedBox(height: context.spacing16),
          OsmeaComponents.button(
            onPressed: onRetry,
            backgroundColor: OsmeaColors.nordicBlue,
            textColor: OsmeaColors.paperWhite,
            text: 'Retry',
            textStyle: OsmeaTextStyle.titleMedium(
              context,
            ).copyWith(color: OsmeaColors.paperWhite),
          ),
        ],
      ),
    );
  }
}

