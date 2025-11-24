/*
 * Cart Empty Widget
 * -----------------
 * Widget that handles empty cart state by navigating to empty view.
 */

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';

/// Widget shown when cart is empty
class CartEmptyWidget extends StatelessWidget {
  const CartEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.go('/empty/cart?actionPath=/home');
    });
    return context.emptySizedBox;
  }
}

