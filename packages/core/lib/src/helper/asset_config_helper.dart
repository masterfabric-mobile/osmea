library asset_config_helper;

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// 🗂️ AssetConfigHelper: A utility class for reading and managing JSON configuration files from assets
///
/// This helper class provides functionality to:
/// - Load JSON configuration files with automatic fallback mechanism
/// - Parse JSON data and provide type-safe access to configuration values
/// - Cache loaded configurations for better performance
/// - Handle errors gracefully with intelligent fallback to @core package defaults
/// - Automatically determine configuration source (project-specific vs core package)
///
/// **Fallback Mechanism:**
/// 1. Tries to load project-specific config (e.g., `assets/app_config.json`)
/// 2. If fails, automatically falls back to @core package config (`packages/core/assets/app_config.json`)
/// 3. If both fail, uses hardcoded default values
///
/// **Usage Example:**
/// ```dart
/// // Initialize the helper
/// final configHelper = AssetConfigHelper();
///
/// // Load @core package config directly (default behavior)
/// await configHelper.loadConfig(); // Loads packages/core/assets/app_config.json
///
/// // OR load project-specific config with automatic fallback to @core
/// await configHelper.loadConfig('assets/app_config.json'); // Auto-fallback to @core if needed
///
/// // Get configuration values with type safety
/// String appName = configHelper.getString('app_settings.app_name', 'Default App Name');
/// bool debugMode = configHelper.getBool('app_settings.debug_mode', false);
/// int timeout = configHelper.getInt('api_configuration.timeout_seconds', 30);
///
/// // Get nested object
/// Map<String, dynamic>? apiConfig = configHelper.getObject('api_configuration');
///
/// // Check configuration source
/// final stats = configHelper.getConfigStats();
/// print('Config source: ${stats['config_source']}'); // 'project_specific' or 'core_package_fallback'
///
/// // Check if a key exists
/// bool hasThemeConfig = configHelper.hasKey('ui_configuration.theme_mode');
/// ```
class AssetConfigHelper {
  // Singleton pattern implementation
  static final AssetConfigHelper _instance = AssetConfigHelper._internal();

  /// Factory constructor that returns the singleton instance
  factory AssetConfigHelper() {
    return _instance;
  }

  /// Private constructor for singleton pattern
  AssetConfigHelper._internal();

  /// Cache for loaded configuration data to avoid repeated file reads
  final Map<String, Map<String, dynamic>> _configCache = {};

  /// Currently loaded configuration data
  Map<String, dynamic>? _currentConfig;

  /// Path to the currently loaded configuration file
  String? _currentConfigPath;

  /// Flag to track if automatic initialization was attempted
  bool _autoInitAttempted = false;

  /// 📂 Load configuration from an asset file with optional fallback
  ///
  /// This method loads a JSON configuration file with configurable fallback:
  ///
  /// **With Fallback (enableFallback = true, default):**
  /// 1. If no assetPath provided, loads @core package default config directly
  /// 2. If assetPath provided, tries to load project-specific config first
  /// 3. If project-specific fails, automatically falls back to @core package default config
  ///
  /// **Without Fallback (enableFallback = false):**
  /// - Only attempts to load from the specified assetPath
  /// - No fallback to @core package config
  /// - Used when MasterApp already handles fallback logic
  ///
  /// Parameters:
  /// - [assetPath]: The path to the JSON asset file. If null and enableFallback=true, defaults to @core package config
  /// - [enableFallback]: Whether to enable automatic fallback to @core package config. Default: true
  ///
  /// Returns:
  /// - Future<bool>: true if configuration was loaded successfully, false otherwise
  ///
  /// Usage:
  /// ```dart
  /// final helper = AssetConfigHelper();
  ///
  /// // Load @core package config directly
  /// await helper.loadConfig();
  ///
  /// // With automatic fallback (default)
  /// await helper.loadConfig('assets/app_config.json');
  ///
  /// // Without fallback (for use with MasterApp)
  /// await helper.loadConfig('assets/app_config.json', false);
  /// ```
  Future<bool> loadConfig(
      [String? assetPath, bool enableFallback = true]) async {
    // Define @core package config path
    const String corePackageConfigPath = 'packages/core/assets/app_config.json';

    // If no assetPath provided, load @core package config directly
    if (assetPath == null) {
      debugPrint(
          '🔄 No asset path provided, loading @core package config directly...');
      bool loaded = await _loadConfigFromPath(corePackageConfigPath);
      if (loaded) {
        debugPrint(
            '📁 Using @core package default configuration from: $corePackageConfigPath');
        return true;
      } else {
        debugPrint('❌ Failed to load @core package default configuration');
        return false;
      }
    }

    // Try to load the specified configuration
    bool loaded = await _loadConfigFromPath(assetPath);
    if (loaded) {
      debugPrint('📁 Using configuration from: $assetPath');
      return true;
    }

    // If fallback is disabled, return false immediately
    if (!enableFallback) {
      debugPrint(
          '❌ Failed to load configuration from: $assetPath (fallback disabled)');
      return false;
    }

    // If fallback is enabled and project-specific config failed, try @core package fallback
    debugPrint(
        '🔄 Project-specific config not found, trying @core package fallback...');
    loaded = await _loadConfigFromPath(corePackageConfigPath);
    if (loaded) {
      debugPrint(
          '📁 Using @core package fallback configuration from: $corePackageConfigPath');
      return true;
    }

    // If both failed
    debugPrint('❌ No configuration could be loaded from either:');
    debugPrint('  1. $assetPath (project-specific)');
    debugPrint('  2. $corePackageConfigPath (@core package fallback)');
    return false;
  }

