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
      // Get user-friendly error message
      final errorMessage = _getErrorMessage(e);
      emit(search_states.SearchErrorState(message: errorMessage));
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
      // Get user-friendly error message
      final errorMessage = _getErrorMessage(e);
      emit(
        search_states.SearchErrorState(message: errorMessage),
      );
    }
  }

  /// Get user-friendly error message from exception
  String _getErrorMessage(dynamic error) {
    final errorString = error.toString().toLowerCase();

    // Handle timeout errors
    if (errorString.contains('timeout') ||
        errorString.contains('operation timed out') ||
        errorString.contains('timed out')) {
      return 'Connection timeout. Please check your internet connection and try again.';
    }

    // Handle network errors
    if (errorString.contains('network') ||
        errorString.contains('connection') ||
        errorString.contains('socketexception')) {
      return 'Network error. Please check your connection and try again.';
    }

    // Handle 401 Unauthorized
    if (errorString.contains('401') ||
        errorString.contains('unauthorized')) {
      return 'Authentication required. Please sign in and try again.';
    }

    // Handle 404 Not Found
    if (errorString.contains('404') ||
        errorString.contains('not found')) {
      return 'Not found. Please try a different search or category.';
    }

    // Handle 500 Server errors
    if (errorString.contains('500') ||
        errorString.contains('502') ||
        errorString.contains('503') ||
        errorString.contains('server error')) {
      return 'Server error. Please try again later.';
    }

    // Default friendly message
    return 'Unable to load category. Please try again.';
  }

  /// Go back to categories view
  /// If categories are already loaded, emit SearchReadyState
  /// Otherwise, load categories
  Future<void> goBackToCategories() async {
    final currentState = state;
    
    // If already in SearchReadyState with categories, just emit it again
    if (currentState is search_states.SearchReadyState &&
        currentState.categories.isNotEmpty) {
      emit(currentState);
      return;
    }
    
    // Otherwise, load categories
    await loadCategories();
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

      // Cart token is automatically handled by WooCartTokenInterceptor
      // Interceptor adds token to requests automatically

      debugPrint('🔍 SearchViewModel.$operation:');
      if (hasJwt) {
        debugPrint('  🔐 JWT Token: Available (${jwtToken.length} chars)');
      } else {
        debugPrint('  🔐 JWT Token: Not available');
      }
      debugPrint('  🛒 Cart Token: Handled automatically by interceptor');
      debugPrint(
        '  📝 Note: Interceptors will automatically add these tokens to API requests if available',
      );

      if (hasJwt) {
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
