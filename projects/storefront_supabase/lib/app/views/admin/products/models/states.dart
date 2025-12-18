import 'package:storefront_supabase/app/models/brand.dart';
import 'package:storefront_supabase/app/models/category.dart';
import 'package:storefront_supabase/app/models/product.dart';
import 'package:storefront_supabase/app/views/admin/products/models/product_filters.dart';

abstract class AdminProductsState {}

class AdminProductsInitial extends AdminProductsState {}

class AdminProductsLoading extends AdminProductsState {}

class AdminProductsLoaded extends AdminProductsState {
  final List<Product> products;
  final String searchQuery;
  final PriceSort priceSort;
  final DateSort dateSort;
  final PopularitySort popularitySort; // Added popularitySort

  // For populating filter options
  final List<Category> allCategories;
  final List<Brand> allBrands;

  // For tracking selected filters
  final Set<String> selectedCategoryIds;
  final Set<int> selectedBrandIds;

  AdminProductsLoaded({
    required this.products,
    this.searchQuery = '',
    this.priceSort = PriceSort.none,
    this.dateSort = DateSort.newestFirst,
    this.popularitySort = PopularitySort.none, // Default value
    this.allCategories = const [],
    this.allBrands = const [],
    this.selectedCategoryIds = const {},
    this.selectedBrandIds = const <int>{},
  });

  AdminProductsLoaded copyWith({
    List<Product>? products,
    String? searchQuery,
    PriceSort? priceSort,
    DateSort? dateSort,
    PopularitySort? popularitySort, // Added popularitySort
    List<Category>? allCategories,
    List<Brand>? allBrands,
    Set<String>? selectedCategoryIds,
    Set<int>? selectedBrandIds,
  }) {
    return AdminProductsLoaded(
      products: products ?? this.products,
      searchQuery: searchQuery ?? this.searchQuery,
      priceSort: priceSort ?? this.priceSort,
      dateSort: dateSort ?? this.dateSort,
      popularitySort: popularitySort ?? this.popularitySort, // Copy popularitySort
      allCategories: allCategories ?? this.allCategories,
      allBrands: allBrands ?? this.allBrands,
      selectedCategoryIds: selectedCategoryIds ?? this.selectedCategoryIds,
      selectedBrandIds: selectedBrandIds ?? this.selectedBrandIds,
    );
  }
}

class AdminProductsError extends AdminProductsState {
  final String message;
  AdminProductsError(this.message);
}
