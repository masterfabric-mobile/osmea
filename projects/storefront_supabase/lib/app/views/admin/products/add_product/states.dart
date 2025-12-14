import 'dart:io';

import 'package:storefront_supabase/app/models/brand.dart';
import 'package:storefront_supabase/app/models/category.dart';

abstract class AddProductState {}

class AddProductInitial extends AddProductState {}

class AddProductLoading extends AddProductState {}

class AddProductLoaded extends AddProductState {
  final List<Category> categories;
  final List<Brand> brands;
  final File? image;
  final String? errorMessage;

  AddProductLoaded({
    required this.categories,
    required this.brands,
    this.image,
    this.errorMessage,
  });

  AddProductLoaded copyWith({
    List<Category>? categories,
    List<Brand>? brands,
    File? image,
    String? errorMessage,
  }) {
    return AddProductLoaded(
      categories: categories ?? this.categories,
      brands: brands ?? this.brands,
      image: image ?? this.image,
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
