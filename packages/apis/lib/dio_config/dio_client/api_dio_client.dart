import 'dart:io' show Directory, HttpClient, X509Certificate;
import 'package:apis/apis.dart';
import 'package:apis/dio_config/dio_client/abstract/api_base_client.dart';
import 'package:apis/dio_config/interceptors/api_interceptor_default.dart';
import 'package:apis/dio_config/cookie_manager/web_cookie_manager.dart';
import 'package:apis/dio_config/interceptors/woo_jwt_interceptor.dart';
import 'package:apis/services/auth/woo_jwt_auth_service.dart';
import 'package:apis/services/auth/woo_jwt_signin_manager.dart';
import 'package:apis/models/auth/woo_jwt_token.dart';
// ignore: depend_on_referenced_packages
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';

/// 🌐 Provides Dio instance for dependency injection
@module
abstract class DioModule {
  @singleton
  Dio dio() => Dio();
}

/// 🚀 Main API Dio Client for handling network requests, cookies, and proxy settings
@Singleton(as: ApiBaseClient)
class ApiDioClient implements ApiBaseClient {
  // 🍪 Cookie managers for different use-cases
  static CookieManager cookieJar = CookieManager(PersistCookieJar());
  static CookieManager cookieJarPersonaClick =
      CookieManager(PersistCookieJar());

  // 🌐 Web-compatible cookie manager using localStorage
  static WebCookieManager webCookieManager = WebCookieManager();

  /// 🏁 Creates and configures a Dio instance with default options and interceptors
  @override
  Dio starter() {
    final dio = Dio()
      ..options = BaseOptions(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      )
      ..options.responseType = ResponseType.json
      ..interceptors.add(ApiInterceptorDefault(
        shopifyAccessToken: ApiNetwork.shopifyAccessToken,
      ));
    // ..interceptors.add(cookieJar); // Uncomment to enable cookie management
    setupProxySettings(dio);
    return dio;
  }

  /// 🛒 Creates a specialized Dio instance for WooCommerce API communication with JWT and cookie support
  static Dio wooDio({bool useJwtAuth = true}) {
    final dio = Dio()
      ..options = BaseOptions(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      )
      ..options.responseType = ResponseType.json;

    // 🔐 Add JWT authentication interceptor
    if (useJwtAuth) {
      try {
        final authService = WooJwtAuthService(dio);
        final jwtInterceptor = WooJwtEnhancedInterceptor(authService);
        dio.interceptors.add(jwtInterceptor);
        debugPrint('🔐 JWT authentication enabled for WooCommerce');
      } catch (e) {
        debugPrint(
            '⚠️ Failed to add JWT interceptor, falling back to Basic Auth: $e');
        dio.interceptors.add(WooInterceptor()); // Fallback to Basic Auth
      }
    } else {
      // Use traditional Basic Auth
      dio.interceptors.add(WooInterceptor());
      debugPrint('🔑 Basic Auth enabled for WooCommerce');
    }

    // 🍪 Add cookie management based on platform
    if (kIsWeb) {
      // Use web-compatible cookie manager for web platform
      dio.interceptors.add(webCookieManager);
    } else {
      // Use traditional cookie jar for mobile platforms
      dio.interceptors.add(cookieJar);
    }

    // 🛒 Add cart token interceptor for cart operations
    try {
      final cartTokenInterceptor = WooCartTokenInterceptor();
      dio.interceptors.add(cartTokenInterceptor);
      debugPrint('🛒 Cart token interceptor enabled for WooCommerce');
    } catch (e) {
      debugPrint('⚠️ Failed to add cart token interceptor: $e');
    }

    _proxySettingsForQA(dio);
    return dio;
  }

  /// 🔐 Creates a WooCommerce Dio instance specifically for JWT authentication
  static Dio wooJwtAuthDio() {
    final dio = Dio()
      ..options = BaseOptions()
      ..options.responseType = ResponseType.json;

    // Add JWT authentication service and interceptor
    try {
      final authService = WooJwtAuthService(dio);
      final jwtInterceptor = WooJwtInterceptor(authService);
      dio.interceptors.add(jwtInterceptor);
      debugPrint('🔐 JWT-only authentication enabled for WooCommerce');
    } catch (e) {
      debugPrint('❌ Failed to add JWT interceptor: $e');
      rethrow;
    }

    _proxySettingsForQA(dio);
    return dio;
  }

