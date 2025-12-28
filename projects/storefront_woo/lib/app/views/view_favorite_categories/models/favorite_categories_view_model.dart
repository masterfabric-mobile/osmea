/*
 * FavoriteCategoriesViewModel
 * ----------------------------
 * ViewModel for managing favorite categories.
 * Uses local storage (FavoriteCategoriesHelper) and fetches category details from API.
 */

import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_categories_api/abstract/store_product_categories_service.dart';
import 'package:storefront_woo/app/utils/favorite_categories_helper.dart';
import 'package:storefront_woo/app/views/view_favorite_categories/models/favorite_category.dart';
import 'package:storefront_woo/app/views/view_favorite_categories/models/states.dart';

@injectable
class FavoriteCategoriesViewModel
    extends BaseViewModelCubit<FavoriteCategoriesState> {
  FavoriteCategoriesViewModel() : super(FavoriteCategoriesInitialState());

  final FavoriteCategoriesHelper _helper = FavoriteCategoriesHelper();
  final StoreProductCategoriesService _categoriesService =
      GetIt.I<StoreProductCategoriesService>();
  final AssetConfigHelper _config = AssetConfigHelper();

  /// Initialize and load favorite categories
  Future<void> initial() async {
    await loadFavoriteCategories();
  }

  /// Load favorite categories with details from API
  Future<void> loadFavoriteCategories() async {
    try {
      emit(FavoriteCategoriesLoadingState());

      final favoriteIds = await _helper.getFavoriteCategoryIds();
      debugPrint('💖 FavoriteCategories: Found ${favoriteIds.length} favorite category IDs');

      if (favoriteIds.isEmpty) {
        emit(FavoriteCategoriesLoadedState(categories: []));
        return;
      }

      final apiVersion =
          _config.getString('woocommerce_configuration.version', 'v1');

      // Fetch category details from API
      final List<FavoriteCategory> categories = [];
      
      // Try to fetch all categories at once if possible, otherwise fetch individually
      // If API is unavailable, we'll still show favorites with minimal info
      bool apiAvailable = true;
      
      for (final categoryId in favoriteIds) {
        try {
          if (!apiAvailable) {
            // If API was unavailable, skip API calls and use minimal info
            categories.add(
              FavoriteCategory(
                id: categoryId,
                name: 'Category $categoryId',
                imageUrl: null,
                addedAt: DateTime.now(),
              ),
            );
            continue;
          }
          
          final categoryResponse = await _categoriesService.retrieveProductCategory(
            apiVersion: apiVersion,
            categoryId: categoryId,
          );

          categories.add(
            FavoriteCategory(
              id: categoryId,
              name: categoryResponse.name ?? 'Category',
              imageUrl: categoryResponse.image?.src ?? categoryResponse.image?.thumbnail,
              addedAt: DateTime.now(), // We don't store addedAt in helper, use now
            ),
          );
        } catch (e) {
          debugPrint('⚠️ Failed to fetch category $categoryId: $e');
          
          // Check if it's a connection error
          final errorString = e.toString().toLowerCase();
          if (errorString.contains('connection') || 
              errorString.contains('connection refused') ||
              errorString.contains('socketexception')) {
            apiAvailable = false;
            debugPrint('⚠️ API connection unavailable, using minimal category info');
          }
          
          // Add category with minimal info if API call fails
          categories.add(
            FavoriteCategory(
              id: categoryId,
              name: 'Category $categoryId',
              imageUrl: null,
              addedAt: DateTime.now(),
            ),
          );
        }
      }

      emit(FavoriteCategoriesLoadedState(categories: categories));
      debugPrint('✅ FavoriteCategories: Loaded ${categories.length} categories');
    } catch (e) {
      debugPrint('❌ Error loading favorite categories: $e');
      emit(FavoriteCategoriesErrorState(
        message: 'Failed to load favorite categories: $e',
      ));
    }
  }

  /// Toggle favorite status for a category
  Future<void> toggleFavorite(int categoryId, String categoryName) async {
    try {
      final success = await _helper.toggleFavorite(categoryId);

      if (success) {
        // Reload categories to reflect changes
        await loadFavoriteCategories();
      }
    } catch (e) {
      debugPrint('❌ Error toggling favorite category: $e');
      emit(FavoriteCategoriesErrorState(
        message: 'Failed to toggle favorite: $e',
      ));
    }
  }

  /// Remove a category from favorites
  Future<void> removeFavorite(int categoryId) async {
    try {
      final success = await _helper.removeFavorite(categoryId);
      if (success) {
        // Reload categories to reflect changes
        await loadFavoriteCategories();
      }
    } catch (e) {
      debugPrint('❌ Error removing favorite category: $e');
      emit(FavoriteCategoriesErrorState(
        message: 'Failed to remove favorite: $e',
      ));
    }
  }

  /// Clear all favorite categories
  Future<void> clearAll() async {
    try {
      await _helper.clearAll();
      emit(FavoriteCategoriesLoadedState(categories: []));
    } catch (e) {
      debugPrint('❌ Error clearing favorite categories: $e');
      emit(FavoriteCategoriesErrorState(
        message: 'Failed to clear favorites: $e',
      ));
    }
  }
}

