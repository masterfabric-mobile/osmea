import 'package:storefront_supabase/app/models/category.dart';
import 'package:storefront_supabase/app/models/product.dart';

abstract class ProductsByCategoryState {}

class ProductsByCategoryInitial extends ProductsByCategoryState {}

class ProductsByCategoryLoading extends ProductsByCategoryState {}

class ProductsByCategoryLoaded extends ProductsByCategoryState {
  final List<Product> products;
  final List<Category> subCategories;
  final String? selectedSubcategoryId;
  final String? selectedAgeGroup;
  final bool showSizeFilter; // New field

  ProductsByCategoryLoaded({
    required this.products,
    this.subCategories = const [],
    this.selectedSubcategoryId,
    this.selectedAgeGroup,
    this.showSizeFilter = false, // Default false
  });

  ProductsByCategoryLoaded copyWith({
    List<Product>? products,
    List<Category>? subCategories,
    String? selectedSubcategoryId,
    String? selectedAgeGroup,
    bool? showSizeFilter,
  }) {
    return ProductsByCategoryLoaded(
      products: products ?? this.products,
      subCategories: subCategories ?? this.subCategories,
      selectedSubcategoryId:
          selectedSubcategoryId ?? this.selectedSubcategoryId,
      selectedAgeGroup: selectedAgeGroup ?? this.selectedAgeGroup,
      showSizeFilter: showSizeFilter ?? this.showSizeFilter,
    );
  }
}

class ProductsByCategoryError extends ProductsByCategoryState {
  final String message;
  ProductsByCategoryError(this.message);
}