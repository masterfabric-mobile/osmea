import 'package:flutter/material.dart';
import 'package:example/styles/app_theme.dart';

/// 🚀 Execute Button Widget
/// ⚡ Primary action button for sending API requests
/// 🎨 Styled based on selected HTTP method
class ExecuteButtonWidget extends StatelessWidget {
  /// 📋 Currently selected HTTP method (GET, POST, etc.)
  final String? selectedMethod;

  /// ⏳ Whether a request is currently loading
  final bool loading;

  /// ✅ Whether the button can be pressed
  final bool canExecute;

  /// 📲 Callback when the button is pressed
  final VoidCallback onExecute;

  /// 🏗️ Constructor with required parameters
  const ExecuteButtonWidget({
    super.key,
    required this.selectedMethod,
    required this.loading,
    required this.canExecute,
    required this.onExecute,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // 🎭 Get method-specific styling from theme (GET=blue, POST=green, etc)
    final methodStyle = selectedMethod != null
        ? AppTheme.getMethodStyle(selectedMethod!, context)
        : null;

    // 📏 Size adaptations for different screen sizes
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 500;
    final buttonHeight = isSmallScreen ? 48.0 : 56.0;

    return SizedBox(
      width: double.infinity, // ↔️ Full width button
      height: buttonHeight, // ↕️ Height based on screen size
      child: ElevatedButton(
        onPressed:
            canExecute ? onExecute : null, // 🔒 Disable when missing data
        style: ElevatedButton.styleFrom(
          // 🎨 Use theme colors instead of hardcoded values
          backgroundColor: methodStyle?.textColor ?? colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          disabledBackgroundColor: colorScheme.surfaceContainerHighest,
          // 🔄 Updated from withOpacity() to withValues() to avoid precision loss
          disabledForegroundColor:
              colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
          elevation: 0, // 🪶 Flat design
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // 🔄 Rounded corners
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (loading)
              // ⏳ Loading spinner when request is in progress
              SizedBox(
                width: isSmallScreen ? 20 : 24,
                height: isSmallScreen ? 20 : 24,
                child: CircularProgressIndicator(
                  color: colorScheme.onPrimary, // 🎨 From theme
                  strokeWidth: isSmallScreen ? 2.0 : 2.5,
                ),
              )
            else
              // 🔘 Button content when not loading
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 🔣 Method icon (if available)
                  if (methodStyle != null)
                    Icon(
                      methodStyle.iconData,
                      size: isSmallScreen ? 16 : 18,
                    ),
                  // ↔️ Responsive spacing
                  SizedBox(width: isSmallScreen ? 6 : 10),
                  // 📝 Button label with method name
                  Text(
                    selectedMethod != null
                        ? '${selectedMethod!} Request'
                        : 'Execute Request',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.onPrimary, // 🎨 Text color from theme
                      fontWeight: FontWeight.w600,
                      fontSize: isSmallScreen
                          ? 14
                          : null, // 🔤 Smaller text on small screens
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
