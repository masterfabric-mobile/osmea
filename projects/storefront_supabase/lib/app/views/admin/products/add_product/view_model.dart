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

  Category? _selectedRoot;
  Category? _selectedSub;
  Category? _selectedLeaf;
  Brand? _selectedBrand;
  List<String> _selectedSizesOrAges = []; // Changed to List

  // Options
  final List<String> clothingSizesAndAges = [
    // Ages
    'Baby (0-2)', 'Toddler (2-4)', 'Kids (4-8)', 'Pre-Teen (9-12)',
    // Sizes
    'XXS', 'XS', 'S', 'M', 'L', 'XL', 'XXL', '3XL'
  ];

  final List<String> shoeSizes = List.generate(14, (index) => (34 + index).toString()); // 34-47

  AddProductViewModel(this._supabaseClient) : super(AddProductInitial());

  Future<void> initial({String? productId}) async {
    stateChanger(AddProductLoading());
    try {
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

      final allCategories = (results[0] as List)
          .map((data) => Category.fromJson(data))
          .toList();
      final brands = (results[1] as List)
          .map((data) => Brand.fromJson(data))
          .toList();
      final productData = results[2] as Map<String, dynamic>?;
      
      String? existingImageUrl;

      if (productData != null) {
        _populateFormFromData(productData, allCategories, brands);
        
        final images = productData['product_images'] as List?;
        if (images != null && images.isNotEmpty) {
          existingImageUrl = images.first['image_url'] as String?;
        }
      } else {
        _clearForm();
      }

      _emitLoadedState(allCategories, brands, existingImageUrl);
    } catch (e) {
      stateChanger(AddProductError('Failed to load data: $e'));
    }
  }
  
  void _populateFormFromData(Map<String, dynamic> data, List<Category> allCats, List<Brand> allBrands) {
    nameController.text = data['name'] ?? '';
    descriptionController.text = data['description'] ?? '';
    priceController.text = (data['price'] ?? 0).toString();
    skuController.text = data['sku'] ?? '';
    stockController.text = (data['stock_quantity'] ?? 0).toString();
    
    // Convert string back to list (e.g. "S,M,L" -> ["S", "M", "L"])
    final ageGroupStr = data['target_age_group'] as String?;
    if (ageGroupStr != null && ageGroupStr.isNotEmpty) {
      _selectedSizesOrAges = ageGroupStr.split(',').map((e) => e.trim()).toList();
    } else {
      _selectedSizesOrAges = [];
    }

    if (data['brand'] != null) {
      final brandId = data['brand']['id']; 
      // Safe find
      _selectedBrand = allBrands.firstWhere(
        (b) => b.id == brandId, 
        orElse: () => Brand.fromJson(data['brand'])
      );
    }

    if (data['categories'] != null) {
      final catId = data['categories']['id'] as String;
      // Safe find for category
      final category = allCats.firstWhere(
        (c) => c.id == catId, 
        orElse: () => Category.fromJson(data['categories'])
      );
      
      if (category.parentId != null) {
        final parent = allCats.firstWhere((c) => c.id == category.parentId, orElse: () => category);
        if (parent.parentId != null) {
           final root = allCats.firstWhere((c) => c.id == parent.parentId, orElse: () => parent);
           _selectedRoot = root;
           _selectedSub = parent;
           _selectedLeaf = category;
        } else {
           _selectedRoot = parent;
           _selectedSub = category;
           _selectedLeaf = null;
        }
      } else {
        _selectedRoot = category;
        _selectedSub = null;
        _selectedLeaf = null;
      }
    }
  }

  void _clearForm() {
    nameController.clear();
    descriptionController.clear();
    priceController.clear();
    skuController.clear();
    stockController.clear();
    _selectedRoot = null;
    _selectedSub = null;
    _selectedLeaf = null;
    _selectedBrand = null;
    _selectedSizesOrAges = [];
  }

  void _emitLoadedState(List<Category> allCategories, List<Brand> brands, [String? existingImageUrl]) {
    stateChanger(AddProductLoaded(
      allCategories: allCategories,
      brands: brands,
      existingImageUrl: existingImageUrl,
      selectedRootCategory: _selectedRoot,
      selectedSubCategory: _selectedSub,
      selectedLeafCategory: _selectedLeaf,
      selectedBrand: _selectedBrand,
      selectedSizesOrAges: _selectedSizesOrAges,
    ));
  }

  // Hierarchical Selection Logic

  void onRootCategoryChanged(Category? category) {
    if (state is! AddProductLoaded) return;
    _selectedRoot = category;
    _selectedSub = null;
    _selectedLeaf = null;
    _selectedSizesOrAges = []; 
    _refreshState();
  }

  void onSubCategoryChanged(Category? category) {
    if (state is! AddProductLoaded) return;
    _selectedSub = category;
    _selectedLeaf = null;
    _selectedSizesOrAges = [];
    _refreshState();
  }

  void onLeafCategoryChanged(Category? category) {
    if (state is! AddProductLoaded) return;
    _selectedLeaf = category;
    _selectedSizesOrAges = [];
    _refreshState();
  }
  
  void onBrandChanged(Brand? brand) {
    if (state is! AddProductLoaded) return;
    _selectedBrand = brand;
    _refreshState();
  }

  // Multi-select toggle
  void toggleSizeOrAge(String val) {
    if (state is! AddProductLoaded) return;
    
    if (_selectedSizesOrAges.contains(val)) {
      _selectedSizesOrAges.remove(val);
    } else {
      _selectedSizesOrAges.add(val);
    }
    _refreshState();
  }

  void _refreshState() {
    final currentState = state as AddProductLoaded;
    stateChanger(currentState.copyWith(
      selectedRootCategory: _selectedRoot,
      selectedSubCategory: _selectedSub,
      selectedLeafCategory: _selectedLeaf,
      selectedBrand: _selectedBrand,
      selectedSizesOrAges: _selectedSizesOrAges,
    ));
  }
  
  // Helpers for View
  List<Category> getRootCategories(List<Category> all) {
    return all.where((c) => c.parentId == null).toList();
  }
  
  List<Category> getSubCategories(List<Category> all, String? parentId) {
    if (parentId == null) return [];
    return all.where((c) => c.parentId == parentId).toList();
  }

  bool get isShoeCategory {
    final slugToCheck = (_selectedLeaf?.slug ?? _selectedSub?.slug ?? _selectedRoot?.slug ?? '').toLowerCase();
    return slugToCheck.contains('shoe') || slugToCheck.contains('boot') || slugToCheck.contains('sneaker');
  }
  
  bool get isFashionCategory {
     final rootSlug = _selectedRoot?.slug.toLowerCase() ?? '';
     return rootSlug == 'fashion' || rootSlug == 'clothing' || rootSlug.contains('cloth');
  }

  Future<void> submitProduct({String? productId}) async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    if (state is! AddProductLoaded) return;
    final currentState = state as AddProductLoaded;
    
    final finalCategory = _selectedLeaf ?? _selectedSub ?? _selectedRoot;

    if (finalCategory == null || _selectedBrand == null) {
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
        'category_id': finalCategory.id,
        'brand_id': _selectedBrand!.id,
        // Convert list to comma-separated string for DB
        'target_age_group': _selectedSizesOrAges.join(','), 
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

  // ... (keep pickImage and addNewBrand as they were, just accessing new state properties)
  Future<void> pickImage() async {
    if (state is! AddProductLoaded) return;
    final currentState = state as AddProductLoaded;
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      stateChanger(currentState.copyWith(image: File(pickedFile.path), errorMessage: null));
    }
  }
  
  Future<void> addNewBrand(String name) async {
    // ... existing logic but update to use currentState.copyWith with new fields ...
    // To save tokens, I'm assuming the existing method logic is fine, just needing to 
    // respect the new state class structure.
    if (state is! AddProductLoaded) return;
    final currentState = state as AddProductLoaded;
    try {
      final slug = name.toLowerCase().replaceAll(RegExp(r'\s+'), '-');
      final newBrandData = await _supabaseClient.from('brand').insert({'name': name, 'slug': slug}).select().single();
      final newBrand = Brand.fromJson(newBrandData);
      final brandsData = await _supabaseClient.from('brand').select();
      final updatedBrands = brandsData.map((data) => Brand.fromJson(data)).toList();
      _selectedBrand = newBrand;
      stateChanger(currentState.copyWith(brands: updatedBrands, selectedBrand: newBrand));
    } catch (e) {
       stateChanger(currentState.copyWith(errorMessage: 'Error: $e'));
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
