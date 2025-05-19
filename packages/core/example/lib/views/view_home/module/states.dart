
import 'package:example/views/view_home/models/product_model.dart';

abstract class HomeViewState {}

class HomeViewInitialState extends HomeViewState {}

class HomeViewLoadingState extends HomeViewState {}

class HomeViewContentState extends HomeViewState {
  final List<Product> products;

  HomeViewContentState({required this.products});
}

class HomeViewErrorState extends HomeViewState {
  final String message;

  HomeViewErrorState({required this.message});
}