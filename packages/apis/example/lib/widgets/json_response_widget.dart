// 📚 Core imports
import 'dart:convert'; // 🔄 JSON encoding/decoding utilities
import 'package:flutter/material.dart'; // 🎨 UI components and Material Design

// 🌟 Syntax highlighting packages for code display
import 'package:flutter_highlight/flutter_highlight.dart'; // 💡 Code highlighting widget
import 'package:flutter_highlight/themes/atom-one-dark.dart'; // 🌙 Dark theme for code
import 'package:flutter_highlight/themes/atom-one-light.dart'; // ☀️ Light theme for code

/// 📋 JSON Response Widget
/// 🔍 Displays formatted JSON response with syntax highlighting
/// 🎨 Features theme-aware styling and responsive design
class JsonResponseWidget extends StatelessWidget {
  // 📄 Response data to display
  final Map<String, dynamic> responseData;

  // 🏗️ Constructor with required parameters
  const JsonResponseWidget({
    super.key,
    required this.responseData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 500;

    // 📏 Adjust font size for small screens
    final fontSize = isSmallScreen ? 12.0 : 14.0;
    final headerPadding = isSmallScreen
        ? const EdgeInsets.symmetric(horizontal: 12, vertical: 6)
        : const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
    final contentPadding = isSmallScreen ? 12.0 : 16.0;

    // 🔄 Convert to formatted JSON string
    final prettyJson = const JsonEncoder.withIndent('  ').convert(responseData);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // 📝 Response header
          Container(
            padding: headerPadding,
            decoration: BoxDecoration(
              color: isDark
                  ? theme.colorScheme.surface
                  : theme.colorScheme.primary,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.code_rounded,
                  color: isDark
                      ? theme.colorScheme.onSurface
                      : theme.colorScheme.onPrimary,
                  size: isSmallScreen ? 16 : 18,
                ),
                SizedBox(width: isSmallScreen ? 6 : 8),
                Text(
                  'JSON Response',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark
                        ? theme.colorScheme.onSurface
                        : theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: isSmallScreen ? 12 : null,
                  ),
                ),
                Spacer(),
                Text(
                  '${prettyJson.split('\n').length} lines',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: (isDark
                            ? theme.colorScheme.onSurface
                            : theme.colorScheme.onPrimary)
                        .withValues(alpha: 0.8),
                    fontSize: isSmallScreen ? 10 : null,
                  ),
                ),
              ],
            ),
          ),

          // 📄 Response body with syntax highlighting
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: isDark
                    ? theme.colorScheme.surface.withValues(alpha: 0.8)
                    : theme.colorScheme.surface,
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(16)),
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(contentPadding),
                child: HighlightView(
                  prettyJson,
                  language: 'json',
                  theme: isDark ? atomOneDarkTheme : atomOneLightTheme,
                  padding: EdgeInsets.all(contentPadding),
                  textStyle: TextStyle(
                    fontFamily: 'Menlo, Monaco, Consolas, monospace',
                    fontSize: fontSize,
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
