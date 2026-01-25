import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:apis/models/cart/woo_cart_token.dart';
import 'package:storefront_woo/app/views/view_cart/models/cart_view_model.dart';
import 'package:storefront_woo/app/views/view_product_detail/widgets/add_to_cart_popup.dart';

/// Adds an item to cart (qty=1) and shows the standard add-to-cart popup.
Future<void> addToCartFromProductCard(
  BuildContext context, {
  required int productId,
}) async {
  if (productId <= 0) return;

  final cartViewModel = GetIt.I<CartViewModel>();
  await cartViewModel.addItemToCart(productId, quantity: 1);

  final cartToken = (await WooCartTokenStorage.loadCartToken())?.cartToken;
  if (!context.mounted) return;
  showAddToCartSuccessPopup(context, cartToken: cartToken);
}

