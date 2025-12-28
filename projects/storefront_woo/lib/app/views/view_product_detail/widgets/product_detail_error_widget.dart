/*
 * Product Detail Error Widget
 * ---------------------------
 * User-friendly error widget for product detail view.
 * Provides helpful actions when product is not found or fails to load.
 */

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';

/// Error widget for product detail view with helpful actions
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
    final configHelper = AssetConfigHelper();
    final isNotFound = _isProductNotFound(message);
    
    // Try to get error configuration
    String errorTitle = isNotFound 
        ? 'Product Not Found'
        : 'Unable to Load Product';
    try {
      errorTitle = configHelper.getString(
        'error_handling_configuration.errorTitle',
        errorTitle,
      );
    } catch (e) {
      debugPrint('⚠️ Failed to load error title from config: $e');
    }

    // User-friendly error message
    String userMessage = message;
    if (isNotFound) {
      userMessage = 'The product you\'re looking for doesn\'t exist or has been removed.';
    }

    return OsmeaComponents.singleChildScrollView(
      padding: context.paddingHigh,
      child: OsmeaComponents.center(
        child: OsmeaComponents.column(
          mainAxisAlignment: context.centerMain,
          crossAxisAlignment: context.crossCenter,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Error icon
            OsmeaComponents.container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: OsmeaColors.pewter.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isNotFound ? Icons.search_off : Icons.error_outline,
                size: 64,
                color: OsmeaColors.pewter,
              ),
            ),
            OsmeaComponents.sizedBox(height: context.spacing24),
            // Error title
            OsmeaComponents.text(
              errorTitle,
              textStyle: OsmeaTextStyle.headlineSmall(context).copyWith(
                fontSize: context.fontSizeNormal * context.textScaleFactor,
                fontWeight: FontWeight.w700,
                color: OsmeaColors.thunder,
              ),
              textAlign: TextAlign.center,
            ),
            OsmeaComponents.sizedBox(height: context.spacing12),
            // Error message
            OsmeaComponents.text(
              userMessage,
              textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                fontSize: context.fontSizeSmall * context.textScaleFactor,
                color: OsmeaColors.pewter,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            OsmeaComponents.sizedBox(height: context.spacing32),
            // Action buttons
            OsmeaComponents.column(
              crossAxisAlignment: context.crossCenter,
              children: [
                // Retry button (primary action) - only show if not "not found"
                if (!isNotFound)
                  OsmeaComponents.button(
                    text: 'Try Again',
                    onPressed: onRetry,
                    variant: ButtonVariant.primary,
                    size: ButtonSize.large,
                    fullWidth: true,
                  ),
                if (!isNotFound) OsmeaComponents.sizedBox(height: context.spacing12),
                // Browse products button
                OsmeaComponents.button(
                  text: 'Browse All Products',
                  onPressed: () {
                    context.push('/products');
                  },
                  variant: ButtonVariant.outlined,
                  size: ButtonSize.large,
                  fullWidth: true,
                ),
                OsmeaComponents.sizedBox(height: context.spacing12),
                // Go back button
                OsmeaComponents.button(
                  text: 'Go Back',
                  onPressed: () {
                    context.pop();
                  },
                  variant: ButtonVariant.ghost,
                  size: ButtonSize.large,
                  fullWidth: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}



