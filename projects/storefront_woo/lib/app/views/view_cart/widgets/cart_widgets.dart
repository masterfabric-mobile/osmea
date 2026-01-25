/*
 * Cart Widgets
 * ------------
 * Widgets for the cart view following OSMEA architecture.
 * Uses OsmeaComponents for consistent UI.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:go_router/go_router.dart';
import 'package:storefront_woo/app/views/view_cart/models/cart_view_model.dart';
import 'package:storefront_woo/app/views/view_cart/models/module/states.dart';
import 'package:storefront_woo/gen/translations.g.dart';

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
      return _buildEmptyCart(context);
    }

    return OsmeaComponents.singleChildScrollView(
      child: OsmeaComponents.column(
        children: [
          // Cart items
          ...state.cartItems.map((item) => _buildCartItem(context, item)),

          OsmeaComponents.sizedBox(height: 8),

          // Coupon section
          _buildCouponSection(context),

          OsmeaComponents.sizedBox(height: 8),

          // Order summary
          _buildOrderSummary(context),

          OsmeaComponents.sizedBox(height: 16),

          // Checkout button - Centered in single child area
          OsmeaComponents.center(
            child: OsmeaComponents.container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: OsmeaColors.black,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: OsmeaColors.black.withValues(alpha: 0.2),
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
                          context.t.cartView.checkout.completePurchase,
                          textStyle: OsmeaTextStyle.titleMedium(context)
                              .copyWith(
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
            ),
          ),

          OsmeaComponents.sizedBox(height: 16),
        ],
      ),
    );
  }

  /// Builds empty cart widget
  Widget _buildEmptyCart(BuildContext context) {
    return OsmeaComponents.center(
      child: OsmeaComponents.column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OsmeaComponents.container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: OsmeaColors.black.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(60),
            ),
            child: Icon(
              Icons.shopping_cart_outlined,
              size: 60,
              color: OsmeaColors.black,
            ),
          ),
          OsmeaComponents.sizedBox(height: 24),
          OsmeaComponents.text(
            context.t.cartView.empty.title,
            textStyle: OsmeaTextStyle.headlineSmall(
              context,
            ).copyWith(color: OsmeaColors.black, fontWeight: FontWeight.w500),
          ),
          OsmeaComponents.sizedBox(height: 8),
          OsmeaComponents.text(
            context.t.cartView.empty.subtitle,
            textStyle: OsmeaTextStyle.bodyMedium(
              context,
            ).copyWith(color: OsmeaColors.pewter),
            textAlign: TextAlign.center,
          ),
          OsmeaComponents.sizedBox(height: 32),
          OsmeaComponents.button(
            onPressed: () {
              // Navigate to home using GoRouter
              if (context.mounted) {
                context.go('/home');
              }
            },
            backgroundColor: OsmeaColors.black,
            textColor: OsmeaColors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            text: context.t.cartView.empty.continueShopping,
            textStyle: OsmeaTextStyle.titleMedium(
              context,
            ).copyWith(color: OsmeaColors.white, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  /// Builds individual cart item widget - MINIMAL ELEGANT DESIGN WITH BOTTOM CONTROLS
  Widget _buildCartItem(BuildContext context, CartItem item) {
    return OsmeaComponents.container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: OsmeaColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: OsmeaColors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: OsmeaComponents.padding(
        padding: const EdgeInsets.all(12),
        child: OsmeaComponents.column(
          children: [
            // Top Row: Image + Product Info
            OsmeaComponents.row(
              children: [
                // Minimal Product Image
                OsmeaComponents.container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: OsmeaColors.grayMaterial[50],
                  ),
                  child: OsmeaComponents.image(
                    imageUrl: item.imageUrl,
                    fit: BoxFit.cover,
                    borderRadius: BorderRadius.circular(12),
                    variant: ImageVariant.normal,
                    cacheWidth: 200, // Limit image size for performance
                    showLoadingIndicator: true,
                    errorWidget: OsmeaComponents.center(
                      child: Icon(
                        Icons.image_outlined,
                        color: OsmeaColors.pewter.withValues(alpha: 0.5),
                        size: 32,
                      ),
                    ),
                  ),
                ),
                OsmeaComponents.sizedBox(width: 12),

                // Minimal Product Info
                OsmeaComponents.expanded(
                  child: OsmeaComponents.column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      OsmeaComponents.text(
                        item.productName,
                        textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                          fontWeight: FontWeight.w500,
                          color: OsmeaColors.thunder,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      OsmeaComponents.sizedBox(height: 4),
                      OsmeaComponents.text(
                        PriceInfoCurrencyHelper.formatPrice(
                          item.price,
                          currencyCode: state.currencyCode,
                        ),
                        textStyle: OsmeaTextStyle.bodyLarge(context).copyWith(
                          color: OsmeaColors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            OsmeaComponents.sizedBox(height: 12),

            // Bottom Row: Quantity Controls + Delete Button
            OsmeaComponents.row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Quantity Controls
                OsmeaComponents.container(
                  decoration: BoxDecoration(
                    color: OsmeaColors.grayMaterial[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: OsmeaComponents.row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      OsmeaComponents.iconButton(
                        onPressed: item.quantity > 1
                            ? () => viewModel.updateItemQuantity(
                                item.productId,
                                item.quantity - 1,
                              )
                            : null,
                        icon: Icon(
                          Icons.remove,
                          color: OsmeaColors.pewter,
                          size: 16,
                        ),
                        backgroundColor: Colors.transparent,
                      ),
                      OsmeaComponents.padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: OsmeaComponents.text(
                          '${item.quantity}',
                          textStyle: OsmeaTextStyle.bodyMedium(context)
                              .copyWith(
                                fontWeight: FontWeight.w600,
                                color: OsmeaColors.thunder,
                              ),
                        ),
                      ),
                      OsmeaComponents.iconButton(
                        onPressed: () => viewModel.updateItemQuantity(
                          item.productId,
                          item.quantity + 1,
                        ),
                        icon: Icon(
                          Icons.add,
                          color: OsmeaColors.black,
                          size: 16,
                        ),
                        backgroundColor: Colors.transparent,
                      ),
                    ],
                  ),
                ),

                // Delete Button - Text Button for better readability
                OsmeaComponents.button(
                  onPressed: () => viewModel.removeItemFromCart(
                    item.productId,
                    context: context,
                  ),
                  backgroundColor: OsmeaColors.red.withValues(alpha: 0.1),
                  textColor: OsmeaColors.red,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  text: context.t.cartView.widgets.item.remove.confirm,
                  textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                    color: OsmeaColors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Builds coupon section - MINIMAL ELEGANT DESIGN
  Widget _buildCouponSection(BuildContext context) {
    return OsmeaComponents.container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: OsmeaColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: OsmeaColors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: OsmeaComponents.padding(
        padding: const EdgeInsets.all(16),
        child: OsmeaComponents.row(
          children: [
            // Minimal Icon
            Icon(
              Icons.local_offer_outlined,
              color: OsmeaColors.black.withValues(alpha: 0.7),
              size: 20,
            ),
            OsmeaComponents.sizedBox(width: 12),

            // Minimal Input Field
            OsmeaComponents.expanded(
              child: OsmeaComponents.textField(
                hint: context.t.cartView.widgets.coupon.inputHint,
                textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                  fontWeight: FontWeight.w400,
                  color: OsmeaColors.thunder,
                ),
              ),
            ),
            OsmeaComponents.sizedBox(width: 8),

            // Minimal Apply Button
            OsmeaComponents.button(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(context.t.cartView.widgets.coupon.comingSoon),
                    backgroundColor: OsmeaColors.black,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              },
              backgroundColor: OsmeaColors.black.withValues(alpha: 0.1),
              textColor: OsmeaColors.black,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              text: context.t.cartView.widgets.coupon.apply,
              textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                color: OsmeaColors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds order summary - FRESH E-COMMERCE DESIGN
  Widget _buildOrderSummary(BuildContext context) {
    return OsmeaComponents.container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: OsmeaColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: OsmeaColors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
        border: Border.all(color: OsmeaColors.grayMaterial[100]!, width: 1),
      ),
      child: OsmeaComponents.padding(
        padding: const EdgeInsets.all(12),
        child: OsmeaComponents.column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Modern Header
            OsmeaComponents.row(
              children: [
                Icon(
                  Icons.receipt_long_outlined,
                  color: OsmeaColors.black,
                  size: 24,
                ),
                OsmeaComponents.sizedBox(width: 8),
                OsmeaComponents.text(
                  context.t.cartView.widgets.orderSummary.title,
                  textStyle: OsmeaTextStyle.titleLarge(context).copyWith(
                    fontWeight: FontWeight.w700,
                    color: OsmeaColors.thunder,
                  ),
                ),
              ],
            ),
            OsmeaComponents.sizedBox(height: 20),

            // Modern Summary Items
            OsmeaComponents.container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: OsmeaColors.grayMaterial[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: OsmeaColors.grayMaterial[200]!,
                  width: 1,
                ),
              ),
              child: OsmeaComponents.column(
                children: [
                  // Subtotal
                  OsmeaComponents.row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OsmeaComponents.text(
                        context.t.cartView.widgets.orderSummary.subtotal,
                        textStyle: OsmeaTextStyle.bodyLarge(context).copyWith(
                          fontWeight: FontWeight.w500,
                          color: OsmeaColors.thunder,
                        ),
                      ),
                      OsmeaComponents.text(
                        PriceInfoCurrencyHelper.formatPrice(
                          state.totalPrice,
                          currencyCode: state.currencyCode,
                        ),
                        textStyle: OsmeaTextStyle.bodyLarge(context).copyWith(
                          fontWeight: FontWeight.w700,
                          color: OsmeaColors.thunder,
                        ),
                      ),
                    ],
                  ),
                  OsmeaComponents.sizedBox(height: 12),

                  // Shipping
                  OsmeaComponents.row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OsmeaComponents.text(
                        context.t.cartView.widgets.orderSummary.shipping,
                        textStyle: OsmeaTextStyle.bodyMedium(
                          context,
                        ).copyWith(color: OsmeaColors.pewter),
                      ),
                      OsmeaComponents.text(
                        context.t.cartView.widgets.orderSummary.shippingCalculated,
                        textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                          color: OsmeaColors.pewter.withValues(alpha: 0.8),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                  OsmeaComponents.sizedBox(height: 12),

                  // Tax
                  OsmeaComponents.row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OsmeaComponents.text(
                        context.t.cartView.widgets.orderSummary.tax,
                        textStyle: OsmeaTextStyle.bodyMedium(
                          context,
                        ).copyWith(color: OsmeaColors.pewter),
                      ),
                      OsmeaComponents.text(
                        context.t.cartView.widgets.orderSummary.taxCalculated,
                        textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                          color: OsmeaColors.pewter.withValues(alpha: 0.8),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                  OsmeaComponents.sizedBox(height: 8),

                  // Divider
                  OsmeaComponents.divider(),
                  OsmeaComponents.sizedBox(height: 8),

                  // Total - Highlighted
                  OsmeaComponents.row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OsmeaComponents.text(
                        context.t.cartView.widgets.orderSummary.total,
                        textStyle: OsmeaTextStyle.titleLarge(context).copyWith(
                          fontWeight: FontWeight.w800,
                          color: OsmeaColors.thunder,
                        ),
                      ),
                      OsmeaComponents.container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: OsmeaColors.black.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: OsmeaComponents.text(
                          PriceInfoCurrencyHelper.formatPrice(
                            state.totalPrice,
                            currencyCode: state.currencyCode,
                          ),
                          textStyle: OsmeaTextStyle.titleLarge(context)
                              .copyWith(
                                color: OsmeaColors.black,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Handles checkout process with authentication check
  void _handleCheckout(BuildContext context) async {
    try {
      // Check if user is authenticated
      final authStorage = AuthStorageHelper();
      final isAuthenticated = await authStorage.isAuthenticated();

      if (!isAuthenticated) {
        // User not authenticated, emit auth required state
        viewModel.loadCart(); // Trigger reload to show auth required state
        return;
      }

      // User is authenticated, proceed with checkout
      // Navigate to bank transfer payment view
      if (context.mounted) {
        final currentState = viewModel.state;
        if (currentState is CartLoadedState) {
          // Navigate to checkout page where user will fill address forms
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.t.cartView.checkout.authenticationError.replaceAll('{error}', e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

/// Loading widget for cart view
class CartLoadingWidget extends StatelessWidget {
  const CartLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

/// Error widget for cart view
class CartErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const CartErrorWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.center(
      child: OsmeaComponents.column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: OsmeaColors.red),
          OsmeaComponents.sizedBox(height: 16),
          OsmeaComponents.text(
            message,
            textStyle: OsmeaTextStyle.bodyMedium(context),
            textAlign: TextAlign.center,
          ),
          OsmeaComponents.sizedBox(height: 16),
          OsmeaComponents.button(onPressed: onRetry, text: context.t.cartView.error.retry),
        ],
      ),
    );
  }
}
