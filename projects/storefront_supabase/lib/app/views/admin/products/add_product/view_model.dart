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

  Future<void> initial() async {
    stateChanger(AddProductLoading());
    try {
      final results = await Future.wait([
        _supabaseClient.from('categories').select(),
        _supabaseClient.from('brand').select(),
      ]);

      final categoriesData = results[0] as List;
      final brandsData = results[1] as List;

      final categories =
          categoriesData.map((data) => Category.fromJson(data)).toList();
      final brands = brandsData.map((data) => Brand.fromJson(data)).toList();

      stateChanger(AddProductLoaded(categories: categories, brands: brands));
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
      stateChanger(currentState.copyWith(image: File(pickedFile.path)));
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
      final slug = name.toLowerCase().replaceAll(RegExp(r'\s+'), '-');
      await _supabaseClient.from('brand').insert({
        'name': name,
        'slug': slug,
      });
      // Refresh data to get the new brand
      await initial();
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

  Future<void> submitProduct() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    if (state is! AddProductLoaded) return;
    final currentState = state as AddProductLoaded;

    if (selectedCategory == null || selectedBrand == null) {
      stateChanger(currentState.copyWith(errorMessage: 'Please select a category and brand.'));
      return;
    }
    if (currentState.image == null) {
      stateChanger(currentState.copyWith(errorMessage: 'Please select an image.'));
      return;
    }

    stateChanger(AddProductSubmitting());

    try {
      final imageFile = currentState.image!;
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}.${imageFile.path.split('.').last}';
      final imagePath = 'product_images/$fileName';

      // Upload image
      await _supabaseClient.storage.from('products').upload(
            imagePath,
            imageFile,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      // Get public URL
      final imageUrl =
          _supabaseClient.storage.from('products').getPublicUrl(imagePath);

      // Create product
      final newProduct = {
        'name': nameController.text,
        'description': descriptionController.text,
        'price': double.parse(priceController.text),
        'sku': skuController.text,
        'stock_quantity': int.parse(stockController.text),
        'category_id': selectedCategory!.id,
        'brand_id': selectedBrand!.id,
        'slug': nameController.text.toLowerCase().replaceAll(' ', '-'),
      };

      final productResponse = await _supabaseClient
          .from('products')
          .insert(newProduct)
          .select('id')
          .single();

      final productId = productResponse['id'];

      // Create product image entry
      await _supabaseClient.from('product_images').insert({
        'product_id': productId,
        'image_url': imageUrl,
        'is_primary': true,
      });

      stateChanger(AddProductSuccess());
    } on StorageException catch (e) {
      if (e.statusCode == '404') {
        stateChanger(AddProductError(
            "Failed to add product: Storage bucket 'products' not found. Please create it in your Supabase project."));
      } else {
        stateChanger(
            AddProductError('Failed to add product: Storage error: ${e.message}'));
      }
    } catch (e) {
      stateChanger(AddProductError('Failed to add product: $e'));
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
