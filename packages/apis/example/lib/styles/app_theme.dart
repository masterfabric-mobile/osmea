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
      colorScheme: _modernPurpleScheme,
      fontFamily: 'Inter',

      // Card theme with subtle styling
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: _modernPurpleScheme.surface,
      ),

      // Modern button styling with better contrast
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(_modernPurpleScheme.primary),
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
        fillColor: _modernPurpleScheme.surfaceContainerLow,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: _modernPurpleScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: _modernPurpleScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              BorderSide(color: _modernPurpleScheme.primary, width: 1.5),
        ),
        labelStyle: TextStyle(color: _modernPurpleScheme.onSurfaceVariant),
      ),

      // App bar
      appBarTheme: AppBarTheme(
        backgroundColor: _modernPurpleScheme.surface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: _modernPurpleScheme.onSurface,
        ),
      ),

      // Text theme
      textTheme: TextTheme(
        bodyLarge:
            TextStyle(fontSize: 16, color: _modernPurpleScheme.onSurface),
        bodyMedium:
            TextStyle(fontSize: 14, color: _modernPurpleScheme.onSurface),
        labelLarge: TextStyle(fontSize: 14, color: _modernPurpleScheme.primary),
      ),

      dividerTheme: DividerThemeData(
        color: _modernPurpleScheme.outlineVariant,
        thickness: 1,
      ),

      // API-specific styling
      extensions: [
        ApiExplorerThemeExtension(
          methodGet: const Color(0xFF43A047), // More modern green
          methodPost: const Color(0xFF8E24AA), // Vibrant purple
          methodPut: const Color(0xFFFB8C00), // Warm orange
          methodDelete: const Color(0xFFE53935), // Vivid red
          methodPatch: const Color(0xFF546E7A), // Cool blue-gray
          codeBackground:
              const Color(0xFF18181B), // Darker, more modern code bg
          codeText: const Color(0xFFF8F9FA), // Crisp white text
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

  /// Modern Purple dark scheme with contemporary color combinations
  static final ColorScheme _modernPurpleScheme = ColorScheme(
    // Primary - More vibrant and modern purple
    primary: const Color(0xFFA855F7), // Vibrant purple
    onPrimary: Colors.white,
    primaryContainer: const Color(0xFF7E22CE), // Deeper purple for containers
    onPrimaryContainer: Colors.white,

    // Secondary - Complementary color
    secondary: const Color(0xFF9333EA), // Secondary purple tone
    onSecondary: Colors.white,
    secondaryContainer:
        const Color(0xFF581C87), // Deep purple for secondary containers
    onSecondaryContainer: Colors.white,

    // Background and surface colors
    background: const Color(0xFF131313), // Nearly black background
    onBackground: const Color(0xFFF9FAFB), // Off-white for text
    surface: const Color(0xFF1C1C1E), // Slightly lighter surface
    onSurface: const Color(0xFFF3F4F6), // Light gray for text

    // Surface container variants with modern gray tones
    surfaceContainerHigh: const Color(0xFF2D2D2F),
    surfaceContainerLow: const Color(0xFF202023),
    surfaceContainerLowest: const Color(0xFF18181B),
    surfaceContainerHighest: const Color(0xFF343438),
    surfaceDim: const Color(0xFF131315), // Dimmed surface

    // Variant colors
    surfaceVariant: const Color(0xFF232326), // Subtle variant
    onSurfaceVariant: const Color(0xFFD1D5DB), // Lighter gray for variant text

    // Error colors with better visibility
    error: const Color(0xFFFF4C6A), // Vibrant pink for errors
    onError: Colors.white,
    errorContainer: const Color(0xFFBF2652), // Deeper error color
    onErrorContainer: Colors.white,

    // Outline colors
    outline: const Color(0xFF525257), // Medium gray for outlines
    outlineVariant: const Color(0xFF38383C), // Darker subtle outlines

    // Scrim and other colors
    scrim: const Color(0xAA000000),
    shadow: const Color(0xFF000000),
    inverseSurface: const Color(0xFFE5E7EB),
    onInverseSurface: const Color(0xFF111111),
    inversePrimary: const Color(0xFF7E22CE),

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
