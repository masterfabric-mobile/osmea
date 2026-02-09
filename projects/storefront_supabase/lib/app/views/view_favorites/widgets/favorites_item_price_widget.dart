import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_supabase/app/core/bloc/currency/currency_cubit.dart';
import 'package:storefront_supabase/app/models/product.dart';
import 'package:storefront_supabase/app/utils/price_helper.dart';

/// Woo-style price display for a favorite product (sale + strikethrough regular).
class FavoritesItemPriceWidget extends StatelessWidget {
  final Product product;

  const FavoritesItemPriceWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final currency = context.watch<CurrencyCubit>().state;
    final hasDiscount = product.hasDiscount;

    if (hasDiscount) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          OsmeaComponents.text(
            PriceHelper.format(product.effectivePrice, currency, locale),
            color: OsmeaColors.black,
            textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          OsmeaComponents.sizedBox(width: context.spacing6),
          OsmeaComponents.text(
            PriceHelper.format(product.price, currency, locale),
            color: OsmeaColors.grayMaterial[400]!,
            textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
              decoration: TextDecoration.lineThrough,
            ),
          ),
        ],
      );
    }

    return OsmeaComponents.text(
      PriceHelper.format(product.effectivePrice, currency, locale),
      color: OsmeaColors.black,
      textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
