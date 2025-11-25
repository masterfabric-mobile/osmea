/*
 * Product Detail Error Widget
 * ---------------------------
 * Error widget for product detail view.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';

/// Error widget for product detail view
class ProductDetailErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ProductDetailErrorWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.center(
      child: OsmeaComponents.column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: context.iconSizeExtraHigh * 1.6,
            color: OsmeaColors.red,
          ),
          OsmeaComponents.sizedBox(height: context.height16),
          OsmeaComponents.text(
            message,
            textStyle: OsmeaTextStyle.bodyMedium(context),
            textAlign: TextAlign.center,
          ),
          OsmeaComponents.sizedBox(height: context.height16),
          OsmeaComponents.button(onPressed: onRetry, text: 'Retry'),
        ],
      ),
    );
  }
}



