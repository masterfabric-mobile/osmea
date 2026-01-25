library color_helper;

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'asset_config_helper.dart';

/// 🎨 ColorHelper: A utility class for color parsing and conversion
///
/// This helper class provides functionality to:
/// - Parse hex color strings to Flutter Color objects
/// - Support multiple hex color formats (#RRGGBB, RRGGBB, #AARRGGBB, AARRGGBB)
/// - Get colors from configuration with fallback support
/// - Handle errors gracefully with fallback colors
///
/// **Supported Hex Formats:**
/// - '#RRGGBB' (6 characters with # prefix, no alpha)
/// - 'RRGGBB' (6 characters without # prefix, no alpha)
/// - '#AARRGGBB' (8 characters with # prefix, with alpha)
/// - 'AARRGGBB' (8 characters without # prefix, with alpha)
///
/// **Usage Examples:**
/// ```dart
/// // Parse hex string to Color
/// final color = ColorHelper.parseHex('#FF5733');
/// final colorWithAlpha = ColorHelper.parseHex('#80FF5733');
///
/// // Get color from config with fallback
/// final configHelper = AssetConfigHelper();
/// final color = ColorHelper.getColorFromConfig(
///   configHelper,
///   'ui_configuration.primary_color',
///   fallback: OsmeaColors.nordicBlue,
/// );
///
/// // Parse hex string with fallback
/// final color = ColorHelper.parseHex(
///   '#FF5733',
///   fallback: OsmeaColors.black,
/// );
/// ```
class ColorHelper {
  /// 🔒 Private constructor to prevent instantiation
  ColorHelper._();

  /// 🎨 Parse a hex color string to Flutter Color
  ///
  /// Supports following hex color formats:
  /// - '#RRGGBB' (6 characters with # prefix, no alpha)
  /// - 'RRGGBB' (6 characters without # prefix, no alpha)
  /// - '#AARRGGBB' (8 characters with # prefix, with alpha)
  /// - 'AARRGGBB' (8 characters without # prefix, with alpha)
  ///
  /// **Note:** For 8-character hex strings, the format is assumed to be AARRGGBB
  /// (alpha first, then RGB), which is Flutter's standard format.
  ///
  /// Parameters:
  /// - [hexString]: The hex color string to parse
  /// - [fallback]: Default color to return if parsing fails. Defaults to black.
  ///
  /// Returns:
  /// - Color: The parsed color or fallback color if parsing fails
  ///
  /// Usage:
  /// ```dart
  /// // Parse 6-character hex (RGB)
  /// final color = ColorHelper.parseHex('#FF5733');
  ///
  /// // Parse 8-character hex (ARGB)
  /// final colorWithAlpha = ColorHelper.parseHex('#80FF5733');
  ///
  /// // With fallback
  /// final color = ColorHelper.parseHex(
  ///   invalidHex,
  ///   fallback: OsmeaColors.nordicBlue,
  /// );
  /// ```
  static Color parseHex(String hexString, {Color fallback = const Color(0xFF000000)}) {
    if (hexString.isEmpty) {
      debugPrint('⚠️ ColorHelper: Empty hex string provided, returning fallback');
      return fallback;
    }

    try {
      // Remove the # prefix if exists
      String hex = hexString.startsWith('#') ? hexString.substring(1) : hexString;

      // Validate hex string contains only valid hex characters
      if (!RegExp(r'^[0-9A-Fa-f]+$').hasMatch(hex)) {
        debugPrint('⚠️ ColorHelper: Invalid hex characters in "$hexString", returning fallback');
        return fallback;
      }

      if (hex.length == 6) {
        // Format: RRGGBB (no alpha)
        // Add FF for full opacity
        return Color(int.parse('FF$hex', radix: 16));
      } else if (hex.length == 8) {
        // Format: AARRGGBB (with alpha)
        // Flutter uses ARGB format
        return Color(int.parse(hex, radix: 16));
      } else {
        debugPrint('⚠️ ColorHelper: Invalid hex length "${hex.length}" in "$hexString" (expected 6 or 8), returning fallback');
        return fallback;
      }
    } catch (e) {
      debugPrint('❌ ColorHelper: Error parsing hex color "$hexString": $e');
      return fallback;
    }
  }

