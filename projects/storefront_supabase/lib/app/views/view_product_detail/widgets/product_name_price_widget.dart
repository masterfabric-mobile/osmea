/*
 * Product Name Price Widget
 * --------------------------
 * Widget for displaying product name and price.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_supabase/app/core/bloc/currency/currency_cubit.dart';
import 'package:storefront_supabase/app/utils/price_helper.dart';
import 'package:storefront_supabase/app/views/view_product_detail/models/module/states.dart';

class ProductNamePriceWidget extends StatelessWidget {
  final ProductDetailLoadedState state;

  const ProductNamePriceWidget({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final product = state.product;
    final hasDiscount = product.hasDiscount;

    return OsmeaComponents.padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.spacing16,
        vertical: context.spacing12,
      ),
      child: OsmeaComponents.column(
        crossAxisAlignment: context.crossStart,
        children: [
          OsmeaComponents.text(
            product.name,
            textStyle: OsmeaTextStyle.titleLarge(context).copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: -0.3,
              height: 1.3,
              color: OsmeaColors.black,
            ),
          ),

          OsmeaComponents.sizedBox(height: context.spacing10),

          BlocBuilder<CurrencyCubit, String>(
            builder: (context, currency) {
              return OsmeaComponents.column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OsmeaComponents.row(
                    children: [
                      if (hasDiscount) ...[
                        OsmeaComponents.text(
                          PriceHelper.format(
                            product.price,
                            currency,
                            Localizations.localeOf(context).toString()
                          ),
                          textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
                                decoration: TextDecoration.lineThrough,
                                color: OsmeaColors.grayMaterial[600],
                              ),
                        ),
                        OsmeaComponents.sizedBox(width: 8),
                      ],
                      OsmeaComponents.text(
                        PriceHelper.format(
                          product.effectivePrice,
                          currency,
                          Localizations.localeOf(context).toString()
                        ),
                        textStyle: OsmeaTextStyle.titleLarge(context).copyWith(
                              color: OsmeaColors.black,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  if (hasDiscount && product.discountPercentage != null) ...[
                    OsmeaComponents.sizedBox(height: 4),
                    OsmeaComponents.container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF000000),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: OsmeaComponents.text(
                        'SALE -${product.discountPercentage!.toStringAsFixed(0)}%',
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