  /// 🔧 Private method to load configuration from a specific path
  ///
  /// This method handles the actual loading logic for a single path
  ///
  /// Parameters:
  /// - [assetPath]: The path to load configuration from
  ///
  /// Returns:
  /// - Future<bool>: true if loaded successfully, false otherwise
  Future<bool> _loadConfigFromPath(String assetPath) async {
    try {
      debugPrint('🔄 Loading configuration from: $assetPath');

      // Check if configuration is already cached
      if (_configCache.containsKey(assetPath)) {
        debugPrint('✅ Configuration loaded from cache: $assetPath');
        _currentConfig = _configCache[assetPath];
        _currentConfigPath = assetPath;
        return true;
      }

      // Load the asset file as a string
      final String configString = await rootBundle.loadString(assetPath);

      // Parse the JSON string
      final Map<String, dynamic> configData = json.decode(configString);

      // Cache the configuration data
      _configCache[assetPath] = configData;
      _currentConfig = configData;
      _currentConfigPath = assetPath;

      debugPrint('✅ Configuration loaded successfully from: $assetPath');
      debugPrint('📊 Configuration keys: ${configData.keys.toList()}');

      return true;
    } catch (e) {
      debugPrint('⚠️ Failed to load configuration from $assetPath: $e');
      return false;
    }
  }

  /// 🔍 Get a string value from the configuration using dot notation
  ///
  /// Parameters:
  /// - [key]: The key path using dot notation (e.g., 'app_settings.app_name')
  /// - [defaultValue]: Default value to return if the key is not found
  ///
  /// Returns:
  /// - String: The configuration value or default value
  String getString(String key, [String defaultValue = '']) {
    final dynamic value = _getValue(key);
    if (value is String) {
      return value;
    }
    debugPrint(
        '⚠️ Key "$key" not found or not a string, returning default: $defaultValue');
    return defaultValue;
  }

  /// 🔢 Get an integer value from the configuration using dot notation
  ///
  /// Parameters:
  /// - [key]: The key path using dot notation (e.g., 'api_configuration.timeout_seconds')
  /// - [defaultValue]: Default value to return if the key is not found
  ///
  /// Returns:
  /// - int: The configuration value or default value
  int getInt(String key, [int defaultValue = 0]) {
    final dynamic value = _getValue(key);
    if (value is int) {
      return value;
    } else if (value is String) {
      // Try to parse string as integer
      final int? parsed = int.tryParse(value);
      if (parsed != null) {
        return parsed;
      }
    }
    debugPrint(
        '⚠️ Key "$key" not found or not an integer, returning default: $defaultValue');
    return defaultValue;
  }

