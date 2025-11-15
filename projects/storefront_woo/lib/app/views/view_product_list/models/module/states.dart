import 'package:apis/network/remote/woocommerce/store_api/product_api/freezed_model/response/list_all_products_response_model.dart';

abstract class ProductListState {}

class ProductListInitialState extends ProductListState {}

class ProductListLoadingState extends ProductListState {}

class ProductListLoadedState extends ProductListState {
  final List<ListAllProductsResponseModel> products;
  final bool hasMore;
  final int currentPage;
  final int totalPages;
  
  ProductListLoadedState({
    required this.products,
    required this.hasMore,
    required this.currentPage,
    required this.totalPages,
  });
}

class ProductListErrorState extends ProductListState {
  final String message;
  ProductListErrorState({required this.message});
}

