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
import 'package:apis/network/remote/woocommerce/store_api/cart_coupons_api/abstract/cart_coupons_service.dart';
import 'package:apis/network/remote/woocommerce/store_api/cart_coupons_api/freezed_model/response/list_cart_coupons_response_model.dart';
import 'package:core/core.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:storefront_woo/app/views/view_cart/models/module/states.dart';
import 'package:apis/apis.dart';

@injectable
class CartViewModel extends BaseViewModelHydratedCubit<CartState> {
  CartViewModel() : super(CartInitialState());

  // Dependencies
  final CartService _cartService = GetIt.I<CartService>();
  final CartCouponsService _cartCouponsService = GetIt.I<CartCouponsService>();
  final AssetConfigHelper _configHelper = AssetConfigHelper();

  // Arguments holder for route/widget inputs
  final Map<String, dynamic> _arguments = {};
  void setArguments(Map<String, dynamic> args) {
    _arguments
      ..clear()
      ..addAll(args);
  }

  Map<String, dynamic> get arguments => Map.unmodifiable(_arguments);

  // Public trigger functions - HydratedCubit pattern
  void loadCart({String? cartToken}) => _loadCart(cartToken: cartToken);
  void addItemToCart(int productId, {int quantity = 1}) =>
      _addItemToCart(productId, quantity);
  void removeItemFromCart(int productId) => _removeItemFromCart(productId);
  void updateItemQuantity(int productId, int quantity) =>
      _updateItemQuantity(productId, quantity);
  void clearCart() => _clearCart();
  void applyCoupon(String couponCode) => _applyCoupon(couponCode);
  void removeCoupon(String couponCode) => _removeCoupon(couponCode);

  // Private methods - HydratedCubit pattern
  Future<void> _loadCart({String? cartToken}) async {
    try {
      debugPrint('🛒 CartViewModel: _loadCart called');
      emit(CartLoadingState());

      // Get cart token from arguments or storage
      final token =
          cartToken ??
          (_arguments['cartToken'] as String?) ??
          await _getCartToken();

      debugPrint(
        '🛒 CartViewModel: Cart token from arguments: ${cartToken != null}',
      );
      debugPrint(
        '🛒 CartViewModel: Cart token from storage: ${token != null && token != cartToken}',
      );

      // Directly call getCart API - WooCommerce handles cart token automatically
      debugPrint('🛒 CartViewModel: Loading cart from API');
      await _loadCartFromAPI();
    } catch (e) {
      debugPrint('🛒 CartViewModel: Error loading cart: $e');
      emit(CartErrorState(message: ApiErrorUtils.getErrorMessage(e)));
    }
  }

