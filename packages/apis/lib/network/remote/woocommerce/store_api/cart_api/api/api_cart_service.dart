import 'package:apis/apis.dart';
import 'package:apis/dio_config/dio_client/api_dio_client.dart';
import 'package:apis/network/remote/woocommerce/store_api/cart_api/abstract/cart_service.dart';
import 'package:apis/network/remote/woocommerce/store_api/cart_api/freezed_model/request/update_customer_request.dart';
import 'package:apis/network/remote/woocommerce/store_api/cart_api/freezed_model/response/add_item_response.dart';
import 'package:apis/network/remote/woocommerce/store_api/cart_api/freezed_model/response/apply_coupon_response.dart';
import 'package:apis/network/remote/woocommerce/store_api/cart_api/freezed_model/response/get_cart_response.dart';
import 'package:apis/network/remote/woocommerce/store_api/cart_api/freezed_model/response/remove_coupon_response.dart';
import 'package:apis/network/remote/woocommerce/store_api/cart_api/freezed_model/response/remove_item_response.dart';
import 'package:apis/network/remote/woocommerce/store_api/cart_api/freezed_model/response/select_shipping_rate_response.dart';
import 'package:apis/network/remote/woocommerce/store_api/cart_api/freezed_model/response/update_customer_response.dart';
import 'package:apis/network/remote/woocommerce/store_api/cart_api/freezed_model/response/update_item_response.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'api_cart_service.g.dart';

/// 🌐 CartServiceClient
/// Retrofit client for WooCommerce Store API Cart.
/// Make sure WooNetwork.storeUrl is set and JWT auth is configured before using! 🏬🔑
@RestApi()
@Injectable(as: CartService)
abstract class CartServiceClient implements CartService {
  /// 🏭 Factory for dependency injection
  @factoryMethod
  factory CartServiceClient(Dio dio) => _CartServiceClient(
        ApiDioClient.wooDio(),
        baseUrl: WooNetwork.baseUrl,
      );

  /// 🛒 Get cart contents from WooCommerce Store API
  /// JWT token is optional - you can get JWT from this response for subsequent requests! 🔑
  @override
  @GET('/wp-json/wc/store/{api_version}/cart')
  Future<GetCartResponse> getCart({
    @Path('api_version') required String apiVersion,
    @Header('Authorization') String? jwtToken,
  });

  /// 🛍️ Add item to cart using WooCommerce Store API
  /// Requires JWT authentication and cart token headers! 🔑
  @override
  @POST('/wp-json/wc/store/{api_version}/cart/add-item')
  Future<AddItemResponse> addItem({
    @Path('api_version') required String apiVersion,
    @Header('CART_TOKEN') required String cartToken,
    @Header('Authorization') required String jwtToken,
    @Field('id') required int id,
    @Field('quantity') required int quantity,
    @Field('variation') List<dynamic>? variation,
  });

  /// 🗑️ Remove item from cart using WooCommerce Store API
  /// Requires JWT authentication and cart token headers! 🔑
  @override
  @POST('/wp-json/wc/store/{api_version}/cart/remove-item')
  Future<RemoveItemResponse> removeItem({
    @Path('api_version') required String apiVersion,
    @Header('CART_TOKEN') required String cartToken,
    @Header('Authorization') required String jwtToken,
    @Query('key') required String key,
  });

  /// 📝 Update item in cart using WooCommerce Store API
  /// Requires JWT authentication and cart token headers! 🔑
  @override
  @POST('/wp-json/wc/store/{api_version}/cart/update-item')
  Future<UpdateItemResponse> updateItem({
    @Path('api_version') required String apiVersion,
    @Header('CART_TOKEN') required String cartToken,
    @Header('Authorization') required String jwtToken,
    @Query('key') required String key,
    @Query('quantity') required int quantity,
  });

  /// 🎫 Apply coupon to cart using WooCommerce Store API
  /// Requires JWT authentication and cart token headers! 🔑
  @override
  @POST('/wp-json/wc/store/{api_version}/cart/apply-coupon')
  Future<ApplyCouponResponse> applyCoupon({
    @Path('api_version') required String apiVersion,
    @Header('CART_TOKEN') required String cartToken,
    @Header('Authorization') required String jwtToken,
    @Query('code') required String code,
  });

  /// 🗑️ Remove coupon from cart using WooCommerce Store API
  /// Requires JWT authentication and cart token headers! 🔑
  @override
  @POST('/wp-json/wc/store/{api_version}/cart/remove-coupon')
  Future<RemoveCouponResponse> removeCoupon({
    @Path('api_version') required String apiVersion,
    @Header('CART_TOKEN') required String cartToken,
    @Header('Authorization') required String jwtToken,
    @Query('code') required String code,
  });

  /// 👤 Update customer information in cart using WooCommerce Store API
  /// Requires JWT authentication and cart token headers! 🔑
  @override
  @POST('/wp-json/wc/store/{api_version}/cart/update-customer')
  Future<UpdateCustomerResponse> updateCustomer({
    @Path('api_version') required String apiVersion,
    @Header('CART_TOKEN') required String cartToken,
    @Header('Authorization') required String jwtToken,
    @Body() required UpdateCustomerRequest request,
  });

  /// 🚚 Select shipping rate for a package in cart using WooCommerce Store API
  /// Requires JWT authentication and cart token headers! 🔑
  @override
  @POST('/wp-json/wc/store/{api_version}/cart/select-shipping-rate')
  Future<SelectShippingRateResponse> selectShippingRate({
    @Path('api_version') required String apiVersion,
    @Header('CART_TOKEN') required String cartToken,
    @Header('Authorization') required String jwtToken,
    @Query('package_id') required int packageId,
    @Query('rate_id') required String rateId,
  });
}