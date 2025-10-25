import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// 🛒 Cart Token Utilities
///
/// Utility functions for extracting and managing cart tokens from WooCommerce API responses.
/// This provides a centralized way to handle cart token extraction across the application.
class CartTokenUtils {
  // Cart token header names
  static const String _cartTokenHeaderName = 'X-Cart-Token';
  static const String _cartIdHeaderName = 'X-Cart-ID';

  /// 🛒 Extract cart token from Dio response
  ///
  /// Extracts cart token and cart ID from response headers, data, or cookies.
  /// Returns a map containing the extracted cart token information.
  static Future<Map<String, String?>> extractCartTokenFromResponse(
      Response response) async {
    try {
      String? cartToken;
      String? cartId;

      // Extract from response headers
      final headers = response.headers;

      // Extract cart token from response headers
      final cartTokenHeader = headers[_cartTokenHeaderName.toLowerCase()];
      if (cartTokenHeader != null && cartTokenHeader.isNotEmpty) {
        cartToken = cartTokenHeader.first;
      }

      // Extract cart ID from response headers
      final cartIdHeader = headers[_cartIdHeaderName.toLowerCase()];
      if (cartIdHeader != null && cartIdHeader.isNotEmpty) {
        cartId = cartIdHeader.first;
      }

      // Extract from response data if not in headers
      if (cartToken == null && response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;

        // Check various possible cart token fields
        cartToken = data['cart_token'] as String? ??
            data['cartToken'] as String? ??
            data['token'] as String?;

        cartId = data['cart_id'] as String? ??
            data['cartId'] as String? ??
            data['id']?.toString();
      }

      // Extract from cookies if not found in headers or data
      if (cartToken == null) {
        final cookies = response.headers['set-cookie'];
        if (cookies != null && cookies.isNotEmpty) {
          for (final cookie in cookies) {
            if (cookie.contains('woocommerce_cart_hash') ||
                cookie.contains('cart_token') ||
                cookie.contains('wp_woocommerce_session')) {
              // Extract cart token from cookie
              final cookieParts = cookie.split(';');
              for (final part in cookieParts) {
                if (part.contains('=')) {
                  final keyValue = part.split('=');
                  if (keyValue.length == 2) {
                    final key = keyValue[0].trim();
                    final value = keyValue[1].trim();
                    if (key.contains('cart') || key.contains('token')) {
                      cartToken = value;
                      break;
                    }
                  }
                }
              }
              if (cartToken != null) break;
            }
          }
        }
      }

      debugPrint(
          '🛒 Cart token extracted: ${cartToken != null ? "Present" : "Not found"}');
      debugPrint(
          '🆔 Cart ID extracted: ${cartId != null ? "Present" : "Not found"}');

      return {
        'cart_token': cartToken,
        'cart_id': cartId,
      };
    } catch (e) {
      debugPrint('❌ Error extracting cart token from response: $e');
      return {
        'cart_token': null,
        'cart_id': null,
      };
    }
  }

  /// 🛒 Extract cart token from response data map
  ///
  /// Extracts cart token information from a response data map (useful for non-Dio responses).
  static Map<String, String?> extractCartTokenFromData(
      Map<String, dynamic> data) {
    try {
      String? cartToken;
      String? cartId;

      // Check various possible cart token fields
      cartToken = data['cart_token'] as String? ??
          data['cartToken'] as String? ??
          data['token'] as String?;

      cartId = data['cart_id'] as String? ??
          data['cartId'] as String? ??
          data['id']?.toString();

      debugPrint(
          '🛒 Cart token extracted from data: ${cartToken != null ? "Present" : "Not found"}');
      debugPrint(
          '🆔 Cart ID extracted from data: ${cartId != null ? "Present" : "Not found"}');

      return {
        'cart_token': cartToken,
        'cart_id': cartId,
      };
    } catch (e) {
      debugPrint('❌ Error extracting cart token from data: $e');
      return {
        'cart_token': null,
        'cart_id': null,
      };
    }
  }

  /// 🔍 Check if response contains cart token information
  static bool hasCartTokenInfo(Response response) {
    try {
      // Check headers
      final headers = response.headers;
      if (headers[_cartTokenHeaderName.toLowerCase()] != null ||
          headers[_cartIdHeaderName.toLowerCase()] != null) {
        return true;
      }

      // Check response data
      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        return data.containsKey('cart_token') ||
            data.containsKey('cartToken') ||
            data.containsKey('token') ||
            data.containsKey('cart_id') ||
            data.containsKey('cartId') ||
            data.containsKey('id');
      }

      // Check cookies
      final cookies = response.headers['set-cookie'];
      if (cookies != null && cookies.isNotEmpty) {
        for (final cookie in cookies) {
          if (cookie.contains('woocommerce_cart_hash') ||
              cookie.contains('cart_token') ||
              cookie.contains('wp_woocommerce_session')) {
            return true;
          }
        }
      }

      return false;
    } catch (e) {
      debugPrint('❌ Error checking cart token info: $e');
      return false;
    }
  }

  /// 🔍 Check if data contains cart token information
  static bool hasCartTokenInfoInData(Map<String, dynamic> data) {
    try {
      return data.containsKey('cart_token') ||
          data.containsKey('cartToken') ||
          data.containsKey('token') ||
          data.containsKey('cart_id') ||
          data.containsKey('cartId') ||
          data.containsKey('id');
    } catch (e) {
      debugPrint('❌ Error checking cart token info in data: $e');
      return false;
    }
  }
}
