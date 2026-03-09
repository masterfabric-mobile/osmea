import 'package:core/core.dart' hide BuildContextTranslationsExtension, AppLocaleUtils, LocaleSettings, TranslationProvider;
import 'package:injectable/injectable.dart';
import 'package:storefront_supabase/app/api/admin/abstract/admin_coupons_service.dart';
import 'package:storefront_supabase/app/core/config/config_di.dart';
import 'module/states.dart';

@injectable
class AdminCouponsViewModel extends BaseViewModelCubit<AdminCouponsState> {
  AdminCouponsViewModel() : super(AdminCouponsInitial());

  AdminCouponsService get _coupons => getIt<AdminCouponsService>();

  Future<void> fetchCoupons() async {
    stateChanger(AdminCouponsLoading());
    try {
      final coupons = await _coupons.listCoupons();
      stateChanger(AdminCouponsLoaded(coupons: coupons));
    } catch (e) {
      stateChanger(AdminCouponsError('Failed to load coupons: $e'));
    }
  }

  Future<void> deleteCoupon(String id) async {
    if (state is! AdminCouponsLoaded) return;
    final currentState = state as AdminCouponsLoaded;
    stateChanger(currentState.copyWith(isLoading: true));

    try {
      await _coupons.deleteCoupon(id);
      await fetchCoupons();
    } catch (e) {
      stateChanger(AdminCouponsError('Failed to delete coupon: $e'));
    }
  }
}
