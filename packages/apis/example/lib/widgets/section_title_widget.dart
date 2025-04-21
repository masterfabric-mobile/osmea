import 'package:flutter/material.dart';

/// 📝 Section Title Widget
/// 🏷️ Displays a consistent section header with icon
/// 🎨 Styled using theme colors for visual consistency
class SectionTitleWidget extends StatelessWidget {
  /// 📝 Title text to display
  final String title;

  /// 🔣 Icon to show next to the title
  final IconData icon;

  /// 🏗️ Constructor with required parameters
  const SectionTitleWidget({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Icon(
          icon,
          color: colorScheme.primary,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
