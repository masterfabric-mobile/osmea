import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:apis/network/remote/woocommerce/wishlist/abstract/woo_wishlist_service.dart';
import 'package:apis/network/remote/woocommerce/wishlist/freezed_model/request/add_wishlist_item_request.dart';
import 'package:apis/network/remote/woocommerce/store_api/cart_api/abstract/cart_service.dart';
import 'package:apis/network/remote/woocommerce/wishlist/freezed_model/request/delete_wishlist_item_request.dart';
import 'package:apis/network/remote/woocommerce/wishlist/freezed_model/response/wishlist_item_response.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_api/abstract/product_service.dart';
import 'package:apis/models/cart/woo_cart_token.dart';
import 'package:storefront_woo/app/views/view_wishlist/models/module/states.dart';

/// Hydrated wishlist view model that also syncs with Woo Wishlist API
/// Injectable - registered as singleton in config_di.dart to ensure single instance
@injectable
class WishlistViewModel extends BaseViewModelHydratedCubit<WishlistState> {
  WishlistViewModel() : super(WishlistInitialState());

  // Dependencies (resolved via DI)
  final WooWishlistService _wishlistService = GetIt.I<WooWishlistService>();
  final ProductService _productService = GetIt.I<ProductService>();
  final CartService _cartService = GetIt.I<CartService>();
  final AssetConfigHelper _config = AssetConfigHelper();

  // Optional route/view arguments holder (to align with other views)
  final Map<String, dynamic> _arguments = {};
  void setArguments(Map<String, dynamic> args) {
    _arguments
      ..clear()
      ..addAll(args);
  }

  Map<String, dynamic> get arguments => Map.unmodifiable(_arguments);

  // Hydrated storage key
  @override
  String get id => 'wishlist_view_model_v1';

  // Selectors
  List<int> get savedIds {
    final s = state;
    return s is WishlistLoadedState
        ? s.items.map((e) => e.id).toList(growable: false)
        : const <int>[];
  }

  bool isSaved(int productId) {
    final s = state;
    return s is WishlistLoadedState
        ? s.items.any((e) => e.id == productId)
        : false;
  }

  int get count => state is WishlistLoadedState
      ? (state as WishlistLoadedState).items.length
      : 0;

  // Public triggers (OSMEA style)
  Future<void> initial() => _syncFromServer();
  Future<void> syncFromServer({int? groupId}) =>
      _syncFromServer(groupId: groupId);
  Future<void> toggle(WishlistItem item, {int? groupId}) =>
      _toggle(item, groupId: groupId);
  Future<void> add(WishlistItem item, {int? groupId}) =>
      _add(item, groupId: groupId);
  Future<void> remove(int productId, {int? groupId}) =>
      _remove(productId, groupId: groupId);
  Future<void> addItemToCartFromWishlist(int productId) =>
      _addItemToCartFromWishlist(productId);
  
  /// Adds item to cart and then removes it from wishlist
  Future<void> addItemToCartAndRemoveFromWishlist(int productId) async {
    try {
      debugPrint('🛒 WishlistViewModel: Starting add to cart and remove from wishlist for product $productId');
      
      // Store the current wishlist items before any operation
      final currentState = state;
      final currentItems = currentState is WishlistLoadedState 
          ? List<WishlistItem>.from(currentState.items)
          : <WishlistItem>[];
      
      debugPrint('💾 WishlistViewModel: Stored ${currentItems.length} items before operations');
      
      // First add to cart - but don't rely on state changes for flow control
      bool cartSuccess = false;
      try {
        await _addItemToCartFromWishlist(productId);
        cartSuccess = true;
        debugPrint('✅ WishlistViewModel: Cart addition completed successfully');
      } catch (e) {
        debugPrint('❌ WishlistViewModel: Cart addition failed: $e');
        // Don't proceed with removal if cart addition failed
        return;
      }
      
      // If cart addition was successful, remove from wishlist
      if (cartSuccess) {
        debugPrint('🗑️ WishlistViewModel: Starting removal from wishlist');
        
        // Remove the item manually from local state without server sync
        final updatedItems = currentItems.where((item) => item.id != productId).toList();
        debugPrint('📝 WishlistViewModel: Updated items count: ${updatedItems.length} (removed product $productId)');
        
        // Emit the updated state immediately
        emit(WishlistLoadedState(items: updatedItems));
        
        // Optionally try to remove from server in background (don't await)
        _removeFromServerInBackground(productId);
        
        debugPrint('✅ WishlistViewModel: Add to cart and remove from wishlist completed');
      }
    } catch (e) {
      debugPrint('❌ Failed to add to cart and remove from wishlist: $e');
      emit(WishlistErrorState(message: 'Failed to complete operation: $e'));
    }
  }
  