  /// 📏 Get a double value from the configuration using dot notation
  ///
  /// Parameters:
  /// - [key]: The key path using dot notation (e.g., 'ui_configuration.font_scale')
  /// - [defaultValue]: Default value to return if the key is not found
  ///
  /// Returns:
  /// - double: The configuration value or default value
  double getDouble(String key, [double defaultValue = 0.0]) {
    final dynamic value = _getValue(key);
    if (value is double) {
      return value;
    } else if (value is int) {
      return value.toDouble();
    } else if (value is String) {
      // Try to parse string as double
      final double? parsed = double.tryParse(value);
      if (parsed != null) {
        return parsed;
      }
    }
    debugPrint(
        '⚠️ Key "$key" not found or not a double, returning default: $defaultValue');
    return defaultValue;
  }

  /// ✅ Get a boolean value from the configuration using dot notation
  ///
  /// Parameters:
  /// - [key]: The key path using dot notation (e.g., 'app_settings.debug_mode')
  /// - [defaultValue]: Default value to return if the key is not found
  ///
  /// Returns:
  /// - bool: The configuration value or default value
  bool getBool(String key, [bool defaultValue = false]) {
    final dynamic value = _getValue(key);
    if (value is bool) {
      return value;
    } else if (value is String) {
      // Handle string representations of boolean
      final String lowerValue = value.toLowerCase();
      if (lowerValue == 'true' || lowerValue == '1') {
        return true;
      } else if (lowerValue == 'false' || lowerValue == '0') {
        return false;
      }
    }
    debugPrint(
        '⚠️ Key "$key" not found or not a boolean, returning default: $defaultValue');
    return defaultValue;
  }

  /// 📋 Get a list value from the configuration using dot notation
  ///
  /// Parameters:
  /// - [key]: The key path using dot notation (e.g., 'localization_configuration.supported_languages')
  /// - [defaultValue]: Default value to return if the key is not found
  ///
  /// Returns:
  /// - List<dynamic>: The configuration value or default value
  List<dynamic> getList(String key, [List<dynamic> defaultValue = const []]) {
    final dynamic value = _getValue(key);
    if (value is List) {
      return value;
    }
    debugPrint(
        '⚠️ Key "$key" not found or not a list, returning default: $defaultValue');
    return defaultValue;
  }

  /// 🗂️ Get an object (Map) value from the configuration using dot notation
  ///
  /// Parameters:
  /// - [key]: The key path using dot notation (e.g., 'api_configuration')
  /// - [defaultValue]: Default value to return if the key is not found
  ///
  /// Returns:
  /// - Map<String, dynamic>?: The configuration object or null if not found
  Map<String, dynamic>? getObject(String key,
      [Map<String, dynamic>? defaultValue]) {
    final dynamic value = _getValue(key);
    if (value is Map<String, dynamic>) {
      return value;
    }
    debugPrint(
        '⚠️ Key "$key" not found or not an object, returning default: $defaultValue');
    return defaultValue;
  }

  /// 🎨 Get a color value from the configuration using dot notation
  ///
  /// Supports following hex color formats:
  /// - '#RRGGBB' (6 characters with # prefix, no alpha)
  /// - 'RRGGBB' (6 characters without # prefix, no alpha)
  /// - '#AARRGGBB' (8 characters with # prefix, with alpha)
  /// - 'AARRGGBB' (8 characters without # prefix, with alpha)
  ///
  /// Parameters:
  /// - [key]: The key path using dot notation (e.g., 'ui_configuration.primary_color')
  /// - [defaultColor]: Default color to return if the key is not found or invalid
  ///
  /// Returns:
  /// - Color: The configuration color value or default color
  Color getColor(String key, [Color defaultColor = const Color(0xFF2196F3)]) {
    final String? colorStr = getString(key);
    if (colorStr == null || colorStr.isEmpty) {
      debugPrint('⚠️ Color key "$key" not found, returning default color');
      return defaultColor;
    }

    try {
      // Remove the # prefix if exists
      String hexColor =
          colorStr.startsWith('#') ? colorStr.substring(1) : colorStr;

      if (hexColor.length == 6) {
        // Format: RRGGBB (no alpha)
        // Add FF for full opacity
        return Color(int.parse('FF$hexColor', radix: 16));
      } else if (hexColor.length == 8) {
        // Format: RRGGBBAA or AARRGGBB
        // Flutter uses ARGB format, so we need to check and rearrange if needed

        // Check if it's likely RRGGBBAA format by examining values
        final lastTwoChars = hexColor.substring(6, 8).toLowerCase();
        if (lastTwoChars == "ff") {
          // Last two chars are FF, likely an alpha value at the end (RRGGBBAA)
          final rgb = hexColor.substring(0, 6);
          final alpha = hexColor.substring(6, 8);
          return Color(int.parse('$alpha$rgb', radix: 16));
        } else {
          // Assume AARRGGBB format (standard order for hex colors with alpha)
          return Color(int.parse('$hexColor', radix: 16));
        }
      }

      debugPrint(
          '⚠️ Invalid color format "$colorStr" for key "$key", returning default color');
      return defaultColor;
    } catch (e) {
      debugPrint('❌ Error parsing color "$colorStr" for key "$key": $e');
      return defaultColor;
    }
  }

