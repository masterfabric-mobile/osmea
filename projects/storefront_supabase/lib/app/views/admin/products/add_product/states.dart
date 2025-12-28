import 'dart:io';

import 'package:storefront_supabase/app/models/brand.dart';
import 'package:storefront_supabase/app/models/category.dart';

abstract class AddProductState {}

class AddProductInitial extends AddProductState {}

class AddProductLoading extends AddProductState {}

class AddProductLoaded extends AddProductState {
  final List<Category> categories;
  final List<Brand> brands;
  final Category? selectedCategory;
  final Brand? selectedBrand;
  final File? image;
  final String? existingImageUrl;
  final String? errorMessage;

  AddProductLoaded({
    required this.categories,
    required this.brands,
    this.selectedCategory,
    this.selectedBrand,
    this.image,
    this.existingImageUrl,
    this.errorMessage,
  });

  AddProductLoaded copyWith({
    List<Category>? categories,
    List<Brand>? brands,
    Category? selectedCategory,
    Brand? selectedBrand,
    File? image,
    String? existingImageUrl,
    String? errorMessage,
  }) {
    return AddProductLoaded(
      categories: categories ?? this.categories,
      brands: brands ?? this.brands,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedBrand: selectedBrand ?? this.selectedBrand,
      image: image ?? this.image,
      existingImageUrl: existingImageUrl ?? this.existingImageUrl,
      errorMessage: errorMessage,
    );
  }
}

class AddProductSubmitting extends AddProductState {}

class AddProductSuccess extends AddProductState {}

class AddProductError extends AddProductState {
  final String message;
  AddProductError(this.message);
}
