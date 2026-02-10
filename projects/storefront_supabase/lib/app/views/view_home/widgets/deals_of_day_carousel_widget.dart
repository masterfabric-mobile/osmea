/*
 * DealsOfDayCarouselWidget
 * ------------------------
 * Horizontal product carousel for "Deals of the day" section.
 * Loads from app config.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart' hide BuildContextTranslationsExtension;
import 'package:go_router/go_router.dart';
import 'package:storefront_supabase/src/resources/resources.g.dart';
import 'package:storefront_supabase/app/views/view_home/models/home_view_model.dart';
import 'package:storefront_supabase/app/models/product.dart';
import 'package:storefront_supabase/utils/config_utils.dart';
import 'package:storefront_supabase/app/utils/price_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_supabase/app/core/bloc/currency/currency_cubit.dart';

/// Deals of the day carousel widget (stateless)
/// Uses OsmeaComponents.carousel for state/indicator management
class DealsOfDayCarouselWidget extends StatelessWidget {
  final AssetConfigHelper configHelper;
  final List<Product> allProducts;
  final SupabaseHomeViewModel viewModel;
  final List<Product> saleProducts;

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

  List<String> _getDealsProductIds(Map<String, dynamic> cfg) {
    final rawIds = cfg['product_ids'] as List<dynamic>?;
    if (rawIds == null || rawIds.isEmpty) return const [];
    return rawIds
        .map((e) => e.toString())
        .where((id) => id.isNotEmpty)
        .toList();
  }

  int _getDealsLimit(Map<String, dynamic> cfg) {
    final limit = (cfg['limit'] as num?)?.toInt();
    if (limit == null || limit <= 0) return 3;
    return limit.clamp(1, 20);
  }

  List<Product> _pickDealsProducts(
    Map<String, dynamic> cfg,
  ) {
    final ids = _getDealsProductIds(cfg);
    final limit = _getDealsLimit(cfg);

    // If config provides an explicit product list, use it (preserve order)
    if (ids.isNotEmpty) {
      final byId = <String, Product>{};
      for (final p in allProducts) {
        byId[p.id] = p;
      }

      return ids
          .map((id) => byId[id])
          .whereType<Product>()
          .take(limit)
          .toList();
    }

    // Fallback: current behavior (discounted on-sale products)
    return saleProducts
        .where((p) => p.hasDiscount)
        .take(limit)
        .toList();
  }

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
    return configHelper.getDouble(
      'home_view.component_spacing.horizontal',
      20.0,
    );
  }

  /// Gets title to content spacing from config
  double _getTitleSpacing() {
    return configHelper.getDouble(
      'home_view.component_spacing.title_to_content',
      16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cfg =
        _loadDealsConfig() ??
        {'title': 'Deals of the day', 'show_see_all': false};

    final sectionTitle = configString(cfg['title']) ?? 'Deals of the day';
    final showSeeAll = cfg['show_see_all'] as bool? ?? false;

    final dealsProducts = _pickDealsProducts(cfg);

    final horizontalPadding = _getHorizontalPadding();

    final double itemWidth = (context.allWidth - (horizontalPadding * 2)).clamp(
      0.0,
      context.allWidth,
    );
    final double bannerHeight = context.height160;
    final bannerItems = dealsProducts
        .map(
          (p) => OsmeaComponents.container(
            margin: context.paddingZero,
            width: itemWidth,
            height: bannerHeight,
            child: _buildLowPriceBannerCard(context, p, bannerHeight),
          ),
        )
        .toList();

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
                  context.resources.seeAll,
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
        if (bannerItems.isEmpty)
          SizedBox(height: bannerHeight)
        else
          OsmeaComponents.padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(
                context,
              ).copyWith(scrollbars: false),
              child: OsmeaComponents.carousel(
                variant: CarouselVariant.standard,
                size: CarouselSize.small,
                height: bannerHeight,
                items: bannerItems,
                width: itemWidth,
                customPadding: context.paddingZero,
                backgroundColor: OsmeaColors.transparent,
                showIndicators: true,
                showArrows: false,
                autoPlay: CarouselAutoPlay.continuous,
                autoPlayInterval: const Duration(seconds: 7),
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
          ),
      ],
    );
  }

  Widget _buildLowPriceBannerCard(
    BuildContext context,
    Product product,
    double bannerHeight,
  ) {
    final discount = product.discountPercentage?.round();

    return GestureDetector(
      onTap: () {
        context.push('/product-detail/${product.id}');
      },
      child: Stack(
        children: [
          Container(
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
                    color: OsmeaColors.transparent,
                    borderRadius: BorderRadius.circular(context.spacing16),
                  ),
                  child: OsmeaComponents.image(
                    imageUrl: product.imageUrls.isNotEmpty ? product.imageUrls.first : null,
                    width: context.width160,
                    height: bannerHeight,
                    fit: BoxFit.cover,
                    borderRadius: BorderRadius.circular(context.spacing16),
                    variant: ImageVariant.normal,
                    cacheWidth: 400,
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
                            borderRadius: BorderRadius.circular(
                              context.spacing20,
                            ),
                            border: Border.all(
                              color: OsmeaColors.black,
                              width: context.borderWidth,
                            ),
                          ),
                          child: OsmeaComponents.text(
                            '$discount% OFF',
                            textStyle: OsmeaTextStyle.bodySmall(context)
                                .copyWith(
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
                        product.name,
                        textStyle: OsmeaTextStyle.titleSmall(context).copyWith(
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.2,
                          color: OsmeaColors.thunder,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      BlocBuilder<CurrencyCubit, String>(
                        builder: (context, currency) {
                          return OsmeaComponents.row(
                            children: [
                              OsmeaComponents.text(
                                PriceHelper.format(
                                  product.effectivePrice,
                                  currency,
                                  Localizations.localeOf(context).toString()
                                ),
                                textStyle: OsmeaTextStyle.titleSmall(context)
                                    .copyWith(
                                      color: OsmeaColors.black,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                              if (product.hasDiscount) ...[
                                OsmeaComponents.sizedBox(width: context.spacing6),
                                OsmeaComponents.text(
                                  PriceHelper.format(
                                    product.price,
                                    currency,
                                    Localizations.localeOf(context).toString()
                                  ),
                                  textStyle: OsmeaTextStyle.bodySmall(context)
                                      .copyWith(
                                        color: OsmeaColors.pewter,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                ),
                              ],
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
