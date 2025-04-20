import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class JsonConfigHelper {
  final Map<String, dynamic> _config;

  JsonConfigHelper._(this._config);

  /// Asset içindeki [assetPath] dosyasını yükler ve bir helper döner.
  static Future<JsonConfigHelper> load(String assetPath) async {
    final jsonString = await rootBundle.loadString(assetPath);
    final config = jsonDecode(jsonString) as Map<String, dynamic>;
    return JsonConfigHelper._(config);
  }

  /// Nokta ile ayrılmış key-path ile değer döndürür.
  dynamic get(String keyPath) {
    final keys = keyPath.split('.');
    dynamic value = _config;
    for (final key in keys) {
      if (value is Map && value.containsKey(key)) {
        value = value[key];
      } else {
        return null;
      }
    }
    return value;
  }
}
