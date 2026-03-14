import 'package:flutter/material.dart';
import 'package:osmea_components/osmea_components.dart';

/// 📝 **Text Data Models**
///
/// Data models and sample data for text showcase.

class TextData {
  // Sample text content for different use cases
  static const Map<String, String> sampleTexts = {
    'Short': 'Hello World',
    'Medium': 'This is a sample text to demonstrate various text features and styling options.',
    'Long': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
    'Code': 'const text = "Hello, World!";',
    'Multilingual': 'Hello · مرحبا · 你好 · Bonjour · Hola · नमस्ते',
  };

  // Color options for text styling
  static const Map<String, Color> semanticColors = {
    'Primary': Colors.blue,
    'Secondary': Colors.grey,
    'Success': Colors.green,
    'Warning': Colors.orange,
    'Danger': Colors.red,
    'Info': Colors.cyan,
    'Dark': Colors.black87,
    'Light': Colors.black54,
  };

  // Background color options
  static const Map<String, Color?> backgroundColors = {
    'None': null,
    'Light Grey': Color(0xFFF5F5F5),
    'Primary Light': Color(0xFFE3F2FD),
    'Success Light': Color(0xFFE8F5E8),
    'Warning Light': Color(0xFFFFF3E0),
    'Danger Light': Color(0xFFFFEBEE),
  };

  // Sample font families
  static const List<String> fontFamilies = [
    '', // Default
    'Roboto',
    'Inter',
    'Open Sans',
    'Lato',
    'Montserrat',
    'Poppins',
    'Nunito',
  ];

  // Font weight display names (non-const: FontWeight cannot be const map key)
  static final Map<FontWeight, String> fontWeightNames = {
    FontWeight.w100: 'Thin (100)',
    FontWeight.w200: 'Extra Light (200)',
    FontWeight.w300: 'Light (300)',
    FontWeight.w400: 'Regular (400)',
    FontWeight.w500: 'Medium (500)',
    FontWeight.w600: 'Semi Bold (600)',
    FontWeight.w700: 'Bold (700)',
    FontWeight.w800: 'Extra Bold (800)',
    FontWeight.w900: 'Black (900)',
  };

  // Sample use cases for different text variants
  static const Map<OsmeaTextVariant, String> variantUseCases = {
    OsmeaTextVariant.displayLarge: 'Hero headlines and main titles',
    OsmeaTextVariant.displayMedium: 'Section headlines',
    OsmeaTextVariant.displaySmall: 'Subsection headlines',
    OsmeaTextVariant.headlineLarge: 'Page titles',
    OsmeaTextVariant.headlineMedium: 'Card titles',
    OsmeaTextVariant.headlineSmall: 'List item titles',
    OsmeaTextVariant.titleLarge: 'Dialog titles',
    OsmeaTextVariant.titleMedium: 'App bar titles',
    OsmeaTextVariant.titleSmall: 'List subtitles',
    OsmeaTextVariant.subtitleLarge: 'Large supporting headings',
    OsmeaTextVariant.subtitleMedium: 'Medium supporting headings',
    OsmeaTextVariant.subtitleSmall: 'Small supporting headings',
    OsmeaTextVariant.labelLarge: 'Button labels',
    OsmeaTextVariant.labelMedium: 'Tab labels',
    OsmeaTextVariant.labelSmall: 'Chip labels',
    OsmeaTextVariant.bodyLarge: 'Article body text',
    OsmeaTextVariant.bodyMedium: 'List item descriptions',
    OsmeaTextVariant.bodySmall: 'Helper text',
    OsmeaTextVariant.captionLarge: 'Image captions',
    OsmeaTextVariant.captionMedium: 'Metadata',
    OsmeaTextVariant.captionSmall: 'Fine print',
    OsmeaTextVariant.buttonLarge: 'Large button text',
    OsmeaTextVariant.buttonMedium: 'Standard button text',
    OsmeaTextVariant.buttonSmall: 'Small button text',
    OsmeaTextVariant.linkLarge: 'Primary links',
    OsmeaTextVariant.linkMedium: 'Inline links',
    OsmeaTextVariant.linkSmall: 'Footer links',
    OsmeaTextVariant.overline: 'Category labels',
    OsmeaTextVariant.code: 'Code snippets',
  };
}
