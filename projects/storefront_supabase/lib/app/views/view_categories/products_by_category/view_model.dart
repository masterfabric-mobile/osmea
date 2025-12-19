import 'package:core/core.dart';
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
    String? ageGroup,
  }) async {
    try {
      // Logic: Fetch products for activeCategory AND all its descendants (deep search)
      // This ensures if I am in "Electronics", I see "Laptops" products too.
      
      // 1. Get all descendant IDs (Recursive) - Postgres function would be better, but Dart recursion is fine for small trees
      final List<String> allCategoryIds = await _getAllDescendantIds(activeCategoryId);
      allCategoryIds.add(activeCategoryId); // Include self

      // 2. Build Query
      var query = _supabaseClient
          .from('products')
          .select('*, product_images(image_url, is_primary, sort_order)')
          .eq('is_active', true)
          .inFilter('category_id', allCategoryIds); 

      if (showSizeFilter && ageGroup != null) {
        query = query.eq('target_age_group', ageGroup);
      }

      final response = await query.order('created_at', ascending: false);
      final products = (response as List).map((data) => Product.fromJson(data as Map<String, dynamic>)).toList();

      stateChanger(ProductsByCategoryLoaded(
        products: products,
        subCategories: subCategories,
        selectedAgeGroup: ageGroup,
        showSizeFilter: showSizeFilter,
      ));
    } catch (e) {
      stateChanger(ProductsByCategoryError('Failed to load products: $e'));
    }
  }

  Future<List<String>> _getAllDescendantIds(String parentId) async {
    final List<String> ids = [];
    final response = await _supabaseClient.from('categories').select('id').eq('parent_id', parentId);
    
    for (var item in response as List) {
      final id = item['id'] as String;
      ids.add(id);
      ids.addAll(await _getAllDescendantIds(id)); // Recursion
    }
    return ids;
  }

  // When a subcategory chip is clicked, we "drill down" into it.
  // This effectively changes the page context to that subcategory.
  void navigateToSubcategory(String subcategoryId) {
    // Re-run the main fetch logic with the new ID. 
    // This allows deep drilling: Electronics -> Computers -> Laptops
    fetchProductsByCategory(subcategoryId);
  }

  void filterByAgeGroup(String? ageGroup) {
    if (state is ProductsByCategoryLoaded && _currentCategoryId != null) {
      final currentState = state as ProductsByCategoryLoaded;
      
      final newAge = currentState.selectedAgeGroup == ageGroup ? null : ageGroup;

      _fetchProductsInternal(
        activeCategoryId: _currentCategoryId!,
        subCategories: currentState.subCategories,
        showSizeFilter: currentState.showSizeFilter,
        ageGroup: newAge,
      );
    }
  }
}
