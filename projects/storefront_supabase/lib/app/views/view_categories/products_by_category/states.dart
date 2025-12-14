import 'package:storefront_supabase/app/models/product.dart';

abstract class ProductsByCategoryState {}

class ProductsByCategoryInitial extends ProductsByCategoryState {}

class ProductsByCategoryLoading extends ProductsByCategoryState {}

class ProductsByCategoryLoaded extends ProductsByCategoryState {
  final List<Product> products;
  ProductsByCategoryLoaded(this.products);
}

class ProductsByCategoryError extends ProductsByCategoryState {
  final String message;
  ProductsByCategoryError(this.message);
}