// 📚 Core imports
import 'package:flutter/material.dart'; // 🎨 UI components and Material Design

// 🔗 Import local widgets
import 'loading_animation_widget.dart'; // ⏳ Loading animation component

/// 🖼️ Placeholder Widget
/// 🔍 Displays appropriate placeholder when no response data is available
/// ⏳ Shows loading indicator or empty state based on loading flag
class PlaceholderWidget extends StatelessWidget {
  // ⏳ Loading state flag
  final bool loading;

  // 🏗️ Constructor with required parameters
  const PlaceholderWidget({
    super.key,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 500;
    final isVerySmallScreen = screenWidth < 360;

    // 📏 More adaptive sizing for smaller screens
    final padding = isVerySmallScreen
        ? 8.0
        : isSmallScreen
            ? 12.0
            : loading
                ? 20.0
                : 32.0;

    // 📐 Use constraints instead of fixed size
    final minHeight = isVerySmallScreen ? 100.0 : 120.0;
    final iconSize = isVerySmallScreen
        ? 32.0
        : isSmallScreen
            ? 40.0
            : 64.0;

    // 🎨 Adapt text styles to screen size
    final headlineStyle = isVerySmallScreen
        ? theme.textTheme.titleSmall
        : isSmallScreen
            ? theme.textTheme.titleMedium
            : theme.textTheme.headlineSmall;

    final bodyStyle = isVerySmallScreen
        ? theme.textTheme.bodySmall?.copyWith(fontSize: 11)
        : isSmallScreen
            ? theme.textTheme.bodySmall
            : theme.textTheme.bodyMedium;

    return Center(
      child: SingleChildScrollView(
        // 📜 Wrap in scrollview to handle overflow
        child: ConstrainedBox(
          // 📏 Use constraints instead of fixed size
          constraints: BoxConstraints(
            minHeight: minHeight,
            maxWidth: isSmallScreen ? screenWidth * 0.85 : 300,
          ),
          child: Container(
            padding: EdgeInsets.all(padding),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.1),
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // 📏 Important: use min size
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 🔄 Animation or icon
                loading
                    ? LoadingAnimationWidget(isSmallScreen: isSmallScreen)
                    : Icon(
                        Icons.api_rounded,
                        size: iconSize,
                        color: theme.colorScheme.primary.withValues(alpha: 0.5),
                      ),
                SizedBox(
                    height: isVerySmallScreen
                        ? 12
                        : isSmallScreen
                            ? 16
                            : 24),
                // 📝 Text message - make it responsive
                Text(
                  loading ? 'Processing Request' : 'Ready to Execute',
                  style: headlineStyle?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: isVerySmallScreen ? 8 : 12),
                Text(
                  loading
                      ? 'Waiting for API response...'
                      : 'Select an API endpoint and execute a request',
                  style: bodyStyle?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