  /// 🔍 Get the search AppBar color from configuration
  ///
  /// Returns the search_app_bar_color from search_view_configuration if specified,
  /// or falls back to primary_color if search_app_bar_color isn't found
  ///
  /// Parameters:
  /// - [defaultColor]: Default color to return if no configuration is found
  ///
  /// Returns:
  /// - Color: The search AppBar color or default color
  Color getSearchAppBarColor([Color defaultColor = const Color(0xFF2196F3)]) {
    // First try to get the specific search AppBar color from search_view_configuration
    final String searchAppBarColorKey =
        'search_view_configuration.search_app_bar_color';
    if (hasKey(searchAppBarColorKey)) {
      return getColor(searchAppBarColorKey, defaultColor);
    }

    // Fall back to primary color if search AppBar color isn't specified
    return getColor('ui_configuration.primary_color', defaultColor);
  }

  /// 🔍 Get the search bar background color from configuration
  ///
  /// Returns the search_bar_background_color from search_view_configuration if specified,
  /// or falls back to a light gray color if search_bar_background_color isn't found
  ///
  /// Parameters:
  /// - [defaultColor]: Default color to return if no configuration is found
  ///
  /// Returns:
  /// - Color: The search bar background color or default color
  Color getSearchBarBackgroundColor(
      [Color defaultColor = const Color(0xFFF5F5F5)]) {
    // Try to get the specific search bar background color from search_view_configuration
    final String searchBarBackgroundColorKey =
        'search_view_configuration.search_bar_background_color';
    if (hasKey(searchBarBackgroundColorKey)) {
      return getColor(searchBarBackgroundColorKey, defaultColor);
    }

    // Fall back to default light gray if search bar background color isn't specified
    return defaultColor;
  }

  /// 🔍 Get the search bar border color from configuration
  ///
  /// Returns the search_bar_border_color if specified,
  /// or falls back to a light gray border color if search_bar_border_color isn't found
  ///
  /// Parameters:
  /// - [defaultColor]: Default color to return if no configuration is found
  ///
  /// Returns:
  /// - Color: The search bar border color or default color
  Color getSearchBarBorderColor(
      [Color defaultColor = const Color(0xFFE0E0E0)]) {
    // Try to get the specific search bar border color from search_view_configuration
    final String searchBarBorderColorKey =
        'search_view_configuration.search_bar_border_color';
    if (hasKey(searchBarBorderColorKey)) {
      return getColor(searchBarBorderColorKey, defaultColor);
    }

    // Fall back to default light gray border if search bar border color isn't specified
    return defaultColor;
  }

  /// 🔍 Get the search bar show clear button setting from configuration
  ///
  /// Returns the search_bar_show_clear_button from search_view_configuration if specified,
  /// or falls back to default value if not found
  ///
  /// Parameters:
  /// - [defaultValue]: Default boolean to return if no configuration is found
  ///
  /// Returns:
  /// - bool: Whether to show the clear button or default value
  bool getSearchBarShowClearButton([bool defaultValue = true]) {
    return getBool(
        'search_view_configuration.search_bar_show_clear_button', defaultValue);
  }

  /// 🔍 Get the search bar show search icon setting from configuration
  ///
  /// Returns the search_bar_show_search_icon from search_view_configuration if specified,
  /// or falls back to default value if not found
  ///
  /// Parameters:
  /// - [defaultValue]: Default boolean to return if no configuration is found
  ///
  /// Returns:
  /// - bool: Whether to show the search icon or default value
  bool getSearchBarShowSearchIcon([bool defaultValue = false]) {
    return getBool(
        'search_view_configuration.search_bar_show_search_icon', defaultValue);
  }

