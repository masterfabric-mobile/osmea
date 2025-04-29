import 'package:flutter/material.dart';

/// Style definition for HTTP methods
class MethodStyle {
  final Color textColor;
  final Color backgroundColor;
  final Color borderColor;
  final IconData iconData;

  const MethodStyle({
    required this.textColor,
    required this.backgroundColor,
    required this.borderColor,
    required this.iconData,
  });
}

/// Modern theme configuration for the API Explorer app
class AppTheme {
  /// Returns the app's theme configuration
  static ThemeData getTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: _lightPurpleScheme,
      fontFamily: 'Inter',

      // Card theme with subtle styling
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: _lightPurpleScheme.surface,
      ),

      // Modern button styling with better contrast
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(_lightPurpleScheme.primary),
          foregroundColor: const WidgetStatePropertyAll(Colors.white),
          elevation: const WidgetStatePropertyAll(0),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ),

      // Input styling
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _lightPurpleScheme.surfaceVariant.withValues(alpha: 180),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: _lightPurpleScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: _lightPurpleScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              BorderSide(color: _lightPurpleScheme.primary, width: 1.5),
        ),
        labelStyle: TextStyle(color: _lightPurpleScheme.onSurfaceVariant),
      ),

      // App bar
      appBarTheme: AppBarTheme(
        backgroundColor: _lightPurpleScheme.primary,
        foregroundColor: _lightPurpleScheme.onPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: _lightPurpleScheme.onPrimary,
        ),
      ),

      // Text theme
      textTheme: TextTheme(
        bodyLarge: TextStyle(fontSize: 16, color: _lightPurpleScheme.onSurface),
        bodyMedium: TextStyle(fontSize: 14, color: _lightPurpleScheme.onSurface),
        labelLarge: TextStyle(fontSize: 14, color: _lightPurpleScheme.primary),
      ),

      dividerTheme: DividerThemeData(
        color: _lightPurpleScheme.outlineVariant,
        thickness: 1,
      ),

      // API-specific styling
      extensions: [
        ApiExplorerThemeExtension(
          methodGet: const Color(0xFF43A047), // Green
          methodPost: const Color(0xFF8E24AA), // Purple
          methodPut: const Color(0xFFFB8C00), // Orange
          methodDelete: const Color(0xFFE53935), // Red
          methodPatch: const Color(0xFF546E7A), // Blue-gray
          codeBackground: const Color(0xFFF8F9FC), // Light background for code
          codeText: const Color(0xFF121212), // Dark text for code
          accentPurple: const Color(0xFFB39DDB), // Light purple accent
        ),
      ],
    );
  }

  /// Returns style information for different HTTP methods
  static MethodStyle getMethodStyle(String method, BuildContext context) {
    final theme = Theme.of(context);
    final apiTheme = theme.extension<ApiExplorerThemeExtension>();

    Color methodColor;
    IconData methodIcon;

    switch (method.toUpperCase()) {
      case 'GET':
        methodColor =
            apiTheme?.methodGet ?? const Color(0xFF4CAF50); // Brighter green
        methodIcon = Icons.download_rounded;
        break;
      case 'POST':
        methodColor =
            apiTheme?.methodPost ?? const Color(0xFFAB47BC); // Brighter purple
        methodIcon = Icons.add_rounded;
        break;
      case 'PUT':
        methodColor =
            apiTheme?.methodPut ?? const Color(0xFFFFA726); // Brighter orange
        methodIcon = Icons.edit_rounded;
        break;
      case 'DELETE':
        methodColor =
            apiTheme?.methodDelete ?? const Color(0xFFF44336); // Brighter red
        methodIcon = Icons.delete_outlined;
        break;
      case 'PATCH':
        methodColor = apiTheme?.methodPatch ??
            const Color(0xFF78909C); // Brighter blue-grey
        methodIcon = Icons.build_rounded;
        break;
      default:
        methodColor = Colors.grey;
        methodIcon = Icons.api_rounded;
    }

    return MethodStyle(
      textColor: Colors.black, // Changed to black text
      backgroundColor: methodColor,
      borderColor: methodColor.withValues(alpha: 26),
      iconData: methodIcon,
    );
  }

  /// Modern Purple light scheme with contemporary color combinations
  static final ColorScheme _lightPurpleScheme = ColorScheme.light(
    // Primary - Vibrant purple for light mode
    primary: const Color(0xFF8E24AA),    // Purple 600
    onPrimary: Colors.white,
    primaryContainer: const Color(0xFFE1BEE7), // Light purple container
    onPrimaryContainer: const Color(0xFF4A148C), // Deep purple text
    
    // Secondary - Complementary color
    secondary: const Color(0xFF7B1FA2),   // Purple 700
    onSecondary: Colors.white,
    secondaryContainer: const Color(0xFFF3E5F5), // Very light purple container
    onSecondaryContainer: const Color(0xFF4A148C), // Deep purple text
    
    // Surface colors with light backgrounds
    background: const Color(0xFFF8F9FA), // Very light gray background
    onBackground: const Color(0xFF121212), // Near-black text
    surface: Colors.white,
    onSurface: const Color(0xFF121212), // Near-black text
    surfaceVariant: const Color(0xFFF5F0FA), // Very light purple-tinted surface
    onSurfaceVariant: const Color(0xFF4D4D4D), // Dark gray text
    
    // Error colors 
    error: const Color(0xFFD32F2F), // Red 700
    onError: Colors.white,
    errorContainer: const Color(0xFFFFEBEE), // Light red background
    onErrorContainer: const Color(0xFFB71C1C), // Dark red text
    
    // Outline colors
    outline: const Color(0xFFBDBDBD), // Medium gray for outlines
    outlineVariant: const Color(0xFFE0E0E0), // Light gray for subtle outlines
    
    // Other colors
    scrim: const Color(0x66000000),
    shadow: const Color(0x66000000),
    inverseSurface: const Color(0xFF121212),
    onInverseSurface: Colors.white,
    inversePrimary: const Color(0xFFD1C4E9),
    
    brightness: Brightness.light,
  );
}

