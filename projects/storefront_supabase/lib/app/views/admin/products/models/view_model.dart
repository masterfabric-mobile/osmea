import 'dart:async';
import 'package:core/core.dart' hide BuildContextTranslationsExtension, AppLocaleUtils, LocaleSettings, TranslationProvider;
import 'package:injectable/injectable.dart';
import 'package:flutter/material.dart';
import 'package:storefront_supabase/app/models/brand.dart';
import 'package:storefront_supabase/app/models/category.dart';
import 'package:storefront_supabase/app/models/product.dart';
import 'package:storefront_supabase/app/models/product_filters.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'states.dart';

@injectable
class AdminProductsViewModel
    extends BaseViewModelCubit<AdminProductsState> {
  final SupabaseClient _supabaseClient;
  Timer? _debounce;
  final TextEditingController searchController;

  AdminProductsViewModel(this._supabaseClient)
      : searchController = TextEditingController(),
        super(AdminProductsLoaded(products: []));

  /* -------------------- SEARCH -------------------- */

  void setSearchQuery(String query) {
    if (state is! AdminProductsLoaded) return;
    final currentState = state as AdminProductsLoaded;

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (currentState.searchQuery != query) {
        fetchProducts(searchQuery: query);
      }
    });
  }

  /* -------------------- SORTS -------------------- */

  void setPriceSort(PriceSort sort) {
    if (state is! AdminProductsLoaded) return;
    fetchProducts(priceSort: sort);
  }

  void setDateSort(DateSort sort) {
    if (state is! AdminProductsLoaded) return;
    fetchProducts(dateSort: sort);
  }

  void setPopularitySort(PopularitySort sort) {
    if (state is! AdminProductsLoaded) return;
    fetchProducts(popularitySort: sort);
  }

  // Options for sizes/ages (Shared with AddProduct)
  final List<String> clothingSizesAndAges = [
    'Baby (0-2)', 'Toddler (2-4)', 'Kids (4-8)', 'Pre-Teen (9-12)',
    'XXS', 'XS', 'S', 'M', 'L', 'XL', 'XXL', '3XL'
  ];
  final List<String> shoeSizes = List.generate(14, (index) => (34 + index).toString());

  /* -------------------- FILTERS (Updated) -------------------- */

  void setHierarchicalCategories(Category? root, Category? sub, Category? leaf) {
    if (state is! AdminProductsLoaded) return;
    fetchProducts(
      selectedRoot: root,
      selectedSub: sub,
      selectedLeaf: leaf,
    );
  }

  void setBrandFilters(Set<int> brandIds) {
    if (state is! AdminProductsLoaded) return;
    fetchProducts(selectedBrandIds: brandIds);
  }

  void setSizeFilters(List<String> sizes) {
    if (state is! AdminProductsLoaded) return;
    fetchProducts(selectedSizesOrAges: sizes);
  }

  /* -------------------- FETCH -------------------- */

  Future<void> fetchProducts({
    String? searchQuery,
    PriceSort? priceSort,
    DateSort? dateSort,
    PopularitySort? popularitySort,
    Category? selectedRoot,
    Category? selectedSub,
    Category? selectedLeaf,
    Set<int>? selectedBrandIds,
    List<String>? selectedSizesOrAges,
  }) async {
    AdminProductsLoaded currentState;
    if (state is AdminProductsLoaded) {
      currentState = state as AdminProductsLoaded;
      stateChanger(currentState.copyWith(isLoading: true));
    } else {
      stateChanger(AdminProductsLoading());
      currentState = AdminProductsLoaded(products: []);
    }

    try {
      /* -------- Initial lookup data -------- */
      if (currentState.allCategories.isEmpty || currentState.allBrands.isEmpty) {
        final results = await Future.wait([
          _supabaseClient.from('categories').select(),
          _supabaseClient.from('brand').select(),
        ]);

        currentState = currentState.copyWith(
          allCategories: (results[0] as List).map((e) => Category.fromJson(e)).toList(),
          allBrands: (results[1] as List).map((e) => Brand.fromJson(e)).toList(),
        );
      }

      final finalQuery = searchQuery ?? currentState.searchQuery;
      final finalPriceSort = priceSort ?? currentState.priceSort;
      final finalDateSort = dateSort ?? currentState.dateSort;
      final finalPopularitySort = popularitySort ?? currentState.popularitySort;
      final finalBrandIds = selectedBrandIds ?? currentState.selectedBrandIds;
      final finalSizes = selectedSizesOrAges ?? currentState.selectedSizesOrAges;

      // Handle Hierarchy State
      // If new values are passed, use them. Else fallback to current state.
      // Note: If 'selectedRoot' is passed as null explicitly? 
      // We assume if passed, it's an update. If not passed (null), keep current.
      // But here we might want to clear. Let's assume the View passes the new full state of selection.
      
      // Actually, to support partial updates, we need to know if it was passed.
      // Simplified: The view calls this method with the *new* state of filters.
      
      final activeRoot = selectedRoot ?? currentState.selectedRootCategory;
      final activeSub = selectedSub ?? currentState.selectedSubCategory;
      final activeLeaf = selectedLeaf ?? currentState.selectedLeafCategory;
      
      // If root changed, sub/leaf might be invalid if we didn't clear them in View.
      // We rely on the View/Sheet to provide consistent triplet.

      /* -------- Base query -------- */

      var baseQuery = _supabaseClient
          .from('products') // Using standard table to avoid view dependency issues for now
          .select('*, product_images(*), brand(name)')
          .eq('is_active', true);

      PostgrestFilterBuilder currentFilteredQuery = baseQuery;

      /* -------- Text Search -------- */
      if (finalQuery.isNotEmpty) {
        final sanitizedQuery = finalQuery.replaceAll(',', ' ');
        
        // 1. Find brands that match the query
        final brandResponse = await _supabaseClient
            .from('brand')
            .select('id')
            .ilike('name', '%$sanitizedQuery%');
        
        final brandIds = (brandResponse as List)
            .map((e) => e['id'] as int)
            .toList();

        // 2. Build the OR filter string
        String orFilter = 'name.ilike.*$sanitizedQuery*';
        if (brandIds.isNotEmpty) {
          orFilter += ',brand_id.in.(${brandIds.join(',')})';
        }
        
        currentFilteredQuery = currentFilteredQuery.or(orFilter);
      }

      /* -------- Hierarchy Filter (Deep Search) -------- */
      final targetCategory = activeLeaf ?? activeSub ?? activeRoot;
      if (targetCategory != null) {
        // Get all descendant IDs
        final descendantIds = await _getAllDescendantIds(targetCategory.id);
        descendantIds.add(targetCategory.id);
        
        currentFilteredQuery = currentFilteredQuery.inFilter('category_id', descendantIds);
      }

      /* -------- Brand Filter -------- */
      if (finalBrandIds.isNotEmpty) {
        currentFilteredQuery = currentFilteredQuery.inFilter('brand_id', finalBrandIds.toList());
      }

      /* -------- Sorting -------- */
      PostgrestTransformBuilder finalOrderedQuery;

      if (finalPriceSort != PriceSort.none) {
        finalOrderedQuery = currentFilteredQuery.order(
          'price',
          ascending: finalPriceSort == PriceSort.lowToHigh,
        );
      } else if (finalPopularitySort != PopularitySort.none) {
        // Fallback to price if wishlist_count column missing on raw table
        finalOrderedQuery = currentFilteredQuery.order('price'); 
      } else {
        finalOrderedQuery = currentFilteredQuery.order(
          'created_at',
          ascending: finalDateSort == DateSort.oldestFirst,
        );
      }

      /* -------- Execute & Client-side Size Filter -------- */
      final response = await finalOrderedQuery;
      var products = (response as List).map((e) => Product.fromJson(e)).toList();

      // Client-side filtering for sizes (comma-separated string in DB)
      if (finalSizes.isNotEmpty) {
        products = products.where((p) {
          if (p.targetAgeGroup == null) return false;
          // DB: "S, M, L" -> List: ["S", "M", "L"]
          final productSizes = p.targetAgeGroup!.split(',').map((e) => e.trim()).toList();
          // Check intersection: Does product have *any* of the selected filters?
          return productSizes.any((s) => finalSizes.contains(s));
        }).toList();
      }

      stateChanger(
        AdminProductsLoaded(
          products: products,
          searchQuery: finalQuery,
          priceSort: finalPriceSort,
          dateSort: finalDateSort,
          popularitySort: finalPopularitySort,
          allCategories: currentState.allCategories,
          allBrands: currentState.allBrands,
          selectedRootCategory: activeRoot,
          selectedSubCategory: activeSub,
          selectedLeafCategory: activeLeaf,
          selectedBrandIds: finalBrandIds,
          selectedSizesOrAges: finalSizes,
          isLoading: false,
        ),
      );
    } catch (e) {
      stateChanger(AdminProductsError('Failed to load products: $e'));
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
  
  // Helpers for UI
  List<Category> getRootCategories(List<Category> all) {
    return all.where((c) => c.parentId == null).toList();
  }
  
  List<Category> getSubCategories(List<Category> all, String? parentId) {
    if (parentId == null) return [];
    return all.where((c) => c.parentId == parentId).toList();
  }

  bool isShoeCategory(Category? leaf, Category? sub, Category? root) {
    final slugToCheck = (leaf?.slug ?? sub?.slug ?? root?.slug ?? '').toLowerCase();
    return slugToCheck.contains('shoe') || slugToCheck.contains('boot') || slugToCheck.contains('sneaker');
  }
  
  bool isFashionCategory(Category? root) {
     final rootSlug = root?.slug.toLowerCase() ?? '';
     return rootSlug == 'fashion' || rootSlug == 'clothing' || rootSlug.contains('cloth');
  }

  /* -------------------- DISPOSE -------------------- */
  @override
  Future<void> close() {
    _debounce?.cancel();
    searchController.dispose();
    return super.close();
  }
}