  // MARK: - Search View Configuration Methods

  /// 🔍 Get SearchView elevation from configuration
  double getSearchViewElevation([double defaultValue = 4.0]) {
    return getDouble('search_view_configuration.elevation', defaultValue);
  }

  /// 🔍 Get SearchView bar size from configuration
  String getSearchViewBarSize([String defaultValue = 'medium']) {
    return getString('search_view_configuration.search_bar_size', defaultValue);
  }

  /// 🔍 Get SearchView bar variant from configuration
  String getSearchViewBarVariant([String defaultValue = 'borderless']) {
    return getString(
        'search_view_configuration.search_bar_variant', defaultValue);
  }

  /// 🔍 Get SearchView border radius from configuration
  double getSearchViewBorderRadius([double defaultValue = 20.0]) {
    return getDouble(
        'search_view_configuration.search_bar_border_radius', defaultValue);
  }

  /// 🔍 Get SearchView title from configuration
  String getSearchViewTitle([String defaultValue = 'Search']) {
    return getString('search_view_configuration.title', defaultValue);
  }

  /// 🔍 Get SearchView hint from configuration
  String getSearchViewHint(
      [String defaultValue = 'Search products, brands, categories...']) {
    return getString('search_view_configuration.search_hint', defaultValue);
  }

  /// 🔍 Get SearchView show barcode scanner setting from configuration
  bool getSearchViewShowBarcodeScanner([bool defaultValue = true]) {
    return getBool(
        'search_view_configuration.show_barcode_scanner', defaultValue);
  }

  /// 🔍 Get SearchView show voice search setting from configuration
  bool getSearchViewShowVoiceSearch([bool defaultValue = true]) {
    return getBool('search_view_configuration.show_voice_search', defaultValue);
  }

  /// 🔍 Get SearchView show back button setting from configuration
  bool getSearchViewShowBackButton([bool defaultValue = true]) {
    return getBool('search_view_configuration.show_back_button', defaultValue);
  }

  /// 🔍 Get SearchView action icon color from configuration
  ///
  /// Returns the action_icon_color from search_view_configuration if specified,
  /// or falls back to pewter color if action_icon_color isn't found
  ///
  /// Parameters:
  /// - [defaultColor]: Default color to return if no configuration is found
  ///
  /// Returns:
  /// - Color: The search action icon color or default color
  Color getSearchViewActionIconColor([Color? defaultColor]) {
    final Color fallbackColor =
        defaultColor ?? const Color(0xFF6B7280); // OsmeaColors.pewter

    // Try to get the specific action icon color from search_view_configuration
    final String actionIconColorKey =
        'search_view_configuration.action_icon_color';
    if (hasKey(actionIconColorKey)) {
      return getColor(actionIconColorKey, fallbackColor);
    }

    // Fall back to pewter if action icon color isn't specified
    return fallbackColor;
  }

  /// 🔍 Get SearchView action button spacing from configuration
  double getSearchViewActionButtonSpacing([double defaultValue = 2.0]) {
    return getDouble(
        'search_view_configuration.action_button_spacing', defaultValue);
  }

  /// 🔍 Get SearchView action button min width from configuration
  double getSearchViewActionButtonMinWidth([double defaultValue = 32.0]) {
    return getDouble(
        'search_view_configuration.action_button_min_width', defaultValue);
  }

  /// 🔍 Get SearchView action button min height from configuration
  double getSearchViewActionButtonMinHeight([double defaultValue = 32.0]) {
    return getDouble(
        'search_view_configuration.action_button_min_height', defaultValue);
  }

  /// 🔍 Get SearchView action button padding from configuration
  double getSearchViewActionButtonPadding([double defaultValue = 4.0]) {
    return getDouble(
        'search_view_configuration.action_button_padding_all', defaultValue);
  }

  /// 🔍 Check if a key exists in the configuration
  ///
  /// Parameters:
  /// - [key]: The key path using dot notation
  ///
  /// Returns:
  /// - bool: true if the key exists, false otherwise
  bool hasKey(String key) {
    final dynamic value = _getValue(key);
    return value != null;
  }

  /// 📊 Get all configuration data as a Map
  ///
  /// Returns:
  /// - Map<String, dynamic>?: The entire configuration data or null if not loaded
  Map<String, dynamic>? getAllConfig() {
    return _currentConfig;
  }