/// Extension to the theme for API-specific visual elements
class ApiExplorerThemeExtension extends ThemeExtension<ApiExplorerThemeExtension> {
  /// API Method colors
  final Color methodGet;
  final Color methodPost;
  final Color methodPut;
  final Color methodDelete;
  final Color methodPatch;

  /// Code highlighting colors
  final Color codeBackground;
  final Color codeText;

  /// Additional color for accents
  final Color accentPurple;

  ApiExplorerThemeExtension({
    required this.methodGet,
    required this.methodPost,
    required this.methodPut,
    required this.methodDelete,
    required this.methodPatch,
    required this.codeBackground,
    required this.codeText,
    this.accentPurple = const Color(0xFFB39DDB),
  });

  @override
  ApiExplorerThemeExtension copyWith({
    Color? methodGet,
    Color? methodPost,
    Color? methodPut,
    Color? methodDelete,
    Color? methodPatch,
    Color? codeBackground,
    Color? codeText,
    Color? accentPurple,
  }) {
    return ApiExplorerThemeExtension(
      methodGet: methodGet ?? this.methodGet,
      methodPost: methodPost ?? this.methodPost,
      methodPut: methodPut ?? this.methodPut,
      methodDelete: methodDelete ?? this.methodDelete,
      methodPatch: methodPatch ?? this.methodPatch,
      codeBackground: codeBackground ?? this.codeBackground,
      codeText: codeText ?? this.codeText,
      accentPurple: accentPurple ?? this.accentPurple,
    );
  }

  @override
  ApiExplorerThemeExtension lerp(
      ThemeExtension<ApiExplorerThemeExtension>? other, double t) {
    if (other is! ApiExplorerThemeExtension) {
      return this;
    }
    return ApiExplorerThemeExtension(
      methodGet: Color.lerp(methodGet, other.methodGet, t)!,
      methodPost: Color.lerp(methodPost, other.methodPost, t)!,
      methodPut: Color.lerp(methodPut, other.methodPut, t)!,
      methodDelete: Color.lerp(methodDelete, other.methodDelete, t)!,
      methodPatch: Color.lerp(methodPatch, other.methodPatch, t)!,
      codeBackground: Color.lerp(codeBackground, other.codeBackground, t)!,
      codeText: Color.lerp(codeText, other.codeText, t)!,
      accentPurple: Color.lerp(accentPurple, other.accentPurple, t)!,
    );
  }
}
