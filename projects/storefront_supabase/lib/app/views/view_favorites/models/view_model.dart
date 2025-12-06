import 'package:core/core.dart';
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
}
