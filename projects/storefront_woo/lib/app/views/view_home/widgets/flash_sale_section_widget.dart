/*
 * FlashSaleSectionWidget
 * ----------------------
 * Flash sale section with countdown timer and product carousel.
 * Loads from app config.
 */

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_woo/app/views/view_home/models/home_view_model.dart';
import 'package:storefront_woo/app/views/view_wishlist/models/wishlist_view_model.dart';
import 'package:storefront_woo/app/views/view_wishlist/models/module/states.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_api/freezed_model/response/list_all_products_response_model.dart';
import 'package:osmea_components/src/enums/carousel_enums.dart';

/// Flash sale section widget with countdown timer
class FlashSaleSectionWidget extends StatefulWidget {
  final AssetConfigHelper configHelper;
  final List<ListAllProductsResponseModel> allProducts;
  final HomeViewModel viewModel;

  const FlashSaleSectionWidget({
    super.key,
    required this.configHelper,
    required this.allProducts,
    required this.viewModel,
  });

  @override
  State<FlashSaleSectionWidget> createState() => _FlashSaleSectionWidgetState();
}

class _FlashSaleSectionWidgetState extends State<FlashSaleSectionWidget> {
  Timer? _timer;
  Duration _timeRemaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _initializeTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _initializeTimer() {
    final config = _loadFlashSaleConfig();
    final endTimeStr = config?['end_time'] as String?;
    
    if (endTimeStr != null) {
      try {
        final endTime = DateTime.parse(endTimeStr);
        _updateTimeRemaining(endTime);
        
        _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
          if (mounted) {
            _updateTimeRemaining(endTime);
          } else {
            timer.cancel();
          }
        });
      } catch (e) {
        debugPrint('Failed to parse flash sale end time: $e');
      }
    } else {
      // Default: 24 hours from now
      final endTime = DateTime.now().add(const Duration(hours: 24));
      _updateTimeRemaining(endTime);
      
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (mounted) {
          _updateTimeRemaining(endTime);
        } else {
          timer.cancel();
        }
      });
    }
  }

  void _updateTimeRemaining(DateTime endTime) {
    final now = DateTime.now();
    final remaining = endTime.difference(now);
    
    if (remaining.isNegative) {
      setState(() {
        _timeRemaining = Duration.zero;
      });
      _timer?.cancel();
    } else {
      setState(() {
        _timeRemaining = remaining;
      });
    }
  }

  /// Loads flash sale section configuration
  Map<String, dynamic>? _loadFlashSaleConfig() {
    try {
      return widget.configHelper.getObject('home_view.flash_sale');
    } catch (e) {
      debugPrint('Failed to load flash sale config: $e');
      return null;
    }
  }

  /// Filters products for flash sale
  List<ListAllProductsResponseModel> _getFlashSaleProducts() {
    final config = _loadFlashSaleConfig();
    final productIds = config?['product_ids'] as List<dynamic>?;
    
    if (productIds != null && productIds.isNotEmpty) {
      final ids = productIds.map((e) => e as int).toSet();
      return widget.allProducts
          .where((p) => ids.contains(p.id) && (p.onSale == true))
          .toList();
    }

    // Default: show on-sale products, limit by config
    final limit = config?['limit'] as int? ?? 10;
    return widget.allProducts
        .where((p) => p.onSale == true)
        .take(limit)
        .toList();
  }

  /// Gets horizontal padding from config
  double _getHorizontalPadding() {
    try {
      final config = _loadFlashSaleConfig();
      final paddingConfig = config?['padding'] as Map<String, dynamic>?;
      if (paddingConfig != null) {
        final horizontal = (paddingConfig['horizontal'] as num?)?.toDouble();
        if (horizontal != null && horizontal > 0) {
          return horizontal;
        }
      }
    } catch (e) {
      debugPrint('Failed to load horizontal padding: $e');
    }
    return widget.configHelper.getDouble('home_view.component_spacing.horizontal', 20.0);
  }

  /// Gets title to content spacing from config
  double _getTitleSpacing() {
    return widget.configHelper.getDouble('home_view.component_spacing.title_to_content', 16.0);
  }

  String _formatDuration(Duration duration) {
    final days = duration.inDays;
    final hours = duration.inHours.remainder(24);
    final minutes = duration.inMinutes.remainder(60);
    
    if (days > 0) {
      return '${days}d ${hours.toString().padLeft(2, '0')}h ${minutes.toString().padLeft(2, '0')}m';
    } else if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}h ${minutes.toString().padLeft(2, '0')}m';
    } else {
      return '${minutes.toString().padLeft(2, '0')}m';
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = _loadFlashSaleConfig();
    final sectionTitle = config?['title'] as String? ?? 'Flash Sale';
    final showSection = config?['enabled'] as bool? ?? true;

    if (!showSection) return const SizedBox.shrink();

    final flashSaleProducts = _getFlashSaleProducts();
    if (flashSaleProducts.isEmpty) return const SizedBox.shrink();

    final horizontalPadding = _getHorizontalPadding();

    return OsmeaComponents.column(
      crossAxisAlignment: context.crossStart,
      children: [
        // Section header with countdown timer
        OsmeaComponents.padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: OsmeaComponents.row(
            mainAxisAlignment: context.spaceBetween,
            crossAxisAlignment: context.crossCenter,
            children: [
              OsmeaComponents.row(
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
                  OsmeaComponents.sizedBox(width: context.spacing8),
                  // Countdown timer
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.spacing8,
                      vertical: context.spacing4,
                    ),
                    decoration: BoxDecoration(
                      color: OsmeaColors.nordicBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(context.spacing8),
                    ),
                    child: OsmeaComponents.row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: context.iconSizeSmall,
                          color: OsmeaColors.nordicBlue,
                        ),
                        OsmeaComponents.sizedBox(width: context.spacing4),
                        OsmeaComponents.text(
                          _formatDuration(_timeRemaining),
                          textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                            fontSize: context.fontSizeExtraSmall * context.textScaleFactor,
                            fontWeight: FontWeight.w700,
                            color: OsmeaColors.nordicBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // See all button
              GestureDetector(
                onTap: () {
                  context.push('/products?on_sale=true');
                },
                child: OsmeaComponents.text(
                  'See all',
                  textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                    fontSize: context.fontSizeExtraSmallMedium * context.textScaleFactor,
                    fontWeight: FontWeight.w500,
                    color: OsmeaColors.nordicBlue,
                  ),
                ),
              ),
            ],
          ),
        ),
        OsmeaComponents.sizedBox(height: _getTitleSpacing()),
        // Product carousel
        ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: OsmeaComponents.carousel(
            variant: CarouselVariant.standard,
            size: CarouselSize.small,
            height: context.height160 + context.spacing10 + context.height80,
            items: flashSaleProducts.map((product) {
              return OsmeaComponents.container(
                margin: EdgeInsets.only(
                  left: flashSaleProducts.indexOf(product) == 0 ? horizontalPadding : context.spacing8,
                  right: flashSaleProducts.indexOf(product) == flashSaleProducts.length - 1 ? horizontalPadding : 0,
                ),
                width: (context.allWidth - (horizontalPadding * 2) - context.spacing16) / 2,
                child: _buildFlashSaleCard(context, product),
              );
            }).toList(),
            width: context.allWidth,
            customPadding: context.paddingZero,
            backgroundColor: OsmeaColors.transparent,
            showIndicators: false,
            showArrows: false,
            autoPlay: CarouselAutoPlay.none,
          ),
        ),
      ],
    );
  }

  /// Builds flash sale product card
  Widget _buildFlashSaleCard(
    BuildContext context,
    ListAllProductsResponseModel product,
  ) {
    final prices = product.prices;
    final bool hasSale =
        product.onSale == true &&
        prices?.salePrice != null &&
        (prices?.salePrice?.isNotEmpty ?? false) &&
        prices?.salePrice != prices?.regularPrice;
    
    int? discountPct;
    if (hasSale) {
      final rp = PriceInfoCurrencyHelper.parsePriceToDouble(
        prices!.regularPrice,
        currencyCode: prices.currencyCode,
        currencyDecimalSeparator: prices.currencyDecimalSeparator,
        currencyThousandSeparator: prices.currencyThousandSeparator,
        currencyMinorUnit: prices.currencyMinorUnit,
      );
      final sp = PriceInfoCurrencyHelper.parsePriceToDouble(
        prices.salePrice,
        currencyCode: prices.currencyCode,
        currencyDecimalSeparator: prices.currencyDecimalSeparator,
        currencyThousandSeparator: prices.currencyThousandSeparator,
        currencyMinorUnit: prices.currencyMinorUnit,
      );
      if (rp != null && sp != null && rp > 0 && sp < rp) {
        discountPct = (((rp - sp) / rp) * 100).round();
      }
    }

    return GestureDetector(
      onTap: () {
        widget.viewModel.selectProduct(product);
        context.push('/product-detail/${product.id ?? 0}');
      },
      child: OsmeaComponents.column(
        crossAxisAlignment: context.crossStart,
        children: [
          // Image container
          Container(
            height: context.height160 + context.spacing10,
            decoration: BoxDecoration(
              color: OsmeaColors.pewter,
              borderRadius: context.borderRadiusNormal,
            ),
            child: Stack(
              children: [
                // Product image
                OsmeaComponents.image(
                  imageUrl: product.images?.isNotEmpty == true
                      ? product.images!.first.src
                      : null,
                  width: double.infinity,
                  height: context.height160 + context.spacing10,
                  fit: BoxFit.cover,
                  borderRadius: context.borderRadiusNormal,
                  variant: ImageVariant.normal,
                  cacheWidth: 1024,
                  cacheHeight: 1024,
                  showLoadingIndicator: true,
                  errorWidget: OsmeaComponents.container(
                    width: double.infinity,
                    height: context.height160 + context.spacing10,
                    color: OsmeaColors.grayMaterial[50],
                    alignment: context.center,
                    child: Icon(
                      Icons.image_outlined,
                      color: OsmeaColors.grayMaterial[400],
                      size: context.iconSizeExtraHigh,
                    ),
                  ),
                ),
                // Discount badge
                if (hasSale && discountPct != null)
                  Positioned(
                    top: context.spacing8,
                    left: context.spacing8,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.spacing6,
                        vertical: context.spacing2,
                      ),
                      decoration: BoxDecoration(
                        color: OsmeaColors.nordicBlue,
                        borderRadius: BorderRadius.circular(context.spacing6),
                      ),
                      child: OsmeaComponents.text(
                        '$discountPct% OFF',
                        textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                          color: OsmeaColors.white,
                          fontSize: context.fontSizeExtraSmall * context.textScaleFactor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                // Wishlist button
                Positioned(
                  top: context.spacing8,
                  right: context.spacing8,
                  child: BlocBuilder<WishlistViewModel, WishlistState>(
                    bloc: GetIt.I<WishlistViewModel>(),
                    buildWhen: (previous, current) {
                      final prevItems = previous is WishlistLoadedState
                          ? previous.items.map((e) => e.id).toSet()
                          : <int>{};
                      final currItems = current is WishlistLoadedState
                          ? current.items.map((e) => e.id).toSet()
                          : current is WishlistSuccessState
                              ? current.previousState.items.map((e) => e.id).toSet()
                              : <int>{};
                      return prevItems != currItems;
                    },
                    builder: (context, wishlistState) {
                      final productId = product.id ?? 0;
                      final wishlistVm = GetIt.I<WishlistViewModel>();
                      final loadedState = wishlistState is WishlistSuccessState
                          ? wishlistState.previousState
                          : wishlistState is WishlistLoadedState
                              ? wishlistState
                              : null;
                      final isSaved = loadedState != null
                          ? loadedState.items.any((e) => e.id == productId)
                          : wishlistVm.isSaved(productId);

                      return GestureDetector(
                        onTap: () async {
                          await widget.viewModel.addProductToWishlist(productId);
                        },
                        child: Container(
                          width: context.width32,
                          height: context.height32,
                          decoration: BoxDecoration(
                            color: OsmeaColors.white,
                            borderRadius: BorderRadius.circular(context.spacing24),
                            border: Border.all(
                              color: OsmeaColors.thunder,
                              width: context.borderWidth,
                            ),
                          ),
                          child: Icon(
                            isSaved ? Icons.favorite : Icons.favorite_border,
                            size: context.iconSizeExtraSmall,
                            color: isSaved
                                ? OsmeaColors.nordicBlue
                                : OsmeaColors.thunder,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          OsmeaComponents.sizedBox(height: context.spacing8),
          // Product info
          OsmeaComponents.padding(
            padding: context.onlyLeftPaddingLow,
            child: OsmeaComponents.column(
              crossAxisAlignment: context.crossStart,
              children: [
                // Price
                if (hasSale) ...[
                  OsmeaComponents.row(
                    children: [
                      OsmeaComponents.text(
                        _formatPrice(
                          prices?.salePrice,
                          currencyCode: prices?.currencyCode,
                          currencyDecimalSeparator: prices?.currencyDecimalSeparator,
                          currencyThousandSeparator: prices?.currencyThousandSeparator,
                          currencyMinorUnit: prices?.currencyMinorUnit,
                        ),
                        textStyle: OsmeaTextStyle.titleSmall(context).copyWith(
                          fontSize: context.fontSizeExtraSmallMedium * context.textScaleFactor,
                          fontWeight: FontWeight.w700,
                          color: OsmeaColors.nordicBlue,
                        ),
                      ),
                      OsmeaComponents.sizedBox(width: context.spacing6),
                      OsmeaComponents.text(
                        _formatPrice(
                          prices?.regularPrice,
                          currencyCode: prices?.currencyCode,
                          currencyDecimalSeparator: prices?.currencyDecimalSeparator,
                          currencyThousandSeparator: prices?.currencyThousandSeparator,
                          currencyMinorUnit: prices?.currencyMinorUnit,
                        ),
                        textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                          fontSize: context.fontSizeSmall * context.textScaleFactor,
                          color: OsmeaColors.pewter,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  OsmeaComponents.text(
                    _formatPrice(
                      prices?.regularPrice,
                      currencyCode: prices?.currencyCode,
                      currencyDecimalSeparator: prices?.currencyDecimalSeparator,
                      currencyThousandSeparator: prices?.currencyThousandSeparator,
                      currencyMinorUnit: prices?.currencyMinorUnit,
                    ),
                    textStyle: OsmeaTextStyle.titleSmall(context).copyWith(
                      fontSize: context.fontSizeExtraSmallMedium * context.textScaleFactor,
                      fontWeight: FontWeight.w700,
                      color: OsmeaColors.thunder,
                    ),
                  ),
                ],
                OsmeaComponents.sizedBox(height: context.spacing4),
                // Product name
                OsmeaComponents.text(
                  product.name ?? 'Product',
                  textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                    fontSize: context.fontSizeExtraSmallMedium * context.textScaleFactor,
                    fontWeight: FontWeight.w500,
                    height: 1.14,
                    color: OsmeaColors.thunder,
                  ),
                  maxLines: context.maxLineTwo,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
    final parsedPrice = PriceInfoCurrencyHelper.parsePriceToDouble(
      priceString,
      currencyCode: currencyCode,
      currencyDecimalSeparator: currencyDecimalSeparator,
      currencyThousandSeparator: currencyThousandSeparator,
      currencyMinorUnit: currencyMinorUnit,
    ) ?? 0.0;
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

