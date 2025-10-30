import 'package:apis/network/remote/woocommerce/store_api/product_api/freezed_model/response/list_all_products_response_model.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_categories_api/freezed_model/response/list_product_categories_response_model.dart';

abstract class SearchState {}

class SearchInitialState extends SearchState {}

class SearchLoadingState extends SearchState {}

class SearchReadyState extends SearchState {
  final List<ListProductCategoriesResponseModel> categories;
  SearchReadyState({required this.categories});
}

class SearchLoadedState extends SearchState {
  final List<ListAllProductsResponseModel> results;
  final String? title;
  SearchLoadedState({required this.results, this.title});
}

class SearchErrorState extends SearchState {
  final String message;
  SearchErrorState({required this.message});
}


