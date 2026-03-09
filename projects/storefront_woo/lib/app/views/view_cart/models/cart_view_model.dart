/*
 * CartViewModel
 * -------------
 * ViewModel for the cart view following OSMEA architecture.
 * Uses Bloc pattern with events and states from core package.
 * Integrates with APIs package for cart operations.
 */

import 'dart:async';
import 'package:apis/network/remote/woocommerce/wishlist/abstract/woo_wishlist_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:apis/network/remote/woocommerce/store_api/cart_api/abstract/cart_service.dart';
import 'package:apis/network/remote/woocommerce/store_api/cart_coupons_api/abstract/cart_coupons_service.dart';
import 'package:apis/network/remote/woocommerce/store_api/cart_coupons_api/freezed_model/response/list_cart_coupons_response_model.dart';
import 'package:apis/network/remote/woocommerce/wishlist/freezed_model/request/add_wishlist_item_request.dart';
import 'package:core/core.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:storefront_woo/app/views/view_cart/models/module/states.dart';
import 'package:storefront_woo/app/views/view_wishlist/models/wishlist_view_model.dart';
import 'package:apis/apis.dart';
import 'package:storefront_woo/gen/translations.g.dart';

@injectable
class CartViewModel extends BaseViewModelHydratedCubit<CartState> {
  CartViewModel() : super(CartInitialState());

  // Dependencies
  final CartService _cartService = GetIt.I<CartService>();
  final CartCouponsService _cartCouponsService = GetIt.I<CartCouponsService>();
  final WooWishlistService _wishlistService = GetIt.I<WooWishlistService>();
  final WishlistViewModel _wishlistViewModel = GetIt.I<WishlistViewModel>();
  final AssetConfigHelper _configHelper = AssetConfigHelper();
  
  // Wishlist API configuration - get from config like WishlistViewModel
  String get _wishlistNamespace {
    return _configHelper.getString(
      'woocommerce_configuration.wishlist_namespace',
      'masterfabric',
    );
  }

  String get _wishlistApiVersion {
    return _configHelper.getString(
      'woocommerce_configuration.version',
      'v1',
    );
  }

  // Track last loaded state to show overlay during updates
  CartLoadedState? _lastLoadedState;
  CartLoadedState? get lastLoadedState => _lastLoadedState;

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
  Future<void> refreshCart({String? cartToken}) async =>
      await _loadCart(cartToken: cartToken);
  Future<void> addItemToCart(int productId, {int quantity = 1}) =>
      _addItemToCart(productId, quantity);
  void removeItemFromCart(int productId, {BuildContext? context}) {
    if (context != null) {
      _showRemoveConfirmationDialog(context, productId);
    } else {
      _removeItemFromCart(productId);
    }
  }

  /// Get dialog color from config
  Color _getDialogColorFromConfig(String key, Color fallback) {
    try {
      final colorString = _configHelper.getString(
        'dialog_popup_configuration.$key',
      );
      if (colorString.isNotEmpty && colorString.startsWith('#')) {
        final hexString = colorString.substring(1);
        if (hexString.length == 6) {
          return Color(int.parse('FF$hexString', radix: 16));
        } else if (hexString.length == 8) {
          return Color(int.parse(hexString, radix: 16));
        }
      }
    } catch (e) {
      debugPrint('⚠️ Failed to load dialog color $key: $e');
    }
    return fallback;
  }

  /// Get popup button color from config (same as wishlist)
  Color _getPopupButtonColorFromConfig(String key, Color fallback) {
    try {
      final colorString = _configHelper.getString(
        'dialog_popup_configuration.buttons.$key',
      );
      if (colorString.isNotEmpty && colorString.startsWith('#')) {
        final hexString = colorString.substring(1);
        if (hexString.length == 6) {
          return Color(int.parse('FF$hexString', radix: 16));
        } else if (hexString.length == 8) {
          return Color(int.parse(hexString, radix: 16));
        }
      }
    } catch (e) {
      debugPrint('⚠️ Failed to load popup button color $key: $e');
    }
    return fallback;
  }

