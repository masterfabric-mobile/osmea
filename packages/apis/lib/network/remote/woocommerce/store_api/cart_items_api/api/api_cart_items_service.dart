 import 'package:apis/apis.dart';
import 'package:apis/dio_config/dio_client/api_dio_client.dart';
import 'package:apis/network/remote/woocommerce/store_api/cart_items_api/abstract/cart_items_service.dart';
import 'package:apis/network/remote/woocommerce/store_api/cart_items_api/freezed_model/response/cart_item.dart';
import 'package:apis/network/remote/woocommerce/store_api/cart_items_api/freezed_model/response/add_cart_item_response.dart';
import 'package:apis/network/remote/woocommerce/store_api/cart_items_api/freezed_model/response/edit_single_cart_item_response.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'api_cart_items_service.g.dart';

/// 🌐 CartItemsServiceClient
/// Retrofit client for WooCommerce Store API Cart Items.
/// Make sure WooNetwork.storeUrl is set and authentication is configured before using! 🏬🔑
@RestApi()
@Injectable(as: CartItemsService)
abstract class CartItemsServiceClient implements CartItemsService {
  /// 🏭 Factory for dependency injection
  @factoryMethod
  factory CartItemsServiceClient(Dio dio) => _CartItemsServiceClient(
        ApiDioClient.wooDio(),
        baseUrl: WooNetwork.baseUrl,
      );

  /// 🛒 Get cart items from WooCommerce Store API
  /// This endpoint provides detailed information about all items currently in the cart.
  /// Returns a List<CartItem> since the API returns an array, not an object.
  /// No extra parameters are needed according to the documentation.
  @override
  @GET('/wp-json/wc/store/{api_version}/cart/items')
  Future<List<CartItem>> listCartItems({
    @Path('api_version') required String apiVersion,
  });

  /// 🛒 Get a single cart item by its key from WooCommerce Store API
  /// Requires JWT authentication and cart token headers for proper authorization.
  /// Returns List<CartItem> because API always returns array format, even for single item.
  @override
  @GET('/wp-json/wc/store/{api_version}/cart/items')
  Future<List<CartItem>> getSingleCartItem({
    @Path('api_version') required String apiVersion,
    @Header('CART_TOKEN') required String cartToken,
    @Header('Authorization') required String jwtToken,
    @Query('key') required String key,
  });

  /// 🛒 Add an item to the cart via WooCommerce Store API
  /// Requires JWT authentication and cart token headers for proper authorization.
  /// POST request with id, quantity and optional variation parameters.
  @override
  @POST('/wp-json/wc/store/{api_version}/cart/items')
  Future<AddCartItemResponse> addCartItem({
    @Path('api_version') required String apiVersion,
    @Header('CART_TOKEN') required String cartToken,
    @Header('Authorization') required String jwtToken,
    @Field('id') required int id,
    @Field('quantity') required int quantity,
    @Field('variation') List<Map<String, dynamic>>? variation,
  });

  /// 🛒 Edit a single cart item by its key via WooCommerce Store API
  /// Requires JWT authentication and cart token headers for proper authorization.
  /// PUT request with key path parameter and quantity query parameter.
  @override
  @PUT('/wp-json/wc/store/{api_version}/cart/items/{key}')
  Future<EditSingleCartItemResponse> editSingleCartItem({
    @Path('api_version') required String apiVersion,
    @Header('CART_TOKEN') required String cartToken,
    @Header('Authorization') required String jwtToken,
    @Path('key') required String key,
    @Query('quantity') required int quantity,
  });

  /// 🗑️ Delete all cart items from the cart via WooCommerce Store API
  /// Requires JWT authentication and cart token headers for proper authorization.
  /// DELETE request returns empty array when successful.
  @override
  @DELETE('/wp-json/wc/store/{api_version}/cart/items')
  Future<List<CartItem>> deleteAllCartItems({
    @Path('api_version') required String apiVersion,
    @Header('CART_TOKEN') required String cartToken,
    @Header('Authorization') required String jwtToken,
  });
}
