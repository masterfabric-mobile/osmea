import 'package:core/core.dart' hide BuildContextTranslationsExtension, AppLocaleUtils, LocaleSettings, TranslationProvider;
import 'package:injectable/injectable.dart';
import 'package:storefront_supabase/app/models/product.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'states.dart';

@injectable
class ProductsByBrandViewModel extends BaseViewModelCubit<ProductsByBrandState> {
  final SupabaseClient _supabaseClient;

  ProductsByBrandViewModel(this._supabaseClient) : super(ProductsByBrandInitial());

  Future<void> fetchProductsByBrand(String brandId) async {
    stateChanger(ProductsByBrandLoading());
    try {
      final userId = _supabaseClient.auth.currentUser?.id;

      // 1. Fetch Brand Name
      final brandResponse = await _supabaseClient
          .from('brand')
          .select('name')
          .eq('id', brandId)
          .single();
      
      final brandName = brandResponse['name'] as String;

      // 2. Fetch Products
      final productsResponse = await _supabaseClient
          .from('products')
          .select('*, product_images(image_url, is_primary, sort_order)')
          .eq('is_active', true)
          .eq('brand_id', brandId)
          .order('created_at', ascending: false);

      final products = (productsResponse as List)
          .map((data) => Product.fromJson(data as Map<String, dynamic>))
          .toList();

      // 3. Check Favorite Status
      bool isFavorite = false;
      if (userId != null) {
        final favResponse = await _supabaseClient
            .from('favorites')
            .select('id')
            .match({'user_id': userId, 'brand_id': brandId})
            .maybeSingle();
        isFavorite = favResponse != null;
      }

      stateChanger(ProductsByBrandLoaded(
        products: products,
        brandName: brandName,
        isFavorite: isFavorite,
      ));
    } catch (e) {
      stateChanger(ProductsByBrandError('Failed to load data: $e'));
    }
  }

  Future<void> toggleBrandFavorite(String brandId) async {
    if (state is! ProductsByBrandLoaded) return;
    final currentState = state as ProductsByBrandLoaded;
    final userId = _supabaseClient.auth.currentUser?.id;

    if (userId == null) {
      // Handle guest user - maybe show snackbar in view
      return; 
    }

    // Optimistic Update
    stateChanger(currentState.copyWith(isFavorite: !currentState.isFavorite));

    try {
      if (currentState.isFavorite) {
        // Was favorite, so remove it
        await _supabaseClient
            .from('favorites')
            .delete()
            .match({'user_id': userId, 'brand_id': brandId});
      } else {
        // Was not favorite, so add it
        await _supabaseClient
            .from('favorites')
            .insert({'user_id': userId, 'brand_id': brandId});
      }
    } catch (e) {
      // Revert on error
      stateChanger(currentState.copyWith(isFavorite: currentState.isFavorite));
    }
  }
}
