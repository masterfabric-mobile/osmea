import 'package:flutter/material.dart';

/// 🎯 **OSMEA Empty View Models**
///
/// Copyright (c) 2025, OSMEA Team
/// Simple model structures for empty view system (like error handling)

/// 📭 Empty view page model
class EmptyPageModel {
  /// Empty view title
  final String title;

  /// Empty view description
  final String description;

  /// Empty view icon (asset path or URL)
  final String? iconPath;

  /// Empty view image (asset path or URL)
  final String? imagePath;

  /// Page background color
  final String? backgroundColor;

  /// Text color
  final String? textColor;

  /// Action button text (optional)
  final String? actionButtonText;

  /// Empty type
  final EmptyType emptyType;

  const EmptyPageModel({
    required this.title,
    required this.description,
    required this.emptyType,
    this.iconPath,
    this.imagePath,
    this.backgroundColor,
    this.textColor,
    this.actionButtonText,
  });

  /// Create EmptyPageModel from JSON
  factory EmptyPageModel.fromJson(Map<String, dynamic> json) {
    return EmptyPageModel(
      title: json['title'] as String,
      description: json['description'] as String,
      emptyType: EmptyType.values.firstWhere(
        (type) => type.name == (json['empty_type'] as String? ?? 'general'),
        orElse: () => EmptyType.general,
      ),
      iconPath: json['icon_path'] as String?,
      imagePath: json['image_path'] as String?,
      backgroundColor: json['background_color'] as String?,
      textColor: json['text_color'] as String?,
      actionButtonText: json['action_button_text'] as String?,
    );
  }

  /// Convert EmptyPageModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'empty_type': emptyType.name,
      'icon_path': iconPath,
      'image_path': imagePath,
      'background_color': backgroundColor,
      'text_color': textColor,
      'action_button_text': actionButtonText,
    };
  }

  /// Convert background color string to Color
  Color? getBackgroundColor() {
    if (backgroundColor == null) return null;
    return _parseColor(backgroundColor!);
  }

  /// Convert text color string to Color
  Color? getTextColor() {
    if (textColor == null) return null;
    return _parseColor(textColor!);
  }

  /// Convert hex color string to Color
  Color? _parseColor(String colorString) {
    try {
      String hex = colorString.replaceAll('#', '');

      // Support both 6-digit and 8-digit hex colors
      if (hex.length == 6) {
        hex = 'FF$hex'; // Add full alpha value for 6-digit colors
      } else if (hex.length == 8) {
        // 8-digit hex: RRGGBBAA format
        // Convert to Flutter's ARGB format
        String alpha = hex.substring(6, 8); // Last 2 digits are alpha
        String rgb = hex.substring(0, 6); // First 6 digits are RGB
        hex = alpha + rgb; // Reorder to ARGB
      }

      return Color(int.parse(hex, radix: 16));
    } catch (e) {
      debugPrint('❌ Error parsing color "$colorString": $e');
      return null;
    }
  }
}

/// 🎨 Empty view configuration model
class EmptyViewConfigModel {
  /// Collection of empty page configurations by empty type
  final Map<EmptyType, EmptyPageModel> emptyPages;

  /// Empty view style
  final EmptyViewStyle style;

  /// Animation duration (milliseconds)
  final int animationDuration;

  /// General theme color
  final String? primaryColor;

  /// Secondary theme color
  final String? secondaryColor;

  /// Background color
  final String? backgroundColor;

  /// Text color
  final String? textColor;

  /// Whether to enable haptic feedback
  final bool enableHapticFeedback;

  /// Default empty message
  final String defaultEmptyMessage;

  /// Whether to show action button
  final bool showActionButton;

  const EmptyViewConfigModel({
    required this.emptyPages,
    required this.style,
    this.animationDuration = 400,
    this.primaryColor,
    this.secondaryColor,
    this.backgroundColor,
    this.textColor,
    this.enableHapticFeedback = true,
    this.defaultEmptyMessage = 'No items found',
    this.showActionButton = false,
  });

