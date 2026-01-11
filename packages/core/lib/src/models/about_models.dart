import 'package:flutter/material.dart';

/// 📄 **OSMEA About Models**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/core
///
/// Model structures for about view system
///
/// {@category Models}
/// {@subCategory AboutModels}

/// 📄 About page model
class AboutPageModel {
  /// About page title
  final String title;

  /// About page description/subtitle
  final String? description;

  /// HTML content to display
  final String? htmlContent;

  /// URL to display in web view (if provided, takes priority over htmlContent)
  final String? url;

  /// Version information
  final String? version;

  /// Build number
  final String? buildNumber;

  /// App name
  final String? appName;

  /// Company/Organization name
  final String? companyName;

  /// Copyright text
  final String? copyright;

  /// Background color
  final String? backgroundColor;

  /// Text color
  final String? textColor;

  /// Primary/accent color
  final String? primaryColor;

  /// About style
  final AboutStyle style;

  /// Whether to show version info
  final bool showVersion;

  /// Whether to show company info
  final bool showCompanyInfo;

  /// Whether to enable fullscreen web view for URLs
  final bool enableFullscreenWebView;

  const AboutPageModel({
    required this.title,
    this.description,
    this.htmlContent,
    this.url,
    this.version,
    this.buildNumber,
    this.appName,
    this.companyName,
    this.copyright,
    this.backgroundColor,
    this.textColor,
    this.primaryColor,
    this.style = AboutStyle.startup,
    this.showVersion = true,
    this.showCompanyInfo = true,
    this.enableFullscreenWebView = true,
  });

  /// Create AboutPageModel from JSON
  factory AboutPageModel.fromJson(Map<String, dynamic> json) {
    return AboutPageModel(
      title: json['title'] as String,
      description: json['description'] as String?,
      htmlContent: json['html_content'] as String?,
      url: json['url'] as String?,
      version: json['version'] as String?,
      buildNumber: json['build_number'] as String?,
      appName: json['app_name'] as String?,
      companyName: json['company_name'] as String?,
      copyright: json['copyright'] as String?,
      backgroundColor: json['background_color'] as String?,
      textColor: json['text_color'] as String?,
      primaryColor: json['primary_color'] as String?,
      style: AboutStyle.values.firstWhere(
        (s) => s.name == (json['style'] as String? ?? 'startup'),
        orElse: () => AboutStyle.startup,
      ),
      showVersion: json['show_version'] as bool? ?? true,
      showCompanyInfo: json['show_company_info'] as bool? ?? true,
      enableFullscreenWebView:
          json['enable_fullscreen_web_view'] as bool? ?? true,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'html_content': htmlContent,
      'url': url,
      'version': version,
      'build_number': buildNumber,
      'app_name': appName,
      'company_name': companyName,
      'copyright': copyright,
      'background_color': backgroundColor,
      'text_color': textColor,
      'primary_color': primaryColor,
      'style': style.name,
      'show_version': showVersion,
      'show_company_info': showCompanyInfo,
      'enable_fullscreen_web_view': enableFullscreenWebView,
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

  /// Check if URL is provided
  bool get hasUrl => url != null && url!.isNotEmpty;

  /// Check if HTML content is provided
  bool get hasHtmlContent => htmlContent != null && htmlContent!.isNotEmpty;
}

/// 🎨 About view style
enum AboutStyle {
  /// Startup style - modern and clean
  startup,

  /// Space style - minimalist with lots of whitespace
  space,

  /// Enterprise style - professional and structured
  enterprise,
}

/// 📋 About configuration model
class AboutConfigModel {
  /// Map of about pages by type
  final Map<String, AboutPageModel> aboutPages;

  const AboutConfigModel({
    required this.aboutPages,
  });

  /// Create AboutConfigModel from JSON
  factory AboutConfigModel.fromJson(Map<String, dynamic> json) {
    final pages = <String, AboutPageModel>{};

    if (json['about_pages'] is Map) {
      final pagesMap = json['about_pages'] as Map<String, dynamic>;
      pagesMap.forEach((key, value) {
        if (value is Map<String, dynamic>) {
          pages[key] = AboutPageModel.fromJson(value);
        }
      });
    }

    return AboutConfigModel(aboutPages: pages);
  }

  /// Get about page by type
  AboutPageModel? getAboutPage(String type) {
    return aboutPages[type];
  }
}
