/*
 * RecommendedSectionWidget
 * ------------------------
 * "Recommended for you" product carousel section.
 * Loads from app config.
 */

import 'package:flutter/material.dart' hide Image;
import 'package:flutter/material.dart' as FlutterMaterial show Image;
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:storefront_woo/app/views/view_home/models/home_view_model.dart';
import 'package:storefront_woo/app/views/view_wishlist/models/wishlist_view_model.dart';
import 'package:storefront_woo/app/views/view_wishlist/models/module/states.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_api/freezed_model/response/list_all_products_response_model.dart';
import 'package:osmea_components/src/utils/snackbar_extensions.dart';

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
  List<ListAllProductsResponseModel> _getRecommendedProducts() {
    final config = _loadRecommendedConfig();
    if (config == null) {
      // Default: show first 4 products (for home view)
      return allProducts.take(4).toList();
    }

    // Check if specific product IDs are provided
    final productIds = config['product_ids'] as List<dynamic>?;
    if (productIds != null && productIds.isNotEmpty) {
      final ids = productIds.map((e) => e as int).toList();
      return allProducts.where((p) => ids.contains(p.id)).toList();
    }

    // If no specific IDs, show first 4 products (for home view)
    final limit = config['limit'] as int? ?? 4;
    return allProducts.take(limit).toList();
  }

  @override
  Widget build(BuildContext context) {
    final config = _loadRecommendedConfig();
    final sectionTitle = config?['title'] as String? ?? 'Recommended for you';
    final showSection = config?['enabled'] as bool? ?? true;

    if (!showSection) return const SizedBox.shrink();

    final recommendedProducts = _getRecommendedProducts();
    if (recommendedProducts.isEmpty) return const SizedBox.shrink();

    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header with "See all" button
        OsmeaComponents.padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: OsmeaComponents.row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              OsmeaComponents.text(
                sectionTitle,
                textStyle: OsmeaTextStyle.titleLarge(context).copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w600, // Semi Bold
                  height: 1.0, // line height 20px
                  letterSpacing: -0.2,
                  color: OsmeaColors.thunder,
                ),
              ),
              // See all button
              GestureDetector(
                onTap: () {
                  context.push('/products');
                },
                child: OsmeaComponents.text(
                  'See all',
                  textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: OsmeaColors.nordicBlue,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Product grid - 2 columns
        OsmeaComponents.padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Wrap(
            spacing: 15,
            runSpacing: 16,
            children: recommendedProducts.map((product) {
              return SizedBox(
                width: (MediaQuery.of(context).size.width - 55) / 2,
                child: _buildRecommendedCard(context, product),
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

    return GestureDetector(
      onTap: () {
        viewModel.selectProduct(product);
        context.push('/product-detail/${product.id ?? 0}');
      },
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image container
          Container(
            height: 170,
            decoration: BoxDecoration(
              color: OsmeaColors.pewter.withOpacity(0.1), // #f5f5f5
              borderRadius: BorderRadius.circular(13),
            ),
            child: Stack(
              children: [
                // Product image
                ClipRRect(
                  borderRadius: BorderRadius.circular(13),
                  child: product.images?.isNotEmpty == true
                      ? FlutterMaterial.Image.network(
                          product.images!.first.src ?? '',
                          width: double.infinity,
                          height: 170,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: double.infinity,
                              height: 170,
                              color: OsmeaColors.pewter.withOpacity(0.1),
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.image_outlined,
                                color: OsmeaColors.pewter,
                                size: 40,
                              ),
                            );
                          },
                        )
                      : Container(
                          width: double.infinity,
                          height: 170,
                          color: OsmeaColors.pewter.withOpacity(0.1),
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.image_outlined,
                            color: OsmeaColors.pewter,
                            size: 40,
                          ),
                        ),
                ),
                // Discount badge - top left (only when API marks onSale)
                if (product.onSale == true && discountPct != null)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: OsmeaColors.nordicBlue,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: OsmeaComponents.text(
                        '$discountPct% OFF',
                        textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                          color: OsmeaColors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                // Wishlist button - top right (reactive with BlocBuilder)
                Positioned(
                  top: 8,
                  right: 8,
                  child: BlocBuilder<WishlistViewModel, WishlistState>(
                    bloc: GetIt.I<WishlistViewModel>(),
                    buildWhen: (previous, current) {
                      // Always rebuild when transitioning to LoadedState from any other state
                      if (previous is! WishlistLoadedState && current is WishlistLoadedState) {
                        return true; // State just loaded, rebuild to show saved status
                      }
                      // Rebuild when state changes between Loaded states (item added/removed)
                      if (previous is WishlistLoadedState && current is WishlistLoadedState) {
                        final prevSaved = previous.items.any((e) => e.id == product.id);
                        final currSaved = current.items.any((e) => e.id == product.id);
                        return prevSaved != currSaved;
                      }
                      // Also rebuild if previous was LoadedState and current is not (shouldn't happen, but safe)
                      if (previous is WishlistLoadedState && current is! WishlistLoadedState) {
                        return true;
                      }
                      return false; // Don't rebuild for other state changes
                    },
                    builder: (context, wishlistState) {
                      final productId = product.id ?? 0;
                      final wishlistVm = GetIt.I<WishlistViewModel>();
                      // Always check current state, even if it's not LoadedState yet
                      final isSaved = wishlistVm.isSaved(productId);
                      
                      debugPrint('💖 RecommendedSection: Product $productId isSaved: $isSaved (state: ${wishlistState.runtimeType})');
                      
                      return GestureDetector(
                        onTap: () {
                          final bool wasSaved = isSaved;
                          viewModel.addProductToWishlist(productId);

                          // Show feedback with Undo
                          if (wasSaved) {
                            // It was saved; toggle will remove
                            context.showSnackbar(
                              title: 'Removed from favorites',
                              message: 'Item was removed from your favorites',
                              type: SnackbarType.error, // red
                              style: SnackbarStyle.minimal,
                              position: SnackbarPosition.bottom,
                              animation: SnackbarAnimation.slide,
                              actionLabel: 'Undo',
                              onAction: () => viewModel.addProductToWishlist(productId),
                            );
                          } else {
                            // It was not saved; toggle will add
                            context.showSnackbar(
                              title: 'Added to favorites',
                              message: 'Item was added to your favorites',
                              type: SnackbarType.info, // blue
                              style: SnackbarStyle.minimal,
                              position: SnackbarPosition.bottom,
                              animation: SnackbarAnimation.slide,
                              actionLabel: 'Undo',
                              onAction: () => viewModel.addProductToWishlist(productId),
                            );
                          }
                        },
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: OsmeaColors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: OsmeaColors.thunder.withOpacity(0.1),
                              width: 0.1,
                            ),
                          ),
                          child: Icon(
                            isSaved ? Icons.favorite : Icons.favorite_border,
                            size: 14,
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
          const SizedBox(height: 8),
          // Product info
          OsmeaComponents.padding(
            padding: const EdgeInsets.only(left: 8),
            child: OsmeaComponents.column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: OsmeaColors.nordicBlue,
                        ),
                      ),
                      OsmeaComponents.sizedBox(width: 6),
                      OsmeaComponents.text(
                        _formatPrice(
                          prices?.regularPrice,
                          currencyCode: prices?.currencyCode,
                          currencyDecimalSeparator: prices?.currencyDecimalSeparator,
                          currencyThousandSeparator: prices?.currencyThousandSeparator,
                          currencyMinorUnit: prices?.currencyMinorUnit,
                        ),
                        textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                          fontSize: 12,
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
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: OsmeaColors.thunder,
                    ),
                  ),
                ],
                const SizedBox(height: 4),
                // Product name
                OsmeaComponents.text(
                  product.name ?? 'Product',
                  textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w500, // Medium
                    height: 1.14, // line height 16px
                    color: OsmeaColors.thunder,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                // Description
                if (product.shortDescription != null &&
                    product.shortDescription!.isNotEmpty)
                  OsmeaComponents.text(
                    _stripHtml(product.shortDescription!),
                    textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      height: 1.2,
                      color: OsmeaColors.pewter,
                    ),
                    maxLines: 1,
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
    final parsedPrice = PriceInfoCurrencyHelper.parsePriceToDouble(
      priceString,
      currencyCode: currencyCode,
      currencyDecimalSeparator: currencyDecimalSeparator,
      currencyThousandSeparator: currencyThousandSeparator,
      currencyMinorUnit: currencyMinorUnit,
    ) ?? 0.0;
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
