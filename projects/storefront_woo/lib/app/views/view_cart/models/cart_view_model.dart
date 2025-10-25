/*
 * CartViewModel
 * -------------
 * ViewModel for the cart view following OSMEA architecture.
 * Uses Bloc pattern with events and states from core package.
 * Integrates with APIs package for cart operations.
 */

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:apis/network/remote/woocommerce/store_api/cart_api/abstract/cart_service.dart';
import 'package:core/core.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:storefront_woo/app/views/view_cart/models/module/states.dart';

@injectable
class CartViewModel extends BaseViewModelHydratedCubit<CartState> {
  CartViewModel() : super(CartInitialState());

  // Dependencies
  final CartService _cartService = GetIt.I<CartService>();
  final AssetConfigHelper _configHelper = AssetConfigHelper();

  // Public trigger functions - HydratedCubit pattern
  void loadCart() => _loadCart();
  void addItemToCart(int productId, {int quantity = 1}) =>
      _addItemToCart(productId, quantity);
  void removeItemFromCart(int productId) => _removeItemFromCart(productId);
  void updateItemQuantity(int productId, int quantity) =>
      _updateItemQuantity(productId, quantity);
  void clearCart() => _clearCart();
  void applyCoupon(String couponCode) => _applyCoupon(couponCode);
  void removeCoupon(String couponCode) => _removeCoupon(couponCode);

  // Private methods - HydratedCubit pattern
  Future<void> _loadCart() async {
    try {
      debugPrint('🛒 CartViewModel: _loadCart called');
      emit(CartLoadingState());

      // Directly call getCart API - WooCommerce handles cart token automatically
      debugPrint('🛒 CartViewModel: Loading cart from API');
      await _loadCartFromAPI();
    } catch (e) {
      debugPrint('🛒 CartViewModel: Error loading cart: $e');
      emit(CartErrorState(message: 'Failed to load cart: $e'));
    }
  }

  /// Load cart from WooCommerce API
  Future<void> _loadCartFromAPI() async {
    try {
      debugPrint('🛒 CartViewModel: Calling getCart API');

      final response = await _cartService.getCart(
        apiVersion: _configHelper.getString(
          'woocommerce_configuration.version',
        ),
        jwtToken: await _getJwtToken(), // Optional JWT token
      );

      if (response.errors != null && response.errors!.isNotEmpty) {
        debugPrint('🛒 CartViewModel: API error: ${response.errors!.first}');
        emit(
          CartErrorState(
            message: 'Failed to load cart from API: ${response.errors!.first}',
          ),
        );
        return;
      }

      // Process cart response
      await _processCartResponse(response);
    } catch (e) {
      debugPrint('🛒 CartViewModel: API error: $e');
      emit(CartErrorState(message: 'Failed to load cart: $e'));
    }
  }

  /// Process cart response from API
  Future<void> _processCartResponse(dynamic response) async {
    try {
      debugPrint('🛒 CartViewModel: Processing cart response...');
      debugPrint(
        '🛒 CartViewModel: Response items: ${response.items?.length ?? 0}',
      );
      debugPrint(
        '🛒 CartViewModel: Response totals: ${response.totals?.toJson()}',
      );

      // Extract and save cart token from response
      _extractAndSaveCartToken(response);

      // Convert API response to local cart items
      final cartItems = <CartItem>[];
      if (response.items != null) {
        debugPrint(
          '🛒 CartViewModel: Processing ${response.items!.length} items...',
        );
        for (final item in response.items!) {
          debugPrint(
            '🛒 CartViewModel: Item - ID: ${item.id}, Name: ${item.name}, Quantity: ${item.quantity}, Price: ${item.prices?.price}, Key: ${item.key}',
          );
          cartItems.add(
            CartItem(
              productId: item.id ?? 0,
              productName: item.name ?? '',
              quantity: item.quantity ?? 0,
              price: double.tryParse(item.prices?.price ?? '0') ?? 0.0,
              imageUrl: item.images?.isNotEmpty == true
                  ? item.images!.first.src
                  : null,
              key:
                  item.key ??
                  'cart_item_${item.id}_${DateTime.now().millisecondsSinceEpoch}',
            ),
          );
        }
      } else {
        debugPrint('🛒 CartViewModel: No items in response');
      }

      final totalPrice = response.totals?.totalPrice != null
          ? double.tryParse(response.totals!.totalPrice!) ?? 0.0
          : 0.0;

      // Extract currency information from API response totals
      final currencyCode =
          response.totals?.currencyCode?.toLowerCase() ??
          PriceInfoCurrencyHelper.currentCurrency;
      final currencySymbol =
          response.totals?.currencySymbol ??
          PriceInfoCurrencyHelper.getCurrencySymbol(currencyCode: currencyCode);

      debugPrint(
        '🛒 CartViewModel: API cart processed - items: ${cartItems.length}, total: $totalPrice, currency: $currencyCode ($currencySymbol)',
      );

      emit(
        CartLoadedState(
          cartItems: cartItems,
          totalPrice: totalPrice,
          totalItems: response.itemsCount ?? 0,
          coupons: response.coupons ?? [],
          shippingAddress: response.shippingAddress,
          billingAddress: response.billingAddress,
          currencyCode: currencyCode,
          currencySymbol: currencySymbol,
        ),
      );
    } catch (e) {
      debugPrint('🛒 CartViewModel: Error processing cart response: $e');
      emit(CartErrorState(message: 'Failed to process cart response: $e'));
    }
  }

