import 'package:storefront_supabase/app/models/cart_item.dart';

abstract class CartState {}

class CartInitialState extends CartState {}

class CartLoadingState extends CartState {}

class CartLoadedState extends CartState {
  final List<CartItem> cartItems;
  final double totalPrice;

  CartLoadedState({required this.cartItems, required this.totalPrice});
}

class CartErrorState extends CartState {
  final String message;
  CartErrorState(this.message);
}
