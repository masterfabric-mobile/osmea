import 'package:flutter/material.dart';

/// 🎨 Main application theme configuration
/// Defines colors, styles, and component appearances
class AppTheme {
  // 🌈 Theme colors
  static const primaryColor = Color(0xFF5468FF); // 🔵 Blue
  static const secondaryColor = Color(0xFF22C55E); // 💚 Green
  static const backgroundColor = Color(0xFFF8FAFC); // ⚪ Light background
  static const textColor = Color(0xFF0F172A); // 🖤 Dark text

  // 🏗️ Get the theme data
  static ThemeData getTheme() {
    return ThemeData(
      // 🧩 Base theme with Material 3
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        surface: Colors.white,
      ),
      useMaterial3: true,

      // 🧱 Basic component themes
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: textColor,
      ),

      // 🃏 Card styling
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade200),
        ),
      ),

      // 🔘 Button styling
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
        ),
      ),

      // 📝 Input field styling
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: primaryColor),
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }
}
