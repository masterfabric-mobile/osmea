import 'package:core/core.dart';
import 'package:apis/apis.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:storefront_woo/app/core/config/config_di.config.dart';
import 'package:flutter/foundation.dart';

GetIt getIt = GetIt.instance;

@InjectableInit(preferRelativeImports: false)
Future<GetIt> configureDependencies({String? environment}) async {
  try {
    debugPrint('🔧 Configuring dependencies for environment: $environment');

    // Initialize core dependencies
    getIt = await Core().init(getIt);
    debugPrint('✅ Core dependencies initialized');

    // Initialize APIs package dependencies
    await _initializeApisPackage(environment);
    debugPrint('✅ APIs package dependencies initialized');

    // Initialize app-specific dependencies
    final result = getIt.init(environment: environment);
    debugPrint('✅ App dependencies initialized');

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

    // Get configuration from app_config.json
    final AssetConfigHelper configHelper = AssetConfigHelper();
    await configHelper.loadConfig('assets/app_config.json');

    final storeUrl = configHelper.getString(
      'woocommerce_configuration.store_url',
      '',
    );
    final brandName = configHelper.getString(
      'woocommerce_configuration.brand_name',
      'simple-jwt-login',
    );
    final apiVersion = configHelper.getString(
      'woocommerce_configuration.version',
      'v3',
    );

    if (storeUrl.isNotEmpty && brandName.isNotEmpty) {
      // Initialize WooCommerce network
      debugPrint('🔧 Initializing WooCommerce with JWT Auth:');
      debugPrint('  - Store URL: $storeUrl');
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