  Future<void> _addItemToCart(int productId, int quantity) async {
    try {
      debugPrint(
        '🛒 CartViewModel: Adding item to cart: productId=$productId, quantity=$quantity',
      );

      // Directly call API - WooCommerce will handle cart token automatically
      await _addItemToAPI(productId, quantity);
    } catch (e) {
      debugPrint('🛒 CartViewModel: Error adding item: $e');
      emit(CartErrorState(message: 'Failed to add item: $e'));
    }
  }

  /// Add item to cart via API - WooCommerce handles cart token automatically
  Future<void> _addItemToAPI(int productId, int quantity) async {
    try {
      debugPrint(
        '🛒 CartViewModel: Calling addItem API: productId=$productId, quantity=$quantity',
      );

      final response = await _cartService.addItem(
        apiVersion: _configHelper.getString(
          'woocommerce_configuration.version',
        ),
        cartToken: await _getCartToken() ?? '',
        jwtToken: await _getJwtToken(), // Optional JWT token
        id: productId,
        quantity: quantity,
      );

      debugPrint(
        '🛒 CartViewModel: AddItem API response: ${response.toJson()}',
      );

      if (response.errors != null && response.errors!.isNotEmpty) {
        debugPrint('❌ API add item error: ${response.errors!.first}');
        emit(
          CartErrorState(
            message: 'Failed to add item: ${response.errors!.first}',
          ),
        );
        return;
      }

      debugPrint('✅ Successfully added item to API cart');

      // Show success message and keep current state
      final currentState = state;
      if (currentState is CartLoadedState) {
        // Just emit the same state to avoid UI issues
        emit(currentState);

        // Show success message via a different mechanism
        debugPrint('🎉 Success: Item added to cart successfully!');
      } else {
        // If no current state, load cart
        await _loadCart();
      }
    } catch (e) {
      debugPrint('❌ Failed to add item to API cart: $e');
      emit(CartErrorState(message: 'Failed to add item to cart: $e'));
    }
  }

  Future<void> _removeItemFromCart(int productId) async {
    try {
      debugPrint('🛒 CartViewModel: Removing item via API');
      await _removeItemFromAPI(productId);
    } catch (e) {
      debugPrint('🛒 CartViewModel: Error removing item: $e');
      emit(CartErrorState(message: 'Failed to remove item: $e'));
    }
  }

  Future<void> _updateItemQuantity(int productId, int quantity) async {
    try {
      debugPrint(
        '🛒 CartViewModel: _updateItemQuantity called - productId: $productId, quantity: $quantity',
      );
      debugPrint('🛒 CartViewModel: Updating quantity via API');
      await _updateItemQuantityFromAPI(productId, quantity);
    } catch (e) {
      debugPrint('🛒 CartViewModel: Error updating quantity: $e');
      emit(CartErrorState(message: 'Failed to update quantity: $e'));
    }
  }

