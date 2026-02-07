import 'package:core/core.dart' hide BuildContextTranslationsExtension, AppLocaleUtils, LocaleSettings, TranslationProvider;
import 'package:injectable/injectable.dart';
import 'package:storefront_supabase/app/models/product.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'states.dart';

@injectable
class FavoritesViewModel extends BaseViewModelCubit<FavoritesState> {
  final SupabaseClient _supabaseClient;

  FavoritesViewModel(this._supabaseClient) : super(FavoritesInitialState());

  Future<void> initial() async {
    stateChanger(FavoritesLoadingState());

    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) {
      stateChanger(FavoritesErrorState(
          'Favorilerinizi görmek için lütfen giriş yapın.'));
      return;
    }

    try {
      final response = await _supabaseClient
          .from('favorites')
          .select('products:product_id(*, product_images(*))')
          .eq('user_id', userId);

      final products = response
          .map((item) =>
              Product.fromJson(item['products'] as Map<String, dynamic>))
          .toList();

      stateChanger(FavoritesLoadedState(favoriteProducts: products));
    } catch (e) {
      stateChanger(FavoritesErrorState('Favoriler yüklenemedi: $e'));
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
      
      // Refresh the list locally to avoid full reload flicker
      if (state is FavoritesLoadedState) {
        final currentList = (state as FavoritesLoadedState).favoriteProducts;
        final updatedList = currentList.where((p) => p.id != productId).toList();
        stateChanger(FavoritesLoadedState(favoriteProducts: updatedList));
      } else {
        await initial();
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
      await _supabaseClient
          .from('favorites')
          .delete()
          .eq('user_id', userId);
      
      stateChanger(FavoritesLoadedState(favoriteProducts: []));
      return true;
    } catch (e) {
      stateChanger(FavoritesErrorState('Favoriler silinemedi: $e'));
      return false;
    }
  }

  Future<bool> addToCart(String productId) async {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) return false;

    try {
      // Check existing
      final existing = await _supabaseClient
          .from('cart')
          .select('id, quantity')
          .match({'user_id': userId, 'product_id': productId})
          .maybeSingle();

      if (existing != null) {
        final newQty = (existing['quantity'] as int) + 1;
        await _supabaseClient
            .from('cart')
            .update({'quantity': newQty})
            .eq('id', existing['id']);
      } else {
        await _supabaseClient.from('cart').insert({
          'user_id': userId,
          'product_id': productId,
          'quantity': 1,
        });
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}
