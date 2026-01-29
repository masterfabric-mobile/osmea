import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:core/core.dart';
import 'package:storefront_woo/services/wordpress_config_service.dart';

/// Helper to integrate WordPress configuration with AssetConfigHelper
///
/// This class fetches configuration from WordPress REST API and merges it
/// with local app_config.json. WordPress config takes priority.
class WordPressConfigIntegration {
  final WordPressConfigService configService;
  final AssetConfigHelper assetConfigHelper;

  /// Merged configuration (WordPress + Local)
  Map<String, dynamic>? mergedConfig;

  WordPressConfigIntegration({
    required this.configService,
    required this.assetConfigHelper,
  });

  /// Load configuration from WordPress and merge with local config
  ///
  /// Priority: WordPress Config > Local Config > Default
  ///
  /// Returns the merged configuration map, or null if both failed
  Future<Map<String, dynamic>?> loadAndMergeConfig({
    String localConfigPath = 'assets/app_config.json',
    bool useWordPressAsPrimary = true,
  }) async {
    try {
      // Step 1: Load local config first (as fallback)
      debugPrint('📂 Step 1: Loading local config from $localConfigPath');
      final localLoaded = await assetConfigHelper.loadConfig(
        localConfigPath,
        true, // enableFallback
      );

      // Get local config values
      Map<String, dynamic> localConfig = {};
      if (localLoaded) {
        // Extract local config by reading the asset file
        try {
          final localConfigString = await rootBundle.loadString(
            localConfigPath,
          );
          localConfig = json.decode(localConfigString) as Map<String, dynamic>;
          debugPrint('✅ Local config loaded');
        } catch (e) {
          debugPrint('⚠️ Could not parse local config: $e');
        }
      } else {
        debugPrint('⚠️ Local config could not be loaded, using defaults');
      }

      // Step 2: Try to fetch WordPress config
      debugPrint('📡 Step 2: Fetching config from WordPress...');
      Map<String, dynamic>? wordPressConfig;

      try {
        wordPressConfig = await configService.fetchAppConfigWithRetry(
          maxRetries: 2,
          retryDelay: const Duration(seconds: 1),
        );
        debugPrint('✅ WordPress config fetched successfully');

        // Debug: Check WordPress config structure
        if (wordPressConfig != null) {
          debugPrint(
            '📊 WordPress config keys: ${wordPressConfig.keys.toList()}',
          );
          if (wordPressConfig.containsKey('woocommerce_configuration')) {
            final wooConfig = wordPressConfig['woocommerce_configuration'];
            if (wooConfig is Map) {
              debugPrint('📊 WooCommerce config from WordPress:');
              debugPrint('  - Store URL: ${wooConfig['store_url']}');
              debugPrint('  - Brand Name: ${wooConfig['brand_name']}');
              debugPrint('  - Version: ${wooConfig['version']}');
            }
          }
        }
      } catch (e) {
        debugPrint('⚠️ WordPress config fetch failed: $e');
        debugPrint('📦 Using local config only');
        mergedConfig = _normalizeConfigTypes(
          Map<String, dynamic>.from(localConfig),
        );
        return mergedConfig;
      }

      // Step 3: Merge configurations
      // Priority: WordPress Config (plugin) > Local Config (app_config.json)
      debugPrint('🔄 Step 3: Merging configurations...');
      debugPrint(
        '  - Priority: ${useWordPressAsPrimary ? 'WordPress (plugin) > Local' : 'Local > WordPress'}',
      );

      mergedConfig = useWordPressAsPrimary
          ? _mergeConfigs(
              localConfig, // base: lower priority (fallback)
              wordPressConfig!, // override: higher priority (plugin config wins)
            )
          : _mergeConfigs(
              wordPressConfig!, // base: lower priority
              localConfig, // override: higher priority (local config wins)
            );
      mergedConfig = _normalizeConfigTypes(mergedConfig!);

      debugPrint('✅ Configuration merged successfully');
      debugPrint('📊 Config source: WordPress + Local (merged)');
      debugPrint('📊 Merged config keys: ${mergedConfig!.keys.toList()}');

      // Debug: Check merged config structure and verify WordPress values are used
      if (mergedConfig!.containsKey('woocommerce_configuration')) {
        final wooConfig = mergedConfig!['woocommerce_configuration'];
        final wordPressWooConfig =
            wordPressConfig?['woocommerce_configuration'];
        final localWooConfig = localConfig['woocommerce_configuration'];

        if (wooConfig is Map) {
          debugPrint('📊 Merged WooCommerce config (final values):');
          debugPrint(
            '  - Store URL: ${wooConfig['store_url']} ${_getSourceInfo(wooConfig['store_url'], wordPressWooConfig?['store_url'], localWooConfig?['store_url'], useWordPressAsPrimary)}',
          );
          debugPrint(
            '  - Brand Name: ${wooConfig['brand_name']} ${_getSourceInfo(wooConfig['brand_name'], wordPressWooConfig?['brand_name'], localWooConfig?['brand_name'], useWordPressAsPrimary)}',
          );
          debugPrint(
            '  - Version: ${wooConfig['version']} ${_getSourceInfo(wooConfig['version'], wordPressWooConfig?['version'], localWooConfig?['version'], useWordPressAsPrimary)}',
          );
        }
      }

      return mergedConfig;
    } catch (e, stackTrace) {
      debugPrint('❌ Error in loadAndMergeConfig: $e');
      debugPrint('Stack trace: $stackTrace');
      return null;
    }
  }