  /// Remove item from server in background without affecting UI state
  Future<void> _removeFromServerInBackground(int productId) async {
    try {
      final jwt = await _getJwtToken();
      if (jwt == null || jwt.isEmpty) {
        debugPrint('💡 Background remove: Not authenticated, skipping server removal');
        return;
      }
      
      final apiVersion = _config.getString('woocommerce_configuration.version', 'v1');
      
      // Create the request object
      final request = DeleteWishlistItemRequest(
        productId: productId,
        groupId: 0, // Default group for most implementations
      );
      
      // Try to remove from server without affecting UI state
      final response = await _wishlistService.deleteItemByProduct(
        apiVersion: apiVersion,
        request: request,
      );
      
      debugPrint('🔄 Background remove: Server removal response - success: ${response.success}');
    } catch (e) {
      debugPrint('⚠️ Background remove: Server removal failed: $e (UI state not affected)');
    }
  }
  void promptAddToCartOptions(WishlistItem item) =>
      _promptAddToCartOptions(item);
  void restorePrevious(WishlistLoadedState prev) {
    debugPrint('🔄 WishlistViewModel: Restoring previous state with ${prev.items.length} items');
    emit(prev);
  }

  /// Clear all wishlist items (used when user signs out)
  void clearAll() {
    debugPrint('💖 Wishlist: Clearing all items (sign out)');
    emit(WishlistLoadedState(items: const []));
  }

  /// Sync local wishlist items to server after successful login
  /// This method should be called after user authentication to merge local and server wishlists
  Future<void> syncLocalItemsAfterLogin() async {
    try {
      final currentState = state;

      // Get local items from current state
      List<WishlistItem> localItems = [];
      if (currentState is WishlistLoadedState &&
          currentState.items.isNotEmpty) {
        localItems = currentState.items;
      }

      if (localItems.isEmpty) {
        debugPrint('💡 No local wishlist items to sync');
        // Still sync from server to get server wishlist
        await syncFromServer();
        return;
      }

      debugPrint(
        '💖 Syncing ${localItems.length} local wishlist items to server after login...',
      );

      // Sync each local item to server using add() method
      // This will handle both authenticated and unauthenticated cases
      for (final item in localItems) {
        try {
          // Use add() method which handles authentication check internally
          // If authenticated, it will add to server
          // If not authenticated, it will add to local state only
          await add(item);
          debugPrint('💖 Synced wishlist item: ${item.id} - ${item.name}');
        } catch (e) {
          debugPrint('⚠️ Failed to sync wishlist item ${item.id}: $e');
          // Continue with other items even if one fails
        }
      }

      // After syncing all items, sync from server to get merged state
      // This ensures we have the latest state from server (including itemId values)
      await syncFromServer();
      debugPrint('✅ Local wishlist synced to server successfully');
    } catch (e) {
      debugPrint('⚠️ Error syncing wishlist after login: $e');
      // Don't block login if wishlist sync fails
      // Try to sync from server anyway to get server state
      try {
        await syncFromServer();
      } catch (e2) {
        debugPrint('⚠️ Failed to sync from server after error: $e2');
      }
    }
  }

