import 'package:flutter/material.dart';
import 'dart:convert';

/// 🎯 **OSMEA Onboarding Models**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/core
///
/// Model structures to be used in the onboarding system
///
/// {@category Models}
/// {@subCategory OnboardingModels}

/// 📱 Onboarding page model
class OnboardingPageModel {
  /// Page title
  final String title;

  /// Page description
  final String description;

  /// Page icon (asset path)
  final String? iconPath;

  /// Page image (asset path)
  final String? imagePath;

  /// Page image URL (network)
  final String? imageUrl;

  /// Page icon URL (network)
  final String? iconUrl;

  /// Page color
  final String? backgroundColor;

  /// Text color
  final String? textColor;

  /// Button text (for last page)
  final String? buttonText;

  /// Skip button text
  final String? skipText;

  /// Next button text
  final String? nextText;

  const OnboardingPageModel({
    required this.title,
    required this.description,
    this.iconPath,
    this.imagePath,
    this.imageUrl,
    this.iconUrl,
    this.backgroundColor,
    this.textColor,
    this.buttonText,
    this.skipText,
    this.nextText,
  });

  /// Create OnboardingPageModel from JSON
  factory OnboardingPageModel.fromJson(Map<String, dynamic> json) {
    return OnboardingPageModel(
      title: json['title'] as String,
      description: json['description'] as String,
      iconPath: json['icon_path'] as String?,
      imagePath: json['image_path'] as String?,
      imageUrl: json['image_url'] as String?,
      iconUrl: json['icon_url'] as String?,
      backgroundColor: json['background_color'] as String?,
      textColor: json['text_color'] as String?,
      buttonText: json['button_text'] as String?,
      skipText: json['skip_text'] as String?,
      nextText: json['next_text'] as String?,
    );
  }

  /// Convert OnboardingPageModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'icon_path': iconPath,
      'image_path': imagePath,
      'image_url': imageUrl,
      'icon_url': iconUrl,
      'background_color': backgroundColor,
      'text_color': textColor,
      'button_text': buttonText,
      'skip_text': skipText,
      'next_text': nextText,
    };
  }

  /// Convert color string to Color
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
      if (hex.length == 6) {
        hex = 'FF$hex'; // Add alpha value for 6-digit hex (ARGB format)
      } else if (hex.length == 8) {
        // 8-digit hex: Convert from RRGGBBAA to AARRGGBB (Flutter's ARGB format)
        String r = hex.substring(0, 2);
        String g = hex.substring(2, 4);
        String b = hex.substring(4, 6);
        String a = hex.substring(6, 8);
        hex = a + r + g + b; // Reorder to ARGB
      } else {
        return null; // Invalid hex length
      }
      return Color(int.parse(hex, radix: 16));
    } catch (e) {
      return null;
    }
  }

  @override
  String toString() {
    return 'OnboardingPageModel(title: $title, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OnboardingPageModel &&
        other.title == title &&
        other.description == description &&
        other.iconPath == iconPath &&
        other.imagePath == imagePath &&
        other.imageUrl == imageUrl &&
        other.iconUrl == iconUrl &&
        other.backgroundColor == backgroundColor &&
        other.textColor == textColor;
  }

  /// Create a copy with updated fields
  OnboardingPageModel copyWith({
    String? title,
    String? description,
    String? iconPath,
    String? imagePath,
    String? imageUrl,
    String? iconUrl,
    String? backgroundColor,
    String? textColor,
    String? buttonText,
    String? skipText,
    String? nextText,
  }) {
    return OnboardingPageModel(
      title: title ?? this.title,
      description: description ?? this.description,
      iconPath: iconPath ?? this.iconPath,
      imagePath: imagePath ?? this.imagePath,
      imageUrl: imageUrl ?? this.imageUrl,
      iconUrl: iconUrl ?? this.iconUrl,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      buttonText: buttonText ?? this.buttonText,
      skipText: skipText ?? this.skipText,
      nextText: nextText ?? this.nextText,
    );
  }

  @override
  int get hashCode {
    return title.hashCode ^
        description.hashCode ^
        iconPath.hashCode ^
        imagePath.hashCode ^
        imageUrl.hashCode ^
        iconUrl.hashCode ^
        backgroundColor.hashCode ^
        textColor.hashCode;
  }
}

/// 🎨 Onboarding configuration model
class OnboardingConfigModel {
  /// List of onboarding pages
  final List<OnboardingPageModel> pages;

  /// Onboarding style (basic or space)
  final OnboardingStyle style;

  /// Auto advance time (seconds)
  final int? autoAdvanceSeconds;

  /// Whether to show skip button
  final bool showSkipButton;

  /// Whether to show page indicators
  final bool showPageIndicator;

  /// Animation duration (milliseconds)
  final int animationDuration;

  /// General theme color
  final String? primaryColor;

  /// Secondary theme color
  final String? secondaryColor;

  const OnboardingConfigModel({
    required this.pages,
    this.style = OnboardingStyle.basic,
    this.autoAdvanceSeconds,
    this.showSkipButton = true,
    this.showPageIndicator = true,
    this.animationDuration = 300,
    this.primaryColor,
    this.secondaryColor,
  });