  /// Merge two configuration maps
  ///
  /// [base] - Base configuration (lower priority, used as fallback)
  /// [override] - Override configuration (higher priority, overwrites base values)
  ///
  /// Returns: Merged config where override values take precedence over base values
  Map<String, dynamic> _mergeConfigs(
    Map<String, dynamic> base,
    Map<String, dynamic> override,
  ) {
    // Start with base config (fallback values)
    final merged = Map<String, dynamic>.from(base);

    // Override with higher priority config values
    override.forEach((key, value) {
      if (value is Map && merged[key] is Map) {
        // Recursively merge nested maps (e.g., woocommerce_configuration)
        merged[key] = _mergeConfigs(
          merged[key] as Map<String, dynamic>, // base nested map
          value as Map<String, dynamic>, // override nested map
        );
      } else {
        // Override base value with higher priority value.
        // If override is null, keep base so defaults from assets/app_config.json
        // (e.g. bottom_foreground_banner.imageUrl / route) are not wiped out.
        if (value == null) {
          return;
        }
        merged[key] = value;
      }
    });

    return merged;
  }

  /// Get a value from merged config using dot notation
  ///
  /// Falls back to AssetConfigHelper if merged config is not available
  String getString(String key, [String defaultValue = '']) {
    if (mergedConfig != null) {
      return _getValueFromConfig(mergedConfig!, key, defaultValue) as String;
    }
    return assetConfigHelper.getString(key, defaultValue);
  }

  /// Get a boolean value from merged config.
  /// Accepts both bool and string "true"/"false"/"1"/"0" from API/plugin.
  bool getBool(String key, [bool defaultValue = false]) {
    if (mergedConfig != null) {
      final v = _getValueFromConfig(mergedConfig!, key, defaultValue);
      return _toBool(v, defaultValue);
    }
    return assetConfigHelper.getBool(key, defaultValue);
  }

  /// Get an integer value from merged config
  int getInt(String key, [int defaultValue = 0]) {
    if (mergedConfig != null) {
      return _getValueFromConfig(mergedConfig!, key, defaultValue) as int;
    }
    return assetConfigHelper.getInt(key, defaultValue);
  }

  /// Get a double value from merged config
  double getDouble(String key, [double defaultValue = 0.0]) {
    if (mergedConfig != null) {
      final value = _getValueFromConfig(mergedConfig!, key, defaultValue);
      if (value is double) {
        return value;
      } else if (value is int) {
        return value.toDouble();
      } else if (value is String) {
        final parsed = double.tryParse(value);
        if (parsed != null) {
          return parsed;
        }
      }
      return defaultValue;
    }
    return assetConfigHelper.getDouble(key, defaultValue);
  }

  /// Get a nested object from merged config.
  /// Nested maps are already normalized (string booleans -> bool) from merged config.
  Map<String, dynamic>? getObject(String key) {
    if (mergedConfig != null) {
      final v = _getValueFromConfig(mergedConfig!, key, null);
      if (v is Map<String, dynamic>) return v;
      if (v is Map) return Map<String, dynamic>.from(v);
      return null;
    }
    return assetConfigHelper.getObject(key);
  }

