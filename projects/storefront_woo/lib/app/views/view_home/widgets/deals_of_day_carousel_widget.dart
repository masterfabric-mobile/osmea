/*
 * DealsOfDayCarouselWidget
 * ------------------------
 * Horizontal product carousel for "Deals of the day" section.
 * Loads from app config.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:go_router/go_router.dart';
import 'package:storefront_woo/app/views/view_home/models/home_view_model.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_api/freezed_model/response/list_all_products_response_model.dart';
import 'package:osmea_components/src/enums/carousel_enums.dart';

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

  /// Gets horizontal padding from config
  double _getHorizontalPadding() {
    try {
      final config = _loadDealsConfig();
      final paddingConfig = config?['padding'] as Map<String, dynamic>?;
      if (paddingConfig != null) {
        final horizontal = (paddingConfig['horizontal'] as num?)?.toDouble();
        if (horizontal != null && horizontal > 0) {
          return horizontal;
        }
      }
    } catch (e) {
      debugPrint('⚠️ Failed to load horizontal padding: $e');
    }
    // Default from component_spacing
    return configHelper.getDouble('home_view.component_spacing.horizontal', 20.0);
  }

  /// Gets title to content spacing from config
  double _getTitleSpacing() {
    return configHelper.getDouble('home_view.component_spacing.title_to_content', 16.0);
  }

  @override
  Widget build(BuildContext context) {
    final cfg =
        _loadDealsConfig() ??
        {'title': 'Deals of the day', 'show_see_all': false};

    final sectionTitle = cfg['title'] as String? ?? 'Deals of the day';
    final showSeeAll = cfg['show_see_all'] as bool? ?? false;

    // Show an empty carousel when there are no products (as requested)

    // Use all discounted products for the Low Price banner carousel
    // Optimized filtering - limit to first 3 to prevent blocking
    final discountedTop3 = saleProducts
        .where(
          (p) =>
              p.prices?.salePrice != null && 
              (p.prices?.salePrice?.isNotEmpty ?? false) &&
              p.prices?.salePrice != p.prices?.regularPrice,
        )
        .take(3) // Limit to 3 items to prevent blocking
        .toList();

    // Intentionally allow empty bannerItems to render an empty carousel

    // Slides should occupy full width of the carousel with no side gutter
    final double itemWidth = context.allWidth;
    // Banner feel
    final double bannerHeight = context.height160;
    final bannerItems = discountedTop3
        .map(
          (p) => OsmeaComponents.container(
            margin: context.paddingZero,
            width: itemWidth,
            height: bannerHeight,
            child: _buildLowPriceBannerCard(context, p, bannerHeight),
          ),
        )
        .toList();

    final horizontalPadding = _getHorizontalPadding();

    return OsmeaComponents.column(
      crossAxisAlignment: context.crossStart,
      children: [
        OsmeaComponents.padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: OsmeaComponents.row(
            mainAxisAlignment: context.spaceBetween,
            children: [
              OsmeaComponents.text(
                sectionTitle,
                textStyle: OsmeaTextStyle.titleLarge(context).copyWith(
                  fontSize: context.fontSizeNormal * context.textScaleFactor,
                  fontWeight: FontWeight.w600,
                  height: context.lineHeightTight,
                  letterSpacing: -0.2,
                  color: OsmeaColors.thunder,
                ),
              ),
              if (showSeeAll)
                OsmeaComponents.text(
                  'See all',
                  textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                    fontSize: context.fontSizeSmall * context.textScaleFactor,
                    fontWeight: FontWeight.w500,
                    height: 1.17,
                    color: OsmeaColors.pewter,
                  ),
                ),
            ],
          ),
        ),
        OsmeaComponents.sizedBox(height: _getTitleSpacing()),
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
              customPadding: context.paddingZero,
              backgroundColor: OsmeaColors.transparent,
              showIndicators: true,
              showArrows: false,
              autoPlay: CarouselAutoPlay.continuous,
              autoPlayInterval: 7.seconds,
              animationDuration: context.durationSlow,
              indicatorType: CarouselIndicatorType.custom,
              indicatorPosition: CarouselIndicatorPosition.bottomRight,
              customIndicator: (context, itemCount, activeIndex) {
                return OsmeaComponents.padding(
                  padding: EdgeInsets.only(
                    right: context.spacing8,
                    bottom: context.spacing8,
                  ),
                  child: OsmeaComponents.container(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.spacing6,
                      vertical: context.spacing2,
                    ),
                    decoration: BoxDecoration(
                      color: OsmeaColors.black.withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(context.spacing12),
                    ),
                    child: OsmeaComponents.text(
                      '${activeIndex + 1}/$itemCount',
                      textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                        color: OsmeaColors.white,
                        fontSize: context.fontSizeExtraSmall * 0.95,
                        fontWeight: FontWeight.w600,
                        height: 1.15,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ),
                );
              },
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
    final discount = _discountPercent(
      prices?.regularPrice,
      prices?.salePrice,
      currencyCode: prices?.currencyCode,
      currencyDecimalSeparator: prices?.currencyDecimalSeparator,
      currencyThousandSeparator: prices?.currencyThousandSeparator,
      currencyMinorUnit: prices?.currencyMinorUnit,
    );

    return GestureDetector(
      onTap: () {
        viewModel.selectProduct(product);
        context.push('/product-detail/${product.id ?? 0}');
      },
      child: Container(
        decoration: BoxDecoration(
          color: OsmeaColors.white,
          borderRadius: BorderRadius.circular(context.spacing16),
          border: Border.all(
            color: OsmeaColors.silver,
            width: context.borderWidth,
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: context.spacing16,
          vertical: context.spacing12,
        ),
        child: OsmeaComponents.row(
          children: [
            // Image
            Container(
              width: context.width160,
              height: bannerHeight,
              decoration: BoxDecoration(
                color: OsmeaColors
                    .transparent, // No background/border for image box
                borderRadius: BorderRadius.circular(context.spacing16),
              ),
              child: OsmeaComponents.image(
                imageUrl: product.images?.isNotEmpty == true
                    ? product.images!.first.src
                    : null,
                width: context.width160,
                height: bannerHeight,
                fit: BoxFit.cover,
                borderRadius: BorderRadius.circular(context.spacing16),
                variant: ImageVariant.normal,
                cacheWidth: 400, // Limit image size for performance
                showLoadingIndicator: true,
                errorWidget: OsmeaComponents.container(
                  width: context.width160,
                  height: bannerHeight,
                  color: OsmeaColors.grayMaterial[50],
                  alignment: context.center,
                  child: Icon(
                    Icons.image_outlined,
                    color: OsmeaColors.grayMaterial[400],
                    size: context.iconSizeExtraHigh,
                  ),
                ),
              ),
            ),
            OsmeaComponents.sizedBox(width: context.spacing12),
            // Texts
            OsmeaComponents.expanded(
              child: OsmeaComponents.column(
                mainAxisAlignment: context.centerMain,
                crossAxisAlignment: context.crossStart,
                children: [
                  if (discount != null)
                    OsmeaComponents.container(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.spacing8,
                        vertical: context.spacing2,
                      ),
                      decoration: BoxDecoration(
                        color: OsmeaColors.black,
                        borderRadius: BorderRadius.circular(context.spacing20),
                        border: Border.all(
                          color: OsmeaColors.black,
                          width: context.borderWidth,
                        ),
                      ),
                      child: OsmeaComponents.text(
                        '$discount% OFF',
                        textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                          fontSize:
                              context.fontSizeExtraSmall *
                              context.textScaleFactor,
                          color: OsmeaColors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  OsmeaComponents.sizedBox(height: context.spacing8),
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
                            currencyDecimalSeparator:
                                prices.currencyDecimalSeparator,
                            currencyThousandSeparator:
                                prices.currencyThousandSeparator,
                            currencyMinorUnit: prices.currencyMinorUnit,
                          ),
                          textStyle: OsmeaTextStyle.titleSmall(context)
                              .copyWith(
                                color: OsmeaColors.black,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        if (prices.salePrice != null &&
                            prices.salePrice!.isNotEmpty &&
                            prices.regularPrice != null &&
                            prices.regularPrice!.isNotEmpty) ...[
                          OsmeaComponents.sizedBox(width: context.spacing6),
                          OsmeaComponents.text(
                            _formatPrice(
                              prices.regularPrice,
                              currencyCode: prices.currencyCode,
                              currencyDecimalSeparator:
                                  prices.currencyDecimalSeparator,
                              currencyThousandSeparator:
                                  prices.currencyThousandSeparator,
                              currencyMinorUnit: prices.currencyMinorUnit,
                            ),
                            textStyle: OsmeaTextStyle.bodySmall(context)
                                .copyWith(
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
      ),
    );
  }

  int? _discountPercent(
    String? regularPrice,
    String? salePrice, {
    String? currencyCode,
    String? currencyDecimalSeparator,
    String? currencyThousandSeparator,
    int? currencyMinorUnit,
  }) {
    if (regularPrice == null || salePrice == null) return null;
    // Use PriceInfoCurrencyHelper.parsePriceToDouble to properly handle formatted strings
    // Use API-provided separators and minor_unit to correctly parse the price format
    final rp = PriceInfoCurrencyHelper.parsePriceToDouble(
      regularPrice,
      currencyCode: currencyCode,
      currencyDecimalSeparator: currencyDecimalSeparator,
      currencyThousandSeparator: currencyThousandSeparator,
      currencyMinorUnit: currencyMinorUnit,
    );
    final sp = PriceInfoCurrencyHelper.parsePriceToDouble(
      salePrice,
      currencyCode: currencyCode,
      currencyDecimalSeparator: currencyDecimalSeparator,
      currencyThousandSeparator: currencyThousandSeparator,
      currencyMinorUnit: currencyMinorUnit,
    );
    if (rp == null || sp == null || rp <= 0 || sp >= rp) return null;
    return (((rp - sp) / rp) * 100).round();
  }

  String _formatPrice(
    String? priceString, {
    String? currencyCode,
    String? currencyDecimalSeparator,
    String? currencyThousandSeparator,
    int? currencyMinorUnit,
  }) {
    if (priceString == null || priceString.isEmpty) {
      return PriceInfoCurrencyHelper.getDefaultPrice();
    }
    // Use PriceInfoCurrencyHelper.parsePriceToDouble to properly handle formatted strings
    // Use API-provided separators and minor_unit to correctly parse the price format
    final parsedPrice =
        PriceInfoCurrencyHelper.parsePriceToDouble(
          priceString,
          currencyCode: currencyCode,
          currencyDecimalSeparator: currencyDecimalSeparator,
          currencyThousandSeparator: currencyThousandSeparator,
          currencyMinorUnit: currencyMinorUnit,
        ) ??
        0.0;
    // Use API-provided separators to correctly format the price
    return PriceInfoCurrencyHelper.formatPrice(
      parsedPrice,
      currencyCode: currencyCode,
      currencyDecimalSeparator: currencyDecimalSeparator,
      currencyThousandSeparator: currencyThousandSeparator,
      decimalPlaces: currencyMinorUnit ?? 2,
      removeTrailingZeros: true,
    );
  }
}
