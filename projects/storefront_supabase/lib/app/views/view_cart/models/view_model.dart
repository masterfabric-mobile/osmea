import 'package:core/core.dart' hide BuildContextTranslationsExtension, AppLocaleUtils, LocaleSettings, TranslationProvider;
import 'package:injectable/injectable.dart';
import 'package:storefront_supabase/app/models/cart_item.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'states.dart';

@injectable
class CartViewModel extends BaseViewModelCubit<CartState> {
  final SupabaseClient _supabaseClient;

  CartViewModel(this._supabaseClient) : super(CartInitialState());

  Future<void> initial() async {
    stateChanger(CartLoadingState());
    final userId = _supabaseClient.auth.currentUser?.id;

    if (userId == null) {
      stateChanger(CartErrorState('Please log in to view your cart.'));
      return;
    }

    try {
      final response = await _supabaseClient
          .from('cart')
          .select('id, quantity, products:product_id(*, product_images(*))')
          .eq('user_id', userId);

      final cartItems =
          response.map((data) => CartItem.fromJson(data)).toList();

      double totalPrice = 0.0;
      for (var item in cartItems) {
        totalPrice += item.product.price * item.quantity;
      }

      stateChanger(
          CartLoadedState(cartItems: cartItems, totalPrice: totalPrice));
    } catch (e) {
      stateChanger(CartErrorState('Failed to load cart: $e'));
    }
  }

  Future<void> removeItem(String cartItemId) async {
    try {
      await _supabaseClient.from('cart').delete().eq('id', cartItemId);
      await initial(); // Refresh the cart
    } catch (e) {
      // Optionally, handle the error more gracefully
      stateChanger(CartErrorState('Failed to remove item: $e'));
    }
  }

  Future<void> updateQuantity(String cartItemId, int newQuantity) async {
    if (newQuantity <= 0) {
      await removeItem(cartItemId);
      return;
    }

    try {
      await _supabaseClient
          .from('cart')
          .update({'quantity': newQuantity}).eq('id', cartItemId);
      await initial(); // Refresh the cart
    } catch (e) {
      // Optionally, handle the error more gracefully
      stateChanger(CartErrorState('Failed to update quantity: $e'));
    }
  }
}
