import 'package:flutter/material.dart';

/// 🚀 **OSMEA Splash Models**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/core
///
/// Model structures to be used in the splash system
///
/// {@category Models}
/// {@subCategory SplashModels}

/// 📱 Splash configuration model
class SplashConfigModel {
  /// Duration in seconds for the splash screen
  final int durationSeconds;

  /// Logo URL or asset path
  final String logoUrl;

  /// Logo width
  final double logoWidth;

  /// Logo height
  final double logoHeight;

  /// Whether to show loading indicator
  final bool showLoadingIndicator;

  /// Loading indicator size
  final int loadingIndicatorSize;

  /// Loading text to display
  final String loadingText;

  /// Whether to show app version
  final bool showAppVersion;

  /// Whether to show copyright text
  final bool showCopyright;

  /// Copyright text to display
  final String copyrightText;

  /// Primary color hex code
  final String? primaryColor;

  /// Loading indicator color hex code
  final String? loadingIndicatorColor;

  /// Text color hex code
  final String? textColor;

  /// Background color hex code
  final String? backgroundColor;

  /// App name to display
  final String? appName;

  /// App version to display
  final String? appVersion;

  /// Number of taps required for dev mode
  final int devModeTapCount;

  /// Whether dev mode is enabled
  final bool devModeEnabled;

  /// Whether to auto-navigate on completion
  final bool autoNavigate;

  /// Animation duration in milliseconds
  final int animationDuration;

  /// Splash style (startup, space, enterprise)
  final SplashStyle style;

  const SplashConfigModel({
    required this.durationSeconds,
    required this.logoUrl,
    required this.logoWidth,
    required this.logoHeight,
    required this.showLoadingIndicator,
    required this.loadingIndicatorSize,
    required this.loadingText,
    required this.showAppVersion,
    required this.showCopyright,
    required this.copyrightText,
    required this.devModeTapCount,
    required this.devModeEnabled,
    required this.autoNavigate,
    required this.animationDuration,
    this.style = SplashStyle.startup,
    this.primaryColor,
    this.loadingIndicatorColor,
    this.textColor,
    this.backgroundColor,
    this.appName,
    this.appVersion,
  });

  /// Create SplashConfigModel from JSON
  factory SplashConfigModel.fromJson(Map<String, dynamic> json) {
    return SplashConfigModel(
      durationSeconds: json['duration_seconds'] as int? ?? 3,
      logoUrl: json['logo_url'] as String? ?? '',
      logoWidth: (json['logo_width'] as num?)?.toDouble() ?? 112.0,
      logoHeight: (json['logo_height'] as num?)?.toDouble() ?? 112.0,
      showLoadingIndicator: json['show_loading_indicator'] as bool? ?? true,
      loadingIndicatorSize: json['loading_indicator_size'] as int? ?? 32,
      loadingText: json['loading_text'] as String? ?? 'Loading...',
      showAppVersion: json['show_app_version'] as bool? ?? false,
      showCopyright: json['show_copyright'] as bool? ?? false,
      copyrightText: json['copyright_text'] as String? ?? '© 2025 OSMEA Team',
      devModeTapCount: json['dev_mode_tap_count'] as int? ?? 5,
      devModeEnabled: json['dev_mode_enabled'] as bool? ?? false,
      autoNavigate: json['auto_navigate'] as bool? ?? true,
      animationDuration: json['animation_duration'] as int? ?? 300,
      style: SplashStyle.values.firstWhere(
        (style) => style.name == (json['style'] as String? ?? 'startup'),
        orElse: () => SplashStyle.startup,
      ),
      primaryColor: json['primary_color'] as String?,
      loadingIndicatorColor: json['loading_indicator_color'] as String?,
      textColor: json['text_color'] as String?,
      backgroundColor: json['background_color'] as String?,
      appName: json['app_name'] as String?,
      appVersion: json['app_version'] as String?,
    );
  }

