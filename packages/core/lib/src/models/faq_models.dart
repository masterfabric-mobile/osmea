import 'package:flutter/material.dart';

/// ❓ **OSMEA FAQ Models**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/core
///
/// Model structures for FAQ view system
///
/// {@category Models}
/// {@subCategory FAQModels}

/// ❓ FAQ item model
class FAQItem {
  /// Question text
  final String question;

  /// Answer text (can be HTML)
  final String answer;

  /// Whether this item is expanded by default
  final bool expandedByDefault;

  /// Category/tag for grouping
  final String? category;

  const FAQItem({
    required this.question,
    required this.answer,
    this.expandedByDefault = false,
    this.category,
  });

  /// Create FAQItem from JSON
  factory FAQItem.fromJson(Map<String, dynamic> json) {
    return FAQItem(
      question: json['question'] as String,
      answer: json['answer'] as String,
      expandedByDefault: json['expanded_by_default'] as bool? ?? false,
      category: json['category'] as String?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'answer': answer,
      'expanded_by_default': expandedByDefault,
      'category': category,
    };
  }
}

/// 📄 FAQ page model
class FAQPageModel {
  /// FAQ page title
  final String title;

  /// FAQ page description/subtitle
  final String? description;

  /// List of FAQ items
  final List<FAQItem> items;

  /// Background color
  final String? backgroundColor;

  /// Text color
  final String? textColor;

  /// Primary/accent color
  final String? primaryColor;

  /// FAQ style
  final FAQStyle style;

  /// Whether to allow multiple items expanded at once
  final bool allowMultipleExpanded;

  /// Whether to show search bar
  final bool showSearchBar;

  /// Whether to show categories
  final bool showCategories;

  const FAQPageModel({
    required this.title,
    this.description,
    required this.items,
    this.backgroundColor,
    this.textColor,
    this.primaryColor,
    this.style = FAQStyle.startup,
    this.allowMultipleExpanded = true,
    this.showSearchBar = false,
    this.showCategories = false,
  });

  /// Create FAQPageModel from JSON
  factory FAQPageModel.fromJson(Map<String, dynamic> json) {
    final itemsList = json['items'] as List<dynamic>? ?? [];
    final items = itemsList
        .map((item) => FAQItem.fromJson(item as Map<String, dynamic>))
        .toList();

    return FAQPageModel(
      title: json['title'] as String,
      description: json['description'] as String?,
      items: items,
      backgroundColor: json['background_color'] as String?,
      textColor: json['text_color'] as String?,
      primaryColor: json['primary_color'] as String?,
      style: FAQStyle.values.firstWhere(
        (s) => s.name == (json['style'] as String? ?? 'startup'),
        orElse: () => FAQStyle.startup,
      ),
      allowMultipleExpanded:
          json['allow_multiple_expanded'] as bool? ?? true,
      showSearchBar: json['show_search_bar'] as bool? ?? false,
      showCategories: json['show_categories'] as bool? ?? false,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'items': items.map((item) => item.toJson()).toList(),
      'background_color': backgroundColor,
      'text_color': textColor,
      'primary_color': primaryColor,
      'style': style.name,
      'allow_multiple_expanded': allowMultipleExpanded,
      'show_search_bar': showSearchBar,
      'show_categories': showCategories,
    };
  }

  /// Get background color as Color
  Color? getBackgroundColor() {
    if (backgroundColor == null) return null;
    return _parseColor(backgroundColor!);
  }

  /// Get text color as Color
  Color? getTextColor() {
    if (textColor == null) return null;
    return _parseColor(textColor!);
  }

  /// Get primary color as Color
  Color? getPrimaryColor() {
    if (primaryColor == null) return null;
    return _parseColor(primaryColor!);
  }

  /// Parse color string to Color
  Color _parseColor(String colorString) {
    try {
      // Remove # if present
      String hex = colorString.replaceAll('#', '');

      // Handle 6 digit hex
      if (hex.length == 6) {
        return Color(int.parse('FF$hex', radix: 16));
      }

      // Handle 8 digit hex (with alpha)
      if (hex.length == 8) {
        return Color(int.parse(hex, radix: 16));
      }

      // Fallback to black
      return const Color(0xFF000000);
    } catch (e) {
      return const Color(0xFF000000);
    }
  }
}

/// 🎨 FAQ view style
enum FAQStyle {
  /// Startup style - modern and clean
  startup,

  /// Space style - minimalist with lots of whitespace
  space,

  /// Enterprise style - professional and structured
  enterprise,
}

/// 📋 FAQ configuration model
class FAQConfigModel {
  /// Map of FAQ pages by type
  final Map<String, FAQPageModel> faqPages;

  const FAQConfigModel({
    required this.faqPages,
  });

  /// Create FAQConfigModel from JSON
  factory FAQConfigModel.fromJson(Map<String, dynamic> json) {
    final pages = <String, FAQPageModel>{};

    if (json['faq_pages'] is Map) {
      final pagesMap = json['faq_pages'] as Map<String, dynamic>;
      pagesMap.forEach((key, value) {
        if (value is Map<String, dynamic>) {
          pages[key] = FAQPageModel.fromJson(value);
        }
      });
    }

    return FAQConfigModel(faqPages: pages);
  }

  /// Get FAQ page by type
  FAQPageModel? getFAQPage(String type) {
    return faqPages[type];
  }
}
