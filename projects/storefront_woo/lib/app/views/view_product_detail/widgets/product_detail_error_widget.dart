/*
 * Product Detail Error Widget
 * ---------------------------
 * Minimalist black & white error widget for product detail view.
 * Clean, simple, and consistent with app design.
 */

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';

/// Minimalist error widget for product detail view
class ProductDetailErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ProductDetailErrorWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  /// Checks if error indicates product not found
  bool _isProductNotFound(String errorMessage) {
    final lowerMessage = errorMessage.toLowerCase();
    return lowerMessage.contains('not found') ||
        lowerMessage.contains('404') ||
        lowerMessage.contains('product not found') ||
        lowerMessage.contains('does not exist');
  }

  @override
  Widget build(BuildContext context) {
    final isNotFound = _isProductNotFound(message);

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
                    isNotFound ? Icons.search_off : Icons.error_outline,
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
              
              // Retry button (hide if product not found)
              if (!isNotFound) ...[
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
