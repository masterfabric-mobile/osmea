// 📚 Core imports
import 'package:flutter/material.dart'; // 🎨 UI components and Material Design

/// 🔄 Status Types Enum
/// 🚦 Represents different status conditions
enum StatusType {
  error, // ❌ For error responses
  success, // ✅ For successful responses
  info // ℹ️ For informational responses
}

/// 📊 Status Information Class
/// 🧩 Contains all details needed to display a status badge
class StatusInfo {
  final StatusType type; // 🏷️ Status category
  final Color color; // 🎨 Theme color to use
  final String text; // 💬 Display text
  final IconData icon; // 🔣 Icon to show

  StatusInfo({
    required this.type,
    required this.color,
    required this.text,
    required this.icon,
  });

  /// 🏭 Factory method to create status info from response data
  /// 🔍 Analyzes the response content to determine status details
  static StatusInfo fromResponse(
      Map<String, dynamic>? responseData, ThemeData theme) {
    // 🚨 Check for error conditions
    final hasError = responseData?.containsKey('error') == true ||
        responseData?.containsKey('status') == true &&
            responseData?['status'] == 'error';

    // ✅ Check for success conditions
    final isSuccess = !hasError &&
        (responseData?.containsKey('status') == true &&
            responseData?['status'] == 'success');

    // 🎭 Determine status type
    final StatusType statusType = hasError
        ? StatusType.error
        : isSuccess
            ? StatusType.success
            : StatusType.info;

    // 🎨 Get appropriate color from theme
    Color color;
    switch (statusType) {
      case StatusType.error:
        color = theme.colorScheme.error;
        break;
      case StatusType.success:
        color = theme.colorScheme.secondary;
        break;
      case StatusType.info:
        color = theme.colorScheme.primary;
        break;
    }

    // 📝 Get appropriate status text
    String text;
    switch (statusType) {
      case StatusType.error:
        text = 'Error';
        break;
      case StatusType.success:
        text = 'Success';
        break;
      case StatusType.info:
        text = 'Info';
        break;
    }

    // 🔣 Get appropriate icon data
    IconData icon;
    switch (statusType) {
      case StatusType.error:
        icon = Icons.error_outline_rounded;
        break;
      case StatusType.success:
        icon = Icons.check_circle_outline_rounded;
        break;
      case StatusType.info:
        icon = Icons.info_outline_rounded;
        break;
    }

    return StatusInfo(
      type: statusType,
      color: color,
      text: text,
      icon: icon,
    );
  }
}
