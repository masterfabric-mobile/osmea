abstract class CategoriesState {}

class CategoriesInitialState extends CategoriesState {}

class CategoriesLoadedState extends CategoriesState {
  final List<String> categories;

  CategoriesLoadedState({
    required this.categories,
  });
}

class CategoriesErrorState extends CategoriesState {
  final String message;

  CategoriesErrorState(this.message);
}
