/*
 * ProductCardWidget
 * -----------------
 * Product card widget for home view.
 * Displays product information with image, price, and actions.
 */

import 'package:flutter/material.dart' hide Image;
import 'package:flutter/material.dart' as FlutterMaterial show Image;
import 'package:apis/network/remote/woocommerce/store_api/product_api/freezed_model/response/list_all_products_response_model.dart';
import 'package:core/core.dart';
import 'package:storefront_woo/app/views/view_home/models/home_view_model.dart';
import 'package:get_it/get_it.dart';

/// Product card widget
class ProductCardWidget extends StatelessWidget {
  final ListAllProductsResponseModel product;
  final VoidCallback onWishlistTap;
  final VoidCallback onTap;

  const ProductCardWidget({
    super.key,
    required this.product,
    required this.onWishlistTap,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final prices = product.prices;
    final discount = _calculateDiscountPercentage(
      prices?.regularPrice,
      prices?.salePrice,
    );

    return GestureDetector(
      onTap: onTap,
      child: OsmeaComponents.container(
        decoration: BoxDecoration(
          color: OsmeaColors.white,
          borderRadius: BorderRadius.circular(context.radiusNormal),
          border: Border.all(
            color: OsmeaColors.silver.withOpacity(0.5),
            width: context.borderWidth,
          ),
        ),
        child: OsmeaComponents.column(
          crossAxisAlignment: context.crossStart,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image with overlays - Optimized height
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(context.radiusNormal),
                topRight: Radius.circular(context.radiusNormal),
              ),
              child: SizedBox(
                height: context.dynamicHeight(0.20), // Reduced image height
                width: double.infinity,
                child: Stack(
                  children: [
                    // Product image
                    Positioned.fill(
                      child: product.images?.isNotEmpty == true
                          ? FlutterMaterial.Image.network(
                              product.images!.first.src ?? '',
                              fit: context.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: OsmeaColors.pewter.withOpacity(0.06),
                                  child: Icon(
                                    Icons.image_outlined,
                                    color: OsmeaColors.pewter.withOpacity(0.35),
                                  ),
                                );
                              },
                            )
                          : Container(
                              color: OsmeaColors.pewter.withOpacity(0.06),
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.image_outlined,
                                color: OsmeaColors.pewter.withOpacity(0.35),
                                size: context.iconSizeHigh,
                              ),
                            ),
                    ),

                    // Sale badge
                    if (product.onSale == true && discount != null)
                      Positioned(
                        left: context.spacing8,
                        top: context.spacing8,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.spacing6,
                            vertical: context.spacing2,
                          ),
                          decoration: BoxDecoration(
                            color: OsmeaColors.white.withOpacity(0.9),
                            borderRadius: context.borderRadiusLow,
                            border: Border.all(
                              color: OsmeaColors.nordicBlue,
                              width: context.borderWidth,
                            ),
                          ),
                          child: OsmeaComponents.text(
                            '$discount% OFF',
                            textStyle: OsmeaTextStyle.bodySmall(context)
                                .copyWith(
                                  color: OsmeaColors.nordicBlue,
                                  fontWeight:
                                      FontWeight.w600, // Semi-bold, not bold
                                  fontSize: context.fontSizeExtraSmall,
                                ),
                          ),
                        ),
                      ),

                    // Wishlist heart - compute via parent HomeViewModel (no BlocBuilder)
                    Positioned(
                      right: context.spacing8,
                      top: context.spacing8,
                      child: OsmeaComponents.iconButton(
                        icon: Icon(
                          GetIt.I<HomeViewModel>().isProductSaved(
                                  product.id ?? 0)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          size: context.iconSizeExtraSmall,
                          color: GetIt.I<HomeViewModel>().isProductSaved(
                                  product.id ?? 0)
                              ? OsmeaColors.nordicBlue
                              : OsmeaColors.pewter,
                        ),
                        size: ButtonSize.small,
                        variant: ButtonVariant.ghost,
                        backgroundColor: OsmeaColors.white.withOpacity(0.9),
                        borderRadius: context.width20, // Circular
                        onPressed: onWishlistTap,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Content - Compact layout to prevent overflow
            OsmeaComponents.padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.spacing10,
                vertical: context.spacing10,
              ),
              child: OsmeaComponents.column(
                crossAxisAlignment: context.crossStart,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title - Compact with proper constraints
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: context.height40, // Reduced for 2 lines
                    ),
                    child: OsmeaComponents.text(
                      _formatProductName(product.name ?? 'Product'),
                      textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                        color: OsmeaColors.thunder,
                        fontWeight: FontWeight.w400, // Normal weight
                        height: 1.25, // Tighter line height
                        fontSize: context.fontSizeSmall, // Slightly smaller
                        letterSpacing: -0.15,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  // Meta (category) - Compact, only if space allows
                  if (product.categories?.isNotEmpty ?? false) ...[
                    OsmeaComponents.sizedBox(height: context.spacing4),
                    OsmeaComponents.text(
                      _formatProductName(product.categories!.first.name ?? ''),
                      textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                        color: OsmeaColors.pewter.withOpacity(0.65),
                        fontWeight: FontWeight.w300, // Light weight
                        height: 1.15,
                        fontSize: context.fontSizeExtraSmall,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    OsmeaComponents.sizedBox(height: context.spacing6),
                  ] else
                    OsmeaComponents.sizedBox(height: context.spacing6),

                  // Price - Compact styling
                  if (prices != null &&
                      prices.salePrice != null &&
                      prices.salePrice!.isNotEmpty &&
                      prices.salePrice != prices.regularPrice)
                    OsmeaComponents.row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: OsmeaComponents.text(
                            _formatPrice(prices.salePrice, prices.currencyCode),
                            textStyle: OsmeaTextStyle.bodyMedium(context)
                                .copyWith(
                                  color: OsmeaColors.nordicBlue,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: -0.2,
                                  fontSize: context.fontSizeSmall,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        OsmeaComponents.sizedBox(width: context.spacing4),
                        Flexible(
                          child: OsmeaComponents.text(
                            _formatPrice(
                              prices.regularPrice,
                              prices.currencyCode,
                            ),
                            textStyle: OsmeaTextStyle.bodySmall(context)
                                .copyWith(
                                  color: OsmeaColors.pewter.withOpacity(0.55),
                                  decoration: TextDecoration.lineThrough,
                                  fontWeight: FontWeight.w300,
                                  fontSize: context.fontSizeExtraSmall,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    )
                  else
                    OsmeaComponents.text(
                      _formatPrice(
                        prices?.regularPrice,
                        prices?.currencyCode ?? 'GBP',
                      ),
                      textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                        color: OsmeaColors.thunder,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.2,
                        fontSize: context.fontSizeSmall,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Formats price using PriceInfoCurrencyHelper from core package
  String _formatPrice(String? priceString, String? currencyCode) {
    if (priceString == null || priceString.isEmpty) {
      return PriceInfoCurrencyHelper.getDefaultPrice();
    }

    final cleanPrice = priceString.replaceAll(RegExp(r'[^\d.,]'), '');
    final parsedPrice = double.tryParse(cleanPrice) ?? 0.0;

    return PriceInfoCurrencyHelper.formatPrice(
      parsedPrice,
      currencyCode: currencyCode,
      decimalPlaces: 2,
    );
  }

  /// Calculates discount percentage from regular and sale price
  int? _calculateDiscountPercentage(String? regularPrice, String? salePrice) {
    if (regularPrice == null || salePrice == null) return null;
    final rp = double.tryParse(regularPrice.replaceAll(RegExp(r'[^\d.,]'), ''));
    final sp = double.tryParse(salePrice.replaceAll(RegExp(r'[^\d.,]'), ''));
    if (rp == null || sp == null || rp <= 0 || sp >= rp) return null;
    final pct = ((rp - sp) / rp * 100).round();
    return pct > 0 ? pct : null;
  }

  /// Formats product name to title case (capitalizes first letter of each word)
  String _formatProductName(String name) {
    if (name.isEmpty) return name;

    // Split by spaces and capitalize first letter of each word
    return name
        .split(' ')
        .map(
          (word) => word.isEmpty
              ? word
              : word[0].toUpperCase() +
                    (word.length > 1 ? word.substring(1).toLowerCase() : ''),
        )
        .join(' ');
  }
}
