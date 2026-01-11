/*
 * HomeErrorWidget
 * ---------------
 * Minimalist black & white error widget for home view.
 * Clean, simple, and consistent with app design.
 */

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';

/// Minimalist error widget for home view
class HomeErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const HomeErrorWidget({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.container(
      color: OsmeaColors.white,
      child: OsmeaComponents.center(
        child: OsmeaComponents.singleChildScrollView(
          padding: context.paddingHigh,
          child: OsmeaComponents.column(
            mainAxisAlignment: context.centerMain,
            crossAxisAlignment: context.crossCenter,
            children: [
              // Simple icon
              OsmeaComponents.container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: OsmeaColors.black,
                    width: 2,
                  ),
                ),
                child: OsmeaComponents.center(
                  child: Icon(
                    Icons.error_outline,
                    size: 40,
                    color: OsmeaColors.black,
                  ),
                ),
              ),
              
              OsmeaComponents.sizedBox(height: context.spacing32),
              
              // Error message
              OsmeaComponents.text(
                message,
                textStyle: OsmeaTextStyle.bodyLarge(context).copyWith(
                  color: OsmeaColors.black,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
                maxLines: 4,
              ),
              
              OsmeaComponents.sizedBox(height: context.spacing48),
              
              // Retry button
              if (onRetry != null) ...[
                OsmeaComponents.button(
                  text: 'Try Again',
                  onPressed: onRetry,
                  variant: ButtonVariant.primary,
                  size: ButtonSize.large,
                  fullWidth: true,
                ),
                OsmeaComponents.sizedBox(height: context.spacing12),
              ],
              
              // Go back button
              OsmeaComponents.button(
                text: 'Go Back',
                onPressed: () {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  } else {
                    context.go('/home');
                  }
                },
                variant: ButtonVariant.ghost,
                size: ButtonSize.large,
                fullWidth: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
