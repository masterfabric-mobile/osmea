import 'package:core/core.dart';
import 'package:apis/apis.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:storefront_woo/app/core/config/config_di.config.dart';
import 'package:storefront_woo/app/views/view_wishlist/models/wishlist_view_model.dart';
import 'package:flutter/foundation.dart';

GetIt getIt = GetIt.instance;

@InjectableInit(preferRelativeImports: false)
Future<GetIt> configureDependencies({String? environment}) async {
  try {
    debugPrint('🔧 Configuring dependencies for environment: $environment');

    // Initialize core dependencies FIRST (Logger is registered here)
    // APIs package needs Logger which is registered in core
    getIt = await Core().init(getIt);
    debugPrint('✅ Core dependencies initialized');

    // Initialize APIs package dependencies AFTER core
    // WooNetwork.init() calls configureDependencies which needs Logger
    await _initializeApisPackage(environment);
    debugPrint('✅ APIs package dependencies initialized');

    // Initialize app-specific dependencies
    final result = getIt.init(environment: environment);
    debugPrint('✅ App dependencies initialized');

    // Override WishlistViewModel to be singleton (shared state across app)
    // This ensures all parts of the app use the same wishlist instance
    // Note: WishlistViewModel is registered as factory by injectable,
    // but we override it to be singleton for shared state
    try {
      if (getIt.isRegistered<WishlistViewModel>()) {
        getIt.unregister<WishlistViewModel>();
      }
      getIt.registerLazySingleton<WishlistViewModel>(() => WishlistViewModel());
      debugPrint('✅ WishlistViewModel registered as singleton');
    } catch (e) {
      debugPrint('⚠️ Could not register WishlistViewModel as singleton: $e');
      // Continue - factory registration will be used
    }

    return result;
  } catch (e, stackTrace) {
    debugPrint('❌ Error configuring dependencies: $e');
    debugPrint('Stack trace: $stackTrace');
    rethrow;
  }
}

/// Initialize APIs package with environment-based configuration
Future<void> _initializeApisPackage(String? environment) async {
  try {
    // Initialize APIs package dependencies
    await _initializeFromEnvironment(environment);
    debugPrint('✅ APIs package dependencies initialized');
  } catch (e) {
    debugPrint('❌ Error initializing APIs package: $e');
    rethrow;
  }
}

/// Initialize APIs package from app configuration
Future<void> _initializeFromEnvironment(String? environment) async {
  try {
    debugPrint('🔧 Initializing WooCommerce from app configuration...');

    // Get configuration from AssetConfigHelper
    // WordPress merged config is already set in starter.dart via setConfig()
    // We should use that config if available, otherwise fallback to local
    final AssetConfigHelper configHelper = AssetConfigHelper();
    
    // Check if WordPress config is already set (from starter.dart)
    final currentConfigPath = configHelper.getCurrentConfigPath();
    final isWordPressConfig = currentConfigPath == 'wordpress_merged_config';
    
    if (isWordPressConfig) {
      debugPrint('🌐 Using WordPress merged configuration');
    } else if (configHelper.getAllConfig() == null) {
      // Only load local config if WordPress config is not set and no config is loaded
      debugPrint('📦 Loading local configuration (WordPress config not available)');
      await configHelper.loadConfig('assets/app_config.json');
    } else {
      debugPrint('📂 Using existing configuration');
    }

    var storeUrl = configHelper.getString(
      'woocommerce_configuration.store_url',
      '',
    ).trim();
    
    // Normalize URL: Fix common formatting issues
    if (storeUrl.isNotEmpty) {
      // Fix missing slash after http: or https: (e.g., http:/example.com -> http://example.com)
      if (storeUrl.startsWith('http:/') && !storeUrl.startsWith('http://')) {
        storeUrl = storeUrl.replaceFirst('http:/', 'http://');
      } else if (storeUrl.startsWith('https:/') && !storeUrl.startsWith('https://')) {
        storeUrl = storeUrl.replaceFirst('https:/', 'https://');
      }
      
      // Remove trailing slash if present
      if (storeUrl.endsWith('/')) {
        storeUrl = storeUrl.substring(0, storeUrl.length - 1);
      }
    }
    
    final brandName = configHelper.getString(
      'woocommerce_configuration.brand_name',
      'simple-jwt-login',
    );
    final apiVersion = configHelper.getString(
      'woocommerce_configuration.version',
      'v3',
    );

    if (storeUrl.isNotEmpty && brandName.isNotEmpty) {
      // Validate URL format
      try {
        final uri = Uri.tryParse(storeUrl);
        if (uri == null || (uri.scheme != 'http' && uri.scheme != 'https')) {
          throw Exception('Invalid URL format: $storeUrl');
        }
      } catch (e) {
        debugPrint('❌ Invalid store URL format: $storeUrl');
        debugPrint('   Error: $e');
        throw Exception('Invalid WooCommerce store URL format: $storeUrl');
      }
      
      // Initialize WooCommerce network
      debugPrint('🔧 Initializing WooCommerce with JWT Auth:');
      debugPrint('  - Store URL: $storeUrl (normalized)');
      debugPrint('  - Brand Name (JWT Plugin): $brandName');
      debugPrint('  - API Version: $apiVersion');
      debugPrint('  - Auth Method: JWT (No consumer key/secret needed)');

      // Initialize WooCommerce network for JWT auth (no credentials needed)
      WooNetwork.init(
        getIt,
        storeUrl: storeUrl,
        storeName: brandName,
        username: '', // Not needed for JWT auth
        password: '', // Not needed for JWT auth
        apiVersion: apiVersion,
      );

      debugPrint('✅ WooCommerce network initialized for JWT Auth');
    } else {
      debugPrint('❌ Missing required configuration:');
      debugPrint('  - Store URL: ${storeUrl.isEmpty ? 'MISSING' : 'OK'}');
      debugPrint('  - Brand Name: ${brandName.isEmpty ? 'MISSING' : 'OK'}');
      throw Exception(
        'Required WooCommerce configuration (store_url, brand_name) is missing',
      );
    }
  } catch (e) {
    debugPrint('❌ Error initializing from app configuration: $e');
    rethrow;
  }
}