  /// 🛍️ Creates a basic WooCommerce Dio instance without authentication for public APIs
  /// Use this for endpoints that don't require authentication like products, categories, etc.
  static Dio wooPublicDio() {
    final dio = Dio()
      ..options = BaseOptions(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      )
      ..options.responseType = ResponseType.json;

    // 🍪 Add cookie management based on platform (for session tracking if needed)
    if (kIsWeb) {
      // Use web-compatible cookie manager for web platform
      dio.interceptors.add(webCookieManager);
    } else {
      // Use traditional cookie jar for mobile platforms
      dio.interceptors.add(cookieJar);
    }

    // 🛒 Add cart token interceptor for cart operations (even public carts need tokens)
    try {
      final cartTokenInterceptor = WooCartTokenInterceptor();
      dio.interceptors.add(cartTokenInterceptor);
      debugPrint('🛒 Cart token interceptor enabled for public WooCommerce');
    } catch (e) {
      debugPrint('⚠️ Failed to add cart token interceptor: $e');
    }

    _proxySettingsForQA(dio);
    debugPrint('🛍️ Public WooCommerce Dio client configured (no auth)');
    return dio;
  }

  /// 🛡️ Sets up proxy settings for QA environments (if proxy IP is provided)
  @override
  void setupProxySettings(Dio dio) {
    // 🌐 Web platform doesn't support HttpClient configuration
    if (kIsWeb) {
      return;
    }

    final String proxyIp = ApiNetwork.proxyIp;
    if (proxyIp.isNotEmpty) {
      dio.httpClientAdapter = IOHttpClientAdapter(
        createHttpClient: () {
          final client = HttpClient();
          client.findProxy = (uri) {
            // 🖧 Route all requests through the specified proxy
            return 'PROXY $proxyIp';
          };
          // ⚠️ Disable certificate validation for QA/testing only!
          client.badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;
          return client;
        },
      );
    } else {
      // 🍎 macOS-specific configuration for better network compatibility
      dio.httpClientAdapter = IOHttpClientAdapter(
        createHttpClient: () {
          final client = HttpClient();

          // Set connection timeout and other macOS-specific settings
          client.connectionTimeout = const Duration(seconds: 30);
          client.idleTimeout = const Duration(seconds: 30);

          // Enable automatic decompression
          client.autoUncompress = true;

          return client;
        },
      );
    }
  }

  /// 📂 Prepares persistent cookie storage in the app's document directory
  @override
  Future<void> prepareResources() async {
    // 🌐 Web platform doesn't support file-based cookie storage
    if (kIsWeb) {
      return;
    }

    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String appDocPath = appDocDir.path;
    cookieJar = CookieManager(PersistCookieJar(
      ignoreExpires: true,
      storage: FileStorage("$appDocPath/.cookies/"),
    ));
    // 🍪 Now cookies will persist between app launches!
  }

  /// 🗑️ Disposes any resources
  @override
  void dispose() {
    // No cleanup needed for static Dio instances
  }

  /// 🛡️ Legacy proxy settings method (kept for backward compatibility)
  static void _proxySettingsForQA(Dio dio) {
    // 🌐 Web platform doesn't support HttpClient configuration
    if (kIsWeb) {
      return;
    }

    final String proxyIp = ApiNetwork.proxyIp;
    if (proxyIp.isNotEmpty) {
      dio.httpClientAdapter = IOHttpClientAdapter(
        createHttpClient: () {
          final client = HttpClient();
          client.findProxy = (uri) {
            // 🖧 Route all requests through the specified proxy
            return 'PROXY $proxyIp';
          };
          // ⚠️ Disable certificate validation for QA/testing only!
          client.badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;
          return client;
        },
      );
    } else {
      // 🍎 macOS-specific configuration for better network compatibility
      dio.httpClientAdapter = IOHttpClientAdapter(
        createHttpClient: () {
          final client = HttpClient();

          // Set connection timeout and other macOS-specific settings
          client.connectionTimeout = const Duration(seconds: 30);
          client.idleTimeout = const Duration(seconds: 30);

          // Enable automatic decompression
          client.autoUncompress = true;

          return client;
        },
      );
    }
  }

