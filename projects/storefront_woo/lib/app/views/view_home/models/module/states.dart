/*
 * Home States
 * -----------
 * States for the home view following OSMEA architecture.
 * Simple Dart classes without freezed.
 */

import 'package:apis/network/remote/woocommerce/store_api/product_api/freezed_model/response/list_all_products_response_model.dart';

/// Base class for all home states
abstract class HomeState {}

/// Initial state when the view is first loaded
class HomeInitialState extends HomeState {}

/// Loading state when products are being fetched
class HomeLoadingState extends HomeState {}

/// Loaded state when products are successfully fetched
class HomeLoadedState extends HomeState {
  final List<ListAllProductsResponseModel> products;
  final bool hasMore;
  final int currentPage;
  final String? searchQuery;
  final int? selectedCategoryId;
  final ListAllProductsResponseModel?
  selectedProduct; // Seçilen product bilgisi

  HomeLoadedState({
    required this.products,
    required this.hasMore,
    required this.currentPage,
    this.searchQuery,
    this.selectedCategoryId,
    this.selectedProduct,
  });

  HomeLoadedState copyWith({
    List<ListAllProductsResponseModel>? products,
    bool? hasMore,
    int? currentPage,
    String? searchQuery,
    int? selectedCategoryId,
    ListAllProductsResponseModel? selectedProduct,
  }) {
    return HomeLoadedState(
      products: products ?? this.products,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      selectedProduct: selectedProduct ?? this.selectedProduct,
    );
  }
}

/// Error state when product fetching fails
class HomeErrorState extends HomeState {
  final String message;

  HomeErrorState({required this.message});
}
