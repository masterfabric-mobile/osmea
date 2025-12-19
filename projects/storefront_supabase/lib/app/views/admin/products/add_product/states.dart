import 'dart:io';

import 'package:storefront_supabase/app/models/brand.dart';
import 'package:storefront_supabase/app/models/category.dart';

abstract class AddProductState {}

class AddProductInitial extends AddProductState {}

class AddProductLoading extends AddProductState {}

class AddProductLoaded extends AddProductState {
  final List<Category> allCategories; // Holds raw list
  final List<Brand> brands;
  
  // Hierarchical Selections
  final Category? selectedRootCategory;
  final Category? selectedSubCategory;
  final Category? selectedLeafCategory; // The deepest selected level
  
  final Brand? selectedBrand;
  final String? selectedSizeOrAge; // Holds 'XS', '42', 'Kids (4-8)', etc.
  
  final File? image;
  final String? existingImageUrl;
  final String? errorMessage;

  AddProductLoaded({
    required this.allCategories,
    required this.brands,
    this.selectedRootCategory,
    this.selectedSubCategory,
    this.selectedLeafCategory,
    this.selectedBrand,
    this.selectedSizeOrAge,
    this.image,
    this.existingImageUrl,
    this.errorMessage,
  });

  AddProductLoaded copyWith({
    List<Category>? allCategories,
    List<Brand>? brands,
    Category? selectedRootCategory,
    Category? selectedSubCategory,
    Category? selectedLeafCategory,
    Brand? selectedBrand,
    String? selectedSizeOrAge,
    File? image,
    String? existingImageUrl,
    String? errorMessage,
  }) {
    return AddProductLoaded(
      allCategories: allCategories ?? this.allCategories,
      brands: brands ?? this.brands,
      selectedRootCategory: selectedRootCategory ?? this.selectedRootCategory,
      selectedSubCategory: selectedSubCategory ?? this.selectedSubCategory,
      selectedLeafCategory: selectedLeafCategory ?? this.selectedLeafCategory,
      selectedBrand: selectedBrand ?? this.selectedBrand,
      selectedSizeOrAge: selectedSizeOrAge ?? this.selectedSizeOrAge,
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
