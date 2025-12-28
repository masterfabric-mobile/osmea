import 'dart:io';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:storefront_supabase/app/models/brand.dart';
import 'package:storefront_supabase/app/models/category.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'states.dart';

@injectable
class AddProductViewModel extends BaseViewModelCubit<AddProductState> {
  final SupabaseClient _supabaseClient;
  final ImagePicker _picker = ImagePicker();

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final skuController = TextEditingController();
  final stockController = TextEditingController();

  Category? selectedCategory;
  Brand? selectedBrand;

  AddProductViewModel(this._supabaseClient) : super(AddProductInitial());

  Future<void> initial({String? productId}) async {
    stateChanger(AddProductLoading());
    try {
      // Fetch categories and brands regardless of mode
      final results = await Future.wait<dynamic>([
        _supabaseClient.from('categories').select(),
        _supabaseClient.from('brand').select(),
        if (productId != null)
          _supabaseClient
              .from('products')
              .select('*, product_images(*), brand(*), categories(*)')
              .eq('id', productId)
              .single()
        else
          Future.value(null),
      ]);

      final categoriesData = results[0] as List;
      final brandsData = results[1] as List;
      final productData = results[2] as Map<String, dynamic>?;

      final categories =
          categoriesData.map((data) => Category.fromJson(data)).toList();
      final brands = brandsData.map((data) => Brand.fromJson(data)).toList();
      String? existingImageUrl;

      // If in edit mode, populate controllers and set selected values
      if (productData != null) {
        nameController.text = productData['name'] ?? '';
        descriptionController.text = productData['description'] ?? '';
        priceController.text = (productData['price'] ?? 0).toString();
        skuController.text = productData['sku'] ?? '';
        stockController.text = (productData['stock_quantity'] ?? 0).toString();

        if (productData['categories'] != null) {
          selectedCategory = Category.fromJson(productData['categories']);
        }
        if (productData['brand'] != null) {
          selectedBrand = Brand.fromJson(productData['brand']);
        }

        final images = productData['product_images'] as List?;
        if (images != null && images.isNotEmpty) {
          existingImageUrl = images.first['image_url'] as String?;
        }
      } else {
        // If in add mode, ensure controllers are clear
        nameController.clear();
        descriptionController.clear();
        priceController.clear();
        skuController.clear();
        stockController.clear();
        selectedCategory = null;
        selectedBrand = null;
      }

      stateChanger(AddProductLoaded(
        categories: categories,
        brands: brands,
        existingImageUrl: existingImageUrl,
      ));
    } catch (e) {
      stateChanger(AddProductError('Failed to load data: $e'));
    }
  }

  Future<void> pickImage() async {
    if (state is! AddProductLoaded) return;
    final currentState = state as AddProductLoaded;

    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      stateChanger(currentState.copyWith(
          image: File(pickedFile.path), errorMessage: null));
    }
  }

  void onCategoryChanged(Category? category) {
    selectedCategory = category;
  }

  void onBrandChanged(Brand? brand) {
    selectedBrand = brand;
  }

  Future<void> addNewBrand(String name) async {
    if (state is! AddProductLoaded) return;
    final currentState = state as AddProductLoaded;

    try {
      final slug = name.toLowerCase().replaceAll(RegExp(r'\\s+'), '-');
      // Insert and immediately fetch the new brand to get its ID
      final newBrandData = await _supabaseClient
          .from('brand')
          .insert({'name': name, 'slug': slug}).select()
          .single();

      final newBrand = Brand.fromJson(newBrandData);

      // Fetch the updated list of all brands
      final brandsData = await _supabaseClient.from('brand').select();
      final updatedBrands =
          brandsData.map((data) => Brand.fromJson(data)).toList();
      
      // Set the new brand as selected
      selectedBrand = newBrand;

      // Update the state without clearing the form
      stateChanger(currentState.copyWith(
        brands: updatedBrands,
        errorMessage: null,
      ));

    } on PostgrestException catch (e) {
      if (e.code == '23505') { // Unique constraint violation
        stateChanger(currentState.copyWith(errorMessage: 'Brand "$name" already exists.'));
      } else {
        stateChanger(currentState.copyWith(errorMessage: 'Error adding brand: ${e.message}'));
      }
    } 
    catch (e) {
      stateChanger(currentState.copyWith(errorMessage: 'An unexpected error occurred: $e'));
    }
  }

  Future<void> submitProduct({String? productId}) async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    if (state is! AddProductLoaded) return;
    final currentState = state as AddProductLoaded;

    if (selectedCategory == null || selectedBrand == null) {
      stateChanger(
          currentState.copyWith(errorMessage: 'Please select a category and brand.'));
      return;
    }

    final isEditMode = productId != null;

    if (!isEditMode && currentState.image == null) {
      stateChanger(currentState.copyWith(errorMessage: 'Please select an image.'));
      return;
    }

    stateChanger(AddProductSubmitting());

    try {
      String? imageUrl;
      if (currentState.image != null) {
        final imageFile = currentState.image!;
        final fileName =
            '${DateTime.now().millisecondsSinceEpoch}.${imageFile.path.split('.').last}';
        final imagePath = 'product_images/$fileName';

        await _supabaseClient.storage.from('products').upload(
              imagePath,
              imageFile,
              fileOptions: FileOptions(cacheControl: '3600', upsert: isEditMode),
            );
        imageUrl =
            _supabaseClient.storage.from('products').getPublicUrl(imagePath);
      }

      final productData = {
        'name': nameController.text,
        'description': descriptionController.text,
        'price': double.parse(priceController.text),
        'sku': skuController.text,
        'stock_quantity': int.parse(stockController.text),
        'category_id': selectedCategory!.id,
        'brand_id': selectedBrand!.id,
      };

      if (!isEditMode) {
        productData['slug'] =
            nameController.text.toLowerCase().replaceAll(' ', '-');
      }

      if (isEditMode) {
        await _supabaseClient
            .from('products')
            .update(productData)
            .eq('id', productId);

        if (imageUrl != null) {
          await _supabaseClient
              .from('product_images')
              .update({'image_url': imageUrl})
              .eq('product_id', productId)
              .eq('is_primary', true);
        }
      } else {
        final productResponse = await _supabaseClient
            .from('products')
            .insert(productData)
            .select('id')
            .single();
        final newProductId = productResponse['id'];

        await _supabaseClient.from('product_images').insert({
          'product_id': newProductId,
          'image_url': imageUrl,
          'is_primary': true,
        });
      }

      stateChanger(AddProductSuccess());
    } on StorageException catch (e) {
      if (e.statusCode == '404') {
        stateChanger(AddProductError(
            "Failed to save product: Storage bucket 'products' not found. Please create it in your Supabase project."));
      } else {
        stateChanger(AddProductError(
            'Failed to save product: Storage error: ${e.message}'));
      }
    } catch (e) {
      stateChanger(AddProductError('Failed to save product: $e'));
    }
  }

  @override
  Future<void> close() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    skuController.dispose();
    stockController.dispose();
    return super.close();
  }
}