  /// Convert SplashConfigModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'duration_seconds': durationSeconds,
      'logo_url': logoUrl,
      'logo_width': logoWidth,
      'logo_height': logoHeight,
      'show_loading_indicator': showLoadingIndicator,
      'loading_indicator_size': loadingIndicatorSize,
      'loading_text': loadingText,
      'show_app_version': showAppVersion,
      'show_copyright': showCopyright,
      'copyright_text': copyrightText,
      'dev_mode_tap_count': devModeTapCount,
      'dev_mode_enabled': devModeEnabled,
      'auto_navigate': autoNavigate,
      'animation_duration': animationDuration,
      'style': style.name,
      'primary_color': primaryColor,
      'loading_indicator_color': loadingIndicatorColor,
      'text_color': textColor,
      'background_color': backgroundColor,
      'app_name': appName,
      'app_version': appVersion,
    };
  }

  /// Convert primary color string to Color
  Color? getPrimaryColor() {
    if (primaryColor == null) return null;
    return _parseColor(primaryColor!);
  }

  /// Convert loading indicator color string to Color
  Color? getLoadingIndicatorColor() {
    if (loadingIndicatorColor != null) {
      return _parseColor(loadingIndicatorColor!);
    }
    // Fallback to primary color if loading indicator color is not set
    return getPrimaryColor();
  }

  /// Convert text color string to Color
  Color? getTextColor() {
    if (textColor == null) return null;
    return _parseColor(textColor!);
  }

  /// Convert background color string to Color
  Color? getBackgroundColor() {
    if (backgroundColor == null) return null;
    return _parseColor(backgroundColor!);
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
    return 'SplashConfigModel(durationSeconds: $durationSeconds, appName: $appName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SplashConfigModel &&
        other.durationSeconds == durationSeconds &&
        other.logoUrl == logoUrl &&
        other.logoWidth == logoWidth &&
        other.logoHeight == logoHeight &&
        other.showLoadingIndicator == showLoadingIndicator &&
        other.loadingIndicatorSize == loadingIndicatorSize &&
        other.loadingText == loadingText &&
        other.showAppVersion == showAppVersion &&
        other.showCopyright == showCopyright &&
        other.copyrightText == copyrightText &&
        other.primaryColor == primaryColor &&
        other.loadingIndicatorColor == loadingIndicatorColor &&
        other.textColor == textColor &&
        other.backgroundColor == backgroundColor &&
        other.appName == appName &&
        other.appVersion == appVersion &&
        other.devModeTapCount == devModeTapCount &&
        other.devModeEnabled == devModeEnabled &&
        other.autoNavigate == autoNavigate &&
        other.animationDuration == animationDuration &&
        other.style == style;
  }

  @override
  int get hashCode {
    return durationSeconds.hashCode ^
        logoUrl.hashCode ^
        logoWidth.hashCode ^
        logoHeight.hashCode ^
        showLoadingIndicator.hashCode ^
        loadingIndicatorSize.hashCode ^
        loadingText.hashCode ^
        showAppVersion.hashCode ^
        showCopyright.hashCode ^
        copyrightText.hashCode ^
        primaryColor.hashCode ^
        loadingIndicatorColor.hashCode ^
        textColor.hashCode ^
        backgroundColor.hashCode ^
        appName.hashCode ^
        appVersion.hashCode ^
        devModeTapCount.hashCode ^
        devModeEnabled.hashCode ^
        autoNavigate.hashCode ^
        animationDuration.hashCode ^
        style.hashCode;
  }
}

/// 🎨 Splash style options
enum SplashStyle {
  /// Basic startup style - Logo centered, loading indicator below
  startup,

  /// Ultra-minimalist space style - Pure text-based design
  space,

  /// Professional enterprise style - Corporate card-based design
  enterprise,
}

/// 📱 Splash state
enum SplashFlowState {
  /// Initial state
  initial,

  /// Loading configuration
  loading,

  /// Ready to display
  ready,

  /// Error occurred
  error,

  /// Completed and ready to navigate
  completed,
}

/// 🎯 Splash actions
enum SplashAction {
  /// Initialize splash
  initialize,

  /// Retry initialization
  retry,

  /// Logo tapped (dev mode)
  logoTap,

  /// Navigate to home
  navigateHome,

  /// Navigate to onboarding
  navigateOnboarding,

  /// Force complete
  complete,
}
