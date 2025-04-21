import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// App theme provider with modern Material 3 design
class AppTheme {
  /// Gets the app theme based on the current context
  static ThemeData getTheme(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;

    // Define seed colors for our application
    const primarySeedColor = Color(0xFF0069B3); // Modern blue
    const secondarySeedColor = Color(0xFF39B54A); // Fresh green
    const tertiarySeedColor = Color(0xFFFFA400); // Warm amber

    // Create color scheme from seeds
    final colorScheme = isDark
        ? ColorScheme.dark(
            primary: primarySeedColor,
            secondary: secondarySeedColor,
            tertiary: tertiarySeedColor,
            surface: const Color(0xFF1E1E1E),
            error: const Color(0xFFEF5350),
            onPrimary: Colors.white,
            onSecondary: Colors.white,
            onTertiary: Colors.black,
            onSurface: Colors.white,
            onError: Colors.white,
            surfaceContainerHighest: const Color(0xFF2C2C2C),
            onSurfaceVariant: const Color(0xFFE1E1E1),
          )
        : ColorScheme.light(
            primary: primarySeedColor,
            secondary: secondarySeedColor,
            tertiary: tertiarySeedColor,
            surface: Colors.white,
            error: const Color(0xFFEF5350),
            onPrimary: Colors.white,
            onSecondary: Colors.white,
            onTertiary: Colors.black,
            onSurface: Colors.black,
            onError: Colors.white,
            surfaceContainerHighest: const Color(0xFFF1F3F4),
            onSurfaceVariant: const Color(0xFF4A4A4A),
          );

    // Modern typography
    final textTheme = _buildTextTheme();

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: brightness,
      textTheme: textTheme,

      // Button themes
      elevatedButtonTheme: _buildElevatedButtonTheme(colorScheme),
      textButtonTheme: _buildTextButtonTheme(colorScheme),
      outlinedButtonTheme: _buildOutlinedButtonTheme(colorScheme),

      // Input themes
      inputDecorationTheme: _buildInputDecorationTheme(colorScheme),

      // Card theme
      cardTheme: _buildCardTheme(colorScheme),

      // App bar theme
      appBarTheme: _buildAppBarTheme(colorScheme, textTheme),

      // Other component themes
      dialogTheme: _buildDialogTheme(colorScheme),
      snackBarTheme: _buildSnackBarTheme(colorScheme),
      switchTheme: _buildSwitchTheme(colorScheme),
      checkboxTheme: _buildCheckboxTheme(colorScheme),
      chipTheme: _buildChipTheme(colorScheme),
      popupMenuTheme: _buildPopupMenuTheme(colorScheme),
    );
  }

  // Text theme with modern typography
  static TextTheme _buildTextTheme() {
    return const TextTheme(
      displayLarge: TextStyle(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.25,
      ),
      displayMedium: TextStyle(
        fontSize: 45,
        fontWeight: FontWeight.w400,
      ),
      displaySmall: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w400,
      ),
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w400,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w400,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w400,
      ),
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w500,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      ),
      labelSmall: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      ),
    );
  }

  // Modern elevated button theme
  static ElevatedButtonThemeData _buildElevatedButtonTheme(ColorScheme colors) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // Modern text button theme
  static TextButtonThemeData _buildTextButtonTheme(ColorScheme colors) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: colors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // Modern outlined button theme
  static OutlinedButtonThemeData _buildOutlinedButtonTheme(ColorScheme colors) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: colors.primary,
        side: BorderSide(color: colors.primary, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // Modern input decoration theme
  static InputDecorationTheme _buildInputDecorationTheme(ColorScheme colors) {
    return InputDecorationTheme(
      filled: true,
      fillColor: colors.surfaceContainerHighest.withValues(alpha: 0.3),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: colors.outline,
          width: 1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: colors.outline.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: colors.primary,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: colors.error,
          width: 1,
        ),
      ),
      floatingLabelStyle: TextStyle(
        color: colors.primary,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      labelStyle: TextStyle(
        color: colors.onSurfaceVariant,
      ),
    );
  }

  // Modern card theme
  static CardTheme _buildCardTheme(ColorScheme colors) {
    return CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      color: colors.surface,
      shadowColor: colors.shadow.withValues(alpha: 0.2),
    );
  }

  // Modern app bar theme
  static AppBarTheme _buildAppBarTheme(
      ColorScheme colors, TextTheme textTheme) {
    return AppBarTheme(
      backgroundColor: colors.primary,
      foregroundColor: colors.onPrimary,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: textTheme.titleLarge?.copyWith(
        color: colors.onPrimary,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(
        color: colors.onPrimary,
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  // Modern dialog theme
  static DialogTheme _buildDialogTheme(ColorScheme colors) {
    return DialogTheme(
      backgroundColor: colors.surface,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }

  // Modern snackbar theme
  static SnackBarThemeData _buildSnackBarTheme(ColorScheme colors) {
    return SnackBarThemeData(
      backgroundColor: colors.inverseSurface,
      contentTextStyle: TextStyle(
        color: colors.onInverseSurface,
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  // Modern switch theme
  static SwitchThemeData _buildSwitchTheme(ColorScheme colors) {
    return SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return colors.primary;
        }
        return colors.outline;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return colors.primary.withValues(alpha: 0.5);
        }
        return colors.surfaceContainerHighest;
      }),
    );
  }

  // Modern checkbox theme
  static CheckboxThemeData _buildCheckboxTheme(ColorScheme colors) {
    return CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return colors.primary;
        }
        return colors.surfaceContainerHighest;
      }),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  // Modern chip theme
  static ChipThemeData _buildChipTheme(ColorScheme colors) {
    return ChipThemeData(
      backgroundColor: colors.surfaceContainerHighest,
      selectedColor: colors.primary,
      labelStyle: TextStyle(
        color: colors.onSurfaceVariant,
        fontWeight: FontWeight.w500,
      ),
      secondaryLabelStyle: TextStyle(
        color: colors.onPrimary,
        fontWeight: FontWeight.w500,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      side: BorderSide(
        color: colors.outline.withValues(alpha: 0.3),
        width: 1,
      ),
    );
  }

  // Modern popup menu theme
  static PopupMenuThemeData _buildPopupMenuTheme(ColorScheme colors) {
    return PopupMenuThemeData(
      color: colors.surface,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      textStyle: TextStyle(
        color: colors.onSurface,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