  /// Load cart from WooCommerce API
  Future<void> _loadCartFromAPI() async {
    try {
      debugPrint('🛒 CartViewModel: Calling getCart API');

      // Log token status before API call
      final jwtToken = await _getJwtToken();
      final cartToken = await _getCartToken();
      debugPrint(
        '🛒 CartViewModel: getCart - JWT Token: ${jwtToken != null ? "Available" : "Not available"}',
      );
      debugPrint(
        '🛒 CartViewModel: getCart - Cart Token: ${cartToken != null ? "Available" : "Not available"}',
      );

      final response = await _cartService.getCart(
        apiVersion: _configHelper.getString(
          'woocommerce_configuration.version',
        ),
        jwtToken: jwtToken, // JWT token with Bearer prefix if authenticated
      );

      if (response.errors != null && response.errors!.isNotEmpty) {
        debugPrint('🛒 CartViewModel: API error: ${response.errors!.first}');
        emit(
          CartErrorState(
            message: ApiErrorUtils.getErrorMessage(response.errors!.first),
          ),
        );
        return;
      }

      // Process cart response
      await _processCartResponse(response);
    } catch (e) {
      debugPrint('🛒 CartViewModel: API error: $e');
      emit(CartErrorState(message: ApiErrorUtils.getErrorMessage(e)));
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

      // Note: Cart token is automatically extracted and saved by WooCartTokenInterceptor
      // No need to manually extract it here

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

          // Parse variation data from API response
          List<Map<String, String>>? variations;
          if (item.variation != null && item.variation!.isNotEmpty) {
            variations = [];
            for (final variationItem in item.variation!) {
              if (variationItem is Map<String, dynamic>) {
                final attribute = (variationItem['attribute'] ?? '').toString();
                final value = (variationItem['value'] ?? '').toString();
                if (attribute.isNotEmpty && value.isNotEmpty) {
                  variations.add({'attribute': attribute, 'value': value});
                }
              }
            }
            debugPrint('🛒 CartViewModel: Item variations: $variations');
          }

          cartItems.add(
            CartItem(
              productId: item.id ?? 0,
              productName: item.name ?? '',
              quantity: item.quantity ?? 0,
              price: double.tryParse(item.prices?.price ?? '0') ?? 0.0,
              imageUrl: item.images?.isNotEmpty == true
                  ? item.images!.first.src
                  : null,
              variations: variations,
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

      // Load coupons from cart coupons API
      List<ListCartCouponsResponseModel> coupons = [];
      try {
        coupons = await _cartCouponsService.getCartCoupons(
          apiVersion: _configHelper.getString(
            'woocommerce_configuration.version',
          ),
        );
        debugPrint('🛒 CartViewModel: Loaded ${coupons.length} coupons');
      } catch (e) {
        debugPrint('⚠️ CartViewModel: Failed to load coupons: $e');
        // Coupons loading failure is not fatal
      }

      debugPrint(
        '🛒 CartViewModel: API cart processed - items: ${cartItems.length}, total: $totalPrice, currency: $currencyCode ($currencySymbol), coupons: ${coupons.length}',
      );

      emit(
        CartLoadedState(
          cartItems: cartItems,
          totalPrice: totalPrice,
          totalItems: response.itemsCount ?? 0,
          coupons: coupons,
          shippingAddress: response.shippingAddress,
          billingAddress: response.billingAddress,
          currencyCode: currencyCode,
          currencySymbol: currencySymbol,
        ),
      );
    } catch (e) {
      debugPrint('🛒 CartViewModel: Error processing cart response: $e');
      emit(CartErrorState(message: ApiErrorUtils.getErrorMessage(e)));
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
      emit(CartErrorState(message: ApiErrorUtils.getErrorMessage(e)));
    }
  }

  /// Add item to cart via API - WooCommerce handles cart token automatically
  Future<void> _addItemToAPI(int productId, int quantity) async {
    try {
      debugPrint(
        '🛒 CartViewModel: Calling addItem API: productId=$productId, quantity=$quantity',
      );

      // Get tokens before API call
      String? cartToken = await _getCartToken();
      final jwtToken = await _getJwtToken();

      // Log token status
      debugPrint(
        '🛒 CartViewModel: addItem - JWT Token: ${jwtToken != null ? "Available (Bearer format)" : "Not available"}',
      );
      debugPrint(
        '🛒 CartViewModel: addItem - Cart Token: ${cartToken != null ? "Available" : "Not available"}',
      );

      // Ensure cart token exists; if not, initialize cart first
      if (cartToken == null || cartToken.isEmpty) {
        debugPrint(
          '🛒 CartViewModel: No cart token found. Initializing with getCart...',
        );
        await _cartService.getCart(
          apiVersion: _configHelper.getString(
            'woocommerce_configuration.version',
          ),
          jwtToken: jwtToken, // Use same JWT token for consistency
        );
        cartToken = await _getCartToken();
        debugPrint(
          '🛒 CartViewModel: Cart initialized with JWT: ${jwtToken != null ? "Yes" : "No"}',
        );
      }

      var response = await _cartService.addItem(
        apiVersion: _configHelper.getString(
          'woocommerce_configuration.version',
        ),
        cartToken: cartToken ?? '',
        jwtToken: jwtToken, // JWT token with Bearer prefix if authenticated
        id: productId,
        quantity: quantity,
      );

      debugPrint(
        '🛒 CartViewModel: AddItem API response: ${response.toJson()}',
      );

      if (response.errors != null && response.errors!.isNotEmpty) {
        debugPrint('❌ API add item error: ${response.errors!.first}');
        final errorText = response.errors!.first.toString().toLowerCase();
        if (errorText.contains('401') ||
            errorText.contains('unauthorized') ||
            errorText.contains('token')) {
          debugPrint(
            '🛒 CartViewModel: Retrying addItem after refreshing cart token',
          );
          final retryJwtToken = await _getJwtToken();
          await _cartService.getCart(
            apiVersion: _configHelper.getString(
              'woocommerce_configuration.version',
            ),
            jwtToken: retryJwtToken,
          );
          final refreshed = await _getCartToken();
          response = await _cartService.addItem(
            apiVersion: _configHelper.getString(
              'woocommerce_configuration.version',
            ),
            cartToken: refreshed ?? '',
            jwtToken: retryJwtToken, // Use same JWT token for consistency
            id: productId,
            quantity: quantity,
          );

          if (response.errors != null && response.errors!.isNotEmpty) {
            emit(
              CartErrorState(
                message: ApiErrorUtils.getErrorMessage(response.errors!.first),
              ),
            );
            return;
          }
        } else {
          emit(
            CartErrorState(
              message: ApiErrorUtils.getErrorMessage(response.errors!.first),
            ),
          );
          return;
        }
      }

      debugPrint('✅ Successfully added item to API cart');

      // Reload cart to get updated data from API
      await _loadCartFromAPI();
    } catch (e) {
      debugPrint('❌ Failed to add item to API cart: $e');
      emit(CartErrorState(message: ApiErrorUtils.getErrorMessage(e)));
    }
  }

  Future<void> _removeItemFromCart(int productId) async {
    try {
      debugPrint('🛒 CartViewModel: Removing item via API');
      await _removeItemFromAPI(productId);
    } catch (e) {
      debugPrint('🛒 CartViewModel: Error removing item: $e');
      emit(CartErrorState(message: ApiErrorUtils.getErrorMessage(e)));
    }
  }

  /// Remove item from cart via API
  Future<void> _removeItemFromAPI(int productId) async {
    try {
      debugPrint(
        '🛒 CartViewModel: Calling removeItem API: productId=$productId',
      );

      // Get tokens before API call
      final cartToken = await _getCartToken();
      final jwtToken = await _getJwtToken();

      // Log token status
      debugPrint(
        '🛒 CartViewModel: removeItem - JWT Token: ${jwtToken != null ? "Available (Bearer format)" : "Not available"}',
      );
      debugPrint(
        '🛒 CartViewModel: removeItem - Cart Token: ${cartToken != null ? "Available" : "Not available"}',
      );

      if (cartToken == null || cartToken.isEmpty) {
        debugPrint('❌ No cart token available for removeItem');
        emit(CartErrorState(message: 'No cart token available'));
        return;
      }

      // Find the cart item key for this product
      final currentState = state;
      if (currentState is! CartLoadedState) {
        debugPrint('❌ No cart loaded to remove item from');
        emit(CartErrorState(message: 'No cart loaded'));
        return;
      }

      // Find the item key for this product
      String? itemKey;
      for (final item in currentState.cartItems) {
        if (item.productId == productId) {
          itemKey = item.key;
          break;
        }
      }

      if (itemKey == null) {
        debugPrint('❌ Item not found in cart: $productId');
        emit(CartErrorState(message: 'Item not found in cart'));
        return;
      }

      debugPrint('🛒 CartViewModel: Removing item with key: $itemKey');

      final response = await _cartService.removeItem(
        apiVersion: _configHelper.getString(
          'woocommerce_configuration.version',
        ),
        cartToken: cartToken,
        jwtToken: jwtToken, // JWT token with Bearer prefix if authenticated
        key: itemKey,
      );

      debugPrint(
        '🛒 CartViewModel: RemoveItem API response: ${response.toJson()}',
      );

      if (response.errors != null && response.errors!.isNotEmpty) {
        debugPrint('❌ API remove item error: ${response.errors!.first}');
        emit(
          CartErrorState(
            message: ApiErrorUtils.getErrorMessage(response.errors!.first),
          ),
        );
        return;
      }

      debugPrint('✅ Successfully removed item from API cart');
      // Reload cart to get updated data from API
      await _loadCartFromAPI();
    } catch (e) {
      debugPrint('❌ Failed to remove item from API cart: $e');
      emit(CartErrorState(message: ApiErrorUtils.getErrorMessage(e)));
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
      emit(CartErrorState(message: ApiErrorUtils.getErrorMessage(e)));
    }
  }

  /// Update item quantity via API
  Future<void> _updateItemQuantityFromAPI(int productId, int quantity) async {
    try {
      debugPrint(
        '🛒 CartViewModel: Calling updateItem API: productId=$productId, quantity=$quantity',
      );

      // Get tokens before API call
      final cartToken = await _getCartToken();
      final jwtToken = await _getJwtToken();

      // Log token status
      debugPrint(
        '🛒 CartViewModel: updateItem - JWT Token: ${jwtToken != null ? "Available (Bearer format)" : "Not available"}',
      );
      debugPrint(
        '🛒 CartViewModel: updateItem - Cart Token: ${cartToken != null ? "Available" : "Not available"}',
      );

      // Find the cart item key for this product
      final currentState = state;
      if (currentState is! CartLoadedState) {
        debugPrint('❌ No cart loaded to update item in');
        emit(CartErrorState(message: 'No cart loaded'));
        return;
      }

      // Find the item key for this product
      String? itemKey;
      for (final item in currentState.cartItems) {
        if (item.productId == productId) {
          itemKey = item.key;
          break;
        }
      }

      if (itemKey == null) {
        debugPrint('❌ Item not found in cart: $productId');
        emit(CartErrorState(message: 'Item not found in cart'));
        return;
      }

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
        jwtToken: jwtToken, // JWT token with Bearer prefix if authenticated
        key: itemKey,
        quantity: quantity,
      );

      debugPrint(
        '🛒 CartViewModel: UpdateItem API response: ${response.toJson()}',
      );

      if (response.errors != null && response.errors!.isNotEmpty) {
        debugPrint('❌ API update item error: ${response.errors!.first}');
        emit(
          CartErrorState(
            message: ApiErrorUtils.getErrorMessage(response.errors!.first),
          ),
        );
        return;
      }

      debugPrint('✅ Successfully updated item in API cart');
      // Reload cart to get updated data from API
      await _loadCartFromAPI();
    } catch (e) {
      debugPrint('❌ Failed to update item in API cart: $e');
      emit(CartErrorState(message: ApiErrorUtils.getErrorMessage(e)));
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
      emit(CartErrorState(message: ApiErrorUtils.getErrorMessage(e)));
    }
  }

  /// Remove item from cart via API

  Future<void> _applyCoupon(String couponCode) async {
    try {
      final currentState = state;
      if (currentState is! CartLoadedState) {
        emit(CartErrorState(message: 'Please load your cart first'));
        return;
      }

      // Check if cart is empty
      if (currentState.cartItems.isEmpty) {
        emit(
          CartErrorState(
            message:
                'Your cart is empty. Add items to cart before applying a coupon.',
          ),
        );
        return;
      }

      if (couponCode.trim().isEmpty) {
        emit(CartErrorState(message: 'Please enter a coupon code'));
        return;
      }

      // Check if cart token exists
      final cartToken = await _getCartToken();
      if (cartToken == null || cartToken.isEmpty) {
        debugPrint(
          '⚠️ CartViewModel: No cart token available, loading cart first...',
        );
        await _loadCart();
        // Try again after loading cart
        final newCartToken = await _getCartToken();
        if (newCartToken == null || newCartToken.isEmpty) {
          emit(
            CartErrorState(message: 'Unable to load cart. Please try again.'),
          );
          return;
        }
      }

      debugPrint('🛒 CartViewModel: Applying coupon: $couponCode');
      debugPrint(
        '🛒 CartViewModel: Cart token available: ${cartToken != null && cartToken.isNotEmpty}',
      );
      debugPrint(
        '🛒 CartViewModel: Cart items count: ${currentState.cartItems.length}',
      );

      // Apply coupon via Cart Coupons API
      final response = await _cartCouponsService.addCartCoupon(
        apiVersion: _configHelper.getString(
          'woocommerce_configuration.version',
        ),
        couponCode: couponCode.trim(),
      );

      debugPrint(
        '🎉 CartViewModel: Coupon applied successfully: ${response.code}',
      );

      // Reload cart to get updated totals with coupon discount
      await _loadCart();
    } catch (e) {
      debugPrint('❌ CartViewModel: Failed to apply coupon: $e');
      emit(CartErrorState(message: _getCouponErrorMessage(e)));
    }
  }

  /// Get user-friendly error message for coupon operations
  /// Uses ApiErrorUtils from apis package for consistent error handling
  String _getCouponErrorMessage(dynamic error) {
    final errorString = error.toString().toLowerCase();

    // Get base error message from ApiErrorUtils
    final baseMessage = ApiErrorUtils.getErrorMessage(error);

    // Add coupon-specific error handling
    if (errorString.contains('400') || errorString.contains('bad request')) {
      if (errorString.contains('already') || errorString.contains('applied')) {
        return 'This coupon has already been applied';
      } else if (errorString.contains('invalid') ||
          errorString.contains('not found') ||
          errorString.contains('does not exist')) {
        return 'Invalid coupon code';
      } else if (errorString.contains('minimum') ||
          errorString.contains('amount')) {
        return 'Coupon requires minimum order amount';
      }
      return 'Invalid coupon code. Please check the code and try again.';
    } else if (errorString.contains('401') ||
        errorString.contains('unauthorized')) {
      return 'Please reload your cart and try again';
    } else if (errorString.contains('403') ||
        errorString.contains('forbidden')) {
      return 'Access denied. Please reload your cart';
    } else if (errorString.contains('404') ||
        errorString.contains('not found')) {
      return 'Coupon not found';
    } else if (errorString.contains('409') ||
        errorString.contains('conflict')) {
      return 'This coupon has already been applied';
    } else if (errorString.contains('422') ||
        errorString.contains('unprocessable')) {
      return 'Invalid coupon code or cart is empty';
    } else if (errorString.contains('already been applied') ||
        errorString.contains('already applied')) {
      return 'This coupon has already been applied';
    } else if (errorString.contains('invalid') ||
        errorString.contains('not found')) {
      return 'Invalid coupon code';
    } else {
      // Fallback to base message from ApiErrorUtils
      return baseMessage;
    }
  }

  Future<void> _removeCoupon(String couponCode) async {
    try {
      final currentState = state;
      if (currentState is! CartLoadedState) return;

      if (couponCode.trim().isEmpty) {
        emit(CartErrorState(message: 'Invalid coupon code'));
        return;
      }

      debugPrint('🛒 CartViewModel: Removing coupon: $couponCode');

      // Remove coupon via Cart Coupons API
      await _cartCouponsService.deleteCartCoupon(
        apiVersion: _configHelper.getString(
          'woocommerce_configuration.version',
        ),
        couponCode: couponCode.trim(),
      );

      debugPrint('🎉 CartViewModel: Coupon removed successfully');

      // Reload cart to get updated totals without coupon discount
      await _loadCart();
    } catch (e) {
      debugPrint('❌ CartViewModel: Failed to remove coupon: $e');
      emit(CartErrorState(message: ApiErrorUtils.getErrorMessage(e)));
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

  /// Gets cart token from arguments (route params) or storage
  /// Priority: arguments > storage
  /// Interceptor automatically adds token to request headers,
  /// but ViewModel needs token for direct API calls
  Future<String?> _getCartToken() async {
    try {
      // First try to get from arguments (route params)
      final argsToken = _arguments['cartToken'] as String?;
      if (argsToken != null && argsToken.isNotEmpty) {
        debugPrint('🛒 CartViewModel: Cart token from arguments');
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
          '🛒 CartViewModel: Cart token from storage: ${wooCartToken.cartToken.length > 20 ? wooCartToken.cartToken.substring(0, 20) + "..." : wooCartToken.cartToken}',
        );
        return wooCartToken.cartToken;
      }

      debugPrint('⚠️ CartViewModel: No cart token found');
      return null;
    } catch (e) {
      debugPrint('❌ Failed to get cart token: $e');
      return null;
    }
  }

  /// Gets JWT token from storage and formats it with Bearer prefix
  /// Uses WooJwtTokenStorage for consistency with other view models
  Future<String?> _getJwtToken() async {
    try {
      // Try to get JWT from WooJwtTokenStorage first (primary source)
      final wooToken = await WooJwtTokenStorage.loadToken();
      if (wooToken != null && !wooToken.isExpired) {
        final token =
            wooToken.authorizationHeader; // Already includes "Bearer " prefix
        debugPrint(
          '🛒 CartViewModel: JWT token from WooJwtTokenStorage: ${token.length > 30 ? "${token.substring(0, 30)}..." : token}',
        );
        return token;
      }

      // Fallback to AuthStorageHelper (legacy support)
      final authStorage = AuthStorageHelper();
      final token = await authStorage.getToken();
      if (token != null && token.isNotEmpty) {
        // Add Bearer prefix if not already present
        final formattedToken = token.startsWith('Bearer ')
            ? token
            : 'Bearer $token';
        debugPrint(
          '🛒 CartViewModel: JWT token from AuthStorageHelper: ${formattedToken.length > 30 ? "${formattedToken.substring(0, 30)}..." : formattedToken}',
        );
        return formattedToken;
      }

      debugPrint('⚠️ CartViewModel: No JWT token found in storage');
      return null;
    } catch (e) {
      debugPrint('❌ Failed to get JWT token: $e');
      return null;
    }
  }
}
