import 'package:apis/apis.dart';
import 'package:apis/network/remote/woocommerce/store_api/cart_api/abstract/cart_service.dart';
import 'package:api_explorer/services/api_request_handler.dart';
import 'package:get_it/get_it.dart';
import 'package:api_explorer/services/api_service_registry.dart';
import 'package:apis/dio_config/dio_client/api_dio_client.dart';
import 'package:flutter/foundation.dart';

///*******************************************************************
//******************* 🛒 GET CART HANDLER ***************************
///*******************************************************************

class GetCartHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    if (method != 'GET') {
      return {
        "status": "error",
        "message": "Method $method not supported for Get Cart API",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }
    try {
      // Try to get JWT token from storage if available (optional)
      String? jwtToken;
      try {
        final token = await WooJwtTokenStorage.loadToken();
        if (token?.accessToken != null && token!.accessToken.isNotEmpty) {
          jwtToken = 'Bearer ${token.accessToken}';
        }
      } catch (e) {
        // JWT token is optional, continue without it
      }

      // Get cookies before request (to compare with after request)
      Map<String, String> cookiesBefore = {};
      if (kIsWeb) {
        try {
          cookiesBefore = await ApiDioClient.webCookieManager.getAllCookies();
          debugPrint('🍪 Cookies before request: ${cookiesBefore.keys.toList()}');
        } catch (e) {
          debugPrint('❌ Error getting cookies before request: $e');
        }
      }

      final response = await GetIt.I<CartService>().getCart(
        apiVersion: WooNetwork.apiVersion,
        jwtToken: jwtToken,
      );

      // Wait a bit for interceptor to save cookies (WebCookieManager runs async)
      if (kIsWeb) {
        await Future.delayed(const Duration(milliseconds: 200)); // Increased delay for cookie processing
      }

      // Get cookies after request and extract new/received cookies
      Map<String, String> receivedCookies = {};
      Map<String, dynamic> cookieDetails = {}; // Detailed cookie information
      
      if (kIsWeb) {
        try {
          final cookiesAfter = await ApiDioClient.webCookieManager.getAllCookies();
          debugPrint('🍪 [GET CART] Cookies after request: ${cookiesAfter.keys.toList()}');
          debugPrint('🍪 [GET CART] Cookies before request: ${cookiesBefore.keys.toList()}');
          
          // Find new cookies (cookies that weren't there before or were updated)
          for (final entry in cookiesAfter.entries) {
            final isNew = !cookiesBefore.containsKey(entry.key);
            final isUpdated = cookiesBefore.containsKey(entry.key) && 
                            cookiesBefore[entry.key] != entry.value;
            
            if (isNew || isUpdated) {
              receivedCookies[entry.key] = entry.value;
              
              // Add detailed information about each cookie
              cookieDetails[entry.key] = {
                'value': entry.value,
                'is_new': isNew,
                'is_updated': isUpdated,
                'previous_value': isUpdated ? cookiesBefore[entry.key] : null,
                'received_at': DateTime.now().toIso8601String(),
                'cookie_type': _identifyCookieType(entry.key),
              };
              
              debugPrint('🍪 [GET CART] Cookie ${entry.key}: ${isNew ? "NEW" : "UPDATED"}');
            }
          }
          
          // If no new cookies found, but cookies exist, show all cookies from this request
          // This is important for getCart as it might receive session cookies
          if (receivedCookies.isEmpty && cookiesAfter.isNotEmpty) {
            receivedCookies = cookiesAfter;
            for (final entry in cookiesAfter.entries) {
              cookieDetails[entry.key] = {
                'value': entry.value,
                'is_new': false,
                'is_updated': false,
                'previous_value': cookiesBefore[entry.key],
                'received_at': DateTime.now().toIso8601String(),
                'cookie_type': _identifyCookieType(entry.key),
              };
            }
            debugPrint('🍪 [GET CART] No new cookies detected, showing all cookies: ${receivedCookies.keys.toList()}');
          }
          
          debugPrint('🍪 [GET CART] Total received cookies count: ${receivedCookies.length}');
          debugPrint('🍪 [GET CART] Cookie details: ${cookieDetails.keys.toList()}');
        } catch (e) {
          debugPrint('❌ [GET CART] Error getting cookies after request: $e');
        }
      }

      // Build response with cart data and cookies
      final responseData = {
        "status": "success",
        "cart": response.toJson(),
        "params": params,
        "timestamp": DateTime.now().toIso8601String(),
      };

      // Add response cookies with detailed information for getCart
      if (receivedCookies.isNotEmpty) {
        responseData["response_cookies"] = receivedCookies;
        responseData["cookie_details"] = cookieDetails; // Detailed cookie analysis
        responseData["is_get_cart"] = true; // Flag to identify getCart responses
        debugPrint('🍪 [GET CART] Added ${receivedCookies.length} cookies with details to response data');
      }

      return responseData;
    } catch (e) {
      return {
        "status": "error",
        "message": "Failed to fetch cart: ${e.toString()}",
        "params": params,
        "timestamp": DateTime.now().toIso8601String(),
      };
    }
  }

  @override
  List<String> get supportedMethods => ['GET'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'GET': [
          // No additional parameters required for Store API Cart GET
          // The API version is handled automatically
        ],
      };

  /// 🍪 Identify cookie type based on cookie name
  /// This helps categorize cookies (session, cart, auth, etc.)
  String _identifyCookieType(String cookieName) {
    final name = cookieName.toLowerCase();
    
    if (name.contains('cart') || name.contains('woocommerce_cart')) {
      return 'cart';
    } else if (name.contains('session') || name.contains('wp_')) {
      return 'session';
    } else if (name.contains('auth') || name.contains('token')) {
      return 'auth';
    } else if (name.contains('nonce')) {
      return 'nonce';
    } else if (name.contains('cookie')) {
      return 'preference';
    } else {
      return 'other';
    }
  }
}
