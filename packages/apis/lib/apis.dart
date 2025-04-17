library apis;

// 🌐 Dependency Injection & Utilities
import 'package:apis/di/config/config_di.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

/// 🛠️ Provides a singleton [Logger] instance for the whole app.
/// 
/// Use this logger for consistent logging across your project!
@module
abstract class DioLoggerModule {
  @Singleton()
  Logger get logger => Logger();
}

/// 🚀 API Network Configuration & Dependency Management
/// 
/// This class manages Shopify API network configuration, dependency injection,
/// and runtime updates for your app's network layer.
class ApiNetwork {
  // 🏗️ Service locator instance (for dependency injection)
  static GetIt getIt = GetIt.instance;

  // 🏬 Shopify Store Name (used to build the base URL)
  static String storeName = '';

  // 🛡️ Proxy IP (optional, for advanced networking)
  static String proxyIp = '';

  // 🔑 Shopify Access Token (optional, for authentication)
  static String shopifyAccessToken = '';

  // 🕵️‍♂️ Interceptor for requests (custom logic before each request)
  static Future<void> Function() onRequestInterceptor = () async {};

  /// 🏁 Initialize the API network layer.
  /// 
  /// [getIt]: The GetIt instance for dependency injection.
  /// [storeName]: Your Shopify store name (e.g., 'examplestore').
  /// [proxyIp]: Optional proxy IP for debugging or routing.
  /// [shopifyAccessToken]: Optional Shopify access token for authentication.
  static GetIt init(
    GetIt getIt,
    { required String storeName,
    String? proxyIp,
    String? shopifyAccessToken,
  }) {
    // ⚠️ Make sure to set storeName and shopifyAccessToken before making requests!
    ApiNetwork.getIt = getIt;
    ApiNetwork.storeName = storeName;
    ApiNetwork.proxyIp = proxyIp ?? '';
    ApiNetwork.shopifyAccessToken = shopifyAccessToken ?? '';

    // 🧩 Register dependencies (see /di/config/config_di.dart)
    configureDependencies();
    return getIt;
  }

  /// 🌍 Computed Shopify Admin API base URL.
  /// 
  /// Example: https://yourstore.myshopify.com/admin
  static String get baseUrl {
    // ⚠️ If storeName is empty, requests will fail!
    if (ApiNetwork.storeName.isEmpty) {
      throw Exception("Store name is not set! Please initialize ApiNetwork with a valid store name. 🏬");
    }
    return 'https://${ApiNetwork.storeName}.myshopify.com/admin';
  }

  /// 🔄 Update the Shopify Store Name at runtime.
  /// 
  /// Useful if you want to switch stores without restarting the app.
  static void updateStoreName(String storeName) {
    ApiNetwork.storeName = storeName;
  }

  /// 🔄 Update the proxy IP at runtime.
  static void updateProxyIp(String proxyIp) {
    ApiNetwork.proxyIp = proxyIp;
  }

  /// 🔄 Update the Shopify Access Token at runtime.
  static void updateShopifyAccessToken(String token) {
    ApiNetwork.shopifyAccessToken = token;
  }

  /// 🛡️ Set a custom interceptor for API requests.
  /// 
  /// [onRequestInInterceptor]: Async function to run before each request.
  /// Example: Add custom headers, logging, etc.
  static void initOnRequestInterceptor({
    required Future<void> Function() onRequestInInterceptor,
  }) {
    ApiNetwork.onRequestInterceptor = onRequestInInterceptor;
  }
}