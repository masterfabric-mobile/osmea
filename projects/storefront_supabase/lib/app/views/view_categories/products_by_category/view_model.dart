import 'package:core/core.dart' hide BuildContextTranslationsExtension, AppLocaleUtils, LocaleSettings, TranslationProvider;
import 'package:injectable/injectable.dart';
import 'package:storefront_supabase/app/models/category.dart';
import 'package:storefront_supabase/app/models/product.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'states.dart';

@injectable
class ProductsByCategoryViewModel extends BaseViewModelCubit<ProductsByCategoryState> {
  final SupabaseClient _supabaseClient;

  // Refined age groups based on e-commerce standards
  final List<String> ageGroups = [
    'Baby (0-2)',
    'Toddler (2-4)',
    'Kids (4-8)',
    'Pre-Teen (9-12)',
    'Teens (13-18)',
    'Seniors',
    'XS',
    'S',
    'M',
    'L',
    'XL',
    'XXL',
  ];

  ProductsByCategoryViewModel(this._supabaseClient) : super(ProductsByCategoryInitial());

  String? _currentCategoryId;

  Future<void> fetchProductsByCategory(String categoryId) async {
    _currentCategoryId = categoryId;
    stateChanger(ProductsByCategoryLoading());
    try {
      // 1. Check if we are in the "Fashion" tree (to enable size filters)
      final isFashionTree = await _isCategoryInHierarchy(categoryId, 'fashion');

      // 2. Fetch direct subcategories (Children of the current category)
      final subCategoriesResponse = await _supabaseClient
          .from('categories')
          .select()
          .eq('parent_id', categoryId)
          .order('name');
      
      final subCategories = (subCategoriesResponse as List)
          .map((data) => Category.fromJson(data as Map<String, dynamic>))
          .toList();

      // 3. Fetch products
      await _fetchProductsInternal(
        activeCategoryId: categoryId,
        subCategories: subCategories,
        showSizeFilter: isFashionTree,
      );
    } catch (e) {
      stateChanger(ProductsByCategoryError('Failed to load data: $e'));
    }
  }

  /// Recursively checks if a category or its parents have the given slug
  Future<bool> _isCategoryInHierarchy(String categoryId, String targetSlug) async {
    try {
      // Get the current category
      final response = await _supabaseClient
          .from('categories')
          .select('id, slug, parent_id')
          .eq('id', categoryId)
          .single();
      
      final slug = response['slug'] as String;
      final parentId = response['parent_id'] as String?;

      // Check current
      if (slug.toLowerCase().contains(targetSlug.toLowerCase())) return true;

      // Check parent if exists
      if (parentId != null) {
        return _isCategoryInHierarchy(parentId, targetSlug);
      }
      
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> _fetchProductsInternal({
    required String activeCategoryId,
    required List<Category> subCategories,
    required bool showSizeFilter,
    List<String> selectedSizes = const [],
  }) async {
    try {
      final List<String> allCategoryIds = await _getAllDescendantIds(activeCategoryId);
      allCategoryIds.add(activeCategoryId); 

      var query = _supabaseClient
          .from('products')
          .select('*, product_images(image_url, is_primary, sort_order)')
          .eq('is_active', true)
          .inFilter('category_id', allCategoryIds); 

      // Note: Supabase doesn't have an easy "array contains any of array" filter for comma-separated strings directly via Postgrest yet without complex RPC or splitting.
      // So we fetch products first and filter in memory if size filter is active.
      // Or, we can use ILIKE/OR logic but that's hard dynamically.
      // For this prototype, we filter in memory after fetch.

      final response = await query.order('created_at', ascending: false);
      var products = (response as List).map((data) => Product.fromJson(data as Map<String, dynamic>)).toList();

      if (showSizeFilter && selectedSizes.isNotEmpty) {
        products = products.where((p) {
          if (p.targetAgeGroup == null) return false;
          final productSizes = p.targetAgeGroup!.split(',').map((e) => e.trim()).toList();
          // Intersection check
          return productSizes.any((s) => selectedSizes.contains(s));
        }).toList();
      }

      stateChanger(ProductsByCategoryLoaded(
        products: products,
        subCategories: subCategories,
        selectedSizes: selectedSizes,
        showSizeFilter: showSizeFilter,
      ));
    } catch (e) {
      stateChanger(ProductsByCategoryError('Failed to load products: $e'));
    }
  }

  // Helper for hierarchy
  Future<List<String>> _getAllDescendantIds(String parentId) async {
    final List<String> ids = [];
    final response = await _supabaseClient.from('categories').select('id').eq('parent_id', parentId);
    for (var item in response as List) {
      final id = item['id'] as String;
      ids.add(id);
      ids.addAll(await _getAllDescendantIds(id));
    }
    return ids;
  }

  void navigateToSubcategory(String? subcategoryId) {
    if (state is ProductsByCategoryLoaded && _currentCategoryId != null) {
      final currentState = state as ProductsByCategoryLoaded;
      final newId = currentState.selectedSubcategoryId == subcategoryId ? null : subcategoryId;

      // When category changes, we might want to clear size filters or keep them. 
      // Keeping them usually feels better.
      _fetchProductsInternal(
        activeCategoryId: newId ?? _currentCategoryId!,
        subCategories: currentState.subCategories,
        showSizeFilter: currentState.showSizeFilter, // Ideally re-check hierarchy if subcat changes
        selectedSizes: currentState.selectedSizes,
      );
    }
  }

  void toggleSizeFilter(String size) {
    if (state is ProductsByCategoryLoaded && _currentCategoryId != null) {
      final currentState = state as ProductsByCategoryLoaded;
      
      final currentList = List<String>.from(currentState.selectedSizes);
      if (currentList.contains(size)) {
        currentList.remove(size);
      } else {
        currentList.add(size);
      }

      _fetchProductsInternal(
        activeCategoryId: currentState.selectedSubcategoryId ?? _currentCategoryId!,
        subCategories: currentState.subCategories,
        showSizeFilter: currentState.showSizeFilter,
        selectedSizes: currentList,
      );
    }
  }
}