  Future<void> _clearCart() async {
    try {
      debugPrint('🛒 CartViewModel: Clearing cart');
      // WooCommerce doesn't have a direct clear cart API
      // Show empty cart state
      emit(
        CartLoadedState(
          cartItems: [],
          totalPrice: 0.0,
          totalItems: 0,
          coupons: [],
          shippingAddress: null,
          billingAddress: null,
        ),
      );
    } catch (e) {
      debugPrint('🛒 CartViewModel: Error clearing cart: $e');
      emit(CartErrorState(message: 'Failed to clear cart: $e'));
    }
  }

  /// Remove item from cart via API
  Future<void> _removeItemFromAPI(int productId) async {
    try {
      // Find the item in current state to get its key
      final currentState = state;
      if (currentState is! CartLoadedState) {
        debugPrint('❌ Cannot remove item: cart not loaded');
        return;
      }

      final item = currentState.cartItems.firstWhere(
        (item) => item.productId == productId,
        orElse: () => throw Exception('Item not found in cart'),
      );

      debugPrint(
        '🛒 CartViewModel: Removing item via API with key: ${item.key}',
      );

      // Get cart token first
      final cartToken = await _getCartToken();
      if (cartToken == null || cartToken.isEmpty) {
        debugPrint('❌ No cart token available for removeItem');
        emit(CartErrorState(message: 'No cart token available'));
        return;
      }

      final response = await _cartService.removeItem(
        apiVersion: _configHelper.getString(
          'woocommerce_configuration.version',
        ),
        cartToken: cartToken,
        jwtToken: await _getJwtToken(),
        key: item.key,
      );

      if (response.errors != null && response.errors!.isNotEmpty) {
        debugPrint('❌ API remove item error: ${response.errors!.first}');
        emit(
          CartErrorState(
            message: 'Failed to remove item: ${response.errors!.first}',
          ),
        );
        return;
      }

      debugPrint('✅ Successfully removed item from API cart');

      // Show success message and keep current state
      final removeState = state;
      if (removeState is CartLoadedState) {
        // Just emit the same state to avoid UI issues
        emit(removeState);

        // Show success message via a different mechanism
        debugPrint('🎉 Success: Item removed from cart successfully!');
      } else {
        // If no current state, load cart
        await _loadCart();
      }
    } catch (e) {
      debugPrint('❌ Failed to remove item: $e');
      emit(CartErrorState(message: 'Failed to remove item: $e'));
    }
  }

  /// Update item quantity via API
  Future<void> _updateItemQuantityFromAPI(int productId, int quantity) async {
    try {
      debugPrint(
        '🛒 CartViewModel: _updateItemQuantityFromAPI called - productId: $productId, quantity: $quantity',
      );

      // Find the item in current state to get its key
      final currentState = state;
      if (currentState is! CartLoadedState) {
        debugPrint('❌ Cannot update quantity: cart not loaded');
        return;
      }

      final item = currentState.cartItems.firstWhere(
        (item) => item.productId == productId,
        orElse: () => throw Exception('Item not found in cart'),
      );

      debugPrint(
        '🛒 CartViewModel: Updating quantity via API with key: ${item.key}',
      );

      // Get cart token first
      final cartToken = await _getCartToken();
      if (cartToken == null || cartToken.isEmpty) {
        debugPrint('❌ No cart token available for updateItem');
        emit(CartErrorState(message: 'No cart token available'));
        return;
      }

      final response = await _cartService.updateItem(
        apiVersion: _configHelper.getString(
          'woocommerce_configuration.version',
        ),
        cartToken: cartToken,
        jwtToken: await _getJwtToken(),
        key: item.key,
        quantity: quantity,
      );

      if (response.errors != null && response.errors!.isNotEmpty) {
        debugPrint('❌ API update quantity error: ${response.errors!.first}');
        emit(
          CartErrorState(
            message: 'Failed to update quantity: ${response.errors!.first}',
          ),
        );
        return;
      }

      debugPrint('✅ Successfully updated quantity in API cart');

      // Show success message and keep current state
      final updateState = state;
      if (updateState is CartLoadedState) {
        // Just emit the same state to avoid UI issues
        emit(updateState);

        // Show success message via a different mechanism
        debugPrint('🎉 Success: Quantity updated successfully!');
      } else {
        // If no current state, load cart
        await _loadCart();
      }
    } catch (e) {
      debugPrint('❌ Failed to update quantity in API cart: $e');
      emit(CartErrorState(message: 'Failed to update quantity: $e'));
    }
  }

