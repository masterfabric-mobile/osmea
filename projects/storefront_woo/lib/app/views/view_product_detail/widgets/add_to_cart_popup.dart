/*
 * Add to Cart Popup
 * -----------------
 * Bottom sheet widget shown after successfully adding a product to cart.
 * Shows cart summary with order details.
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import 'package:osmea_components/src/components/bottom_sheet/bottom_sheet.dart';
import 'package:storefront_woo/app/views/view_cart/models/cart_view_model.dart';
import 'package:storefront_woo/app/views/view_cart/models/module/states.dart';
import 'package:storefront_woo/app/views/view_cart/widgets/cart_item_widget.dart';

/// Shows add to cart success bottom sheet with cart summary
void showAddToCartSuccessPopup(BuildContext context, {String? cartToken}) {
  // Get cart view model and load cart
  final cartViewModel = GetIt.I<CartViewModel>();

  // Set cart token in arguments if provided
  if (cartToken != null && cartToken.isNotEmpty) {
    cartViewModel.setArguments({'cartToken': cartToken});
    cartViewModel.loadCart(cartToken: cartToken);
  } else {
    cartViewModel.loadCart();
  }

  // Show bottom sheet with cart summary
  OsmeaBottomSheetHelpers.showModal(
    context: context,
    size: BottomSheetSize.large,
    title: 'Product Added to Cart',
    backgroundColor: OsmeaColors.paperWhite,
    footer: BlocBuilder<CartViewModel, CartState>(
      bloc: cartViewModel,
      builder: (context, cartState) {
        if (cartState is! CartLoadedState) {
          return const SizedBox.shrink();
        }
        return OsmeaComponents.container(
          decoration: BoxDecoration(
            color: OsmeaColors.paperWhite,
            border: Border(
              top: BorderSide(
                color:
                    OsmeaColors.grayMaterial[200] ??
                    OsmeaColors.pewter.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: context.spacing16,
            vertical: context.spacing12,
          ),
          child: OsmeaComponents.row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Continue shopping button
              OsmeaComponents.expanded(
                child: OsmeaComponents.button(
                  text: 'Continue Shopping',
                  variant: ButtonVariant.outlined,
                  size: ButtonSize.small,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              OsmeaComponents.sizedBox(width: context.spacing8),
              // Checkout button
              OsmeaComponents.expanded(
                child: OsmeaComponents.button(
                  text: 'Checkout',
                  variant: ButtonVariant.primary,
                  size: ButtonSize.small,
                  onPressed: () {
                    if (context.mounted) {
                      Navigator.pop(context);
                      // Navigate to checkout (guest checkout is allowed)
                      context.go(
                        '/checkout',
                        extra: {
                          'totalAmount': cartState.totalPrice,
                          'currencySymbol': cartState.currencySymbol,
                          'currencyCode': cartState.currencyCode,
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    ),
    child: BlocBuilder<CartViewModel, CartState>(
      bloc: cartViewModel,
      builder: (context, cartState) {
        // Show loading while cart is being loaded
        if (cartState is CartLoadingState || cartState is CartInitialState) {
          return OsmeaComponents.container(
            padding: EdgeInsets.all(context.spacing24),
            child: OsmeaComponents.center(
              child: OsmeaComponents.loading(
                type: LoadingType.circularFade,
                size: context.iconSizeLarge,
                color: OsmeaColors.nordicBlue,
              ),
            ),
          );
        }

        // Show error if cart failed to load
        if (cartState is CartErrorState) {
          return OsmeaComponents.container(
            padding: EdgeInsets.all(context.spacing24),
            child: OsmeaComponents.column(
              children: [
                OsmeaComponents.text(
                  'Failed to load cart',
                  textStyle: OsmeaTextStyle.bodyMedium(context),
                  color: OsmeaColors.pewter,
                ),
                OsmeaComponents.sizedBox(height: context.spacing16),
                OsmeaComponents.button(
                  text: 'Retry',
                  onPressed: () {
                    if (cartToken != null && cartToken.isNotEmpty) {
                      cartViewModel.loadCart(cartToken: cartToken);
                    } else {
                      cartViewModel.loadCart();
                    }
                  },
                  variant: ButtonVariant.outlined,
                  size: ButtonSize.medium,
                ),
              ],
            ),
          );
        }

        // Show cart summary if cart is loaded
        if (cartState is CartLoadedState) {
          return SingleChildScrollView(
            child: OsmeaComponents.column(
              children: [
                OsmeaComponents.sizedBox(height: context.spacing12),
                // Success message
                OsmeaComponents.container(
                  margin: EdgeInsets.symmetric(horizontal: context.spacing16),
                  padding: EdgeInsets.symmetric(
                    horizontal: context.spacing16,
                    vertical: context.spacing12,
                  ),
                  decoration: BoxDecoration(
                    color: OsmeaColors.nordicBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: OsmeaColors.nordicBlue.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: OsmeaComponents.row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        color: OsmeaColors.nordicBlue,
                        size: context.iconSizeMedium,
                      ),
                      OsmeaComponents.sizedBox(width: context.spacing10),
                      OsmeaComponents.expanded(
                        child: OsmeaComponents.text(
                          'Product successfully added to cart.',
                          textAlign: TextAlign.center,
                          textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                            fontWeight: FontWeight.w500,
                            color: OsmeaColors.nordicBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                OsmeaComponents.sizedBox(height: context.spacing20),
                // Cart items list
                if (cartState.cartItems.isNotEmpty) ...[
                  OsmeaComponents.container(
                    margin: EdgeInsets.symmetric(horizontal: context.spacing16),
                    padding: EdgeInsets.symmetric(
                      horizontal: context.spacing12,
                      vertical: context.spacing8,
                    ),
                    decoration: BoxDecoration(
                      color: OsmeaColors.grayMaterial[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: BlocBuilder<CartViewModel, CartState>(
                      bloc: cartViewModel,
                      builder: (context, state) {
                        if (state is CartLoadedState) {
                          final itemCount = state.cartItems.length;
                          return OsmeaComponents.text(
                            itemCount == 1
                                ? 'You have 1 item in your cart'
                                : 'You have $itemCount different items in your cart',
                            textStyle: OsmeaTextStyle.titleSmall(context)
                                .copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: OsmeaColors.thunder,
                                ),
                          );
                        }
                        return OsmeaComponents.text(
                          'You have ${cartState.cartItems.length} different items in your cart',
                          textStyle: OsmeaTextStyle.titleSmall(context)
                              .copyWith(
                                fontWeight: FontWeight.w600,
                                color: OsmeaColors.thunder,
                              ),
                        );
                      },
                    ),
                  ),
                  OsmeaComponents.sizedBox(height: context.spacing12),
                  ...cartState.cartItems.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    return OsmeaComponents.column(
                      children: [
                        CartItemWidget(
                          item: item,
                          viewModel: cartViewModel,
                          state: cartState,
                        ),
                        if (index < cartState.cartItems.length - 1)
                          OsmeaComponents.container(
                            margin: EdgeInsets.symmetric(
                              horizontal: context.spacing16,
                            ),
                            height: context.height1,
                            color: OsmeaColors.grayMaterial[200],
                          ),
                      ],
                    );
                  }).toList(),
                  OsmeaComponents.sizedBox(height: context.spacing8),
                ],
              ],
            ),
          );
        }

        // Fallback
        return OsmeaComponents.container(
          padding: EdgeInsets.all(context.spacing24),
          child: OsmeaComponents.text(
            'Loading cart...',
            textStyle: OsmeaTextStyle.bodyMedium(context),
            color: OsmeaColors.pewter,
          ),
        );
      },
    ),
  );
}
