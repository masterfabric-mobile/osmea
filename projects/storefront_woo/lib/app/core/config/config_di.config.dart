// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:storefront_woo/app/views/view_home/models/home_view_model.dart'
    as _i867;
import 'package:storefront_woo/app/views/view_product_detail/models/product_detail_view_model.dart'
    as _i819;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.factory<_i819.ProductDetailViewModel>(
        () => _i819.ProductDetailViewModel());
    gh.factory<_i867.HomeViewModel>(() => _i867.HomeViewModel());
    return this;
  }
}
