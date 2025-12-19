import 'package:storefront_supabase/app/models/brand.dart';
import 'package:storefront_supabase/app/models/category.dart';
import 'package:storefront_supabase/app/models/product.dart';
import 'package:storefront_supabase/app/models/product_filters.dart';

abstract class SupabaseHomeState {}

class SupabaseHomeInitialState extends SupabaseHomeState {}

class SupabaseHomeLoadingState extends SupabaseHomeState {}

class SupabaseHomeLoadedState extends SupabaseHomeState {
  final List<Product> products;
  final String searchQuery;
  final PriceSort priceSort;
  final DateSort dateSort;
  final PopularitySort popularitySort;

  // For populating filter options
  final List<Category> allCategories;
  final List<Brand> allBrands;

  // For tracking selected filters
  final Set<String> selectedCategoryIds;
  final Set<int> selectedBrandIds;

  SupabaseHomeLoadedState({
    required this.products,
    this.searchQuery = '',
    this.priceSort = PriceSort.none,
    this.dateSort = DateSort.newestFirst,
    this.popularitySort = PopularitySort.none,
    this.allCategories = const [],
    this.allBrands = const [],
    this.selectedCategoryIds = const {},
    this.selectedBrandIds = const <int>{},
  });

  SupabaseHomeLoadedState copyWith({
    List<Product>? products,
    String? searchQuery,
    PriceSort? priceSort,
    DateSort? dateSort,
    PopularitySort? popularitySort,
    List<Category>? allCategories,
    List<Brand>? allBrands,
    Set<String>? selectedCategoryIds,
    Set<int>? selectedBrandIds,
  }) {
    return SupabaseHomeLoadedState(
      products: products ?? this.products,
      searchQuery: searchQuery ?? this.searchQuery,
      priceSort: priceSort ?? this.priceSort,
      dateSort: dateSort ?? this.dateSort,
      popularitySort: popularitySort ?? this.popularitySort,
      allCategories: allCategories ?? this.allCategories,
      allBrands: allBrands ?? this.allBrands,
      selectedCategoryIds: selectedCategoryIds ?? this.selectedCategoryIds,
      selectedBrandIds: selectedBrandIds ?? this.selectedBrandIds,
    );
  }
}

class SupabaseHomeErrorState extends SupabaseHomeState {
  final String message;

  SupabaseHomeErrorState(this.message);
}