  /// Create EmptyViewConfigModel from JSON
  factory EmptyViewConfigModel.fromJson(Map<String, dynamic> json) {
    final emptyPagesJson = json['empty_pages'] as List<dynamic>? ?? [];
    final emptyPages = <EmptyType, EmptyPageModel>{};

    for (final pageJson in emptyPagesJson) {
      final pageData = pageJson as Map<String, dynamic>;
      final emptyType = EmptyType.values.firstWhere(
        (type) => type.name == (pageData['empty_type'] as String? ?? 'general'),
        orElse: () => EmptyType.general,
      );
      emptyPages[emptyType] = EmptyPageModel.fromJson(pageData);
    }

    return EmptyViewConfigModel(
      emptyPages: emptyPages,
      style: EmptyViewStyle.values.firstWhere(
        (style) => style.name == (json['style'] as String? ?? 'startup'),
        orElse: () => EmptyViewStyle.startup,
      ),
      animationDuration: json['animation_duration'] as int? ?? 400,
      primaryColor: json['primary_color'] as String?,
      secondaryColor: json['secondary_color'] as String?,
      backgroundColor: json['background_color'] as String?,
      textColor: json['text_color'] as String?,
      enableHapticFeedback: json['enable_haptic_feedback'] as bool? ?? true,
      defaultEmptyMessage: json['default_empty_message'] as String? ??
          'No items found',
      showActionButton: json['show_action_button'] as bool? ?? false,
    );
  }

  /// Convert EmptyViewConfigModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'empty_pages': emptyPages.values.map((page) => page.toJson()).toList(),
      'style': style.name,
      'animation_duration': animationDuration,
      'primary_color': primaryColor,
      'secondary_color': secondaryColor,
      'background_color': backgroundColor,
      'text_color': textColor,
      'enable_haptic_feedback': enableHapticFeedback,
      'default_empty_message': defaultEmptyMessage,
      'show_action_button': showActionButton,
    };
  }

  /// Get primary color as Color object
  Color? getPrimaryColor() {
    if (primaryColor == null) return null;
    return _parseColor(primaryColor!);
  }

  /// Get secondary color as Color object
  Color? getSecondaryColor() {
    if (secondaryColor == null) return null;
    return _parseColor(secondaryColor!);
  }

  /// Get background color as Color object
  Color? getBackgroundColor() {
    if (backgroundColor == null) return null;
    return _parseColor(backgroundColor!);
  }

  /// Get text color as Color object
  Color? getTextColor() {
    if (textColor == null) return null;
    return _parseColor(textColor!);
  }

  /// Convert hex color string to Color
  Color? _parseColor(String colorString) {
    try {
      String hex = colorString.replaceAll('#', '');

      // Support both 6-digit and 8-digit hex colors
      if (hex.length == 6) {
        hex = 'FF$hex'; // Add full alpha value for 6-digit colors
      } else if (hex.length == 8) {
        // 8-digit hex: RRGGBBAA format
        // Convert to Flutter's ARGB format
        String alpha = hex.substring(6, 8); // Last 2 digits are alpha
        String rgb = hex.substring(0, 6); // First 6 digits are RGB
        hex = alpha + rgb; // Reorder to ARGB
      }

      return Color(int.parse(hex, radix: 16));
    } catch (e) {
      debugPrint('❌ Error parsing color "$colorString": $e');
      return null;
    }
  }
}

/// 🎨 Empty view styles
enum EmptyViewStyle {
  startup,
  space,
  enterprise,
}

/// 📭 Empty types
enum EmptyType {
  general,
  cart,
  search,
  favorites,
  wishlist,
  products,
  orders,
  notifications,
  messages,
  history,
  reviews,
  addresses,
  payments,
}

/// 📱 Empty view status
enum EmptyViewStatus {
  initial,
  loading,
  showingEmpty,
  hidden,
}
