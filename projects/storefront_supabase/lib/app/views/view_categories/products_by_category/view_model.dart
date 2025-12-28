import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:storefront_supabase/app/models/product.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'states.dart';

@injectable
class ProductsByCategoryViewModel extends BaseViewModelCubit<ProductsByCategoryState> {
  final SupabaseClient _supabaseClient;

  ProductsByCategoryViewModel(this._supabaseClient) : super(ProductsByCategoryInitial());

  Future<void> fetchProductsByCategory(String categoryId) async {
    stateChanger(ProductsByCategoryLoading());
    try {
      final response = await _supabaseClient
          .from('products')
          .select('*, product_images(image_url, is_primary, sort_order)')
          .eq('category_id', categoryId)
          .eq('is_active', true)
          .order('created_at', ascending: false);

      final products = response.map((data) => Product.fromJson(data)).toList();
      stateChanger(ProductsByCategoryLoaded(products));
    } catch (e) {
      stateChanger(ProductsByCategoryError('Failed to load products: $e'));
    }
  }
}
