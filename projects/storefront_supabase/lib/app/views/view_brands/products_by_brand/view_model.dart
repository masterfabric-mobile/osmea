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
      // Fetch Brand Name
      final brandResponse = await _supabaseClient
          .from('brand')
          .select('name')
          .eq('id', brandId)
          .single();
      
      final brandName = brandResponse['name'] as String;

      // Fetch Products
      final response = await _supabaseClient
          .from('products')
          .select('*, product_images(image_url, is_primary, sort_order)')
          .eq('is_active', true)
          .eq('brand_id', brandId)
          .order('created_at', ascending: false);

      final products = (response as List)
          .map((data) => Product.fromJson(data as Map<String, dynamic>))
          .toList();

      stateChanger(ProductsByBrandLoaded(
        products: products,
        brandName: brandName,
      ));
    } catch (e) {
      stateChanger(ProductsByBrandError('Failed to load products: $e'));
    }
  }
}
