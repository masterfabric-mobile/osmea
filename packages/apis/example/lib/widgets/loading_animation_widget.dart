// 📚 Core imports
import 'package:flutter/material.dart'; // 🎨 UI components and Material Design

/// ⏳ Loading Animation Widget
/// 🔄 Displays a custom progress indicator with centered icon
/// ⚡ Used while waiting for API responses
class LoadingAnimationWidget extends StatelessWidget {
  // 📱 Flag for responsive sizing
  final bool isSmallScreen;

  // 🏗️ Constructor with required parameters
  const LoadingAnimationWidget({
    super.key,
    required this.isSmallScreen,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = isSmallScreen ? 50.0 : 80.0;
    final iconSize = isSmallScreen ? 24.0 : 36.0;

    return Stack(
      alignment: Alignment.center,
      children: [
        // 🔄 Circular progress indicator
        SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            strokeWidth: isSmallScreen ? 2 : 3,
            valueColor:
                AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
          ),
        ),
        // ⚡ Center icon
        Icon(
          Icons.stream_rounded,
          size: iconSize,
          color: theme.colorScheme.primary,
        ),
      ],
    );
  }
}
