import 'dart:async';
import 'package:core/core.dart' hide BuildContextTranslationsExtension, AppLocaleUtils, LocaleSettings, TranslationProvider;
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:storefront_supabase/app/core/cart/cart_cache.dart';
import 'package:storefront_supabase/app/core/cart/guest_cart_storage.dart';
import 'package:storefront_supabase/app/models/product.dart';
import 'package:storefront_supabase/app/views/view_cart/models/states.dart';

const String _kGuestCartItemIdPrefix = 'guest_';

@injectable
class CartViewModel extends BaseViewModelCubit<CartState> {
  final SupabaseClient _supabaseClient;
  final CartCache _cartCache;
  final GuestCartStorage _guestCartStorage;

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

  CartViewModel(this._supabaseClient, this._cartCache, this._guestCartStorage) : super(CartInitialState());

  // Public trigger functions
  Future<void> initial({String? cartToken}) async => _loadCart(); 
  Future<void> refreshCart() async => _loadCart();
  /// Returns true if item was added (guest: local; logged-in: Supabase).
  Future<bool> addItemToCart(String productId, {int quantity = 1, String? variantId}) async => _addItemToCart(productId, quantity, variantId);
  void removeItemFromCart(String cartItemId, {BuildContext? context}) { 
    if (context != null) {
      _showRemoveConfirmationDialog(context, cartItemId);
    } else {
      _removeItemFromCart(cartItemId);
    }
  }
  void updateItemQuantity(String cartItemId, int newQuantity) => _updateItemQuantity(cartItemId, newQuantity);
  void clearCart() => _clearCart();
  Future<void> applyCoupon(String couponCode) async {} 
  Future<void> removeCoupon(String couponCode) async {} 

  // Private methods
  Future<void> _loadCart() async {
    try {
      emit(CartLoadingState(previousState: _lastLoadedState)); 

      final userId = _supabaseClient.auth.currentUser?.id;
      if (userId == null) {
        await _loadGuestCart();
        return;
      }
      // Giriş yapıldıysa önce misafir sepetini Supabase'e merge et
      final guestItems = await _guestCartStorage.getItems();
      if (guestItems.isNotEmpty) {
        for (final entry in guestItems) {
          try {
            var query = _supabaseClient
                .from('cart')
                .select('id, quantity')
                .eq('user_id', userId)
                .eq('product_id', entry.productId);
            if (entry.variantId != null) {
              query = query.eq('variant_id', entry.variantId!);
            } else {
              query = query.isFilter('variant_id', null);
            }
            final existing = await query.maybeSingle();
            if (existing != null) {
              final newQty = (existing['quantity'] as int) + entry.quantity;
              await _supabaseClient.from('cart').update({'quantity': newQty}).eq('id', existing['id']);
            } else {
              await _supabaseClient.from('cart').insert({
                'product_id': entry.productId,
                if (entry.variantId != null) 'variant_id': entry.variantId,
                'quantity': entry.quantity,
              });
            }
          } catch (_) {}
        }
        await _guestCartStorage.clear();
      }

      final response = await _supabaseClient
          .from('cart')
          .select('id, quantity, variant_id, products(*, product_images(*))')
          .eq('user_id', userId);

      final cartItems = <CartItem>[];
      for (final itemData in (response as List)) {
        if (itemData['products'] != null) {
          final product = Product.fromJson(itemData['products'] as Map<String, dynamic>);
          cartItems.add(CartItem(
            id: itemData['id'] as String,
            quantity: itemData['quantity'] as int,
            product: product,
            variantId: _variantIdFromJson(itemData['variant_id']),
          ));
        }
      }

      _cartCache.setCartForUser(userId, cartItems);

      double totalPrice = cartItems.fold(0.0, (sum, item) => sum + item.product.effectivePrice * item.quantity);
      int totalItems = cartItems.fold(0, (sum, item) => sum + item.quantity);

      final loadedState = CartLoadedState(
        cartItems: cartItems,
        totalPrice: totalPrice,
        totalItems: totalItems,
        currencyCode: 'USD', 
        currencySymbol: '\$',
      );

      _lastLoadedState = loadedState;
      emit(loadedState);
    } catch (e) {
      emit(CartErrorState(message: 'Failed to load cart: $e', previousState: _lastLoadedState));
    }
  }

