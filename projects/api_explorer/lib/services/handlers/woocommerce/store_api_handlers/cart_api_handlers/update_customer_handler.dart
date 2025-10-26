import 'package:api_explorer/services/api_request_handler.dart';
import 'package:api_explorer/services/api_service_registry.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:apis/apis.dart';
import 'package:apis/network/remote/woocommerce/store_api/cart_api/abstract/cart_service.dart';
import 'package:apis/network/remote/woocommerce/store_api/cart_api/freezed_model/request/update_customer_request.dart';

///*******************************************************************
///************** 👤 UPDATE CART CUSTOMER HANDLER *****************
///*******************************************************************

class UpdateCartCustomerHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    if (method != 'POST') {
      return {
        "status": "error",
        "message": "Method $method not supported for Update Customer API",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    try {
      final apiVersion = params['api_version'] ?? 'v1';

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

      // Create UpdateCustomerRequest from parameters
      BillingAddress? billingAddress;
      ShippingAddress? shippingAddress;

      // Build billing address if any billing field is provided
      if (params.keys.any((key) => key.startsWith('billing_'))) {
        billingAddress = BillingAddress(
          firstName: params['billing_first_name'],
          lastName: params['billing_last_name'],
          address1: params['billing_address_1'],
          address2: params['billing_address_2'],
          city: params['billing_city'],
          state: params['billing_state'],
          postcode: params['billing_postcode'],
          country: params['billing_country'],
          email: params['billing_email'],
          phone: params['billing_phone'],
        );
      }

      // Build shipping address if any shipping field is provided
      if (params.keys.any((key) => key.startsWith('shipping_'))) {
        shippingAddress = ShippingAddress(
          firstName: params['shipping_first_name'],
          lastName: params['shipping_last_name'],
          address1: params['shipping_address_1'],
          address2: params['shipping_address_2'],
          city: params['shipping_city'],
          state: params['shipping_state'],
          postcode: params['shipping_postcode'],
          country: params['shipping_country'],
          phone: params['shipping_phone'],
        );
      }

      // Validate that at least one address is provided
      if (billingAddress == null && shippingAddress == null) {
        return {
          "status": "error",
          "message": "At least one address (billing or shipping) must be provided for customer update. Please fill at least one billing field (e.g., billing_first_name, billing_email) or one shipping field (e.g., shipping_first_name, shipping_city).",
          "available_fields": {
            "billing_fields": [
              "billing_first_name", "billing_last_name", "billing_address_1", "billing_address_2", 
              "billing_city", "billing_state", "billing_postcode", "billing_country", 
              "billing_email", "billing_phone"
            ],
            "shipping_fields": [
              "shipping_first_name", "shipping_last_name", "shipping_address_1", "shipping_address_2",
              "shipping_city", "shipping_state", "shipping_postcode", "shipping_country", "shipping_phone"
            ]
          },
          "example_usage": {
            "minimal_billing": {
              "billing_first_name": "John",
              "billing_email": "john@example.com"
            },
            "minimal_shipping": {
              "shipping_first_name": "Jane",
              "shipping_city": "Istanbul"
            }
          },
          "timestamp": DateTime.now().toIso8601String(),
        };
      }

      final request = UpdateCustomerRequest(
        billingAddress: billingAddress,
        shippingAddress: shippingAddress,
      );

      debugPrint('👤 Starting update customer information:');
      debugPrint('  - API Version: $apiVersion');
      debugPrint('  - Has Billing Address: ${billingAddress != null}');
      debugPrint('  - Has Shipping Address: ${shippingAddress != null}');
      if (billingAddress != null) {
        debugPrint('  - Billing Name: ${billingAddress.firstName} ${billingAddress.lastName}');
        debugPrint('  - Billing Email: ${billingAddress.email}');
        debugPrint('  - Billing City: ${billingAddress.city}');
      }
      if (shippingAddress != null) {
        debugPrint('  - Shipping Name: ${shippingAddress.firstName} ${shippingAddress.lastName}');
        debugPrint('  - Shipping City: ${shippingAddress.city}');
      }

      // Get CartService from DI
      final cartService = GetIt.I<CartService>();

      // Format JWT token with Bearer prefix if available
      final formattedJwtToken = (jwtToken != null && jwtToken.isNotEmpty)
          ? (jwtToken.startsWith('Bearer ') ? jwtToken : 'Bearer $jwtToken')
          : null;

      // Call the service
      final response = await cartService.updateCustomer(
        apiVersion: apiVersion,
        cartToken: cartToken,
        jwtToken: formattedJwtToken,
        request: request,
      );

      debugPrint('🔍 Update Customer Response Debug:');
      debugPrint('  - Items Count: ${response.itemsCount}');
      debugPrint('  - Items Weight: ${response.itemsWeight}');
      debugPrint('  - Needs Payment: ${response.needsPayment}');
      debugPrint('  - Needs Shipping: ${response.needsShipping}');
      debugPrint('  - Has Calculated Shipping: ${response.hasCalculatedShipping}');
      debugPrint('  - Billing Address Updated: ${response.billingAddress != null}');
      debugPrint('  - Shipping Address Updated: ${response.shippingAddress != null}');
      debugPrint('  - Payment Requirements: ${response.paymentRequirements}');
      debugPrint('  - Total Price: ${response.totals?.totalPrice}');
      debugPrint('  - Errors: ${response.errors}');

      // Check if there are any errors in the response
      if (response.errors != null && response.errors!.isNotEmpty) {
        debugPrint('❌ Update customer failed with errors: ${response.errors}');
        
        return {
          "status": "error",
          "message": "Failed to update customer information",
          "error_details": {
            "type": "customer_update_error",
            "errors": response.errors,
          },
          "params": params,
          "timestamp": DateTime.now().toIso8601String(),
        };
      }

      // Verify customer information was updated
      bool billingUpdated = response.billingAddress != null;
      bool shippingUpdated = response.shippingAddress != null;
      
      debugPrint('✅ Customer update completed');
      debugPrint('   - Billing Address Updated: $billingUpdated');
      debugPrint('   - Shipping Address Updated: $shippingUpdated');

      return {
        "status": "success",
        "message": "Customer information updated successfully",
        "auth_info": {
          "cart_token_source": params.containsKey('cart_token') && params['cart_token']!.isNotEmpty ? "manual" : "auto_storage",
          "jwt_token_source": params.containsKey('jwt_token') && params['jwt_token']!.isNotEmpty ? "manual" : "auto_storage",
          "cart_token_available": cartToken.isNotEmpty,
          "jwt_token_available": jwtToken != null && jwtToken.isNotEmpty,
        },
        "customer_info": {
          "billing_address_updated": billingUpdated,
          "shipping_address_updated": shippingUpdated,
          "billing_address": response.billingAddress?.toJson(),
          "shipping_address": response.shippingAddress?.toJson(),
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
        "coupons": response.coupons?.map((coupon) => {
          "code": coupon.code,
          "discount_type": coupon.discountType,
          "totals": coupon.totals?.toJson(),
        }).toList(),
        "shipping_rates": response.shippingRates?.map((rate) => rate.toJson()).toList(),
        "params": params,
        "timestamp": DateTime.now().toIso8601String(),
      };

    } catch (e) {
      debugPrint("🚨 Update Customer Error Details: $e");

      String errorMessage = "Failed to update customer information: ${e.toString()}";
      Map<String, dynamic> errorDetails = {};

      // Check if it's a network/HTTP related error
      if (e.toString().contains('DioException') ||
          e.toString().contains('DioError')) {
        debugPrint("🔍 Network Error detected");

        if (e.toString().contains('400')) {
          errorDetails['status_code'] = 400;
          errorMessage = "Invalid customer data. Please check all required fields";
        } else if (e.toString().contains('401')) {
          errorDetails['status_code'] = 401;
          errorMessage = "Unauthorized. Please check your JWT token";
        } else if (e.toString().contains('403')) {
          errorDetails['status_code'] = 403;
          errorMessage = "Access denied. Please check your permissions";
        } else if (e.toString().contains('404')) {
          errorDetails['status_code'] = 404;
          errorMessage = "Cart not found or update customer API not available";
        } else if (e.toString().contains('422')) {
          errorDetails['status_code'] = 422;
          errorMessage = "Invalid customer data format. Please verify address information";
        } else {
          errorMessage = "Network error occurred while updating customer information";
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
      } else if (e.toString().contains('customer') ||
                 e.toString().contains('address') ||
                 e.toString().contains('billing') ||
                 e.toString().contains('shipping')) {
        errorDetails['type'] = 'customer_data_error';
        errorMessage = "Invalid customer or address data";
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
          // Authentication fields (auto-loaded)
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
            isRequired: false,
          ),
          
          // Billing Address fields
          const ApiField(
            name: 'billing_first_name',
            label: 'Billing First Name',
            hint: 'Customer billing first name',
            isRequired: false,
          ),
          const ApiField(
            name: 'billing_last_name',
            label: 'Billing Last Name',
            hint: 'Customer billing last name',
            isRequired: false,
          ),
          const ApiField(
            name: 'billing_address_1',
            label: 'Billing Address Line 1',
            hint: 'First line of the billing address',
            isRequired: false,
          ),
          const ApiField(
            name: 'billing_address_2',
            label: 'Billing Address Line 2',
            hint: 'Second line of the billing address',
            isRequired: false,
          ),
          const ApiField(
            name: 'billing_city',
            label: 'Billing City',
            hint: 'City of the billing address',
            isRequired: false,
          ),
          const ApiField(
            name: 'billing_state',
            label: 'Billing State',
            hint: 'State, province, or district of the billing address',
            isRequired: false,
          ),
          const ApiField(
            name: 'billing_postcode',
            label: 'Billing Postcode',
            hint: 'Zip or Postcode of the billing address',
            isRequired: false,
          ),
          const ApiField(
            name: 'billing_country',
            label: 'Billing Country',
            hint: 'ISO code for the country of the billing address',
            isRequired: false,
          ),
          const ApiField(
            name: 'billing_email',
            label: 'Billing Email',
            hint: 'Customer email address',
            isRequired: false,
          ),
          const ApiField(
            name: 'billing_phone',
            label: 'Billing Phone',
            hint: 'Customer phone number',
            isRequired: false,
          ),
          
          // Shipping Address fields
          const ApiField(
            name: 'shipping_first_name',
            label: 'Shipping First Name',
            hint: 'Customer shipping first name',
            isRequired: false,
          ),
          const ApiField(
            name: 'shipping_last_name',
            label: 'Shipping Last Name',
            hint: 'Customer shipping last name',
            isRequired: false,
          ),
          const ApiField(
            name: 'shipping_address_1',
            label: 'Shipping Address Line 1',
            hint: 'First line of the shipping address',
            isRequired: false,
          ),
          const ApiField(
            name: 'shipping_address_2',
            label: 'Shipping Address Line 2',
            hint: 'Second line of the shipping address',
            isRequired: false,
          ),
          const ApiField(
            name: 'shipping_city',
            label: 'Shipping City',
            hint: 'City of the shipping address',
            isRequired: false,
          ),
          const ApiField(
            name: 'shipping_state',
            label: 'Shipping State',
            hint: 'State, province, or district of the shipping address',
            isRequired: false,
          ),
          const ApiField(
            name: 'shipping_postcode',
            label: 'Shipping Postcode',
            hint: 'Zip or Postcode of the shipping address',
            isRequired: false,
          ),
          const ApiField(
            name: 'shipping_country',
            label: 'Shipping Country',
            hint: 'ISO code for the country of the shipping address',
            isRequired: false,
          ),
          const ApiField(
            name: 'shipping_phone',
            label: 'Shipping Phone',
            hint: 'Customer shipping phone number',
            isRequired: false,
          ),
        ],
      };
}
