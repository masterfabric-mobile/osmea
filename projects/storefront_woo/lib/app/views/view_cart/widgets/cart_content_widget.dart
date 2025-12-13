/*
 * Cart Content Widget
 * -------------------
 * Main content widget for cart view displaying cart items, coupons, and summary.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import 'package:storefront_woo/app/views/view_cart/models/cart_view_model.dart';
import 'package:storefront_woo/app/views/view_cart/models/module/states.dart';
import 'package:storefront_woo/app/views/view_cart/widgets/cart_empty_widget.dart';
import 'package:storefront_woo/app/views/view_cart/widgets/cart_item_swipe_widget.dart';
import 'package:storefront_woo/app/views/view_cart/widgets/coupon_section_widget.dart';
import 'package:storefront_woo/app/views/view_cart/widgets/order_summary_widget.dart';

/// Main content widget for cart view
class CartContentWidget extends StatelessWidget {
  final CartViewModel viewModel;
  final CartLoadedState state;

  const CartContentWidget({
    super.key,
    required this.viewModel,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    if (state.cartItems.isEmpty) {
      return const CartEmptyWidget();
    }

    return OsmeaComponents.singleChildScrollView(
      child: OsmeaComponents.column(
        children: [
          OsmeaComponents.sizedBox(height: context.spacing12),
          ..._buildCartItems(context),
          OsmeaComponents.sizedBox(height: context.spacing12),
          CouponSectionWidget(
            viewModel: viewModel,
            state: state,
          ),
          OsmeaComponents.sizedBox(height: context.spacing12),
          OrderSummaryWidget(state: state),
          OsmeaComponents.sizedBox(height: context.spacing16),
          
          // Complete Purchase Button
          _buildCheckoutButton(context),
          
          OsmeaComponents.sizedBox(height: context.spacing16),
        ],
      ),
    );
  }

  Widget _buildCheckoutButton(BuildContext context) {
    return OsmeaComponents.container(
      margin: EdgeInsets.symmetric(horizontal: context.spacing16),
      decoration: BoxDecoration(
        color: OsmeaColors.nordicBlue,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: OsmeaColors.nordicBlue.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _handleCheckout(context);
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: OsmeaComponents.row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OsmeaComponents.text(
                  'Complete Purchase',
                  textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
                    color: OsmeaColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                OsmeaComponents.sizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: OsmeaColors.white,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleCheckout(BuildContext context) async {
    try {
      // Check if user is authenticated using AuthCubit (more reliable)
      bool isAuthenticated = false;
      try {
        final authCubit = GetIt.I<AuthCubit>();
        final authState = authCubit.state;
        isAuthenticated = authState is AuthAuthenticatedState &&
            authState.isAuthenticated &&
            authState.jwtToken != null &&
            authState.jwtToken!.isNotEmpty;
      } catch (e) {
        debugPrint('⚠️ Could not get AuthCubit, trying AuthStorageHelper: $e');
        // Fallback to AuthStorageHelper
        final authStorage = AuthStorageHelper();
        isAuthenticated = await authStorage.isAuthenticated();
      }

      if (!isAuthenticated) {
        // User not authenticated, show message and redirect to auth
        if (context.mounted) {
          context.snackbarWarning(
            'Please sign in to complete your purchase',
            duration: const Duration(seconds: 3),
          );
          await Future.delayed(const Duration(milliseconds: 500));
          if (context.mounted) {
            context.go('/auth');
          }
        }
        return;
      }

      // User is authenticated, proceed with checkout
      // Navigate to checkout page where user will fill address forms
      if (context.mounted) {
        final currentState = viewModel.state;
        if (currentState is CartLoadedState) {
          // Navigate to checkout page (not directly to payment)
          // User will fill address forms in checkout page
          context.go(
            '/checkout',
            extra: {
              'totalAmount': currentState.totalPrice,
              'currencySymbol': currentState.currencySymbol,
              'currencyCode': currentState.currencyCode,
            },
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        context.snackbarError(
          'Error starting checkout: ${e.toString()}',
          duration: const Duration(seconds: 3),
        );
      }
    }
  }

  List<Widget> _buildCartItems(BuildContext context) {
    return state.cartItems.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      return OsmeaComponents.column(
        children: [
          CartItemSwipeWidget(
            item: item,
            viewModel: viewModel,
            state: state,
          ),
          if (index < state.cartItems.length - 1)
            OsmeaComponents.container(
              margin: EdgeInsets.symmetric(horizontal: context.spacing16),
              height: context.height1,
              color: OsmeaColors.grayMaterial[200],
            ),
        ],
      );
    }).toList();
  }
}

