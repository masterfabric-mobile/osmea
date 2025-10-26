import 'package:apis/network/remote/woocommerce/store_api/cart_api/freezed_model/request/update_customer_request.dart';
import 'package:apis/network/remote/woocommerce/store_api/cart_api/freezed_model/response/add_item_response.dart';
import 'package:apis/network/remote/woocommerce/store_api/cart_api/freezed_model/response/apply_coupon_response.dart';
import 'package:apis/network/remote/woocommerce/store_api/cart_api/freezed_model/response/get_cart_response.dart';
import 'package:apis/network/remote/woocommerce/store_api/cart_api/freezed_model/response/remove_coupon_response.dart';
import 'package:apis/network/remote/woocommerce/store_api/cart_api/freezed_model/response/remove_item_response.dart';
import 'package:apis/network/remote/woocommerce/store_api/cart_api/freezed_model/response/select_shipping_rate_response.dart';
import 'package:apis/network/remote/woocommerce/store_api/cart_api/freezed_model/response/update_customer_response.dart';
import 'package:apis/network/remote/woocommerce/store_api/cart_api/freezed_model/response/update_item_response.dart';

/// 🔑 Abstract contract for WooCommerce Store API Cart Service
/// Implement this to fetch cart from WooCommerce Store API! 🌐
abstract class CartService {
  /// 🚀 Fetches the cart contents from the WooCommerce Store API.
  /// JWT token is optional - you can get it from this response for subsequent requests.
  Future<GetCartResponse> getCart({
    required String apiVersion,
    String? jwtToken,
  });

  /// 🛒 Adds an item to the cart using WooCommerce Store API.
  /// Cart token is required, JWT authentication is optional.
  Future<AddItemResponse> addItem({
    required String apiVersion,
    required String cartToken,
    String? jwtToken, // Optional JWT token
    required int id,
    required int quantity,
    List<dynamic>? variation,
  });

  /// 🗑️ Removes an item from the cart using WooCommerce Store API.
  /// Cart token is required, JWT authentication is optional.
  Future<RemoveItemResponse> removeItem({
    required String apiVersion,
    required String cartToken,
    String? jwtToken, // Optional JWT token
    required String key,
  });

  /// 📝 Updates an item in the cart using WooCommerce Store API.
  /// Cart token is required, JWT authentication is optional.
  Future<UpdateItemResponse> updateItem({
    required String apiVersion,
    required String cartToken,
    String? jwtToken, // Optional JWT token
    required String key,
    required int quantity,
  });

  /// 🎫 Applies a coupon to the cart using WooCommerce Store API.
  /// Cart token is required, JWT authentication is optional.
  Future<ApplyCouponResponse> applyCoupon({
    required String apiVersion,
    required String cartToken,
    String? jwtToken, // Optional JWT token
    required String code,
  });

  /// 🗑️ Removes a coupon from the cart using WooCommerce Store API.
  /// Cart token is required, JWT authentication is optional.
  Future<RemoveCouponResponse> removeCoupon({
    required String apiVersion,
    required String cartToken,
    String? jwtToken, // Optional JWT token
    required String code,
  });

  /// 👤 Updates customer information in the cart using WooCommerce Store API.
  /// Requires JWT authentication and cart token for proper authorization.
  Future<UpdateCustomerResponse> updateCustomer({
    required String apiVersion,
    required String cartToken,
    String? jwtToken, // Optional JWT token
    required UpdateCustomerRequest request,
  });

  /// 🚚 Selects a shipping rate for a package in the cart using WooCommerce Store API.
  /// Requires JWT authentication and cart token for proper authorization.
  Future<SelectShippingRateResponse> selectShippingRate({
    required String apiVersion,
    required String cartToken,
    String? jwtToken, // Optional JWT token
    required int packageId,
    required String rateId,
  });
}