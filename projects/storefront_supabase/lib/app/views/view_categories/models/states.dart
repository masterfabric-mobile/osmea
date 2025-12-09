import 'package:storefront_supabase/app/models/category.dart';

abstract class CategoriesState {}

class CategoriesInitialState extends CategoriesState {}

class CategoriesLoadingState extends CategoriesState {}

class CategoriesLoadedState extends CategoriesState {
  final List<Category> categories;

  CategoriesLoadedState({
    required this.categories,
  });
}

class CategoriesErrorState extends CategoriesState {
  final String message;

  CategoriesErrorState(this.message);
}
