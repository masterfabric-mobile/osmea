import 'package:core/core.dart' hide BuildContextTranslationsExtension, AppLocaleUtils, LocaleSettings, TranslationProvider;
import 'package:injectable/injectable.dart';
import 'package:storefront_supabase/app/models/coupon.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'module/states.dart';

@injectable
class AdminCouponsViewModel extends BaseViewModelCubit<AdminCouponsState> {
  final SupabaseClient _supabaseClient;

  AdminCouponsViewModel(this._supabaseClient) : super(AdminCouponsInitial());

  Future<void> fetchCoupons() async {
    stateChanger(AdminCouponsLoading());
    try {
      final response = await _supabaseClient
          .from('coupons')
          .select()
          .order('created_at', ascending: false);

      final coupons = (response as List).map((data) => Coupon.fromJson(data)).toList();
      stateChanger(AdminCouponsLoaded(coupons: coupons));
    } catch (e) {
      stateChanger(AdminCouponsError('Failed to load coupons: $e'));
    }
  }

  Future<void> deleteCoupon(String id) async {
    if (state is! AdminCouponsLoaded) return;
    final currentState = state as AdminCouponsLoaded;
    
    // Optimistic update or loading state
    stateChanger(currentState.copyWith(isLoading: true));

    try {
      await _supabaseClient.from('coupons').delete().eq('id', id);
      await fetchCoupons(); // Refresh list
    } catch (e) {
      stateChanger(AdminCouponsError('Failed to delete coupon: $e'));
    }
  }
}
