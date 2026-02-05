import 'package:storefront_supabase/app/models/brand.dart';
import 'package:storefront_supabase/app/models/category.dart';
import 'package:storefront_supabase/app/models/product.dart';
import 'package:storefront_supabase/app/models/product_filters.dart';

abstract class SupabaseHomeState {}

class SupabaseHomeInitialState extends SupabaseHomeState {}

class SupabaseHomeLoadingState extends SupabaseHomeState {}

class SupabaseHomeLoadedState extends SupabaseHomeState {
  final List<Product> products;
  final List<Product> onSaleProducts;
  final List<Product> productsOfTheDay;
  final List<Product> recommendedProducts; // Added
  final List<Product> collectionProducts; // Added
  final String searchQuery;
  final PriceSort priceSort;
  final DateSort dateSort;
  final PopularitySort popularitySort;

  // For populating filter options
  final List<Category> allCategories;
  final List<Brand> allBrands;

  // For tracking selected filters
  final Category? selectedRootCategory;
  final Category? selectedSubCategory;
  final Category? selectedLeafCategory;
  final Set<int> selectedBrandIds;
  final List<String> selectedSizesOrAges;
  final bool isLoading;
  final bool isListView;
  final bool showLoginSuccessSnackbar;

  SupabaseHomeLoadedState({
    required this.products,
    this.onSaleProducts = const [],
    this.productsOfTheDay = const [],
    this.recommendedProducts = const [], // Default empty
    this.collectionProducts = const [], // Default empty
    this.searchQuery = '',
    this.priceSort = PriceSort.none,
    this.dateSort = DateSort.newestFirst,
    this.popularitySort = PopularitySort.none,
    this.allCategories = const [],
    this.allBrands = const [],
    this.selectedRootCategory,
    this.selectedSubCategory,
    this.selectedLeafCategory,
    this.selectedBrandIds = const <int>{},
    this.selectedSizesOrAges = const [],
    this.isLoading = false,
    this.isListView = false,
    this.showLoginSuccessSnackbar = false,
  });

  SupabaseHomeLoadedState copyWith({
    List<Product>? products,
    List<Product>? onSaleProducts,
    List<Product>? productsOfTheDay,
    List<Product>? recommendedProducts, // Added
    List<Product>? collectionProducts, // Added
    String? searchQuery,
    PriceSort? priceSort,
    DateSort? dateSort,
    PopularitySort? popularitySort,
    List<Category>? allCategories,
    List<Brand>? allBrands,
    Category? selectedRootCategory,
    Category? selectedSubCategory,
    Category? selectedLeafCategory,
    Set<int>? selectedBrandIds,
    List<String>? selectedSizesOrAges,
    bool? isLoading,
    bool? isListView,
    bool? showLoginSuccessSnackbar,
  }) {
    return SupabaseHomeLoadedState(
      products: products ?? this.products,
      onSaleProducts: onSaleProducts ?? this.onSaleProducts,
      productsOfTheDay: productsOfTheDay ?? this.productsOfTheDay,
      recommendedProducts: recommendedProducts ?? this.recommendedProducts, // Added
      collectionProducts: collectionProducts ?? this.collectionProducts, // Added
      searchQuery: searchQuery ?? this.searchQuery,
      priceSort: priceSort ?? this.priceSort,
      dateSort: dateSort ?? this.dateSort,
      popularitySort: popularitySort ?? this.popularitySort,
      allCategories: allCategories ?? this.allCategories,
      allBrands: allBrands ?? this.allBrands,
      selectedRootCategory: selectedRootCategory ?? this.selectedRootCategory,
      selectedSubCategory: selectedSubCategory ?? this.selectedSubCategory,
      selectedLeafCategory: selectedLeafCategory ?? this.selectedLeafCategory,
      selectedBrandIds: selectedBrandIds ?? this.selectedBrandIds,
      selectedSizesOrAges: selectedSizesOrAges ?? this.selectedSizesOrAges,
      isLoading: isLoading ?? this.isLoading,
      isListView: isListView ?? this.isListView,
      showLoginSuccessSnackbar: showLoginSuccessSnackbar ?? this.showLoginSuccessSnackbar,
    );
  }
}

class SupabaseHomeErrorState extends SupabaseHomeState {
  final String message;

  SupabaseHomeErrorState(this.message);
}