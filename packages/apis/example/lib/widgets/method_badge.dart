import 'package:flutter/material.dart';
import 'package:example/styles/app_theme.dart';

/// A badge widget for displaying HTTP methods with appropriate styling
class MethodBadge extends StatelessWidget {
  final String method;
  final double size;
  final bool showIcon;

  const MethodBadge({
    super.key,
    required this.method,
    this.size = 1.0,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    final methodStyle = AppTheme.getMethodStyle(method, context);

    final Color textColor = Colors.black;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10 * size,
        vertical: 6 * size,
      ),
      decoration: BoxDecoration(
        color: methodStyle.backgroundColor,
        borderRadius: BorderRadius.circular(4 * size),
        border: Border.all(
          color: Colors.black.withValues(alpha: 26),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(
              methodStyle.iconData,
              color: textColor, // Set to black
              size: 14 * size,
            ),
            SizedBox(width: 6 * size),
          ],
          Text(
            method.toUpperCase(),
            style: TextStyle(
              color: textColor, // Set to black
              fontWeight: FontWeight.bold,
              fontSize: 14 * size,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