  /// 🎨 Get color from configuration using AssetConfigHelper
  ///
  /// This method retrieves a color string from configuration and parses it to a Color object.
  /// It combines the functionality of AssetConfigHelper.getString() and ColorHelper.parseHex().
  ///
  /// Parameters:
  /// - [configHelper]: The AssetConfigHelper instance to use
  /// - [key]: The configuration key path using dot notation (e.g., 'ui_configuration.primary_color')
  /// - [fallback]: Default color to return if the key is not found or parsing fails
  ///
  /// Returns:
  /// - Color: The configuration color value or fallback color
  ///
  /// Usage:
  /// ```dart
  /// final configHelper = AssetConfigHelper();
  /// final color = ColorHelper.getColorFromConfig(
  ///   configHelper,
  ///   'dialog_popup_configuration.add_to_cart_popup.backgroundColor',
  ///   fallback: OsmeaColors.paperWhite,
  /// );
  /// ```
  static Color getColorFromConfig(
    dynamic configHelper,
    String key, {
    Color fallback = const Color(0xFF000000),
  }) {
    try {
      // Check if configHelper has getString method (AssetConfigHelper)
      if (configHelper == null) {
        debugPrint('⚠️ ColorHelper: ConfigHelper is null, returning fallback');
        return fallback;
      }

      // Use reflection to call getString if available
      // For now, we'll assume it's AssetConfigHelper and has getString method
      String colorString;
      if (configHelper is AssetConfigHelper) {
        colorString = configHelper.getString(key);
      } else {
        // Try to call getString using dynamic call
        try {
          colorString = configHelper.getString(key) as String;
        } catch (e) {
          debugPrint('⚠️ ColorHelper: ConfigHelper does not have getString method: $e');
          return fallback;
        }
      }

      if (colorString.isEmpty) {
        debugPrint('⚠️ ColorHelper: Color key "$key" not found or empty, returning fallback');
        return fallback;
      }

      // Parse the hex string
      return parseHex(colorString, fallback: fallback);
    } catch (e) {
      debugPrint('❌ ColorHelper: Error getting color from config for key "$key": $e');
      return fallback;
    }
  }

  /// 🎨 Get color from configuration with default value support
  ///
  /// This is a convenience method that works with AssetConfigHelper's getString method
  /// that supports default values.
  ///
  /// Parameters:
  /// - [configHelper]: The AssetConfigHelper instance to use
  /// - [key]: The configuration key path using dot notation
  /// - [defaultValue]: Default hex string value if key is not found
  /// - [fallback]: Default color to return if parsing fails
  ///
  /// Returns:
  /// - Color: The configuration color value or fallback color
  ///
  /// Usage:
  /// ```dart
  /// final configHelper = AssetConfigHelper();
  /// final color = ColorHelper.getColorFromConfigWithDefault(
  ///   configHelper,
  ///   'ui_configuration.primary_color',
  ///   defaultValue: '#1976D2',
  ///   fallback: OsmeaColors.nordicBlue,
  /// );
  /// ```
  static Color getColorFromConfigWithDefault(
    dynamic configHelper,
    String key,
    String defaultValue, {
    Color fallback = const Color(0xFF000000),
  }) {
    try {
      if (configHelper == null) {
        debugPrint('⚠️ ColorHelper: ConfigHelper is null, using default value');
        return parseHex(defaultValue, fallback: fallback);
      }

      String colorString;
      if (configHelper is AssetConfigHelper) {
        colorString = configHelper.getString(key, defaultValue);
      } else {
        try {
          colorString = configHelper.getString(key, defaultValue) as String;
        } catch (e) {
          debugPrint('⚠️ ColorHelper: ConfigHelper does not have getString method: $e');
          return parseHex(defaultValue, fallback: fallback);
        }
      }

      if (colorString.isEmpty) {
        return parseHex(defaultValue, fallback: fallback);
      }

      return parseHex(colorString, fallback: fallback);
    } catch (e) {
      debugPrint('❌ ColorHelper: Error getting color from config for key "$key": $e');
      return parseHex(defaultValue, fallback: fallback);
    }
  }
}
