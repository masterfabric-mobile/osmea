/*
 * Product Detail Widgets
 * ----------------------
 * Widgets for the product detail view following OSMEA architecture.
 * Uses OsmeaComponents for consistent UI.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_api/freezed_model/response/retrieve_product_response_model.dart'
    as product_models;
import 'package:apis/network/remote/woocommerce/store_api/product_reviews_api/freezed_model/response/list_product_reviews_response_model.dart';
import 'package:storefront_woo/app/views/view_product_detail/models/product_detail_view_model.dart';
import 'package:storefront_woo/app/views/view_product_detail/models/module/states.dart';
import 'package:storefront_woo/app/views/view_product_detail/widgets/description_section.dart';
import 'package:storefront_woo/app/views/view_product_detail/widgets/action_section.dart';
import 'package:storefront_woo/app/views/view_wishlist/models/wishlist_view_model.dart';
import 'package:storefront_woo/app/views/view_wishlist/models/module/states.dart';

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
    final productId = state.product.id ?? 0;

    // Use BlocBuilder to reactively listen to WishlistViewModel changes
    return BlocBuilder<WishlistViewModel, WishlistState>(
      bloc: GetIt.I<WishlistViewModel>(),
      buildWhen: (previous, current) {
        // Rebuild when state changes from Initial/Loading to Loaded
        if (previous is! WishlistLoadedState &&
            current is WishlistLoadedState) {
          return true; // State just loaded, rebuild to show saved status
        }
        // Rebuild when state changes between Loaded states (item added/removed)
        if (previous is WishlistLoadedState && current is WishlistLoadedState) {
          final prevSaved = previous.items.any((e) => e.id == productId);
          final currSaved = current.items.any((e) => e.id == productId);
          return prevSaved != currSaved;
        }
        return false; // Don't rebuild for other state changes
      },
      builder: (context, wishlistState) {
        final wishlistVm = GetIt.I<WishlistViewModel>();
        final isInWishlist = wishlistVm.isSaved(productId);

        return Stack(
          children: [
            OsmeaComponents.singleChildScrollView(
              padding: EdgeInsets.only(bottom: context.dynamicHeight(0.12)),
              child: OsmeaComponents.column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product images with overlay actions
                  _buildProductImages(
                    context,
                    state.imageUrls,
                    viewModel: viewModel,
                    goRoute: goRoute,
                    withOverlays: true,
                    isInWishlist: isInWishlist,
                    productId: productId,
                  ),

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
                          textStyle: OsmeaTextStyle.headlineLarge(context)
                              .copyWith(
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
                          textStyle: OsmeaTextStyle.headlineSmall(context)
                              .copyWith(
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
                            textStyle: OsmeaTextStyle.titleSmall(context)
                                .copyWith(
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.0,
                                  color: OsmeaColors.thunder.withValues(
                                    alpha: 0.8,
                                  ),
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

                        // Reviews Section
                        _buildReviewsSection(context, viewModel, state),
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
                    isInWishlist: isInWishlist,
                    onToggleWishlist: () {
                      viewModel.addProductToWishlistFire(productId);
                    },
                    isInCart: state.isInCart,
                    onAddToCart: () async {
                      // Check if all required attributes are selected before adding
                      final product = state.product;
                      if (product.attributes != null &&
                          product.attributes!.isNotEmpty) {
                        final Set<String> requiredAttributes = {};
                        for (final attr in product.attributes!) {
                          if (attr is Map<String, dynamic>) {
                            final name = (attr['name'] ?? attr['label'] ?? '')
                                .toString();
                            List<String> options = [];
                            final rawOptions = attr['options'];
                            final rawTerms = attr['terms'];

                            if (rawOptions is List && rawOptions.isNotEmpty) {
                              options = rawOptions
                                  .map((e) => e.toString())
                                  .toList();
                            } else if (rawTerms is List &&
                                rawTerms.isNotEmpty) {
                              options = rawTerms
                                  .map(
                                    (e) => e is Map
                                        ? (e['name'] ?? e['value'] ?? '')
                                              .toString()
                                        : e.toString(),
                                  )
                                  .where((e) => e.isNotEmpty)
                                  .toList();
                            }

                            if (options.isNotEmpty) {
                              requiredAttributes.add(name);
                            }
                          }
                        }

                        final Set<String> missingAttributes = requiredAttributes
                            .where(
                              (attr) =>
                                  !state.selectedAttributes.containsKey(attr) ||
                                  state.selectedAttributes[attr] == null ||
                                  state.selectedAttributes[attr]!.isEmpty,
                            )
                            .toSet();

                        if (missingAttributes.isNotEmpty) {
                          // Show snackbar using OsmeaComponents
                          context.snackbarError(
                            'Please select all options',
                            duration: const Duration(seconds: 2),
                          );

                          // Highlight missing attributes
                          final currentState = viewModel.state;
                          if (currentState is ProductDetailLoadedState) {
                            viewModel.stateChanger(
                              currentState.copyWith(
                                highlightedAttributes: missingAttributes,
                              ),
                            );

                            // Reset highlighting after 2 seconds
                            Future.delayed(const Duration(seconds: 2), () {
                              final stateAfterDelay = viewModel.state;
                              if (stateAfterDelay is ProductDetailLoadedState) {
                                viewModel.stateChanger(
                                  stateAfterDelay.copyWith(
                                    highlightedAttributes: {},
                                  ),
                                );
                              }
                            });
                          }
                          return;
                        }
                      }

                      // Add product to cart
                      await viewModel.addProductToCart(
                        state.product.id ?? 0,
                        quantity: state.selectedQuantity,
                      );

                      // Check if add was successful (check state)
                      final currentState = viewModel.state;
                      if (currentState is ProductDetailLoadedState &&
                          currentState.isInCart) {
                        // Show success popup with cart token for navigation
                        final cartToken = await viewModel
                            .getCartTokenForNavigation();
                        _showAddToCartSuccessPopup(
                          context,
                          cartToken: cartToken,
                        );
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
      },
    );
  }

  /// Formats price with currency symbol and handles sale prices
  String _formatPrice(product_models.Prices? prices) {
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

    // Use PriceInfoCurrencyHelper.parsePriceToDouble to properly handle formatted strings
    // Use API-provided separators and minor_unit to correctly parse the price format
    final parsedPrice =
        PriceInfoCurrencyHelper.parsePriceToDouble(
          priceString!,
          currencyCode: prices.currencyCode,
          currencyDecimalSeparator: prices.currencyDecimalSeparator,
          currencyThousandSeparator: prices.currencyThousandSeparator,
          currencyMinorUnit: prices.currencyMinorUnit,
        ) ??
        0.0;

    // Use PriceInfoCurrencyHelper for proper formatting
    // Use API-provided separators to correctly format the price
    final formattedPrice = PriceInfoCurrencyHelper.formatPrice(
      parsedPrice,
      currencyCode: prices.currencyCode,
      currencyDecimalSeparator: prices.currencyDecimalSeparator,
      currencyThousandSeparator: prices.currencyThousandSeparator,
      decimalPlaces: prices.currencyMinorUnit ?? 2,
      removeTrailingZeros: true,
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
    required ProductDetailViewModel viewModel,
    required Function(String path) goRoute,
    bool withOverlays = false,
    bool isInWishlist = false,
    int productId = 0,
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
                    isInWishlist ? Icons.favorite : Icons.favorite_outline,
                    color: isInWishlist
                        ? OsmeaColors.nordicBlue
                        : OsmeaColors.thunder,
                  ),
                  size: ButtonSize.medium,
                  variant: ButtonVariant.ghost,
                  backgroundColor: OsmeaColors.white.withValues(alpha: 0.9),
                  borderRadius: context.width24,
                  onPressed: () =>
                      viewModel.addProductToWishlistFire(productId),
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
    // Sadece product API'den gelen veriyi kullan, ekstra API çağrısı yapma
    List<Map<String, dynamic>> normalized = [];
    for (final item in rawAttributes) {
      if (item is Map<String, dynamic>) {
        // Store API shape often provides either `options: List<String>`
        // or `terms: List<{ name: string }>`
        final name = (item['name'] ?? item['label'] ?? '').toString();
        List<String> options = [];
        final rawOptions = item['options'];
        final rawTerms = item['terms'];

        if (rawOptions is List && rawOptions.isNotEmpty) {
          options = rawOptions.map((e) => e.toString()).toList();
        } else if (rawTerms is List && rawTerms.isNotEmpty) {
          options = rawTerms
              .map(
                (e) => e is Map
                    ? (e['name'] ?? e['value'] ?? '').toString()
                    : e.toString(),
              )
              .where((e) => e.isNotEmpty)
              .toList();
        }

        // Sadece options/terms varsa ekle (boş attribute'ları gösterme)
        if (options.isNotEmpty) {
          normalized.add({'name': name, 'options': options});
        }
      } else {
        // Fallback for typed model with getters `name` and `options`
        try {
          final dynamic dyn = item;
          final String name = (dyn.name as String?) ?? '';
          final List<String> options =
              (dyn.options as List?)?.map((e) => e.toString()).toList() ?? [];

          // Sadece options varsa ekle
          if (options.isNotEmpty) {
            normalized.add({'name': name, 'options': options});
          }
        } catch (_) {
          // Skip unknown shapes gracefully
        }
      }
    }

    // Eğer hiç attribute yoksa, hiçbir şey gösterme
    if (normalized.isEmpty) {
      return const SizedBox.shrink();
    }

    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final attr in normalized) ...[
          OsmeaComponents.text(
            ((attr['name'] as String?) ?? '').capitalizeFirst(),
            textStyle: OsmeaTextStyle.bodySmall(
              context,
            ).copyWith(color: OsmeaColors.pewter, fontWeight: FontWeight.w500),
          ),
          OsmeaComponents.sizedBox(height: context.spacing6),
          Wrap(
            spacing: context.spacing8,
            runSpacing: context.spacing8,
            children: [
              for (final opt in (attr['options'] as List<String>)) ...[
                Builder(
                  builder: (context) {
                    final attrName = (attr['name'] as String?) ?? '';
                    final isSelected =
                        state.selectedAttributes[attrName] == opt;
                    final isHighlighted =
                        state.highlightedAttributes.contains(attrName) &&
                        !isSelected;

                    // Check if this option is available based on other selected attributes
                    final isAvailable = _isOptionAvailable(
                      attrName,
                      opt,
                      state.product,
                      state.selectedAttributes,
                    );

                    // Determine border color - red if highlighted, otherwise normal
                    final borderColor = isHighlighted
                        ? OsmeaColors.red
                        : (isSelected
                              ? OsmeaColors.nordicBlue
                              : (isAvailable
                                    ? OsmeaColors.silver.withValues(alpha: 0.4)
                                    : OsmeaColors.grayMaterial[300]!));

                    // Determine background color - red tint if highlighted
                    final backgroundColor = isHighlighted
                        ? OsmeaColors.red.withValues(alpha: 0.1)
                        : (isSelected
                              ? OsmeaColors.nordicBlue.withValues(alpha: 0.12)
                              : Colors.transparent);

                    return ChoiceChip(
                      label: Text(opt.capitalizeFirst()),
                      selected: isSelected,
                      onSelected: (isAvailable || isSelected)
                          ? (_) {
                              // If already selected, clear the selection; otherwise set it
                              if (isSelected) {
                                viewModel.clearSelectedAttribute(attrName);
                              } else {
                                viewModel.setSelectedAttribute(attrName, opt);
                              }
                            }
                          : null,
                      selectedColor: OsmeaColors.nordicBlue.withValues(
                        alpha: 0.12,
                      ),
                      backgroundColor: backgroundColor,
                      disabledColor: OsmeaColors.grayMaterial[100],
                      shape: StadiumBorder(
                        side: BorderSide(
                          color: borderColor,
                          width: isHighlighted ? 2.0 : 1.0,
                        ),
                      ),
                      labelStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                        color: isHighlighted
                            ? OsmeaColors.red
                            : (isAvailable
                                  ? OsmeaColors.thunder
                                  : OsmeaColors.pewter.withValues(alpha: 0.5)),
                        fontWeight: isHighlighted
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
          OsmeaComponents.sizedBox(height: context.spacing16),
        ],
      ],
    );
  }

  /// Parses color from option value (hex code or color name)
  /// Checks if an attribute option is available based on selected attributes and variations
  /// All attributes (including color) are filtered the same way based on variations
  /// If no attributes are selected, all options are available
  bool _isOptionAvailable(
    String attributeName,
    String optionValue,
    product_models.RetrieveProductResponseModel product,
    Map<String, String> selectedAttributes,
  ) {
    // If no variations, all options are available
    if (product.variations == null || product.variations!.isEmpty) {
      return true;
    }

    // Parse variations
    final List<Map<String, dynamic>> variations = [];
    for (final variation in product.variations!) {
      if (variation is Map<String, dynamic>) {
        variations.add(variation);
      }
    }

    if (variations.isEmpty) {
      return true;
    }

    // Build comprehensive attribute mapping (name -> taxonomy, taxonomy -> name)
    final Map<String, String> attributeNameToTaxonomy = {};
    final Map<String, String> taxonomyToName = {};
    if (product.attributes != null) {
      for (final attr in product.attributes!) {
        if (attr is Map<String, dynamic>) {
          final name = (attr['name'] ?? attr['label'] ?? '').toString().trim();
          final taxonomy = (attr['taxonomy'] ?? attr['id'] ?? '')
              .toString()
              .trim();
          if (name.isNotEmpty) {
            attributeNameToTaxonomy[name] = taxonomy.isNotEmpty
                ? taxonomy
                : name;
            if (taxonomy.isNotEmpty) {
              taxonomyToName[taxonomy] = name;
            }
          }
        }
      }
    }

    // Helper function to normalize strings for comparison
    String normalize(String str) => str.trim().toLowerCase();

    // Helper function to check if attribute names match
    bool attributeNamesMatch(String name1, String name2) {
      final normalized1 = normalize(name1);
      final normalized2 = normalize(name2);

      // Direct match
      if (normalized1 == normalized2) return true;

      // Check via taxonomy mapping
      final taxonomy1 = attributeNameToTaxonomy[name1] ?? '';
      final taxonomy2 = attributeNameToTaxonomy[name2] ?? '';
      if (taxonomy1.isNotEmpty &&
          taxonomy2.isNotEmpty &&
          normalize(taxonomy1) == normalize(taxonomy2)) {
        return true;
      }

      // Check if name1 matches taxonomy2 or vice versa
      if (taxonomy2.isNotEmpty && normalize(name1) == normalize(taxonomy2))
        return true;
      if (taxonomy1.isNotEmpty && normalize(name2) == normalize(taxonomy1))
        return true;

      return false;
    }

    // Helper function to check if values match (case-insensitive, trimmed)
    bool valuesMatch(String value1, String value2) {
      return normalize(value1) == normalize(value2);
    }

    // If no attributes are selected yet, all options are available (tüm varyasyonlar gelmeli)
    if (selectedAttributes.isEmpty) {
      return true;
    }

    // Create a test selection WITHOUT the attribute being checked
    // We filter based on OTHER selected attributes, then check if this option exists in matching variations
    final testSelection = Map<String, String>.from(selectedAttributes);
    testSelection.remove(attributeName); // Remove the attribute being checked

    // If no other attributes are selected, check if this option exists in any variation
    if (testSelection.isEmpty) {
      for (final variation in variations) {
        final variationAttrs = variation['attributes'] as List<dynamic>?;
        if (variationAttrs == null) continue;

        for (final varAttr in variationAttrs) {
          if (varAttr is Map<String, dynamic>) {
            final varAttrName = (varAttr['name'] ?? varAttr['id'] ?? '')
                .toString();
            final varAttrValue = (varAttr['value'] ?? '').toString();

            // Check if this variation has the option value for the attribute being checked
            if (attributeNamesMatch(varAttrName, attributeName) &&
                valuesMatch(varAttrValue, optionValue)) {
              return true; // Found a variation with this option
            }
          }
        }
      }
      return false; // No variation found with this option
    }

    // Check if any variation matches other selected attributes AND contains this option
    for (final variation in variations) {
      final variationAttrs = variation['attributes'] as List<dynamic>?;
      if (variationAttrs == null) continue;

      // First check if variation matches other selected attributes
      bool matchesOtherAttributes = true;
      for (final entry in testSelection.entries) {
        final selectedAttrName = entry.key;
        final selectedAttrValue = entry.value;

        bool foundMatch = false;
        for (final varAttr in variationAttrs) {
          if (varAttr is Map<String, dynamic>) {
            final varAttrName = (varAttr['name'] ?? varAttr['id'] ?? '')
                .toString();
            final varAttrValue = (varAttr['value'] ?? '').toString();

            // Match by name or taxonomy with case-insensitive comparison
            if (attributeNamesMatch(varAttrName, selectedAttrName) &&
                valuesMatch(varAttrValue, selectedAttrValue)) {
              foundMatch = true;
              break;
            }
          }
        }

        if (!foundMatch) {
          matchesOtherAttributes = false;
          break;
        }
      }

      // If variation matches other attributes, check if it also has this option
      if (matchesOtherAttributes) {
        for (final varAttr in variationAttrs) {
          if (varAttr is Map<String, dynamic>) {
            final varAttrName = (varAttr['name'] ?? varAttr['id'] ?? '')
                .toString();
            final varAttrValue = (varAttr['value'] ?? '').toString();

            // Check if this variation has the option value for the attribute being checked
            if (attributeNamesMatch(varAttrName, attributeName) &&
                valuesMatch(varAttrValue, optionValue)) {
              return true; // Found a matching variation
            }
          }
        }
      }
    }

    return false; // No matching variation found
  }

  /// Builds reviews section
  Widget _buildReviewsSection(
    BuildContext context,
    ProductDetailViewModel viewModel,
    ProductDetailLoadedState state,
  ) {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.text(
          state.reviews.isEmpty
              ? 'Reviews'
              : 'Reviews (${state.reviews.length})',
          textStyle: OsmeaTextStyle.titleSmall(context).copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0,
            color: OsmeaColors.thunder.withValues(alpha: 0.8),
          ),
        ),
        OsmeaComponents.sizedBox(height: context.spacing8),
        if (state.reviews.isEmpty)
          _buildEmptyReviewsState(context)
        else ...[
          ...state.reviews.map((review) => _buildReviewItem(context, review)),
          OsmeaComponents.sizedBox(height: context.spacing16),
        ],
      ],
    );
  }

  /// Builds empty reviews state with icon
  Widget _buildEmptyReviewsState(BuildContext context) {
    return OsmeaComponents.container(
      margin: EdgeInsets.only(bottom: context.spacing16),
      padding: EdgeInsets.symmetric(
        horizontal: context.spacing16,
        vertical: context.spacing24,
      ),
      decoration: BoxDecoration(
        color: OsmeaColors.grayMaterial[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: OsmeaColors.grayMaterial[200]!, width: 1),
      ),
      child: OsmeaComponents.center(
        child: OsmeaComponents.column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.reviews_outlined,
              size: context.iconSizeHigh,
              color: OsmeaColors.pewter.withValues(alpha: 0.5),
            ),
            OsmeaComponents.sizedBox(height: context.spacing12),
            OsmeaComponents.text(
              'No reviews yet',
              textStyle: OsmeaTextStyle.bodyLarge(context).copyWith(
                fontWeight: FontWeight.w500,
                color: OsmeaColors.thunder.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            OsmeaComponents.sizedBox(height: context.spacing4),
            OsmeaComponents.text(
              'No reviews have been made for this product yet.',
              textStyle: OsmeaTextStyle.bodySmall(
                context,
              ).copyWith(color: OsmeaColors.pewter),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Builds individual review item
  Widget _buildReviewItem(
    BuildContext context,
    ListProductReviewsResponseModel review,
  ) {
    return OsmeaComponents.container(
      margin: EdgeInsets.only(bottom: context.spacing12),
      padding: EdgeInsets.all(context.spacing12),
      decoration: BoxDecoration(
        color: OsmeaColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: OsmeaColors.grayMaterial[200]!, width: 1),
      ),
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Reviewer info and rating
          OsmeaComponents.row(
            children: [
              // Avatar
              if (review.reviewerAvatarUrls?.the48 != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    review.reviewerAvatarUrls!.the48!,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: OsmeaColors.grayMaterial[200],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          Icons.person,
                          color: OsmeaColors.pewter,
                          size: 20,
                        ),
                      );
                    },
                  ),
                )
              else
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: OsmeaColors.grayMaterial[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.person,
                    color: OsmeaColors.pewter,
                    size: 20,
                  ),
                ),
              OsmeaComponents.sizedBox(width: context.spacing12),
              // Reviewer name and rating
              OsmeaComponents.expanded(
                child: OsmeaComponents.column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OsmeaComponents.text(
                      review.reviewer ?? 'Anonymous',
                      textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                        fontWeight: FontWeight.w600,
                        color: OsmeaColors.thunder,
                      ),
                    ),
                    if (review.rating != null) ...[
                      OsmeaComponents.sizedBox(height: 4),
                      OsmeaComponents.row(
                        children: [
                          ...List.generate(5, (index) {
                            return Icon(
                              index < (review.rating ?? 0)
                                  ? Icons.star
                                  : Icons.star_border,
                              color: OsmeaColors.nordicBlue,
                              size: 16,
                            );
                          }),
                          OsmeaComponents.sizedBox(width: 8),
                          OsmeaComponents.text(
                            '${review.rating}/5',
                            textStyle: OsmeaTextStyle.bodySmall(
                              context,
                            ).copyWith(color: OsmeaColors.pewter),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              // Verified badge
              if (review.verified == true)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.spacing8,
                    vertical: context.spacing4,
                  ),
                  decoration: BoxDecoration(
                    color: OsmeaColors.nordicBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: OsmeaComponents.text(
                    'Verified',
                    textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                      color: OsmeaColors.nordicBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          OsmeaComponents.sizedBox(height: context.spacing8),
          // Review text (HTML formatted)
          if (review.review != null && review.review!.isNotEmpty)
            WebViewerHelper.html(review.review!),
          // Review date
          if (review.formattedDateCreated != null ||
              review.dateCreated != null) ...[
            OsmeaComponents.sizedBox(height: context.spacing8),
            OsmeaComponents.text(
              review.formattedDateCreated ?? review.dateCreated ?? '',
              textStyle: OsmeaTextStyle.bodySmall(
                context,
              ).copyWith(color: OsmeaColors.pewter),
            ),
          ],
        ],
      ),
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
            context.go('/cart', extra: {'cartToken': cartToken});
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
