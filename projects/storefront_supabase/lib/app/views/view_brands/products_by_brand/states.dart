import 'package:storefront_supabase/app/models/product.dart';

abstract class ProductsByBrandState {}

class ProductsByBrandInitial extends ProductsByBrandState {}

class ProductsByBrandLoading extends ProductsByBrandState {}

class ProductsByBrandLoaded extends ProductsByBrandState {
  final List<Product> products;
  final String brandName;

  ProductsByBrandLoaded({
    required this.products,
    required this.brandName,
  });
}

class ProductsByBrandError extends ProductsByBrandState {
  final String message;
  ProductsByBrandError(this.message);
}
