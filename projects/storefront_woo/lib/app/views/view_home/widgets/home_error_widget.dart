/*
 * HomeErrorWidget
 * ---------------
 * User-friendly error widget for home view.
 * Provides helpful actions when products fail to load.
 */

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';

/// Error widget for home view with helpful actions
class HomeErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const HomeErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final configHelper = AssetConfigHelper();
    
    // Try to get error configuration
    String errorTitle = 'Unable to Load Products';
    try {
      errorTitle = configHelper.getString(
        'error_handling_configuration.errorTitle',
        'Unable to Load Products',
      );
    } catch (e) {
      debugPrint('⚠️ Failed to load error title from config: $e');
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
                Icons.shopping_bag_outlined,
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
              message,
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
                // Retry button (primary action)
                if (onRetry != null)
                  OsmeaComponents.button(
                    text: 'Try Again',
                    onPressed: onRetry,
                    variant: ButtonVariant.primary,
                    size: ButtonSize.large,
                    fullWidth: true,
                  ),
                if (onRetry != null) OsmeaComponents.sizedBox(height: context.spacing12),
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
                // Search button
                OsmeaComponents.button(
                  text: 'Search Products',
                  onPressed: () {
                    context.push('/search');
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

