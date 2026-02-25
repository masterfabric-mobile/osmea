import 'package:flutter/material.dart';
import 'package:tiny_plates/app/core/config/app_config_service.dart';
import 'package:tiny_plates/app/core/helpers/color_helper.dart';

/// Reads style tokens from [AppConfigService] and produces a [ThemeData].
/// Changing values in app_config.json updates the app theme after restart.
class ThemeFactory {
  ThemeFactory._();

  static ThemeData fromConfig(AppConfigService config) {
    final primaryColor = colorFromHex(
      config.getString('theme.primaryColor', '#000000'),
      fallback: Colors.black,
    );
    final backgroundColor = colorFromHex(
      config.getString('theme.backgroundColor', '#FFFFFF'),
      fallback: Colors.white,
    );
    final buttonBg = colorFromHex(
      config.getString('buttonStyle.primary.bg', '#000000'),
      fallback: Colors.black,
    );
    final buttonText = colorFromHex(
      config.getString('buttonStyle.primary.text', '#FFFFFF'),
      fallback: Colors.white,
    );
    final buttonRadius =
        config.getDouble('buttonStyle.borderRadius', 8).toDouble();
    final fontFamily = config.getString('typography.fontFamily', 'Roboto');

    return ThemeData(
      useMaterial3: true,
      fontFamily: fontFamily,
      colorScheme: ColorScheme.fromSeed(seedColor: primaryColor).copyWith(
        primary: primaryColor,
        onPrimary: buttonText,
        surface: backgroundColor,
        onSurface: primaryColor,
      ),
      scaffoldBackgroundColor: backgroundColor,
      canvasColor: backgroundColor,
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundColor,
        foregroundColor: primaryColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: backgroundColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonBg,
          foregroundColor: buttonText,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonRadius),
          ),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: backgroundColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: primaryColor.withValues(alpha: 0.4),
        elevation: 0,
      ),
    );
  }
}
