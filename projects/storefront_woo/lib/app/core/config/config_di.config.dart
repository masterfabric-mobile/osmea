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
import 'package:storefront_woo/app/views/view_cart/models/cart_view_model.dart'
    as _i892;
import 'package:storefront_woo/app/views/view_home/models/home_view_model.dart'
    as _i867;
import 'package:storefront_woo/app/views/view_product_detail/models/product_detail_view_model.dart'
    as _i819;
import 'package:storefront_woo/app/views/view_product_list/models/product_list_view_model.dart'
    as _i277;
import 'package:storefront_woo/app/views/view_profile/models/profile_view_model.dart'
    as _i386;
import 'package:storefront_woo/app/views/view_search/models/search_view_model.dart'
    as _i53;
import 'package:storefront_woo/app/views/view_wishlist/models/wishlist_view_model.dart'
    as _i241;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i892.CartViewModel>(() => _i892.CartViewModel());
    gh.factory<_i277.ProductListViewModel>(() => _i277.ProductListViewModel());
    gh.factory<_i386.ProfileViewModel>(() => _i386.ProfileViewModel());
    gh.factory<_i241.WishlistViewModel>(() => _i241.WishlistViewModel());
    gh.factory<_i819.ProductDetailViewModel>(
      () => _i819.ProductDetailViewModel(),
    );
    gh.factory<_i867.HomeViewModel>(() => _i867.HomeViewModel());
    gh.factory<_i53.SearchViewModel>(() => _i53.SearchViewModel());
    return this;
  }
}
