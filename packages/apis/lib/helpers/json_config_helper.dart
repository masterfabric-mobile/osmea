import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Helper class for loading and accessing JSON configuration
class JsonConfigHelper {
  /// The loaded JSON data
  final Map<String, dynamic> _data;

  JsonConfigHelper(this._data);

  /// Load configuration from a JSON file
  static Future<JsonConfigHelper> load(String path) async {
    try {
      final jsonString = await rootBundle.loadString(path);
      final jsonData = json.decode(jsonString);
      return JsonConfigHelper(jsonData);
    } catch (e) {
      // Return empty config if file not found or invalid
      if (kDebugMode) {
        debugPrint('Error loading config file: $e');
      }
      return JsonConfigHelper({});
    }
  }

  /// Get a value from the JSON by dot path
  /// Example: get('root.storeName')
  String get(String path) {
    final parts = path.split('.');
    dynamic current = _data;

    for (final part in parts) {
      if (current is! Map || !current.containsKey(part)) {
        return '';
      }
      current = current[part];
    }

    return current?.toString() ?? '';
  }

  /// Sample config.json structure:
  /// {
  ///   "root": {
  ///     "storeName": "your-store-name",
  ///     "shopifyAccessToken": "your-access-token",
  ///     "apiVersion": "2023-07"
  ///   }
  /// }
}
