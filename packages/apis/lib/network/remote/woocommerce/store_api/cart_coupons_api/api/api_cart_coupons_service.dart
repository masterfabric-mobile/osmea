import 'package:apis/apis.dart';
import 'package:apis/dio_config/dio_client/api_dio_client.dart';
import 'package:apis/network/remote/woocommerce/store_api/cart_coupons_api/abstract/cart_coupons_service.dart';
import 'package:apis/network/remote/woocommerce/store_api/cart_coupons_api/freezed_model/response/list_cart_coupons_response_model.dart';
import 'package:apis/network/remote/woocommerce/store_api/cart_coupons_api/freezed_model/response/retrieve_cart_coupon_response_model.dart';
import 'package:apis/network/remote/woocommerce/store_api/cart_coupons_api/freezed_model/response/add_cart_coupon_response_model.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'api_cart_coupons_service.g.dart';

/// 🌐 CartCouponsServiceClient
/// Retrofit client for WooCommerce Store API Cart Coupons.
/// Make sure WooNetwork.storeUrl is set before using! 🏬🔑
@RestApi()
@Injectable(as: CartCouponsService)
abstract class CartCouponsServiceClient implements CartCouponsService {
  /// 🏭 Factory for dependency injection
  @factoryMethod
  factory CartCouponsServiceClient(Dio dio) => _CartCouponsServiceClient(
        ApiDioClient.wooDio(),
        baseUrl: WooNetwork.baseUrl,
      );

  /// 🛒 Get cart coupons from WooCommerce Store API
  /// Retrieves list of discount codes applied to the current cart
  @override
  @GET('/wp-json/wc/store/{api_version}/cart/coupons')
  Future<List<ListCartCouponsResponseModel>> getCartCoupons({
    @Path('api_version') required String apiVersion,
  });

  /// 🛒 Get single cart coupon by code from WooCommerce Store API
  /// Retrieves detailed information about a specific coupon applied to the cart
  @override
  @GET('/wp-json/wc/store/{api_version}/cart/coupons/{coupon_code}')
  Future<RetrieveCartCouponResponseModel> getCartCoupon({
    @Path('api_version') required String apiVersion,
    @Path('coupon_code') required String couponCode,
  });

  /// 🛒 Add coupon to cart in WooCommerce Store API
  /// Applies a discount code to the current cart
  @override
  @POST('/wp-json/wc/store/{api_version}/cart/coupons')
  Future<AddCartCouponResponseModel> addCartCoupon({
    @Path('api_version') required String apiVersion,
    @Query('code') required String couponCode,
  });

  /// 🛒 Delete single cart coupon in WooCommerce Store API
  /// Removes a specific discount code from the current cart
  @override
  @DELETE('/wp-json/wc/store/{api_version}/cart/coupons/{coupon_code}')
  Future<void> deleteCartCoupon({
    @Path('api_version') required String apiVersion,
    @Path('coupon_code') required String couponCode,
  });

  /// 🛒 Delete all cart coupons in WooCommerce Store API
  /// Removes all discount codes from the current cart
  @override
  @DELETE('/wp-json/wc/store/{api_version}/cart/coupons')
  Future<void> deleteAllCartCoupons({
    @Path('api_version') required String apiVersion,
  });
}
