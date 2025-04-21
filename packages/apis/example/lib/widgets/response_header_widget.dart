// 📚 Core imports
import 'package:flutter/material.dart'; // 🎨 UI components and Material Design

// 🔗 Import local widgets
import 'status_badge_widget.dart'; // 🏷️ Status badge display widget
import 'status_info_widget.dart'; // 📊 Status data classes

/// 📝 Response Header Widget
/// 🔝 Displays the title bar with status indicator and actions
/// 🔄 Adapts to different screen sizes and states
class ResponseHeaderWidget extends StatelessWidget {
  // 📄 Response data used to determine status
  final Map<String, dynamic>? responseData;

  // 🛠️ Callback for copying response to clipboard
  final VoidCallback onCopyPressed;

  // 🏗️ Constructor with required parameters
  const ResponseHeaderWidget({
    super.key,
    required this.responseData,
    required this.onCopyPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 500;

    // 📏 Adjust height and padding for small screens
    final containerHeight = isSmallScreen ? 48.0 : 56.0;
    final horizontalPadding = isSmallScreen ? 12.0 : 16.0;

    return Container(
      height: containerHeight,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // 📌 Title icon
          Icon(
            Icons.data_object_rounded,
            color: theme.colorScheme.primary,
            size: isSmallScreen ? 18 : 20,
          ),
          SizedBox(width: isSmallScreen ? 8 : 12),
          // 📝 Title text
          Text(
            'Response',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: isSmallScreen ? 14 : null,
            ),
          ),
          Spacer(),
          // 🧩 Action buttons
          if (responseData != null) ...[
            // 🚦 Status indicator
            _buildStatusIndicator(context),
            SizedBox(width: isSmallScreen ? 8 : 12),
            // 📋 Copy button
            IconButton(
              onPressed: onCopyPressed,
              icon: Icon(
                Icons.copy_rounded,
                color: theme.colorScheme.primary,
                size: isSmallScreen ? 18 : 20,
              ),
              tooltip: 'Copy JSON',
              style: IconButton.styleFrom(
                backgroundColor:
                    theme.colorScheme.primary.withValues(alpha: 0.1),
                padding: isSmallScreen ? EdgeInsets.all(6) : null,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// 🚦 Status Indicator Builder
  /// 📊 Analyzes response data and shows appropriate status (error/success/info)
  /// 🔄 Adapts to screen size for responsive design
  Widget _buildStatusIndicator(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 500;

    // 🧐 Get status info from response data
    final StatusInfo statusInfo = StatusInfo.fromResponse(responseData, theme);

    // 🎨 Return the status badge widget with styling
    return StatusBadgeWidget(
      status: statusInfo,
      isSmallScreen: isSmallScreen,
    );
  }
}
