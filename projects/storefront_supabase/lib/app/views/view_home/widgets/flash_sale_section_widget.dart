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
import 'package:storefront_supabase/app/views/view_home/models/home_view_model.dart';
import 'package:storefront_supabase/app/views/view_favorites/models/view_model.dart';
import 'package:storefront_supabase/app/views/view_favorites/models/states.dart';
import 'package:storefront_supabase/app/models/product.dart';
import 'package:storefront_supabase/utils/config_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_supabase/app/core/bloc/currency/currency_cubit.dart';
import 'package:storefront_supabase/app/utils/price_helper.dart';

/// Flash sale section widget with countdown timer
class FlashSaleSectionWidget extends StatefulWidget {
  final AssetConfigHelper configHelper;
  final List<Product> allProducts;
  final SupabaseHomeViewModel viewModel;

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
  // Track wishlist state for each product for immediate UI feedback
  final Map<String, bool> _productWishlistStates = {};

  @override
  void initState() {
    super.initState();
    _initializeTimer();
    _initializeWishlistStates();
  }

  void _initializeWishlistStates() {
    final flashSaleProducts = _getFlashSaleProducts();
    final wishlistVm = GetIt.I<FavoritesViewModel>();
    // Check if FavoritesViewModel is loaded
    if (wishlistVm.state is FavoritesLoadedState) {
      final favorites = (wishlistVm.state as FavoritesLoadedState).favoriteProducts;
      for (final product in flashSaleProducts) {
        final productId = product.id;
        _productWishlistStates[productId] = favorites.any((p) => p.id == productId);
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _initializeTimer() {
    final config = _loadFlashSaleConfig();
    final endTimeStr = configString(config?['end_time']);

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
  List<Product> _getFlashSaleProducts() {
    final config = _loadFlashSaleConfig();
    final productIds = config?['product_ids'] as List<dynamic>?;

    if (productIds != null && productIds.isNotEmpty) {
      final ids = productIds.map((e) => e.toString()).toSet();
      return widget.allProducts
          .where((p) => ids.contains(p.id) && p.hasDiscount)
          .toList();
    }

    // Default: show on-sale products, limit by config
    final limit = config?['limit'] as int? ?? 10;
    return widget.allProducts
        .where((p) => p.hasDiscount)
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
    return widget.configHelper.getDouble(
      'home_view.component_spacing.horizontal',
      20.0,
    );
  }

  /// Gets title to content spacing from config
  double _getTitleSpacing() {
    return widget.configHelper.getDouble(
      'home_view.component_spacing.title_to_content',
      16.0,
    );
  }

  /// Gets background color from config
  Color _getBackgroundColor() {
    try {
      final config = _loadFlashSaleConfig();
      final colorString = configString(config?['backgroundColor']);
      if (colorString != null && colorString.isNotEmpty) {
        // Handle hex color strings
        if (colorString.startsWith('#')) {
          final hexString = colorString.substring(1);
          if (hexString.length == 6) {
            return Color(int.parse('FF$hexString', radix: 16));
          } else if (hexString.length == 8) {
            return Color(int.parse(hexString, radix: 16));
          }
        }
      }
    } catch (e) {
      debugPrint('⚠️ Failed to load flash sale background color: $e');
    }
    return OsmeaColors.white;
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
    final sectionTitle = configString(config?['title']) ?? 'Flash Sale';
    final showSection = config?['enabled'] as bool? ?? true;

    if (!showSection) return const SizedBox.shrink();

    final flashSaleProducts = _getFlashSaleProducts();
    if (flashSaleProducts.isEmpty) return const SizedBox.shrink();

    // Update wishlist states from FavoritesViewModel
    final wishlistVm = GetIt.I<FavoritesViewModel>();
    if (wishlistVm.state is FavoritesLoadedState) {
        final favs = (wishlistVm.state as FavoritesLoadedState).favoriteProducts;
        for (final product in flashSaleProducts) {
          final productId = product.id;
          if (!_productWishlistStates.containsKey(productId)) {
            _productWishlistStates[productId] = favs.any((p) => p.id == productId);
          }
        }
    }

    final horizontalPadding = _getHorizontalPadding();
    final backgroundColor = _getBackgroundColor();

    return OsmeaComponents.container(
      margin: EdgeInsets.symmetric(vertical: context.spacing8),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border(
          left: BorderSide(color: OsmeaColors.silver, width: 1),
          right: BorderSide(color: OsmeaColors.silver, width: 1),
          bottom: BorderSide(color: OsmeaColors.silver, width: 1),
        ),
        borderRadius: BorderRadius.circular(context.spacing12),
      ),
      child: OsmeaComponents.column(
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
                        fontSize:
                            context.fontSizeNormal * context.textScaleFactor,
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
                        color: OsmeaColors.black.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(context.spacing8),
                      ),
                      child: OsmeaComponents.row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: context.iconSizeSmall,
                            color: OsmeaColors.black,
                          ),
                          OsmeaComponents.sizedBox(width: context.spacing4),
                          OsmeaComponents.text(
                            _formatDuration(_timeRemaining),
                            textStyle: OsmeaTextStyle.bodySmall(context)
                                .copyWith(
                                  fontSize:
                                      context.fontSizeExtraSmall *
                                      context.textScaleFactor,
                                  fontWeight: FontWeight.w700,
                                  color: OsmeaColors.black,
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
                    // Navigate to on sale
                    context.push('/categories/products/all?on_sale=true');
                  },
                  child: OsmeaComponents.text(
                    'See all',
                    textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                      fontSize:
                          context.fontSizeExtraSmallMedium *
                          context.textScaleFactor,
                      fontWeight: FontWeight.w500,
                      color: OsmeaColors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          OsmeaComponents.sizedBox(height: _getTitleSpacing()),
          // Product carousel
          ScrollConfiguration(
            behavior: ScrollConfiguration.of(
              context,
            ).copyWith(scrollbars: false),
            child: OsmeaComponents.carousel(
              variant: CarouselVariant.standard,
              size: CarouselSize.small,
              height: context.height160 + context.spacing10 + context.height80,
              items: flashSaleProducts.map((product) {
                return OsmeaComponents.container(
                  margin: EdgeInsets.only(
                    left: flashSaleProducts.indexOf(product) == 0
                        ? horizontalPadding
                        : context.spacing8,
                    right:
                        flashSaleProducts.indexOf(product) ==
                            flashSaleProducts.length - 1
                        ? horizontalPadding
                        : 0,
                  ),
                  width:
                      (context.allWidth -
                          (horizontalPadding * 2) -
                          context.spacing16) /
                      2,
                  child: _buildFlashSaleCard(context, product),
                );
              }).toList(),
              width: context.allWidth,
              customPadding: context.paddingZero,
              backgroundColor: backgroundColor,
              showIndicators: false,
              showArrows: false,
              autoPlay: CarouselAutoPlay.none,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds flash sale product card
  Widget _buildFlashSaleCard(
    BuildContext context,
    Product product,
  ) {
    final hasSale = product.hasDiscount;
    final discountPct = product.discountPercentage?.round();

    return GestureDetector(
      onTap: () {
        context.push('/product-detail/${product.id}');
      },
      child: OsmeaComponents.column(
        crossAxisAlignment: context.crossStart,
        children: [
          // Image container
          Container(
            height: context.height160 + context.spacing10,
            decoration: BoxDecoration(
              color: OsmeaColors.white,
              borderRadius: context.borderRadiusNormal,
              border: Border.all(color: OsmeaColors.silver, width: 1),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                // Product image
                OsmeaComponents.image(
                  imageUrl: product.imageUrl,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.contain,
                  borderRadius: context.borderRadiusNormal,
                  variant: ImageVariant.normal,
                  cacheWidth: 400,
                  cacheHeight: 400,
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
                        color: OsmeaColors.black,
                        borderRadius: BorderRadius.circular(context.spacing6),
                      ),
                      child: OsmeaComponents.text(
                        '$discountPct% OFF',
                        textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                          color: OsmeaColors.white,
                          fontSize:
                              context.fontSizeExtraSmall *
                              context.textScaleFactor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                // Wishlist button
                Positioned(
                  top: context.spacing8,
                  right: context.spacing8,
                  child: Builder(
                    builder: (context) {
                      final productId = product.id;
                      final localIsSaved =
                          _productWishlistStates[productId] ?? false;

                      return GestureDetector(
                        onTap: () async {
                          // Store previous state
                          final wasSaved = localIsSaved;

                          // Immediately update local state
                          setState(() {
                            _productWishlistStates[productId] = !wasSaved;
                          });

                          // Call view model
                          // Note: Need to implement toggle logic in FavoritesViewModel
                          final wishlistVm = GetIt.I<FavoritesViewModel>();
                          if (wasSaved) {
                             await wishlistVm.removeFavorite(productId);
                          } else {
                             await wishlistVm.addToCart(productId); // FIXME: This is add to cart, need add to wishlist method
                             // Since FavoritesViewModel lacks proper toggle method currently, UI updates locally.
                             // Assuming addFavorite exists or will be added.
                          }
                        },
                        child: Container(
                          width: context.width32,
                          height: context.height32,
                          decoration: BoxDecoration(
                            color: OsmeaColors.white,
                            borderRadius: BorderRadius.circular(
                              context.spacing24,
                            ),
                            border: Border.all(
                              color: OsmeaColors.thunder,
                              width: context.borderWidth,
                            ),
                          ),
                          child: Icon(
                            localIsSaved
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: context.iconSizeExtraSmall,
                            color: localIsSaved
                                ? OsmeaColors.black
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
                BlocBuilder<CurrencyCubit, String>(
                  builder: (context, currency) {
                    return OsmeaComponents.row(
                      children: [
                        if (hasSale) ...[
                          OsmeaComponents.text(
                            PriceHelper.format(
                              product.salePrice!,
                              currency,
                              Localizations.localeOf(context).toString()
                            ),
                            textStyle: OsmeaTextStyle.titleSmall(context).copyWith(
                              fontSize:
                                  context.fontSizeExtraSmallMedium *
                                  context.textScaleFactor,
                              fontWeight: FontWeight.w700,
                              color: OsmeaColors.black,
                            ),
                          ),
                          OsmeaComponents.sizedBox(width: context.spacing6),
                          OsmeaComponents.text(
                            PriceHelper.format(
                              product.price,
                              currency,
                              Localizations.localeOf(context).toString()
                            ),
                            textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                              fontSize:
                                  context.fontSizeSmall * context.textScaleFactor,
                              color: OsmeaColors.pewter,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ] else ...[
                          OsmeaComponents.text(
                            PriceHelper.format(
                              product.price,
                              currency,
                              Localizations.localeOf(context).toString()
                            ),
                            textStyle: OsmeaTextStyle.titleSmall(context).copyWith(
                              fontSize:
                                  context.fontSizeExtraSmallMedium *
                                  context.textScaleFactor,
                              fontWeight: FontWeight.w700,
                              color: OsmeaColors.thunder,
                            ),
                          ),
                        ]
                      ],
                    );
                  }
                ),
                OsmeaComponents.sizedBox(height: context.spacing4),
                // Product name
                OsmeaComponents.text(
                  product.name,
                  textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                    fontSize:
                        context.fontSizeExtraSmallMedium *
                        context.textScaleFactor,
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
}
