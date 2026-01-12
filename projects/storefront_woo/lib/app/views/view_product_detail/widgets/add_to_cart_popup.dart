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
import 'package:storefront_woo/gen/translations.g.dart';

/// Get color from config
Color _getColorFromConfig(String key, Color fallback) {
  final configHelper = AssetConfigHelper();
  return ColorHelper.getColorFromConfig(
    configHelper,
    'dialog_popup_configuration.add_to_cart_popup.$key',
    fallback: fallback,
  );
}

/// Get button color from config
Color _getButtonColorFromConfig(String key, Color fallback) {
  final configHelper = AssetConfigHelper();
  return ColorHelper.getColorFromConfig(
    configHelper,
    'dialog_popup_configuration.buttons.$key',
    fallback: fallback,
  );
}

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

  // Get colors from config
  final backgroundColor = _getColorFromConfig(
    'backgroundColor',
    OsmeaColors.paperWhite,
  );
  final footerBackgroundColor = _getColorFromConfig(
    'footerBackgroundColor',
    OsmeaColors.paperWhite,
  );
  final footerBorderColor = _getColorFromConfig(
    'footerBorderColor',
    OsmeaColors.grayMaterial[200]!,
  );

  // Show bottom sheet with cart summary
  OsmeaBottomSheetHelpers.showModal(
    context: context,
    size: BottomSheetSize.large,
    title: context.t.productDetailView.addToCart.popup.title,
    backgroundColor: backgroundColor,
    footer: BlocBuilder<CartViewModel, CartState>(
      bloc: cartViewModel,
      builder: (context, cartState) {
        if (cartState is! CartLoadedState) {
          return const SizedBox.shrink();
        }
        return OsmeaComponents.container(
          decoration: BoxDecoration(
            color: footerBackgroundColor,
            border: Border(top: BorderSide(color: footerBorderColor, width: 1)),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: context.spacing16,
            vertical: context.spacing12,
          ),
          child: OsmeaComponents.column(
            children: [
              // Price and item count info
              OsmeaComponents.row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Item count
                  OsmeaComponents.column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      OsmeaComponents.text(
                        'Items',
                        textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                          color: OsmeaColors.grayMaterial[500] ?? OsmeaColors.pewter,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      OsmeaComponents.sizedBox(height: context.spacing2),
                      OsmeaComponents.text(
                        '${cartState.totalItems}',
                        textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
                          color: OsmeaColors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  // Total price
                  OsmeaComponents.column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      OsmeaComponents.text(
                        'Total',
                        textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                          color: OsmeaColors.grayMaterial[500] ?? OsmeaColors.pewter,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      OsmeaComponents.sizedBox(height: context.spacing2),
                      OsmeaComponents.text(
                        PriceInfoCurrencyHelper.formatPrice(
                          cartState.totalPrice,
                          currencyCode: cartState.currencyCode,
                          currencyDecimalSeparator: cartState.currencyDecimalSeparator,
                          currencyThousandSeparator: cartState.currencyThousandSeparator,
                          decimalPlaces: cartState.currencyMinorUnit ?? 2,
                          removeTrailingZeros: true,
                        ),
                        textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
                          color: OsmeaColors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              OsmeaComponents.sizedBox(height: context.spacing12),
              // Buttons row
              OsmeaComponents.row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Continue shopping button
                  Builder(
                    builder: (context) {
                      final secondaryBgColor = _getButtonColorFromConfig(
                        'secondary.backgroundColor',
                        OsmeaColors.white,
                      );
                      final secondaryTextColor = _getButtonColorFromConfig(
                        'secondary.textColor',
                        OsmeaColors.black,
                      );
                      final secondaryBorderColor = _getButtonColorFromConfig(
                        'secondary.borderColor',
                        OsmeaColors.black,
                      );

                      return OsmeaComponents.expanded(
                        child: OsmeaComponents.button(
                          text: context.t.productDetailView.addToCart.popup.continueShopping,
                          variant: ButtonVariant.outlined,
                          size: ButtonSize.small,
                          backgroundColor: secondaryBgColor,
                          textColor: secondaryTextColor,
                          borderColor: secondaryBorderColor,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      );
                    },
                  ),
                  OsmeaComponents.sizedBox(width: context.spacing8),
                  // Checkout button
                  Builder(
                    builder: (context) {
                      final primaryBgColor = _getButtonColorFromConfig(
                        'primary.backgroundColor',
                        OsmeaColors.black,
                      );
                      final primaryTextColor = _getButtonColorFromConfig(
                        'primary.textColor',
                        OsmeaColors.white,
                      );

                      return OsmeaComponents.expanded(
                        child: OsmeaComponents.button(
                          text: context.t.productDetailView.addToCart.popup.checkout,
                          variant: ButtonVariant.primary,
                          size: ButtonSize.small,
                          backgroundColor: primaryBgColor,
                          textColor: primaryTextColor,
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
                      );
                    },
                  ),
                ],
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
                color: _getColorFromConfig(
                  'loadingColor',
                  const Color(0xFF1976D2),
                ),
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
                  context.t.productDetailView.addToCart.popup.failedToLoad,
                  textStyle: OsmeaTextStyle.bodyMedium(context),
                  color: OsmeaColors.grayMaterial[400]!,
                ),
                OsmeaComponents.sizedBox(height: context.spacing16),
                OsmeaComponents.button(
                  text: context.t.productDetailView.addToCart.popup.retry,
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
                Builder(
                  builder: (context) {
                    final successBgColor = _getColorFromConfig(
                      'successBackgroundColor',
                      const Color(0xFFE8F5E9),
                    );
                    final successBorderColor = _getColorFromConfig(
                      'successBorderColor',
                      const Color(0xFF4CAF50),
                    );
                    final successIconColor = _getColorFromConfig(
                      'successIconColor',
                      const Color(0xFF4CAF50),
                    );
                    final successTextColor = _getColorFromConfig(
                      'successTextColor',
                      const Color(0xFF2E7D32),
                    );

                    return OsmeaComponents.container(
                      margin: EdgeInsets.symmetric(
                        horizontal: context.spacing16,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: context.spacing16,
                        vertical: context.spacing12,
                      ),
                      decoration: BoxDecoration(
                        color: successBgColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: successBorderColor, width: 1),
                      ),
                      child: OsmeaComponents.row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            color: successIconColor,
                            size: context.iconSizeMedium,
                          ),
                          OsmeaComponents.sizedBox(width: context.spacing10),
                          OsmeaComponents.expanded(
                            child: OsmeaComponents.text(
                              context.t.productDetailView.addToCart.popup.successMessage,
                              textAlign: TextAlign.center,
                              textStyle: OsmeaTextStyle.bodySmall(context)
                                  .copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: successTextColor,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
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
                                ? context.t.productDetailView.addToCart.popup.itemCount.single
                                : context.t.productDetailView.addToCart.popup.itemCount.multiple.replaceAll('{count}', itemCount.toString()),
                            textStyle: OsmeaTextStyle.titleSmall(context)
                                .copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: _getColorFromConfig(
                                    'titleColor',
                                    const Color(0xFF1976D2),
                                  ),
                                ),
                          );
                        }
                        return OsmeaComponents.text(
                          context.t.productDetailView.addToCart.popup.itemCount.multiple.replaceAll('{count}', cartState.cartItems.length.toString()),
                          textStyle: OsmeaTextStyle.titleSmall(context)
                              .copyWith(
                                fontWeight: FontWeight.w600,
                                color: _getColorFromConfig(
                                  'titleColor',
                                  const Color(0xFF1976D2),
                                ),
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
                          isInBottomSheet: true,
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
            context.t.productDetailView.addToCart.popup.loading,
            textStyle: OsmeaTextStyle.bodyMedium(context),
            color: OsmeaColors.grayMaterial[400]!,
          ),
        );
      },
    ),
  );
}
