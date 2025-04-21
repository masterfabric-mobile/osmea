import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  // Modern color palette with better contrast
  static const _primaryLight = Color(0xFF0055D3);
  static const _primaryDark = Color(0xFF4580FF);

  static const _successLight = Color(0xFF09925E);
  static const _successDark = Color(0xFF30CF8D);

  static const _warningLight = Color(0xFFFF9500);
  static const _warningDark = Color(0xFFFFB340);

  static const _errorLight = Color(0xFFE53935);
  static const _errorDark = Color(0xFFFF6B6B);

  static const _neutralLight = Color(0xFF42464A);
  static const _neutralDark = Color(0xFFAFB4BB);

  // Method colors mapping
  static Color getMethodColor(String method, bool isDark) {
    switch (method.toUpperCase()) {
      case 'GET':
        return isDark ? _successDark : _successLight;
      case 'POST':
        return isDark ? _primaryDark : _primaryLight;
      case 'PUT':
        return isDark ? _warningDark : _warningLight;
      case 'DELETE':
        return isDark ? _errorDark : _errorLight;
      default:
        return isDark ? _neutralDark : _neutralLight;
    }
  }

  static ThemeData getTheme([bool darkMode = false]) {
    final brightness = darkMode ? Brightness.dark : Brightness.light;

    // Create color scheme based on brightness
    final colorScheme = brightness == Brightness.dark
        ? const ColorScheme.dark(
            primary: _primaryDark,
            secondary: _successDark,
            error: _errorDark,
            surface: Color(0xFF1C1C1C),
            onPrimary: Colors.white,
            onSecondary: Colors.white,
            onSurface: Colors.white,
            onError: Colors.white,
          )
        : const ColorScheme.light(
            primary: _primaryLight,
            secondary: _successLight,
            error: _errorLight,
            surface: Colors.white,
            onPrimary: Colors.white,
            onSecondary: Colors.white,
            onSurface: Color(0xFF121212),
            onError: Colors.white,
          );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: 'Inter',

      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: brightness == Brightness.dark
              ? Brightness.light
              : Brightness.dark,
        ),
      ),

      // Card Theme with modern rounded corners
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
      ),

      // Elevated Button - Modern style
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      // Input decoration - Clean modern look
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: brightness == Brightness.dark
            ? const Color(0xFF2A2A2A)
            : const Color(0xFFF5F5F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary),
        ),
        contentPadding: const EdgeInsets.all(16),
      ),

      // Chip theme for HTTP method selectors
      chipTheme: ChipThemeData(
        backgroundColor: brightness == Brightness.dark
            ? const Color(0xFF2A2A2A)
            : const Color(0xFFF5F5F5),
        selectedColor: colorScheme.primary.withValues(alpha: 0.2),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        labelStyle: TextStyle(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w500,
        ),
        secondaryLabelStyle: TextStyle(
          color: colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),

      // Text Theme - Modern typography
      textTheme: TextTheme(
        titleLarge: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 22,
          color: colorScheme.onSurface,
        ),
        titleMedium: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: colorScheme.onSurface,
        ),
        bodyLarge: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 16,
          color: colorScheme.onSurface,
        ),
        bodyMedium: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: colorScheme.onSurface,
        ),
        labelLarge: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color: colorScheme.onSurface,
        ),
      ),
    );
  }

  // HTTP Method styling - returns style based on method type
  static MethodStyle getMethodStyle(String method, BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final color = getMethodColor(method, isDark);

    return MethodStyle(
      backgroundColor: color.withValues(alpha: 0.1),
      textColor: color,
      borderColor: color,
      iconData: getMethodIcon(method),
    );
  }

  // Icons for different HTTP methods
  static IconData getMethodIcon(String method) {
    switch (method.toUpperCase()) {
      case 'GET':
        return Icons.download_rounded;
      case 'POST':
        return Icons.add_circle_outline_rounded;
      case 'PUT':
        return Icons.edit_outlined;
      case 'DELETE':
        return Icons.delete_outline_rounded;
      default:
        return Icons.http_rounded;
    }
  }
}

/// Style configuration for HTTP method chips/buttons
class MethodStyle {
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;
  final IconData iconData;

  const MethodStyle({
    required this.backgroundColor,
    required this.textColor,
    required this.borderColor,
    required this.iconData,
  });
}
