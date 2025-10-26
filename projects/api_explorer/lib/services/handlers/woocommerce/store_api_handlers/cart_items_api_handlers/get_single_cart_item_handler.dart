import 'package:api_explorer/services/api_request_handler.dart';
import 'package:api_explorer/services/api_service_registry.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:apis/apis.dart';
import 'package:apis/network/remote/woocommerce/store_api/cart_items_api/abstract/cart_items_service.dart';

///*******************************************************************
//************** 🔍 GET SINGLE CART ITEM HANDLER *******************
///*******************************************************************

class GetSingleCartItemHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    if (method != 'GET') {
      return {
        "status": "error",
        "message": "Method $method not supported for Get Single Cart Item API",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    // Validate required parameters
    if (!params.containsKey('key') || params['key']!.isEmpty) {
      return {
        "status": "error",
        "message": "Cart item key is required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    try {
      final apiVersion = params['api_version'] ?? 'v1';
      final key = params['key']!;

      // 🔍 Auto-fetch cart token from local storage
      String? cartToken = params['cart_token'];
      if (cartToken == null || cartToken.isEmpty) {
        try {
          debugPrint('🔍 Loading cart token from storage...');
          final storedToken = await WooCartTokenStorage.loadCartToken();
          cartToken = storedToken?.cartToken;
          
          if (cartToken != null && cartToken.isNotEmpty) {
            debugPrint('🛒 Cart token loaded from storage: ${cartToken.length > 20 ? cartToken.substring(0, 20) + "..." : cartToken}');
          } else {
            debugPrint('⚠️ No cart token found in storage');
          }
        } catch (e) {
          debugPrint('❌ Could not load cart token from storage: $e');
        }
      }

      // 🔐 Auto-fetch JWT token from local storage
      String? jwtToken = params['jwt_token'];
      if (jwtToken == null || jwtToken.isEmpty) {
        try {
          debugPrint('🔍 Loading JWT token from storage...');
          final storedJwt = await WooJwtTokenStorage.loadToken();
          jwtToken = storedJwt?.accessToken;
          
          if (jwtToken != null && jwtToken.isNotEmpty) {
            debugPrint('🔐 JWT token loaded from storage: ${jwtToken.length > 20 ? jwtToken.substring(0, 20) + "..." : jwtToken}');
          } else {
            debugPrint('⚠️ No JWT token found in storage');
          }
        } catch (e) {
          debugPrint('❌ Could not load JWT token from storage: $e');
        }
      }

      // Validate tokens after auto-fetch attempt
      if (cartToken == null || cartToken.isEmpty) {
        return {
          "status": "error",
          "message": "Cart token is required. Please provide it manually or ensure it's saved in storage.",
          "timestamp": DateTime.now().toIso8601String(),
        };
      }

      // JWT token is optional - just log if missing
      if (jwtToken == null || jwtToken.isEmpty) {
        debugPrint('⚠️ JWT token not provided - continuing without authentication');
      } else {
        debugPrint('🔐 JWT token available for authenticated request');
      }

      debugPrint('🔍 Starting get single cart item:');
      debugPrint('  - API Version: $apiVersion');
      debugPrint('  - Item Key: $key');
      debugPrint('  - Cart Token Available: ${cartToken.isNotEmpty}');
      debugPrint('  - JWT Token Available: ${jwtToken != null && jwtToken.isNotEmpty}');

      // Get CartItemsService from DI
      final cartItemsService = GetIt.I<CartItemsService>();

      // Format JWT token with Bearer prefix if available, or use empty string
      final formattedJwtToken = (jwtToken != null && jwtToken.isNotEmpty)
          ? (jwtToken.startsWith('Bearer ') ? jwtToken : 'Bearer $jwtToken')
          : '';

      // Call the service
      final responseList = await cartItemsService.getSingleCartItem(
        apiVersion: apiVersion,
        cartToken: cartToken,
        jwtToken: formattedJwtToken,
        key: key,
      );

      debugPrint('🔍 Single Cart Item Response received successfully');
      debugPrint('  - Response Type: ${responseList.runtimeType}');
      debugPrint('  - Response Count: ${responseList.length}');

      if (responseList.isEmpty) {
        return {
          "status": "error",
          "message": "Cart item not found with the provided key",
          "params": params,
          "timestamp": DateTime.now().toIso8601String(),
        };
      }

      // Get the first (and should be only) item from the array
      final response = responseList.first;
      final responseJson = response.toJson();
      debugPrint('  - Item Key: ${response.key}');
      debugPrint('  - Item Name: ${response.name}');
      debugPrint('  - Available Fields: ${responseJson.keys.join(', ')}');

      debugPrint('✅ Single cart item retrieved successfully');

      return {
        "status": "success",
        "message": "Single cart item retrieved successfully",
        "auth_info": {
          "cart_token_source": params.containsKey('cart_token') && params['cart_token']!.isNotEmpty ? "manual" : "auto_storage",
          "jwt_token_source": params.containsKey('jwt_token') && params['jwt_token']!.isNotEmpty ? "manual" : "auto_storage",
          "cart_token_available": cartToken.isNotEmpty,
          "jwt_token_available": jwtToken != null && jwtToken.isNotEmpty,
        },
        "item": responseJson,
        "params": params,
        "timestamp": DateTime.now().toIso8601String(),
      };

    } catch (e) {
      debugPrint("🚨 Get Single Cart Item Error Details: $e");

      String errorMessage = "Failed to get single cart item: ${e.toString()}";
      Map<String, dynamic> errorDetails = {};

      // Check if it's a network/HTTP related error
      if (e.toString().contains('DioException') ||
          e.toString().contains('DioError')) {
        debugPrint("🔍 Network Error detected");

        if (e.toString().contains('400')) {
          errorDetails['status_code'] = 400;
          errorMessage = "Bad request. Please check the cart item key";
        } else if (e.toString().contains('401')) {
          errorDetails['status_code'] = 401;
          errorMessage = "Unauthorized. Please check your JWT token";
        } else if (e.toString().contains('403')) {
          errorDetails['status_code'] = 403;
          errorMessage = "Access denied. Please check your permissions";
        } else if (e.toString().contains('404')) {
          errorDetails['status_code'] = 404;
          errorMessage = "Cart item not found. Please check the item key";
        } else if (e.toString().contains('500')) {
          errorDetails['status_code'] = 500;
          errorMessage = "Server error occurred while fetching cart item";
        } else {
          errorMessage = "Network error occurred while fetching cart item";
        }

        errorDetails['type'] = 'network_error';
      } else if (e.toString().contains('cart_token') ||
                 e.toString().contains('CART_TOKEN')) {
        errorDetails['type'] = 'cart_token_error';
        errorMessage = "Invalid or expired cart token";
      } else if (e.toString().contains('jwt') ||
                 e.toString().contains('JWT') ||
                 e.toString().contains('Authorization')) {
        errorDetails['type'] = 'auth_error';
        errorMessage = "Invalid or expired JWT token";
      } else if (e.toString().contains('key')) {
        errorDetails['type'] = 'key_error';
        errorMessage = "Invalid cart item key";
      } else {
        errorDetails['type'] = 'unknown_error';
      }

      return {
        "status": "error",
        "message": errorMessage,
        "error_details": errorDetails,
        "full_error": e.toString(),
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
          const ApiField(
            name: 'key',
            label: 'Cart Item Key',
            hint: 'The unique key of the cart item to retrieve (e.g., "6f4922f45568161a8cdf4ad2299f6d23")',
            isRequired: true,
          ),
          const ApiField(
            name: 'cart_token',
            label: 'Cart Token',
            hint: 'Cart token for authentication (auto-loaded from storage if empty)',
            isRequired: false,
          ),
          const ApiField(
            name: 'jwt_token',
            label: 'JWT Token (Optional)',
            hint: 'JWT authentication token (auto-loaded from storage if empty)',
            isRequired: false,
          ),
          const ApiField(
            name: 'api_version',
            label: 'API Version',
            hint: 'WooCommerce Store API version (default: v1)',
          ),
        ],
      };
}