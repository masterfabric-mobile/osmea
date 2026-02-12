import 'package:core/core.dart' hide BuildContextTranslationsExtension, AppLocaleUtils, LocaleSettings, TranslationProvider;
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:storefront_supabase/app/models/brand.dart';
import 'package:storefront_supabase/app/models/category.dart';
import 'package:storefront_supabase/app/models/favorite_group.dart';
import 'package:storefront_supabase/app/core/cart/cart_cache.dart';
import 'package:storefront_supabase/app/models/product.dart';
import 'package:storefront_supabase/app/views/view_cart/models/view_model.dart';
import 'package:storefront_supabase/app/utils/brand_logo_url_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'states.dart';

@lazySingleton
class FavoritesViewModel extends BaseViewModelCubit<FavoritesState> {
  final SupabaseClient _supabaseClient;
  final CartCache _cartCache;

  FavoritesViewModel(this._supabaseClient, this._cartCache) : super(FavoritesInitialState());

  Future<void> initial() async {
    stateChanger(FavoritesLoadingState());

    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) {
      stateChanger(FavoritesErrorState(
          'Favorilerinizi görmek için lütfen giriş yapın.'));
      return;
    }

    try {
      final favoritesResponse = await _supabaseClient
          .from('favorites')
          .select('*, products:product_id(*, product_images(*)), brand:brand_id(*), category:category_id(*)')
          .eq('user_id', userId);

      final List<Product> products = [];
      final List<Brand> brands = [];
      final List<Category> categories = [];

      for (var item in favoritesResponse as List) {
        if (item['products'] != null) {
          products.add(Product.fromJson(item['products'] as Map<String, dynamic>));
        } else if (item['brand'] != null) {
          final b = Brand.fromJson(item['brand'] as Map<String, dynamic>);
          brands.add(b.copyWith(logoUrl: resolveBrandLogoUrl(_supabaseClient, b.logoUrl)));
        } else if (item['category'] != null) {
          final catMap = item['category'] as Map<String, dynamic>;
          categories.add(Category.fromJson(catMap));
        }
      }

      final groupsResponse = await _supabaseClient
          .from('favorite_groups')
          .select()
          .eq('user_id', userId)
          .order('created_at');

      final groups = (groupsResponse as List)
          .map((data) => FavoriteGroup.fromJson(data))
          .toList();

      stateChanger(FavoritesLoadedState(
        favoriteProducts: products,
        favoriteBrands: brands,
        favoriteCategories: categories,
        groups: groups,
      ));
    } catch (e) {
      stateChanger(FavoritesErrorState('Favoriler yüklenemedi: $e'));
    }
  }

  // --- View Logic ---

  void setViewType(FavoritesViewType type) {
    if (state is FavoritesLoadedState) {
      final curr = state as FavoritesLoadedState;
      stateChanger(curr.copyWith(viewType: type));
    }
  }

  /// Returns products in the given group without changing state. Use for bottom sheet / collection detail.
  Future<List<Product>> getCollectionProducts(String? groupId) async {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) return [];

    var query = _supabaseClient
        .from('favorites')
        .select('*, products:product_id(*, product_images(*))')
        .eq('user_id', userId);
    if (groupId != null) {
      query = query.eq('group_id', groupId);
    }
    final response = await query;
    final List<Product> products = [];
    for (var item in response as List) {
      if (item['products'] != null) {
        products.add(Product.fromJson(item['products'] as Map<String, dynamic>));
      }
    }
    return products;
  }

  /// Products that are in favorites but not in this collection (for "Add to collection" list).
  Future<List<Product>> getFavoriteProductsNotInGroup(String groupId) async {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) return [];

    final response = await _supabaseClient
        .from('favorites')
        .select('*, products:product_id(*, product_images(*))')
        .eq('user_id', userId);
    final List<Product> products = [];
    for (var item in response as List) {
      final itemGroupId = item['group_id'] as String?;
      if (item['products'] != null && itemGroupId != groupId) {
        products.add(Product.fromJson(item['products'] as Map<String, dynamic>));
      }
    }
    return products;
  }

  /// Move a favorite product into this collection (update group_id).
  Future<bool> addProductToGroup(String productId, String groupId) async {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) return false;
    try {
      await _supabaseClient
          .from('favorites')
          .update({'group_id': groupId})
          .eq('user_id', userId)
          .eq('product_id', productId);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Remove a product from this collection (set group_id to null); product stays in favorites.
  Future<bool> removeProductFromGroup(String productId, String groupId) async {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) return false;
    try {
      await _supabaseClient
          .from('favorites')
          .update({'group_id': null})
          .eq('user_id', userId)
          .eq('product_id', productId)
          .eq('group_id', groupId);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> selectGroup(String? groupId) async {
    // If we select a group, we should probably fetch items for that group ONLY, 
    // OR filter the cached list if we mapped them.
    // Given the previous fetch didn't preserve the 'favorites' table mapping (group_id),
    // re-fetching with a filter is the robust way to ensure we see correct items.
    
    if (state is! FavoritesLoadedState) return;
    final curr = state as FavoritesLoadedState;
    
    // Optimistic update for UI selection
    stateChanger(curr.copyWith(selectedGroupId: groupId, favoriteProducts: [], favoriteBrands: [])); // Clear temporarily or keep loading?
    // Let's keep loading indicator or just silent update?
    // Better: Show loading state or specialized loading.
    
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) return;

    try {
      var query = _supabaseClient
          .from('favorites')
          .select('*, products:product_id(*, product_images(*)), brand:brand_id(*)')
          .eq('user_id', userId);
      
      if (groupId != null) {
        query = query.eq('group_id', groupId);
      }

      final response = await query;
      
      final List<Product> products = [];
      final List<Brand> brands = [];

      for (var item in response as List) {
        if (item['products'] != null) {
          products.add(Product.fromJson(item['products'] as Map<String, dynamic>));
        } else if (item['brand'] != null) {
          final b = Brand.fromJson(item['brand'] as Map<String, dynamic>);
          brands.add(b.copyWith(logoUrl: resolveBrandLogoUrl(_supabaseClient, b.logoUrl)));
        }
      }

      // Restore other state parts
      stateChanger(curr.copyWith(
        favoriteProducts: products,
        favoriteBrands: brands,
        selectedGroupId: groupId, // Ensure it's set
      ));

    } catch (e) {
      // Revert or show error
      stateChanger(FavoritesErrorState('Filtreleme hatası: $e'));
    }
  }

  Future<void> createGroup(String name) async {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) return;

    try {
      await _supabaseClient.from('favorite_groups').insert({
        'user_id': userId,
        'name': name,
      });
      await initial();
    } catch (e) {
      // Handle error
    }
  }

  /// Delete a collection: unassign favorites from this group, then delete the group.
  Future<bool> deleteGroup(String groupId) async {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) return false;
    try {
      await _supabaseClient
          .from('favorites')
          .update({'group_id': null})
          .eq('user_id', userId)
          .eq('group_id', groupId);
      await _supabaseClient
          .from('favorite_groups')
          .delete()
          .eq('id', groupId)
          .eq('user_id', userId);
      await initial();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Giriş yapılmamış olsa bile sepete eklenebilir (misafir sepeti yerel saklanır).
  Future<bool> addToCart(String productId) async {
    try {
      final cartVm = GetIt.I<CartViewModel>();
      final ok = await cartVm.addItemToCart(productId, quantity: 1, variantId: null);
      if (ok) {
        final uid = _supabaseClient.auth.currentUser?.id;
        _cartCache.setInCart(uid ?? 'guest', productId, null, true);
      }
      return ok;
    } catch (e) {
      return false;
    }
  }

  /// [productForOptimisticUpdate] When provided, adds this product to state immediately
  /// so the heart icon updates before initial() refetch (better UX on home/search).
  Future<bool> addFavorite(String productId, {Product? productForOptimisticUpdate}) async {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) return false;

    try {
      await _supabaseClient.from('favorites').insert({
        'user_id': userId,
        'product_id': productId,
      });
      if (productForOptimisticUpdate != null && state is FavoritesLoadedState) {
        final curr = state as FavoritesLoadedState;
        if (!curr.favoriteProducts.any((p) => p.id == productId)) {
          stateChanger(curr.copyWith(
            favoriteProducts: [...curr.favoriteProducts, productForOptimisticUpdate],
          ));
        }
      }
      await initial();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeFavorite(String productId) async {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) return false;

    try {
      await _supabaseClient
          .from('favorites')
          .delete()
          .match({'user_id': userId, 'product_id': productId});
      if (state is FavoritesLoadedState) {
        final curr = state as FavoritesLoadedState;
        final updated = curr.favoriteProducts.where((p) => p.id != productId).toList();
        stateChanger(curr.copyWith(favoriteProducts: updated));
      }
      await initial();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Add brand to favorites. [brandForOptimisticUpdate] optional for immediate UI update.
  Future<bool> addFavoriteBrand(int brandId, {Brand? brandForOptimisticUpdate}) async {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) return false;

    try {
      await _supabaseClient.from('favorites').insert({
        'user_id': userId,
        'brand_id': brandId,
      });
      if (brandForOptimisticUpdate != null && state is FavoritesLoadedState) {
        final curr = state as FavoritesLoadedState;
        if (!curr.favoriteBrands.any((b) => b.id == brandId)) {
          final resolved = brandForOptimisticUpdate.copyWith(
            logoUrl: resolveBrandLogoUrl(_supabaseClient, brandForOptimisticUpdate.logoUrl),
          );
          stateChanger(curr.copyWith(
            favoriteBrands: [...curr.favoriteBrands, resolved],
          ));
        }
      }
      await initial();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeFavoriteBrand(int brandId) async {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) return false;

    try {
      await _supabaseClient
          .from('favorites')
          .delete()
          .match({'user_id': userId, 'brand_id': brandId});
      
      if (state is FavoritesLoadedState) {
        final curr = state as FavoritesLoadedState;
        final updated = curr.favoriteBrands.where((b) => b.id != brandId).toList();
        stateChanger(curr.copyWith(favoriteBrands: updated));
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeFavoriteCategory(String categoryId) async {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) return false;
    try {
      await _supabaseClient
          .from('favorites')
          .delete()
          .match({'user_id': userId, 'category_id': categoryId});
      if (state is FavoritesLoadedState) {
        final curr = state as FavoritesLoadedState;
        final updated = curr.favoriteCategories.where((c) => c.id != categoryId).toList();
        stateChanger(curr.copyWith(favoriteCategories: updated));
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> clearAllFavorites() async {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) return false;
    try {
      await _supabaseClient.from('favorites').delete().eq('user_id', userId);
      if (state is FavoritesLoadedState) {
        final curr = state as FavoritesLoadedState;
        stateChanger(curr.copyWith(
          favoriteProducts: [],
          favoriteBrands: [],
          favoriteCategories: [],
        ));
      } else {
        stateChanger(FavoritesLoadedState(
          favoriteProducts: [],
          favoriteBrands: [],
          favoriteCategories: [],
          groups: state is FavoritesLoadedState ? (state as FavoritesLoadedState).groups : [],
        ));
      }
      return true;
    } catch (e) {
      stateChanger(FavoritesErrorState('Favoriler silinemedi: $e'));
      return false;
    }
  }
}
