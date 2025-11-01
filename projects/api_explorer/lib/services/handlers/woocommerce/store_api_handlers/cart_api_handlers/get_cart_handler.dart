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

      // Get cookies after request and extract new/received cookies
      Map<String, String> receivedCookies = {};
      if (kIsWeb) {
        try {
          final cookiesAfter = await ApiDioClient.webCookieManager.getAllCookies();
          debugPrint('🍪 Cookies after request: ${cookiesAfter.keys.toList()}');
          
          // Find new cookies (cookies that weren't there before)
          for (final entry in cookiesAfter.entries) {
            if (!cookiesBefore.containsKey(entry.key) || 
                cookiesBefore[entry.key] != entry.value) {
              receivedCookies[entry.key] = entry.value;
            }
          }
          
          // If no new cookies found, but cookies exist, show all cookies from this request
          // (in case they were updated)
          if (receivedCookies.isEmpty && cookiesAfter.isNotEmpty) {
            receivedCookies = cookiesAfter;
          }
          
          debugPrint('🍪 Received cookies from response: ${receivedCookies.keys.toList()}');
        } catch (e) {
          debugPrint('❌ Error getting cookies after request: $e');
        }
      }

      // Build response with cart data and cookies
      final responseData = {
        "status": "success",
        "cart": response.toJson(),
        "params": params,
        "timestamp": DateTime.now().toIso8601String(),
      };

      // Add response cookies if available
      if (receivedCookies.isNotEmpty) {
        responseData["response_cookies"] = receivedCookies;
        debugPrint('🍪 Added ${receivedCookies.length} cookies to response data');
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
}
