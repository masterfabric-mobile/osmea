import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:apis/network/remote/woocommerce/wishlist/abstract/woo_wishlist_service.dart';
import 'package:apis/network/remote/woocommerce/wishlist/freezed_model/request/add_wishlist_item_request.dart';
import 'package:apis/network/remote/woocommerce/wishlist/freezed_model/request/delete_wishlist_item_request.dart';
import 'package:apis/network/remote/woocommerce/wishlist/freezed_model/response/wishlist_item_response.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_api/abstract/product_service.dart';
import 'package:apis/dio_config/dio_client/api_dio_client.dart';
import 'package:apis/apis.dart';
import 'package:storefront_woo/app/views/view_wishlist/models/module/states.dart';
import 'package:storefront_woo/app/views/view_cart/models/cart_view_model.dart';
import 'package:dio/dio.dart';

/// Lightweight DTO persisted for wishlist items
class WishlistItem {
  final int id; // product_id
  final int? itemId; // wishlist item_id (for DELETE by ID)
  final String? name;
  final String? imageUrl;
  final String? regularPrice;
  final String? salePrice;
  final String? currencyCode;
  final bool onSale;

  const WishlistItem({
    required this.id,
    this.itemId,
    this.name,
    this.imageUrl,
    this.regularPrice,
    this.salePrice,
    this.currencyCode,
    this.onSale = false,
  });

  factory WishlistItem.fromJson(Map<String, dynamic> json) => WishlistItem(
    id: json['id'] as int,
    itemId: json['itemId'] as int?,
    name: json['name'] as String?,
    imageUrl: json['imageUrl'] as String?,
    regularPrice: json['regularPrice'] as String?,
    salePrice: json['salePrice'] as String?,
    currencyCode: json['currencyCode'] as String?,
    onSale: (json['onSale'] as bool?) ?? false,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'itemId': itemId,
    'name': name,
    'imageUrl': imageUrl,
    'regularPrice': regularPrice,
    'salePrice': salePrice,
    'currencyCode': currencyCode,
    'onSale': onSale,
  };
}

// State moved to module/states.dart (SavedInitial/Loading/Loaded/Error)

/// Hydrated wishlist view model that also syncs with Woo Wishlist API
@injectable
class WishlistViewModel extends BaseViewModelHydratedCubit<WishlistState> {
  WishlistViewModel() : super(WishlistInitialState());

  // Dependencies (resolved via DI)
  final WooWishlistService _wishlistService = GetIt.I<WooWishlistService>();
  final ProductService _productService = GetIt.I<ProductService>();
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
  void promptAddToCartOptions(WishlistItem item) =>
      _promptAddToCartOptions(item);
  void restorePrevious(WishlistLoadedState prev) => emit(prev);

  /// Clear all wishlist items (used when user signs out)
  void clearAll() {
    debugPrint('💖 Wishlist: Clearing all items (sign out)');
    emit(WishlistLoadedState(items: const []));
  }

