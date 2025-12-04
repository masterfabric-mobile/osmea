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
import 'package:storefront_supabase/app/views/view_favorites/models/view_model.dart'
    as _i721;
import 'package:storefront_supabase/app/views/view_home/models/home_view_model.dart'
    as _i482;
import 'package:storefront_supabase/app/views/view_login/models/view_model.dart'
    as _i357;
import 'package:storefront_supabase/app/views/view_product_detail/models/view_model.dart'
    as _i421;
import 'package:storefront_supabase/app/views/view_settings/models/view_model.dart'
    as _i76;
import 'package:storefront_supabase/app/views/view_signup/models/view_model.dart'
    as _i550;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i550.SignupViewModel>(() => _i550.SignupViewModel());
    gh.factory<_i76.SettingsViewModel>(() => _i76.SettingsViewModel());
    gh.factory<_i421.ProductDetailViewModel>(
      () => _i421.ProductDetailViewModel(),
    );
    gh.factory<_i482.SupabaseHomeViewModel>(
      () => _i482.SupabaseHomeViewModel(),
    );
    gh.factory<_i357.LoginViewModel>(() => _i357.LoginViewModel());
    gh.factory<_i721.FavoritesViewModel>(() => _i721.FavoritesViewModel());
    return this;
  }
}
