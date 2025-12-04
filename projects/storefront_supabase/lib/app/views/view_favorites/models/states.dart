abstract class FavoritesState {}

class FavoritesInitialState extends FavoritesState {}

class FavoritesLoadedState extends FavoritesState {
  final List<String> favoriteItems;

  FavoritesLoadedState({
    required this.favoriteItems,
  });
}

class FavoritesErrorState extends FavoritesState {
  final String message;

  FavoritesErrorState(this.message);
}
