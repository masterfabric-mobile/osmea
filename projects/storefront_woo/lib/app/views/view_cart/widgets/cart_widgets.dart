/*
 * Cart Widgets
 * ------------
 * Widgets for the cart view following OSMEA architecture.
 * Uses OsmeaComponents for consistent UI.
 */

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';
import 'package:storefront_woo/app/views/view_cart/models/cart_view_model.dart';
import 'package:storefront_woo/app/views/view_cart/models/module/states.dart';

/// Main content widget for cart view
class CartContentWidget extends StatefulWidget {
  final CartViewModel viewModel;
  final CartLoadedState state;

  const CartContentWidget({
    super.key,
    required this.viewModel,
    required this.state,
  });

  @override
  State<CartContentWidget> createState() => _CartContentWidgetState();
}

class _CartContentWidgetState extends State<CartContentWidget> {
  final TextEditingController _couponController = TextEditingController();

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;
    final state = widget.state;
    if (state.cartItems.isEmpty) {
      return _buildEmptyCart(context);
    }

    return OsmeaComponents.singleChildScrollView(
      child: OsmeaComponents.column(
        children: [
          // Cart items with swipe-to-delete
          ...state.cartItems.map(
            (item) => _buildCartItemWithSwipe(context, item, viewModel, state),
          ),

          OsmeaComponents.sizedBox(height: 8),

          // Coupon section
          _buildCouponSection(context, viewModel, state),

          OsmeaComponents.sizedBox(height: 8),

          // Order summary
          _buildOrderSummary(context, state),

          OsmeaComponents.sizedBox(height: 16),
        ],
      ),
    );
  }

  /// Builds empty cart widget
  Widget _buildEmptyCart(BuildContext context) {
    // Navigate to empty view route
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.go('/empty/cart?actionPath=/home');
    });
    // Return empty container while navigating
    return const SizedBox.shrink();
  }

  /// Builds cart item with swipe-to-delete functionality
  Widget _buildCartItemWithSwipe(
    BuildContext context,
    CartItem item,
    CartViewModel viewModel,
    CartLoadedState state,
  ) {
    return Dismissible(
      key: Key('cart_item_${item.key}'),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 8),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: context.spacing20),
        decoration: BoxDecoration(
          color: OsmeaColors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(
              Icons.delete_outline_rounded,
              color: OsmeaColors.white,
              size: 28,
            ),
            SizedBox(width: context.spacing12),
            Text(
              'Remove',
              style: OsmeaTextStyle.titleMedium(
                context,
              ).copyWith(color: OsmeaColors.white, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        // Show confirmation dialog
        return await showDialog<bool>(
              context: context,
              builder: (BuildContext dialogContext) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  title: Text(
                    'Remove item?',
                    style: OsmeaTextStyle.titleMedium(
                      context,
                    ).copyWith(fontWeight: FontWeight.w600),
                  ),
                  content: Text(
                    'Are you sure you want to remove "${item.productName}" from your cart?',
                    style: OsmeaTextStyle.bodyMedium(context),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(false),
                      child: Text(
                        'Cancel',
                        style: OsmeaTextStyle.bodyMedium(
                          context,
                        ).copyWith(color: OsmeaColors.pewter),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(true),
                      style: TextButton.styleFrom(
                        foregroundColor: OsmeaColors.red,
                      ),
                      child: Text(
                        'Remove',
                        style: OsmeaTextStyle.bodyMedium(context).copyWith(
                          color: OsmeaColors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ) ??
            false;
      },
      onDismissed: (direction) {
        // Remove item from cart
        viewModel.removeItemFromCart(item.productId);
        // Show snackbar with Undo
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Item removed from cart'),
            backgroundColor: OsmeaColors.thunder,
            action: SnackBarAction(
              label: 'Undo',
              textColor: OsmeaColors.white,
              onPressed: () {
                // Re-add item to cart
                viewModel.addItemToCart(
                  item.productId,
                  quantity: item.quantity,
                );
              },
            ),
            duration: Duration(seconds: 3),
          ),
        );
      },
      child: _buildCartItem(context, item, viewModel, state),
    );
  }

  /// Builds individual cart item widget - MINIMAL ELEGANT DESIGN WITH BOTTOM CONTROLS
  Widget _buildCartItem(
    BuildContext context,
    CartItem item,
    CartViewModel viewModel,
    CartLoadedState state,
  ) {
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: item.imageUrl != null
                        ? Image.network(
                            item.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return OsmeaComponents.center(
                                child: Icon(
                                  Icons.image_outlined,
                                  color: OsmeaColors.pewter.withValues(
                                    alpha: 0.5,
                                  ),
                                  size: 32,
                                ),
                              );
                            },
                          )
                        : OsmeaComponents.center(
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
                      // Show variations if available
                      if (item.formattedVariations.isNotEmpty) ...[
                        OsmeaComponents.sizedBox(height: 4),
                        OsmeaComponents.text(
                          item.formattedVariations,
                          textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                            color: OsmeaColors.pewter,
                            fontWeight: FontWeight.w400,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      OsmeaComponents.sizedBox(height: 4),
                      OsmeaComponents.text(
                        PriceInfoCurrencyHelper.formatPrice(
                          item.price,
                          currencyCode: state.currencyCode,
                          removeTrailingZeros: true,
                        ),
                        textStyle: OsmeaTextStyle.bodyLarge(context).copyWith(
                          color: OsmeaColors.nordicBlue,
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
                          color: OsmeaColors.nordicBlue,
                          size: 16,
                        ),
                        backgroundColor: Colors.transparent,
                      ),
                    ],
                  ),
                ),

                // Delete Button - Text Button for better readability
                OsmeaComponents.button(
                  onPressed: () => viewModel.removeItemFromCart(item.productId),
                  backgroundColor: OsmeaColors.red.withValues(alpha: 0.1),
                  textColor: OsmeaColors.red,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  text: 'Remove',
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
  Widget _buildCouponSection(
    BuildContext context,
    CartViewModel viewModel,
    CartLoadedState state,
  ) {
    return OsmeaComponents.column(
      children: [
        // Applied coupons list
        if (state.coupons.isNotEmpty) ...[
          ...state.coupons.map((coupon) => _buildAppliedCoupon(context, coupon, viewModel, state)),
          OsmeaComponents.sizedBox(height: 8),
        ],
        
        // Coupon input section
        OsmeaComponents.container(
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
                  color: OsmeaColors.nordicBlue.withValues(alpha: 0.7),
                  size: 20,
                ),
                OsmeaComponents.sizedBox(width: 12),

                // Minimal Input Field
                OsmeaComponents.expanded(
                  child: OsmeaComponents.textField(
                    controller: _couponController,
                    hint: 'Discount code',
                    textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                      fontWeight: FontWeight.w400,
                      color: OsmeaColors.thunder,
                    ),
                    onSubmitted: (value) {
                      if (value.trim().isNotEmpty) {
                        viewModel.applyCoupon(value.trim());
                        _couponController.clear();
                      }
                    },
                  ),
                ),
                OsmeaComponents.sizedBox(width: 8),

                // Minimal Apply Button
                OsmeaComponents.button(
                  onPressed: () {
                    final couponCode = _couponController.text.trim();
                    if (couponCode.isNotEmpty) {
                      viewModel.applyCoupon(couponCode);
                      _couponController.clear();
                    }
                  },
                  backgroundColor: OsmeaColors.nordicBlue.withValues(alpha: 0.1),
                  textColor: OsmeaColors.nordicBlue,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  text: 'Apply',
                  textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                    color: OsmeaColors.nordicBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Builds applied coupon widget
  Widget _buildAppliedCoupon(
    BuildContext context,
    dynamic coupon,
    CartViewModel viewModel,
    CartLoadedState state,
  ) {
    final couponCode = coupon.code ?? '';
    final discount = coupon.totals?.totalDiscount != null
        ? double.tryParse(coupon.totals!.totalDiscount!) ?? 0.0
        : 0.0;
    
    return OsmeaComponents.container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: OsmeaColors.nordicBlue.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: OsmeaColors.nordicBlue.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: OsmeaComponents.padding(
        padding: const EdgeInsets.all(12),
        child: OsmeaComponents.row(
          children: [
            Icon(
              Icons.check_circle,
              color: OsmeaColors.nordicBlue,
              size: 20,
            ),
            OsmeaComponents.sizedBox(width: 8),
            OsmeaComponents.expanded(
              child: OsmeaComponents.column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OsmeaComponents.text(
                    couponCode.toUpperCase(),
                    textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                      fontWeight: FontWeight.w600,
                      color: OsmeaColors.nordicBlue,
                    ),
                  ),
                  if (discount > 0) ...[
                    OsmeaComponents.sizedBox(height: 2),
                    OsmeaComponents.text(
                      'Discount: ${PriceInfoCurrencyHelper.formatPrice(
                        discount,
                        currencyCode: state.currencyCode,
                        removeTrailingZeros: true,
                      )}',
                      textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                        color: OsmeaColors.pewter,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            OsmeaComponents.iconButton(
              onPressed: () => viewModel.removeCoupon(couponCode),
              icon: Icon(
                Icons.close,
                color: OsmeaColors.red,
                size: 18,
              ),
              backgroundColor: Colors.transparent,
              tooltip: 'Remove coupon',
            ),
          ],
        ),
      ),
    );
  }

  /// Builds order summary - FRESH E-COMMERCE DESIGN
  Widget _buildOrderSummary(BuildContext context, CartLoadedState state) {
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
                  color: OsmeaColors.nordicBlue,
                  size: 24,
                ),
                OsmeaComponents.sizedBox(width: 8),
                OsmeaComponents.text(
                  'Order Summary',
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
                        'Subtotal',
                        textStyle: OsmeaTextStyle.bodyLarge(context).copyWith(
                          fontWeight: FontWeight.w500,
                          color: OsmeaColors.thunder,
                        ),
                      ),
                      OsmeaComponents.text(
                        PriceInfoCurrencyHelper.formatPrice(
                          state.totalPrice + state.totalDiscount,
                          currencyCode: state.currencyCode,
                          removeTrailingZeros: true,
                        ),
                        textStyle: OsmeaTextStyle.bodyLarge(context).copyWith(
                          fontWeight: FontWeight.w700,
                          color: OsmeaColors.thunder,
                        ),
                      ),
                    ],
                  ),
                  OsmeaComponents.sizedBox(height: 12),

                  // Discount (if coupons applied)
                  if (state.totalDiscount > 0) ...[
                    OsmeaComponents.row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OsmeaComponents.text(
                          'Discount',
                          textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                            color: OsmeaColors.nordicBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        OsmeaComponents.text(
                          '-${PriceInfoCurrencyHelper.formatPrice(
                            state.totalDiscount,
                            currencyCode: state.currencyCode,
                            removeTrailingZeros: true,
                          )}',
                          textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                            color: OsmeaColors.nordicBlue,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    OsmeaComponents.sizedBox(height: 12),
                  ],

                  // Shipping
                  OsmeaComponents.row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OsmeaComponents.text(
                        'Shipping',
                        textStyle: OsmeaTextStyle.bodyMedium(
                          context,
                        ).copyWith(color: OsmeaColors.pewter),
                      ),
                      OsmeaComponents.text(
                        'Calculated at checkout',
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
                        'Tax',
                        textStyle: OsmeaTextStyle.bodyMedium(
                          context,
                        ).copyWith(color: OsmeaColors.pewter),
                      ),
                      OsmeaComponents.text(
                        'Calculated at checkout',
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
                        'Total',
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
                          color: OsmeaColors.nordicBlue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: OsmeaComponents.text(
                          PriceInfoCurrencyHelper.formatPrice(
                            state.totalPrice,
                            currencyCode: state.currencyCode,
                          ),
                          textStyle: OsmeaTextStyle.titleLarge(context)
                              .copyWith(
                                color: OsmeaColors.nordicBlue,
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
          OsmeaComponents.button(onPressed: onRetry, text: 'Retry'),
        ],
      ),
    );
  }
}
