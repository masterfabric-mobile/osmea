import 'package:apis/network/remote/woocommerce/store_api/product_api/freezed_model/response/list_all_products_response_model.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_attributes_api/freezed_model/response/list_product_attributes_response_model.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_attribute_terms/freezed_model/response/list_product_attribute_terms_response_model.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_categories_api/freezed_model/response/list_product_categories_response_model.dart';

/// Model to hold attribute with its terms
class AttributeWithTerms {
  final ListProductAttributesResponseModel attribute;
  final List<ListProductAttributeTermsResponseModel> terms;

  const AttributeWithTerms({required this.attribute, required this.terms});
}

/// Base state for product list
abstract class ProductListState {
  /// Current products list (may be empty during loading)
  final List<ListAllProductsResponseModel> products;

  /// Pagination info
  final bool hasMore;
  final int currentPage;
  final int totalPages;

  /// Whether products are currently loading
  final bool isLoadingProducts;

  /// Whether filter options are currently loading
  final bool isLoadingFilterOptions;

  /// Error message for products loading (null if no error)
  final String? productsError;

  /// Error message for filter options loading (null if no error)
  final String? filterOptionsError;

  /// Attributes with their terms for filtering
  final List<AttributeWithTerms> attributesWithTerms;

  /// Available categories for filtering
  final List<ListProductCategoriesResponseModel> categories;

  const ProductListState({
    this.products = const [],
    this.hasMore = false,
    this.currentPage = 1,
    this.totalPages = 1,
    this.isLoadingProducts = false,
    this.isLoadingFilterOptions = false,
    this.productsError,
    this.filterOptionsError,
    this.attributesWithTerms = const [],
    this.categories = const [],
  });
}

/// Initial state - nothing loaded yet
class ProductListInitialState extends ProductListState {
  const ProductListInitialState() : super();
}

/// Products are loading
class ProductListLoadingState extends ProductListState {
  const ProductListLoadingState({
    super.products,
    super.hasMore,
    super.currentPage,
    super.totalPages,
    super.isLoadingFilterOptions,
    super.filterOptionsError,
    super.attributesWithTerms,
    super.categories,
  }) : super(isLoadingProducts: true);
}

/// Products loaded successfully
class ProductListLoadedState extends ProductListState {
  const ProductListLoadedState({
    required super.products,
    required super.hasMore,
    required super.currentPage,
    required super.totalPages,
    super.isLoadingFilterOptions,
    super.filterOptionsError,
    super.attributesWithTerms,
    super.categories,
  }) : super(isLoadingProducts: false);
}

/// Error loading products
class ProductListErrorState extends ProductListState {
  final String message;

  const ProductListErrorState({
    required this.message,
    super.products,
    super.hasMore,
    super.currentPage,
    super.totalPages,
    super.isLoadingFilterOptions,
    super.filterOptionsError,
    super.attributesWithTerms,
    super.categories,
  }) : super(isLoadingProducts: false, productsError: message);
}

/// Filter options are loading
class ProductListFilterOptionsLoadingState extends ProductListState {
  const ProductListFilterOptionsLoadingState({
    super.products,
    super.hasMore,
    super.currentPage,
    super.totalPages,
    super.isLoadingProducts,
    super.productsError,
    super.attributesWithTerms,
    super.categories,
  }) : super(isLoadingFilterOptions: true);
}

/// Filter options loaded successfully
class ProductListFilterOptionsLoadedState extends ProductListState {
  const ProductListFilterOptionsLoadedState({
    super.products,
    super.hasMore,
    super.currentPage,
    super.totalPages,
    super.isLoadingProducts,
    super.productsError,
    super.attributesWithTerms,
    super.categories,
  }) : super(isLoadingFilterOptions: false);
}

/// Error loading filter options
class ProductListFilterOptionsErrorState extends ProductListState {
  final String message;

  const ProductListFilterOptionsErrorState({
    required this.message,
    super.products,
    super.hasMore,
    super.currentPage,
    super.totalPages,
    super.isLoadingProducts,
    super.productsError,
    super.attributesWithTerms,
    super.categories,
  }) : super(isLoadingFilterOptions: false, filterOptionsError: message);
}
