import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:storefront_supabase/app/models/product.dart';
import 'states.dart';

@injectable
class SupabaseHomeViewModel extends BaseViewModelCubit<SupabaseHomeState> {
  final SupabaseClient _supabaseClient;

  SupabaseHomeViewModel(this._supabaseClient) : super(SupabaseHomeInitialState());

  Future<void> initial() async {
    stateChanger(SupabaseHomeLoadingState());
    
    try {
      final response = await _supabaseClient
          .from('products')
          .select('*, product_images(image_url, is_primary, sort_order)')
          .eq('is_active', true)
          .order('created_at', ascending: false);
      
      final products = response
          .map((data) => Product.fromJson(data))
          .toList();
      
      stateChanger(SupabaseHomeLoadedState(products: products));
      
    } catch (e) {
      stateChanger(SupabaseHomeErrorState('Failed to load products: $e'));
    }
  }
}