  // Private implementations
  Future<void> _syncFromServer({int? groupId}) async {
    try {
      // If not authenticated, keep local (hydrated) state without erroring
      final jwt = await _getJwtToken();
      if (jwt == null || jwt.isEmpty) {
        final s = state;
        if (s is WishlistLoadedState) {
          emit(WishlistLoadedState(items: s.items));
        } else {
          emit(WishlistLoadedState(items: const []));
        }
        return;
      }

      emit(WishlistLoadingState());
      final apiVersion = _config.getString(
        'woocommerce_configuration.version',
        'v1',
      );

      debugPrint('💖 Wishlist: Fetching wishlist items from server...');

      // API returns items in 'items' field, but WishlistPaginatedResponse expects 'data'
      // We need to manually parse the raw response
      List<dynamic> rawItems = [];

      try {
        // Try to get raw response using Dio directly
        // Interceptor will automatically add JWT token if available
        final dio = ApiDioClient.wooDio();
        final baseUrl = WooNetwork.baseUrl;

        final queryParams = <String, dynamic>{'page': 1, 'per_page': 100};
        if (groupId != null) {
          queryParams['group_id'] = groupId;
        }

        // Don't manually add Authorization header - let interceptor handle it
        // Interceptor will add token if available, or proceed without token for wishlist endpoints
        final headers = <String, dynamic>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        };

        final fullUrl = '$baseUrl/wp-json/custom-wishlist/$apiVersion/items';
        debugPrint('💖 Wishlist: Making direct Dio request to $fullUrl');
        debugPrint(
          '💖 Wishlist: JWT token will be added by interceptor if available',
        );

        final response = await dio.get<Map<String, dynamic>>(
          fullUrl,
          queryParameters: queryParams,
          options: Options(headers: headers),
        );

        debugPrint('💖 Wishlist: Raw response received: ${response.data}');

        // Parse response - API returns {items: [...], pagination: {...}}
        if (response.data != null) {
          final responseData = response.data!;

          // Check if response has 'items' field (actual API format)
          if (responseData.containsKey('items') &&
              responseData['items'] is List) {
            rawItems = responseData['items'] as List<dynamic>;
            debugPrint(
              '💖 Wishlist: Found ${rawItems.length} items in response.items',
            );
          }
          // Fallback: check if response has 'data' field (model format)
          else if (responseData.containsKey('data') &&
              responseData['data'] is List) {
            rawItems = responseData['data'] as List<dynamic>;
            debugPrint(
              '💖 Wishlist: Found ${rawItems.length} items in response.data',
            );
          }
          // Try to parse as WishlistPaginatedResponse format
          else {
            debugPrint(
              '⚠️ Wishlist: Response does not contain items or data field',
            );
            debugPrint(
              '⚠️ Wishlist: Response keys: ${responseData.keys.toList()}',
            );

            // Try using service response as fallback
            try {
              final paged = await _wishlistService.getWishlistItems(
                apiVersion: apiVersion,
                groupId: groupId,
                page: 1,
                perPage: 100,
              );
              if (paged.data != null && paged.data!.isNotEmpty) {
                rawItems = paged.data!.map((item) => item).toList();
                debugPrint(
                  '💖 Wishlist: Using service response data (${rawItems.length} items)',
                );
              }
            } catch (e) {
              debugPrint('❌ Wishlist: Fallback service call failed: $e');
            }
          }
        }
      } catch (e) {
        debugPrint('❌ Wishlist: Error fetching raw response: $e');
        // Fallback to service call
        try {
          final paged = await _wishlistService.getWishlistItems(
            apiVersion: apiVersion,
            groupId: groupId,
            page: 1,
            perPage: 100,
          );
          if (paged.data != null && paged.data!.isNotEmpty) {
            rawItems = paged.data!.map((item) => item).toList();
            debugPrint(
              '💖 Wishlist: Using service response data (${rawItems.length} items)',
            );
          }
        } catch (e2) {
          debugPrint('❌ Wishlist: Service call also failed: $e2');
        }
      }

      debugPrint('💖 Wishlist: Total raw items to process: ${rawItems.length}');

      final mapped = <WishlistItem>[];

      // Process each wishlist item
      for (final item in rawItems) {
        // Handle both WishlistItemResponse and raw Map formats
        int? productId;
        int? itemId; // wishlist item_id (for DELETE by ID)
        String? productName;
        String? productImage;
        String? productPrice;

        if (item is WishlistItemResponse) {
          itemId = item.id; // wishlist item_id
          productId = item.productId;
          productName = item.productName;
          productImage = item.productImage;
          productPrice = item.productPrice;
        } else if (item is Map<String, dynamic>) {
          // Handle raw API response format: {id: 10, product_id: 96, name: "...", price: "...", image: "..."}
          // API returns: {id: 10, product_id: 96, name: "...", price: "...", link: "...", image: "..."}
          // 'id' is the wishlist item_id, 'product_id' is the product ID
          // Handle both String and num types for id and product_id
          final idValue = item['id'];
          if (idValue != null) {
            if (idValue is num) {
              itemId = idValue.toInt();
            } else if (idValue is String) {
              itemId = int.tryParse(idValue);
            }
          }

          final productIdValue = item['product_id'];
          if (productIdValue != null) {
            if (productIdValue is num) {
              productId = productIdValue.toInt();
            } else if (productIdValue is String) {
              productId = int.tryParse(productIdValue);
            }
          }

          if (productId == null) {
            // Fallback: if product_id is not available, use id as productId (legacy)
            productId = itemId;
          }
          productName = item['name'] as String?;
          productImage = item['image'] as String?;
          productPrice = item['price']?.toString();

          debugPrint(
            '💖 Wishlist: Parsed raw item - itemId: $itemId, productId: $productId, name: $productName',
          );
        }

        if (productId == null || productId == 0) {
          debugPrint('⚠️ Wishlist: Skipping item with invalid productId');
          continue;
        }

        debugPrint(
          '💖 Wishlist: Processing item - productId: $productId, name: $productName',
        );

        // Check if product details are available from wishlist response
        final hasProductDetails =
            productName != null &&
            productName.isNotEmpty &&
            productImage != null &&
            productImage.isNotEmpty;

        if (hasProductDetails) {
          // Even if we have product details from wishlist response,
          // we should fetch full product details to get currency code and proper pricing
          // But if ProductService fails, use wishlist response data as fallback
          try {
            debugPrint(
              '🔄 Wishlist: Fetching product details for currency code - productId: $productId',
            );
            final product = await _productService.retrieveProduct(
              apiVersion: apiVersion,
              productId: productId,
            );

            // Extract image URL
            String? imageUrl = productImage;
            if (product.images != null && product.images!.isNotEmpty) {
              imageUrl = product.images!.first.src;
            }

            // Extract prices with currency code
            final prices = product.prices;
            final regularPrice =
                prices?.regularPrice ?? prices?.price ?? productPrice;
            final salePrice = product.onSale == true ? prices?.salePrice : null;
            final currencyCode = prices?.currencyCode;

            mapped.add(
              WishlistItem(
                id: productId,
                itemId: itemId,
                name: productName,
                imageUrl: imageUrl,
                regularPrice: regularPrice,
                salePrice: salePrice,
                currencyCode: currencyCode,
                onSale: product.onSale ?? false,
              ),
            );
            debugPrint(
              '✅ Wishlist: Added item with currency code from ProductService - ${product.name}',
            );
          } catch (e) {
            debugPrint(
              '⚠️ Wishlist: Failed to fetch product for currency, using wishlist data: $e',
            );
            // Fallback: use wishlist response data (without currency code)
            mapped.add(
              WishlistItem(
                id: productId,
                itemId: itemId,
                name: productName,
                imageUrl: productImage,
                regularPrice: productPrice,
                salePrice: null,
                currencyCode: null, // Will use default currency
                onSale: false,
              ),
            );
            debugPrint(
              '✅ Wishlist: Added item from response data (no currency) - $productName',
            );
          }
        } else {
          // Fetch product details from ProductService
          try {
            debugPrint(
              '🔄 Wishlist: Fetching product details for productId: $productId',
            );
            final product = await _productService.retrieveProduct(
              apiVersion: apiVersion,
              productId: productId,
            );

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

            mapped.add(
              WishlistItem(
                id: productId,
                itemId: itemId,
                name: product.name,
                imageUrl: imageUrl,
                regularPrice: regularPrice,
                salePrice: salePrice,
                currencyCode: currencyCode,
                onSale: product.onSale ?? false,
              ),
            );
            debugPrint(
              '✅ Wishlist: Added item from ProductService - ${product.name}',
            );
          } catch (e) {
            debugPrint('❌ Wishlist: Failed to fetch product $productId: $e');
            // Use partial data from wishlist if available
            mapped.add(
              WishlistItem(
                id: productId,
                itemId: itemId,
                name: productName ?? 'Product',
                imageUrl: productImage,
                regularPrice: productPrice,
                salePrice: null,
                currencyCode: null,
                onSale: false,
              ),
            );
            debugPrint(
              '✅ Wishlist: Added item with partial data - ${productName ?? "Product"}',
            );
          }
        }
      }

      debugPrint('💖 Wishlist: Mapped ${mapped.length} items to WishlistItem');
      emit(WishlistLoadedState(items: mapped));
    } catch (e) {
      debugPrint('❌ Wishlist sync error: $e');
      emit(WishlistErrorState(message: 'Failed to load saved items: $e'));
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
      // Check if item is already in local state
      final currentState = state;
      if (currentState is WishlistLoadedState) {
        final alreadyExists = currentState.items.any((w) => w.id == item.id);
        if (alreadyExists) {
          debugPrint(
            '💡 Wishlist: Item already in local state, syncing from server...',
          );
          // Item already exists locally, sync from server to ensure consistency
          final jwt = await _getJwtToken();
          if (jwt != null && jwt.isNotEmpty) {
            await _syncFromServer(groupId: groupId);
          }
          return;
        }
      }

      // Sync with server only if authenticated
      final jwt = await _getJwtToken();
      if (jwt == null || jwt.isEmpty) {
        debugPrint('💡 Wishlist: unauthenticated add -> local only');
        // Add to local state for unauthenticated users
        final s = state;
        final items = s is WishlistLoadedState ? [...s.items, item] : [item];
        emit(WishlistLoadedState(items: items));
        return;
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

      // Check if item was already in wishlist
      final message = response.message?.toLowerCase() ?? '';
      final isAlreadyInWishlist =
          message.contains('already in wishlist') ||
          message.contains('already exists') ||
          message.contains('already added');

      if (isAlreadyInWishlist) {
        debugPrint(
          '💡 Wishlist: Product already in wishlist, syncing from server...',
        );
        // Product already exists on server, sync from server to get updated state
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
      } else {
        debugPrint(
          '⚠️ Wishlist: API returned success=false, syncing from server...',
        );
        // Sync from server to get accurate state
        await _syncFromServer(groupId: groupId);
      }
    } catch (e) {
      debugPrint('❌ Wishlist add error: $e');
      // On error, sync from server to get accurate state
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

      // Update local state optimistically
      final items = s is WishlistLoadedState
          ? s.items.where((e) => e.id != productId).toList()
          : const <WishlistItem>[];
      emit(WishlistLoadedState(items: items));

      final apiVersion = _config.getString(
        'woocommerce_configuration.version',
        'v1',
      );

      // Try DELETE by itemId first (preferred method as per API explorer)
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

          // Sync from server to get accurate state after removal
          if (response.success == true) {
            debugPrint(
              '✅ Wishlist: Item removed successfully by ID, syncing from server...',
            );
            await _syncFromServer(groupId: groupId);
          } else {
            debugPrint(
              '⚠️ Wishlist: API returned success=false, syncing from server...',
            );
            await _syncFromServer(groupId: groupId);
          }
          return;
        } catch (e) {
          debugPrint('❌ Wishlist: deleteItemById failed: $e');
          // Fall through to try deleteItemByProduct
        }
      }

