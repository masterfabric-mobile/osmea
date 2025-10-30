/*
 * DealsOfDayCarouselWidget
 * ------------------------
 * Horizontal product carousel for "Deals of the day" section.
 * Loads from app config.
 */

import 'package:flutter/material.dart' hide Image;
import 'package:flutter/material.dart' as FlutterMaterial show Image;
import 'package:osmea_components/osmea_components.dart';
import 'package:core/core.dart';
import 'package:storefront_woo/app/views/view_home/models/home_view_model.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_api/freezed_model/response/list_all_products_response_model.dart';

/// Deals of the day carousel widget (stateless)
/// Uses OsmeaComponents.carousel for state/indicator management
class DealsOfDayCarouselWidget extends StatelessWidget {
  final AssetConfigHelper configHelper;
  final List<ListAllProductsResponseModel> allProducts;
  final HomeViewModel viewModel;
  final List<ListAllProductsResponseModel> saleProducts;

  const DealsOfDayCarouselWidget({
    super.key,
    required this.configHelper,
    required this.allProducts,
    required this.viewModel,
    required this.saleProducts,
  });

  /// Loads deals of the day configuration
  Map<String, dynamic>? _loadDealsConfig() {
    try {
      return configHelper.getObject('home_view.deals_of_day');
    } catch (e) {
      debugPrint('⚠️ Failed to load deals of day config: $e');
      return null;
    }
  }

  // No internal filtering; ViewModel provides sale products. Config is used only for title/cta.

  @override
  Widget build(BuildContext context) {
    final cfg =
        _loadDealsConfig() ??
        {'title': 'Deals of the day', 'show_see_all': false};

    final sectionTitle = cfg['title'] as String? ?? 'Deals of the day';
    final showSeeAll = cfg['show_see_all'] as bool? ?? false;

    // Show an empty carousel when there are no products (as requested)

    // Use all discounted products for the Low Price banner carousel
    final discountedTop3 = saleProducts
        .where(
          (p) =>
              p.prices?.salePrice != null &&
              (p.prices?.salePrice?.isNotEmpty ?? false) &&
              p.prices?.salePrice != p.prices?.regularPrice,
        )
        .toList();

    // Intentionally allow empty bannerItems to render an empty carousel

    // Slides should occupy full width of the carousel with no side gutter
    final double itemWidth = context.allWidth;
    // Banner feel
    final double bannerHeight = 160;
    final bannerItems = discountedTop3
        .map(
          (p) => OsmeaComponents.container(
            margin: EdgeInsets.zero,
            width: itemWidth,
            height: bannerHeight,
            child: _buildLowPriceBannerCard(context, p, bannerHeight),
          ),
        )
        .toList();

    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: OsmeaComponents.row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OsmeaComponents.text(
                sectionTitle,
                textStyle: OsmeaTextStyle.titleLarge(context).copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  height: 1.0,
                  letterSpacing: -0.2,
                  color: OsmeaColors.thunder,
                ),
              ),
              if (showSeeAll)
                OsmeaComponents.text(
                  'See all',
                  textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    height: 1.17,
                    color: OsmeaColors.pewter,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Render completely empty space when no slides — avoids any internal carousel padding/gutters
        if (bannerItems.isEmpty)
          SizedBox(height: bannerHeight)
        else
          ScrollConfiguration(
            behavior: ScrollConfiguration.of(
              context,
            ).copyWith(scrollbars: false),
            child: OsmeaComponents.carousel(
              variant: CarouselVariant.standard,
              size: CarouselSize.small,
              height: bannerHeight,
              items: bannerItems,
              width: context.allWidth,
              customPadding: EdgeInsets.zero,
              backgroundColor: OsmeaColors.transparent,
              showIndicators: true,
              showArrows: false,
              autoPlay: CarouselAutoPlay.continuous,
              autoPlayInterval: const Duration(seconds: 7),
              animationDuration: Duration(milliseconds: 600),
              indicatorType: CarouselIndicatorType.dot,
              indicatorPosition: CarouselIndicatorPosition.bottomCenter,
            ),
          ),
      ],
    );
  }

  // no async fetching here; ViewModel supplies sale products

  // (Legacy deal card removed – using Low Price banner only)

  /// Builds a banner-style card emphasizing the discount (Low Price)
  Widget _buildLowPriceBannerCard(
    BuildContext context,
    ListAllProductsResponseModel product,
    double bannerHeight,
  ) {
    final prices = product.prices;
    final discount = _discountPercent(prices?.regularPrice, prices?.salePrice);

    return Container(
      decoration: BoxDecoration(
        color: OsmeaColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: OsmeaColors.silver.withOpacity(0.5),
          width: 0.5,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: OsmeaComponents.row(
        children: [
          // Image
          Container(
            width: 160,
            height: bannerHeight,
            decoration: BoxDecoration(
              color:
                  OsmeaColors.transparent, // No background/border for image box
              borderRadius: BorderRadius.circular(16),
            ),
            child: OsmeaComponents.clipRRect(
              borderRadius: BorderRadius.circular(16),
              child: product.images?.isNotEmpty == true
                  ? FlutterMaterial.Image.network(
                      product.images!.first.src ?? '',
                      fit: BoxFit.cover,
                    )
                  : Container(color: OsmeaColors.pewter.withOpacity(0.08)),
            ),
          ),
          const SizedBox(width: 12),
          // Texts
          OsmeaComponents.expanded(
            child: OsmeaComponents.column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (discount != null)
                  OsmeaComponents.container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: OsmeaColors.nordicBlue.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: OsmeaColors.nordicBlue,
                        width: 0.5,
                      ),
                    ),
                    child: OsmeaComponents.text(
                      '$discount% OFF',
                      textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                        fontSize: 11,
                        color: OsmeaColors.nordicBlue,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                OsmeaComponents.text(
                  product.name ?? 'Product',
                  textStyle: OsmeaTextStyle.titleSmall(context).copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.2,
                    color: OsmeaColors.thunder,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                if (prices != null)
                  OsmeaComponents.row(
                    children: [
                      OsmeaComponents.text(
                        _formatPrice(
                          prices.salePrice ?? prices.regularPrice,
                          currencyCode: prices.currencyCode,
                        ),
                        textStyle: OsmeaTextStyle.titleSmall(context).copyWith(
                          color: OsmeaColors.nordicBlue,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (prices.salePrice != null &&
                          prices.salePrice!.isNotEmpty &&
                          prices.regularPrice != null &&
                          prices.regularPrice!.isNotEmpty) ...[
                        const SizedBox(width: 6),
                        OsmeaComponents.text(
                          _formatPrice(
                            prices.regularPrice,
                            currencyCode: prices.currencyCode,
                          ),
                          textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                            color: OsmeaColors.pewter,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int? _discountPercent(String? regularPrice, String? salePrice) {
    if (regularPrice == null || salePrice == null) return null;
    final rp = double.tryParse(regularPrice.replaceAll(RegExp(r'[^\d.,]'), ''));
    final sp = double.tryParse(salePrice.replaceAll(RegExp(r'[^\d.,]'), ''));
    if (rp == null || sp == null || rp <= 0 || sp >= rp) return null;
    return (((rp - sp) / rp) * 100).round();
  }

  String _formatPrice(String? priceString, {String? currencyCode}) {
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
}
