// 📚 Core imports
import 'package:flutter/material.dart'; // 🎨 UI components and Material Design

// 🔗 Import local widgets
import 'status_info_widget.dart'; // 📊 Status data classes

/// 🏷️ Status Badge Widget
/// 📌 Visual representation of status with icon and text
/// 🎨 Styled based on status type with theme colors
class StatusBadgeWidget extends StatelessWidget {
  // 📄 Status information containing all styling data
  final StatusInfo status;

  // 📱 Responsive design flag
  final bool isSmallScreen;

  // 🏗️ Constructor with required parameters
  const StatusBadgeWidget({
    super.key,
    required this.status,
    required this.isSmallScreen,
  });

  @override
  Widget build(BuildContext context) {
    // 📏 Responsive sizing
    final horizontalPadding = isSmallScreen ? 8.0 : 12.0;
    final verticalPadding = isSmallScreen ? 4.0 : 6.0;
    final fontSize = isSmallScreen ? 10.0 : 12.0;
    final iconSize = isSmallScreen ? 14.0 : 16.0;
    final spacing = isSmallScreen ? 4.0 : 6.0;

    // 🎭 Build the badge with styling from status info
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: BoxDecoration(
        color: status.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: status.color.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            status.icon,
            color: status.color,
            size: iconSize,
          ),
          SizedBox(width: spacing),
          Text(
            status.text,
            style: TextStyle(
              color: status.color,
              fontWeight: FontWeight.w600,
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );
  }
}
