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
import 'package:storefront_supabase/app/views/view_cart/models/view_model.dart'
    as _i826;
import 'package:storefront_supabase/app/views/view_categories/models/view_model.dart'
    as _i1038;
import 'package:storefront_supabase/app/views/view_favorites/models/view_model.dart'
    as _i721;
import 'package:storefront_supabase/app/views/view_home/models/home_view_model.dart'
    as _i482;
import 'package:storefront_supabase/app/views/view_product_detail/models/view_model.dart'
    as _i421;
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
    gh.factory<_i76.SettingsViewModel>(() => _i76.SettingsViewModel());
    gh.factory<_i826.CartViewModel>(
      () => _i826.CartViewModel(gh<_i454.SupabaseClient>()),
    );
    gh.factory<_i56.ProfileViewModel>(
      () => _i56.ProfileViewModel(gh<_i454.SupabaseClient>()),
    );
    gh.factory<_i421.ProductDetailViewModel>(
      () => _i421.ProductDetailViewModel(gh<_i454.SupabaseClient>()),
    );
    gh.factory<_i1038.CategoriesViewModel>(
      () => _i1038.CategoriesViewModel(gh<_i454.SupabaseClient>()),
    );
    gh.factory<_i482.SupabaseHomeViewModel>(
      () => _i482.SupabaseHomeViewModel(gh<_i454.SupabaseClient>()),
    );
    gh.factory<_i844.SearchViewModel>(
      () => _i844.SearchViewModel(gh<_i454.SupabaseClient>()),
    );
    gh.factory<_i721.FavoritesViewModel>(
      () => _i721.FavoritesViewModel(gh<_i454.SupabaseClient>()),
    );
    return this;
  }
}
