import 'package:apis/network/remote/woocommerce/store_api/product_api/freezed_model/response/list_all_products_response_model.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_api/freezed_model/response/get_filter_options_response_model.dart';

abstract class ProductListState {}

class ProductListInitialState extends ProductListState {}

class ProductListLoadingState extends ProductListState {}

class ProductListLoadedState extends ProductListState {
  final List<ListAllProductsResponseModel> products;
  final bool hasMore;
  final int currentPage;
  final int totalPages;
  final GetFilterOptionsResponseModel? filterOptions; // Available filter options
  
  ProductListLoadedState({
    required this.products,
    required this.hasMore,
    required this.currentPage,
    required this.totalPages,
    this.filterOptions,
  });
}

class ProductListErrorState extends ProductListState {
  final String message;
  ProductListErrorState({required this.message});
}

// New states for filter options loading
class ProductListFilterOptionsLoadingState extends ProductListState {}

class ProductListFilterOptionsErrorState extends ProductListState {
  final String message;
  ProductListFilterOptionsErrorState({required this.message});
}



