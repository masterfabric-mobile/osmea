import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:apis/apis.dart';
import 'package:apis/models/auth/woo_jwt_token.dart';
import 'package:apis/services/auth/woo_jwt_auth_service.dart';
import 'package:apis/dio_config/dio_logger/abstract/api_base_logger.dart';
import 'package:apis/utils/api_error_utils.dart';
import 'package:core/core.dart';

/// 🔐 JWT Interceptor for WooCommerce API requests
class WooJwtInterceptor extends Interceptor {
  final _dioLogger = GetIt.I.get<ApiBaseLogger>();
  final WooJwtAuthService _authService;

  WooJwtInterceptor(this._authService);

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      // 🌐 Pre-request hook for network checks or analytics
      await ApiNetwork.onRequestInterceptor();

      // 🔐 Add JWT token to request headers
      await _addJwtTokenToRequest(options);

      // 📝 Set common headers for WooCommerce
      options.headers.addAll(<String, dynamic>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      });

      // 📋 Log outgoing request
      _dioLogger.printOnRequestLogs(options);
    } catch (e) {
      debugPrint('❌ Error in WooJwtInterceptor onRequest: $e');
      _dioLogger.printErrorLogs(
        DioException(
          requestOptions: options,
          error: ApiErrorUtils.getErrorMessage(e),
          type: DioExceptionType.unknown,
        ),
      );
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // 📥 Log incoming response
    _dioLogger.printOnResponseLogs(response);
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 🐞 Log error details for debugging
    _dioLogger.printErrorLogs(err);

    // 🔄 Handle 401 errors by attempting token refresh
    if (err.response?.statusCode == 401) {
      try {
        debugPrint('🔄 Received 401 error, attempting token refresh...');

        final refreshed = await _attemptTokenRefresh();
        if (refreshed) {
          debugPrint('✅ Token refreshed, retrying original request...');

          // Retry the original request with new token
          final retryResponse = await _retryRequest(err.requestOptions);
          return handler.resolve(retryResponse);
        } else {
          debugPrint('❌ Token refresh failed, user needs to re-authenticate');
          // Clear invalid token
          await WooJwtTokenStorage.clearToken();
        }
      } catch (e) {
        debugPrint('❌ Error during token refresh: $e');
        await WooJwtTokenStorage.clearToken();
      }
    }

    super.onError(err, handler);
  }

  /// 🔐 Add JWT token to request headers
  Future<void> _addJwtTokenToRequest(RequestOptions options) async {
    try {
      // Skip JWT for authentication endpoints
      if (_isAuthEndpoint(options.path)) {
        return;
      }

      // Check if this is a wishlist endpoint - JWT is optional for wishlist
      final isWishlistEndpoint = _isWishlistEndpoint(options.path);

      // First try to get token from WooJwtTokenStorage (legacy)
      WooJwtToken? token = await WooJwtTokenStorage.loadToken();

      // Always check Core Auth JWT first (preferred over WooJWT)
      // This ensures we use the latest authenticated token
      try {
        final authStorage = AuthStorageHelper();
        final coreJwtToken = await authStorage.getToken();

        if (coreJwtToken != null && coreJwtToken.isNotEmpty) {
          // Use Core Auth JWT token (preferred)
          options.headers['Authorization'] = 'Bearer $coreJwtToken';
          debugPrint(
              '🔐 Core Auth JWT token added to request (path: ${options.path})');
          return;
        }
      } catch (e) {
        debugPrint('⚠️ Could not get Core Auth JWT token: $e');
      }

      // Only use WooJWT if Core Auth JWT is not available
      if (token != null && !token.isExpired) {
        // Add JWT token to Authorization header
        options.headers['Authorization'] = token.authorizationHeader;
        debugPrint('🔐 WooJWT token added to request (path: ${options.path})');
      } else if (token != null && token.needsRefresh) {
        // Try to refresh token
        debugPrint('🔄 Token needs refresh, attempting auto-refresh...');
        final refreshedToken = await _authService.autoRefreshIfNeeded();

        if (refreshedToken != null) {
          options.headers['Authorization'] = refreshedToken.authorizationHeader;
          debugPrint('✅ Token refreshed and added to request');
        } else {
          // For wishlist endpoints, proceed without token (local storage mode)
          if (isWishlistEndpoint) {
            debugPrint(
                '💡 Wishlist endpoint: proceeding without token (local storage mode)');
          } else {
            debugPrint('⚠️ Token refresh failed, proceeding without token');
          }
        }
      } else {
        // For wishlist endpoints, proceed without token (local storage mode)
        if (isWishlistEndpoint) {
          debugPrint(
              '💡 Wishlist endpoint: no token available, using local storage mode');
        } else {
          debugPrint('⚠️ No valid JWT token available');
        }
      }
    } catch (e) {
      debugPrint('❌ Error adding JWT token to request: $e');
    }
  }

  /// 🔍 Check if the request is to a wishlist endpoint
  bool _isWishlistEndpoint(String path) {
    return path.contains('/custom-wishlist/') || path.contains('wishlist');
  }

  /// 🔄 Attempt to refresh the JWT token
  Future<bool> _attemptTokenRefresh() async {
    try {
      final token = await WooJwtTokenStorage.loadToken();
      if (token?.refreshToken == null) {
        debugPrint('❌ No refresh token available');
        return false;
      }

      await _authService.refreshToken();
      return true;
    } catch (e) {
      debugPrint('❌ Token refresh failed: $e');
      return false;
    }
  }

  /// 🔄 Retry the original request with new token
  Future<Response> _retryRequest(RequestOptions requestOptions) async {
    try {
      // Create a new Dio instance for retry
      final dio = Dio();

      // Add JWT token to retry request
      final token = await WooJwtTokenStorage.loadToken();
      if (token != null) {
        requestOptions.headers['Authorization'] = token.authorizationHeader;
      }

      // Retry the request
      return await dio.fetch(requestOptions);
    } catch (e) {
      debugPrint('❌ Request retry failed: $e');
      rethrow;
    }
  }

  /// 🔍 Check if the request is to an authentication endpoint
  bool _isAuthEndpoint(String path) {
    final authEndpoints = [
      '/wp-json/jwt-auth/v1/token',
      '/wp-json/jwt-auth/v1/token/refresh',
      '/wp-json/jwt-auth/v1/token/revoke',
      '/wp-json/jwt-auth/v1/token/validate',
      // Custom brand-specific auth endpoints
      '-auth-login/v1/auth',
      '-auth-login/v1/signup',
      '-auth-login/v1/delete',
      '-auth-login/v1/reset-password',
    ];

    return authEndpoints.any((endpoint) => path.contains(endpoint));
  }
}

