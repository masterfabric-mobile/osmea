import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:apis/network/remote/woocommerce/wishlist/abstract/woo_wishlist_service.dart';
import 'package:apis/network/remote/woocommerce/wishlist/freezed_model/request/add_wishlist_item_request.dart';
import 'package:apis/network/remote/woocommerce/wishlist/freezed_model/request/create_wishlist_group_request.dart';
import 'package:apis/network/remote/woocommerce/store_api/cart_api/abstract/cart_service.dart';
import 'package:apis/network/remote/woocommerce/wishlist/freezed_model/request/delete_wishlist_item_request.dart';
import 'package:apis/network/remote/woocommerce/wishlist/freezed_model/response/wishlist_item_response.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_api/abstract/product_service.dart';
import 'package:apis/models/cart/woo_cart_token.dart';
import 'package:apis/utils/api_error_utils.dart';
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
    // Handle WishlistSuccessState by using previousState
    if (s is WishlistLoadedState) {
      return s.items.any((e) => e.id == productId);
    } else if (s is WishlistSuccessState) {
      return s.previousState.items.any((e) => e.id == productId);
    }
    return false;
  }

  int get count => state is WishlistLoadedState
      ? (state as WishlistLoadedState).items.length
      : 0;

  // Helper: Get API namespace from config
  String get _namespace {
    return _config.getString(
      'woocommerce_configuration.wishlist_namespace',
      'masterfabric-wishlist',
    );
  }

  // Helper: Get API version from config
  String get _apiVersion {
    return _config.getString('woocommerce_configuration.version', 'v1');
  }

  // Public triggers (OSMEA style)
  Future<void> initial() async {
    await _syncFromServer();
    await _loadGroups();
  }
  Future<void> syncFromServer({int? groupId}) =>
      _syncFromServer(groupId: groupId);
  Future<List<WishlistItem>> getCollectionItems(int groupId) =>
      _getCollectionItems(groupId);
  Future<void> toggle(WishlistItem item, {int? groupId}) =>
      _toggle(item, groupId: groupId);
  Future<void> add(WishlistItem item, {int? groupId}) =>
      _add(item, groupId: groupId);
  Future<void> remove(int productId, {int? groupId}) =>
      _remove(productId, groupId: groupId);
  Future<void> removeByItemId(int itemId) =>
      _removeByItemId(itemId);
  Future<void> addItemToCartFromWishlist(int productId) =>
      _addItemToCartFromWishlist(productId);
  
  // Group management methods
  Future<void> loadGroups() => _loadGroups();
  Future<void> createGroup(String name, {String? description}) =>
      _createGroup(name, description: description);
  Future<void> deleteGroup(int groupId) => _deleteGroup(groupId);

  /// Adds item to cart and then removes it from wishlist
  Future<void> addItemToCartAndRemoveFromWishlist(int productId) async {
    try {
      debugPrint(
        '🛒 WishlistViewModel: Starting add to cart and remove from wishlist for product $productId',
      );

      // Store the current wishlist items before any operation
      // Handle case where state might be WishlistActionPromptState (popup is open)
      final currentState = state;
      WishlistLoadedState? loadedState;

      if (currentState is WishlistActionPromptState) {
        // If popup is open, use previousState
        debugPrint(
          '💡 WishlistViewModel: State is WishlistActionPromptState, using previousState',
        );
        loadedState = currentState.previousState;
      } else if (currentState is WishlistLoadedState) {
        loadedState = currentState;
      } else {
        debugPrint(
          '⚠️ WishlistViewModel: Current state is not WishlistLoadedState, cannot remove item',
        );
        // Try to add to cart anyway
        await _addItemToCartFromWishlist(productId);
        return;
      }

      final currentItems = List<WishlistItem>.from(loadedState.items);
      debugPrint(
        '💾 WishlistViewModel: Stored ${currentItems.length} items before operations',
      );
      debugPrint(
        '💾 WishlistViewModel: Current items IDs: ${currentItems.map((e) => e.id).toList()}',
      );

      // First add to cart - throw exception if it fails
      try {
        await _addItemToCartFromWishlist(productId);
        debugPrint('✅ WishlistViewModel: Cart addition completed successfully');
      } catch (e) {
        debugPrint('❌ WishlistViewModel: Cart addition failed: $e');
        // Re-throw exception so UI can show error
        final errorMessage = ApiErrorUtils.getErrorMessage(e);
        emit(
          WishlistErrorState(message: 'Failed to add to cart: $errorMessage'),
        );
        rethrow;
      }

      // Re-check state after cart addition (in case it changed)
      final stateAfterCart = state;
      final itemsAfterCart = stateAfterCart is WishlistLoadedState
          ? List<WishlistItem>.from(stateAfterCart.items)
          : currentItems;

      debugPrint('🗑️ WishlistViewModel: Starting removal from wishlist');
      debugPrint(
        '🗑️ WishlistViewModel: Items after cart addition: ${itemsAfterCart.length}',
      );
      debugPrint('🗑️ WishlistViewModel: Removing product ID: $productId');

      // Remove the item manually from local state without server sync
      final updatedItems = itemsAfterCart.where((item) {
        final shouldKeep = item.id != productId;
        if (!shouldKeep) {
          debugPrint(
            '🗑️ WishlistViewModel: Filtering out item with id=${item.id} (matches productId=$productId)',
          );
        }
        return shouldKeep;
      }).toList();

      debugPrint(
        '📝 WishlistViewModel: Updated items count: ${updatedItems.length} (removed product $productId)',
      );
      debugPrint(
        '📝 WishlistViewModel: Remaining items IDs: ${updatedItems.map((e) => e.id).toList()}',
      );

      // Emit the updated state immediately
      final currentGroups = loadedState.groups;
      emit(WishlistLoadedState(items: updatedItems, groups: currentGroups));

      // Optionally try to remove from server in background (don't await)
      _removeFromServerInBackground(productId);

      debugPrint(
        '✅ WishlistViewModel: Add to cart and remove from wishlist completed',
      );
    } catch (e) {
      debugPrint('❌ Failed to add to cart and remove from wishlist: $e');
      // Error state already emitted in catch block above, don't emit again
      if (state is! WishlistErrorState) {
        final errorMessage = ApiErrorUtils.getErrorMessage(e);
        emit(
          WishlistErrorState(
            message: 'Failed to complete operation: $errorMessage',
          ),
        );
      }
    }
  }

  /// Remove item from server in background without affecting UI state
  Future<void> _removeFromServerInBackground(int productId) async {
    try {
      final jwt = await _getJwtToken();
      if (jwt == null || jwt.isEmpty) {
        debugPrint(
          '💡 Background remove: Not authenticated, skipping server removal',
        );
        return;
      }

      // Find the item to get itemId if available
      final s = state;
      WishlistItem? itemToRemove;
      WishlistLoadedState? loadedState;

      if (s is WishlistActionPromptState) {
        // If popup is open, use previousState
        loadedState = s.previousState;
      } else if (s is WishlistLoadedState) {
        loadedState = s;
      }

      if (loadedState != null) {
        itemToRemove = loadedState.items.firstWhere(
          (e) => e.id == productId,
          orElse: () => WishlistItem(id: productId),
        );
      }

      // Try DELETE by itemId first (preferred method)
      bool deleteSuccess = false;
      if (itemToRemove?.itemId != null) {
        try {
          debugPrint(
            '💖 Background remove: Deleting by itemId: ${itemToRemove!.itemId}',
          );
          final response = await _wishlistService.deleteItemById(
            namespace: _namespace,
            apiVersion: _apiVersion,
            itemId: itemToRemove.itemId!,
          );

          if (response.success == true) {
            deleteSuccess = true;
            debugPrint('✅ Background remove: Item removed successfully by ID');
            return;
          }
        } catch (e) {
          debugPrint('❌ Background remove: deleteItemById failed: $e');
          // Fall through to try deleteItemByProduct
        }
      }

      // If deleteItemById didn't work, try deleteItemByProduct
      if (!deleteSuccess) {
        try {
          debugPrint(
            '💖 Background remove: Deleting by productId: $productId, groupId: 0',
          );
          final request = DeleteWishlistItemRequest(
            productId: productId,
            groupId: 0, // Default group for most implementations
          );

          final response = await _wishlistService.deleteItemByProduct(
            namespace: _namespace,
            apiVersion: _apiVersion,
            request: request,
          );

          debugPrint(
            '🔄 Background remove: Server removal response - success: ${response.success}',
          );
        } catch (e) {
          debugPrint(
            '⚠️ Background remove: Server removal failed: $e (UI state not affected)',
          );
        }
      }
    } catch (e) {
      debugPrint(
        '⚠️ Background remove: Server removal failed: $e (UI state not affected)',
      );
    }
  }

  void promptAddToCartOptions(WishlistItem item) =>
      _promptAddToCartOptions(item);
  void restorePrevious(WishlistLoadedState prev) {
    debugPrint(
      '🔄 WishlistViewModel: Restoring previous state with ${prev.items.length} items',
    );
    emit(prev);
  }

  /// Clear all wishlist items (used when user signs out or remove all)
  Future<void> clearAll() async {
    debugPrint('💖 Wishlist: Clearing all items');
    
    // Get current items before clearing
    final currentState = state;
    final currentItems = currentState is WishlistLoadedState
        ? currentState.items
        : <WishlistItem>[];
    
    // Optimistically clear UI immediately
    emit(WishlistLoadedState(items: const [], groups: const []));
    
    // Delete all items from server in background
    if (currentItems.isNotEmpty) {
      final jwt = await _getJwtToken();
      if (jwt != null && jwt.isNotEmpty) {
        debugPrint('💖 Wishlist: Deleting ${currentItems.length} items from server');
        
        // Delete all items from server
        for (final item in currentItems) {
          try {
            // Try to delete by itemId first (preferred method)
            if (item.itemId != null) {
              try {
                await _wishlistService.deleteItemById(
                  namespace: _namespace,
                  apiVersion: _apiVersion,
                  itemId: item.itemId!,
                );
                debugPrint('✅ Wishlist: Deleted item ${item.id} by itemId');
                continue;
              } catch (e) {
                debugPrint('⚠️ Wishlist: Failed to delete item ${item.id} by itemId: $e');
                // Fall through to try by productId
              }
            }
            
            // Fallback: delete by productId
            try {
              await _wishlistService.deleteItemByProduct(
                namespace: _namespace,
                apiVersion: _apiVersion,
                request: DeleteWishlistItemRequest(
                  productId: item.id,
                  groupId: 0,
                ),
              );
              debugPrint('✅ Wishlist: Deleted item ${item.id} by productId');
            } catch (e) {
              debugPrint('⚠️ Wishlist: Failed to delete item ${item.id} by productId: $e');
              // Continue with other items even if one fails
            }
          } catch (e) {
            debugPrint('❌ Wishlist: Error deleting item ${item.id}: $e');
            // Continue with other items even if one fails
          }
        }
        
        debugPrint('✅ Wishlist: Finished deleting all items from server');
      } else {
        debugPrint('💡 Wishlist: Not authenticated, only cleared local state');
      }
    }
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
  Future<List<WishlistItem>> _getCollectionItems(int groupId) async {
    try {
      final jwt = await _getJwtToken();
      if (jwt == null || jwt.isEmpty) {
        debugPrint('💡 Wishlist: Not authenticated, returning empty list');
        return [];
      }

      debugPrint('💖 Wishlist: Fetching items for collection $groupId...');

      List<WishlistItemResponse> items = [];

      try {
        final paged = await _wishlistService.getWishlistItems(
          namespace: _namespace,
          apiVersion: _apiVersion,
          groupId: groupId,
          page: 1,
          perPage: 100,
        );

        if (paged.items != null && paged.items!.isNotEmpty) {
          items = paged.items!;
        } else if (paged.data != null && paged.data!.isNotEmpty) {
          items = paged.data!;
        }
      } catch (e) {
        debugPrint('❌ Wishlist: Failed to fetch collection items: $e');
        return [];
      }

      if (items.isEmpty) {
        return [];
      }

      // Map WishlistItemResponse to WishlistItem
      final mapped = <WishlistItem>[];

      for (final itemResponse in items) {
        try {
          final itemId = itemResponse.id;
          final productId = itemResponse.productId;

          if (productId == null || productId == 0) {
            continue;
          }

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

          try {
            final product = await _productService.retrieveProduct(
              apiVersion: _apiVersion,
              productId: productId,
            );

            final prices = product.prices;
            final imageUrl = product.images?.isNotEmpty == true
                ? product.images!.first.src
                : image;

            final productName = product.name ?? name ?? 'Product';
            final productPrice =
                prices?.regularPrice ?? prices?.price ?? price ?? '0.00';

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
          } catch (e) {
            final fallbackName = name ?? 'Product';
            final fallbackPrice = price ?? '0.00';

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
          debugPrint('❌ Wishlist: Error parsing collection item: $e');
          continue;
        }
      }

      debugPrint('✅ Wishlist: Loaded ${mapped.length} items for collection $groupId');
      return mapped;
    } catch (e) {
      debugPrint('❌ Wishlist: Error getting collection items: $e');
      return [];
    }
  }

  Future<void> _syncFromServer({int? groupId}) async {
    try {
      // If not authenticated, keep local (hydrated) state without erroring
      final jwt = await _getJwtToken();
      if (jwt == null || jwt.isEmpty) {
        debugPrint('💡 Wishlist: Not authenticated, using local state');
        final s = state;
        if (s is WishlistLoadedState) {
          // Keep existing state
          emit(WishlistLoadedState(items: s.items, groups: s.groups));
        } else if (s is WishlistInitialState) {
          // If initial state, try to restore from persisted state
          // HydratedCubit should handle this, but ensure we have loaded state
          emit(WishlistLoadedState(items: const [], groups: const []));
        } else {
          // For any other state (error, etc.), ensure we have loaded state
          emit(WishlistLoadedState(items: const [], groups: const []));
        }
        return;
      }

      emit(WishlistLoadingState());
      debugPrint('💖 Wishlist: Starting sync from server...');

      debugPrint('💖 Wishlist: Fetching wishlist items from server...');

      // Use service to fetch wishlist items
      List<WishlistItemResponse> items = [];

      try {
        final paged = await _wishlistService.getWishlistItems(
          namespace: _namespace,
          apiVersion: _apiVersion,
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
            message:
                'Failed to load saved items: ${ApiErrorUtils.getErrorMessage(e)}',
          ),
        );
        return;
      }

      if (items.isEmpty) {
        debugPrint('💡 Wishlist: No items found');
        // Load groups even if no items
        final groups = await _loadGroupsAndGetList();
        final currentState = state;
        if (currentState is WishlistLoadedState) {
          emit(currentState.copyWith(groups: groups));
        } else {
          emit(WishlistLoadedState(items: const [], groups: groups));
        }
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
              apiVersion: _apiVersion,
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
            final productPrice =
                prices?.regularPrice ?? prices?.price ?? price ?? '0.00';

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

      // Load groups after loading items
      final groups = await _loadGroupsAndGetList();
      
      emit(WishlistLoadedState(items: mapped, groups: groups));
      debugPrint('✅ Wishlist: Loaded ${mapped.length} items from API');
    } catch (e, stackTrace) {
      debugPrint('❌ Wishlist sync error: $e');
      debugPrint('❌ Wishlist sync error stack trace: $stackTrace');

      // IMPORTANT: Preserve existing state on sync failure - don't clear wishlist
      final currentState = state;
      if (currentState is WishlistLoadedState) {
        // Keep existing state if available - don't clear it!
        debugPrint(
          '💡 Wishlist: Sync failed, keeping existing state with ${currentState.items.length} items',
        );
        emit(WishlistLoadedState(items: currentState.items, groups: currentState.groups));
      } else if (currentState is WishlistActionPromptState) {
        // If popup is open, restore previous state
        debugPrint(
          '💡 Wishlist: Sync failed, restoring previous state from popup',
        );
        emit(WishlistLoadedState(
          items: currentState.previousState.items,
          groups: currentState.previousState.groups,
        ));
      } else {
        // If no existing state, try to restore from persisted state
        // HydratedCubit should handle this, but ensure we have loaded state
        debugPrint('💡 Wishlist: Sync failed, checking persisted state...');
        // Don't emit empty state - let HydratedCubit restore from storage
        // If that fails too, only then use empty state
        final persistedState =
            state; // This should be restored by HydratedCubit
        if (persistedState is WishlistLoadedState) {
          debugPrint(
            '💡 Wishlist: Using persisted state with ${persistedState.items.length} items',
          );
          emit(persistedState);
        } else {
          debugPrint('💡 Wishlist: No persisted state, using empty state');
          emit(WishlistLoadedState(items: const [], groups: const []));
        }
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
        // Handle WishlistSuccessState by using previousState
        final currentItems = s is WishlistLoadedState
            ? s.items
            : s is WishlistSuccessState
            ? s.previousState.items
            : <WishlistItem>[];

        // Check if item already exists
        if (currentItems.any((e) => e.id == item.id)) {
          debugPrint(
            '💡 Wishlist: Item already in local state (unauthenticated)',
          );
          return;
        }

        final items = [...currentItems, item];
        final currentGroups = s is WishlistLoadedState ? s.groups : const <WishlistGroup>[];
        final newState = WishlistLoadedState(items: items, groups: currentGroups);
        emit(newState);
        debugPrint('✅ Wishlist: Item added to local state (unauthenticated)');
        return;
      }

      // Preserve current state before sync
      final stateBeforeSync = state;
      WishlistLoadedState? preservedState;
      if (stateBeforeSync is WishlistLoadedState) {
        preservedState = stateBeforeSync;
      }

      // IMPORTANT: First sync from server to get current state
      // This prevents 400 errors when item already exists on server
      // But don't fail if sync fails - we'll still try to add the item
      debugPrint('💖 Wishlist: Syncing from server before adding item...');
      try {
        await _syncFromServer(groupId: groupId);
      } catch (syncError) {
        debugPrint(
          '⚠️ Wishlist: Sync before add failed, but continuing with add: $syncError',
        );
        // Restore preserved state if sync failed
        if (preservedState != null) {
          emit(preservedState);
        }
      }

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
          // Use preserved state if available, otherwise empty
          emit(preservedState ?? WishlistLoadedState(items: const []));
        }
      }

      // Call API to add item - THIS IS THE CRITICAL CALL
      debugPrint(
        '💖 Wishlist: Sending API request to add item (productId: ${item.id}, groupId: ${groupId ?? 0})',
      );
      final response = await _wishlistService.addItemToWishlist(
        namespace: _namespace,
        apiVersion: _apiVersion,
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
        try {
          await _syncFromServer(groupId: groupId);
        } catch (syncError) {
          debugPrint(
            '⚠️ Wishlist: Sync after failed add also failed: $syncError',
          );
          // Keep current state if sync fails
          if (preservedState != null) {
            // Add item to preserved state optimistically
            if (!preservedState.items.any((w) => w.id == item.id)) {
              final items = [...preservedState.items, item];
              emit(WishlistLoadedState(items: items, groups: preservedState.groups));
            } else {
              emit(preservedState);
            }
          }
        }
        return;
      }

      // If successful, sync from server to get the complete updated state
      if (response.success == true) {
        debugPrint(
          '✅ Wishlist: Item added successfully, syncing from server...',
        );
        
        // If adding to a collection (groupId is not null), refresh entire wishlist
        // Otherwise, just sync items
        if (groupId != null) {
          debugPrint('💖 Wishlist: Added to collection, refreshing entire wishlist...');
          await Future.delayed(const Duration(milliseconds: 300));
          await _refreshWishlist();
        } else {
          // For general wishlist (no group), just sync items
          await _syncFromServer();
        }
        
        // Emit success state with current loaded state
        final currentState = state;
        if (currentState is WishlistLoadedState) {
          emit(
            WishlistSuccessState(
              message: groupId != null ? 'Added to collection' : 'Added to favorites',
              previousState: currentState,
            ),
          );
        } else {
          // If state is not loaded, try to refresh again
          await _refreshWishlist();
          final refreshedState = state;
          if (refreshedState is WishlistLoadedState) {
            emit(
              WishlistSuccessState(
                message: groupId != null ? 'Added to collection' : 'Added to favorites',
                previousState: refreshedState,
              ),
            );
          }
        }
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Wishlist add error: $e');
      debugPrint('❌ Wishlist add error stack trace: $stackTrace');

      // Preserve state before error handling
      final stateBeforeError = state;
      WishlistLoadedState? preservedState;
      if (stateBeforeError is WishlistLoadedState) {
        preservedState = stateBeforeError;
      }

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
          // Restore preserved state if sync fails
          if (preservedState != null) {
            emit(preservedState);
          }
        }
        return;
      }

      // On other errors, try to sync from server to get accurate state
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
            emit(WishlistLoadedState(items: items, groups: cur.groups));
          }
        } else if (preservedState != null) {
          // Use preserved state and add item if not already there
          if (!preservedState.items.any((w) => w.id == item.id)) {
            final items = [...preservedState.items, item];
            emit(WishlistLoadedState(items: items, groups: preservedState.groups));
          } else {
            emit(preservedState);
          }
        } else {
          // If state is not loaded, create new state with item
          final currentGroups = cur is WishlistLoadedState ? cur.groups : const <WishlistGroup>[];
          emit(WishlistLoadedState(items: [item], groups: currentGroups));
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
        // Handle WishlistSuccessState by using previousState
        final currentItems = s is WishlistLoadedState
            ? s.items
            : s is WishlistSuccessState
            ? s.previousState.items
            : <WishlistItem>[];
        final items = currentItems.where((e) => e.id != productId).toList();
        final currentGroups = s is WishlistLoadedState ? s.groups : const <WishlistGroup>[];
        emit(WishlistLoadedState(items: items, groups: currentGroups));
        debugPrint(
          '✅ Wishlist: Item removed from local state (unauthenticated)',
        );
        return;
      }

      // Find the item to get itemId if available
      final s = state;
      // Handle WishlistSuccessState by using previousState
      final currentItems = s is WishlistLoadedState
          ? s.items
          : s is WishlistSuccessState
          ? s.previousState.items
          : <WishlistItem>[];

      WishlistItem? itemToRemove;
      if (currentItems.isNotEmpty) {
        itemToRemove = currentItems.firstWhere(
          (e) => e.id == productId,
          orElse: () => WishlistItem(id: productId),
        );
      }

      // Update local state optimistically (UI updates immediately)
      final items = currentItems.where((e) => e.id != productId).toList();
      final currentGroups = s is WishlistLoadedState ? s.groups : const <WishlistGroup>[];
      emit(WishlistLoadedState(items: items, groups: currentGroups));

      // Try DELETE by itemId first (preferred method as per API explorer)
      bool deleteSuccess = false;
      if (itemToRemove?.itemId != null) {
        try {
          debugPrint(
            '💖 Wishlist: Deleting by itemId: ${itemToRemove!.itemId}',
          );
          final response = await _wishlistService.deleteItemById(
            namespace: _namespace,
            apiVersion: _apiVersion,
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
            namespace: _namespace,
            apiVersion: _apiVersion,
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
            debugPrint(
              '⚠️ Wishlist: Delete by itemId failed, but keeping optimistic removal',
            );
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
          debugPrint(
            '⚠️ Wishlist: Delete failed with error, but keeping optimistic removal',
          );
          return;
        }
      }
    } catch (e) {
      debugPrint('❌ Wishlist remove error: $e');
      // On error, keep optimistic update instead of syncing to avoid clearing list
      debugPrint(
        '💡 Wishlist: Remove error occurred, but keeping optimistic removal',
      );
      // Don't sync from server as it might clear the entire list
    }
  }

  Future<void> _removeByItemId(int itemId) async {
    try {
      final jwt = await _getJwtToken();
      if (jwt == null || jwt.isEmpty) {
        debugPrint('💡 Wishlist: Not authenticated, cannot remove by itemId');
        return;
      }

      debugPrint('💖 Wishlist: Deleting by itemId: $itemId');
      final response = await _wishlistService.deleteItemById(
        namespace: _namespace,
        apiVersion: _apiVersion,
        itemId: itemId,
      );

      debugPrint(
        '💖 Wishlist remove API response (by ID): success=${response.success}, message=${response.message}',
      );

      if (response.success == true) {
        debugPrint('✅ Wishlist: Item removed successfully by ID');
        // Reload groups to update item counts
        await _loadGroups();
      } else {
        debugPrint('⚠️ Wishlist: Delete by itemId failed: ${response.message}');
        throw Exception(response.message ?? 'Failed to remove item');
      }
    } catch (e) {
      debugPrint('❌ Wishlist removeByItemId error: $e');
      rethrow;
    }
  }

  Future<void> _addItemToCartFromWishlist(int productId) async {
    debugPrint(
      '🛒 WishlistViewModel: Adding product $productId to cart via API',
    );

    // Preserve current wishlist state before any operations
    final currentState = state;
    WishlistLoadedState? preservedState;
    if (currentState is WishlistActionPromptState) {
      preservedState = currentState.previousState;
    } else if (currentState is WishlistLoadedState) {
      preservedState = currentState;
    }

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
        // Get first variation ID (for wishlist, we use first available variation)
        final firstVariation = product.variations!.first;
        if (firstVariation is Map<String, dynamic>) {
          final id = firstVariation['id'];
          if (id != null) {
            variationId = int.tryParse(id.toString());
            debugPrint(
              '🛒 Found first variation ID: $variationId for variable product',
            );
          }
        }
      }
    } catch (e) {
      debugPrint(
        '⚠️ Could not fetch product details, proceeding with product ID: $e',
      );
    }

    // Ensure we have a cart token; if missing, initialize cart first
    String? cartToken = await _getCartToken();
    if (cartToken == null || cartToken.isEmpty) {
      debugPrint('🛒 No cart token found. Initializing cart via getCart...');
      await _cartService.getCart(
        apiVersion: _config.getString(
          'woocommerce_configuration.version',
          'v1',
        ),
        jwtToken: await _getJwtToken(),
      );
      cartToken = await _getCartToken();
      debugPrint(
        '🛒 Cart token after init: ${cartToken != null && cartToken.isNotEmpty}',
      );
    }

    // Add item to cart via API (first attempt)
    // If variation ID found, use it as the id; otherwise use product ID
    final itemId = variationId ?? productId;

    debugPrint('🛒 Adding to cart: id=$itemId, variationId=$variationId');

    var response = await _cartService.addItem(
      apiVersion: _config.getString('woocommerce_configuration.version', 'v1'),
      cartToken: cartToken ?? '',
      jwtToken: await _getJwtToken(), // Optional JWT token
      id: itemId,
      quantity: 1,
    );

    debugPrint(
      '🛒 WishlistViewModel: AddItem API response: ${response.toJson()}',
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
          apiVersion: _config.getString(
            'woocommerce_configuration.version',
            'v1',
          ),
          jwtToken: await _getJwtToken(),
        );
        final refreshedToken = await _getCartToken();
        response = await _cartService.addItem(
          apiVersion: _config.getString(
            'woocommerce_configuration.version',
            'v1',
          ),
          cartToken: refreshedToken ?? '',
          jwtToken: await _getJwtToken(),
          id: itemId,
          quantity: 1,
        );

        if (response.errors != null && response.errors!.isNotEmpty) {
          final errorMessage = ApiErrorUtils.getErrorMessage(
            response.errors!.first,
          );
          // Restore preserved state before throwing
          if (preservedState != null) {
            emit(preservedState);
          }
          // Throw exception so calling code knows it failed
          throw Exception('Failed to add item: $errorMessage');
        }
      } else {
        final errorMessage = ApiErrorUtils.getErrorMessage(
          response.errors!.first,
        );
        // Restore preserved state before throwing
        if (preservedState != null) {
          emit(preservedState);
        }
        // Throw exception so calling code knows it failed
        throw Exception('Failed to add item: $errorMessage');
      }
    }

    // Cart token is automatically handled by WooCartTokenInterceptor
    // No need to manually save token - interceptor extracts from response headers

    // Restore preserved wishlist state to ensure it's not cleared
    if (preservedState != null) {
      debugPrint(
        '💾 WishlistViewModel: Restoring preserved wishlist state after cart addition',
      );
      emit(preservedState);
    }

    debugPrint('✅ Successfully added product $productId to cart via API');
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
      // Helper functions
      String? safeString(dynamic value) {
        if (value == null) return null;
        if (value is String) return value;
        if (value is bool) return value.toString();
        if (value is num) return value.toString();
        return value.toString();
      }

      int? safeInt(dynamic value) {
        if (value == null) return null;
        if (value is int) return value;
        if (value is String) return int.tryParse(value);
        if (value is num) return value.toInt();
        return null;
      }

      bool safeBool(dynamic value, {bool defaultValue = false}) {
        if (value == null) return defaultValue;
        if (value is bool) return value;
        if (value is String) {
          return value.toLowerCase() == 'true' || value == '1';
        }
        if (value is num) return value != 0;
        return defaultValue;
      }

      // Restore items
      List<WishlistItem> items = const [];
      if (json.containsKey('items') && json['items'] is List) {
        final itemsJson = json['items'] as List;
        items = itemsJson
            .map((item) {
              try {
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
      }

      // Restore groups
      List<WishlistGroup> groups = const [];
      if (json.containsKey('groups') && json['groups'] is List) {
        final groupsJson = json['groups'] as List;
        groups = groupsJson
            .map((group) {
              try {
                return WishlistGroup(
                  id: safeString(group['id']) ?? '',
                  name: safeString(group['name']) ?? 'Unnamed Group',
                  description: safeString(group['description']),
                  isDefault: safeBool(group['isDefault'], defaultValue: false),
                  itemCount: safeInt(group['itemCount']),
                  createdAt: safeString(group['createdAt']),
                  updatedAt: safeString(group['updatedAt']),
                  userId: safeInt(group['userId']),
                );
              } catch (e) {
                debugPrint('⚠️ Wishlist: Error parsing group from JSON: $e');
                return null;
              }
            })
            .whereType<WishlistGroup>()
            .toList();
      }

      debugPrint(
        '✅ Wishlist: Restored ${items.length} items and ${groups.length} groups from persisted state',
      );
      return WishlistLoadedState(items: items, groups: groups);
    } catch (e) {
      debugPrint('⚠️ Wishlist: Error restoring state from JSON: $e');
      // Return empty loaded state on error
      return WishlistLoadedState(items: const [], groups: const []);
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

        final groupsJson = state.groups.map((group) {
          return {
            'id': group.id,
            'name': group.name,
            'description': group.description,
            'isDefault': group.isDefault,
            'itemCount': group.itemCount,
            'createdAt': group.createdAt,
            'updatedAt': group.updatedAt,
            'userId': group.userId,
          };
        }).toList();

        debugPrint(
          '✅ Wishlist: Persisting ${state.items.length} items and ${state.groups.length} groups to storage',
        );
        return {
          'items': itemsJson,
          'groups': groupsJson,
        };
      }
      // Don't persist other states (loading, error, etc.)
      return null;
    } catch (e) {
      debugPrint('⚠️ Wishlist: Error persisting state to JSON: $e');
      return null;
    }
  }

  // Private group management implementations
  Future<void> _loadGroups() async {
    final groups = await _loadGroupsAndGetList();
    
    // Update current state with groups (preserve items)
    final currentState = state;
    if (currentState is WishlistLoadedState) {
      emit(currentState.copyWith(groups: groups));
    } else if (currentState is! WishlistLoadingState) {
      // Only emit if not loading (to avoid overriding loading state)
      emit(WishlistLoadedState(
        items: const [],
        groups: groups,
      ));
    }
  }

  /// Refresh entire wishlist from server - loads both items and groups
  /// Public method to refresh wishlist from external sources (e.g., bottom sheet)
  Future<void> refresh() async {
    await _refreshWishlist();
  }

  /// Refresh entire wishlist from server - loads both items and groups
  Future<void> _refreshWishlist() async {
    debugPrint('🔄 Wishlist: Refreshing entire wishlist from server...');
    try {
      // Sync items from server (groupId=null means ALL items)
      // _syncFromServer() already loads groups internally, so we just call it
      await _syncFromServer();
      
      // _syncFromServer() already emits WishlistLoadedState with items and groups
      // No need to do anything else - state is already updated
      final currentState = state;
      if (currentState is WishlistLoadedState) {
        debugPrint('✅ Wishlist: Refresh completed - ${currentState.items.length} items, ${currentState.groups.length} groups');
      } else {
        debugPrint('⚠️ Wishlist: Refresh completed but state is not WishlistLoadedState: ${currentState.runtimeType}');
      }
    } catch (e) {
      debugPrint('❌ Wishlist: Error refreshing wishlist: $e');
      // Don't emit error state, keep current state
    }
  }

  Future<List<WishlistGroup>> _loadGroupsAndGetList() async {
    try {
      final jwt = await _getJwtToken();
      if (jwt == null || jwt.isEmpty) {
        debugPrint('💡 Wishlist: Not authenticated, skipping group load');
        return const <WishlistGroup>[];
      }

      debugPrint('💖 Wishlist: Loading groups from server...');
      final response = await _wishlistService.getAllGroups(
        namespace: _namespace,
        apiVersion: _apiVersion,
      );

      final groups = response.groups ?? [];
      final mappedGroups = groups.map((group) {
        return WishlistGroup(
          id: group.id ?? '',
          name: group.name ?? 'Unnamed Group',
          description: group.description,
          isDefault: group.isDefault ?? false,
          itemCount: group.itemCount,
          createdAt: group.createdAt,
          updatedAt: group.updatedAt,
          userId: group.userId,
        );
      }).toList();

      // DON'T emit state here - let _loadGroups() handle it
      // This prevents duplicate emits and preserves items
      debugPrint('✅ Wishlist: Loaded ${mappedGroups.length} groups');
      return mappedGroups;
    } catch (e) {
      debugPrint('❌ Wishlist: Error loading groups: $e');
      // Return empty list on error, don't emit error state
      return const <WishlistGroup>[];
    }
  }

  Future<void> _createGroup(String name, {String? description}) async {
    try {
      final jwt = await _getJwtToken();
      if (jwt == null || jwt.isEmpty) {
        debugPrint('💡 Wishlist: Not authenticated, cannot create group');
        emit(WishlistErrorState(
          message: 'Please sign in to create a collection',
        ));
        return;
      }

      if (name.trim().isEmpty) {
        emit(WishlistErrorState(message: 'Collection name cannot be empty'));
        return;
      }

      emit(WishlistLoadingState());
      debugPrint('💖 Wishlist: Creating group: $name');

      final response = await _wishlistService.createGroup(
        namespace: _namespace,
        apiVersion: _apiVersion,
        request: CreateWishlistGroupRequest(
          name: name.trim(),
          description: description?.trim(),
        ),
      );

      debugPrint('💖 Wishlist: Create group response: success=${response.success}, data=${response.data}');

      if (response.success == true) {
        debugPrint('✅ Wishlist: Group created successfully: $name');
        
        // Wait a bit for server to process the new collection
        await Future.delayed(const Duration(milliseconds: 500));
        
        // Refresh entire wishlist from server - this will load both items and groups
        await _refreshWishlist();
        
        // Emit success state with current loaded state
        final currentState = state;
        if (currentState is WishlistLoadedState) {
          emit(WishlistSuccessState(
            message: 'Collection created successfully',
            previousState: currentState,
          ));
        } else {
          // If state is not loaded after refresh, ensure we have loaded state
          await _refreshWishlist();
          final refreshedState = state;
          if (refreshedState is WishlistLoadedState) {
            emit(WishlistSuccessState(
              message: 'Collection created successfully',
              previousState: refreshedState,
            ));
          }
        }
        
        debugPrint('✅ Wishlist: Collection "$name" created and wishlist refreshed');
      } else {
        emit(WishlistErrorState(
          message: response.message ?? 'Failed to create collection',
        ));
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Wishlist: Error creating group: $e');
      debugPrint('❌ Stack trace: $stackTrace');
      final errorMessage = ApiErrorUtils.getErrorMessage(e);
      emit(WishlistErrorState(
        message: 'Failed to create collection: $errorMessage',
      ));
    }
  }

  Future<void> _deleteGroup(int groupId) async {
    try {
      final jwt = await _getJwtToken();
      if (jwt == null || jwt.isEmpty) {
        debugPrint('💡 Wishlist: Not authenticated, cannot delete group');
        throw Exception('Please sign in to delete a collection');
      }

      debugPrint('🗑️ Wishlist: Deleting group: $groupId');
      final response = await _wishlistService.deleteGroup(
        namespace: _namespace,
        apiVersion: _apiVersion,
        groupId: groupId,
      );

      if (response.success == true) {
        debugPrint('✅ Wishlist: Group deleted successfully');
        
        // Wait a bit for server to process
        await Future.delayed(const Duration(milliseconds: 300));
        
        // Refresh entire wishlist from server
        await _refreshWishlist();
        
        // Emit success state
        final currentState = state;
        if (currentState is WishlistLoadedState) {
          emit(WishlistSuccessState(
            message: 'Collection deleted successfully',
            previousState: currentState,
          ));
        }
        
        return;
      }

      throw Exception(response.message ?? 'Failed to delete collection');
    } catch (e) {
      debugPrint('❌ Wishlist: Error deleting group ($groupId): $e');
      rethrow;
    }
  }
}
