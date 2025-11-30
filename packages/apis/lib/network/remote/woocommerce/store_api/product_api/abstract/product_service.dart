import 'package:apis/network/remote/woocommerce/store_api/product_api/freezed_model/response/list_all_products_response_model.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_api/freezed_model/response/retrieve_product_response_model.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_api/freezed_model/response/retrieve_product_by_slug_response_model.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_api/freezed_model/response/list_product_variations_response_model.dart';

/// 🔑 Abstract contract for WooCommerce Store API Product Service
/// Implement this to fetch products from WooCommerce Store API! 🌐
abstract class ProductService {
  /// 🛍️ Fetches all products from the WooCommerce Store API.
  ///
  /// [apiVersion]: The API version to use (e.g., 'v1').
  /// [page]: Page number for pagination (default: 1).
  /// [perPage]: Number of items per page (default: 10).
  /// [search]: Search query to filter products.
  /// [orderBy]: Order products by field (e.g., 'date', 'id', 'title', 'price').
  /// [order]: Sort order ('asc' or 'desc').
  /// [category]: Filter by category ID.
  /// [tag]: Filter by tag ID.
  /// [status]: Filter by product status ('publish', 'draft', 'private').
  /// [featured]: Filter by featured products (true/false).
  /// [onSale]: Filter by products on sale (true/false).
  /// [minPrice]: Minimum price filter.
  /// [maxPrice]: Maximum price filter.
  /// [stockStatus]: Filter by stock status ('instock', 'outofstock', 'onbackorder').
  /// [attribute]: Filter by product attribute.
  /// [attributeTerm]: Filter by product attribute term.
  /// [shippingClass]: Filter by shipping class ID.
  /// [after]: Return products published after a given ISO8601 compliant date.
  /// [before]: Return products published before a given ISO8601 compliant date.
  /// [exclude]: Ensure result set excludes specific IDs.
  /// [include]: Limit result set to specific IDs.
  /// [parent]: Limit result set to products of a specific parent ID.
  /// [parentExclude]: Limit result set to all products except those of a specific parent ID.
  /// [slug]: Limit result set to products with a specific slug.
  /// [type]: Limit result set to products assigned a specific type.
  /// [sku]: Limit result set to products with a specific SKU.
  /// [featured]: Limit result set to featured products.
  /// [catalogVisibility]: Limit result set to products assigned a specific catalog visibility.
  /// [reviewCount]: Limit result set to products with a specific review count.
  /// [averageRating]: Limit result set to products with a specific average rating.
  /// [minRating]: Limit result set to products with a minimum rating.
  /// [maxRating]: Limit result set to products with a maximum rating.
  /// [brand]: Filter by brand ID or slug (as string).
  Future<List<ListAllProductsResponseModel>> listAllProducts({
    required String apiVersion,
    int page = 1,
    int perPage = 10,
    String? search,
    String? orderBy,
    String? order,
    int? category,
    int? tag,
    String? status,
    bool? featured,
    bool? onSale,
    String? minPrice,
    String? maxPrice,
    String? stockStatus,
    String? attribute,
    String? attributeTerm,
    int? shippingClass,
    String? after,
    String? before,
    List<int>? exclude,
    List<int>? include,
    int? parent,
    List<int>? parentExclude,
    String? slug,
    String? type,
    String? sku,
    String? catalogVisibility,
    int? reviewCount,
    double? averageRating,
    double? minRating,
    double? maxRating,
    String? brand,
  });

  /// 🔍 Fetches a single product by ID from the WooCommerce Store API.
  ///
  /// [apiVersion]: The API version to use (e.g., 'v1').
  /// [productId]: The ID of the product to retrieve.
  Future<RetrieveProductResponseModel> retrieveProduct({
    required String apiVersion,
    required int productId,
  });

  /// 🔍 Fetches a single product by slug from the WooCommerce Store API.
  ///
  /// [apiVersion]: The API version to use (e.g., 'v1').
  /// [productSlug]: The slug of the product to retrieve.
  Future<RetrieveProductBySlugResponseModel> retrieveProductBySlug({
    required String apiVersion,
    required String productSlug,
  });

  /// 🎨 Fetches all product variations by type from the WooCommerce Store API.
  ///
  /// [apiVersion]: The API version to use (e.g., 'v1').
  /// [type]: The product type to filter variations (e.g., 'simple', 'variable').
  Future<List<ListProductVariationsResponseModel>> listAllVariationsByType({
    required String apiVersion,
    required String type,
  });
}