/// 🔐 Enhanced WooCommerce Interceptor with JWT support
class WooJwtEnhancedInterceptor extends Interceptor {
  final _dioLogger = GetIt.I.get<ApiBaseLogger>();
  final WooJwtAuthService _authService;
  bool _useJwtAuth = true; // Flag to switch between JWT and Basic Auth

  WooJwtEnhancedInterceptor(this._authService);

  /// 🔄 Switch between JWT and Basic Auth
  void setUseJwtAuth(bool useJwt) {
    _useJwtAuth = useJwt;
    debugPrint(
        '🔄 Authentication mode switched to: ${useJwt ? "JWT" : "Basic Auth"}');
  }

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      // 🌐 Pre-request hook for network checks or analytics
      await ApiNetwork.onRequestInterceptor();

      if (_useJwtAuth) {
        // 🔐 Use JWT authentication
        await _addJwtTokenToRequest(options);
      } else {
        // 🔑 Use Basic Auth (fallback)
        _addBasicAuthToRequest(options);
      }

      // 📝 Set common headers for WooCommerce
      options.headers.addAll(<String, dynamic>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      });

      // 📋 Log outgoing request
      _dioLogger.printOnRequestLogs(options);
    } catch (e) {
      debugPrint('❌ Error in WooJwtEnhancedInterceptor onRequest: $e');
      _dioLogger.printErrorLogs(
        DioException(
          requestOptions: options,
          error: ApiErrorUtils.getErrorMessage(e),
          type: DioExceptionType.unknown,
        ),
      );
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // 📥 Log incoming response
    _dioLogger.printOnResponseLogs(response);
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 🐞 Log error details for debugging
    _dioLogger.printErrorLogs(err);

    // 🔄 Handle 401 errors
    if (err.response?.statusCode == 401) {
      if (_useJwtAuth) {
        // Try JWT token refresh
        try {
          debugPrint(
              '🔄 Received 401 error with JWT auth, attempting token refresh...');

          final refreshed = await _attemptTokenRefresh();
          if (refreshed) {
            debugPrint('✅ Token refreshed, retrying original request...');

            final retryResponse = await _retryRequest(err.requestOptions);
            return handler.resolve(retryResponse);
          } else {
            debugPrint(
                '⚠️ JWT token refresh failed, falling back to Basic Auth');
            _useJwtAuth = false;
            // Retry with Basic Auth
            final retryResponse = await _retryRequest(err.requestOptions);
            return handler.resolve(retryResponse);
          }
        } catch (e) {
          debugPrint('❌ Error during JWT token refresh: $e');
          await WooJwtTokenStorage.clearToken();
        }
      } else {
        debugPrint('❌ Basic Auth failed, user needs to re-authenticate');
      }
    }

    super.onError(err, handler);
  }

  /// 🔐 Add JWT token to request headers
  Future<void> _addJwtTokenToRequest(RequestOptions options) async {
    try {
      // Skip JWT for authentication endpoints
      if (_isAuthEndpoint(options.path)) {
        return;
      }

      // Check if this is a wishlist endpoint - JWT is optional for wishlist
      final isWishlistEndpoint = _isWishlistEndpoint(options.path);

      // First try to get token from WooJwtTokenStorage (legacy)
      WooJwtToken? token = await WooJwtTokenStorage.loadToken();

      // Always check Core Auth JWT first (preferred over WooJWT)
      // This ensures we use the latest authenticated token
      try {
        final authStorage = AuthStorageHelper();
        final coreJwtToken = await authStorage.getToken();

        if (coreJwtToken != null && coreJwtToken.isNotEmpty) {
          // Use Core Auth JWT token (preferred)
          options.headers['Authorization'] = 'Bearer $coreJwtToken';
          debugPrint(
              '🔐 Core Auth JWT token added to request (path: ${options.path})');
          return;
        }
      } catch (e) {
        debugPrint('⚠️ Could not get Core Auth JWT token: $e');
      }

      // Only use WooJWT if Core Auth JWT is not available
      if (token != null && !token.isExpired) {
        options.headers['Authorization'] = token.authorizationHeader;
        debugPrint('🔐 WooJWT token added to request (path: ${options.path})');
      } else if (token != null && token.needsRefresh) {
        debugPrint('🔄 Token needs refresh, attempting auto-refresh...');
        final refreshedToken = await _authService.autoRefreshIfNeeded();

        if (refreshedToken != null) {
          options.headers['Authorization'] = refreshedToken.authorizationHeader;
          debugPrint('✅ Token refreshed and added to request');
        } else {
          // For wishlist endpoints, proceed without token (local storage mode)
          if (isWishlistEndpoint) {
            debugPrint(
                '💡 Wishlist endpoint: proceeding without token (local storage mode)');
          } else {
            debugPrint('⚠️ Token refresh failed, falling back to Basic Auth');
            _useJwtAuth = false;
            _addBasicAuthToRequest(options);
          }
        }
      } else {
        // For wishlist endpoints, proceed without token (local storage mode)
        if (isWishlistEndpoint) {
          debugPrint(
              '💡 Wishlist endpoint: no token available, using local storage mode');
        } else {
          debugPrint(
              '⚠️ No valid JWT token available, falling back to Basic Auth');
          _useJwtAuth = false;
          _addBasicAuthToRequest(options);
        }
      }
    } catch (e) {
      debugPrint('❌ Error adding JWT token to request: $e');
      // Only fallback to Basic Auth if not a wishlist endpoint
      final isWishlistEndpoint = _isWishlistEndpoint(options.path);
      if (!isWishlistEndpoint) {
        _addBasicAuthToRequest(options);
      }
    }
  }

  /// 🔍 Check if the request is to a wishlist endpoint
  bool _isWishlistEndpoint(String path) {
    return path.contains('/custom-wishlist/') || path.contains('wishlist');
  }

  /// 🔑 Add Basic Auth to request headers
  void _addBasicAuthToRequest(RequestOptions options) {
    try {
      final authHeader = WooNetwork.basicAuthHeader();
      options.headers['Authorization'] = authHeader;
      debugPrint('🔑 Basic Auth added to request');
    } catch (e) {
      debugPrint('❌ Error adding Basic Auth to request: $e');
    }
  }

  /// 🔄 Attempt to refresh the JWT token
  Future<bool> _attemptTokenRefresh() async {
    try {
      final token = await WooJwtTokenStorage.loadToken();
      if (token?.refreshToken == null) {
        debugPrint('❌ No refresh token available');
        return false;
      }

      await _authService.refreshToken();
      return true;
    } catch (e) {
      debugPrint('❌ Token refresh failed: $e');
      return false;
    }
  }

  /// 🔄 Retry the original request
  Future<Response> _retryRequest(RequestOptions requestOptions) async {
    try {
      final dio = Dio();

      // Add appropriate authentication
      if (_useJwtAuth) {
        final token = await WooJwtTokenStorage.loadToken();
        if (token != null) {
          requestOptions.headers['Authorization'] = token.authorizationHeader;
        }
      } else {
        requestOptions.headers['Authorization'] = WooNetwork.basicAuthHeader();
      }

      return await dio.fetch(requestOptions);
    } catch (e) {
      debugPrint('❌ Request retry failed: $e');
      rethrow;
    }
  }

  /// 🔍 Check if the request is to an authentication endpoint
  bool _isAuthEndpoint(String path) {
    final authEndpoints = [
      '/wp-json/jwt-auth/v1/token',
      '/wp-json/jwt-auth/v1/token/refresh',
      '/wp-json/jwt-auth/v1/token/revoke',
      '/wp-json/jwt-auth/v1/token/validate',
      // Custom brand-specific auth endpoints
      '-auth-login/v1/auth',
      '-auth-login/v1/signup',
      '-auth-login/v1/delete',
      '-auth-login/v1/reset-password',
    ];

    return authEndpoints.any((endpoint) => path.contains(endpoint));
  }
}