  /// 📂 Legacy cookie preparation method (kept for backward compatibility)
  static Future<void> prepareCookiesJar() async {
    // 🌐 Web platform doesn't support file-based cookie storage
    if (kIsWeb) {
      return;
    }

    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String appDocPath = appDocDir.path;
    cookieJar = CookieManager(PersistCookieJar(
      ignoreExpires: true,
      storage: FileStorage("$appDocPath/.cookies/"),
    ));
    // 🍪 Now cookies will persist between app launches!
  }

  /// 🍪 Clear all cookies (works on both web and mobile)
  static Future<void> clearAllCookies() async {
    if (kIsWeb) {
      await webCookieManager.clearCookies();
    } else {
      // For mobile, we would need to clear the cookie jar
      // This is a simplified approach - in practice you might want to
      // implement a more sophisticated cookie clearing mechanism
      debugPrint('🍪 Cookie clearing for mobile platforms not implemented yet');
    }
  }

  /// 🍪 Get all cookies (works on both web and mobile)
  static Future<Map<String, String>> getAllCookies() async {
    if (kIsWeb) {
      return await webCookieManager.getAllCookies();
    } else {
      // For mobile, return empty map for now
      // In practice, you might want to implement cookie retrieval
      debugPrint(
          '🍪 Cookie retrieval for mobile platforms not implemented yet');
      return {};
    }
  }

  /// 🍪 Check if a specific cookie exists
  static Future<bool> hasCookie(String name) async {
    if (kIsWeb) {
      return await webCookieManager.hasCookie(name);
    } else {
      // For mobile, return false for now
      debugPrint('🍪 Cookie checking for mobile platforms not implemented yet');
      return false;
    }
  }

  /// 🍪 Get a specific cookie value
  static Future<String?> getCookie(String name) async {
    if (kIsWeb) {
      return await webCookieManager.getCookie(name);
    } else {
      // For mobile, return null for now
      debugPrint(
          '🍪 Cookie retrieval for mobile platforms not implemented yet');
      return null;
    }
  }

  /// 🔐 Authenticate user with WooCommerce JWT
  static Future<WooJwtToken> authenticateUser({
    required String username,
    required String password,
  }) async {
    try {
      final authDio = wooJwtAuthDio();
      final authService = WooJwtAuthService(authDio);

      debugPrint('🔐 Starting WooCommerce JWT authentication...');
      final token = await authService.authenticate(
        username: username,
        password: password,
      );

      debugPrint('✅ JWT authentication successful');
      return token;
    } catch (e) {
      debugPrint('❌ JWT authentication failed: $e');
      rethrow;
    }
  }

  /// 🔄 Refresh JWT token
  static Future<WooJwtToken> refreshJwtToken() async {
    try {
      final authDio = wooJwtAuthDio();
      final authService = WooJwtAuthService(authDio);

      debugPrint('🔄 Refreshing JWT token...');
      final token = await authService.refreshToken();

      debugPrint('✅ JWT token refreshed successfully');
      return token;
    } catch (e) {
      debugPrint('❌ JWT token refresh failed: $e');
      rethrow;
    }
  }

  /// 🚪 Logout user and clear JWT token
  static Future<void> logoutUser() async {
    try {
      final authDio = wooJwtAuthDio();
      final authService = WooJwtAuthService(authDio);

      debugPrint('🚪 Logging out user...');
      await authService.logout();

      debugPrint('✅ User logged out successfully');
    } catch (e) {
      debugPrint('❌ Logout failed: $e');
      rethrow;
    }
  }

  /// 🔍 Check if user is authenticated with JWT
  static Future<bool> isUserAuthenticated() async {
    try {
      final authDio = wooJwtAuthDio();
      final authService = WooJwtAuthService(authDio);

      return await authService.isAuthenticated();
    } catch (e) {
      debugPrint('❌ Authentication check failed: $e');
      return false;
    }
  }

