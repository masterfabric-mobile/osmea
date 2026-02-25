// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:storefront_supabase/app/core/cart/cart_cache.dart' as _i434;
import 'package:storefront_supabase/app/core/cart/guest_cart_storage.dart'
    as _i867;
import 'package:storefront_supabase/app/core/config/register_module.dart'
    as _i1006;
import 'package:storefront_supabase/app/views/admin/coupons/add_coupon/models/add_coupon_view_model.dart'
    as _i392;
import 'package:storefront_supabase/app/views/admin/coupons/models/coupons_view_model.dart'
    as _i247;
import 'package:storefront_supabase/app/views/admin/dashboard/models/dashboard_view_model.dart'
    as _i437;
import 'package:storefront_supabase/app/views/admin/products/add_product/view_model.dart'
    as _i156;
import 'package:storefront_supabase/app/views/admin/products/models/products_view_model.dart'
    as _i147;
import 'package:storefront_supabase/app/views/admin/settings/models/admin_settings_view_model.dart'
    as _i348;
import 'package:storefront_supabase/app/views/view_brands/products_by_brand/view_model.dart'
    as _i454;
import 'package:storefront_supabase/app/views/view_cart/models/cart_view_model.dart'
    as _i149;
import 'package:storefront_supabase/app/views/view_categories/models/categories_view_model.dart'
    as _i1011;
import 'package:storefront_supabase/app/views/view_categories/products_by_category/view_model.dart'
    as _i793;
import 'package:storefront_supabase/app/views/view_checkout/models/checkout_view_model.dart'
    as _i1047;
import 'package:storefront_supabase/app/views/view_favorites/models/favorites_view_model.dart'
    as _i303;
import 'package:storefront_supabase/app/views/view_home/models/home_view_model.dart'
    as _i482;
import 'package:storefront_supabase/app/views/view_product_detail/models/product_detail_view_model.dart'
    as _i133;
import 'package:storefront_supabase/app/views/view_product_list/models/product_list_view_model.dart'
    as _i384;
import 'package:storefront_supabase/app/views/view_profile/change_password/models/change_password_view_model.dart'
    as _i265;
import 'package:storefront_supabase/app/views/view_profile/models/profile_view_model.dart'
    as _i67;
import 'package:storefront_supabase/app/views/view_search/models/search_view_model.dart'
    as _i915;
import 'package:storefront_supabase/app/views/view_settings/models/settings_view_model.dart'
    as _i555;
import 'package:supabase_flutter/supabase_flutter.dart' as _i454;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.factory<_i555.SettingsViewModel>(() => _i555.SettingsViewModel());
    gh.lazySingleton<_i434.CartCache>(() => _i434.CartCache());
    gh.lazySingleton<_i867.GuestCartStorage>(() => _i867.GuestCartStorage());
    gh.lazySingleton<_i454.SupabaseClient>(() => registerModule.supabaseClient);
    gh.lazySingleton<_i303.FavoritesViewModel>(
      () => _i303.FavoritesViewModel(
        gh<_i454.SupabaseClient>(),
        gh<_i434.CartCache>(),
      ),
    );
    gh.lazySingleton<_i482.SupabaseHomeViewModel>(
      () => _i482.SupabaseHomeViewModel(
        gh<_i454.SupabaseClient>(),
        gh<_i434.CartCache>(),
      ),
    );
    gh.factory<_i149.CartViewModel>(
      () => _i149.CartViewModel(
        gh<_i454.SupabaseClient>(),
        gh<_i434.CartCache>(),
        gh<_i867.GuestCartStorage>(),
      ),
    );
    gh.factory<_i133.ProductDetailViewModel>(
      () => _i133.ProductDetailViewModel(
        gh<_i454.SupabaseClient>(),
        gh<_i434.CartCache>(),
        gh<_i867.GuestCartStorage>(),
      ),
    );
    gh.factory<_i392.AddCouponViewModel>(
      () => _i392.AddCouponViewModel(gh<_i454.SupabaseClient>()),
    );
    gh.factory<_i247.AdminCouponsViewModel>(
      () => _i247.AdminCouponsViewModel(gh<_i454.SupabaseClient>()),
    );
    gh.factory<_i437.AdminDashboardViewModel>(
      () => _i437.AdminDashboardViewModel(gh<_i454.SupabaseClient>()),
    );
    gh.factory<_i156.AddProductViewModel>(
      () => _i156.AddProductViewModel(gh<_i454.SupabaseClient>()),
    );
    gh.factory<_i147.AdminProductsViewModel>(
      () => _i147.AdminProductsViewModel(gh<_i454.SupabaseClient>()),
    );
    gh.factory<_i348.AdminSettingsViewModel>(
      () => _i348.AdminSettingsViewModel(gh<_i454.SupabaseClient>()),
    );
    gh.factory<_i454.ProductsByBrandViewModel>(
      () => _i454.ProductsByBrandViewModel(gh<_i454.SupabaseClient>()),
    );
    gh.factory<_i1011.CategoriesViewModel>(
      () => _i1011.CategoriesViewModel(gh<_i454.SupabaseClient>()),
    );
    gh.factory<_i793.ProductsByCategoryViewModel>(
      () => _i793.ProductsByCategoryViewModel(gh<_i454.SupabaseClient>()),
    );
    gh.factory<_i1047.CheckoutViewModel>(
      () => _i1047.CheckoutViewModel(gh<_i454.SupabaseClient>()),
    );
    gh.factory<_i384.ProductListViewModel>(
      () => _i384.ProductListViewModel(gh<_i454.SupabaseClient>()),
    );
    gh.factory<_i265.ChangePasswordViewModel>(
      () => _i265.ChangePasswordViewModel(gh<_i454.SupabaseClient>()),
    );
    gh.factory<_i67.ProfileViewModel>(
      () => _i67.ProfileViewModel(gh<_i454.SupabaseClient>()),
    );
    gh.factory<_i915.SearchViewModel>(
      () => _i915.SearchViewModel(gh<_i454.SupabaseClient>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i1006.RegisterModule {}
