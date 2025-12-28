/*
 * FavoriteCategoriesState
 * ----------------------
 * States for favorite categories view.
 */

import 'package:storefront_woo/app/views/view_favorite_categories/models/favorite_category.dart';

abstract class FavoriteCategoriesState {}

class FavoriteCategoriesInitialState extends FavoriteCategoriesState {}

class FavoriteCategoriesLoadingState extends FavoriteCategoriesState {}

class FavoriteCategoriesLoadedState extends FavoriteCategoriesState {
  final List<FavoriteCategory> categories;

  FavoriteCategoriesLoadedState({required this.categories});
}

class FavoriteCategoriesErrorState extends FavoriteCategoriesState {
  final String message;

  FavoriteCategoriesErrorState({required this.message});
}

