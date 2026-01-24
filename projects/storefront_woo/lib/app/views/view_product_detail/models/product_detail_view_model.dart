/*
 * ProductDetailViewModel
 * ----------------------
 * ViewModel for the product detail view following OSMEA architecture.
 * Uses Bloc pattern with events and states from core package.
 * Based on admin_dashboard pattern for consistency.
 */

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_api/abstract/product_service.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_api/freezed_model/response/retrieve_product_response_model.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_attribute_terms/abstract/store_product_attribute_terms_service.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_attribute_terms/freezed_model/response/list_product_attribute_terms_response_model.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_attributes_api/abstract/store_product_attributes_service.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_attributes_api/freezed_model/response/list_product_attributes_response_model.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_attributes_api/freezed_model/response/retrieve_product_attribute_response_model.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_reviews_api/abstract/store_product_reviews_service.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_reviews_api/freezed_model/response/list_product_reviews_response_model.dart';
import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:storefront_woo/app/views/view_product_detail/models/module/states.dart';
import 'package:storefront_woo/app/views/view_home/models/home_view_model.dart';
import 'package:storefront_woo/app/views/view_home/models/module/states.dart';
import 'package:apis/network/remote/woocommerce/store_api/cart_api/abstract/cart_service.dart';
import 'package:apis/network/remote/woocommerce/store_api/cart_api/freezed_model/response/get_cart_response.dart';
import 'package:apis/models/cart/woo_cart_token.dart';
import 'package:apis/utils/api_error_utils.dart';
import 'package:storefront_woo/app/views/view_wishlist/models/wishlist_view_model.dart';
import 'package:storefront_woo/app/views/view_wishlist/models/module/states.dart';
import 'package:storefront_woo/app/utils/wishlist_local_helper.dart';
import 'package:get_it/get_it.dart';