  Future<void> _applyCoupon(String couponCode) async {
    try {
      final currentState = state;
      if (currentState is! CartLoadedState) return;

      // Get cart token first
      final cartToken = await _getCartToken();
      if (cartToken == null || cartToken.isEmpty) {
        debugPrint('❌ No cart token available for applyCoupon');
        emit(CartErrorState(message: 'No cart token available'));
        return;
      }

      // Apply coupon via API
      final response = await _cartService.applyCoupon(
        apiVersion: _configHelper.getString(
          'woocommerce_configuration.version',
        ),
        cartToken: cartToken,
        jwtToken: await _getJwtToken(),
        code: couponCode,
      );

      if (response.errors != null && response.errors!.isNotEmpty) {
        emit(
          CartErrorState(
            message: 'Failed to apply coupon: ${response.errors!.first}',
          ),
        );
        return;
      }

      // Show success message and keep current state
      final applyState = state;
      if (applyState is CartLoadedState) {
        // Just emit the same state to avoid UI issues
        emit(applyState);

        // Show success message via a different mechanism
        debugPrint('🎉 Success: Coupon applied successfully!');
      } else {
        // If no current state, load cart
        await _loadCart();
      }
    } catch (e) {
      emit(CartErrorState(message: 'Failed to apply coupon: $e'));
    }
  }

  Future<void> _removeCoupon(String couponCode) async {
    try {
      final currentState = state;
      if (currentState is! CartLoadedState) return;

      // Get cart token first
      final cartToken = await _getCartToken();
      if (cartToken == null || cartToken.isEmpty) {
        debugPrint('❌ No cart token available for removeCoupon');
        emit(CartErrorState(message: 'No cart token available'));
        return;
      }

      // Remove coupon via API
      final response = await _cartService.removeCoupon(
        apiVersion: _configHelper.getString(
          'woocommerce_configuration.version',
        ),
        cartToken: cartToken,
        jwtToken: await _getJwtToken(),
        code: couponCode,
      );

      if (response.errors != null && response.errors!.isNotEmpty) {
        emit(
          CartErrorState(
            message: 'Failed to remove coupon: ${response.errors!.first}',
          ),
        );
        return;
      }

      // Show success message and keep current state
      final removeCouponState = state;
      if (removeCouponState is CartLoadedState) {
        // Just emit the same state to avoid UI issues
        emit(removeCouponState);

        // Show success message via a different mechanism
        debugPrint('🎉 Success: Coupon removed successfully!');
      } else {
        // If no current state, load cart
        await _loadCart();
      }
    } catch (e) {
      emit(CartErrorState(message: 'Failed to remove coupon: $e'));
    }
  }

  @override
  CartState? fromJson(Map<String, dynamic> json) {
    return null; // State will be reconstructed from API
  }

  @override
  Map<String, dynamic>? toJson(CartState state) {
    return null; // No need to persist cart state
  }

  /// Gets cart token from storage
  Future<String?> _getCartToken() async {
    try {
      // Cart token interceptor zaten storage'a kaydediyor, oradan okuyalım
      final storage = LocalStorageHelper();
      await storage.init();
      final token = await storage.getItem('woo_cart_token');
      debugPrint(
        '🛒 CartViewModel: Cart token from storage: ${token != null ? "Found (${token.toString().length} chars)" : "Not found"}',
      );
      return token?.toString();
    } catch (e) {
      debugPrint('❌ Failed to get cart token: $e');
      return null;
    }
  }

  /// Extract and save cart token from API response
  void _extractAndSaveCartToken(dynamic response) {
    try {
      // Cart token interceptor zaten response header'dan çıkarıp storage'a kaydediyor
      debugPrint(
        '🛒 CartViewModel: Cart token extraction - interceptor handles storage',
      );
    } catch (e) {
      debugPrint('❌ Failed to extract cart token: $e');
    }
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
