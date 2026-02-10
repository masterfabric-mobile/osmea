import 'dart:async';
import 'package:core/core.dart' hide BuildContextTranslationsExtension, AppLocaleUtils, LocaleSettings, TranslationProvider;
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:storefront_supabase/app/models/product.dart';
import 'package:storefront_supabase/app/views/view_cart/models/states.dart';

@injectable
class CartViewModel extends BaseViewModelCubit<CartState> {
  final SupabaseClient _supabaseClient;

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

  CartViewModel(this._supabaseClient) : super(CartInitialState());

  // Public trigger functions
  Future<void> initial({String? cartToken}) async => _loadCart(); 
  Future<void> refreshCart() async => _loadCart();
  Future<void> addItemToCart(String productId, {int quantity = 1, String? variantId}) async => _addItemToCart(productId, quantity, variantId);
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
        _lastLoadedState = CartLoadedState(cartItems: [], totalPrice: 0, totalItems: 0, currencyCode: 'USD', currencySymbol: '\$');
        emit(_lastLoadedState!);
        return;
      }

      final response = await _supabaseClient
          .from('cart')
          .select('id, quantity, products(*, product_images(*))') 
          .eq('user_id', userId);

      final cartItems = <CartItem>[];
      for (final itemData in (response as List)) {
        if (itemData['products'] != null) {
          final product = Product.fromJson(itemData['products'] as Map<String, dynamic>);
          cartItems.add(CartItem(
            id: itemData['id'] as String,
            quantity: itemData['quantity'] as int,
            product: product,
          ));
        }
      }

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

  Future<void> _addItemToCart(String productId, int quantity, String? variantId) async {
    // If state is not loaded, we might be adding from outside (e.g. PLP)
    // We should optimistically add or at least reload.
    // Ideally we should be in a loaded state or initial state.
    
    final userId = _supabaseClient.auth.currentUser?.id;
    try {
      if (userId != null) {
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
          return;
        }
      }
      await _supabaseClient.from('cart').insert({
        'product_id': productId,
        if (variantId != null) 'variant_id': variantId,
        'quantity': quantity,
      });
      await _loadCart(); 
    } catch (e) {
      // If we are in loaded state, we can show error and keep state
      if (state is CartLoadedState) {
         emit(CartErrorState(message: 'Failed to add item to cart: $e', previousState: state as CartLoadedState));
      } else {
         emit(CartErrorState(message: 'Failed to add item to cart: $e'));
      }
    }
  }

  Future<void> _removeItemFromCart(String cartItemId) async {
    if (state is! CartLoadedState) return;
    final currentState = state as CartLoadedState;

    try {
      // Optimistic update
      final updatedItems = currentState.cartItems.where((item) => item.id != cartItemId).toList();
      final updatedTotalPrice = updatedItems.fold(0.0, (sum, item) => sum + item.product.effectivePrice * item.quantity);
      final updatedTotalItems = updatedItems.fold(0, (sum, item) => sum + item.quantity);
      
      emit(currentState.copyWith(
        cartItems: updatedItems,
        totalPrice: updatedTotalPrice,
        totalItems: updatedTotalItems,
      ));

      await _supabaseClient.from('cart').delete().eq('id', cartItemId);
      await _loadCart(); // Refresh cart to get actual state
      final loaded = _lastLoadedState;
      if (loaded != null) {
        emit(CartItemRemovedState(loadedState: loaded));
        Future.microtask(() => emit(loaded));
      }
    } catch (e) {
      // Revert optimistic update on error
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
    
    // Optimistic update
    final updatedItems = currentState.cartItems.map((item) {
      if (item.id == cartItemId) {
        return item.copyWith(quantity: newQuantity);
      }
      return item;
    }).toList();
    final updatedTotalPrice = updatedItems.fold(0.0, (sum, item) => sum + item.product.effectivePrice * item.quantity);
    final updatedTotalItems = updatedItems.fold(0, (sum, item) => sum + item.quantity);

    // Simulate productId as int for updatingProductId if possible, or ignore for now as Supabase uses String IDs
    // We can't use hashCode for reliable ID matching if collisions occur, but for spinner it's mostly visual.
    // Alternatively, change state to support String updatingProductId or ignore the spinner on specific item for now.
    
    emit(currentState.copyWith(
      cartItems: updatedItems,
      totalPrice: updatedTotalPrice,
      totalItems: updatedTotalItems,
      // updatingProductId: ... // Skipping item-specific spinner for now to avoid type mismatch
    ));


    try {
      await _supabaseClient
          .from('cart')
          .update({'quantity': newQuantity}).eq('id', cartItemId);
      await _loadCart(); 
    } catch (e) {
      emit(currentState); // Revert
      emit(CartErrorState(message: 'Failed to update quantity: $e', previousState: currentState));
    }
  }

  Future<void> _clearCart() async {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) return;
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
}
