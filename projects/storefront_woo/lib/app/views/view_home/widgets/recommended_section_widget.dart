/*
 * RecommendedSectionWidget
 * ------------------------
 * "Recommended for you" product carousel section.
 * Loads from app config.
 */

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_woo/app/views/view_home/models/home_view_model.dart';
import 'package:storefront_woo/app/views/view_wishlist/models/wishlist_view_model.dart';
import 'package:storefront_woo/app/views/view_wishlist/models/module/states.dart';
// Animation helpers are now imported from core
import 'package:apis/network/remote/woocommerce/store_api/product_api/freezed_model/response/list_all_products_response_model.dart';
import 'package:storefront_woo/gen/translations.g.dart';

/// Recommended section widget
class RecommendedSectionWidget extends StatelessWidget {
  final AssetConfigHelper configHelper;
  final List<ListAllProductsResponseModel> allProducts;
  final HomeViewModel viewModel;

  const RecommendedSectionWidget({
    super.key,
    required this.configHelper,
    required this.allProducts,
    required this.viewModel,
  });

  /// Loads recommended section configuration
  Map<String, dynamic>? _loadRecommendedConfig() {
    try {
      return configHelper.getObject('home_view.recommended');
    } catch (e) {
      debugPrint('⚠️ Failed to load recommended config: $e');
      return null;
    }
  }

  /// Filters products based on recommended config
  /// Optimized to prevent blocking during build
  List<ListAllProductsResponseModel> _getRecommendedProducts() {
    // Use cached config to avoid repeated lookups
    final config = _loadRecommendedConfig();
    if (config == null) {
      // Default: show first 4 products (for home view)
      // Use take() which is lazy and efficient
      return allProducts.take(4).toList();
    }

    // Check if specific product IDs are provided
    final productIds = config['product_ids'] as List<dynamic>?;
    if (productIds != null && productIds.isNotEmpty) {
      // Convert to Set for O(1) lookup instead of O(n)
      final ids = productIds.map((e) => e as int).toSet();
      return allProducts.where((p) => ids.contains(p.id)).toList();
    }

    // If no specific IDs, show first 4 products (for home view)
    final limit = config['limit'] as int? ?? 4;
    return allProducts.take(limit).toList();
  }

