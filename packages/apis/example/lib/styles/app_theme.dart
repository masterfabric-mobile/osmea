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
      colorScheme: _purpleDarkScheme,
      fontFamily: 'Inter',

      // Card theme with subtle styling
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: _purpleDarkScheme.surface,
      ),

      // Modern button styling with better contrast
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(_purpleDarkScheme.primary),
          foregroundColor: const WidgetStatePropertyAll(
              Colors.white), // White text for better contrast
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
        fillColor: _purpleDarkScheme.surfaceContainerLow,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: _purpleDarkScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: _purpleDarkScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: _purpleDarkScheme.primary, width: 1.5),
        ),
        labelStyle: TextStyle(color: _purpleDarkScheme.onSurfaceVariant),
      ),

      // App bar
      appBarTheme: AppBarTheme(
        backgroundColor: _purpleDarkScheme.surface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: _purpleDarkScheme.onSurface,
        ),
      ),

      // Text theme
      textTheme: TextTheme(
        bodyLarge: TextStyle(fontSize: 16, color: _purpleDarkScheme.onSurface),
        bodyMedium: TextStyle(fontSize: 14, color: _purpleDarkScheme.onSurface),
        labelLarge: TextStyle(fontSize: 14, color: _purpleDarkScheme.primary),
      ),

      dividerTheme: DividerThemeData(
        color: _purpleDarkScheme.outlineVariant,
        thickness: 1,
      ),

      // API-specific styling
      extensions: [
        ApiExplorerThemeExtension(
          methodGet: const Color(0xFF66BB6A), // Green 400
          methodPost: const Color(0xFF9C27B0), // Purple 500
          methodPut: const Color(0xFFFFB74D), // Orange 300
          methodDelete: const Color(0xFFEF5350), // Red 400
          methodPatch: const Color(0xFF78909C), // Blue Grey 400
          codeBackground: const Color(0xFF1A1A1A),
          codeText: const Color(0xFFF5F5F5),
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

  /// Purple dark scheme
  static final ColorScheme _purpleDarkScheme = ColorScheme(
    // Primary - Different Purple tone
    primary:
        const Color.fromARGB(255, 212, 59, 254), // Purple 600 - rich purple
    onPrimary: Colors.white,
    primaryContainer:
        const Color.fromARGB(255, 85, 22, 125), // Purple 800 - deeper purple
    onPrimaryContainer: Colors.white,

    // Secondary - Complementary color
    secondary:
        const Color.fromARGB(255, 145, 57, 161), // Purple 400 - lighter purple
    onSecondary: Colors.white,
    secondaryContainer:
        const Color(0xFF4A148C), // Purple 900 - very deep purple
    onSecondaryContainer: Colors.white, // Near-white for text
    surface: const Color(0xFF1E1E1E), // Slightly lighter than background
    onSurface: const Color(0xFFEEEEEE), // Near-white for text
    surfaceContainerHigh: const Color(0xFF2C2C2C),
    surfaceContainerLow: const Color(0xFF1F1F1F),
    surfaceContainerLowest: const Color(0xFF1A1A1A),
    surfaceContainerHighest: const Color(0xFF323232),
    onSurfaceVariant: const Color(0xFFBDBDBD), // Light gray for secondary text

    // Error colors
    error: const Color(0xFFE57373), // Red 300 - lighter for visibility
    onError: Colors.black,
    errorContainer: const Color(0xFFD32F2F), // Red 700
    onErrorContainer: Colors.white,

    // Outline colors
    outline: const Color(0xFF484848), // Medium dark gray
    outlineVariant: const Color(0xFF2E2E2E), // Darker gray for subtle outlines

    brightness: Brightness.dark,
  );
}

/// Extension to the theme for API-specific visual elements
class ApiExplorerThemeExtension
    extends ThemeExtension<ApiExplorerThemeExtension> {
  /// API Method colors
  final Color methodGet;
  final Color methodPost;
  final Color methodPut;
  final Color methodDelete;
  final Color methodPatch;

  /// Code highlighting colors
  final Color codeBackground;
  final Color codeText;

  ApiExplorerThemeExtension({
    required this.methodGet,
    required this.methodPost,
    required this.methodPut,
    required this.methodDelete,
    required this.methodPatch,
    required this.codeBackground,
    required this.codeText,
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
  }) {
    return ApiExplorerThemeExtension(
      methodGet: methodGet ?? this.methodGet,
      methodPost: methodPost ?? this.methodPost,
      methodPut: methodPut ?? this.methodPut,
      methodDelete: methodDelete ?? this.methodDelete,
      methodPatch: methodPatch ?? this.methodPatch,
      codeBackground: codeBackground ?? this.codeBackground,
      codeText: codeText ?? this.codeText,
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
    );
  }
}