  Future<void> _loadGuestCart() async {
    final entries = await _guestCartStorage.getItems();
    if (entries.isEmpty) {
      _lastLoadedState = CartLoadedState(cartItems: [], totalPrice: 0, totalItems: 0, currencyCode: 'USD', currencySymbol: '\$');
      emit(_lastLoadedState!);
      return;
    }
    final productIds = entries.map((e) => e.productId).toSet().toList();
    try {
      final response = await _supabaseClient
          .from('products')
          .select('*, product_images(*)')
          .inFilter('id', productIds);
      final productsMap = <String, Product>{};
      for (final row in response as List) {
        final product = Product.fromJson(row as Map<String, dynamic>);
        productsMap[product.id] = product;
      }
      final cartItems = <CartItem>[];
      for (var i = 0; i < entries.length; i++) {
        final entry = entries[i];
        final product = productsMap[entry.productId];
        if (product != null) {
          cartItems.add(CartItem(
            id: '$_kGuestCartItemIdPrefix$i',
            quantity: entry.quantity,
            product: product,
            variantId: entry.variantId,
          ));
        }
      }
      double totalPrice = cartItems.fold(0.0, (sum, item) => sum + item.product.effectivePrice * item.quantity);
      int totalItems = cartItems.fold(0, (sum, item) => sum + item.quantity);
      _lastLoadedState = CartLoadedState(
        cartItems: cartItems,
        totalPrice: totalPrice,
        totalItems: totalItems,
        currencyCode: 'USD',
        currencySymbol: '\$',
      );
      emit(_lastLoadedState!);
    } catch (e) {
      _lastLoadedState = CartLoadedState(cartItems: [], totalPrice: 0, totalItems: 0, currencyCode: 'USD', currencySymbol: '\$');
      emit(_lastLoadedState!);
    }
  }

  Future<bool> _addItemToCart(String productId, int quantity, String? variantId) async {
    final userId = _supabaseClient.auth.currentUser?.id;
    try {
      if (userId == null) {
        await _guestCartStorage.add(productId, quantity: quantity, variantId: variantId);
        _cartCache.setInCart('guest', productId, variantId, true);
        await _loadGuestCart();
        return true;
      }
      var query = _supabaseClient
          .from('cart')
          .select('id, quantity')
          .eq('user_id', userId)
          .eq('product_id', productId);
      if (variantId != null) {
        query = query.eq('variant_id', variantId);
      } else {
        query = query.isFilter('variant_id', null);
      }
      final existing = await query.maybeSingle();
      if (existing != null) {
        final newQty = (existing['quantity'] as int) + quantity;
        await _supabaseClient.from('cart').update({'quantity': newQty}).eq('id', existing['id']);
        await _loadCart();
        return true;
      }
      await _supabaseClient.from('cart').insert({
        'product_id': productId,
        if (variantId != null) 'variant_id': variantId,
        'quantity': quantity,
      });
      await _loadCart();
      return true;
    } catch (e) {
      if (state is CartLoadedState) {
        emit(CartErrorState(message: 'Failed to add item to cart: $e', previousState: state as CartLoadedState));
      } else {
        emit(CartErrorState(message: 'Failed to add item to cart: $e'));
      }
      return false;
    }
  }

  Future<void> _removeItemFromCart(String cartItemId) async {
    if (state is! CartLoadedState) return;
    final currentState = state as CartLoadedState;
    final userId = _supabaseClient.auth.currentUser?.id;

    if (cartItemId.startsWith(_kGuestCartItemIdPrefix)) {
      final index = int.tryParse(cartItemId.replaceFirst(_kGuestCartItemIdPrefix, ''));
      if (index != null) {
        final removedItem = currentState.cartItems.length > index ? currentState.cartItems[index] : null;
        final updatedItems = currentState.cartItems.where((item) => item.id != cartItemId).toList();
        final updatedTotalPrice = updatedItems.fold(0.0, (sum, item) => sum + item.product.effectivePrice * item.quantity);
        final updatedTotalItems = updatedItems.fold(0, (sum, item) => sum + item.quantity);
        emit(currentState.copyWith(cartItems: updatedItems, totalPrice: updatedTotalPrice, totalItems: updatedTotalItems));
        await _guestCartStorage.removeAt(index);
        if (removedItem != null) _cartCache.setInCart('guest', removedItem.product.id, removedItem.variantId, false);
        _lastLoadedState = currentState.copyWith(cartItems: updatedItems, totalPrice: updatedTotalPrice, totalItems: updatedTotalItems);
        emit(CartItemRemovedState(loadedState: _lastLoadedState!));
        Future.microtask(() => emit(_lastLoadedState!));
      }
      return;
    }

    try {
      final updatedItems = currentState.cartItems.where((item) => item.id != cartItemId).toList();
      final updatedTotalPrice = updatedItems.fold(0.0, (sum, item) => sum + item.product.effectivePrice * item.quantity);
      final updatedTotalItems = updatedItems.fold(0, (sum, item) => sum + item.quantity);
      emit(currentState.copyWith(cartItems: updatedItems, totalPrice: updatedTotalPrice, totalItems: updatedTotalItems));

      CartItem? removedItem;
      for (final item in currentState.cartItems) {
        if (item.id == cartItemId) {
          removedItem = item;
          break;
        }
      }

      await _supabaseClient.from('cart').delete().eq('id', cartItemId);
      await _loadCart();
      if (removedItem != null && userId != null) {
        _cartCache.setInCart(userId, removedItem.product.id, removedItem.variantId, false);
      }
      final loaded = _lastLoadedState;
      if (loaded != null) {
        emit(CartItemRemovedState(loadedState: loaded));
        Future.microtask(() => emit(loaded));
      }
    } catch (e) {
      emit(currentState);
      emit(CartErrorState(message: 'Failed to remove item: $e', previousState: currentState));
    }
  }