  // Private implementations
  Future<void> _syncFromServer({int? groupId}) async {
    try {
      // If not authenticated, keep local (hydrated) state without erroring
      final jwt = await _getJwtToken();
      if (jwt == null || jwt.isEmpty) {
        debugPrint('💡 Wishlist: Not authenticated, using local state');
        final s = state;
        if (s is WishlistLoadedState) {
          // Keep existing state
          emit(WishlistLoadedState(items: s.items));
        } else if (s is WishlistInitialState) {
          // If initial state, try to restore from persisted state
          // HydratedCubit should handle this, but ensure we have loaded state
          emit(WishlistLoadedState(items: const []));
        } else {
          // For any other state (error, etc.), ensure we have loaded state
          emit(WishlistLoadedState(items: const []));
        }
        return;
      }

      emit(WishlistLoadingState());
      debugPrint('💖 Wishlist: Starting sync from server...');
      final apiVersion = _config.getString(
        'woocommerce_configuration.version',
        'v1',
      );

      debugPrint('💖 Wishlist: Fetching wishlist items from server...');

      // Use service to fetch wishlist items
      List<WishlistItemResponse> items = [];

      try {
        final paged = await _wishlistService.getWishlistItems(
          apiVersion: apiVersion,
          groupId: groupId,
          page: 1,
          perPage: 100,
        );

        // Service parsed successfully - check if data exists
        // Support both API format (items) and legacy format (data)
        if (paged.items != null && paged.items!.isNotEmpty) {
          debugPrint(
            '💖 Wishlist: Using API format response (${paged.items!.length} items)',
          );
          items = paged.items!;
        } else if (paged.data != null && paged.data!.isNotEmpty) {
          debugPrint(
            '💖 Wishlist: Using legacy format response (${paged.data!.length} items)',
          );
          items = paged.data!;
        } else {
          debugPrint('💡 Wishlist: Service response has no data');
        }
      } catch (e) {
        debugPrint('❌ Wishlist: Service call failed: $e');
        emit(
          WishlistErrorState(
            message: 'Failed to load saved items: ${e.toString()}',
          ),
        );
        return;
      }

      if (items.isEmpty) {
        debugPrint('💡 Wishlist: No items found');
        emit(WishlistLoadedState(items: const []));
        return;
      }

      // Map WishlistItemResponse to WishlistItem for UI
      final mapped = <WishlistItem>[];

      for (final itemResponse in items) {
        try {
          final itemId = itemResponse.id;
          final productId = itemResponse.productId;

        if (productId == null || productId == 0) {
          debugPrint(
            '⚠️ Wishlist: Skipping item with invalid productId: ${itemResponse.id}',
          );
          continue;
        }

        // Get fields from response (supports both API format and legacy format)
        // API format: name, price, image
        // Legacy format: product_name, product_price, product_image
        // Helper function to safely convert dynamic to String?
        String? safeStringFromResponse(dynamic value) {
          if (value == null) return null;
          if (value is String) return value;
          if (value is bool) return value.toString();
          if (value is num) return value.toString();
          return value.toString();
        }

        final name =
            safeStringFromResponse(itemResponse.name) ??
            safeStringFromResponse(itemResponse.productName);
        final price =
            safeStringFromResponse(itemResponse.price) ??
            safeStringFromResponse(itemResponse.productPrice);
        final image =
            safeStringFromResponse(itemResponse.image) ??
            safeStringFromResponse(itemResponse.productImage);

        debugPrint(
          '💖 Wishlist: Parsing item - id: $itemId, productId: $productId, name: $name, price: $price',
        );

          // Try to fetch full product details for currency code and proper pricing
          try {
            debugPrint(
              '💖 Wishlist: Fetching product details for productId: $productId',
            );
            final product = await _productService.retrieveProduct(
              apiVersion: apiVersion,
              productId: productId,
            );

            debugPrint(
              '💖 Wishlist: Product fetched - name: ${product.name}, prices: ${product.prices?.toJson()}',
            );

            // Use product details from ProductService when available
            final prices = product.prices;
            final imageUrl = product.images?.isNotEmpty == true
                ? product.images!.first.src
                : image;

            final productName = product.name ?? name ?? 'Product';
            final productPrice = prices?.regularPrice ?? 
                                 prices?.price ?? 
                                 price ?? 
                                 '0.00';

            debugPrint(
              '💖 Wishlist: Creating WishlistItem - name: $productName, price: $productPrice',
            );

            mapped.add(
              WishlistItem(
                id: productId,
                itemId: itemId,
                name: productName,
                imageUrl: imageUrl,
                regularPrice: productPrice,
                salePrice: product.onSale == true ? prices?.salePrice : null,
                currencyCode: prices?.currencyCode,
                currencyDecimalSeparator: prices?.currencyDecimalSeparator,
                currencyThousandSeparator: prices?.currencyThousandSeparator,
                currencyMinorUnit: prices?.currencyMinorUnit,
                onSale: product.onSale ?? false,
              ),
            );
          } catch (e, stackTrace) {
            debugPrint(
              '⚠️ Wishlist: Failed to fetch product $productId, using API response data: $e',
            );
            debugPrint('⚠️ Stack trace: $stackTrace');
            
            // Fallback: use wishlist API response data directly
            // Ensure we have at least some data
            final fallbackName = name ?? 'Product';
            final fallbackPrice = price ?? '0.00';
            
            debugPrint(
              '💖 Wishlist: Using fallback data - name: $fallbackName, price: $fallbackPrice',
            );
            
            mapped.add(
              WishlistItem(
                id: productId,
                itemId: itemId,
                name: fallbackName,
                imageUrl: image,
                regularPrice: fallbackPrice,
                salePrice: null,
                currencyCode: null,
                onSale: false,
              ),
            );
          }
        } catch (e) {
          debugPrint('❌ Wishlist: Error parsing item: $e');
          // Continue with next item
          continue;
        }
      }

      emit(WishlistLoadedState(items: mapped));
      debugPrint('✅ Wishlist: Loaded ${mapped.length} items from API');
    } catch (e, stackTrace) {
      debugPrint('❌ Wishlist sync error: $e');
      debugPrint('❌ Wishlist sync error stack trace: $stackTrace');

      // Don't leave in error state - try to restore from persisted state or use empty
      final currentState = state;
      if (currentState is WishlistLoadedState) {
        // Keep existing state if available
        debugPrint('💡 Wishlist: Sync failed, keeping existing state');
        emit(WishlistLoadedState(items: currentState.items));
      } else {
        // If no existing state, emit empty loaded state (not error state)
        // This ensures UI can still function
        debugPrint('💡 Wishlist: Sync failed, using empty state');
        emit(WishlistLoadedState(items: const []));
      }
    }
  }