  /// Show confirmation dialog before removing item (wishlist-style popup)
  Future<void> _showRemoveConfirmationDialog(
    BuildContext context,
    int productId,
  ) async {
    // Get product name for the dialog
    final currentState = state;
    String productName = 'this item';
    if (currentState is CartLoadedState) {
      try {
        final item = currentState.cartItems.firstWhere(
          (item) => item.productId == productId,
        );
        productName = item.productName;
      } catch (e) {
        debugPrint('⚠️ Item not found in cart: $e');
      }
    }

    // Check if user is logged in (has valid JWT token)
    final jwtToken = await _getJwtToken();
    final isLoggedIn = jwtToken != null && jwtToken.isNotEmpty;

    // Check if item is already in wishlist (BEFORE showing popup)
    bool isInWishlist = false;
    if (isLoggedIn) {
      try {
        // Ensure wishlist is synced before checking
        await _wishlistViewModel.syncFromServer();
        isInWishlist = _wishlistViewModel.isSaved(productId);
        debugPrint('💖 Cart: Product $productId is ${isInWishlist ? "already" : "not"} in wishlist');
      } catch (e) {
        debugPrint('⚠️ Cart: Failed to check wishlist status: $e');
        // Continue with popup even if check fails
      }
    }

    // Get popup colors from config
    final popupBgColor = _getDialogColorFromConfig(
      'popup.backgroundColor',
      OsmeaColors.white,
    );
    final popupTitleColor = _getDialogColorFromConfig(
      'popup.titleColor',
      const Color(0xFF1976D2),
    );
    final popupSubtitleColor = _getDialogColorFromConfig(
      'popup.subtitleColor',
      OsmeaColors.grayMaterial[400]!,
    );
    final popupElevation = _configHelper.getDouble(
      'dialog_popup_configuration.popup.elevation',
      8.0,
    );

    // Build popup buttons based on login status and wishlist status
    List<Widget> popupButtons = [];
    
    // Only show "Remove & save for later" button if user is logged in AND item is NOT already in wishlist
    if (isLoggedIn && !isInWishlist) {
      popupButtons.add(
        OsmeaComponents.row(
          children: [
            OsmeaComponents.expanded(
              child: Builder(
                builder: (context) {
                  final primaryBgColor = _getPopupButtonColorFromConfig(
                    'primary.backgroundColor',
                    OsmeaColors.black,
                  );
                  final primaryTextColor = _getPopupButtonColorFromConfig(
                    'primary.textColor',
                    OsmeaColors.white,
                  );

                  return OsmeaComponents.button(
                    text: 'Remove & save for later',
                    variant: ButtonVariant.primary,
                    backgroundColor: primaryBgColor,
                    textColor: primaryTextColor,
                    onPressed: () {
                      Navigator.of(context).pop('save_later');
                    },
                  );
                },
              ),
            ),
          ],
        ),
      );
      popupButtons.add(OsmeaComponents.sizedBox(height: context.spacing8));
    }

    // "Just remove" button (or "Remove" if not logged in - make it primary)
    popupButtons.add(
      OsmeaComponents.row(
        children: [
          OsmeaComponents.expanded(
            child: Builder(
              builder: (context) {
                if (isLoggedIn) {
                  // Secondary button style when logged in
                  final secondaryBgColor = _getPopupButtonColorFromConfig(
                    'secondary.backgroundColor',
                    OsmeaColors.white,
                  );
                  final secondaryTextColor = _getPopupButtonColorFromConfig(
                    'secondary.textColor',
                    OsmeaColors.black,
                  );
                  final secondaryBorderColor = _getPopupButtonColorFromConfig(
                    'secondary.borderColor',
                    OsmeaColors.black,
                  );

                  return OsmeaComponents.button(
                    text: 'Just remove',
                    variant: ButtonVariant.outlined,
                    backgroundColor: secondaryBgColor,
                    textColor: secondaryTextColor,
                    borderColor: secondaryBorderColor,
                    onPressed: () {
                      Navigator.of(context).pop('remove_only');
                    },
                  );
                } else {
                  // Primary button style when not logged in
                  final primaryBgColor = _getPopupButtonColorFromConfig(
                    'primary.backgroundColor',
                    OsmeaColors.black,
                  );
                  final primaryTextColor = _getPopupButtonColorFromConfig(
                    'primary.textColor',
                    OsmeaColors.white,
                  );

                  return OsmeaComponents.button(
                    text: 'Remove',
                    variant: ButtonVariant.primary,
                    backgroundColor: primaryBgColor,
                    textColor: primaryTextColor,
                    onPressed: () {
                      Navigator.of(context).pop('remove_only');
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
    popupButtons.add(OsmeaComponents.sizedBox(height: context.spacing8));

    // Cancel button
    popupButtons.add(
      Builder(
        builder: (context) {
          final ghostTextColor = _getPopupButtonColorFromConfig(
            'ghost.textColor',
            OsmeaColors.black,
          );

          return OsmeaComponents.button(
            text: 'Cancel',
            variant: ButtonVariant.ghost,
            textColor: ghostTextColor,
            onPressed: () => Navigator.of(context).pop('cancel'),
          );
        },
      ),
    );

    // Build subtitle based on wishlist status
    String subtitle;
    if (isLoggedIn) {
      if (isInWishlist) {
        subtitle = '"$productName" is already saved in your favorites. Would you like to remove it from your cart?';
      } else {
        subtitle = 'Would you like to save "$productName" for later or remove it from your cart?';
      }
    } else {
      subtitle = 'Are you sure you want to remove "$productName" from your cart?';
    }

    // Show popup and wait for result
    final result = await OsmeaComponents.showPopup<String>(
      context: context,
      variant: PopupVariant.dialog,
      title: 'Remove from cart?',
      subtitle: subtitle,
      backgroundColor: popupBgColor,
      titleStyle: OsmeaTextStyle.titleMedium(context).copyWith(
        color: popupTitleColor,
        fontWeight: FontWeight.w600,
      ),
      subtitleStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
        color: popupSubtitleColor,
      ),
      elevation: popupElevation,
      padding: EdgeInsets.all(context.spacing16),
      child: OsmeaComponents.column(
        mainAxisSize: MainAxisSize.min,
        children: popupButtons,
      ),
    );

    // Handle result after popup is closed - execute query based on selection
    if (result == 'save_later') {
      // Add to wishlist and remove from cart (query will be executed in _addToWishlistAndRemove)
      await _addToWishlistAndRemove(context, productId);
    } else if (result == 'remove_only') {
      // Just remove from cart (query will be executed in _removeItemFromCart)
      await _removeItemFromCart(productId);
    }
  }

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

          // Parse price using PriceInfoCurrencyHelper to handle formatted strings
          // Use API-provided separators and minor_unit to correctly parse the price format
          final itemPrice = item.prices?.price != null
              ? PriceInfoCurrencyHelper.parsePriceToDouble(
                      item.prices!.price!,
                      currencyCode: item.prices?.currencyCode,
                      currencyDecimalSeparator:
                          item.prices?.currencyDecimalSeparator,
                      currencyThousandSeparator:
                          item.prices?.currencyThousandSeparator,
                      currencyMinorUnit: item.prices?.currencyMinorUnit,
                    ) ??
                    0.0
              : 0.0;

          cartItems.add(
            CartItem(
              productId: item.id ?? 0,
              productName: item.name ?? '',
              quantity: item.quantity ?? 0,
              price: itemPrice,
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

      // Extract currency information from API response totals first
      final currencyCode =
          response.totals?.currencyCode?.toLowerCase() ??
          PriceInfoCurrencyHelper.currentCurrency;

      // Parse total price using PriceInfoCurrencyHelper to handle formatted strings
      // Use API-provided separators and minor_unit from totals if available
      final totalPrice = response.totals?.totalPrice != null
          ? PriceInfoCurrencyHelper.parsePriceToDouble(
                  response.totals!.totalPrice!,
                  currencyCode: currencyCode,
                  currencyDecimalSeparator:
                      response.totals?.currencyDecimalSeparator,
                  currencyThousandSeparator:
                      response.totals?.currencyThousandSeparator,
                  currencyMinorUnit: response.totals?.currencyMinorUnit,
                ) ??
                0.0
          : 0.0;
      final currencySymbol =
          response.totals?.currencySymbol ??
          PriceInfoCurrencyHelper.getCurrencySymbol(currencyCode: currencyCode);

      // Extract currency formatting info from API response totals
      final currencyDecimalSeparator =
          response.totals?.currencyDecimalSeparator;
      final currencyThousandSeparator =
          response.totals?.currencyThousandSeparator;
      final currencyMinorUnit = response.totals?.currencyMinorUnit;

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

      final loadedState = CartLoadedState(
        cartItems: cartItems,
        totalPrice: totalPrice,
        totalItems: response.itemsCount ?? 0,
        coupons: coupons,
        shippingAddress: response.shippingAddress,
        billingAddress: response.billingAddress,
        currencyCode: currencyCode,
        currencySymbol: currencySymbol,
        currencyDecimalSeparator: currencyDecimalSeparator,
        currencyThousandSeparator: currencyThousandSeparator,
        currencyMinorUnit: currencyMinorUnit,
      );

      // Track last loaded state for overlay during updates
      _lastLoadedState = loadedState;
      emit(loadedState);
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

      // Use empty string if cart token is null - API will handle it
      // Don't call getCart() here as it causes nonce issues with JWT
      // Only pass jwtToken if it's not null - interceptor will handle it if null
      var response = await _cartService.addItem(
        apiVersion: _configHelper.getString(
          'woocommerce_configuration.version',
        ),
        cartToken: cartToken ?? '',
        jwtToken:
            jwtToken, // JWT token with Bearer prefix if authenticated, null otherwise (interceptor will add it)
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
            message: ApiErrorUtils.getErrorMessage(response.errors!.first),
          ),
        );
        return;
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

      // Get the current state BEFORE emitting loading state
      final currentState = state;
      CartLoadedState? loadedState;
      if (currentState is CartLoadedState) {
        loadedState = currentState;
      } else if (_lastLoadedState != null) {
        // Use last loaded state if current state is not loaded
        loadedState = _lastLoadedState;
      }

      if (loadedState == null) {
        debugPrint('❌ No cart loaded to remove item from');
        emit(CartErrorState(message: t.cartView.messages.noCartLoaded));
        return;
      }

      // Emit loading state to show overlay (after we've saved the loaded state)
      emit(CartLoadingState());

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
        emit(CartErrorState(message: t.cartView.messages.noCartToken));
        return;
      }

      // Find the item key for this product
      String? itemKey;
      for (final item in loadedState.cartItems) {
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
      
      // Save current loaded state before showing loading
      if (state is CartLoadedState) {
        _lastLoadedState = state as CartLoadedState;
      }
      
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

      // Get the current loaded state
      final currentState = state;
      CartLoadedState? loadedState;
      if (currentState is CartLoadedState) {
        loadedState = currentState;
      } else if (_lastLoadedState != null) {
        loadedState = _lastLoadedState;
      }

      if (loadedState == null) {
        debugPrint('❌ No cart loaded to update item in');
        emit(CartErrorState(message: t.cartView.messages.noCartLoaded));
        return;
      }

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

      // Find the item key for this product
      String? itemKey;
      for (final item in loadedState.cartItems) {
        if (item.productId == productId) {
          itemKey = item.key;
          break;
        }
      }

      if (itemKey == null) {
        debugPrint('❌ Item not found in cart: $productId');
        emit(CartErrorState(message: t.cartView.messages.itemNotFound));
        return;
      }

      if (cartToken == null || cartToken.isEmpty) {
        debugPrint('❌ No cart token available for updateItem');
        emit(CartErrorState(message: t.cartView.messages.noCartToken));
        return;
      }

      // Show loading state with updatingProductId - this will show spinner on that item
      // Also update the quantity optimistically
      final updatedItems = loadedState.cartItems.map((item) {
        if (item.productId == productId) {
          return item.copyWith(quantity: quantity);
        }
        return item;
      }).toList();

      // Calculate new total items count
      int newTotalItems = 0;
      double newTotal = 0.0;
      for (final item in updatedItems) {
        newTotalItems += item.quantity;
        newTotal += item.price * item.quantity;
      }

      // Emit state with loading indicator and updated counts
      final updatingState = loadedState.copyWith(
        cartItems: updatedItems,
        totalPrice: newTotal,
        totalItems: newTotalItems,
        updatingProductId: productId,
      );
      _lastLoadedState = updatingState;
      emit(updatingState);

      // Make API call in background
      final response = await _cartService.updateItem(
        apiVersion: _configHelper.getString(
          'woocommerce_configuration.version',
        ),
        cartToken: cartToken,
        jwtToken: jwtToken,
        key: itemKey,
        quantity: quantity,
      );

      debugPrint(
        '🛒 CartViewModel: UpdateItem API response: ${response.toJson()}',
      );

      if (response.errors != null && response.errors!.isNotEmpty) {
        debugPrint('❌ API update item error: ${response.errors!.first}');
        // Revert to previous state on error (without updatingProductId)
        final revertedState = loadedState.copyWith(clearUpdatingProductId: true);
        _lastLoadedState = revertedState;
        emit(revertedState);
        emit(
          CartErrorState(
            message: ApiErrorUtils.getErrorMessage(response.errors!.first),
          ),
        );
        return;
      }

      debugPrint('✅ Successfully updated item in API cart');
      
      // Clear updating indicator
      final finalState = updatingState.copyWith(clearUpdatingProductId: true);
      _lastLoadedState = finalState;
      emit(finalState);
    } catch (e) {
      debugPrint('❌ Failed to update item in API cart: $e');
      
      // Restore last loaded state on error (without updatingProductId)
      if (_lastLoadedState != null) {
        final errorState = _lastLoadedState!.copyWith(clearUpdatingProductId: true);
        emit(errorState);
      }
      emit(CartErrorState(message: ApiErrorUtils.getErrorMessage(e)));
    }
  }

  Future<void> _clearCart() async {
    try {
      debugPrint('🛒 CartViewModel: Clearing cart');
      // WooCommerce doesn't have a direct clear cart API
      // Show empty cart state
      final loadedState = CartLoadedState(
        cartItems: [],
        totalPrice: 0.0,
        totalItems: 0,
        coupons: [],
        shippingAddress: null,
        billingAddress: null,
      );

      // Track last loaded state for overlay during updates
      _lastLoadedState = loadedState;
      emit(loadedState);
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
  Future<void> close() {
    return super.close();
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

  /// Add item to wishlist and then remove from cart
  Future<void> _addToWishlistAndRemove(BuildContext context, int productId) async {
    try {
      // Get product name for the success message
      final currentState = state;
      String productName = 'Item';
      if (currentState is CartLoadedState) {
        try {
          final item = currentState.cartItems.firstWhere(
            (item) => item.productId == productId,
          );
          productName = item.productName;
        } catch (e) {
          debugPrint('⚠️ Could not find product name for productId: $productId');
        }
      }

      debugPrint('💖 Adding product $productId to wishlist from cart');
      
      // Add to wishlist
      final response = await _wishlistService.addItemToWishlist(
        namespace: _wishlistNamespace,
        apiVersion: _wishlistApiVersion,
        request: AddWishlistItemRequest(
          productId: productId,
          groupId: 0, // Default group
          quantity: 1,
        ),
      );

      debugPrint('💖 Wishlist API response: success=${response.success}, message=${response.message}');

      // Check if operation was successful or item already in wishlist
      final message = response.message?.toLowerCase() ?? '';
      final isAlreadyInWishlist = message.contains('already in wishlist') ||
          message.contains('already exists') ||
          message.contains('already added');

      if (response.success == true || isAlreadyInWishlist) {
        // Successfully added or already in wishlist - now remove from cart
        await _removeItemFromCart(productId);
        
        // Show success message
        if (context.mounted) {
          context.snackbarSuccess(
            '$productName moved to your favorites',
            duration: context.durationNormal,
          );
        }
      } else {
        // Failed to add to wishlist
        debugPrint('❌ Failed to add to wishlist: ${response.message}');
        if (context.mounted) {
          context.snackbarError(
            'Failed to save to favorites',
            duration: context.durationNormal,
          );
        }
      }
    } catch (e) {
      debugPrint('❌ Error adding to wishlist: $e');
      if (context.mounted) {
        context.snackbarError(
          'Failed to save to favorites',
          duration: context.durationNormal,
        );
      }
    }
  }

}
