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
import 'package:storefront_supabase/app/views/view_cart/models/cart_view_model.dart';
import 'package:storefront_supabase/app/views/view_cart/models/module/states.dart';
import 'package:storefront_supabase/app/utils/price_helper.dart';
import 'package:storefront_supabase/app/core/bloc/currency/currency_cubit.dart';

/// Shows add to cart success bottom sheet with cart summary
void showAddToCartSuccessPopup(BuildContext context, {String? cartToken}) {
  final cartViewModel = GetIt.I<CartViewModel>();
  // Supabase doesn't use cartToken the same way as Woo, but let's refresh
  cartViewModel.initial();

  OsmeaBottomSheetHelpers.showModal(
    context: context,
    size: BottomSheetSize.large,
    title: 'Product Added to Cart',
    backgroundColor: OsmeaColors.paperWhite,
    openDuration: const Duration(milliseconds: 600),
    closeDuration: const Duration(milliseconds: 250),
    footer: BlocBuilder<CartViewModel, CartState>(
      bloc: cartViewModel,
      builder: (context, cartState) {
        if (cartState is! CartLoadedState || cartState.cartItems.isEmpty) {
          return const SizedBox.shrink();
        }
        return OsmeaComponents.container(
          decoration: BoxDecoration(
            color: OsmeaColors.paperWhite,
            border: Border(top: BorderSide(color: OsmeaColors.grayMaterial[200]!, width: 1)),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: context.spacing16,
            vertical: context.spacing12,
          ),
          child: OsmeaComponents.column(
            children: [
              OsmeaComponents.row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                        '${cartState.cartItems.length}',
                        textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
                          color: OsmeaColors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
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
                      BlocBuilder<CurrencyCubit, String>(
                        builder: (context, currency) {
                          return OsmeaComponents.text(
                            PriceHelper.format(cartState.totalPrice, currency, Localizations.localeOf(context).toString()),
                            textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
                              color: OsmeaColors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          );
                        }
                      ),
                    ],
                  ),
                ],
              ),
              OsmeaComponents.sizedBox(height: context.spacing12),
              OsmeaComponents.row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OsmeaComponents.expanded(
                    child: OsmeaComponents.button(
                      text: 'Continue Shopping',
                      variant: ButtonVariant.outlined,
                      size: ButtonSize.small,
                      backgroundColor: OsmeaColors.white,
                      textColor: OsmeaColors.black,
                      borderColor: OsmeaColors.black,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  OsmeaComponents.sizedBox(width: context.spacing8),
                  OsmeaComponents.expanded(
                    child: OsmeaComponents.button(
                      text: 'View Cart',
                      variant: ButtonVariant.primary,
                      size: ButtonSize.small,
                      backgroundColor: OsmeaColors.black,
                      textColor: OsmeaColors.white,
                      onPressed: () {
                        if (context.mounted) {
                          Navigator.pop(context);
                          context.go('/cart');
                        }
                      },
                    ),
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
        if (cartState is CartLoadingState || cartState is CartInitialState) {
          return OsmeaComponents.container(
            padding: EdgeInsets.all(context.spacing24),
            child: OsmeaComponents.center(
              child: OsmeaComponents.loading(
                type: LoadingType.circularFade,
                size: context.iconSizeLarge,
                color: const Color(0xFF1976D2),
              ),
            ),
          );
        }

        if (cartState is CartErrorState) {
          return OsmeaComponents.container(
            padding: EdgeInsets.all(context.spacing24),
            child: OsmeaComponents.column(
              children: [
                OsmeaComponents.text(
                  'Failed to load cart',
                  textStyle: OsmeaTextStyle.bodyMedium(context),
                  color: OsmeaColors.grayMaterial[400]!,
                ),
                OsmeaComponents.sizedBox(height: context.spacing16),
                OsmeaComponents.button(
                  text: 'Retry',
                  onPressed: () {
                    cartViewModel.initial();
                  },
                  variant: ButtonVariant.outlined,
                  size: ButtonSize.medium,
                ),
              ],
            ),
          );
        }

        if (cartState is CartLoadedState) {
          return SingleChildScrollView(
            child: OsmeaComponents.column(
              children: [
                OsmeaComponents.sizedBox(height: context.spacing12),
                if (cartState.cartItems.isNotEmpty)
                  OsmeaComponents.container(
                    margin: EdgeInsets.symmetric(horizontal: context.spacing16),
                    padding: EdgeInsets.symmetric(horizontal: context.spacing16, vertical: context.spacing12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF4CAF50), width: 1),
                    ),
                    child: OsmeaComponents.row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle_rounded, color: const Color(0xFF4CAF50), size: context.iconSizeMedium),
                        OsmeaComponents.sizedBox(width: context.spacing10),
                        OsmeaComponents.expanded(
                          child: OsmeaComponents.text(
                            'Product successfully added to cart.',
                            textAlign: TextAlign.center,
                            textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF2E7D32),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                // Simplified list for Supabase
                if (cartState.cartItems.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.all(context.spacing16),
                    child: Column(
                      children: cartState.cartItems.map((item) {
                        return ListTile(
                          leading: item.product.imageUrl.isNotEmpty
                              ? Image.network(item.product.imageUrl, width: 50, height: 50, fit: BoxFit.cover)
                              : const Icon(Icons.image),
                          title: Text(item.product.name),
                          subtitle: Text('Qty: ${item.quantity}'),
                        );
                      }).toList(),
                    ),
                  ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    ),
  );
}