  /// 📊 Get JWT authentication status
  static Future<Map<String, dynamic>> getJwtAuthStatus() async {
    try {
      final authDio = wooJwtAuthDio();
      final authService = WooJwtAuthService(authDio);

      return await authService.getAuthStatus();
    } catch (e) {
      debugPrint('❌ Failed to get JWT auth status: $e');
      return {
        'isAuthenticated': false,
        'hasToken': false,
        'needsRefresh': false,
        'error': e.toString(),
      };
    }
  }

  /// 🔄 Auto-refresh JWT token if needed
  static Future<WooJwtToken?> autoRefreshJwtIfNeeded() async {
    try {
      final authDio = wooJwtAuthDio();
      final authService = WooJwtAuthService(authDio);

      return await authService.autoRefreshIfNeeded();
    } catch (e) {
      debugPrint('❌ Auto-refresh failed: $e');
      return null;
    }
  }

  /// 📋 Get current user info from JWT
  static Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      final authDio = wooJwtAuthDio();
      final authService = WooJwtAuthService(authDio);

      return await authService.getCurrentUser();
    } catch (e) {
      debugPrint('❌ Failed to get current user: $e');
      return null;
    }
  }

  /// 🔐 Easy sign-in with automatic JWT storage
  static Future<WooJwtSignInResult> signInUser({
    required String username,
    required String password,
  }) async {
    try {
      debugPrint('🔐 Starting easy sign-in process...');

      final result = await WooJwtSignInManager.instance.signIn(
        username: username,
        password: password,
      );

      if (result.isSuccess) {
        debugPrint(
            '✅ Easy sign-in successful - JWT token saved to local storage');
      } else {
        debugPrint('❌ Easy sign-in failed: ${result.message}');
      }

      return result;
    } catch (e) {
      debugPrint('❌ Easy sign-in error: $e');
      return WooJwtSignInResult.failure(
        error: e.toString(),
        message: 'Sign-in failed: $e',
      );
    }
  }

  /// 🚪 Easy sign-out with automatic JWT cleanup
  static Future<WooJwtSignOutResult> signOutUser() async {
    try {
      debugPrint('🚪 Starting easy sign-out process...');

      final result = await WooJwtSignInManager.instance.signOut();

      if (result.isSuccess) {
        debugPrint(
            '✅ Easy sign-out successful - JWT token cleared from local storage');
      } else {
        debugPrint('❌ Easy sign-out failed: ${result.message}');
      }

      return result;
    } catch (e) {
      debugPrint('❌ Easy sign-out error: $e');
      return WooJwtSignOutResult.failure(
        error: e.toString(),
        message: 'Sign-out failed: $e',
      );
    }
  }

  /// 🔍 Check if user is signed in
  static Future<bool> isUserSignedIn() async {
    try {
      return await WooJwtSignInManager.instance.isSignedIn();
    } catch (e) {
      debugPrint('❌ Error checking sign-in status: $e');
      return false;
    }
  }

  /// 📊 Get comprehensive sign-in status
  static Future<WooJwtSignInStatus> getSignInStatus() async {
    try {
      return await WooJwtSignInManager.instance.getSignInStatus();
    } catch (e) {
      debugPrint('❌ Error getting sign-in status: $e');
      return WooJwtSignInStatus(
        isSignedIn: false,
        hasToken: false,
        isExpired: true,
        needsRefresh: false,
        error: e.toString(),
      );
    }
  }

  /// 🔄 Auto-refresh token if needed
  static Future<bool> autoRefreshTokenIfNeeded() async {
    try {
      return await WooJwtSignInManager.instance.autoRefreshIfNeeded();
    } catch (e) {
      debugPrint('❌ Auto-refresh error: $e');
      return false;
    }
  }

  /// 📈 Get JWT storage statistics
  static Future<Map<String, dynamic>> getJwtStorageStats() async {
    try {
      return await WooJwtSignInManager.instance.getStorageStats();
    } catch (e) {
      debugPrint('❌ Error getting storage stats: $e');
      return {'error': e.toString()};
    }
  }

  /// 🧹 Clean up expired JWT tokens
  static Future<void> cleanupExpiredJwtTokens() async {
    try {
      await WooJwtSignInManager.instance.cleanupExpiredTokens();
    } catch (e) {
      debugPrint('❌ Error cleaning up expired tokens: $e');
    }
  }
}
