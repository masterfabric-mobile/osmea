import 'package:apis/apis.dart';
import 'package:apis/dio_config/dio_client/api_dio_client.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_api/abstract/product_service.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_api/freezed_model/response/list_all_products_response_model.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_api/freezed_model/response/retrieve_product_response_model.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_api/freezed_model/response/retrieve_product_by_slug_response_model.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_api/freezed_model/response/list_product_variations_response_model.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'api_product_service.g.dart';

/// 🌐 ProductServiceClient
/// Retrofit client for WooCommerce Store API Products.
/// Make sure WooNetwork.storeUrl is set and authentication is configured before using! 🏬🔑
@RestApi()
@Injectable(as: ProductService)
abstract class ProductServiceClient implements ProductService {
  /// 🏭 Factory for dependency injection
  @factoryMethod
  factory ProductServiceClient(Dio dio) => _ProductServiceClient(
        ApiDioClient.wooPublicDio(),
        baseUrl: WooNetwork.storeUrl,
      );

  /// 🛍️ Get all products from WooCommerce Store API
  @override
  @GET('/wp-json/wc/store/{api_version}/products')
  Future<List<ListAllProductsResponseModel>> listAllProducts({
    @Path('api_version') required String apiVersion,
    @Query('page') int page = 1,
    @Query('per_page') int perPage = 10,
    @Query('search') String? search,
    @Query('orderby') String? orderBy,
    @Query('order') String? order,
    @Query('category') int? category,
    @Query('tag') int? tag,
    @Query('status') String? status,
    @Query('featured') bool? featured,
    @Query('on_sale') bool? onSale,
    @Query('min_price') String? minPrice,
    @Query('max_price') String? maxPrice,
    @Query('stock_status') String? stockStatus,
    @Query('attribute') String? attribute,
    @Query('attribute_term') String? attributeTerm,
    @Query('shipping_class') int? shippingClass,
    @Query('after') String? after,
    @Query('before') String? before,
    @Query('exclude') List<int>? exclude,
    @Query('include') List<int>? include,
    @Query('parent') int? parent,
    @Query('parent_exclude') List<int>? parentExclude,
    @Query('slug') String? slug,
    @Query('type') String? type,
    @Query('sku') String? sku,
    @Query('catalog_visibility') String? catalogVisibility,
    @Query('review_count') int? reviewCount,
    @Query('average_rating') double? averageRating,
    @Query('min_rating') double? minRating,
    @Query('max_rating') double? maxRating,
  });

  /// 🔍 Get a single product by ID from WooCommerce Store API
  @override
  @GET('/wp-json/wc/store/{api_version}/products/{product_id}')
  Future<RetrieveProductResponseModel> retrieveProduct({
    @Path('api_version') required String apiVersion,
    @Path('product_id') required int productId,
  });

  /// 🔍 Get a single product by slug from WooCommerce Store API
  @override
  @GET('/wp-json/wc/store/{api_version}/products/{product_slug}')
  Future<RetrieveProductBySlugResponseModel> retrieveProductBySlug({
    @Path('api_version') required String apiVersion,
    @Path('product_slug') required String productSlug,
  });

  /// 🎨 Get all product variations by type from WooCommerce Store API
  @override
  @GET('/wp-json/wc/store/{api_version}/products')
  Future<List<ListProductVariationsResponseModel>> listAllVariationsByType({
    @Path('api_version') required String apiVersion,
    @Query('type') required String type,
  });
}