  /// Gets horizontal padding from config
  double _getHorizontalPadding() {
    try {
      final config = _loadRecommendedConfig();
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

  /// Get color from config
  Color _getColorFromConfig(String key, Color fallback) {
    try {
      final colorString = configHelper.getString('home_view.recommended.$key');
      if (colorString.isNotEmpty && colorString.startsWith('#')) {
        final hexString = colorString.substring(1);
        if (hexString.length == 6) {
          return Color(int.parse('FF$hexString', radix: 16));
        } else if (hexString.length == 8) {
          return Color(int.parse(hexString, radix: 16));
        }
      }
    } catch (e) {
      debugPrint('⚠️ Failed to load recommended color $key: $e');
    }
    return fallback;
  }

  @override
  Widget build(BuildContext context) {
    final config = _loadRecommendedConfig();
    final sectionTitle = config?['title'] as String? ?? context.t.homeView.widgets.recommended.title;
    final showSection = config?['enabled'] as bool? ?? true;

    if (!showSection) return const SizedBox.shrink();

    final recommendedProducts = _getRecommendedProducts();
    if (recommendedProducts.isEmpty) return const SizedBox.shrink();

    final horizontalPadding = _getHorizontalPadding();

    return OsmeaComponents.column(
      crossAxisAlignment: context.crossStart,
      children: [
        // Section header with "See all" button
        OsmeaComponents.padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: OsmeaComponents.row(
            mainAxisAlignment: context.spaceBetween,
            crossAxisAlignment: context.crossCenter,
            children: [
              OsmeaComponents.text(
                sectionTitle,
                textStyle: OsmeaTextStyle.titleLarge(context).copyWith(
                  fontSize: context.fontSizeNormal * context.textScaleFactor,
                  fontWeight: FontWeight.w600, // Semi Bold
                  height: context.lineHeightTight, // line height 20px
                  letterSpacing: -0.2,
                  color: _getColorFromConfig('titleColor', OsmeaColors.black),
                ),
              ),
              // See all button
              GestureDetector(
                onTap: () {
                  context.push('/products');
                },
                child: OsmeaComponents.text(
                  context.t.homeView.widgets.recommended.seeAll,
                  textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                    fontSize:
                        context.fontSizeExtraSmallMedium *
                        context.textScaleFactor,
                    fontWeight: FontWeight.w500,
                    color: _getColorFromConfig('seeAllColor', OsmeaColors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
        OsmeaComponents.sizedBox(height: _getTitleSpacing()),
        // Product grid - 2 columns (no padding, spacing handled by parent)
        OsmeaComponents.padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Wrap(
            spacing: context.spacing16,
            runSpacing: context.height16,
            children: recommendedProducts.asMap().entries.map((entry) {
              final index = entry.key;
              final product = entry.value;
              // Use RepaintBoundary to isolate each card and prevent unnecessary repaints
              return RepaintBoundary(
                child: StaggeredAnimation(
                  index: index,
                  child: SizedBox(
                    width:
                        (context.allWidth -
                            (horizontalPadding * 2) -
                            context.spacing16) /
                        2,
                    child: _buildRecommendedCard(context, product),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  /// Builds recommended product card in Figma style
  Widget _buildRecommendedCard(
    BuildContext context,
    ListAllProductsResponseModel product,
  ) {
    final prices = product.prices;
    // currency symbol not needed; prices formatted via helper with currencyCode
    final bool hasSale =
        product.onSale == true &&
        prices?.salePrice != null &&
        (prices?.salePrice?.isNotEmpty ?? false) &&
        prices?.salePrice != prices?.regularPrice;
    int? discountPct;
    if (hasSale) {
      final rp = double.tryParse(
        (prices!.regularPrice ?? '').replaceAll(RegExp(r'[^\d.,]'), ''),
      );
      final sp = double.tryParse(
        (prices.salePrice ?? '').replaceAll(RegExp(r'[^\d.,]'), ''),
      );
      if (rp != null && sp != null && rp > 0 && sp < rp) {
        discountPct = (((rp - sp) / rp) * 100).round();
      }
    }

    return AnimatedCard(
      onTap: () {
        viewModel.selectProduct(product);
        context.push('/product-detail/${product.id ?? 0}');
      },
      child: OsmeaComponents.column(
        crossAxisAlignment: context.crossStart,
        children: [
          // Image container
          Container(
            height: context.height160 + context.spacing10,
            decoration: BoxDecoration(
              color: _getColorFromConfig('card.imageBackgroundColor', OsmeaColors.white),
              borderRadius: BorderRadius.circular(
                configHelper.getDouble('home_view.recommended.card.borderRadius', 12.0),
              ),
              border: configHelper.getBool('home_view.recommended.card.showBorder', false)
                  ? Border.all(
                      color: _getColorFromConfig('card.borderColor', OsmeaColors.silver),
                      width: configHelper.getDouble('home_view.recommended.card.borderWidth', 0.0),
                    )
                  : null,
            ),
            child: Stack(
              children: [
                // Product image - using OsmeaComponents.image for optimized loading
                OsmeaComponents.image(
                  imageUrl: product.images?.isNotEmpty == true
                      ? product.images!.first.src
                      : null,
                  width: double.infinity,
                  height: context.height160 + context.spacing10,
                  fit: BoxFit.cover,
                  borderRadius: BorderRadius.circular(
                    configHelper.getDouble('home_view.recommended.card.borderRadius', 12.0),
                  ),
                  variant: ImageVariant.normal,
                  cacheWidth: 400, // Limit image size for performance
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
                // Discount badge - top left (only when API marks onSale)
                if (product.onSale == true && discountPct != null)
                  Positioned(
                    top: context.spacing8,
                    left: context.spacing8,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.spacing6,
                        vertical: context.spacing2,
                      ),
                      decoration: BoxDecoration(
                        color: _getColorFromConfig('discountBadge.backgroundColor', OsmeaColors.black),
                        borderRadius: BorderRadius.circular(
                          configHelper.getDouble('home_view.recommended.discountBadge.borderRadius', 6.0),
                        ),
                      ),
                      child: OsmeaComponents.text(
                        '$discountPct% OFF',
                        textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                          color: _getColorFromConfig('discountBadge.textColor', OsmeaColors.white),
                          fontSize:
                              context.fontSizeExtraSmall *
                              context.textScaleFactor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),

                // Wishlist button - top right
                Positioned(
                  top: context.spacing8,
                  right: context.spacing8,
                  child: BlocBuilder<WishlistViewModel, WishlistState>(
                    bloc: GetIt.I<WishlistViewModel>(),
                    buildWhen: (previous, current) {
                      // Only rebuild when items actually change
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
                      // Handle WishlistSuccessState by using previousState
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
                          final bool wasSaved = isSaved;
                          
                          // Optimistic update - show snackbar immediately
                          if (wasSaved) {
                            context.showSnackbar(
                              title: context.t.homeView.widgets.recommended.wishlist.removed.title,
                              message: context.t.homeView.widgets.recommended.wishlist.removed.message,
                              type: SnackbarType.info,
                              style: SnackbarStyle.minimal,
                              position: SnackbarPosition.bottom,
                              animation: SnackbarAnimation.slide,
                              duration: const Duration(seconds: 2),
                              actionLabel: context.t.homeView.widgets.recommended.wishlist.removed.undo,
                              onAction: () =>
                                  viewModel.addProductToWishlist(productId),
                            );
                          } else {
                            context.showSnackbar(
                              title: context.t.homeView.widgets.recommended.wishlist.added.title,
                              message: context.t.homeView.widgets.recommended.wishlist.added.message,
                              type: SnackbarType.success,
                              style: SnackbarStyle.minimal,
                              position: SnackbarPosition.bottom,
                              animation: SnackbarAnimation.slide,
                              duration: const Duration(seconds: 2),
                              actionLabel: context.t.homeView.widgets.recommended.wishlist.added.undo,
                              onAction: () =>
                                  viewModel.addProductToWishlist(productId),
                            );
                          }

                          // Then perform the actual toggle
                          await viewModel.addProductToWishlist(productId);
                        },
                        child: Container(
                          width: context.width32,
                          height: context.height32,
                          decoration: BoxDecoration(
                            color: _getColorFromConfig('wishlistButton.backgroundColor', OsmeaColors.white),
                            borderRadius: BorderRadius.circular(
                              configHelper.getDouble('home_view.recommended.wishlistButton.borderRadius', 24.0),
                            ),
                            border: configHelper.getDouble('home_view.recommended.wishlistButton.borderWidth', 0.0) > 0
                                ? Border.all(
                                    color: _getColorFromConfig('wishlistButton.borderColor', OsmeaColors.silver),
                                    width: configHelper.getDouble('home_view.recommended.wishlistButton.borderWidth', 0.0),
                                  )
                                : null,
                          ),
                          child: Icon(
                            isSaved ? Icons.favorite : Icons.favorite_border,
                            size: context.iconSizeExtraSmall,
                            color: isSaved
                                ? _getColorFromConfig('wishlistButton.iconColorSelected', OsmeaColors.black)
                                : _getColorFromConfig('wishlistButton.iconColor', OsmeaColors.black),
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
                          currencyDecimalSeparator:
                              prices?.currencyDecimalSeparator,
                          currencyThousandSeparator:
                              prices?.currencyThousandSeparator,
                          currencyMinorUnit: prices?.currencyMinorUnit,
                        ),
                        textStyle: OsmeaTextStyle.titleSmall(context).copyWith(
                          fontSize:
                              context.fontSizeExtraSmallMedium *
                              context.textScaleFactor,
                          fontWeight: FontWeight.w700,
                          color: _getColorFromConfig('price.salePriceColor', OsmeaColors.black),
                        ),
                      ),
                      OsmeaComponents.sizedBox(width: context.spacing6),
                      OsmeaComponents.text(
                        _formatPrice(
                          prices?.regularPrice,
                          currencyCode: prices?.currencyCode,
                          currencyDecimalSeparator:
                              prices?.currencyDecimalSeparator,
                          currencyThousandSeparator:
                              prices?.currencyThousandSeparator,
                          currencyMinorUnit: prices?.currencyMinorUnit,
                        ),
                        textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                          fontSize:
                              context.fontSizeSmall * context.textScaleFactor,
                          color: _getColorFromConfig('price.strikethroughPriceColor', OsmeaColors.grayMaterial[400]!),
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
                      currencyDecimalSeparator:
                          prices?.currencyDecimalSeparator,
                      currencyThousandSeparator:
                          prices?.currencyThousandSeparator,
                      currencyMinorUnit: prices?.currencyMinorUnit,
                    ),
                    textStyle: OsmeaTextStyle.titleSmall(context).copyWith(
                      fontSize:
                          context.fontSizeExtraSmallMedium *
                          context.textScaleFactor,
                      fontWeight: FontWeight.w700,
                      color: _getColorFromConfig('price.regularPriceColor', OsmeaColors.black),
                    ),
                  ),
                ],
                OsmeaComponents.sizedBox(height: context.spacing4),
                // Product name
                OsmeaComponents.text(
                  product.name ?? context.t.homeView.widgets.recommended.defaultProductName,
                  textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                    fontSize:
                        context.fontSizeExtraSmallMedium *
                        context.textScaleFactor,
                    fontWeight: FontWeight.w500, // Medium
                    height: 1.14, // line height 16px
                    color: _getColorFromConfig('productName.color', OsmeaColors.black),
                  ),
                  maxLines: context.maxLineTwo,
                  overflow: TextOverflow.ellipsis,
                ),
                OsmeaComponents.sizedBox(height: context.spacing2),
                // Description
                if (product.shortDescription != null &&
                    product.shortDescription!.isNotEmpty)
                  OsmeaComponents.text(
                    _stripHtml(product.shortDescription!),
                    textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                      fontSize:
                          context.fontSizeExtraSmall * context.textScaleFactor,
                      fontWeight: FontWeight.w400,
                      height: 1.2,
                      color: _getColorFromConfig('description.color', OsmeaColors.grayMaterial[400]!),
                    ),
                    maxLines: context.maxLineOne,
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

  String _stripHtml(String input) {
    return input.replaceAll(RegExp(r'<[^>]*>'), '');
  }
}
