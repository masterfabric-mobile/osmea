import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:apis/apis.dart';
import 'package:apis/models/cart/woo_cart_token.dart';
import 'package:apis/dio_config/dio_logger/abstract/api_base_logger.dart';
import 'package:apis/utils/api_error_utils.dart';

/// 🛒 Cart Token Interceptor for WooCommerce API requests
///
/// This interceptor automatically handles cart tokens similar to JWT tokens:
/// - Adds cart token to request headers when available
/// - Extracts cart token from response headers and saves to local storage
/// - Manages cart token lifecycle and updates
class WooCartTokenInterceptor extends Interceptor {
  final _dioLogger = GetIt.I.get<ApiBaseLogger>();

  // Cart token header names
  static const String _cartTokenHeaderName = 'Cart-Token';
  static const String _cartTokenResponseHeaderName = 'Cart-Token';
  static const String _cartIdHeaderName = 'Cart-ID';
  static const String _cartIdResponseHeaderName = 'Cart-ID';

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      // 🌐 Pre-request hook for network checks or analytics
      await ApiNetwork.onRequestInterceptor();

      // 🛒 Add cart token to request headers
      await _addCartTokenToRequest(options);

      // 📋 Log outgoing request
      _dioLogger.printOnRequestLogs(options);
    } catch (e) {
      debugPrint('❌ Error in WooCartTokenInterceptor onRequest: $e');
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
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    try {
      // 🛒 Extract cart token from response headers
      await _extractCartTokenFromResponse(response);

      // 📥 Log incoming response
      _dioLogger.printOnResponseLogs(response);
    } catch (e) {
      debugPrint('❌ Error in WooCartTokenInterceptor onResponse: $e');
    }

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    try {
      // 🛒 Handle cart token errors (e.g., expired token)
      await _handleCartTokenError(err);

      // 🐞 Log error details for debugging
      _dioLogger.printErrorLogs(err);
    } catch (e) {
      debugPrint('❌ Error in WooCartTokenInterceptor onError: $e');
    }

    super.onError(err, handler);
  }

  /// 🛒 Add cart token to request headers
  Future<void> _addCartTokenToRequest(RequestOptions options) async {
    try {
      // Skip cart token for non-cart endpoints
      if (!_isCartEndpoint(options.path)) {
        return;
      }

      // Get current cart token
      final cartToken = await WooCartTokenStorage.loadCartToken();

      if (cartToken != null && cartToken.cartToken.isNotEmpty) {
        // Check if token has expired
        if (cartToken.expiresAt != null &&
            DateTime.now().isAfter(cartToken.expiresAt!)) {
          debugPrint('⚠️ Cart token has expired, clearing...');
          await WooCartTokenStorage.clearCartToken();
          return;
        }

        // Add cart token to headers
        options.headers[_cartTokenHeaderName] = cartToken.cartToken;

        // Add cart ID if available
        if (cartToken.cartId != null && cartToken.cartId!.isNotEmpty) {
          options.headers[_cartIdHeaderName] = cartToken.cartId;
        }

        debugPrint(
            '🛒 Cart token added to request: ${cartToken.cartToken.length > 20 ? cartToken.cartToken.substring(0, 20) + "..." : cartToken.cartToken}');
      } else {
        debugPrint('⚠️ No valid cart token available');
      }
    } catch (e) {
      debugPrint('❌ Error adding cart token to request: $e');
    }
  }

  /// 🛒 Extract cart token from response headers and save to storage
  Future<void> _extractCartTokenFromResponse(Response response) async {
    try {
      // Process all WooCommerce Store API responses
      if (!_isWooCommerceStoreApiEndpoint(response.requestOptions.path)) {
        return;
      }

      final headers = response.headers;
      String? cartToken;
      String? cartId;

      debugPrint('🔍 Extracting cart token from response...');
      debugPrint('🔍 Response path: ${response.requestOptions.path}');
      debugPrint('🔍 Response headers: ${headers.map.keys.toList()}');

      // Extract cart token from response headers
      final cartTokenHeader =
          headers[_cartTokenResponseHeaderName.toLowerCase()];
      if (cartTokenHeader != null && cartTokenHeader.isNotEmpty) {
        cartToken = cartTokenHeader.first;
        debugPrint('🛒 Found cart token in X-Cart-Token header');
      }

      // Extract cart ID from response headers
      final cartIdHeader = headers[_cartIdResponseHeaderName.toLowerCase()];
      if (cartIdHeader != null && cartIdHeader.isNotEmpty) {
        cartId = cartIdHeader.first;
        debugPrint('🆔 Found cart ID in X-Cart-ID header');
      }

      // Extract cart token from response data if not in headers
      if (cartToken == null && response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        debugPrint('🔍 Checking response data for cart token...');

        // Check various possible cart token fields
        cartToken = data['cart_token'] as String? ??
            data['cartToken'] as String? ??
            data['token'] as String? ??
            data['nonce'] as String? ??
            data['woocommerce_cart_hash'] as String?;

        cartId = data['cart_id'] as String? ??
            data['cartId'] as String? ??
            data['id']?.toString();

        if (cartToken != null) {
          debugPrint('🛒 Found cart token in response data');
        }
      }

      // For WooCommerce Store API, cart token might be in cookies
      if (cartToken == null) {
        final cookies = response.headers['set-cookie'];
        if (cookies != null && cookies.isNotEmpty) {
          debugPrint('🔍 Checking cookies for cart token...');
          debugPrint('🔍 Set-Cookie headers: ${cookies.join(", ")}');

          for (final cookieHeader in cookies) {
            // Parse cookie: name=value; attributes
            final cookieParts = cookieHeader.split(';');
            if (cookieParts.isNotEmpty) {
              final nameValue = cookieParts[0].trim().split('=');
              if (nameValue.length >= 2) {
                final cookieName = nameValue[0].trim();
                // Handle values that might contain '='
                final cookieValue = cookieHeader
                    .substring(cookieHeader.indexOf('=') + 1)
                    .split(';')[0]
                    .trim();

                debugPrint('🔍 Checking cookie: $cookieName');

                // Check for cart-related cookie names (WooCommerce standard cookie names)
                // WooCommerce cookies: woocommerce_cart_hash, woocommerce_items_in_cart, wp_woocommerce_session_
                if (cookieName == 'woocommerce_cart_hash' ||
                    cookieName == 'woocommerce_items_in_cart' ||
                    cookieName.startsWith('wp_woocommerce_session_') ||
                    cookieName.contains('cart_token') ||
                    cookieName.toLowerCase().contains('cart')) {
                  cartToken = cookieValue;
                  debugPrint(
                      '🛒 Found cart token in cookie: $cookieName=${cookieValue.length > 20 ? cookieValue.substring(0, 20) + "..." : cookieValue}');
                  break;
                }
              }
            }
          }
        }
      }

      // Save cart token if found, but only if:
      // 1. No existing token, OR
      // 2. Existing token is expired/invalid
      if (cartToken != null && cartToken.isNotEmpty) {
        // Check if we have a valid existing token
        final existingToken = await WooCartTokenStorage.loadCartToken();
        final shouldSave = existingToken == null ||
            (existingToken.expiresAt != null &&
                DateTime.now().isAfter(existingToken.expiresAt!)) ||
            existingToken.cartToken.isEmpty;

        if (shouldSave) {
          await _saveCartToken(
              cartToken, cartId, response.requestOptions.uri.toString());
          debugPrint(
              '🛒 Cart token extracted and saved: ${cartToken.length > 20 ? cartToken.substring(0, 20) + "..." : cartToken}');
        } else {
          debugPrint(
              'ℹ️ Cart token found in response but existing token is still valid. Keeping existing token.');
        }
      } else {
        debugPrint('⚠️ No cart token found in response');
      }
    } catch (e) {
      debugPrint('❌ Error extracting cart token from response: $e');
    }
  }

  /// 🛒 Save cart token to storage
  Future<void> _saveCartToken(
      String cartToken, String? cartId, String requestUrl) async {
    try {
      // Get current store URL
      final storeUrl = WooNetwork.baseUrl;

      // Create or update cart token
      await WooCartTokenStorage.updateCartToken(
        cartToken: cartToken,
        cartId: cartId,
        storeUrl: storeUrl,
        lastRefreshed: DateTime.now(),
        metadata: {
          'request_url': requestUrl,
          'extracted_at': DateTime.now().toIso8601String(),
        },
      );

      debugPrint('✅ Cart token saved to storage');
    } catch (e) {
      debugPrint('❌ Error saving cart token: $e');
    }
  }

  /// 🛒 Handle cart token errors
  Future<void> _handleCartTokenError(DioException err) async {
    try {
      // Check if error is related to cart token using ApiErrorUtils
      final errorMessage = ApiErrorUtils.getErrorMessage(err);
      final statusCode = err.response?.statusCode;

      // Check if error is related to cart token
      if (statusCode == 401 || statusCode == 403) {
        // Check if the error is cart token related
        final responseData = err.response?.data;
        if (responseData is Map<String, dynamic>) {
          final message = responseData['message'] as String? ?? '';
          if (message.toLowerCase().contains('cart') ||
              message.toLowerCase().contains('token')) {
            debugPrint('🛒 Cart token error detected, clearing token...');
            debugPrint('🛒 Error message: $errorMessage');
            await WooCartTokenStorage.clearCartToken();
          }
        } else {
          // Use ApiErrorUtils to check error message
          if (errorMessage.toLowerCase().contains('unauthorized') ||
              errorMessage.toLowerCase().contains('forbidden')) {
            debugPrint(
                '🛒 Authentication error detected, clearing cart token...');
            debugPrint('🛒 Error message: $errorMessage');
            await WooCartTokenStorage.clearCartToken();
          }
        }
      }
    } catch (e) {
      debugPrint(
          '❌ Error handling cart token error: ${ApiErrorUtils.getErrorMessage(e)}');
    }
  }

  /// 🔍 Check if the endpoint is cart-related
  bool _isCartEndpoint(String path) {
    final cartPaths = [
      '/cart',
      '/store/cart',
      '/wp-json/wc/store',
      '/wp-json/wc/v3/cart',
      '/wp-json/wc/v2/cart',
      '/wp-json/wc/store/v1', // WooCommerce Store API v1
      '/wp-json/wc/store/v2', // WooCommerce Store API v2
      '/checkout', // Checkout endpoints also need cart token
    ];

    return cartPaths.any((cartPath) => path.contains(cartPath));
  }

  /// 🔍 Check if the endpoint is WooCommerce Store API
  bool _isWooCommerceStoreApiEndpoint(String path) {
    return path.contains('/wp-json/wc/store/');
  }

  /// 🔄 Refresh cart token (if needed)
  Future<void> refreshCartToken() async {
    try {
      final currentToken = await WooCartTokenStorage.loadCartToken();
      if (currentToken != null) {
        // Update last refreshed time
        await WooCartTokenStorage.updateCartToken(
          lastRefreshed: DateTime.now(),
        );
        debugPrint('🔄 Cart token refreshed');
      }
    } catch (e) {
      debugPrint('❌ Error refreshing cart token: $e');
    }
  }

  /// 🗑️ Clear cart token
  Future<void> clearCartToken() async {
    try {
      await WooCartTokenStorage.clearCartToken();
      debugPrint('🗑️ Cart token cleared');
    } catch (e) {
      debugPrint('❌ Error clearing cart token: $e');
    }
  }

  /// 📊 Get current cart token info
  Future<Map<String, dynamic>?> getCartTokenInfo() async {
    try {
      return await WooCartTokenStorage.getCartTokenInfo();
    } catch (e) {
      debugPrint('❌ Error getting cart token info: $e');
      return null;
    }
  }
}
