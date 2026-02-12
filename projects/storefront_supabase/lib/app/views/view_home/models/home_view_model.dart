import 'dart:async';
import 'package:core/core.dart'
    hide
        BuildContextTranslationsExtension,
        AppLocaleUtils,
        LocaleSettings,
        TranslationProvider,
        AuthState;
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:storefront_supabase/app/models/brand.dart';
import 'package:storefront_supabase/app/models/category.dart';
import 'package:storefront_supabase/app/models/product.dart';
import 'package:storefront_supabase/app/models/product_filters.dart';
import 'package:storefront_supabase/app/utils/brand_logo_url_helper.dart';
import 'package:storefront_supabase/app/core/cart/cart_cache.dart';
import 'package:storefront_supabase/app/utils/category_image_url_helper.dart';
import 'package:storefront_supabase/app/views/view_favorites/models/view_model.dart';
import 'package:storefront_supabase/app/views/view_favorites/models/states.dart';
import 'package:storefront_supabase/app/views/view_cart/models/view_model.dart';
import 'package:get_it/get_it.dart';
import 'states.dart';

@lazySingleton
class SupabaseHomeViewModel extends BaseViewModelCubit<SupabaseHomeState> {
  final SupabaseClient _supabaseClient;
  final CartCache _cartCache;
  StreamSubscription<AuthState>? _authSubscription;

  // Options for sizes/ages
  final List<String> clothingSizesAndAges = [
    'Baby (0-2)',
    'Toddler (2-4)',
    'Kids (4-8)',
    'Pre-Teen (9-12)',
    'XXS',
    'XS',
    'S',
    'M',
    'L',
    'XL',
    'XXL',
    '3XL',
  ];
  final List<String> shoeSizes = List.generate(
    14,
    (index) => (34 + index).toString(),
  );

  final TextEditingController searchController = TextEditingController();

