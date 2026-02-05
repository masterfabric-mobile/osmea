// 🌐 API Dependency Injection Configuration
// This file sets up dependency injection for the APIs package using GetIt and Injectable.

import 'package:apis/apis.dart'; // 📦 Main APIs package
import 'package:apis/di/config/config_di.config.dart'; // ⚙️ Generated DI config
import 'package:apis/dio_config/dio_client/shopify_graphql_client.dart'; // 🔌 Shopify GraphQL Client
import 'package:apis/dio_config/dio_client/api_dio_client.dart'; // 🚀 API Dio Client
import 'package:apis/dio_config/dio_client/abstract/api_base_client.dart'; // 🌐 Abstract Base Client
import 'package:apis/dio_config/cookie_manager/web_cookie_manager.dart'; // 🍪 Web Cookie Manager
import 'package:get_it/get_it.dart'; // 🛠️ Service locator
import 'package:injectable/injectable.dart'; // 💉 Dependency injection
import 'package:logger/logger.dart'; // 📜 Logger for error handling
import 'package:flutter/foundation.dart'; // For FlutterError

// Create a logger instance for logging errors
final Logger logger = Logger();

/// 🚀 Initializes and configures all dependencies for the APIs package.
///
/// Call this function at app startup to ensure all services are ready to use.
///
/// Returns the configured [GetIt] instance for service locator.
@InjectableInit(preferRelativeImports: false)
GetIt configureDependencies() {
  try {
    final getIt = ApiNetwork.getIt;

    // 🏗️ Initialize dependencies using the generated config only if not already initialized
    // Check if key services are already registered to avoid duplicate registration
    if (!getIt.isRegistered<ApiBaseClient>()) {
      getIt.init();
      logger.i('🏗️ Dependencies initialized using generated config');
    } else {
      logger.i('⚠️ Dependencies already initialized, skipping init()');
    }

    // 🔌 Register services manually if needed
    _registerServices(getIt);

    // 🍪 Initialize cookie jar and storage resources asynchronously
    _initializeCookieJarAsync();

    return getIt;
  } catch (e) {
    // Log the error if dependency initialization fails
    logger.e('Failed to configure dependencies: $e');

    // Handle specific exceptions
    if (e is FlutterError) {
      logger.e('Flutter error occurred: ${e.message}');
    } else if (e is Exception) {
      logger.e('General exception occurred: ${e.toString()}');
    } else {
      logger.e('An unknown error occurred: ${e.toString()}');
    }

    rethrow; // Rethrow the error after logging
  }
}

/// 🍪 Initialize cookie jar asynchronously (non-blocking)
void _initializeCookieJarAsync() {
  _initializeCookieJar().catchError((e) {
    logger.e('Async cookie jar initialization failed: $e');
  });
}

/// 🍪 Synchronous version for cases where cookie jar must be ready
Future<GetIt> configureDependenciesAsync() async {
  try {
    final getIt = ApiNetwork.getIt;

    // 🏗️ Initialize dependencies using the generated config only if not already initialized
    // Check if key services are already registered to avoid duplicate registration
    if (!getIt.isRegistered<ApiBaseClient>()) {
      getIt.init();
      logger.i('🏗️ Dependencies initialized using generated config');
    } else {
      logger.i('⚠️ Dependencies already initialized, skipping init()');
    }

    // 🔌 Register services manually if needed
    _registerServices(getIt);

    // 🍪 Initialize cookie jar and storage resources synchronously
    await _initializeCookieJar();

    return getIt;
  } catch (e) {
    // Log the error if dependency initialization fails
    logger.e('Failed to configure dependencies: $e');

    // Handle specific exceptions
    if (e is FlutterError) {
      logger.e('Flutter error occurred: ${e.message}');
    } else if (e is Exception) {
      logger.e('General exception occurred: ${e.toString()}');
    } else {
      logger.e('An unknown error occurred: ${e.toString()}');
    }

    rethrow; // Rethrow the error after logging
  }
}

/// 🍪 Initialize cookie jar and storage resources
Future<void> _initializeCookieJar() async {
  try {
    logger.i('🍪 Initializing cookie jar and storage resources...');

    // Initialize API Dio Client resources (including cookie preparation)
    await ApiDioClient().prepareResources();

    // Log platform-specific cookie initialization
    if (kIsWeb) {
      logger.i(
          '🌐 Web platform detected - using WebCookieManager for localStorage');
    } else {
      logger.i('📱 Mobile platform detected - using traditional CookieManager');
    }

    logger.i('✅ Cookie jar initialization completed successfully');
  } catch (e) {
    logger.e('❌ Failed to initialize cookie jar: $e');
    // Don't rethrow here as cookie initialization failure shouldn't break the app
  }
}

/// 🔌 Manually register services if auto-registration fails
void _registerServices(GetIt getIt) {
  try {
    // Shopify GraphQL Client
    if (!getIt.isRegistered<GraphQLBaseClient>()) {
      getIt.registerSingleton<GraphQLBaseClient>(ShopifyGraphQLClient());
    }

    // API Dio Client
    if (!getIt.isRegistered<ApiBaseClient>()) {
      getIt.registerSingleton<ApiBaseClient>(ApiDioClient());
    }

    // 🍪 Register Cookie Managers
    _registerCookieManagers(getIt);

    logger.i(
        'GraphQL, API services, and Cookie Managers registered successfully');
  } catch (e) {
    logger.w('Some services could not be registered: $e');
  }
}

/// 🍪 Register cookie managers for dependency injection
void _registerCookieManagers(GetIt getIt) {
  try {
    // Register WebCookieManager for web platform
    if (kIsWeb) {
      if (!getIt.isRegistered<WebCookieManager>()) {
        getIt.registerSingleton<WebCookieManager>(WebCookieManager());
        logger.i('🌐 WebCookieManager registered for web platform');
      }
    }

    // Note: Traditional CookieManager is already registered in ApiDioClient
    // as static instances, so no additional registration needed

    logger.i('✅ Cookie managers registration completed');
  } catch (e) {
    logger.w('Some cookie managers could not be registered: $e');
  }
}
