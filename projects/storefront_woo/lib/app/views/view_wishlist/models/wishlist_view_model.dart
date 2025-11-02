import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:apis/network/remote/woocommerce/wishlist/abstract/woo_wishlist_service.dart';
import 'package:apis/network/remote/woocommerce/wishlist/freezed_model/request/add_wishlist_item_request.dart';
import 'package:apis/network/remote/woocommerce/wishlist/freezed_model/request/delete_wishlist_item_request.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_api/abstract/product_service.dart';
import 'package:storefront_woo/app/views/view_wishlist/models/module/states.dart';
import 'package:storefront_woo/app/views/view_cart/models/cart_view_model.dart';

/// Lightweight DTO persisted for wishlist items
class WishlistItem {
  final int id;
  final String? name;
  final String? imageUrl;
  final String? regularPrice;
  final String? salePrice;
  final String? currencyCode;
  final bool onSale;

  const WishlistItem({
    required this.id,
    this.name,
    this.imageUrl,
    this.regularPrice,
    this.salePrice,
    this.currencyCode,
    this.onSale = false,
  });

  factory WishlistItem.fromJson(Map<String, dynamic> json) => WishlistItem(
    id: json['id'] as int,
    name: json['name'] as String?,
    imageUrl: json['imageUrl'] as String?,
    regularPrice: json['regularPrice'] as String?,
    salePrice: json['salePrice'] as String?,
    currencyCode: json['currencyCode'] as String?,
    onSale: (json['onSale'] as bool?) ?? false,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
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
      final paged = await _wishlistService.getWishlistItems(
        apiVersion: apiVersion,
        groupId: groupId,
        page: 1,
        perPage: 100,
      );

      final wishlistItems = paged.data ?? [];
      final mapped = <WishlistItem>[];

      // Process each wishlist item and fetch product details if needed
      for (final w in wishlistItems) {
        final productId = w.productId ?? 0;
        if (productId == 0) continue;

        // Check if product details are missing from wishlist response
        final hasProductDetails =
            w.productName != null &&
            w.productName!.isNotEmpty &&
            w.productImage != null &&
            w.productImage!.isNotEmpty;

        if (hasProductDetails) {
          // Use data from wishlist response
          mapped.add(
            WishlistItem(
              id: productId,
              name: w.productName,
              imageUrl: w.productImage,
              regularPrice: w.productPrice,
              salePrice: null,
              currencyCode: null,
              onSale: false,
            ),
          );
        } else {
          // Fetch product details from ProductService
          try {
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
                name: product.name,
                imageUrl: imageUrl,
                regularPrice: regularPrice,
                salePrice: salePrice,
                currencyCode: currencyCode,
                onSale: product.onSale ?? false,
              ),
            );
          } catch (e) {
            debugPrint('❌ Failed to fetch product $productId: $e');
            // Use partial data from wishlist if available
            mapped.add(
              WishlistItem(
                id: productId,
                name: w.productName ?? 'Product',
                imageUrl: w.productImage,
                regularPrice: w.productPrice,
                salePrice: null,
                currencyCode: null,
                onSale: false,
              ),
            );
          }
        }
      }

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
      final s = state;
      final items = s is WishlistLoadedState ? [...s.items, item] : [item];
      emit(WishlistLoadedState(items: items));

      // Sync with server only if authenticated
      final jwt = await _getJwtToken();
      if (jwt == null || jwt.isEmpty) {
        debugPrint('💡 Wishlist: unauthenticated add -> local only');
        return;
      }

      final apiVersion = _config.getString(
        'woocommerce_configuration.version',
        'v1',
      );
      await _wishlistService.addItemToWishlist(
        apiVersion: apiVersion,
        request: AddWishlistItemRequest(
          productId: item.id,
          groupId: groupId ?? 0,
        ),
      );
    } catch (e) {
      debugPrint('❌ Wishlist add error: $e');
      // Keep local state; avoid throwing user to error screen for wishlist
      final cur = state;
      if (cur is WishlistLoadedState) {
        final rolledBack = cur.items.where((w) => w.id != item.id).toList();
        emit(WishlistLoadedState(items: rolledBack));
      }
    }
  }

  Future<void> _remove(int productId, {int? groupId}) async {
    try {
      final s = state;
      final items = s is WishlistLoadedState
          ? s.items.where((e) => e.id != productId).toList()
          : const <WishlistItem>[];
      emit(WishlistLoadedState(items: items));

      final jwt = await _getJwtToken();
      if (jwt == null || jwt.isEmpty) {
        debugPrint('💡 Wishlist: unauthenticated remove -> local only');
        return;
      }

      final apiVersion = _config.getString(
        'woocommerce_configuration.version',
        'v1',
      );
      await _wishlistService.deleteItemByProduct(
        apiVersion: apiVersion,
        request: DeleteWishlistItemRequest(
          productId: productId,
          groupId: groupId ?? 0,
        ),
      );
    } catch (e) {
      debugPrint('❌ Wishlist remove error: $e');
      // Rollback removal on failure
      final cur = state;
      if (cur is WishlistLoadedState) {
        emit(WishlistLoadedState(items: [...cur.items]));
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
