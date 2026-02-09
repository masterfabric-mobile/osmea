import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_supabase/app/core/bloc/currency/currency_cubit.dart';
import 'package:storefront_supabase/app/utils/price_helper.dart';
import 'package:storefront_supabase/app/models/product.dart';

class ActionSection extends StatelessWidget {
  final bool isInWishlist;
  final VoidCallback onToggleWishlist;

  final bool isInCart;
  final Future<void> Function() onAddToCart;

  final VoidCallback? onShare;
  final bool showWishlistAndShare;
  final Product? product;

  const ActionSection({
    super.key,
    required this.isInWishlist,
    required this.onToggleWishlist,
    required this.isInCart,
    required this.onAddToCart,
    this.onShare,
    this.showWishlistAndShare = true,
    this.product,
  });

  @override
  Widget build(BuildContext context) {
    if (product == null) return const SizedBox.shrink();
    
    return OsmeaComponents.row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Price display - left side
        OsmeaComponents.expanded(
          child: BlocBuilder<CurrencyCubit, String>(
            builder: (context, currency) {
              return OsmeaComponents.column(
                crossAxisAlignment: context.crossStart,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (product!.hasDiscount) ...[
                    OsmeaComponents.text(
                      PriceHelper.format(product!.salePrice!, currency, Localizations.localeOf(context).toString()),
                      textStyle: OsmeaTextStyle.titleLarge(context).copyWith(
                        color: OsmeaColors.black,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                    ),
                    OsmeaComponents.sizedBox(height: context.spacing2),
                    OsmeaComponents.text(
                      PriceHelper.format(product!.price, currency, Localizations.localeOf(context).toString()),
                      textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                        color: OsmeaColors.grayMaterial[400]!,
                        fontWeight: FontWeight.w400,
                        decoration: TextDecoration.lineThrough,
                        decorationColor: OsmeaColors.grayMaterial[400]!,
                        decorationThickness: 1.5,
                      ),
                    ),
                  ] else ...[
                    OsmeaComponents.text(
                      PriceHelper.format(product!.price, currency, Localizations.localeOf(context).toString()),
                      textStyle: OsmeaTextStyle.titleLarge(context).copyWith(
                        color: OsmeaColors.black,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        ),
        // Add to Cart button - right side
        OsmeaComponents.expanded(
          child: Material(
            color: OsmeaColors.black,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              onTap: () async {
                await onAddToCart();
              },
              borderRadius: BorderRadius.circular(8),
              child: OsmeaComponents.container(
                height: 50,
                child: OsmeaComponents.center(
                  child: OsmeaComponents.text(
                    isInCart
                        ? 'In Cart'
                        : 'Add to Cart',
                    textStyle: OsmeaTextStyle.bodyLarge(context).copyWith(
                      color: OsmeaColors.white,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