@injectable
class ProductDetailViewModel
    extends BaseViewModelHydratedCubit<ProductDetailState> {
  ProductDetailViewModel() : super(ProductDetailInitialState());

  // Dependencies
  final ProductService _productService = GetIt.I<ProductService>();
  final CartService _cartService = GetIt.I<CartService>();
  final StoreProductAttributeTermsService _attributeTermsService =
      GetIt.I<StoreProductAttributeTermsService>();
  final StoreProductAttributesService _attributesService =
      GetIt.I<StoreProductAttributesService>();
  final StoreProductReviewsService _reviewsService =
      GetIt.I<StoreProductReviewsService>();
  final AssetConfigHelper _configHelper = AssetConfigHelper();

  // Arguments holder for route/widget inputs
  final Map<String, dynamic> _arguments = {};
  void setArguments(Map<String, dynamic> args) {
    _arguments
      ..clear()
      ..addAll(args);
  }

  Map<String, dynamic> get arguments => Map.unmodifiable(_arguments);

  // State variables
  int _selectedQuantity = 1;
  List<String> _imageUrls = [];
  final int _currentImageIndex = 0;

  // ============================================================================
  // Public API Methods - Structured Pattern: Future first, then Fire (void)
  // ============================================================================

  // ----------------------------------------------------------------------------
  // Product Loading
  // ----------------------------------------------------------------------------

  /// Initializes wishlist and loads product
  /// This ensures wishlist state is ready before checking product status
  Future<void> initializeWithProduct(int productId) async {
    // Initialize wishlist first
    try {
      final wishlistViewModel = GetIt.I<WishlistViewModel>();
      final currentState = wishlistViewModel.state;
      // Only sync if state is initial or empty
      if (currentState is WishlistInitialState ||
          (currentState is WishlistLoadedState && currentState.items.isEmpty)) {
        await wishlistViewModel.initial();
        debugPrint(
          '✅ ProductDetailViewModel: Wishlist initialized with ${wishlistViewModel.count} items',
        );
      }
    } catch (e) {
      debugPrint(
        '⚠️ ProductDetailViewModel: Failed to initialize wishlist: $e',
      );
    }
    // Load product after wishlist is ready
    await loadProduct(productId);
  }

  /// Loads product details from API or cache
  /// Fetches product data, images, and checks cart/wishlist status
  /// Returns Future to allow await in calling code
  Future<void> loadProduct(int productId) async =>
      await _loadProduct(productId);

  /// Convenience: fire-and-forget product load (void)
  /// Calls the Future-based loadProduct under the hood
  void loadProductFire(int productId) {
    // Fire-and-forget wrapper that sits on top of Future method
    // ignore: discarded_futures
    loadProduct(productId);
  }

  // ----------------------------------------------------------------------------
  // Cart Operations
  // ----------------------------------------------------------------------------

  /// Adds product to cart with specified quantity
  /// Returns Future to allow await in calling code
  Future<void> addProductToCart(int productId, {int quantity = 1}) async =>
      await _addToCart(productId, quantity);

  /// Convenience: fire-and-forget add to cart (void)
  /// Calls the Future-based addProductToCart under the hood
  void addProductToCartFire(int productId, {int quantity = 1}) {
    // Fire-and-forget wrapper that sits on top of Future method
    // ignore: discarded_futures
    addProductToCart(productId, quantity: quantity);
  }

  // ----------------------------------------------------------------------------
  // Wishlist Operations
  // ----------------------------------------------------------------------------

  /// Adds or removes product from wishlist
  /// Returns Future to allow await in calling code
  Future<void> addProductToWishlist(int productId) async =>
      await _addToWishlist(productId);

  /// Convenience: fire-and-forget wishlist toggle (void)
  /// Calls the Future-based addProductToWishlist under the hood
  void addProductToWishlistFire(int productId) {
    // Fire-and-forget wrapper that sits on top of Future method
    // ignore: discarded_futures
    addProductToWishlist(productId);
  }

  /// Updates wishlist status in local state (called from view lifecycle)
  /// This keeps ProductDetailViewModel state in sync with WishlistViewModel
  void updateWishlistStatus(int productId, bool isInWishlist) {
    try {
      final currentState = state;
      if (currentState is ProductDetailLoadedState &&
          currentState.product.id == productId) {
        emit(currentState.copyWith(isInWishlist: isInWishlist));
      }
    } catch (e) {
      debugPrint(
        '❌ ProductDetailViewModel: Failed to update wishlist status: $e',
      );
    }
  }

  // ----------------------------------------------------------------------------
  // Quantity Management
  // ----------------------------------------------------------------------------

  /// Updates the selected quantity for the product
  /// Returns Future to allow await in calling code (wrapped sync operation)
  Future<void> updateQuantity(int quantity) async =>
      await Future.microtask(() => _changeQuantity(quantity));

  /// Convenience: fire-and-forget quantity update (void)
  /// Calls the Future-based updateQuantity under the hood
  void updateQuantityFire(int quantity) {
    // Fire-and-forget wrapper that sits on top of Future method
    // ignore: discarded_futures
    updateQuantity(quantity);
  }

  // ----------------------------------------------------------------------------
  // Image Management
  // ----------------------------------------------------------------------------

  /// Loads and sets product image URLs
  /// Returns Future to allow await in calling code (wrapped sync operation)
  Future<void> loadProductImages(List<String> imageUrls) async =>
      await Future.microtask(() => _loadImages(imageUrls));

  /// Convenience: fire-and-forget image load (void)
  /// Calls the Future-based loadProductImages under the hood
  void loadProductImagesFire(List<String> imageUrls) {
    // Fire-and-forget wrapper that sits on top of Future method
    // ignore: discarded_futures
    loadProductImages(imageUrls);
  }

  // ----------------------------------------------------------------------------
  // Description Expand/Collapse Management
  // ----------------------------------------------------------------------------

  /// Sets description expanded state
  Future<void> setDescriptionExpanded(bool isExpanded) async =>
      Future.microtask(() {
        final currentState = state;
        if (currentState is ProductDetailLoadedState) {
          emit(currentState.copyWith(isDescriptionExpanded: isExpanded));
        }
      });

  /// Fire-and-forget version
  void setDescriptionExpandedFire(bool isExpanded) {
    // ignore: discarded_futures
    setDescriptionExpanded(isExpanded);
  }

  /// Toggles description expanded state
  Future<void> toggleDescriptionExpanded() async => Future.microtask(() {
    final currentState = state;
    if (currentState is ProductDetailLoadedState) {
      emit(
        currentState.copyWith(
          isDescriptionExpanded: !currentState.isDescriptionExpanded,
        ),
      );
    }
  });

  /// Fire-and-forget version
  void toggleDescriptionExpandedFire() {
    // ignore: discarded_futures
    toggleDescriptionExpanded();
  }

  // ----------------------------------------------------------------------------
  // Attribute Selection (e.g., Color, Size)
  // ----------------------------------------------------------------------------

  /// Gets available attribute options based on selected attributes and variations
  /// This filters options to only show those that are available with current selections
  Map<String, List<String>> _getAvailableAttributeOptions(
    RetrieveProductResponseModel product,
    Map<String, String> selectedAttributes,
  ) {
    final Map<String, List<String>> availableOptions = {};

    // If no variations, return empty map (no filtering needed)
    if (product.variations == null || product.variations!.isEmpty) {
      return availableOptions;
    }

    // Parse variations
    final List<Map<String, dynamic>> variations = [];
    for (final variation in product.variations!) {
      if (variation is Map<String, dynamic>) {
        variations.add(variation);
      }
    }

    // If no valid variations, return empty map
    if (variations.isEmpty) {
      return availableOptions;
    }

    // Get all attribute names from product attributes
    final Map<String, String> attributeNameMap = {}; // name -> taxonomy
    if (product.attributes != null) {
      for (final attr in product.attributes!) {
        if (attr is Map<String, dynamic>) {
          final name = (attr['name'] ?? attr['label'] ?? '').toString();
          final taxonomy = (attr['taxonomy'] ?? attr['id'] ?? '').toString();
          if (name.isNotEmpty) {
            attributeNameMap[name] = taxonomy.isNotEmpty ? taxonomy : name;
          }
        }
      }
    }

    // Find variations that match selected attributes
    final List<Map<String, dynamic>> matchingVariations = [];
    for (final variation in variations) {
      bool matches = true;

      // Check if variation matches all selected attributes
      for (final entry in selectedAttributes.entries) {
        final selectedAttrName = entry.key;
        final selectedAttrValue = entry.value;

        // Get variation attributes
        final variationAttrs = variation['attributes'] as List<dynamic>?;
        if (variationAttrs == null) continue;

        bool foundMatch = false;
        for (final varAttr in variationAttrs) {
          if (varAttr is Map<String, dynamic>) {
            final varAttrName = (varAttr['name'] ?? varAttr['id'] ?? '')
                .toString();
            final varAttrValue = (varAttr['value'] ?? '').toString();

            // Match by name or taxonomy
            if ((varAttrName == selectedAttrName ||
                    varAttrName == attributeNameMap[selectedAttrName]) &&
                varAttrValue == selectedAttrValue) {
              foundMatch = true;
              break;
            }
          }
        }

        if (!foundMatch) {
          matches = false;
          break;
        }
      }

      if (matches) {
        matchingVariations.add(variation);
      }
    }

    // Extract available options for each attribute from matching variations
    for (final variation in matchingVariations) {
      final variationAttrs = variation['attributes'] as List<dynamic>?;
      if (variationAttrs == null) continue;

      for (final varAttr in variationAttrs) {
        if (varAttr is Map<String, dynamic>) {
          final varAttrName = (varAttr['name'] ?? varAttr['id'] ?? '')
              .toString();
          final varAttrValue = (varAttr['value'] ?? '').toString();

          if (varAttrName.isEmpty || varAttrValue.isEmpty) continue;

          // Find the attribute name (might be taxonomy, need to find display name)
          String displayName = varAttrName;
          for (final entry in attributeNameMap.entries) {
            if (entry.value == varAttrName || entry.key == varAttrName) {
              displayName = entry.key;
              break;
            }
          }

          // Add to available options if not already selected
          if (!selectedAttributes.containsKey(displayName) ||
              selectedAttributes[displayName] != varAttrValue) {
            availableOptions
                .putIfAbsent(displayName, () => [])
                .add(varAttrValue);
          }
        }
      }
    }

    // Remove duplicates and sort
    for (final key in availableOptions.keys) {
      availableOptions[key] = availableOptions[key]!.toSet().toList()..sort();
    }

    return availableOptions;
  }

  /// Sets a selected attribute value, e.g. setSelectedAttribute('Color','Red')
  /// Automatically filters available options for other attributes based on variations
  Future<void> setSelectedAttribute(
    String name,
    String value,
  ) async => Future.microtask(() {
    final currentState = state;
    if (currentState is ProductDetailLoadedState) {
      final updated = Map<String, String>.from(currentState.selectedAttributes)
        ..[name] = value;

      // Get available options based on new selection
      final availableOptions = _getAvailableAttributeOptions(
        currentState.product,
        updated,
      );

      // If selecting this attribute makes other attributes invalid, clear them
      // Check if any selected attribute is no longer available
      final Map<String, String> cleanedAttributes = Map.from(updated);
      for (final entry in updated.entries) {
        if (entry.key != name) {
          // Check if this attribute value is still available
          final available = availableOptions[entry.key];
          if (available != null && !available.contains(entry.value)) {
            // This attribute value is no longer valid, clear it
            cleanedAttributes.remove(entry.key);
          }
        }
      }

      emit(currentState.copyWith(selectedAttributes: cleanedAttributes));
    }
  });

  /// Clears a selected attribute
  Future<void> clearSelectedAttribute(String name) async =>
      Future.microtask(() {
        final currentState = state;
        if (currentState is ProductDetailLoadedState) {
          final updated = Map<String, String>.from(
            currentState.selectedAttributes,
          )..remove(name);
          emit(currentState.copyWith(selectedAttributes: updated));
        }
      });

  // ----------------------------------------------------------------------------
  // Attribute Terms Loading
  // ----------------------------------------------------------------------------

  /// Loads attribute terms for a specific attribute ID
  /// Returns list of attribute terms (e.g., color options, size options)
  Future<List<ListProductAttributeTermsResponseModel>> loadAttributeTerms({
    required int attributeId,
    String apiVersion = 'v1',
    int? page,
    int? perPage,
    String? search,
  }) async {
    try {
      debugPrint('🔄 Loading attribute terms for attribute ID: $attributeId');
      final terms = await _attributeTermsService.listProductAttributeTerms(
        apiVersion: apiVersion,
        attributeId: attributeId,
        page: page,
        perPage: perPage,
        search: search,
      );
      debugPrint(
        '✅ Loaded ${terms.length} attribute terms for attribute ID: $attributeId',
      );
      return terms;
    } catch (e) {
      debugPrint(
        '❌ Error loading attribute terms for attribute ID $attributeId: $e',
      );
      rethrow;
    }
  }

  /// Fire-and-forget version
  void loadAttributeTermsFire({
    required int attributeId,
    String apiVersion = 'v1',
    int? page,
    int? perPage,
    String? search,
  }) {
    // ignore: discarded_futures
    loadAttributeTerms(
      attributeId: attributeId,
      apiVersion: apiVersion,
      page: page,
      perPage: perPage,
      search: search,
    );
  }

  /// Retrieves a single attribute term by ID
  Future<ListProductAttributeTermsResponseModel> retrieveAttributeTerm({
    required int attributeId,
    required int termId,
    String apiVersion = 'v1',
  }) async {
    try {
      debugPrint(
        '🔄 Retrieving attribute term ID: $termId for attribute ID: $attributeId',
      );
      final term = await _attributeTermsService.retrieveProductAttributeTerm(
        apiVersion: apiVersion,
        attributeId: attributeId,
        termId: termId,
      );
      debugPrint('✅ Retrieved attribute term: ${term.name} (ID: ${term.id})');
      return term;
    } catch (e) {
      debugPrint(
        '❌ Error retrieving attribute term $termId for attribute $attributeId: $e',
      );
      rethrow;
    }
  }

  // ----------------------------------------------------------------------------
  // Product Attributes Loading
  // ----------------------------------------------------------------------------

  /// Loads all product attributes (e.g., Color, Size, Material)
  /// Returns list of all available attributes in the store
  Future<List<ListProductAttributesResponseModel>> loadProductAttributes({
    String apiVersion = 'v1',
    int? page,
    int? perPage,
    String? search,
    List<int>? exclude,
    List<int>? include,
    int? offset,
    String? order,
    String? orderby,
    bool? hideEmpty,
  }) async {
    try {
      debugPrint('🔄 Loading product attributes');
      final attributes = await _attributesService.listProductAttributes(
        apiVersion: apiVersion,
        page: page,
        perPage: perPage,
        search: search,
        exclude: exclude,
        include: include,
        offset: offset,
        order: order,
        orderby: orderby,
        hideEmpty: hideEmpty,
      );
      debugPrint('✅ Loaded ${attributes.length} product attributes');
      return attributes;
    } catch (e) {
      debugPrint('❌ Error loading product attributes: $e');
      rethrow;
    }
  }

  /// Fire-and-forget version
  void loadProductAttributesFire({
    String apiVersion = 'v1',
    int? page,
    int? perPage,
    String? search,
    List<int>? exclude,
    List<int>? include,
    int? offset,
    String? order,
    String? orderby,
    bool? hideEmpty,
  }) {
    // ignore: discarded_futures
    loadProductAttributes(
      apiVersion: apiVersion,
      page: page,
      perPage: perPage,
      search: search,
      exclude: exclude,
      include: include,
      offset: offset,
      order: order,
      orderby: orderby,
      hideEmpty: hideEmpty,
    );
  }

  /// Retrieves a single product attribute by ID
  Future<RetrieveProductAttributeResponseModel> retrieveProductAttribute({
    required int attributeId,
    String apiVersion = 'v1',
  }) async {
    try {
      debugPrint('🔄 Retrieving product attribute ID: $attributeId');
      final attribute = await _attributesService.retrieveProductAttribute(
        apiVersion: apiVersion,
        attributeId: attributeId,
      );
      debugPrint(
        '✅ Retrieved product attribute: ${attribute.name} (ID: ${attribute.id})',
      );
      return attribute;
    } catch (e) {
      debugPrint('❌ Error retrieving product attribute $attributeId: $e');
      rethrow;
    }
  }

  // Private methods - HydratedCubit pattern
  Future<void> _loadProduct(int productId) async {
    try {
      emit(ProductDetailLoadingState());

      // First try to get selected product from HomeViewModel if available
      // This provides faster loading with cached data
      final homeViewModel = GetIt.I<HomeViewModel>();
      final homeState = homeViewModel.state;

      if (homeState is HomeLoadedState &&
          homeState.selectedProduct != null &&
          homeState.selectedProduct!.id == productId) {
        // Use cached product data for faster loading
        final cachedProduct = homeState.selectedProduct!;
        debugPrint(
          '✅ Using cached product data for faster loading: ${cachedProduct.name}',
        );

        // Convert ListAllProductsResponseModel to RetrieveProductResponseModel
        // For now, we'll just show loading and fetch fresh data
        debugPrint('🔄 Converting cached data and fetching fresh details');
      }

      // Always fetch fresh data from API for complete details
      debugPrint('🔄 Fetching fresh product details from API');
      final product = await _productService.retrieveProduct(
        apiVersion: 'v1',
        productId: productId,
      );

      // Extract image URLs safely
      final imageUrls = <String>[];
      if (product.images != null) {
        for (final img in product.images!) {
          if (img.src != null && img.src!.isNotEmpty) {
            imageUrls.add(img.src!);
          }
        }
      }
      debugPrint(
        '📸 Extracted ${imageUrls.length} image URLs for product: ${product.name}',
      );

      // Check if product is in cart or wishlist
      bool isInCart = false;
      int cartQuantity = 1;

      // Check cart via API
      try {
        final cartResponse = await _cartService.getCart(
          apiVersion: _configHelper.getString(
            'woocommerce_configuration.version',
          ),
          jwtToken: await _getJwtToken(),
        );

        // Find product in cart items
        if (cartResponse.items != null && cartResponse.items!.isNotEmpty) {
          final cartItem = cartResponse.items!.firstWhere(
            (item) => item.id == productId,
            orElse: () => GetCartResponseItem(id: null),
          );

          if (cartItem.id != null) {
            isInCart = true;
            cartQuantity = cartItem.quantity ?? 1;
            _selectedQuantity =
                cartQuantity; // Set selected quantity to cart quantity
          }
        }
      } catch (e) {
        debugPrint('⚠️ Failed to check cart: $e');
        // Continue without cart check - not fatal
      }

      // Check if product is in wishlist
      // Ensure wishlist is loaded before checking
      bool isInWishlist = false;
      try {
        final wishlistViewModel = GetIt.I<WishlistViewModel>();
        final wishlistState = wishlistViewModel.state;

        // If wishlist is not loaded yet, try to sync first
        if (wishlistState is! WishlistLoadedState) {
          debugPrint(
            '💖 ProductDetailViewModel: Wishlist not loaded, syncing...',
          );
          await wishlistViewModel.initial();
        }

        // Now check if product is saved
        isInWishlist = wishlistViewModel.isSaved(productId);
        debugPrint(
          '💖 ProductDetailViewModel: Product $productId isInWishlist: $isInWishlist',
        );
      } catch (e) {
        debugPrint('⚠️ Failed to check wishlist: $e');
        // Continue without wishlist check - not fatal
      }

      // Load product reviews
      List<ListProductReviewsResponseModel> reviews = [];
      try {
        debugPrint('📝 Loading product reviews for product ID: $productId');
        reviews = await _reviewsService.listProductReviews(
          apiVersion: 'v1',
          product: productId,
          perPage: 50,
          status: 'approved', // Only show approved reviews
        );
        debugPrint(
          '✅ Loaded ${reviews.length} reviews for product ID: $productId',
        );
      } catch (e) {
        debugPrint('⚠️ Failed to load product reviews: $e');
        // Continue without reviews - not fatal
      }

      emit(
        ProductDetailLoadedState(
          product: product,
          selectedQuantity: _selectedQuantity,
          imageUrls: imageUrls,
          currentImageIndex: _currentImageIndex,
          isInCart: isInCart,
          reviews: reviews,
          isInWishlist: isInWishlist,
          isDescriptionExpanded: false,
        ),
      );
    } catch (e) {
      final errorMessage = ApiErrorUtils.getErrorMessage(e);
      emit(
        ProductDetailErrorState(
          message: 'Failed to load product: $errorMessage',
        ),
      );
    }
  }

  Future<void> _addToCart(int productId, int quantity) async {
    // Ensure we are in a valid loaded state before proceeding
    if (state is! ProductDetailLoadedState) return;
    final currentState = state as ProductDetailLoadedState;

    try {
      // We could emit a dedicated \"adding to cart\" state here if needed.
      // For now, keep the existing loaded state and proceed with the API call.

      debugPrint(
        '🛒 ProductDetailViewModel: Adding product $productId to cart via API',
      );

      // Get current state to check for selected attributes
      final latestState = state;
      if (latestState is! ProductDetailLoadedState) {
        debugPrint('❌ Invalid state for adding to cart');
        return;
      }

      final product = latestState.product;
      Map<String, String> selectedAttributes = latestState.selectedAttributes;
      debugPrint('🛒 Selected attributes: $selectedAttributes');

      // Validate that all required attributes are selected
      if (product.attributes != null && product.attributes!.isNotEmpty) {
        // Get all attribute names that have options
        final Set<String> requiredAttributes = {};
        for (final attr in product.attributes!) {
          if (attr is Map<String, dynamic>) {
            final name = (attr['name'] ?? attr['label'] ?? '').toString();
            List<String> options = [];
            final rawOptions = attr['options'];
            final rawTerms = attr['terms'];

            if (rawOptions is List && rawOptions.isNotEmpty) {
              options = rawOptions.map((e) => e.toString()).toList();
            } else if (rawTerms is List && rawTerms.isNotEmpty) {
              options = rawTerms
                  .map(
                    (e) => e is Map
                        ? (e['name'] ?? e['value'] ?? '').toString()
                        : e.toString(),
                  )
                  .where((e) => e.isNotEmpty)
                  .toList();
            }

            // If attribute has options, it's required
            if (options.isNotEmpty) {
              requiredAttributes.add(name);
            }
          }
        }

        // Check which attributes are missing
        final Set<String> missingAttributes = requiredAttributes
            .where(
              (attr) =>
                  !selectedAttributes.containsKey(attr) ||
                  selectedAttributes[attr] == null ||
                  selectedAttributes[attr]!.isEmpty,
            )
            .toSet();

        // If there are missing attributes, show snackbar and highlight them
        if (missingAttributes.isNotEmpty) {
          debugPrint('❌ Missing required attributes: $missingAttributes');

          // Emit state with highlighted attributes
          emit(currentState.copyWith(highlightedAttributes: missingAttributes));

          // Reset highlighting after 2 seconds
          Future.delayed(const Duration(seconds: 2), () {
            final currentStateAfterDelay = state;
            if (currentStateAfterDelay is ProductDetailLoadedState) {
              emit(currentStateAfterDelay.copyWith(highlightedAttributes: {}));
            }
          });

          // Return early - don't make API call
          // The snackbar will be shown in the view layer
          return;
        }
      }

      // Try to find matching variation ID first, then build variation array
      int? variationId;
      List<Map<String, String>>? variation;

      if (selectedAttributes.isNotEmpty &&
          product.variations != null &&
          product.variations!.isNotEmpty) {
        // Build attribute mapping for matching
        final Map<String, String> attributeNameToTaxonomy = {};
        if (product.attributes != null) {
          for (final attr in product.attributes!) {
            if (attr is Map<String, dynamic>) {
              final name = (attr['name'] ?? attr['label'] ?? '')
                  .toString()
                  .trim();
              final taxonomy = (attr['taxonomy'] ?? attr['id'] ?? '')
                  .toString()
                  .trim();
              if (name.isNotEmpty) {
                attributeNameToTaxonomy[name] = taxonomy.isNotEmpty
                    ? taxonomy
                    : name;
              }
            }
          }
        }

        // Helper to normalize strings for comparison
        String normalize(String str) => str.trim().toLowerCase();

        // Helper to check if attribute names match
        bool attributeNamesMatch(String name1, String name2) {
          if (normalize(name1) == normalize(name2)) return true;
          final taxonomy1 = attributeNameToTaxonomy[name1] ?? '';
          final taxonomy2 = attributeNameToTaxonomy[name2] ?? '';
          if (taxonomy1.isNotEmpty &&
              taxonomy2.isNotEmpty &&
              normalize(taxonomy1) == normalize(taxonomy2))
            return true;
          if (taxonomy2.isNotEmpty && normalize(name1) == normalize(taxonomy2))
            return true;
          if (taxonomy1.isNotEmpty && normalize(name2) == normalize(taxonomy1))
            return true;
          return false;
        }

        // Helper to check if values match
        bool valuesMatch(String value1, String value2) =>
            normalize(value1) == normalize(value2);

        // Find matching variation by attributes
        final List<Map<String, dynamic>> variations = [];
        for (final v in product.variations!) {
          if (v is Map<String, dynamic>) {
            variations.add(v);
          }
        }

        for (final variationData in variations) {
          final variationAttrs = variationData['attributes'] as List<dynamic>?;
          if (variationAttrs == null) continue;

          bool matchesAll = true;
          for (final entry in selectedAttributes.entries) {
            final selectedAttrName = entry.key;
            final selectedAttrValue = entry.value;

            bool foundMatch = false;
            for (final varAttr in variationAttrs) {
              if (varAttr is Map<String, dynamic>) {
                final varAttrName = (varAttr['name'] ?? varAttr['id'] ?? '')
                    .toString();
                final varAttrValue = (varAttr['value'] ?? '').toString();

                if (attributeNamesMatch(varAttrName, selectedAttrName) &&
                    valuesMatch(varAttrValue, selectedAttrValue)) {
                  foundMatch = true;
                  break;
                }
              }
            }

            if (!foundMatch) {
              matchesAll = false;
              break;
            }
          }

          if (matchesAll) {
            // Found matching variation - get its ID
            final id = variationData['id'];
            if (id != null) {
              variationId = int.tryParse(id.toString());
              debugPrint('🛒 Found matching variation ID: $variationId');
              break;
            }
          }
        }
      }

      // If variation ID not found, build variation array from attributes
      if (variationId == null && selectedAttributes.isNotEmpty) {
        variation = [];
        // Build attribute map: name -> taxonomy
        final Map<String, String> attributeTaxonomyMap = {};
        if (product.attributes != null) {
          for (final attr in product.attributes!) {
            if (attr is Map<String, dynamic>) {
              final name = (attr['name'] ?? attr['label'] ?? '').toString();
              final taxonomy = (attr['taxonomy'] ?? attr['id'] ?? '')
                  .toString();
              if (name.isNotEmpty && taxonomy.isNotEmpty) {
                attributeTaxonomyMap[name] = taxonomy;
              }
            }
          }
        }

        // Convert selectedAttributes to variation format
        for (final entry in selectedAttributes.entries) {
          final attributeName = entry.key;
          final attributeValue = entry.value;

          // Find taxonomy for this attribute name
          String taxonomy =
              attributeTaxonomyMap[attributeName] ?? attributeName;

          // Ensure taxonomy has 'pa_' prefix if it's a product attribute
          if (!taxonomy.startsWith('pa_') &&
              !taxonomy.startsWith('attribute_')) {
            // Try to find matching taxonomy from product attributes
            final matchingAttr = product.attributes?.firstWhere((attr) {
              if (attr is Map<String, dynamic>) {
                final name = (attr['name'] ?? attr['label'] ?? '').toString();
                return name == attributeName;
              }
              return false;
            }, orElse: () => null);

            if (matchingAttr is Map<String, dynamic>) {
              taxonomy =
                  (matchingAttr['taxonomy'] ??
                          matchingAttr['id'] ??
                          attributeName)
                      .toString();
            } else {
              // Fallback: use attribute name with pa_ prefix
              taxonomy =
                  'pa_${attributeName.toLowerCase().replaceAll(' ', '_')}';
            }
          }

          variation.add({'attribute': taxonomy, 'value': attributeValue});
        }

        debugPrint('🛒 Variation array (no ID found): $variation');
      }

      // Ensure we have a cart token; if missing, initialize cart first
      String? cartToken = await _getCartToken();
      if (cartToken == null || cartToken.isEmpty) {
        debugPrint('🛒 No cart token found. Initializing cart via getCart...');
        await _cartService.getCart(
          apiVersion: _configHelper.getString(
            'woocommerce_configuration.version',
          ),
          jwtToken: await _getJwtToken(),
        );
        cartToken = await _getCartToken();
        debugPrint(
          '🛒 Cart token after init: ${cartToken != null && cartToken.isNotEmpty}',
        );
      }

      // Add item to cart via API (first attempt)
      // If variation ID found, use it as the id; otherwise use product ID with variation array
      final itemId = variationId ?? productId;
      final itemVariation = variationId != null
          ? null
          : variation?.cast<dynamic>();

      debugPrint(
        '🛒 Adding to cart: id=$itemId, variationId=$variationId, variation=$itemVariation',
      );

      var response = await _cartService.addItem(
        apiVersion: _configHelper.getString(
          'woocommerce_configuration.version',
        ),
        cartToken: cartToken ?? '',
        jwtToken: await _getJwtToken(), // Optional JWT token
        id: itemId,
        quantity: quantity,
        variation:
            itemVariation, // Only send variation array if variation ID not found
      );

      debugPrint(
        '🛒 ProductDetailViewModel: AddItem API response: ${response.toJson()}',
      );

      if (response.errors != null && response.errors!.isNotEmpty) {
        debugPrint('❌ API add item error: ${response.errors!.first}');
        // If unauthorized or token-related, try to refresh cart and retry once
        final errorText = response.errors!.first.toString().toLowerCase();
        if (errorText.contains('401') ||
            errorText.contains('unauthorized') ||
            errorText.contains('token')) {
          debugPrint('🛒 Retrying addItem after refreshing cart token...');
          await _cartService.getCart(
            apiVersion: _configHelper.getString(
              'woocommerce_configuration.version',
            ),
            jwtToken: await _getJwtToken(),
          );
          final refreshedToken = await _getCartToken();
          response = await _cartService.addItem(
            apiVersion: _configHelper.getString(
              'woocommerce_configuration.version',
            ),
            cartToken: refreshedToken ?? '',
            jwtToken: await _getJwtToken(),
            id: itemId,
            quantity: quantity,
            variation:
                itemVariation, // Only send variation array if variation ID not found
          );

          if (response.errors != null && response.errors!.isNotEmpty) {
            // Keep current state if it's a loaded state
            final currentStateForError = state;
            final errorMessage = ApiErrorUtils.getErrorMessage(
              response.errors!.first,
            );
            emit(
              ProductDetailErrorState(
                message: 'Failed to add item: $errorMessage',
                previousState: currentStateForError is ProductDetailLoadedState
                    ? currentStateForError
                    : null,
              ),
            );
            return;
          }
        } else {
          // Keep current state if it's a loaded state
          final currentStateForError = state;
          final errorMessage = ApiErrorUtils.getErrorMessage(
            response.errors!.first,
          );
          emit(
            ProductDetailErrorState(
              message: 'Failed to add item: $errorMessage',
              previousState: currentStateForError is ProductDetailLoadedState
                  ? currentStateForError
                  : null,
            ),
          );
          return;
        }
      }

      // Cart token is automatically handled by WooCartTokenInterceptor
      // No need to manually save token - interceptor extracts from response headers

      debugPrint('✅ Successfully added product $productId to cart via API');

      // Check actual cart quantity after add (API may have merged quantities if item already exists)
      int finalQuantity = quantity;
      try {
        final cartResponse = await _cartService.getCart(
          apiVersion: _configHelper.getString(
            'woocommerce_configuration.version',
          ),
          jwtToken: await _getJwtToken(),
        );

        // Find actual quantity in cart after add
        if (cartResponse.items != null && cartResponse.items!.isNotEmpty) {
          final cartItem = cartResponse.items!.firstWhere(
            (item) => item.id == productId,
            orElse: () => GetCartResponseItem(id: null),
          );

          if (cartItem.id != null) {
            finalQuantity = cartItem.quantity ?? quantity;
          }
        }
      } catch (e) {
        debugPrint('⚠️ Failed to check final cart quantity: $e');
        // Use original quantity if check fails
      }

      // Update state to show product is in cart and update quantity
      // Also set flag to show add to cart popup
      final finalState = state;
      if (finalState is ProductDetailLoadedState) {
        emit(
          finalState.copyWith(
            isInCart: true,
            selectedQuantity: finalQuantity, // Update to actual cart quantity
            shouldShowAddToCartPopup: true, // Trigger bottom sheet
          ),
        );
        _selectedQuantity = finalQuantity;
      }
    } catch (e) {
      debugPrint('❌ Failed to add to cart: $e');
      // Keep current state if it's a loaded state
      final currentStateForError = state;
      final errorMessage = ApiErrorUtils.getErrorMessage(e);
      emit(
        ProductDetailErrorState(
          message: 'Failed to add to cart: $errorMessage',
          previousState: currentStateForError is ProductDetailLoadedState
              ? currentStateForError
              : null,
        ),
      );
    }
  }

  Future<void> _addToWishlist(int productId) async {
    try {
      final currentState = state;
      if (currentState is! ProductDetailLoadedState) return;

      // Get WishlistViewModel from GetIt
      final wishlistViewModel = GetIt.I<WishlistViewModel>();
      
      // Import WishlistLocalHelper
      final localHelper = WishlistLocalHelper();

      // Check if product is already in wishlist (check local first, then viewmodel)
      final isInLocalWishlist = await localHelper.isInWishlist(productId);
      final isCurrentlyInWishlist = isInLocalWishlist || wishlistViewModel.isSaved(productId);
      final wasInWishlist = isCurrentlyInWishlist;

      debugPrint(
        '💖 ProductDetailViewModel: Toggling wishlist for product $productId (currently: $isCurrentlyInWishlist)',
      );

      // STEP 1: Update local storage immediately (optimistic update)
      if (wasInWishlist) {
        // Remove from local
        await localHelper.removeFromLocalWishlist(productId);
      } else {
        // Add to local
        await localHelper.addToLocalWishlist(productId);
      }

      // Update UI immediately based on local state
      final isNowInWishlistLocal = !wasInWishlist;
      emit(currentState.copyWith(isInWishlist: isNowInWishlistLocal));

      // Get product details from current state
      final product = currentState.product;

      // Extract image URL
      String? imageUrl;
      if (product.images != null && product.images!.isNotEmpty) {
        imageUrl = product.images!.first.src;
      }

      // Extract prices
      final prices = product.prices;
      final regularPrice = prices?.regularPrice ?? prices?.price;
      final salePrice = product.onSale == true ? prices?.salePrice : null;
      final currencyCode = prices?.currencyCode;

      // Create WishlistItem from product (using states.dart model)
      final wishlistItem = WishlistItem(
        id: productId,
        name: product.name,
        imageUrl: imageUrl,
        regularPrice: regularPrice,
        salePrice: salePrice,
        currencyCode: currencyCode,
        currencyDecimalSeparator: prices?.currencyDecimalSeparator,
        currencyThousandSeparator: prices?.currencyThousandSeparator,
        currencyMinorUnit: prices?.currencyMinorUnit,
        onSale: product.onSale == true,
      );

      // STEP 2: Sync with API in background (non-blocking)
      // Toggle wishlist using WishlistViewModel (add or remove) - this will sync with API
      wishlistViewModel.toggle(wishlistItem).then((_) {
        // Mark as synced in local storage after successful API call
        if (wasInWishlist) {
          localHelper.markRemoveAsSynced(productId);
        } else {
          localHelper.markAddAsSynced(productId);
        }
      }).catchError((e) {
        debugPrint('⚠️ ProductDetailViewModel: API sync failed, but local state updated: $e');
        // Local state is already updated, so UI remains consistent
      });

      debugPrint(
        '✅ ProductDetailViewModel: Wishlist toggled locally - now: $isNowInWishlistLocal (API sync in background)',
      );

      // Show success message
      emit(
        ProductDetailSuccessState(
          message: wasInWishlist
              ? 'Product removed from wishlist'
              : 'Product added to wishlist successfully!',
          previousState: currentState.copyWith(isInWishlist: isNowInWishlistLocal),
        ),
      );
    } catch (e) {
      debugPrint('❌ ProductDetailViewModel: Failed to toggle wishlist: $e');
      final errorMessage = ApiErrorUtils.getErrorMessage(e);
      emit(
        ProductDetailErrorState(
          message: 'Failed to toggle wishlist: $errorMessage',
        ),
      );
    }
  }

  void _changeQuantity(int quantity) {
    try {
      final currentState = state;
      if (currentState is! ProductDetailLoadedState) return;

      _selectedQuantity = quantity;
      emit(currentState.copyWith(selectedQuantity: _selectedQuantity));

      // If product is in cart, update quantity via API immediately
      // This ensures cart quantity is synced with counter in real-time
      if (currentState.isInCart) {
        _updateCartQuantity(currentState.product.id ?? 0, quantity);
      }
      // If not in cart, just update local quantity (will be used when Add to Cart is clicked)
    } catch (e) {
      debugPrint('❌ Failed to change quantity: $e');
      final errorMessage = ApiErrorUtils.getErrorMessage(e);
      emit(
        ProductDetailErrorState(
          message: 'Failed to change quantity: $errorMessage',
        ),
      );
    }
  }

  /// Updates cart item quantity via API
  Future<void> _updateCartQuantity(int productId, int quantity) async {
    try {
      final currentState = state;
      if (currentState is! ProductDetailLoadedState) return;

      // Get cart token and JWT token
      String? cartToken = await _getCartToken();
      if (cartToken == null || cartToken.isEmpty) {
        debugPrint('⚠️ No cart token available for quantity update');
        return;
      }

      // Get cart to find item key
      final cartResponse = await _cartService.getCart(
        apiVersion: _configHelper.getString(
          'woocommerce_configuration.version',
        ),
        jwtToken: await _getJwtToken(),
      );

      // Find item key for this product
      String? itemKey;
      if (cartResponse.items != null) {
        final cartItem = cartResponse.items!.firstWhere(
          (item) => item.id == productId,
          orElse: () => GetCartResponseItem(id: null),
        );
        if (cartItem.id != null) {
          itemKey = cartItem.key;
        }
      }

      if (itemKey == null) {
        debugPrint('⚠️ Item key not found for product $productId');
        return;
      }

      // Update item quantity via API
      final response = await _cartService.updateItem(
        apiVersion: _configHelper.getString(
          'woocommerce_configuration.version',
        ),
        cartToken: cartToken,
        jwtToken: await _getJwtToken(),
        key: itemKey,
        quantity: quantity,
      );

      if (response.errors != null && response.errors!.isNotEmpty) {
        debugPrint('❌ API update item error: ${response.errors!.first}');
        return;
      }

      debugPrint('✅ Successfully updated cart quantity to $quantity');
    } catch (e) {
      debugPrint('❌ Failed to update cart quantity: $e');
      // Don't emit error state - just log it
    }
  }

  void _loadImages(List<String> imageUrls) {
    try {
      final currentState = state;
      if (currentState is! ProductDetailLoadedState) return;

      _imageUrls = imageUrls;
      emit(currentState.copyWith(imageUrls: _imageUrls));
    } catch (e) {
      debugPrint('❌ Failed to load images: $e');
      final errorMessage = ApiErrorUtils.getErrorMessage(e);
      emit(
        ProductDetailErrorState(
          message: 'Failed to load images: $errorMessage',
        ),
      );
    }
  }

  @override
  ProductDetailState? fromJson(Map<String, dynamic> json) {
    return null; // State will be reconstructed from API
  }

  @override
  Map<String, dynamic>? toJson(ProductDetailState state) {
    return null; // No need to persist product detail state
  }

  /// Gets cart token from arguments (route params) or storage
  /// Priority: arguments > storage
  /// Interceptor automatically adds token to request headers,
  /// but ViewModel needs token for direct API calls
  Future<String?> _getCartToken() async {
    try {
      // First try to get from arguments (route params)
      final argsToken = _arguments['cartToken'] as String?;
      if (argsToken != null && argsToken.isNotEmpty) {
        debugPrint('🛒 ProductDetailViewModel: Cart token from arguments');
        return argsToken;
      }

      // Fallback to storage
      final wooCartToken = await WooCartTokenStorage.loadCartToken();

      if (wooCartToken != null && wooCartToken.cartToken.isNotEmpty) {
        // Check if token has expired
        if (wooCartToken.expiresAt != null &&
            DateTime.now().isAfter(wooCartToken.expiresAt!)) {
          debugPrint('⚠️ Cart token has expired');
          await WooCartTokenStorage.clearCartToken();
          return null;
        }

        debugPrint(
          '🛒 ProductDetailViewModel: Cart token from storage: ${wooCartToken.cartToken.length > 20 ? "${wooCartToken.cartToken.substring(0, 20)}..." : wooCartToken.cartToken}',
        );
        return wooCartToken.cartToken;
      }

      debugPrint('⚠️ ProductDetailViewModel: No cart token found');
      return null;
    } catch (e) {
      debugPrint('❌ Failed to get cart token: $e');
      return null;
    }
  }

  /// Gets cart token for navigation - public method
  /// Returns token from arguments or storage
  Future<String?> getCartTokenForNavigation() async {
    return await _getCartToken();
  }

  /// Gets JWT token from storage
  Future<String?> _getJwtToken() async {
    try {
      final authStorage = AuthStorageHelper();
      return await authStorage.getToken();
    } catch (e) {
      debugPrint('❌ Failed to get JWT token: $e');
      return null;
    }
  }
}