  /// Keys that must stay string (colors, urls, placeholder, variant, etc.).
  /// If merged config has bool for these (e.g. from local json), convert to "true"/"false"
  /// so "as String?" in UI never gets bool.
  static bool _configKeyMustBeString(String key) {
    final k = key.toLowerCase();
    const strKeys = {
      'placeholder',
      'variant',
      'title',
      'text',
      'message',
      'subtitle',
      'description',
      'route',
      'imageurl',
      'amount',
      'layout',
      'position',
      'style',
      'curve',
      'begin',
      'end',
      'name',
      'content',
      'hint',
      'label',
      'icon',
      'indicatorstyle',
      'indicator_style',
      'titlewithcount',
      'end_time',
      'gradient_start',
      'gradient_end',
      'id',
      'tooltip',
      'fillediconname',
      'animationtype',
      'animationtrigger',
      'authiconname',
      'guesticonname',
      'authroute',
      'guestroute',
      'authtext',
      'guesttext',
      'height',
    };
    if (strKeys.contains(k)) return true;
    if (k.endsWith('_color') || k.endsWith('_url') || k.endsWith('url'))
      return true;
    if (k.contains('color') || k.contains('url')) return true;
    return false;
  }

  /// Keys that must stay bool (enabled, show_*, etc.). Only these may stay bool;
  /// any other bool is converted to "true"/"false" to avoid "bool is not a subtype of String?" in UI.
  static bool _configKeyIsBool(String key) {
    final k = key.toLowerCase();
    const boolKeys = {
      'enabled',
      'show_names',
      'show_dismiss_button',
      'show_close_button',
      'show_see_all',
      'showlabels',
      'showicons',
      'centeritems',
    };
    if (boolKeys.contains(k)) return true;
    return k.startsWith('show_');
  }

  /// Normalize config: string "true"/"false"/"1"/"0" -> bool for bool keys;
  /// bool -> "true"/"false" for non-bool keys so "as String?" in UI never gets bool.
  Map<String, dynamic> _normalizeConfigTypes(Map<String, dynamic> map) {
    final result = <String, dynamic>{};
    for (final e in map.entries) {
      final v = e.value;
      if (v is Map) {
        result[e.key] = _normalizeConfigTypes(Map<String, dynamic>.from(v));
      } else if (v is List) {
        result[e.key] = v.map((item) {
          if (item is Map) {
            return _normalizeConfigTypes(Map<String, dynamic>.from(item));
          }
          return _toBoolIfBoolString(item);
        }).toList();
      } else {
        if (v is bool) {
          if (_configKeyMustBeString(e.key) || !_configKeyIsBool(e.key)) {
            result[e.key] = v ? 'true' : 'false';
          } else {
            result[e.key] = v;
          }
        } else {
          result[e.key] = _toBoolIfBoolString(v);
        }
      }
    }
    return result;
  }

  static dynamic _toBoolIfBoolString(dynamic v) {
    if (v is String) {
      final s = v.toLowerCase().trim();
      if (s == 'true' || s == '1') return true;
      if (s == 'false' || s == '0' || s == '') return false;
    }
    return v;
  }

  static bool _toBool(dynamic v, bool defaultValue) {
    if (v == null) return defaultValue;
    if (v is bool) return v;
    if (v is String) {
      final s = v.toLowerCase().trim();
      if (s == 'true' || s == '1') return true;
      if (s == 'false' || s == '0' || s == '') return false;
    }
    return defaultValue;
  }

  /// Helper to get value from config using dot notation
  dynamic _getValueFromConfig(
    Map<String, dynamic> config,
    String key,
    dynamic defaultValue,
  ) {
    final keys = key.split('.');
    dynamic value = config;

    for (final k in keys) {
      if (value is Map && value.containsKey(k)) {
        value = value[k];
      } else {
        return defaultValue;
      }
    }

    return value ?? defaultValue;
  }

  /// Helper to show which source provided the final value
  String _getSourceInfo(
    dynamic finalValue,
    dynamic wordPressValue,
    dynamic localValue,
    bool wordPressIsPrimary,
  ) {
    if (wordPressIsPrimary) {
      // WordPress is primary, check if it matches WordPress value
      if (wordPressValue != null &&
          wordPressValue.toString() == finalValue.toString()) {
        return '(from WordPress plugin ✅)';
      } else if (localValue != null &&
          localValue.toString() == finalValue.toString()) {
        return '(from local config, WordPress missing)';
      }
    } else {
      // Local is primary
      if (localValue != null &&
          localValue.toString() == finalValue.toString()) {
        return '(from local config ✅)';
      } else if (wordPressValue != null &&
          wordPressValue.toString() == finalValue.toString()) {
        return '(from WordPress plugin, local missing)';
      }
    }
    return '(merged/fallback)';
  }
}
