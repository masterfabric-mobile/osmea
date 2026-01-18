/*
 * Product Images Widget
 * ---------------------
 * Modern product images carousel with smooth animations and beautiful indicators.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:storefront_woo/app/views/view_product_detail/models/product_detail_view_model.dart';
import 'package:storefront_woo/app/views/view_product_detail/models/module/states.dart';
import 'package:storefront_woo/gen/translations.g.dart';

/// Modern widget for displaying product images with carousel and overlay actions
class ProductImagesWidget extends StatefulWidget {
  final List<String> imageUrls;
  final ProductDetailViewModel viewModel;
  final Function(String path) goRoute;
  final bool withOverlays;
  final bool isInWishlist;
  final int productId;
  final String? productName;

  const ProductImagesWidget({
    super.key,
    required this.imageUrls,
    required this.viewModel,
    required this.goRoute,
    this.withOverlays = false,
    this.isInWishlist = false,
    this.productId = 0,
    this.productName,
  });

  @override
  State<ProductImagesWidget> createState() => _ProductImagesWidgetState();
}

class _ProductImagesWidgetState extends State<ProductImagesWidget> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    if (widget.imageUrls.isEmpty) {
      return OsmeaComponents.container(
        height: context.dynamicHeight(0.50),
        width: context.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              OsmeaColors.grayMaterial[50]!,
              OsmeaColors.grayMaterial[100]!,
            ],
          ),
        ),
        child: OsmeaComponents.center(
          child: OsmeaComponents.column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.image_outlined,
                size: context.iconSizeExtraHigh * 2,
                color: OsmeaColors.grayMaterial[300]!,
              ),
              OsmeaComponents.sizedBox(height: context.spacing8),
              OsmeaComponents.text(
                'No Image Available',
                textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                  color: OsmeaColors.grayMaterial[400]!,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Elegant image area - refined proportions
    final height = context.dynamicHeight(0.40);

    return OsmeaComponents.sizedBox(
      height: height,
      child: Stack(
        children: [
          // Main image carousel - Pull & Bear style
          PageView.builder(
            controller: _pageController,
            itemCount: widget.imageUrls.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final heroTag = index == 0
                  ? 'product-image-${widget.productId}'
                  : 'product_image_${widget.productId}_$index';
              
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ImageDetailScreen(
                        goRoute: widget.goRoute,
                        imageUrls: widget.imageUrls,
                        initialIndex: index,
                      ),
                    ),
                  );
                },
                child: Hero(
                  tag: heroTag,
                  child: OsmeaComponents.container(
                    width: context.infinity,
                    height: height,
                    color: OsmeaColors.white,
                    child: OsmeaComponents.image(
                      imageUrl: widget.imageUrls[index],
                      width: context.infinity,
                      height: height,
                      fit: BoxFit.contain,
                      alignment: context.center,
                      placeholder: OsmeaComponents.container(
                        color: OsmeaColors.grayMaterial[50],
                        child: OsmeaComponents.center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: OsmeaColors.black,
                          ),
                        ),
                      ),
                      errorWidget: OsmeaComponents.container(
                        color: OsmeaColors.grayMaterial[50],
                        child: OsmeaComponents.center(
                          child: Icon(
                            Icons.broken_image_outlined,
                            size: context.iconSizeExtraHigh * 1.5,
                            color: OsmeaColors.grayMaterial[300]!,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // Image indicators - elegant and refined
          if (widget.imageUrls.length > 1)
            Positioned(
              bottom: context.spacing16,
              left: 0,
              right: 0,
              child: OsmeaComponents.center(
                child: OsmeaComponents.container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.spacing8,
                    vertical: context.spacing6,
                  ),
                  decoration: BoxDecoration(
                    color: OsmeaColors.black.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: OsmeaComponents.row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      widget.imageUrls.length,
                      (index) => GestureDetector(
                        onTap: () {
                          _pageController.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: OsmeaComponents.container(
                          margin: EdgeInsets.symmetric(horizontal: 3),
                          width: _currentPage == index ? 20 : 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? _getIndicatorColor(context)
                                : _getIndicatorColor(context).withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // Overlay actions - elegant and refined
          if (widget.withOverlays)
            Positioned(
              right: context.spacing12,
              top: context.spacing12,
              child: OsmeaComponents.column(
                children: [
                  // Wishlist button - elegant
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => widget.viewModel.addProductToWishlistFire(widget.productId),
                      borderRadius: BorderRadius.circular(20),
                      child: OsmeaComponents.container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: OsmeaColors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                        ),
                        child: OsmeaComponents.center(
                          child: Icon(
                            widget.isInWishlist
                                ? Icons.favorite
                                : Icons.favorite_outline,
                            color: OsmeaColors.black,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                  OsmeaComponents.sizedBox(height: context.spacing6),
                  // Share button - elegant
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _shareProduct(context),
                      borderRadius: BorderRadius.circular(20),
                      child: OsmeaComponents.container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: OsmeaColors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                        ),
                        child: OsmeaComponents.center(
                          child: Icon(
                            Icons.share_outlined,
                            color: OsmeaColors.black,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Badges on product detail (same style as cards)
          if (widget.withOverlays)
            Positioned(
              left: context.spacing12,
              top: context.spacing12,
              child: Builder(
                builder: (context) {
                  final configHelper = AssetConfigHelper();
                  final state = widget.viewModel.state;
                  if (state is! ProductDetailLoadedState) {
                    return const SizedBox.shrink();
                  }

                  final product = state.product;
                  final productId = product.id ?? widget.productId;
                  final onSale = product.onSale == true;

                  // Week Star (ONLY config products)
                  final weekStarConfig =
                      configHelper.getObject('product_card.badges.week_star') ??
                          const {};
                  final weekStarIds =
                      (weekStarConfig['product_ids'] as List<dynamic>?) ??
                          const [];
                  final weekStarIdSet = weekStarIds
                      .map((e) => int.tryParse(e.toString()) ?? -1)
                      .where((id) => id > 0)
                      .toSet();
                  final showWeekStar = weekStarIdSet.isNotEmpty &&
                      weekStarIdSet.contains(productId);

                  // Flash badge (only if discount >= config threshold)
                  final flashEnabled = configHelper.getBool(
                    'product_card.badges.flash_sale.enabled',
                    true,
                  );
                  final flashMinDiscount = configHelper.getInt(
                    'product_card.badges.flash_sale.min_discount_percent',
                    0,
                  );
                  int? discountPct;
                  try {
                    final prices = product.prices;
                    final rp = PriceInfoCurrencyHelper.parsePriceToDouble(
                      prices?.regularPrice,
                      currencyCode: prices?.currencyCode,
                      currencyDecimalSeparator: prices?.currencyDecimalSeparator,
                      currencyThousandSeparator: prices?.currencyThousandSeparator,
                      currencyMinorUnit: prices?.currencyMinorUnit,
                    );
                    final sp = PriceInfoCurrencyHelper.parsePriceToDouble(
                      prices?.salePrice,
                      currencyCode: prices?.currencyCode,
                      currencyDecimalSeparator: prices?.currencyDecimalSeparator,
                      currencyThousandSeparator: prices?.currencyThousandSeparator,
                      currencyMinorUnit: prices?.currencyMinorUnit,
                    );
                    if (rp != null && sp != null && rp > 0 && sp < rp) {
                      discountPct = (((rp - sp) / rp) * 100).round();
                    }
                  } catch (_) {
                    // ignore
                  }

                  // If both apply, only show Week Star.
                  final showFlash = flashEnabled &&
                      onSale &&
                      !showWeekStar &&
                      discountPct != null &&
                      discountPct >= flashMinDiscount;

                  if (!showWeekStar && !showFlash) {
                    return const SizedBox.shrink();
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (showWeekStar)
                        Container(
                          width: context.width48,
                          height: context.height48,
                          decoration: BoxDecoration(
                            color: OsmeaColors.black,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: OsmeaColors.white,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    OsmeaColors.black.withValues(alpha: 0.2),
                                blurRadius: context.blurRadius8,
                                offset: context.offsetVerticalCustom(
                                  context.spacing2,
                                ),
                              ),
                            ],
                          ),
                          child: OsmeaComponents.column(
                            mainAxisAlignment: context.centerMain,
                            children: [
                              Icon(
                                Icons.star_rounded,
                                size: context.iconSizeSmall,
                                color: OsmeaColors.white,
                              ),
                              OsmeaComponents.text(
                                'WEEK',
                                textStyle:
                                    OsmeaTextStyle.bodySmall(context).copyWith(
                                  color: OsmeaColors.white,
                                  fontSize: context.fontSizeExtraSmall * 0.8,
                                  fontWeight: FontWeight.w800,
                                  height: 1.0,
                                  letterSpacing: 0.6,
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (showWeekStar) OsmeaComponents.sizedBox(height: context.spacing6),
                      if (showFlash)
                        Container(
                          width: context.width48,
                          height: context.height48,
                          decoration: BoxDecoration(
                            color: OsmeaColors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: OsmeaColors.black,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    OsmeaColors.black.withValues(alpha: 0.12),
                                blurRadius: context.blurRadius8,
                                offset: context.offsetVerticalCustom(
                                  context.spacing2,
                                ),
                              ),
                            ],
                          ),
                          child: OsmeaComponents.column(
                            mainAxisAlignment: context.centerMain,
                            children: [
                              Icon(
                                Icons.flash_on_rounded,
                                size: context.iconSizeSmall,
                                color: OsmeaColors.black,
                              ),
                              OsmeaComponents.text(
                                'FLASH',
                                textStyle:
                                    OsmeaTextStyle.bodySmall(context).copyWith(
                                  color: OsmeaColors.black,
                                  fontSize: context.fontSizeExtraSmall * 0.72,
                                  fontWeight: FontWeight.w900,
                                  height: 1.0,
                                  letterSpacing: 0.7,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  /// Gets indicator color from config
  Color _getIndicatorColor(BuildContext context) {
    final configHelper = AssetConfigHelper();
    final colorString = configHelper.getString(
      'product_detail_view.images.indicatorColor',
      '#FFFFFF',
    );
    
    try {
      if (colorString.startsWith('#')) {
        final hexString = colorString.substring(1);
        if (hexString.length == 6) {
          return Color(int.parse('FF$hexString', radix: 16));
        } else if (hexString.length == 8) {
          return Color(int.parse(hexString, radix: 16));
        }
      }
    } catch (e) {
      debugPrint('⚠️ Failed to parse indicator color: $e');
    }
    
    return OsmeaColors.white;
  }

  /// Shares product information
  Future<void> _shareProduct(BuildContext context) async {
    try {
      final name = widget.productName ?? 'Product';
      final shareText = '$name\n\n/product-detail/${widget.productId}';
      
      final success = await ApplicationShareHelper.shareText(
        shareText,
        subject: name,
      );
      
      if (success) {
        debugPrint('✅ Product shared successfully: $name');
      } else {
        debugPrint('⚠️ Failed to share product');
        if (context.mounted) {
          context.snackbarError(context.t.productDetailView.share.failed);
        }
      }
    } catch (e) {
      debugPrint('❌ Error sharing product: $e');
      if (context.mounted) {
        context.snackbarError(context.t.productDetailView.share.error);
      }
    }
  }
}

