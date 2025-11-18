import 'package:core/core.dart';
import 'package:apis/apis.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:storefront_woo/app/core/config/config_di.config.dart';
import 'package:storefront_woo/app/views/view_wishlist/models/wishlist_view_model.dart';
import 'package:flutter/foundation.dart';
import 'package:apis/network/remote/woocommerce/auth/abstract/woo_auth_service.dart';

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

    // Override AccountCubit to inject getUsersMe callback for fresh API calls
    // This ensures profile data is always fresh (user can update their info)
    try {
      debugPrint('🔍 storefront_woo DI: Checking AccountCubit registration...');
      debugPrint('🔍 storefront_woo DI: AccountCubit isRegistered: ${getIt.isRegistered<AccountCubit>()}');
      if (getIt.isRegistered<AccountCubit>()) {
        debugPrint('🔍 storefront_woo DI: Unregistering existing AccountCubit...');
        getIt.unregister<AccountCubit>();
        debugPrint('✅ storefront_woo DI: AccountCubit unregistered');
      }
      debugPrint('🔍 storefront_woo DI: Registering AccountCubit with getUsersMe callback...');
      getIt.registerFactory<AccountCubit>(() {
        debugPrint('🔍 storefront_woo DI: AccountCubit factory called');
        // Try to get AuthCubit from GetIt if registered
        AuthCubit? authCubit;
        try {
          if (getIt.isRegistered<AuthCubit>()) {
            authCubit = getIt<AuthCubit>();
            debugPrint('✅ storefront_woo DI: AuthCubit found');
          } else {
            debugPrint('⚠️ storefront_woo DI: AuthCubit not registered');
          }
        } catch (e) {
          debugPrint('⚠️ AccountCubit DI: AuthCubit not available: $e');
        }

        // Create getUsersMe callback that calls API directly
        // IMPORTANT: Return name as-is from API, do NOT process it
        Future<Map<String, dynamic>?> getUsersMeCallback() async {
          try {
            debugPrint('🔍 AccountCubit DI: getUsersMe callback called');
            final jwtToken = await WooJwtTokenStorage.loadToken();
            if (jwtToken != null && jwtToken.accessToken.isNotEmpty) {
              debugPrint('🔍 AccountCubit DI: JWT token found, calling API...');
              final authService = getIt<WooAuthService>();
              final authHeader = 'Bearer ${jwtToken.accessToken}';
              final userMeResponse = await authService.getUsersMe(authHeader);
              
              debugPrint('✅ AccountCubit DI: getUsersMe API call successful');
              debugPrint('👤 AccountCubit DI: User name from API (raw): "${userMeResponse.name}"');
              debugPrint('👤 AccountCubit DI: User name type: ${userMeResponse.name.runtimeType}');
              
              // Return name as-is from API response - NO processing
              final result = {
                'id': userMeResponse.id,
                'name': userMeResponse.name, // Use name directly, no processing
                'url': userMeResponse.url,
                'description': userMeResponse.description,
                'link': userMeResponse.link,
                'slug': userMeResponse.slug,
                'avatar_urls': userMeResponse.avatarUrls?.toJson(),
                'is_super_admin': userMeResponse.isSuperAdmin,
                'woocommerce_meta': userMeResponse.woocommerceMeta?.toJson(),
              };
              
              debugPrint('👤 AccountCubit DI: Returning result with name: "${result['name']}"');
              return result;
            } else {
              debugPrint('⚠️ AccountCubit DI: No JWT token found');
            }
          } catch (e, stackTrace) {
            debugPrint('⚠️ AccountCubit DI: Error calling getUsersMe API: $e');
            debugPrint('⚠️ AccountCubit DI: Stack trace: $stackTrace');
          }
          return null;
        }

        debugPrint('🔍 storefront_woo DI: Creating AccountCubit with callback...');
        final accountCubit = AccountCubit(
          authCubit: authCubit,
          getUsersMeCallback: getUsersMeCallback,
        );
        debugPrint('✅ storefront_woo DI: AccountCubit created with callback');
        return accountCubit;
      });
      debugPrint('✅ AccountCubit registered with getUsersMe callback in storefront_woo DI');
    } catch (e) {
      debugPrint('⚠️ Could not register AccountCubit with callback: $e');
      // Continue - core registration will be used
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
