import 'package:storefront_supabase/app/models/brand.dart';
import 'package:storefront_supabase/app/models/favorite_group.dart';
import 'package:storefront_supabase/app/models/product.dart';

enum FavoritesViewType { products, brands }

abstract class FavoritesState {}

class FavoritesInitialState extends FavoritesState {}

class FavoritesLoadingState extends FavoritesState {}

class FavoritesLoadedState extends FavoritesState {
  final List<Product> favoriteProducts;
  final List<Brand> favoriteBrands;
  final List<FavoriteGroup> groups;
  
  final FavoritesViewType viewType;
  final String? selectedGroupId; // null means "All"

  FavoritesLoadedState({
    required this.favoriteProducts,
    this.favoriteBrands = const [],
    this.groups = const [],
    this.viewType = FavoritesViewType.products,
    this.selectedGroupId,
  });

  FavoritesLoadedState copyWith({
    List<Product>? favoriteProducts,
    List<Brand>? favoriteBrands,
    List<FavoriteGroup>? groups,
    FavoritesViewType? viewType,
    String? selectedGroupId,
  }) {
    return FavoritesLoadedState(
      favoriteProducts: favoriteProducts ?? this.favoriteProducts,
      favoriteBrands: favoriteBrands ?? this.favoriteBrands,
      groups: groups ?? this.groups,
      viewType: viewType ?? this.viewType,
      selectedGroupId: selectedGroupId ?? this.selectedGroupId, // Pass null to reset? Logic handled in ViewModel usually
    );
  }
}

class FavoritesErrorState extends FavoritesState {
  final String message;

  FavoritesErrorState(this.message);
}
