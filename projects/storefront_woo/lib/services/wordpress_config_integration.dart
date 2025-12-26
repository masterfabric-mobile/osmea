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
          final localConfigString = await rootBundle.loadString(localConfigPath);
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
      } catch (e) {
        debugPrint('⚠️ WordPress config fetch failed: $e');
        debugPrint('📦 Using local config only');
        mergedConfig = localConfig;
        return mergedConfig;
      }
      
      // Step 3: Merge configurations
      debugPrint('🔄 Step 3: Merging configurations...');
      mergedConfig = useWordPressAsPrimary
          ? _mergeConfigs(localConfig, wordPressConfig)
          : _mergeConfigs(wordPressConfig, localConfig);
      
      debugPrint('✅ Configuration merged successfully');
      debugPrint('📊 Config source: WordPress + Local (merged)');
      debugPrint('📊 Merged config keys: ${mergedConfig!.keys.toList()}');
      
      return mergedConfig;
    } catch (e, stackTrace) {
      debugPrint('❌ Error in loadAndMergeConfig: $e');
      debugPrint('Stack trace: $stackTrace');
      return null;
    }
  }
  
  /// Merge two configuration maps
  /// 
  /// [base] - Base configuration (lower priority)
  /// [override] - Override configuration (higher priority)
  Map<String, dynamic> _mergeConfigs(
    Map<String, dynamic> base,
    Map<String, dynamic> override,
  ) {
    final merged = Map<String, dynamic>.from(base);
    
    override.forEach((key, value) {
      if (value is Map && merged[key] is Map) {
        // Recursively merge nested maps
        merged[key] = _mergeConfigs(
          merged[key] as Map<String, dynamic>,
          value as Map<String, dynamic>,
        );
      } else {
        // Override with WordPress value
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
  
  /// Get a boolean value from merged config
  bool getBool(String key, [bool defaultValue = false]) {
    if (mergedConfig != null) {
      return _getValueFromConfig(mergedConfig!, key, defaultValue) as bool;
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
  
  /// Get a nested object from merged config
  Map<String, dynamic>? getObject(String key) {
    if (mergedConfig != null) {
      return _getValueFromConfig(mergedConfig!, key, null) as Map<String, dynamic>?;
    }
    return assetConfigHelper.getObject(key);
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
}

