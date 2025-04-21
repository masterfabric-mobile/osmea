// 📚 Core imports - foundational Flutter libraries
import 'dart:convert'; // 🔄 JSON encoding/decoding utilities
import 'package:flutter/material.dart'; // 🎨 UI components and Material Design
import 'package:flutter/services.dart'; // ⌨️ Platform services like clipboard

// 🔗 Import local widgets
import 'json_response_widget.dart'; // 📋 JSON formatter and display widget
import 'placeholder_widget.dart'; // 🖼️ Placeholder content widget
import 'response_header_widget.dart'; // 🔝 Header component with actions

/// 📱 ResponsePanel Widget
/// 🔍 Displays API response data with syntax highlighting and loading states
/// 📊 Features: JSON formatting, copy to clipboard, responsive design
class ResponsePanel extends StatelessWidget {
  // 📄 Response data to display (nullable for empty/loading states)
  final Map<String, dynamic>? responseData;

  // ⏳ Loading state indicator to show progress animation
  final bool loading;

  // 🏗️ Constructor with required parameters
  const ResponsePanel({
    super.key,
    required this.responseData,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    // 📏 Get screen dimensions to adapt layout
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen =
        screenWidth < 500; // 📱 Check if we're on a small device

    // ↔️ Adjust padding based on screen size for better spacing
    final padding = isSmallScreen ? 12.0 : 20.0;

    return Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔝 Use the extracted header widget
          ResponseHeaderWidget(
            responseData: responseData,
            onCopyPressed: () => _copyResponseToClipboard(context),
          ),
          SizedBox(height: isSmallScreen ? 8 : 16),
          // Make sure the content area expands to fill available space
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: responseData != null
                  ? JsonResponseWidget(responseData: responseData!)
                  : PlaceholderWidget(loading: loading),
            ),
          ),
        ],
      ),
    );
  }

  void _copyResponseToClipboard(BuildContext context) {
    final jsonString = const JsonEncoder.withIndent('  ').convert(responseData);
    Clipboard.setData(ClipboardData(text: jsonString));

    // 📢 Show snackbar with animation
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.check_circle_outline,
              color: Theme.of(context).colorScheme.onInverseSurface,
            ),
            const SizedBox(width: 8),
            Text('JSON copied to clipboard'),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        width: 280,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
