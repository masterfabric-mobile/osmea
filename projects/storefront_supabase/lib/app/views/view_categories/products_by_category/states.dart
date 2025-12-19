import 'package:storefront_supabase/app/models/category.dart';
import 'package:storefront_supabase/app/models/product.dart';

abstract class ProductsByCategoryState {}

class ProductsByCategoryInitial extends ProductsByCategoryState {}

class ProductsByCategoryLoading extends ProductsByCategoryState {}

class ProductsByCategoryLoaded extends ProductsByCategoryState {
  final List<Product> products;
  final List<Category> subCategories;
  final String? selectedSubcategoryId;
  final List<String> selectedSizes; // Changed to List
  final bool showSizeFilter;

  ProductsByCategoryLoaded({
    required this.products,
    this.subCategories = const [],
    this.selectedSubcategoryId,
    this.selectedSizes = const [], // Default empty
    this.showSizeFilter = false,
  });

  ProductsByCategoryLoaded copyWith({
    List<Product>? products,
    List<Category>? subCategories,
    String? selectedSubcategoryId,
    List<String>? selectedSizes,
    bool? showSizeFilter,
  }) {
    return ProductsByCategoryLoaded(
      products: products ?? this.products,
      subCategories: subCategories ?? this.subCategories,
      selectedSubcategoryId:
          selectedSubcategoryId ?? this.selectedSubcategoryId,
      selectedSizes: selectedSizes ?? this.selectedSizes,
      showSizeFilter: showSizeFilter ?? this.showSizeFilter,
    );
  }
}

class ProductsByCategoryError extends ProductsByCategoryState {
  final String message;
  ProductsByCategoryError(this.message);
}