  Future<void> _toggle(WishlistItem item, {int? groupId}) async {
    final exists = isSaved(item.id);
    if (exists) {
      await _remove(item.id, groupId: groupId);
    } else {
      await _add(item, groupId: groupId);
    }
  }

  Future<void> _add(WishlistItem item, {int? groupId}) async {
    try {
      // Sync with server only if authenticated
      final jwt = await _getJwtToken();
      if (jwt == null || jwt.isEmpty) {
        debugPrint('💡 Wishlist: unauthenticated add -> local only');
        // Add to local state for unauthenticated users
        final s = state;
        final items = s is WishlistLoadedState ? [...s.items, item] : [item];
        emit(WishlistLoadedState(items: items));
        debugPrint('✅ Wishlist: Item added to local state (unauthenticated)');
        return;
      }

      // IMPORTANT: First sync from server to get current state
      // This prevents 400 errors when item already exists on server
      debugPrint('💖 Wishlist: Syncing from server before adding item...');
      await _syncFromServer(groupId: groupId);

      // Check if item is already in state after sync
      final currentState = state;
      if (currentState is WishlistLoadedState) {
        final alreadyExists = currentState.items.any((w) => w.id == item.id);
        if (alreadyExists) {
          debugPrint(
            '💡 Wishlist: Item already exists on server, skipping add...',
          );
          return;
        }
      } else {
        // If state is not loaded after sync, ensure we have at least an empty loaded state
        debugPrint(
          '⚠️ Wishlist: State not loaded after sync, ensuring loaded state...',
        );
        if (currentState is! WishlistLoadedState) {
          emit(WishlistLoadedState(items: const []));
        }
      }

      final apiVersion = _config.getString(
        'woocommerce_configuration.version',
        'v1',
      );

      // Call API to add item
      final response = await _wishlistService.addItemToWishlist(
        apiVersion: apiVersion,
        request: AddWishlistItemRequest(
          productId: item.id,
          groupId: groupId ?? 0,
          quantity: 1, // Default quantity is 1 for wishlist items
        ),
      );

      debugPrint(
        '💖 Wishlist API response: success=${response.success}, message=${response.message}',
      );

      // Check if item was already in wishlist (from API response)
      final message = response.message?.toLowerCase() ?? '';
      final isAlreadyInWishlist =
          message.contains('already in wishlist') ||
          message.contains('already exists') ||
          message.contains('already added') ||
          message.contains('400') ||
          message.contains('bad request');

      if (isAlreadyInWishlist || response.success != true) {
        debugPrint(
          '💡 Wishlist: Product already in wishlist or add failed, syncing from server...',
        );
        // Product already exists on server or add failed, sync from server to get updated state
        await _syncFromServer(groupId: groupId);
        return;
      }

      // If successful, sync from server to get the complete updated state
      if (response.success == true) {
        debugPrint(
          '✅ Wishlist: Item added successfully, syncing from server...',
        );
        // Always sync from server after successful add to ensure state consistency
        await _syncFromServer(groupId: groupId);
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Wishlist add error: $e');
      debugPrint('❌ Wishlist add error stack trace: $stackTrace');

      // Check if it's a 400 error (duplicate)
      final errorString = e.toString().toLowerCase();
      if (errorString.contains('400') ||
          errorString.contains('bad request') ||
          errorString.contains('already') ||
          errorString.contains('duplicate')) {
        debugPrint(
          '💡 Wishlist: 400 error detected (likely duplicate), syncing from server...',
        );
        try {
          await _syncFromServer(groupId: groupId);
          return;
        } catch (syncError) {
          debugPrint('❌ Wishlist sync error after 400: $syncError');
        }
      }

      // On other errors, sync from server to get accurate state
      try {
        await _syncFromServer(groupId: groupId);
      } catch (syncError) {
        debugPrint('❌ Wishlist sync error after add failure: $syncError');
        // If sync fails, add to local state as fallback
        final cur = state;
        if (cur is WishlistLoadedState) {
          // Check if item is already in state
          if (!cur.items.any((w) => w.id == item.id)) {
            debugPrint('💡 Wishlist: Adding item to local state as fallback');
            final items = [...cur.items, item];
            emit(WishlistLoadedState(items: items));
          }
        } else {
          // If state is not loaded, create new state with item
          emit(WishlistLoadedState(items: [item]));
        }
      }
    }
  }

  Future<void> _remove(int productId, {int? groupId}) async {
    try {
      final jwt = await _getJwtToken();
      if (jwt == null || jwt.isEmpty) {
        debugPrint('💡 Wishlist: unauthenticated remove -> local only');
        // Remove from local state for unauthenticated users
        final s = state;
        final items = s is WishlistLoadedState
            ? s.items.where((e) => e.id != productId).toList()
            : const <WishlistItem>[];
        emit(WishlistLoadedState(items: items));
        return;
      }

      // Find the item to get itemId if available
      final s = state;
      WishlistItem? itemToRemove;
      if (s is WishlistLoadedState) {
        itemToRemove = s.items.firstWhere(
          (e) => e.id == productId,
          orElse: () => WishlistItem(id: productId),
        );
      }

      // Update local state optimistically (UI updates immediately)
      final items = s is WishlistLoadedState
          ? s.items.where((e) => e.id != productId).toList()
          : const <WishlistItem>[];
      emit(WishlistLoadedState(items: items));

      final apiVersion = _config.getString(
        'woocommerce_configuration.version',
        'v1',
      );

      // Try DELETE by itemId first (preferred method as per API explorer)
      bool deleteSuccess = false;
      if (itemToRemove?.itemId != null) {
        try {
          debugPrint(
            '💖 Wishlist: Deleting by itemId: ${itemToRemove!.itemId}',
          );
          final response = await _wishlistService.deleteItemById(
            apiVersion: apiVersion,
            itemId: itemToRemove.itemId!,
          );

          debugPrint(
            '💖 Wishlist remove API response (by ID): success=${response.success}, message=${response.message}',
          );

          if (response.success == true) {
            deleteSuccess = true;
            debugPrint('✅ Wishlist: Item removed successfully by ID');
            // Optimistic update is already correct, no need to sync
            // This prevents unnecessary rebuilds
            return;
          }
        } catch (e) {
          debugPrint('❌ Wishlist: deleteItemById failed: $e');
          // Fall through to try deleteItemByProduct
        }
      }

      // If deleteItemById didn't work, try deleteItemByProduct
      if (!deleteSuccess) {
        try {
          debugPrint(
            '💖 Wishlist: Deleting by productId: $productId, groupId: ${groupId ?? 0}',
          );
          final response = await _wishlistService.deleteItemByProduct(
            apiVersion: apiVersion,
            request: DeleteWishlistItemRequest(
              productId: productId,
              groupId: groupId ?? 0,
            ),
          );

          debugPrint(
            '💖 Wishlist remove API response (by product): success=${response.success}, message=${response.message}',
          );

          if (response.success == true) {
            deleteSuccess = true;
            debugPrint('✅ Wishlist: Item removed successfully by product');
            // Optimistic update is already correct, no need to sync
            // Background sync only if needed (e.g., for itemId updates)
            return;
          } else {
            // If delete failed, don't sync - keep optimistic update
            debugPrint('⚠️ Wishlist: Delete by itemId failed, but keeping optimistic removal');
            return;
          }
        } catch (e) {
          debugPrint('❌ Wishlist: deleteItemByProduct failed: $e');
          // Check if it's a 404 error (item not found on server)
          if (e.toString().contains('404') ||
              e.toString().contains('Not Found')) {
            debugPrint(
              '💡 Wishlist: Item not found on server (404) - optimistic update was correct',
            );
            // Optimistic update was correct, no need to sync
            return;
          }
          // For other errors, keep optimistic update - don't sync to avoid clearing list
          debugPrint('⚠️ Wishlist: Delete failed with error, but keeping optimistic removal');
          return;
        }
      }
    } catch (e) {
      debugPrint('❌ Wishlist remove error: $e');
      // On error, keep optimistic update instead of syncing to avoid clearing list
      debugPrint('💡 Wishlist: Remove error occurred, but keeping optimistic removal');
      // Don't sync from server as it might clear the entire list
    }
  }

  Future<void> _addItemToCartFromWishlist(int productId) async {
    try {
      debugPrint('🛒 WishlistViewModel: Starting add to cart for product $productId');
      
      // Store current state before cart operation
      final beforeCartState = state;
      final beforeCartItems = beforeCartState is WishlistLoadedState 
          ? beforeCartState.items.length 
          : 0;
      debugPrint('📊 WishlistViewModel: Before cart - Wishlist has $beforeCartItems items');

      // First, check if product is variable and get first variation if needed
      int? variationId;
      try {
        final product = await _productService.retrieveProduct(
          apiVersion: _config.getString(
            'woocommerce_configuration.version',
            'v1',
          ),
          productId: productId,
        );

        // Check if product is variable and has variations
        if (product.type == 'variable' && 
            product.variations != null && 
            product.variations!.isNotEmpty) {
          // Get first variation ID
          final firstVariation = product.variations!.first;
          if (firstVariation is Map<String, dynamic>) {
            final id = firstVariation['id'];
            if (id != null) {
              variationId = int.tryParse(id.toString());
              debugPrint('🛒 Found first variation ID: $variationId for variable product');
            }
          }
        }
      } catch (e) {
        debugPrint('⚠️ Could not fetch product details, proceeding with product ID: $e');
      }

      // Add item to cart via API directly (like HomeViewModel)
      // Use variation ID if found, otherwise use product ID
      final response = await _cartService.addItem(
        apiVersion: _config.getString(
          'woocommerce_configuration.version',
          'v1',
        ),
        cartToken: await _getCartToken() ?? '',
        jwtToken: await _getJwtToken(), // Optional JWT token
        id: variationId ?? productId,
        quantity: 1,
      );

      debugPrint(
        '🛒 WishlistViewModel: AddItem API response: ${response.toJson()}',
      );

      if (response.errors != null && response.errors!.isNotEmpty) {
        debugPrint('❌ API add item error: ${response.errors!.first}');
        emit(
          WishlistErrorState(
            message: 'Failed to add item: ${response.errors!.first}',
          ),
        );
        return;
      }

      debugPrint('✅ Successfully added product $productId to cart via API');

      // Check final state after cart operation
      final afterCartState = state;
      final afterCartItems = afterCartState is WishlistLoadedState 
          ? afterCartState.items.length 
          : 0;
      debugPrint('📊 WishlistViewModel: After cart - Wishlist has $afterCartItems items');

      // Emit success message for the view to display
      final cur = state;
      if (cur is WishlistLoadedState) {
        debugPrint('📤 WishlistViewModel: Emitting success state with ${cur.items.length} items');
        emit(
          WishlistSuccessState(message: 'Added to cart', previousState: cur),
        );
        // Immediately restore to loaded state after success message
        Future.delayed(Duration(milliseconds: 50), () {
          if (state is WishlistSuccessState) {
            debugPrint('🔄 WishlistViewModel: Auto-restoring to loaded state');
            final successState = state as WishlistSuccessState;
            emit(successState.previousState);
          }
        });
      }
    } catch (e) {
      debugPrint('❌ Failed to add to cart: $e');
      emit(WishlistErrorState(message: 'Failed to add to cart: $e'));
    }
  }

  void _promptAddToCartOptions(WishlistItem item) {
    final cur = state;
    if (cur is WishlistLoadedState) {
      emit(WishlistActionPromptState(previousState: cur, item: item));
    }
  }

  Future<String?> _getJwtToken() async {
    try {
      final auth = AuthStorageHelper();
      return await auth.getToken();
    } catch (_) {
      return null;
    }
  }

  /// Gets cart token from storage
  /// Interceptor automatically adds token to request headers,
  /// but ViewModel needs token for direct API calls
  Future<String?> _getCartToken() async {
    try {
      // First try to get from arguments (route params)
      final argsToken = _arguments['cartToken'] as String?;
      if (argsToken != null && argsToken.isNotEmpty) {
        debugPrint('🛒 WishlistViewModel: Cart token from arguments');
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
          '🛒 WishlistViewModel: Cart token from storage: ${wooCartToken.cartToken.length > 20 ? wooCartToken.cartToken.substring(0, 20) + "..." : wooCartToken.cartToken}',
        );
        return wooCartToken.cartToken;
      }

      debugPrint('⚠️ WishlistViewModel: No cart token found');
      return null;
    } catch (e) {
      debugPrint('❌ Failed to get cart token: $e');
      return null;
    }
  }

