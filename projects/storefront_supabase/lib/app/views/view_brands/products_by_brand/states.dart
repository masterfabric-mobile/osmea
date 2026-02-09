import 'package:storefront_supabase/app/models/product.dart';

abstract class ProductsByBrandState {}

class ProductsByBrandInitial extends ProductsByBrandState {}

class ProductsByBrandLoading extends ProductsByBrandState {}

class ProductsByBrandLoaded extends ProductsByBrandState {
  final List<Product> products;
  final String brandName;
  final bool isFavorite; // Added

  ProductsByBrandLoaded({
    required this.products,
    required this.brandName,
    this.isFavorite = false,
  });

  ProductsByBrandLoaded copyWith({
    List<Product>? products,
    String? brandName,
    bool? isFavorite,
  }) {
    return ProductsByBrandLoaded(
      products: products ?? this.products,
      brandName: brandName ?? this.brandName,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

class ProductsByBrandError extends ProductsByBrandState {
  final String message;
  ProductsByBrandError(this.message);
}
