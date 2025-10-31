import 'package:core/core.dart' as core;
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_api/abstract/product_service.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_api/freezed_model/response/list_all_products_response_model.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_categories_api/abstract/store_product_categories_service.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_categories_api/freezed_model/response/list_product_categories_response_model.dart';
import 'package:storefront_woo/app/views/view_search/models/module/states.dart'
    as search_states;
import 'package:storefront_woo/app/services/cart_token_storage.dart';
// JWT and cart tokens are automatically added by interceptors if user is authenticated

@injectable
class SearchViewModel
    extends core.BaseViewModelHydratedCubit<search_states.SearchState> {
  SearchViewModel() : super(search_states.SearchInitialState());

  final ProductService _productService = GetIt.I<ProductService>();
  final StoreProductCategoriesService _categoriesService =
      GetIt.I<StoreProductCategoriesService>();

  Future<void> loadCategories() async {
    try {
      // Log token status - interceptors will use these tokens automatically
      await _logTokenStatus('loadCategories');

      final cats = await _categoriesService.listProductCategories(
        apiVersion: 'v1',
        perPage: 100,
        hideEmpty: true,
      );
      emit(search_states.SearchReadyState(categories: cats));
    } catch (e) {
      // Not fatal; stay in initial state
      emit(
        search_states.SearchReadyState(
          categories: const <ListProductCategoriesResponseModel>[],
        ),
      );
    }
  }

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      emit(search_states.SearchInitialState());
      return;
    }
    try {
      // Log token status - interceptors will use these tokens automatically
      await _logTokenStatus('search');

      emit(search_states.SearchLoadingState());
      final products = await _productService.listAllProducts(
        apiVersion: 'v1',
        page: 1,
        perPage: 20,
        search: query,
      );
      final results = (products as List<ListAllProductsResponseModel>? ?? []);
      emit(search_states.SearchLoadedState(results: results, title: 'Search'));
    } catch (e) {
      emit(search_states.SearchErrorState(message: 'Failed to search: $e'));
    }
  }

  Future<void> searchByCategory(int categoryId, {String? name}) async {
    try {
      // Log token status - interceptors will use these tokens automatically
      await _logTokenStatus('searchByCategory');

      emit(search_states.SearchLoadingState());
      final products = await _productService.listAllProducts(
        apiVersion: 'v1',
        page: 1,
        perPage: 20,
        category: categoryId,
      );
      final results = (products as List<ListAllProductsResponseModel>? ?? []);
      emit(search_states.SearchLoadedState(results: results, title: name));
    } catch (e) {
      emit(
        search_states.SearchErrorState(message: 'Failed to load category: $e'),
      );
    }
  }

  @override
  search_states.SearchState? fromJson(Map<String, dynamic> json) => null;

  @override
  Map<String, dynamic>? toJson(search_states.SearchState state) => null;

  /// Logs the status of JWT and cart tokens for debugging
  /// Interceptors will automatically use these tokens if available
  Future<void> _logTokenStatus(String operation) async {
    try {
      // Check JWT token
      final authStorage = core.AuthStorageHelper();
      final jwtToken = await authStorage.getToken();
      final hasJwt = jwtToken != null && jwtToken.isNotEmpty;

      // Check cart token
      final cartToken = await CartTokenStorage.loadCartToken();
      final hasCartToken = cartToken != null && cartToken.isNotEmpty;

      debugPrint('🔍 SearchViewModel.$operation:');
      if (hasJwt) {
        debugPrint('  🔐 JWT Token: Available (${jwtToken.length} chars)');
      } else {
        debugPrint('  🔐 JWT Token: Not available');
      }
      if (hasCartToken) {
        debugPrint('  🛒 Cart Token: Available (${cartToken.length} chars)');
      } else {
        debugPrint('  🛒 Cart Token: Not available');
      }
      debugPrint(
        '  📝 Note: Interceptors will automatically add these tokens to API requests if available',
      );

      if (hasJwt || hasCartToken) {
        debugPrint(
          '  ✅ Authenticated user detected - tokens will be used by interceptors',
        );
      } else {
        debugPrint(
          '  ℹ️ No tokens available - requests will proceed without authentication',
        );
      }
    } catch (e) {
      debugPrint('❌ Error checking token status: $e');
    }
  }
}
