/*
 * Product Detail Widgets
 * ----------------------
 * Widgets for the product detail view following OSMEA architecture.
 * Uses OsmeaComponents for consistent UI.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:go_router/go_router.dart';
// removed unused go_router import
import 'package:apis/network/remote/woocommerce/store_api/product_api/freezed_model/response/retrieve_product_response_model.dart';
import 'package:storefront_woo/app/views/view_product_detail/models/product_detail_view_model.dart';
import 'package:storefront_woo/app/views/view_product_detail/models/module/states.dart';
import 'package:storefront_woo/app/views/view_product_detail/widgets/description_section.dart';
import 'package:storefront_woo/app/views/view_product_detail/widgets/action_section.dart';

/// Main content widget for product detail view
class ProductDetailContentWidget extends StatelessWidget {
  final ProductDetailViewModel viewModel;
  final ProductDetailLoadedState state;
  final Function(String path) goRoute;

  const ProductDetailContentWidget({
    super.key,
    required this.viewModel,
    required this.state,
    required this.goRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        OsmeaComponents.singleChildScrollView(
          padding: EdgeInsets.only(bottom: context.dynamicHeight(0.12)),
          child: OsmeaComponents.column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product images with overlay actions
              _buildProductImages(context, state.imageUrls, goRoute: goRoute, withOverlays: true),

              // Product info section
              OsmeaComponents.padding(
                padding: EdgeInsets.fromLTRB(
                  context.spacing12,
                  0,
                  context.spacing12,
                  0,
                ),
                child: OsmeaComponents.column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product name
                    OsmeaComponents.text(
                      state.product.name ?? 'Unknown Product',
                      textStyle: OsmeaTextStyle.headlineLarge(context).copyWith(
                        fontWeight: FontWeight.w300,
                        letterSpacing: -0.8,
                        height: 1.0,
                        color: OsmeaColors.thunder,
                      ),
                    ),

                    OsmeaComponents.sizedBox(height: context.spacing8),

                    // Price
                    OsmeaComponents.text(
                      _formatPrice(state.product.prices),
                      textStyle: OsmeaTextStyle.headlineSmall(context).copyWith(
                        color: OsmeaColors.nordicBlue,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.5,
                        height: 1.1,
                      ),
                    ),

                    OsmeaComponents.sizedBox(height: context.spacing8),

                    // Attributes
                    if (state.product.attributes != null &&
                        state.product.attributes!.isNotEmpty)
                      _buildAttributes(context, viewModel),

                    OsmeaComponents.sizedBox(height: context.spacing16),

                    // Description
                    if (state.product.description?.isNotEmpty == true) ...[
                      OsmeaComponents.text(
                        'Details',
                        textStyle: OsmeaTextStyle.titleSmall(context).copyWith(
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.0,
                          color: OsmeaColors.thunder.withValues(alpha: 0.8),
                        ),
                      ),
                      OsmeaComponents.sizedBox(height: context.spacing8),
                      DescriptionSection(
                        description: state.product.description!,
                        viewModel: viewModel,
                        state: state,
                      ),
                      OsmeaComponents.sizedBox(height: context.spacing16),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),

        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: SafeArea(
            top: false,
            child: OsmeaComponents.container(
              padding: EdgeInsets.symmetric(
                horizontal: context.spacing16,
                vertical: context.spacing12,
              ),
              decoration: BoxDecoration(
                color: OsmeaColors.white,
                boxShadow: [
                  BoxShadow(
                    color: OsmeaColors.black.withValues(alpha: 0.06),
                    blurRadius: 12,
                    offset: const Offset(0, -6),
                  ),
                ],
              ),
              child: ActionSection(
                isInWishlist: state.isInWishlist,
                onToggleWishlist: () {
                  viewModel.addProductToWishlistFire(state.product.id ?? 0);
                },
                isInCart: state.isInCart,
                onAddToCart: () async {
                  // Add product to cart
                  await viewModel.addProductToCart(
                    state.product.id ?? 0,
                    quantity: state.selectedQuantity,
                  );
                  
                  // Check if add was successful (check state)
                  final currentState = viewModel.state;
                  if (currentState is ProductDetailLoadedState && currentState.isInCart) {
                    // Show success popup with cart token for navigation
                    final cartToken = await viewModel.getCartTokenForNavigation();
                    _showAddToCartSuccessPopup(context, cartToken: cartToken);
                  }
                },
                selectedQuantity: state.selectedQuantity,
                onUpdateQuantity: (q) => viewModel.updateQuantityFire(q),
                onShare: () {},
                showWishlistAndShare: false,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Formats price with currency symbol and handles sale prices
  String _formatPrice(Prices? prices) {
    if (prices == null) {
      debugPrint('❌ ProductDetailWidget: Prices is null');
      return PriceInfoCurrencyHelper.getDefaultPrice();
    }

    debugPrint('💰 ProductDetailWidget: Price data: ${prices.toJson()}');

    // Determine which price to show
    String? priceString;
    if (prices.salePrice != null &&
        prices.salePrice!.isNotEmpty &&
        prices.regularPrice != null &&
        prices.regularPrice!.isNotEmpty) {
      priceString = prices.salePrice;
      debugPrint('💰 ProductDetailWidget: Using sale price: $priceString');
    } else {
      priceString = prices.regularPrice ?? prices.price ?? '0.00';
      debugPrint(
        '💰 ProductDetailWidget: Using regular/main price: $priceString',
      );
    }

    // Parse the price to double for proper formatting
    final cleanPrice = priceString!.replaceAll(RegExp(r'[^\d.,]'), '');
    final parsedPrice = double.tryParse(cleanPrice) ?? 0.0;

    // Use PriceInfoCurrencyHelper for proper formatting
    final formattedPrice = PriceInfoCurrencyHelper.formatPrice(
      parsedPrice,
      currencyCode: prices.currencyCode,
      decimalPlaces: prices.currencyMinorUnit ?? 2,
    );

    debugPrint(
      '💰 ProductDetailWidget: Final formatted price: "$formattedPrice"',
    );
    return formattedPrice;
  }

  /// Builds product images area. Tapping opens the dedicated ImageDetailScreen.
  Widget _buildProductImages(
    BuildContext context,
    List<String> imageUrls, {
    required Function(String path) goRoute,
    bool withOverlays = false,
  }) {
    if (imageUrls.isEmpty) {
      return OsmeaComponents.container(
        height: context.dynamicHeight(0.32),
        width: context.infinity,
        color: OsmeaColors.grayMaterial[100],
        child: const Icon(Icons.image, size: 100),
      );
    }

    final height = context.allHeight < 700
        ? context.dynamicHeight(0.34)
        : context.dynamicHeight(0.40);

    final pager = PageView.builder(
      itemCount: imageUrls.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ImageDetailScreen(
                  goRoute: goRoute,
                  imageUrls: imageUrls,
                  initialIndex: index,
                ),
              ),
            );
          },
          child: OsmeaComponents.image(
            imageUrl: imageUrls[index],
            width: context.infinity,
            height: height,
            fit: BoxFit.contain,
            placeholder: OsmeaComponents.container(
              color: OsmeaColors.grayMaterial[100],
              child: const Icon(Icons.image, size: 100),
            ),
          ),
        );
      },
    );

    if (!withOverlays) {
      return OsmeaComponents.sizedBox(height: height, child: pager);
    }

    return OsmeaComponents.sizedBox(
      height: height,
      child: Stack(
        children: [
          pager,
          Positioned(
            right: context.spacing12,
            top: context.spacing12,
            child: OsmeaComponents.column(
              children: [
                OsmeaComponents.iconButton(
                  icon: Icon(
                    state.isInWishlist
                        ? Icons.favorite
                        : Icons.favorite_outline,
                    color: state.isInWishlist
                        ? OsmeaColors.nordicBlue
                        : OsmeaColors.thunder,
                  ),
                  size: ButtonSize.medium,
                  variant: ButtonVariant.ghost,
                  backgroundColor: OsmeaColors.white.withValues(alpha: 0.9),
                  borderRadius: context.width24,
                  onPressed: () =>
                      viewModel.addProductToWishlistFire(state.product.id ?? 0),
                ),
                OsmeaComponents.sizedBox(height: context.spacing8),
                OsmeaComponents.iconButton(
                  icon: const Icon(Icons.share_outlined),
                  size: ButtonSize.medium,
                  variant: ButtonVariant.ghost,
                  backgroundColor: OsmeaColors.white.withValues(alpha: 0.9),
                  borderRadius: context.width24,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttributes(
    BuildContext context,
    ProductDetailViewModel viewModel,
  ) {
    final rawAttributes = state.product.attributes!;

    // Normalize attributes coming from different Woo APIs
    List<Map<String, dynamic>> normalized = [];
    for (final item in rawAttributes) {
      if (item is Map<String, dynamic>) {
        // Store API shape often provides either `options: List<String>`
        // or `terms: List<{ name: string }>`
        final name = (item['name'] ?? item['label'] ?? '').toString();
        List<String> options = [];
        final rawOptions = item['options'];
        final rawTerms = item['terms'];
        if (rawOptions is List) {
          options = rawOptions.map((e) => e.toString()).toList();
        } else if (rawTerms is List) {
          options = rawTerms
              .map((e) => e is Map ? (e['name'] ?? e['value'] ?? '').toString() : e.toString())
              .where((e) => e.isNotEmpty)
              .toList();
        }
        normalized.add({'name': name, 'options': options});
      } else {
        // Fallback for typed model with getters `name` and `options`
        try {
          final dynamic dyn = item;
          final String name = (dyn.name as String?) ?? '';
          final List<String> options =
              (dyn.options as List?)?.map((e) => e.toString()).toList() ?? [];
          normalized.add({'name': name, 'options': options});
        } catch (_) {
          // Skip unknown shapes gracefully
        }
      }
    }

    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final attr in normalized)
          if ((attr['options'] as List).isNotEmpty) ...[
            OsmeaComponents.text(
              (attr['name'] as String?) ?? '',
              textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                color: OsmeaColors.pewter,
                fontWeight: FontWeight.w500,
              ),
            ),
            OsmeaComponents.sizedBox(height: context.spacing6),
            Wrap(
              spacing: context.spacing8,
              runSpacing: context.spacing8,
              children: [
                for (final opt in (attr['options'] as List<String>))
                  ChoiceChip(
                    label: Text(opt),
                    selected: state.selectedAttributes[(attr['name'] as String?)] == opt,
                    onSelected: (_) => viewModel.setSelectedAttribute(
                      (attr['name'] as String?) ?? '',
                      opt,
                    ),
                    selectedColor: OsmeaColors.nordicBlue.withValues(
                      alpha: 0.12,
                    ),
                    shape: StadiumBorder(
                      side: BorderSide(
                        color: OsmeaColors.silver.withValues(alpha: 0.4),
                      ),
                    ),
                    labelStyle: OsmeaTextStyle.bodySmall(context),
                  ),
              ],
            ),
            OsmeaComponents.sizedBox(height: context.spacing16),
          ],
      ],
    );
  }
}

/// Loading widget for product detail view
class ProductDetailLoadingWidget extends StatelessWidget {
  const ProductDetailLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

/// Error widget for product detail view
class ProductDetailErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ProductDetailErrorWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.center(
      child: OsmeaComponents.column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: OsmeaColors.red),
          OsmeaComponents.sizedBox(height: 16),
          OsmeaComponents.text(
            message,
            textStyle: OsmeaTextStyle.bodyMedium(context),
            textAlign: TextAlign.center,
          ),
          OsmeaComponents.sizedBox(height: 16),
          OsmeaComponents.button(onPressed: onRetry, text: 'Retry'),
        ],
      ),
    );
  }
}

/// Shows add to cart success popup with options
void _showAddToCartSuccessPopup(BuildContext context, {String? cartToken}) {
  OsmeaComponents.showPopup(
    context: context,
    variant: PopupVariant.dialog,
    size: PopupSize.small,
    title: 'Product Added to Cart',
    child: OsmeaComponents.text(
      'Product successfully added to cart.',
      textAlign: TextAlign.center,
      textStyle: OsmeaTextStyle.bodyMedium(context),
      color: OsmeaColors.thunder,
    ),
    footer: OsmeaComponents.column(
      children: [
        OsmeaComponents.button(
          text: 'Check Cart',
          variant: ButtonVariant.primary,
          size: ButtonSize.medium,
          fullWidth: true,
          onPressed: () {
            Navigator.of(context).pop();
            // Navigate to cart page with cart token in arguments
            // Use context.go instead of push since cart is in ShellRoute (bottom nav)
            // This prevents duplicate key error in Navigator
            context.go('/cart', extra: {
              'cartToken': cartToken,
            });
          },
        ),
        OsmeaComponents.sizedBox(height: context.spacing12),
        OsmeaComponents.button(
          text: 'Continue Shopping',
          variant: ButtonVariant.outlined,
          size: ButtonSize.medium,
          fullWidth: true,
          onPressed: () {
            Navigator.of(context).pop();
            // Just close popup, stay on product detail page
          },
        ),
      ],
    ),
  );
}
