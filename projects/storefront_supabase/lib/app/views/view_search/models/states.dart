import 'package:storefront_supabase/app/models/product.dart';

abstract class SearchState {}

class SearchInitialState extends SearchState {}

class SearchLoadingState extends SearchState {}

class SearchLoadedState extends SearchState {
  final List<Product> searchResults;

  SearchLoadedState({required this.searchResults});
}

class SearchErrorState extends SearchState {
  final String message;

  SearchErrorState(this.message);
}