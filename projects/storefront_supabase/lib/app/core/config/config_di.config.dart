// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:storefront_supabase/app/core/cart/cart_cache.dart' as _i434;
import 'package:storefront_supabase/app/core/cart/guest_cart_storage.dart' as _i435;
import 'package:storefront_supabase/app/core/config/register_module.dart'
    as _i1006;
import 'package:storefront_supabase/app/views/admin/coupons/add_coupon/models/view_model.dart'
    as _i332;
import 'package:storefront_supabase/app/views/admin/coupons/models/view_model.dart'
    as _i221;
import 'package:storefront_supabase/app/views/admin/dashboard/models/view_model.dart'
    as _i821;
import 'package:storefront_supabase/app/views/admin/products/add_product/view_model.dart'
    as _i156;
import 'package:storefront_supabase/app/views/admin/products/models/view_model.dart'
    as _i625;
import 'package:storefront_supabase/app/views/admin/settings/models/view_model.dart'
    as _i861;
import 'package:storefront_supabase/app/views/view_brands/products_by_brand/view_model.dart'
    as _i454;
import 'package:storefront_supabase/app/views/view_checkout/models/checkout_view_model.dart'
    as _i888;
import 'package:storefront_supabase/app/views/view_cart/models/view_model.dart'
    as _i826;
import 'package:storefront_supabase/app/views/view_categories/models/view_model.dart'
    as _i1038;
import 'package:storefront_supabase/app/views/view_categories/products_by_category/view_model.dart'
    as _i793;
import 'package:storefront_supabase/app/views/view_favorites/models/view_model.dart'
    as _i721;
import 'package:storefront_supabase/app/views/view_home/models/home_view_model.dart'
    as _i482;
import 'package:storefront_supabase/app/views/view_product_detail/models/view_model.dart'
    as _i421;
import 'package:storefront_supabase/app/views/view_product_list/models/product_list_view_model.dart'
    as _i384;
import 'package:storefront_supabase/app/views/view_profile/change_password/models/view_model.dart'
    as _i319;
import 'package:storefront_supabase/app/views/view_profile/models/view_model.dart'
    as _i56;
import 'package:storefront_supabase/app/views/view_search/models/view_model.dart'
    as _i844;
import 'package:storefront_supabase/app/views/view_settings/models/view_model.dart'
    as _i76;
import 'package:supabase_flutter/supabase_flutter.dart' as _i454;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.factory<_i76.SettingsViewModel>(() => _i76.SettingsViewModel());
    gh.lazySingleton<_i454.SupabaseClient>(() => registerModule.supabaseClient);
    gh.lazySingleton<_i434.CartCache>(() => _i434.CartCache());
    gh.lazySingleton<_i435.GuestCartStorage>(() => _i435.GuestCartStorage());
    gh.factory<_i454.ProductsByBrandViewModel>(
      () => _i454.ProductsByBrandViewModel(gh<_i454.SupabaseClient>()),
    );
    gh.factory<_i384.ProductListViewModel>(
      () => _i384.ProductListViewModel(gh<_i454.SupabaseClient>()),
    );
    gh.factory<_i861.AdminSettingsViewModel>(
      () => _i861.AdminSettingsViewModel(gh<_i454.SupabaseClient>()),
    );
    gh.factory<_i156.AddProductViewModel>(
      () => _i156.AddProductViewModel(gh<_i454.SupabaseClient>()),
    );
    gh.factory<_i625.AdminProductsViewModel>(
      () => _i625.AdminProductsViewModel(gh<_i454.SupabaseClient>()),
    );
    gh.factory<_i821.AdminDashboardViewModel>(
      () => _i821.AdminDashboardViewModel(gh<_i454.SupabaseClient>()),
    );
    gh.factory<_i332.AddCouponViewModel>(
      () => _i332.AddCouponViewModel(gh<_i454.SupabaseClient>()),
    );
    gh.factory<_i221.AdminCouponsViewModel>(
      () => _i221.AdminCouponsViewModel(gh<_i454.SupabaseClient>()),
    );
    gh.factory<_i56.ProfileViewModel>(
      () => _i56.ProfileViewModel(gh<_i454.SupabaseClient>()),
    );
    gh.factory<_i319.ChangePasswordViewModel>(
      () => _i319.ChangePasswordViewModel(gh<_i454.SupabaseClient>()),
    );
    gh.factory<_i1038.CategoriesViewModel>(
      () => _i1038.CategoriesViewModel(gh<_i454.SupabaseClient>()),
    );
    gh.factory<_i793.ProductsByCategoryViewModel>(
      () => _i793.ProductsByCategoryViewModel(gh<_i454.SupabaseClient>()),
    );
    gh.factory<_i844.SearchViewModel>(
      () => _i844.SearchViewModel(gh<_i454.SupabaseClient>()),
    );
    gh.factory<_i888.CheckoutViewModel>(
      () => _i888.CheckoutViewModel(gh<_i454.SupabaseClient>()),
    );
    gh.factory<_i826.CartViewModel>(
      () => _i826.CartViewModel(
        gh<_i454.SupabaseClient>(),
        gh<_i434.CartCache>(),
        gh<_i435.GuestCartStorage>(),
      ),
    );
    gh.factory<_i421.ProductDetailViewModel>(
      () => _i421.ProductDetailViewModel(
        gh<_i454.SupabaseClient>(),
        gh<_i434.CartCache>(),
        gh<_i435.GuestCartStorage>(),
      ),
    );
    gh.lazySingleton<_i482.SupabaseHomeViewModel>(
      () => _i482.SupabaseHomeViewModel(
        gh<_i454.SupabaseClient>(),
        gh<_i434.CartCache>(),
      ),
    );
    gh.lazySingleton<_i721.FavoritesViewModel>(
      () => _i721.FavoritesViewModel(
        gh<_i454.SupabaseClient>(),
        gh<_i434.CartCache>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i1006.RegisterModule {}