  Future<void> _updateItemQuantity(String cartItemId, int newQuantity) async {
    if (newQuantity <= 0) {
      await _removeItemFromCart(cartItemId);
      return;
    }

    if (state is! CartLoadedState) return;
    final currentState = state as CartLoadedState;

    if (cartItemId.startsWith(_kGuestCartItemIdPrefix)) {
      final index = int.tryParse(cartItemId.replaceFirst(_kGuestCartItemIdPrefix, ''));
      if (index != null) {
        final updatedItems = currentState.cartItems.map((item) {
          if (item.id == cartItemId) return item.copyWith(quantity: newQuantity);
          return item;
        }).toList();
        final updatedTotalPrice = updatedItems.fold(0.0, (sum, item) => sum + item.product.effectivePrice * item.quantity);
        final updatedTotalItems = updatedItems.fold(0, (sum, item) => sum + item.quantity);
        emit(currentState.copyWith(cartItems: updatedItems, totalPrice: updatedTotalPrice, totalItems: updatedTotalItems));
        await _guestCartStorage.updateQuantityAt(index, newQuantity);
        _lastLoadedState = currentState.copyWith(cartItems: updatedItems, totalPrice: updatedTotalPrice, totalItems: updatedTotalItems);
      }
      return;
    }

    final updatedItems = currentState.cartItems.map((item) {
      if (item.id == cartItemId) return item.copyWith(quantity: newQuantity);
      return item;
    }).toList();
    final updatedTotalPrice = updatedItems.fold(0.0, (sum, item) => sum + item.product.effectivePrice * item.quantity);
    final updatedTotalItems = updatedItems.fold(0, (sum, item) => sum + item.quantity);
    emit(currentState.copyWith(cartItems: updatedItems, totalPrice: updatedTotalPrice, totalItems: updatedTotalItems));

    try {
      await _supabaseClient.from('cart').update({'quantity': newQuantity}).eq('id', cartItemId);
      await _loadCart();
    } catch (e) {
      emit(currentState);
      emit(CartErrorState(message: 'Failed to update quantity: $e', previousState: currentState));
    }
  }

  Future<void> _clearCart() async {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) {
      await _guestCartStorage.clear();
      _lastLoadedState = CartLoadedState(cartItems: [], totalPrice: 0, totalItems: 0, currencyCode: 'USD', currencySymbol: '\$');
      emit(_lastLoadedState!);
      return;
    }
    try {
      await _supabaseClient.from('cart').delete().eq('user_id', userId);
      await _loadCart();
    } catch (e) {
      emit(CartErrorState(message: 'Failed to clear cart: $e', previousState: _lastLoadedState));
    }
  }

  /// Show confirmation dialog before removing item
  Future<void> _showRemoveConfirmationDialog(
    BuildContext context,
    String cartItemId,
  ) async {
    final currentState = state;
    if (currentState is! CartLoadedState) return;
    
    String productName = 'this item';
    try {
      final item = currentState.cartItems.firstWhere(
        (item) => item.id == cartItemId,
      );
      productName = item.product.name;
    } catch (e) {
      debugPrint('⚠️ Item not found in cart: $e');
    }

    final result = await OsmeaComponents.showPopup<bool>(
      context: context,
      variant: PopupVariant.dialog,
      title: 'Remove from cart?',
      subtitle: 'Are you sure you want to remove "$productName" from your cart?',
      padding: EdgeInsets.all(context.spacing16),
      child: OsmeaComponents.row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          OsmeaComponents.button(
            text: 'Cancel',
            variant: ButtonVariant.ghost,
            onPressed: () => Navigator.of(context).pop(false),
          ),
          OsmeaComponents.button(
            text: 'Remove',
            variant: ButtonVariant.danger,
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    ) ?? false;

    if (result) {
      await _removeItemFromCart(cartItemId);
    }
  }

  Map<String, dynamic>? toJson(CartState state) {
    return null; 
  }

  CartState? fromJson(Map<String, dynamic> json) {
    return null; 
  }

  static String? _variantIdFromJson(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    return value.toString();
  }
}
