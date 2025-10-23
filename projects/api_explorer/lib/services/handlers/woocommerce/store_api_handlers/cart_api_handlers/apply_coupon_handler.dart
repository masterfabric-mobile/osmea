import 'package:api_explorer/services/api_request_handler.dart';
import 'package:api_explorer/services/api_service_registry.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:apis/apis.dart';
import 'package:apis/network/remote/woocommerce/store_api/cart_api/abstract/cart_service.dart';

///*******************************************************************
///******************* 🎫 APPLY COUPON HANDLER **********************
///*******************************************************************

class ApplyCouponHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    if (method != 'POST') {
      return {
        "status": "error",
        "message": "Method $method not supported for Apply Coupon API",
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

      debugPrint('🎫 Starting apply coupon to cart:');
      debugPrint('  - Coupon Code: $couponCode');
      debugPrint('  - API Version: $apiVersion');

      // Get CartService from DI
      final cartService = GetIt.I<CartService>();

      // Format JWT token with Bearer prefix if available
      String? formattedJwtToken;
      if (jwtToken != null && jwtToken.isNotEmpty) {
        formattedJwtToken = jwtToken.startsWith('Bearer ') 
            ? jwtToken 
            : 'Bearer $jwtToken';
      }

      // Call the service
      final response = await cartService.applyCoupon(
        apiVersion: apiVersion,
        cartToken: cartToken,
        jwtToken: formattedJwtToken, // Can be null - service should handle this
        code: couponCode,
      );

      debugPrint('🔍 Apply Coupon Response Debug:');
      debugPrint('  - Items Count: ${response.itemsCount}');
      debugPrint('  - Items Weight: ${response.itemsWeight}');
      debugPrint('  - Applied Coupons Count: ${response.coupons?.length ?? 0}');
      debugPrint('  - Total Items: ${response.totals?.totalItems}');
      debugPrint('  - Total Discount: ${response.totals?.totalDiscount}');
      debugPrint('  - Total Price: ${response.totals?.totalPrice}');
      debugPrint('  - Needs Payment: ${response.needsPayment}');
      debugPrint('  - Needs Shipping: ${response.needsShipping}');
      debugPrint('  - Errors: ${response.errors}');

      // Check if there are any errors in the response
      if (response.errors != null && response.errors!.isNotEmpty) {
        debugPrint('❌ Apply coupon failed with errors: ${response.errors}');
        
        return {
          "status": "error",
          "message": "Failed to apply coupon to cart",
          "error_details": {
            "type": "cart_error",
            "errors": response.errors,
          },
          "params": params,
          "timestamp": DateTime.now().toIso8601String(),
        };
      }

      // Check if coupon was actually applied by looking at coupons array
      final appliedCoupons = response.coupons ?? [];
      final wasCouponApplied = appliedCoupons.any((coupon) => coupon.code == couponCode);

      debugPrint('✅ Coupon application completed');
      debugPrint('   - Coupon Applied: $wasCouponApplied');
      debugPrint('   - Applied Coupons: ${appliedCoupons.map((c) => c.code).join(", ")}');

      return {
        "status": "success",
        "message": wasCouponApplied 
            ? "Coupon '$couponCode' applied successfully to cart"
            : "Coupon processing completed (check response for details)",
        "auth_info": {
          "cart_token_source": params.containsKey('cart_token') && params['cart_token']!.isNotEmpty ? "manual" : "auto_storage",
          "jwt_token_source": params.containsKey('jwt_token') && params['jwt_token']!.isNotEmpty ? "manual" : "auto_storage",
          "cart_token_available": cartToken.isNotEmpty,
          "jwt_token_available": jwtToken != null && jwtToken.isNotEmpty,
        },
        "coupon_info": {
          "applied_coupon_code": couponCode,
          "coupon_was_applied": wasCouponApplied,
          "total_applied_coupons": appliedCoupons.length,
          "applied_coupons": appliedCoupons.map((coupon) => {
            "code": coupon.code,
            "discount_type": coupon.discountType,
            "total_discount": coupon.totals?.totalDiscount,
            "total_discount_tax": coupon.totals?.totalDiscountTax,
            "currency_code": coupon.totals?.currencyCode,
            "currency_symbol": coupon.totals?.currencySymbol,
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
        "coupons": appliedCoupons.map((coupon) => coupon.toJson()).toList(),
        "shipping_address": response.shippingAddress?.toJson(),
        "billing_address": response.billingAddress?.toJson(),
        "shipping_rates": response.shippingRates?.map((rate) => rate.toJson()).toList(),
        "params": params,
        "timestamp": DateTime.now().toIso8601String(),
      };

    } catch (e) {
      debugPrint("🚨 Apply Coupon Error Details: $e");

      String errorMessage = "Failed to apply coupon to cart: ${e.toString()}";
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
          errorMessage = "Coupon not found or cart API not available";
        } else if (e.toString().contains('409')) {
          errorDetails['status_code'] = 409;
          errorMessage = "Coupon conflict. Coupon may already be applied or invalid";
        } else if (e.toString().contains('422')) {
          errorDetails['status_code'] = 422;
          errorMessage = "Invalid coupon. Coupon may be expired, used, or not applicable";
        } else {
          errorMessage = "Network error occurred while applying coupon to cart";
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
            hint: 'The coupon code to apply to the cart (e.g., "20off", "SAVE10")',
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
            hint: 'JWT authentication token for authenticated requests (optional)',
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