      // Fallback: DELETE by product_id + group_id (as per API definition)
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

        // Sync from server to get accurate state after removal
        if (response.success == true) {
          debugPrint(
            '✅ Wishlist: Item removed successfully by product, syncing from server...',
          );
          await _syncFromServer(groupId: groupId);
        } else {
          debugPrint(
            '⚠️ Wishlist: API returned success=false, syncing from server...',
          );
          await _syncFromServer(groupId: groupId);
        }
        return;
      } catch (e) {
        debugPrint('❌ Wishlist: deleteItemByProduct failed: $e');
        // Continue to sync from server anyway
      }

      // Final fallback: sync from server
      await _syncFromServer(groupId: groupId);
    } catch (e) {
      debugPrint('❌ Wishlist remove error: $e');
      // On error, sync from server to get accurate state
      try {
        await _syncFromServer(groupId: groupId);
      } catch (syncError) {
        debugPrint('❌ Wishlist sync error after remove failure: $syncError');
        // If sync fails, rollback removal
        final cur = state;
        if (cur is WishlistLoadedState) {
          // Check if item was actually removed
          if (!cur.items.any((w) => w.id == productId)) {
            // Item was removed, but we need to restore it if sync failed
            // Actually, we should keep the removed state since the local removal was successful
            // The sync will restore it if it still exists on server
            debugPrint('💡 Wishlist: Keeping local removal state');
          }
        }
      }
    }
  }

  Future<void> _addItemToCartFromWishlist(int productId) async {
    try {
      // Delegate to CartViewModel via DI
      final cartVm = GetIt.I<CartViewModel>();
      cartVm.addItemToCart(productId, quantity: 1);

      // Emit success message for the view to display
      final cur = state;
      if (cur is WishlistLoadedState) {
        emit(
          WishlistSuccessState(message: 'Added to cart', previousState: cur),
        );
      }
    } catch (e) {
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

  @override
  WishlistState? fromJson(Map<String, dynamic> json) =>
      WishlistLoadedState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(WishlistState state) =>
      state is WishlistLoadedState ? state.toJson() : null;
}