  SupabaseHomeViewModel(this._supabaseClient, this._cartCache)
    : super(SupabaseHomeInitialState()) {
    // Listen for Auth Changes
    _authSubscription = _supabaseClient.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.signedIn) {
        if (state is SupabaseHomeLoadedState) {
          stateChanger(
            (state as SupabaseHomeLoadedState).copyWith(
              showLoginSuccessSnackbar: true,
            ),
          );
        }
      }
    });
  }

  void resetLoginSnackbar() {
    if (state is SupabaseHomeLoadedState) {
      stateChanger(
        (state as SupabaseHomeLoadedState).copyWith(
          showLoginSuccessSnackbar: false,
        ),
      );
    }
  }

  void showLoginSuccess() {
    if (state is SupabaseHomeLoadedState) {
      stateChanger(
        (state as SupabaseHomeLoadedState).copyWith(
          showLoginSuccessSnackbar: true,
        ),
      );
    }
  }

  void setSearchQuery(String query) {
    if (state is! SupabaseHomeLoadedState) return;
    fetchProducts(searchQuery: query);
  }

  void toggleViewMode(bool isList) {
    if (state is! SupabaseHomeLoadedState) return;
    final currentState = state as SupabaseHomeLoadedState;
    if (currentState.isListView != isList) {
      stateChanger(currentState.copyWith(isListView: isList));
    }
  }

  void setPriceSort(PriceSort sort) {
    if (state is! SupabaseHomeLoadedState) return;
    fetchProducts(priceSort: sort);
  }

  void setDateSort(DateSort sort) {
    if (state is! SupabaseHomeLoadedState) return;
    fetchProducts(dateSort: sort);
  }

  void setPopularitySort(PopularitySort sort) {
    if (state is! SupabaseHomeLoadedState) return;
    fetchProducts(popularitySort: sort);
  }

  void selectProduct(Product product) {
    if (state is SupabaseHomeLoadedState) {
      final currentState = state as SupabaseHomeLoadedState;
      stateChanger(currentState.copyWith(selectedProduct: product));
    }
  }

  Future<void> initial() async {
    await fetchProducts();
  }

  void restart() {
    searchController.clear();
    stateChanger(SupabaseHomeInitialState());
    initial();
  }

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
    bool applyFilter = false,
  }) async {
    SupabaseHomeLoadedState currentState = state is SupabaseHomeLoadedState
        ? state as SupabaseHomeLoadedState
        : SupabaseHomeLoadedState(products: []);

    stateChanger(currentState.copyWith(isLoading: true));

    try {
      final finalQuery = searchQuery ?? currentState.searchQuery;
      final finalPriceSort = priceSort ?? currentState.priceSort;
      final finalDateSort = dateSort ?? currentState.dateSort;
      final finalPopularitySort = popularitySort ?? currentState.popularitySort;

      final activeRoot = applyFilter
          ? selectedRoot
          : (selectedRoot ?? currentState.selectedRootCategory);
      final activeSub = applyFilter
          ? selectedSub
          : (selectedSub ?? currentState.selectedSubCategory);
      final activeLeaf = applyFilter
          ? selectedLeaf
          : (selectedLeaf ?? currentState.selectedLeafCategory);

      final finalBrandIds = applyFilter
          ? (selectedBrandIds ?? const {})
          : (selectedBrandIds ?? currentState.selectedBrandIds);

      final finalSizes = applyFilter
          ? (selectedSizesOrAges ?? const [])
          : (selectedSizesOrAges ?? currentState.selectedSizesOrAges);

      // --- Prepare Product Query ---
      var baseQuery = _supabaseClient
          .from('products')
          .select(
            '*, product_images(image_url, is_primary, sort_order), brand(name)',
          )
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

      /* -------- Brand Filter -------- */
      if (finalBrandIds.isNotEmpty) {
        currentFilteredQuery = currentFilteredQuery.inFilter(
          'brand_id',
          finalBrandIds.toList(),
        );
      }

      /* -------- Sorting -------- */
      PostgrestTransformBuilder finalOrderedQuery;

      if (finalPriceSort != PriceSort.none) {
        finalOrderedQuery = currentFilteredQuery.order(
          'price',
          ascending: finalPriceSort == PriceSort.lowToHigh,
        );
      } else if (finalPopularitySort != PopularitySort.none) {
        finalOrderedQuery = currentFilteredQuery.order('price');
      } else {
        finalOrderedQuery = currentFilteredQuery.order(
          'created_at',
          ascending: finalDateSort == DateSort.oldestFirst,
        );
      }

      List<Product> products = [];
      List<Product> onSaleProducts = currentState.onSaleProducts;
      List<Product> productsOfTheDay = currentState.productsOfTheDay;
      List<Product> recommendedProducts = currentState.recommendedProducts;
      List<Product> collectionProducts = currentState.collectionProducts;
      List<Category> allCategories = currentState.allCategories;
      List<Brand> allBrands = currentState.allBrands;

      if (currentState.allCategories.isEmpty ||
          currentState.allBrands.isEmpty) {
        // Initial Fetch
        final results = await Future.wait([
          _supabaseClient
              .from('categories')
              .select('id, name, slug, description, image_url, parent_id'),
          _supabaseClient
              .from('brand')
              .select('id, name, slug, logo_url, description'),
          finalOrderedQuery,
          // On Sale
          _supabaseClient
              .from('products')
              .select(
                '*, product_images(image_url, is_primary, sort_order), brand(name)',
              )
              .eq('is_active', true)
              .not('sale_price', 'is', null)
              .order('created_at', ascending: false)
              .limit(10),
          // Featured (for collections)
          _supabaseClient
              .from('products')
              .select(
                '*, product_images(image_url, is_primary, sort_order), brand(name)',
              )
              .eq('is_active', true)
              .eq('is_featured', true)
              .limit(10),
          // Recommended (View count)
          _supabaseClient
              .from('products')
              .select(
                '*, product_images(image_url, is_primary, sort_order), brand(name)',
              )
              .eq('is_active', true)
              .order('view_count', ascending: false)
              .limit(10),
        ]);

        allCategories = (results[0] as List)
            .map((e) => Category.fromJson(e))
            .map(
              (c) => c.copyWith(
                imageUrl: resolveCategoryImageUrl(_supabaseClient, c.imageUrl),
              ),
            )
            .toList();
        allBrands = (results[1] as List)
            .map((e) => Brand.fromJson(e))
            .map(
              (b) => b.copyWith(
                logoUrl: resolveBrandLogoUrl(_supabaseClient, b.logoUrl),
              ),
            )
            .toList();

        products = (results[2] as List)
            .map((e) => Product.fromJson(e))
            .toList();

        onSaleProducts = (results[3] as List)
            .map((e) => Product.fromJson(e))
            .where((p) => p.hasDiscount)
            .toList();

        collectionProducts = (results[4] as List)
            .map((e) => Product.fromJson(e))
            .toList();

        recommendedProducts = (results[5] as List)
            .map((e) => Product.fromJson(e))
            .toList();

        // Randomize products for Day
        final pool = List<Product>.from(products);
        pool.shuffle();
        productsOfTheDay = pool.take(3).toList();
      } else {
        // Subsequent Fetch
        final response = await finalOrderedQuery;
        products = (response as List).map((e) => Product.fromJson(e)).toList();
      }

      stateChanger(
        SupabaseHomeLoadedState(
          products: products,
          onSaleProducts: onSaleProducts,
          productsOfTheDay: productsOfTheDay,
          collectionProducts: collectionProducts,
          recommendedProducts: recommendedProducts,
          searchQuery: finalQuery,
          priceSort: finalPriceSort,
          dateSort: finalDateSort,
          popularitySort: finalPopularitySort,
          allCategories: allCategories,
          allBrands: allBrands,
          selectedRootCategory: activeRoot,
          selectedSubCategory: activeSub,
          selectedLeafCategory: activeLeaf,
          selectedBrandIds: finalBrandIds,
          selectedSizesOrAges: finalSizes,
          isLoading: false,
        ),
      );
    } catch (e) {
      stateChanger(SupabaseHomeErrorState('Failed to load products: $e'));
    }
  }

  Future<void> addProductToWishlist(String productId) async {
    try {
      final wishlistVm = GetIt.I<FavoritesViewModel>();

      // We will use FavoritesViewModel directly.
      // If FavoritesViewModel supports toggle by ID:
      // Since it doesn't have a direct toggle method by ID in previous code,
      // we need to check if it's saved and then add/remove.

      // Note: FavoritesViewModel uses int/String for ID?
      // Supabase uses UUID (String) for products. `Product` model has String id.
      // But `FavoritesViewModel` in `storefront_supabase` uses `Product` model which has String id.
      // So we are good with String productId.

      // Wait, let me check `FavoritesViewModel` code from previous turns.
      // `storefront_supabase/lib/app/views/view_favorites/models/view_model.dart`
      // `removeFavorite(String productId)`
      // `addToCart(String productId)`
      // It DOES NOT have `addFavorite` exposed?
      // I will assume I need to implement `addFavorite` in `FavoritesViewModel`.
      // For now, I will simulate it here or use what's available.

      // Actually, I can implement `toggleFavorite` here if needed, calling Supabase directly?
      // No, better to use ViewModel.

      // Let's implement basic toggle here calling Supabase directly if ViewModel falls short,
      // but ideally we update ViewModel.
      // Since I can't update ViewModel right now (focused on Home), I'll do it here.

      final userId = _supabaseClient.auth.currentUser?.id;
      if (userId == null) {
        // Handle unauthenticated
        return;
      }

      final isSaved = isProductSaved(productId);

      if (isSaved) {
        await _supabaseClient.from('favorites').delete().match({
          'user_id': userId,
          'product_id': productId,
        });
      } else {
        await _supabaseClient.from('favorites').insert({
          'user_id': userId,
          'product_id': productId,
        });
      }

      // Refresh favorites to update UI
      await wishlistVm.initial();
    } catch (e) {
      debugPrint('Error toggling wishlist: $e');
    }
  }

  bool isProductSaved(String productId) {
    try {
      final wishlistVm = GetIt.I<FavoritesViewModel>();
      if (wishlistVm.state is FavoritesLoadedState) {
        return (wishlistVm.state as FavoritesLoadedState).favoriteProducts.any(
          (p) => p.id == productId,
        );
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  /// Sepete ekler. Misafir kullanıcı da sepete ekleyebilir (yerel sepet).
  Future<void> addProductToCart(String productId) async {
    try {
      final cartVm = GetIt.I<CartViewModel>();
      await cartVm.addItemToCart(productId, quantity: 1, variantId: null);
      final uid = _supabaseClient.auth.currentUser?.id;
      _cartCache.setInCart(uid ?? 'guest', productId, null, true);
    } catch (e) {
      debugPrint('Error adding to cart: $e');
      rethrow;
    }
  }

  @override
  Future<void> close() {
    searchController.dispose();
    _authSubscription?.cancel();
    return super.close();
  }
}
