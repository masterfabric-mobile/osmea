import 'package:api_explorer/services/api_request_handler.dart';
import 'package:api_explorer/services/api_service_registry.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:apis/apis.dart';
import 'package:apis/network/remote/woocommerce/store_api/cart_api/abstract/cart_service.dart';

///*******************************************************************
///**************** 🗑️ REMOVE COUPON HANDLER **********************
///*******************************************************************

class RemoveCouponHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    if (method != 'POST') {
      return {
        "status": "error",
        "message": "Method $method not supported for Remove Coupon API",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    // Validate required parameters
    if (!params.containsKey('code') || params['code']!.isEmpty) {
      return {
        "status": "error",
        "message": "Coupon code is required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    try {
      final couponCode = params['code']!;
      final apiVersion = params['api_version'] ?? 'v1';

      // Validate coupon code format (basic validation)
      if (couponCode.length < 2) {
        return {
          "status": "error",
          "message": "Invalid coupon code format. Must be at least 2 characters",
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
          
          if (cartToken != null) {
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

      debugPrint('🗑️ Starting remove coupon from cart:');
      debugPrint('  - Coupon Code: $couponCode');
      debugPrint('  - API Version: $apiVersion');

      // Get CartService from DI
      final cartService = GetIt.I<CartService>();

      // Format JWT token with Bearer prefix if available
      final formattedJwtToken = (jwtToken != null && jwtToken.isNotEmpty)
          ? (jwtToken.startsWith('Bearer ') ? jwtToken : 'Bearer $jwtToken')
          : null;

      // Call the service
      final response = await cartService.removeCoupon(
        apiVersion: apiVersion,
        cartToken: cartToken,
        jwtToken: formattedJwtToken,
        code: couponCode,
      );

      debugPrint('🔍 Remove Coupon Response Debug:');
      debugPrint('  - Items Count: ${response.itemsCount}');
      debugPrint('  - Items Weight: ${response.itemsWeight}');
      debugPrint('  - Remaining Coupons Count: ${response.coupons?.length ?? 0}');
      debugPrint('  - Total Items: ${response.totals?.totalItems}');
      debugPrint('  - Total Discount: ${response.totals?.totalDiscount}');
      debugPrint('  - Total Price: ${response.totals?.totalPrice}');
      debugPrint('  - Needs Payment: ${response.needsPayment}');
      debugPrint('  - Needs Shipping: ${response.needsShipping}');
      debugPrint('  - Errors: ${response.errors}');

      // Check if there are any errors in the response
      if (response.errors != null && response.errors!.isNotEmpty) {
        debugPrint('❌ Remove coupon failed with errors: ${response.errors}');
        
        return {
          "status": "error",
          "message": "Failed to remove coupon from cart",
          "error_details": {
            "type": "cart_error",
            "errors": response.errors,
          },
          "params": params,
          "timestamp": DateTime.now().toIso8601String(),
        };
      }

      // Check if coupon was actually removed by looking at coupons array
      final remainingCoupons = response.coupons ?? [];
      final wasCouponRemoved = !remainingCoupons.any((coupon) => 
        coupon is Map && coupon['code'] == couponCode);

      debugPrint('✅ Coupon removal completed');
      debugPrint('   - Coupon Removed: $wasCouponRemoved');
      debugPrint('   - Remaining Coupons: ${remainingCoupons.length}');

      return {
        "status": "success",
        "message": wasCouponRemoved 
            ? "Coupon '$couponCode' removed successfully from cart"
            : "Coupon processing completed (check response for details)",
        "auth_info": {
          "cart_token_source": params.containsKey('cart_token') && params['cart_token']!.isNotEmpty ? "manual" : "auto_storage",
          "jwt_token_source": params.containsKey('jwt_token') && params['jwt_token']!.isNotEmpty ? "manual" : "auto_storage",
          "cart_token_available": cartToken.isNotEmpty,
          "jwt_token_available": jwtToken != null && jwtToken.isNotEmpty,
        },
        "coupon_info": {
          "removed_coupon_code": couponCode,
          "coupon_was_removed": wasCouponRemoved,
          "remaining_coupons_count": remainingCoupons.length,
          "remaining_coupons": remainingCoupons.map((coupon) {
            if (coupon is Map) {
              return {
                "code": coupon['code'],
                "discount_type": coupon['discount_type'],
                "totals": coupon['totals'],
              };
            }
            return coupon;
          }).toList(),
        },
        "cart_data": {
          "items_count": response.itemsCount,
          "items_weight": response.itemsWeight,
          "needs_payment": response.needsPayment,
          "needs_shipping": response.needsShipping,
          "has_calculated_shipping": response.hasCalculatedShipping,
          "payment_requirements": response.paymentRequirements,
          "payment_methods": response.paymentMethods,
        },
        "items": response.items?.map((item) => {
          "key": item.key,
          "id": item.id,
          "type": item.type,
          "name": item.name,
          "quantity": item.quantity,
          "sku": item.sku,
          "short_description": item.shortDescription,
          "permalink": item.permalink,
          "prices": item.prices != null ? {
            "price": item.prices!.price,
            "regular_price": item.prices!.regularPrice,
            "sale_price": item.prices!.salePrice,
            "currency_code": item.prices!.currencyCode,
            "currency_symbol": item.prices!.currencySymbol,
          } : null,
          "totals": item.totals != null ? {
            "line_subtotal": item.totals!.lineSubtotal,
            "line_total": item.totals!.lineTotal,
            "currency_code": item.totals!.currencyCode,
            "currency_symbol": item.totals!.currencySymbol,
          } : null,
          "quantity_limits": item.quantityLimits != null ? {
            "minimum": item.quantityLimits!.minimum,
            "maximum": item.quantityLimits!.maximum,
            "multiple_of": item.quantityLimits!.multipleOf,
            "editable": item.quantityLimits!.editable,
          } : null,
        }).toList(),
        "totals": response.totals != null ? {
          "total_items": response.totals!.totalItems,
          "total_items_tax": response.totals!.totalItemsTax,
          "total_fees": response.totals!.totalFees,
          "total_fees_tax": response.totals!.totalFeesTax,
          "total_discount": response.totals!.totalDiscount,
          "total_discount_tax": response.totals!.totalDiscountTax,
          "total_shipping": response.totals!.totalShipping,
          "total_shipping_tax": response.totals!.totalShippingTax,
          "total_price": response.totals!.totalPrice,
          "total_tax": response.totals!.totalTax,
          "currency_code": response.totals!.currencyCode,
          "currency_symbol": response.totals!.currencySymbol,
        } : null,
        "coupons": remainingCoupons,
        "shipping_address": response.shippingAddress?.toJson(),
        "billing_address": response.billingAddress?.toJson(),
        "shipping_rates": response.shippingRates?.map((rate) => rate.toJson()).toList(),
        "params": params,
        "timestamp": DateTime.now().toIso8601String(),
      };

    } catch (e) {
      debugPrint("🚨 Remove Coupon Error Details: $e");

      String errorMessage = "Failed to remove coupon from cart: ${e.toString()}";
      Map<String, dynamic> errorDetails = {};

      // Check if it's a network/HTTP related error
      if (e.toString().contains('DioException') ||
          e.toString().contains('DioError')) {
        debugPrint("🔍 Network Error detected");

        if (e.toString().contains('400')) {
          errorDetails['status_code'] = 400;
          errorMessage = "Invalid coupon code or request. Please check the coupon code";
        } else if (e.toString().contains('401')) {
          errorDetails['status_code'] = 401;
          errorMessage = "Unauthorized. Please check your JWT token";
        } else if (e.toString().contains('403')) {
          errorDetails['status_code'] = 403;
          errorMessage = "Access denied. Please check your permissions";
        } else if (e.toString().contains('404')) {
          errorDetails['status_code'] = 404;
          errorMessage = "Coupon not found in cart or cart API not available";
        } else if (e.toString().contains('409')) {
          errorDetails['status_code'] = 409;
          errorMessage = "Coupon conflict. Coupon may not be applied or already removed";
        } else if (e.toString().contains('422')) {
          errorDetails['status_code'] = 422;
          errorMessage = "Invalid coupon. Coupon may not be applicable for removal";
        } else {
          errorMessage = "Network error occurred while removing coupon from cart";
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
      } else if (e.toString().contains('coupon') ||
                 e.toString().contains('code')) {
        errorDetails['type'] = 'coupon_error';
        errorMessage = "Invalid coupon code or coupon-related error";
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
            name: 'code',
            label: 'Coupon Code',
            hint: 'The coupon code to remove from the cart (e.g., "20off")',
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
