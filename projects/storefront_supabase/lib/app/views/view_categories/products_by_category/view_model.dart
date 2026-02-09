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
  
  // Cache for categories to avoid refetching on every sub-navigation if possible,
  // but for now we'll fetch fresh to ensure consistency.
  List<Category> _allCachedCategories = [];

  static final RegExp _uuidRegex = RegExp(
    r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
  );

  Future<void> fetchProductsByCategory(String categoryId) async {
    _currentCategoryId = categoryId;
    if (!_uuidRegex.hasMatch(categoryId)) {
      stateChanger(ProductsByCategoryError(
        'Invalid category. Special offer and campaign links must use a valid category ID.',
      ));
      return;
    }
    stateChanger(ProductsByCategoryLoading());
    try {
      // 1. Fetch ALL categories at once to build hierarchy in memory.
      // This is much faster than recursive DB calls.
      final categoriesResponse = await _supabaseClient
          .from('categories')
          .select('*, products(count)') // Select everything needed
          .order('name');
      
      _allCachedCategories = (categoriesResponse as List)
          .map((data) => Category.fromJson(data as Map<String, dynamic>))
          .toList();

      // 2. Process hierarchy in memory
      
      // Check Fashion Tree
      final isFashionTree = _isCategoryInHierarchyInMemory(categoryId, 'fashion');

      // Get Direct Subcategories
      final subCategories = _allCachedCategories
          .where((c) => c.parentId == categoryId)
          .toList();

      // Get All Descendant IDs for Product Query
      final allCategoryIds = _getAllDescendantIdsInMemory(categoryId);
      allCategoryIds.add(categoryId); // Include current

      // 3. Fetch Products
      await _fetchProductsWithIds(
        categoryIds: allCategoryIds,
        subCategories: subCategories,
        showSizeFilter: isFashionTree,
      );

    } catch (e) {
      stateChanger(ProductsByCategoryError('Failed to load data: $e'));
    }
  }

  /// Checks if category is in hierarchy of targetSlug using in-memory list
  bool _isCategoryInHierarchyInMemory(String categoryId, String targetSlug) {
    String? currentId = categoryId;
    while (currentId != null) {
      final category = _allCachedCategories.firstWhere(
        (c) => c.id == currentId,
        orElse: () => Category(id: 'notFound', name: '', slug: ''),
      );
      
      if (category.id == 'notFound') break;
      
      if (category.slug.toLowerCase().contains(targetSlug.toLowerCase())) {
        return true;
      }
      currentId = category.parentId;
    }
    return false;
  }

  /// Gets all descendant IDs recursively from memory
  List<String> _getAllDescendantIdsInMemory(String parentId) {
    final directChildren = _allCachedCategories.where((c) => c.parentId == parentId).toList();
    final List<String> ids = [];
    
    for (var child in directChildren) {
      ids.add(child.id);
      ids.addAll(_getAllDescendantIdsInMemory(child.id));
    }
    return ids;
  }

  Future<void> _fetchProductsWithIds({
    required List<String> categoryIds,
    required List<Category> subCategories,
    required bool showSizeFilter,
    List<String> selectedSizes = const [],
  }) async {
    try {
      var query = _supabaseClient
          .from('products')
          .select('*, product_images(image_url, is_primary, sort_order)')
          .eq('is_active', true)
          .inFilter('category_id', categoryIds); 

      final response = await query.order('created_at', ascending: false);
      var products = (response as List).map((data) => Product.fromJson(data as Map<String, dynamic>)).toList();

      if (showSizeFilter && selectedSizes.isNotEmpty) {
        products = products.where((p) {
          if (p.targetAgeGroup == null) return false;
          final productSizes = p.targetAgeGroup!.split(',').map((e) => e.trim()).toList();
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

  void toggleSizeFilter(String size) {
    if (state is ProductsByCategoryLoaded && _currentCategoryId != null) {
      final currentState = state as ProductsByCategoryLoaded;
      
      final currentList = List<String>.from(currentState.selectedSizes);
      if (currentList.contains(size)) {
        currentList.remove(size);
      } else {
        currentList.add(size);
      }

      // We need to re-fetch or re-filter?
      // Since we filter in memory at the end of _fetchProductsWithIds, 
      // we need to call it again. But to avoid re-fetching products from DB 
      // just for client-side filter, we should ideally cache products too.
      // However, to keep it simple and safe with the current structure:
      
      // Optimization: We already have the full product list if we didn't filter in DB.
      // But _fetchProductsWithIds does the DB fetch. 
      // For responsiveness, let's just re-run the whole flow or optimize?
      // Re-running flow is safe. optimizing is better. 
      
      // Let's re-run the fetch for now to ensure consistency, 
      // but ideally we'd store `allFetchedProducts` in state and filter locally.
      
      final allCategoryIds = _getAllDescendantIdsInMemory(_currentCategoryId!);
      allCategoryIds.add(_currentCategoryId!);

      _fetchProductsWithIds(
        categoryIds: allCategoryIds,
        subCategories: currentState.subCategories,
        showSizeFilter: currentState.showSizeFilter,
        selectedSizes: currentList,
      );
    }
  }
}