  /// Create OnboardingConfigModel from JSON
  factory OnboardingConfigModel.fromJson(Map<String, dynamic> json) {
    try {
      // Pages parsing
      List<OnboardingPageModel> pagesList = [];
      final pagesData = json['pages'];

      if (pagesData is List) {
        for (var pageData in pagesData) {
          if (pageData is Map<String, dynamic>) {
            try {
              pagesList.add(OnboardingPageModel.fromJson(pageData));
            } catch (e) {
              debugPrint('❌ Failed to parse page: $e');
            }
          }
        }
      } else if (pagesData is String) {
        try {
          final decoded = jsonDecode(pagesData);
          if (decoded is List) {
            final tempJson = Map<String, dynamic>.from(json);
            tempJson['pages'] = decoded;
            return OnboardingConfigModel.fromJson(tempJson);
          }
        } catch (e) {
          debugPrint('❌ Failed to decode pages JSON string: $e');
        }
      }

      return OnboardingConfigModel(
        pages: pagesList,
        style: OnboardingStyle.values.firstWhere(
          (style) => style.name == (json['style'] as String? ?? 'basic'),
          orElse: () => OnboardingStyle.basic,
        ),
        autoAdvanceSeconds: json['auto_advance_seconds'] as int?,
        showSkipButton: json['show_skip_button'] as bool? ?? true,
        showPageIndicator: json['show_page_indicator'] as bool? ?? true,
        animationDuration: json['animation_duration'] as int? ?? 300,
        primaryColor: json['primary_color'] as String?,
        secondaryColor: json['secondary_color'] as String?,
      );
    } catch (e) {
      debugPrint('❌ Error in OnboardingConfigModel.fromJson: $e');

      // Fallback: Return with empty pages
      return OnboardingConfigModel(
        pages: [],
        style: OnboardingStyle.basic,
        showSkipButton: true,
        showPageIndicator: true,
      );
    }
  }

  /// Convert OnboardingConfigModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'pages': pages.map((page) => page.toJson()).toList(),
      'style': style.name,
      'auto_advance_seconds': autoAdvanceSeconds,
      'show_skip_button': showSkipButton,
      'show_page_indicator': showPageIndicator,
      'animation_duration': animationDuration,
      'primary_color': primaryColor,
      'secondary_color': secondaryColor,
    };
  }

  /// Convert primary color string to Color
  Color? getPrimaryColor() {
    if (primaryColor == null) return null;
    return _parseColor(primaryColor!);
  }

  /// Convert secondary color string to Color
  Color? getSecondaryColor() {
    if (secondaryColor == null) return null;
    return _parseColor(secondaryColor!);
  }

  /// Convert hex color string to Color
  Color? _parseColor(String colorString) {
    try {
      String hex = colorString.replaceAll('#', '');
      if (hex.length == 6) {
        hex = 'FF$hex'; // Add alpha value for 6-digit hex (ARGB format)
      } else if (hex.length == 8) {
        // 8-digit hex: Convert from RRGGBBAA to AARRGGBB (Flutter's ARGB format)
        String r = hex.substring(0, 2);
        String g = hex.substring(2, 4);
        String b = hex.substring(4, 6);
        String a = hex.substring(6, 8);
        hex = a + r + g + b; // Reorder to ARGB
      } else {
        return null; // Invalid hex length
      }
      return Color(int.parse(hex, radix: 16));
    } catch (e) {
      return null;
    }
  }

  /// Create a copy with updated fields
  OnboardingConfigModel copyWith({
    List<OnboardingPageModel>? pages,
    OnboardingStyle? style,
    int? autoAdvanceSeconds,
    bool? showSkipButton,
    bool? showPageIndicator,
    int? animationDuration,
    String? primaryColor,
    String? secondaryColor,
  }) {
    return OnboardingConfigModel(
      pages: pages ?? this.pages,
      style: style ?? this.style,
      autoAdvanceSeconds: autoAdvanceSeconds ?? this.autoAdvanceSeconds,
      showSkipButton: showSkipButton ?? this.showSkipButton,
      showPageIndicator: showPageIndicator ?? this.showPageIndicator,
      animationDuration: animationDuration ?? this.animationDuration,
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
    );
  }

  @override
  String toString() {
    return 'OnboardingConfigModel(pages: ${pages.length}, style: $style)';
  }
}

/// 🎨 Onboarding style options
enum OnboardingStyle {
  /// Basic style - Visual on top, text on bottom
  basic,

  /// Space style - Text over full screen visual
  space,

  /// Enterprise style - Professional card-based layout with corporate design
  enterprise,
}

/// 📱 Onboarding state
enum OnboardingFlowState {
  /// Loading
  loading,

  /// Ready
  ready,

  /// Error
  error,

  /// Completed
  completed,
}

/// 🎯 Onboarding actions
enum OnboardingAction {
  /// Next page
  next,

  /// Previous page
  previous,

  /// Skip
  skip,

  /// Finish
  finish,

  /// Go to specific page
  goToPage,
}
