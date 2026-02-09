import 'package:storefront_supabase/app/models/product.dart';
import 'package:storefront_supabase/app/models/category.dart';

/// Product filter model for e-commerce filtering
class ProductFilters {
  final String? search;
  final String? categoryId; // Single category
  final List<String>? selectedTags; // Multiple tags
  final bool? onSale;
  final double? minPrice;
  final double? maxPrice;
  final String? orderBy; // 'date', 'price', 'popularity'
  final String? order; // 'asc' or 'desc'

  const ProductFilters({
    this.search,
    this.categoryId,
    this.selectedTags,
    this.onSale,
    this.minPrice,
    this.maxPrice,
    this.orderBy,
    this.order,
  });

  ProductFilters copyWith({
    String? search,
    String? categoryId,
    List<String>? selectedTags,
    bool? onSale,
    double? minPrice,
    double? maxPrice,
    String? orderBy,
    String? order,
    bool clearSearch = false,
    bool clearCategory = false,
    bool clearSelectedTags = false,
    bool clearOnSale = false,
    bool clearMinPrice = false,
    bool clearMaxPrice = false,
    bool clearOrderBy = false,
    bool clearOrder = false,
  }) {
    return ProductFilters(
      search: clearSearch ? null : (search ?? this.search),
      categoryId: clearCategory ? null : (categoryId ?? this.categoryId),
      selectedTags: clearSelectedTags ? null : (selectedTags ?? this.selectedTags),
      onSale: clearOnSale ? null : (onSale ?? this.onSale),
      minPrice: clearMinPrice ? null : (minPrice ?? this.minPrice),
      maxPrice: clearMaxPrice ? null : (maxPrice ?? this.maxPrice),
      orderBy: clearOrderBy ? null : (orderBy ?? this.orderBy),
      order: clearOrder ? null : (order ?? this.order),
    );
  }

  bool get hasActiveFilters {
    return search != null ||
        categoryId != null ||
        (selectedTags != null && selectedTags!.isNotEmpty) ||
        onSale != null ||
        minPrice != null ||
        maxPrice != null ||
        orderBy != null;
  }
}

/// Base state for product list
abstract class ProductListState {
  final List<Product> products;
  final bool hasMore;
  final int currentPage;
  final bool isLoadingProducts;
  final bool isLoadingFilterOptions;
  final String? productsError;
  final String? filterOptionsError;
  final List<Category> categories;
  final List<String> tags; // Available tags

  const ProductListState({
    this.products = const [],
    this.hasMore = false,
    this.currentPage = 1,
    this.isLoadingProducts = false,
    this.isLoadingFilterOptions = false,
    this.productsError,
    this.filterOptionsError,
    this.categories = const [],
    this.tags = const [],
  });
}

class ProductListInitialState extends ProductListState {
  const ProductListInitialState() : super();
}

class ProductListLoadingState extends ProductListState {
  const ProductListLoadingState({
    super.products,
    super.hasMore,
    super.currentPage,
    super.isLoadingFilterOptions,
    super.filterOptionsError,
    super.categories,
    super.tags,
  }) : super(isLoadingProducts: true);
}

class ProductListLoadedState extends ProductListState {
  const ProductListLoadedState({
    required super.products,
    required super.hasMore,
    required super.currentPage,
    super.isLoadingFilterOptions,
    super.filterOptionsError,
    super.categories,
    super.tags,
  }) : super(isLoadingProducts: false);
}

class ProductListErrorState extends ProductListState {
  final String message;

  const ProductListErrorState({
    required this.message,
    super.products,
    super.hasMore,
    super.currentPage,
    super.isLoadingFilterOptions,
    super.filterOptionsError,
    super.categories,
    super.tags,
  }) : super(isLoadingProducts: false, productsError: message);
}

class ProductListFilterOptionsLoadingState extends ProductListState {
  const ProductListFilterOptionsLoadingState({
    super.products,
    super.hasMore,
    super.currentPage,
    super.isLoadingProducts,
    super.productsError,
    super.categories,
    super.tags,
  }) : super(isLoadingFilterOptions: true);
}

class ProductListFilterOptionsLoadedState extends ProductListState {
  const ProductListFilterOptionsLoadedState({
    super.products,
    super.hasMore,
    super.currentPage,
    super.isLoadingProducts,
    super.productsError,
    super.categories,
    super.tags,
  }) : super(isLoadingFilterOptions: false);
}

class ProductListFilterOptionsErrorState extends ProductListState {
  final String message;

  const ProductListFilterOptionsErrorState({
    required this.message,
    super.products,
    super.hasMore,
    super.currentPage,
    super.isLoadingProducts,
    super.productsError,
    super.categories,
    super.tags,
  }) : super(isLoadingFilterOptions: false, filterOptionsError: message);
}
