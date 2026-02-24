import 'package:masterfabric_core/masterfabric_core.dart';

/// DI-registered singleton that exposes [AssetConfigHelper] values.
/// Loaded once at startup via [starter.dart]; use via [GetIt] elsewhere.
class AppConfigService {
  final AssetConfigHelper _helper = AssetConfigHelper();

  String getString(String key, [String fallback = '']) =>
      _helper.getString(key, fallback);

  bool getBool(String key, [bool fallback = false]) =>
      _helper.getBool(key, fallback);

  int getInt(String key, [int fallback = 0]) =>
      _helper.getInt(key, fallback);

  double getDouble(String key, [double fallback = 0.0]) =>
      _helper.getDouble(key, fallback);

  Map<String, dynamic>? getAllConfig() => _helper.getAllConfig();
}
