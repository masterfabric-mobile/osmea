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
          OsmeaComponents.sizedBox(height: 12),

          // Cart items with swipe-to-delete and dividers
          ...state.cartItems.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return OsmeaComponents.column(
              children: [
                _buildCartItemWithSwipe(context, item, viewModel, state),
                // Divider between items (except last)
                if (index < state.cartItems.length - 1)
                  OsmeaComponents.container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    height: 1,
                    color: OsmeaColors.grayMaterial[200],
                  ),
              ],
            );
          }),

          OsmeaComponents.sizedBox(height: 12),

          // Coupon section
          _buildCouponSection(context, viewModel, state),

          OsmeaComponents.sizedBox(height: 12),

          // Order summary
          _buildOrderSummary(context, state),

          OsmeaComponents.sizedBox(height: 12),
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

  /// Formats variations string for better readability
  String _formatVariationsForDisplay(String variations) {
    // Clean up common technical terms and make more readable
    return variations
        .replaceAll('Pa ', '') // Remove remaining 'Pa ' if any
        .replaceAll('pa_', '') // Remove any remaining 'pa_' prefix
        .replaceAll('_', ' ') // Replace underscores with spaces
        .split(',')
        .map((part) {
          // Clean each part
          String cleaned = part.trim();
          // Capitalize first letter of each word
          cleaned = cleaned
              .split(' ')
              .map((word) {
                if (word.isEmpty) return word;
                return word[0].toUpperCase() + word.substring(1).toLowerCase();
              })
              .join(' ');
          return cleaned;
        })
        .join(', ');
  }

  /// Builds variations text with bold attribute names
  Widget _buildVariationsWithBoldAttributes(
    BuildContext context,
    String variations,
  ) {
    final formatted = _formatVariationsForDisplay(variations);
    final parts = formatted.split(',');

    final textSpans = <TextSpan>[];
    for (int i = 0; i < parts.length; i++) {
      final part = parts[i].trim();
      if (part.isEmpty) continue;

      // Split by colon to separate attribute name and value
      final colonIndex = part.indexOf(':');
      if (colonIndex > 0) {
        final attributeName = part.substring(0, colonIndex).trim();
        final value = part.substring(colonIndex + 1).trim();

        // Bold attribute name
        textSpans.add(
          TextSpan(
            text: attributeName,
            style: OsmeaTextStyle.bodySmall(context).copyWith(
              color: OsmeaColors.pewter,
              fontWeight: FontWeight.w600,
              height: 1.3,
              fontSize: 10,
            ),
          ),
        );
        // Normal value
        textSpans.add(
          TextSpan(
            text: ': $value',
            style: OsmeaTextStyle.bodySmall(context).copyWith(
              color: OsmeaColors.pewter,
              fontWeight: FontWeight.w400,
              height: 1.3,
              fontSize: 10,
            ),
          ),
        );
      } else {
        // No colon found, use normal text
        textSpans.add(
          TextSpan(
            text: part,
            style: OsmeaTextStyle.bodySmall(context).copyWith(
              color: OsmeaColors.pewter,
              fontWeight: FontWeight.w400,
              height: 1.3,
              fontSize: 10,
            ),
          ),
        );
      }

      // Add comma separator (except for last item)
      if (i < parts.length - 1) {
        textSpans.add(
          TextSpan(
            text: ', ',
            style: OsmeaTextStyle.bodySmall(context).copyWith(
              color: OsmeaColors.pewter,
              fontWeight: FontWeight.w400,
              height: 1.3,
              fontSize: 10,
            ),
          ),
        );
      }
    }

    return RichText(
      text: TextSpan(children: textSpans),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
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
        margin: const EdgeInsets.only(bottom: 8, left: 16, right: 16),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: context.spacing20),
        decoration: BoxDecoration(
          color: OsmeaColors.red,
          borderRadius: BorderRadius.circular(12),
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

  /// Builds individual cart item widget - ULTRA MINIMALIST DESIGN
  Widget _buildCartItem(
    BuildContext context,
    CartItem item,
    CartViewModel viewModel,
    CartLoadedState state,
  ) {
    // Get cartToken from viewModel arguments
    final cartToken = viewModel.arguments['cartToken'] as String?;

    return OsmeaComponents.container(
      margin: const EdgeInsets.only(left: 16, right: 16),
      decoration: BoxDecoration(
        color: OsmeaColors.white,
        border: Border(
          bottom: BorderSide(color: OsmeaColors.grayMaterial[200]!, width: 0.5),
        ),
      ),
      child: InkWell(
        onTap: () {
          // Navigate to product detail page
          context.push(
            '/product-detail/${item.productId}',
            extra: cartToken != null ? {'cartToken': cartToken} : null,
          );
        },
        child: OsmeaComponents.padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: OsmeaComponents.row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image - Compact vertical
              OsmeaComponents.container(
                width: 60,
                height: 75,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: OsmeaColors.grayMaterial[50],
                ),
                child: OsmeaComponents.clipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: item.imageUrl != null
                      ? Image.network(
                          item.imageUrl!,
                          fit: BoxFit.cover,
                          width: 60,
                          height: 75,
                          errorBuilder: (context, error, stackTrace) {
                            return OsmeaComponents.center(
                              child: Icon(
                                Icons.image_outlined,
                                color: OsmeaColors.pewter.withValues(
                                  alpha: 0.3,
                                ),
                                size: 28,
                              ),
                            );
                          },
                        )
                      : OsmeaComponents.center(
                          child: Icon(
                            Icons.image_outlined,
                            color: OsmeaColors.pewter.withValues(alpha: 0.3),
                            size: 28,
                          ),
                        ),
                ),
              ),
              OsmeaComponents.sizedBox(width: 10),

              // Product Info - Compact
              OsmeaComponents.expanded(
                child: OsmeaComponents.column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Product Name - Compact
                    OsmeaComponents.text(
                      item.productName,
                      textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                        fontWeight: FontWeight.w500,
                        color: OsmeaColors.thunder,
                        height: 1.2,
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // Variations - Attribute names bold, fixed height for alignment
                    OsmeaComponents.container(
                      height: 28,
                      child: item.formattedVariations.isNotEmpty
                          ? OsmeaComponents.column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildVariationsWithBoldAttributes(
                                  context,
                                  item.formattedVariations,
                                ),
                              ],
                            )
                          : const SizedBox.shrink(),
                    ),

                    OsmeaComponents.sizedBox(height: 6),

                    // Price - Left aligned
                    OsmeaComponents.text(
                      PriceInfoCurrencyHelper.formatPrice(
                        item.price,
                        currencyCode: state.currencyCode,
                        currencyDecimalSeparator:
                            state.currencyDecimalSeparator,
                        currencyThousandSeparator:
                            state.currencyThousandSeparator,
                        decimalPlaces: state.currencyMinorUnit ?? 2,
                        removeTrailingZeros: true,
                      ),
                      textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                        color: OsmeaColors.nordicBlue,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),

                    OsmeaComponents.sizedBox(height: 6),

                    // Quantity Controls and Remove button - Left and Right
                    OsmeaComponents.row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Quantity Controls - Left side, Compact
                        OsmeaComponents.container(
                          decoration: BoxDecoration(
                            color: OsmeaColors.grayMaterial[50],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: OsmeaComponents.row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Decrease
                              OsmeaComponents.iconButton(
                                onPressed: item.quantity > 1
                                    ? () => viewModel.updateItemQuantity(
                                        item.productId,
                                        item.quantity - 1,
                                      )
                                    : null,
                                icon: Icon(
                                  Icons.remove_rounded,
                                  color: item.quantity > 1
                                      ? OsmeaColors.thunder
                                      : OsmeaColors.pewter.withValues(
                                          alpha: 0.3,
                                        ),
                                  size: 12,
                                ),
                                backgroundColor: Colors.transparent,
                                size: ButtonSize.extraSmall,
                              ),
                              // Quantity
                              OsmeaComponents.padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: OsmeaComponents.text(
                                  '${item.quantity}',
                                  textStyle: OsmeaTextStyle.bodySmall(context)
                                      .copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: OsmeaColors.thunder,
                                        fontSize: 11,
                                      ),
                                ),
                              ),
                              // Increase
                              OsmeaComponents.iconButton(
                                onPressed: () => viewModel.updateItemQuantity(
                                  item.productId,
                                  item.quantity + 1,
                                ),
                                icon: Icon(
                                  Icons.add_rounded,
                                  color: OsmeaColors.nordicBlue,
                                  size: 12,
                                ),
                                backgroundColor: Colors.transparent,
                                size: ButtonSize.extraSmall,
                              ),
                            ],
                          ),
                        ),
                        // Remove button - Right side
                        OsmeaComponents.iconButton(
                          onPressed: () =>
                              viewModel.removeItemFromCart(item.productId),
                          icon: Icon(
                            Icons.delete_outline_rounded,
                            color: OsmeaColors.red,
                            size: 18,
                          ),
                          backgroundColor: Colors.transparent,
                          size: ButtonSize.extraSmall,
                          tooltip: 'Remove item',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds coupon section - MODERN CLEAN DESIGN
  Widget _buildCouponSection(
    BuildContext context,
    CartViewModel viewModel,
    CartLoadedState state,
  ) {
    return OsmeaComponents.column(
      children: [
        // Applied coupons list
        if (state.coupons.isNotEmpty) ...[
          ...state.coupons.map(
            (coupon) => _buildAppliedCoupon(context, coupon, viewModel, state),
          ),
          OsmeaComponents.sizedBox(height: 12),
        ],

        // Coupon input section - Minimalist design
        OsmeaComponents.container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: OsmeaComponents.row(
            children: [
              OsmeaComponents.expanded(
                child: OsmeaComponents.textField(
                  controller: _couponController,
                  hint: 'Discount code',
                  variant: TextFieldVariant.outlined,
                  size: TextFieldSize.medium,
                  prefixIcon: Icon(
                    Icons.local_offer_outlined,
                    color: OsmeaColors.pewter,
                    size: 20,
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
              OsmeaComponents.textButton(
                text: 'Apply',
                onPressed: () {
                  final couponCode = _couponController.text.trim();
                  if (couponCode.isNotEmpty) {
                    viewModel.applyCoupon(couponCode);
                    _couponController.clear();
                  }
                },
                size: ButtonSize.small,
                variant: ButtonVariant.primary,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Builds applied coupon widget - MINIMAL DESIGN
  Widget _buildAppliedCoupon(
    BuildContext context,
    dynamic coupon,
    CartViewModel viewModel,
    CartLoadedState state,
  ) {
    final couponCode = coupon.code ?? '';

    return OsmeaComponents.container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: OsmeaColors.nordicBlue.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
      ),
      child: OsmeaComponents.padding(
        padding: const EdgeInsets.all(10),
        child: OsmeaComponents.row(
          children: [
            Icon(
              Icons.check_circle_rounded,
              color: OsmeaColors.nordicBlue,
              size: 18,
            ),
            OsmeaComponents.sizedBox(width: 8),
            OsmeaComponents.expanded(
              child: OsmeaComponents.text(
                couponCode.toUpperCase(),
                textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                  fontWeight: FontWeight.w600,
                  color: OsmeaColors.nordicBlue,
                ),
              ),
            ),
            OsmeaComponents.iconButton(
              onPressed: () => viewModel.removeCoupon(couponCode),
              icon: Icon(
                Icons.close_rounded,
                color: OsmeaColors.pewter,
                size: 16,
              ),
              backgroundColor: Colors.transparent,
              tooltip: 'Remove coupon',
            ),
          ],
        ),
      ),
    );
  }

  /// Builds order summary - MINIMAL DESIGN
  Widget _buildOrderSummary(BuildContext context, CartLoadedState state) {
    return OsmeaComponents.container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: OsmeaColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: OsmeaComponents.padding(
        padding: const EdgeInsets.all(14),
        child: OsmeaComponents.column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header - Compact
            OsmeaComponents.text(
              'Order Summary',
              textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
                fontWeight: FontWeight.w700,
                color: OsmeaColors.thunder,
              ),
            ),
            OsmeaComponents.sizedBox(height: 12),

            // Summary Items - Clean list design
            OsmeaComponents.column(
              children: [
                // Subtotal
                _buildSummaryRow(
                  context,
                  'Subtotal',
                  PriceInfoCurrencyHelper.formatPrice(
                    state.totalPrice + state.totalDiscount,
                    currencyCode: state.currencyCode,
                    currencyDecimalSeparator: state.currencyDecimalSeparator,
                    currencyThousandSeparator: state.currencyThousandSeparator,
                    decimalPlaces: state.currencyMinorUnit ?? 2,
                    removeTrailingZeros: true,
                  ),
                  isPrimary: false,
                ),
                OsmeaComponents.sizedBox(height: 10),

                // Discount (if coupons applied)
                if (state.totalDiscount > 0) ...[
                  _buildSummaryRow(
                    context,
                    'Discount',
                    '-${PriceInfoCurrencyHelper.formatPrice(state.totalDiscount, currencyCode: state.currencyCode, currencyDecimalSeparator: state.currencyDecimalSeparator, currencyThousandSeparator: state.currencyThousandSeparator, decimalPlaces: state.currencyMinorUnit ?? 2, removeTrailingZeros: true)}',
                    isPrimary: false,
                    isDiscount: true,
                  ),
                  OsmeaComponents.sizedBox(height: 10),
                ],

                // Shipping
                _buildSummaryRow(
                  context,
                  'Shipping',
                  'Calculated at checkout',
                  isPrimary: false,
                  isSecondary: true,
                ),
                OsmeaComponents.sizedBox(height: 10),

                // Tax
                _buildSummaryRow(
                  context,
                  'Tax',
                  'Calculated at checkout',
                  isPrimary: false,
                  isSecondary: true,
                ),
                OsmeaComponents.sizedBox(height: 12),

                // Divider
                OsmeaComponents.divider(),
                OsmeaComponents.sizedBox(height: 12),

                // Total - Prominent display
                _buildSummaryRow(
                  context,
                  'Total',
                  PriceInfoCurrencyHelper.formatPrice(
                    state.totalPrice,
                    currencyCode: state.currencyCode,
                    currencyDecimalSeparator: state.currencyDecimalSeparator,
                    currencyThousandSeparator: state.currencyThousandSeparator,
                    decimalPlaces: state.currencyMinorUnit ?? 2,
                  ),
                  isPrimary: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Helper method to build summary row
  Widget _buildSummaryRow(
    BuildContext context,
    String label,
    String value, {
    bool isPrimary = false,
    bool isDiscount = false,
    bool isSecondary = false,
  }) {
    return OsmeaComponents.row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        OsmeaComponents.text(
          label,
          textStyle: isPrimary
              ? OsmeaTextStyle.titleMedium(context).copyWith(
                  fontWeight: FontWeight.w700,
                  color: OsmeaColors.thunder,
                )
              : OsmeaTextStyle.bodyMedium(context).copyWith(
                  fontWeight: isDiscount ? FontWeight.w600 : FontWeight.w500,
                  color: isDiscount
                      ? OsmeaColors.nordicBlue
                      : isSecondary
                      ? OsmeaColors.pewter
                      : OsmeaColors.thunder,
                ),
        ),
        OsmeaComponents.text(
          value,
          textStyle: isPrimary
              ? OsmeaTextStyle.titleMedium(context).copyWith(
                  fontWeight: FontWeight.w700,
                  color: OsmeaColors.nordicBlue,
                )
              : isDiscount
              ? OsmeaTextStyle.bodyMedium(context).copyWith(
                  fontWeight: FontWeight.w700,
                  color: OsmeaColors.nordicBlue,
                )
              : OsmeaTextStyle.bodySmall(context).copyWith(
                  fontWeight: FontWeight.w500,
                  color: isSecondary
                      ? OsmeaColors.pewter.withValues(alpha: 0.8)
                      : OsmeaColors.thunder,
                  fontStyle: isSecondary ? FontStyle.italic : FontStyle.normal,
                ),
        ),
      ],
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
