/*
 * Cart Error Widget
 * -----------------
 * Error widget for cart view.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';

/// Error widget for cart view
class CartErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const CartErrorWidget({
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
          Icon(
            Icons.error_outline,
            size: context.height64,
            color: OsmeaColors.amberFlame,
          ),
          OsmeaComponents.sizedBox(height: context.spacing16),
          OsmeaComponents.text(
            message,
            textStyle: OsmeaTextStyle.bodyMedium(context),
            textAlign: TextAlign.center,
          ),
          OsmeaComponents.sizedBox(height: context.spacing16),
          OsmeaComponents.button(
            onPressed: onRetry,
            text: 'Retry',
          ),
        ],
      ),
    );
  }
}