  @override
  WishlistState? fromJson(Map<String, dynamic> json) {
    try {
      // Try to restore wishlist state from persisted data
      if (json.containsKey('items') && json['items'] is List) {
        final itemsJson = json['items'] as List;
        final items = itemsJson
            .map((item) {
              try {
                // Helper function to safely convert dynamic to String?
                String? safeString(dynamic value) {
                  if (value == null) return null;
                  if (value is String) return value;
                  if (value is bool) return value.toString();
                  if (value is num) return value.toString();
                  return value.toString();
                }

                // Helper function to safely convert dynamic to int?
                int? safeInt(dynamic value) {
                  if (value == null) return null;
                  if (value is int) return value;
                  if (value is String) return int.tryParse(value);
                  if (value is num) return value.toInt();
                  return null;
                }

                // Helper function to safely convert dynamic to bool?
                bool safeBool(dynamic value, {bool defaultValue = false}) {
                  if (value == null) return defaultValue;
                  if (value is bool) return value;
                  if (value is String) {
                    return value.toLowerCase() == 'true' || value == '1';
                  }
                  if (value is num) return value != 0;
                  return defaultValue;
                }

                return WishlistItem(
                  id: safeInt(item['id']) ?? 0,
                  itemId: safeInt(item['itemId']),
                  name: safeString(item['name']),
                  imageUrl: safeString(item['imageUrl']),
                  regularPrice: safeString(item['regularPrice']),
                  salePrice: safeString(item['salePrice']),
                  currencyCode: safeString(item['currencyCode']),
                  currencyDecimalSeparator: safeString(
                    item['currencyDecimalSeparator'],
                  ),
                  currencyThousandSeparator: safeString(
                    item['currencyThousandSeparator'],
                  ),
                  currencyMinorUnit: safeInt(item['currencyMinorUnit']),
                  onSale: safeBool(item['onSale'], defaultValue: false),
                );
              } catch (e) {
                debugPrint('⚠️ Wishlist: Error parsing item from JSON: $e');
                return null;
              }
            })
            .whereType<WishlistItem>()
            .toList();

        debugPrint(
          '✅ Wishlist: Restored ${items.length} items from persisted state',
        );
        return WishlistLoadedState(items: items);
      }
      // If no items, return empty loaded state
      return WishlistLoadedState(items: const []);
    } catch (e) {
      debugPrint('⚠️ Wishlist: Error restoring state from JSON: $e');
      // Return empty loaded state on error
      return WishlistLoadedState(items: const []);
    }
  }

  @override
  Map<String, dynamic>? toJson(WishlistState state) {
    try {
      // Persist wishlist state to survive app restarts
      if (state is WishlistLoadedState) {
        final itemsJson = state.items.map((item) {
          return {
            'id': item.id,
            'itemId': item.itemId,
            'name': item.name,
            'imageUrl': item.imageUrl,
            'regularPrice': item.regularPrice,
            'salePrice': item.salePrice,
            'currencyCode': item.currencyCode,
            'onSale': item.onSale,
          };
        }).toList();

        debugPrint(
          '✅ Wishlist: Persisting ${state.items.length} items to storage',
        );
        return {'items': itemsJson};
      }
      // Don't persist other states (loading, error, etc.)
      return null;
    } catch (e) {
      debugPrint('⚠️ Wishlist: Error persisting state to JSON: $e');
      return null;
    }
  }
}
