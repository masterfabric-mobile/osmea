import 'package:storefront_supabase/app/models/product.dart';

abstract class FavoritesState {}

class FavoritesInitialState extends FavoritesState {}

class FavoritesLoadingState extends FavoritesState {}

class FavoritesLoadedState extends FavoritesState {
  final List<Product> favoriteProducts;

  FavoritesLoadedState({
    required this.favoriteProducts,
  });
}

class FavoritesErrorState extends FavoritesState {
  final String message;

  FavoritesErrorState(this.message);
}
