import 'package:api_explorer/services/api_request_handler.dart';
import 'package:api_explorer/services/api_service_registry.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:apis/apis.dart';
import 'package:apis/network/remote/woocommerce/store_api/cart_items_api/abstract/cart_items_service.dart';

///*******************************************************************
//************** 🛒 ADD CART ITEM HANDLER **************************
///*******************************************************************

class AddCartItemHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    if (method != 'POST') {
      return {
        "status": "error",
        "message": "Method $method not supported for Add Cart Item API",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    // Validate required parameters
    if (!params.containsKey('id') || params['id']!.isEmpty) {
      return {
        "status": "error",
        "message": "Product ID is required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    if (!params.containsKey('quantity') || params['quantity']!.isEmpty) {
      return {
        "status": "error",
        "message": "Quantity is required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    try {
      final apiVersion = params['api_version'] ?? 'v1';
      final productId = int.tryParse(params['id']!);
      final quantity = int.tryParse(params['quantity']!);

      if (productId == null) {
        return {
          "status": "error",
          "message": "Invalid product ID. Must be a valid integer.",
          "timestamp": DateTime.now().toIso8601String(),
        };
      }

      if (quantity == null || quantity <= 0) {
        return {
          "status": "error",
          "message": "Invalid quantity. Must be a positive integer.",
          "timestamp": DateTime.now().toIso8601String(),
        };
      }

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

      // Parse variation if provided
      List<Map<String, dynamic>>? variation;
      if (params.containsKey('variation') && params['variation']!.isNotEmpty) {
        // Try to parse variation from JSON string if provided
        try {
          // Basic parsing - in real implementation you might want more sophisticated JSON parsing
          debugPrint('📝 Variation parameter provided: ${params['variation']}');
        } catch (e) {
          debugPrint('⚠️ Could not parse variation parameter: $e');
        }
      }

      debugPrint('🛒 Starting add cart item:');
      debugPrint('  - API Version: $apiVersion');
      debugPrint('  - Product ID: $productId');
      debugPrint('  - Quantity: $quantity');
      debugPrint('  - Cart Token Available: ${cartToken.isNotEmpty}');
      debugPrint('  - JWT Token Available: ${jwtToken != null && jwtToken.isNotEmpty}');

      // Get CartItemsService from DI
      final cartItemsService = GetIt.I<CartItemsService>();

      // Format JWT token with Bearer prefix if available, or use empty string
      final formattedJwtToken = (jwtToken != null && jwtToken.isNotEmpty)
          ? (jwtToken.startsWith('Bearer ') ? jwtToken : 'Bearer $jwtToken')
          : '';

      // Call the service
      final response = await cartItemsService.addCartItem(
        apiVersion: apiVersion,
        cartToken: cartToken,
        jwtToken: formattedJwtToken,
        id: productId,
        quantity: quantity,
        variation: variation,
      );

      debugPrint('🛒 Add Cart Item Response received successfully');
      debugPrint('  - Response Type: ${response.runtimeType}');

      debugPrint('✅ Cart item added successfully');

      return {
        "status": "success",
        "message": "Cart item added successfully",
        "auth_info": {
          "cart_token_source": params.containsKey('cart_token') && params['cart_token']!.isNotEmpty ? "manual" : "auto_storage",
          "jwt_token_source": params.containsKey('jwt_token') && params['jwt_token']!.isNotEmpty ? "manual" : "auto_storage",
          "cart_token_available": cartToken.isNotEmpty,
          "jwt_token_available": jwtToken != null && jwtToken.isNotEmpty,
        },
        "added_item": "Cart item added successfully - response details will be available after build generation",
        "request_params": {
          "product_id": productId,
          "quantity": quantity,
          "variation": variation,
        },
        "params": params,
        "timestamp": DateTime.now().toIso8601String(),
      };

    } catch (e) {
      debugPrint("🚨 Add Cart Item Error Details: $e");

      String errorMessage = "Failed to add cart item: ${e.toString()}";
      Map<String, dynamic> errorDetails = {};

      // Check if it's a network/HTTP related error
      if (e.toString().contains('DioException') ||
          e.toString().contains('DioError')) {
        debugPrint("🔍 Network Error detected");

        if (e.toString().contains('400')) {
          errorDetails['status_code'] = 400;
          errorMessage = "Bad request. Please check the product ID and quantity";
        } else if (e.toString().contains('401')) {
          errorDetails['status_code'] = 401;
          errorMessage = "Unauthorized. Please check your JWT token";
        } else if (e.toString().contains('403')) {
          errorDetails['status_code'] = 403;
          errorMessage = "Access denied. Please check your permissions";
        } else if (e.toString().contains('404')) {
          errorDetails['status_code'] = 404;
          errorMessage = "Product not found. Please check the product ID";
        } else if (e.toString().contains('422')) {
          errorDetails['status_code'] = 422;
          errorMessage = "Validation error. Product may be out of stock or invalid quantity";
        } else if (e.toString().contains('500')) {
          errorDetails['status_code'] = 500;
          errorMessage = "Server error occurred while adding cart item";
        } else {
          errorMessage = "Network error occurred while adding cart item";
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
      } else if (e.toString().contains('id') || e.toString().contains('product')) {
        errorDetails['type'] = 'product_error';
        errorMessage = "Invalid product ID or product not available";
      } else if (e.toString().contains('quantity')) {
        errorDetails['type'] = 'quantity_error';
        errorMessage = "Invalid quantity or insufficient stock";
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
  List<String> get supportedMethods => ['POST'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'POST': [
          const ApiField(
            name: 'id',
            label: 'Product ID',
            hint: 'The cart item product or variation ID (e.g., "15")',
            isRequired: true,
          ),
          const ApiField(
            name: 'quantity',
            label: 'Quantity',
            hint: 'Quantity of this item in the cart (e.g., "4")',
            isRequired: true,
          ),
          const ApiField(
            name: 'variation',
            label: 'Variation (Optional)',
            hint: 'Chosen attributes for variations containing array of objects with keys "attribute" and "value"',
            isRequired: false,
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