  /// 📁 Get the path of the currently loaded configuration file
  ///
  /// Returns:
  /// - String?: The path of the current configuration file or null if not loaded
  String? getCurrentConfigPath() {
    return _currentConfigPath;
  }

  /// 🗑️ Clear the configuration cache
  ///
  /// This method clears all cached configuration data, forcing the next
  /// loadConfig call to read from the asset file again.
  void clearCache() {
    _configCache.clear();
    _currentConfig = null;
    _currentConfigPath = null;
    debugPrint('🗑️ Configuration cache cleared');
  }

  /// 🔄 Reload the current configuration from the asset file
  ///
  /// This method reloads the currently loaded configuration file,
  /// bypassing the cache.
  ///
  /// Returns:
  /// - Future<bool>: true if the configuration was reloaded successfully, false otherwise
  Future<bool> reloadConfig() async {
    if (_currentConfigPath == null) {
      debugPrint('❌ No configuration file is currently loaded');
      return false;
    }

    // Remove from cache to force reload
    _configCache.remove(_currentConfigPath);

    // Reload the configuration
    return await loadConfig(_currentConfigPath!);
  }

  /// 🔧 Private method to get a value using dot notation with auto-initialization
  ///
  /// This method traverses the configuration object using dot notation
  /// to retrieve nested values. If no configuration is loaded, it attempts
  /// to auto-initialize with the default path.
  ///
  /// Parameters:
  /// - [key]: The key path using dot notation (e.g., 'app_settings.app_name')
  ///
  /// Returns:
  /// - dynamic: The value at the specified key path or null if not found
  dynamic _getValue(String key) {
    // Auto-initialize if no config is loaded and not yet attempted
    if (_currentConfig == null && !_autoInitAttempted) {
      debugPrint('🔄 Auto-initializing configuration...');
      _autoInitAttempted = true;

      // Try to load default configuration synchronously (this will be cached for future use)
      // Note: We can't use async here, so we'll just mark as attempted and return null
      // The user should call loadConfig() explicitly for proper initialization
      debugPrint(
          '⚠️ No configuration loaded. Please call loadConfig() first or use await helper.loadConfig("assets/app_config.json")');
      return null;
    }

    if (_currentConfig == null) {
      return null;
    }

    final List<String> keyParts = key.split('.');
    dynamic current = _currentConfig;

    for (final String part in keyParts) {
      if (current is Map<String, dynamic> && current.containsKey(part)) {
        current = current[part];
      } else {
        debugPrint('🔍 Key path "$key" not found at part "$part"');
        return null;
      }
    }

    return current;
  }

  /// 📈 Get configuration statistics
  ///
  /// Returns:
  /// - Map<String, dynamic>: Statistics about the loaded configuration
  Map<String, dynamic> getConfigStats() {
    if (_currentConfig == null) {
      return {
        'loaded': false,
        'config_path': null,
        'total_keys': 0,
        'cache_size': _configCache.length,
        'auto_init_attempted': _autoInitAttempted,
        'config_source': null,
      };
    }

    // Determine config source
    String configSource = 'unknown';
    if (_currentConfigPath != null) {
      if (_currentConfigPath!.contains('packages/core/assets/')) {
        configSource = 'core_package_fallback';
      } else if (_currentConfigPath!.startsWith('assets/')) {
        configSource = 'project_specific';
      }
    }

    return {
      'loaded': true,
      'config_path': _currentConfigPath,
      'config_source': configSource,
      'total_keys': _countKeys(_currentConfig!),
      'cache_size': _configCache.length,
      'auto_init_attempted': _autoInitAttempted,
      'top_level_keys': _currentConfig!.keys.toList(),
    };
  }

  /// 🔢 Private method to count total keys in a nested Map
  ///
  /// This method recursively counts all keys in nested objects.
  ///
  /// Parameters:
  /// - [map]: The map to count keys in
  ///
  /// Returns:
  /// - int: The total number of keys
  int _countKeys(Map<String, dynamic> map) {
    int count = map.keys.length;
    for (final dynamic value in map.values) {
      if (value is Map<String, dynamic>) {
        count += _countKeys(value);
      }
    }
    return count;
  }
}
