/*
 * ProductCardWidget
 * -----------------
 * Reusable product card widget for displaying products.
 * Uses the same design as home recommended section cards.
 * Used in home view, search view, and other product listings.
 */

import 'package:flutter/material.dart' hide Image;
import 'package:flutter/material.dart' as flutter_material show Image;
import 'package:storefront_supabase/app/models/product.dart';
import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_supabase/app/core/bloc/currency/currency_cubit.dart';
import 'package:storefront_supabase/app/utils/price_helper.dart';

enum ProductCardBadge { flashSale, weekStar }

/// Product card widget - matches home recommended section design
class ProductCardWidget extends StatefulWidget {
  final Product product;
  final VoidCallback onWishlistTap;
  final VoidCallback onTap;
  final Future<void> Function()? onAddToCart;
  final bool isSaved; // Wishlist status passed from parent
  final Set<ProductCardBadge> badges;

  /// Controls whether the "Week Star" badge is allowed to render in this context.
  final bool allowWeekStarBadge;

  const ProductCardWidget({
    super.key,
    required this.product,
    required this.onWishlistTap,
    required this.onTap,
    this.onAddToCart,
    this.isSaved = false,
    this.badges = const {},
    this.allowWeekStarBadge = false,
  });

  @override
  State<ProductCardWidget> createState() => _ProductCardWidgetState();
}

class _ProductCardWidgetState extends State<ProductCardWidget> {
  PageController? _pageController;
  int _currentImageIndex = 0;
  bool _isAddingToCart = false;
  late bool _localIsSaved; // Local state for immediate UI feedback

  @override
  void initState() {
    super.initState();
    _localIsSaved = widget.isSaved; // Initialize from prop
    final imageCount = widget.product.imageUrls.length;
    if (imageCount > 1) {
      _pageController = PageController();
    }
  }

  @override
  void didUpdateWidget(covariant ProductCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sync local state with prop when it changes from parent
    if (oldWidget.isSaved != widget.isSaved) {
      _localIsSaved = widget.isSaved;
    }
    
    final oldCount = oldWidget.product.imageUrls.length;
    final newCount = widget.product.imageUrls.length;

    if (oldCount <= 1 && newCount > 1) {
      _pageController ??= PageController();
    } else if (oldCount > 1 && newCount <= 1) {
      _pageController?.dispose();
      _pageController = null;
      _currentImageIndex = 0;
    } else if (_currentImageIndex >= newCount && newCount > 0) {
      _currentImageIndex = 0;
    }
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final configHelper = AssetConfigHelper();
    final bool hasSale = product.hasDiscount;

    int? discountPct = product.discountPercentage?.round();

    // Week Star badge: ONLY products defined in app config.
    final weekStarConfig =
        configHelper.getObject('product_card.badges.week_star') ?? const {};
    final weekStarIds =
        (weekStarConfig['product_ids'] as List<dynamic>?) ?? const [];
    // Product IDs are strings in Supabase
    final weekStarIdSet = weekStarIds
        .map((e) => e.toString())
        .where((id) => id.isNotEmpty)
        .toSet();
    final shouldShowWeekStar =
        widget.allowWeekStarBadge &&
        weekStarIdSet.isNotEmpty &&
        weekStarIdSet.contains(product.id);

    final flashEnabled = configHelper.getBool(
      'product_card.badges.flash_sale.enabled',
      true,
    );
    final flashAuto = configHelper.getBool(
      'product_card.badges.flash_sale.auto',
      true,
    );
    final flashMinDiscount = configHelper.getInt(
      'product_card.badges.flash_sale.min_discount_percent',
      0,
    );
    final flashLabel = configHelper.getString(
      'product_card.badges.flash_sale.label',
      'FLASH',
    );
    // Flash sale badge logic: ONLY when discount percent >= configured threshold.
    final meetsMinDiscount =
        discountPct != null && (discountPct >= flashMinDiscount);
    final flashFromAuto =
        flashEnabled &&
        flashAuto &&
        hasSale &&
        meetsMinDiscount;
    // If a product is both Week Star and Flash, only show Week Star.
    final shouldShowFlashSale =
        flashEnabled && flashFromAuto && !shouldShowWeekStar;

    final imageHeight = context.height160 + context.spacing10;

    return AnimatedCard(
      onTap: widget.onTap,
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Image container
          Container(
            height: imageHeight,
            decoration: BoxDecoration(
              color: OsmeaColors.grayMaterial[50],
              borderRadius: context.borderRadiusNormal,
            ),
            child: Stack(
              children: [
                // Product image with Hero animation
                ClipRRect(
                  borderRadius: context.borderRadiusNormal,
                  child: _buildImageArea(context, product),
                ),
                // Badges - top left (week star / flash sale / discount)
                if (shouldShowWeekStar ||
                    shouldShowFlashSale ||
                    (hasSale && discountPct != null))
                  Positioned(
                    top: context.spacing8,
                    left: context.spacing8,
                    child: OsmeaComponents.column(
                      crossAxisAlignment: context.crossStart,
                      children: [
                        if (shouldShowWeekStar)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: context.spacing10,
                              vertical: context.spacing4,
                            ),
                            decoration: BoxDecoration(
                              color: OsmeaColors.black,
                              borderRadius: BorderRadius.circular(
                                context.spacing6,
                              ),
                              border: Border.all(
                                color: OsmeaColors.white,
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: OsmeaColors.black.withValues(
                                    alpha: 0.12,
                                  ),
                                  blurRadius: context.blurRadius8,
                                  offset: context.offsetVerticalCustom(
                                    context.spacing2,
                                  ),
                                ),
                              ],
                            ),
                            child: OsmeaComponents.row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.star_rounded,
                                  size: context.iconSizeExtraSmall,
                                  color: OsmeaColors.white,
                                ),
                                OsmeaComponents.sizedBox(
                                  width: context.spacing4,
                                ),
                                OsmeaComponents.text(
                                  'WEEK STAR',
                                  textStyle:
                                      OsmeaTextStyle.bodySmall(context).copyWith(
                                        color: OsmeaColors.white,
                                        fontSize:
                                            context.fontSizeExtraSmall * 0.82,
                                        fontWeight: FontWeight.w800,
                                        height: 1.0,
                                        letterSpacing: 0.5,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        if (shouldShowWeekStar)
                          OsmeaComponents.sizedBox(height: context.spacing4),
                        if (shouldShowFlashSale)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: context.spacing10,
                              vertical: context.spacing4,
                            ),
                            decoration: BoxDecoration(
                              color: OsmeaColors.white,
                              borderRadius: BorderRadius.circular(
                                context.spacing6,
                              ),
                              border: Border.all(
                                color: OsmeaColors.black,
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: OsmeaColors.black.withValues(
                                    alpha: 0.08,
                                  ),
                                  blurRadius: context.blurRadius8,
                                  offset: context.offsetVerticalCustom(
                                    context.spacing2,
                                  ),
                                ),
                              ],
                            ),
                            child: OsmeaComponents.row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.flash_on_rounded,
                                  size: context.iconSizeExtraSmall,
                                  color: OsmeaColors.black,
                                ),
                                OsmeaComponents.sizedBox(
                                  width: context.spacing4,
                                ),
                                OsmeaComponents.text(
                                  flashLabel,
                                  textStyle:
                                      OsmeaTextStyle.bodySmall(context).copyWith(
                                        color: OsmeaColors.black,
                                        fontSize:
                                            context.fontSizeExtraSmall * 0.82,
                                        fontWeight: FontWeight.w900,
                                        height: 1.0,
                                        letterSpacing: 0.5,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        if (shouldShowFlashSale)
                          OsmeaComponents.sizedBox(height: context.spacing4),
                        if (hasSale && discountPct != null)
                          OsmeaComponents.container(
                            padding: EdgeInsets.symmetric(
                              horizontal: context.spacing6,
                              vertical: context.spacing2,
                            ),
                            decoration: BoxDecoration(
                              color: _getDiscountBadgeBackgroundColor(context),
                              borderRadius: BorderRadius.circular(
                                context.spacing6,
                              ),
                            ),
                            child: OsmeaComponents.text(
                              '$discountPct% OFF',
                              textStyle: OsmeaTextStyle.bodySmall(context)
                                  .copyWith(
                                    color: _getDiscountBadgeTextColor(context),
                                    fontSize:
                                        context.fontSizeExtraSmall *
                                        context.textScaleFactor,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ),
                      ],
                    ),
                  ),
                // Wishlist button - top right with animation
                Positioned(
                  top: context.spacing8,
                  right: context.spacing8,
                  child: AnimatedButton(
                    onPressed: () {
                      setState(() {
                        _localIsSaved = !_localIsSaved;
                      });
                      widget.onWishlistTap();
                    },
                    child: OsmeaComponents.container(
                      width: context.iconSizeNormal * 1.25,
                      height: context.iconSizeNormal * 1.25,
                      decoration: BoxDecoration(
                        color: OsmeaColors.white,
                        borderRadius: BorderRadius.circular(context.spacing24),
                        border: Border.all(
                          color: OsmeaColors.silver,
                          width: context.borderWidth,
                        ),
                      ),
                      child: Icon(
                        _localIsSaved ? Icons.favorite : Icons.favorite_border,
                        size: context.iconSizeExtraSmall,
                        color: _localIsSaved
                            ? _getWishlistIconSavedColor(context)
                            : _getWishlistIconUnsavedColor(context),
                      ),
                    ),
                  ),
                ),

                // Multi-image indicator (bottom-center)
                if (product.imageUrls.length > 1)
                  Positioned(
                    bottom: context.spacing8,
                    left: 0,
                    right: 0,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: OsmeaComponents.container(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.spacing8,
                          vertical: context.spacing4,
                        ),
                        decoration: BoxDecoration(
                          color: OsmeaColors.black.withValues(alpha: 0.55),
                          borderRadius: BorderRadius.circular(
                            context.spacing24,
                          ),
                        ),
                        child: OsmeaComponents.row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(
                            product.imageUrls.length,
                            (index) => OsmeaComponents.container(
                              width: context.spacing6,
                              height: context.spacing6,
                              margin: EdgeInsets.symmetric(
                                horizontal: context.spacing2,
                              ),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: index == _currentImageIndex
                                    ? OsmeaColors.white
                                    : OsmeaColors.white.withValues(alpha: 0.4),
                              ),
                            ),
                          ),
                        ),
                      ),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Price row (top) + add-to-cart
                BlocBuilder<CurrencyCubit, String>(
                  builder: (context, currency) {
                    return hasSale
                        ? OsmeaComponents.row(
                            crossAxisAlignment: context.crossCenter,
                            children: [
                              OsmeaComponents.expanded(
                                child: OsmeaComponents.row(
                                  children: [
                                    Flexible(
                                      child: OsmeaComponents.text(
                                        PriceHelper.format(
                                            product.salePrice!,
                                            currency,
                                            Localizations.localeOf(context).toString()),
                                        textStyle: OsmeaTextStyle.titleSmall(context)
                                            .copyWith(
                                              fontSize:
                                                  context.fontSizeExtraSmallMedium *
                                                  context.textScaleFactor,
                                              fontWeight: FontWeight.w800,
                                              color: _getSalePriceColor(context),
                                            ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    OsmeaComponents.sizedBox(width: context.spacing6),
                                    Flexible(
                                      child: OsmeaComponents.text(
                                        PriceHelper.format(
                                            product.price,
                                            currency,
                                            Localizations.localeOf(context).toString()),
                                        textStyle: OsmeaTextStyle.bodySmall(context)
                                            .copyWith(
                                              fontSize:
                                                  context.fontSizeSmall *
                                                  context.textScaleFactor,
                                              color: OsmeaColors.pewter,
                                              decoration: TextDecoration.lineThrough,
                                            ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (widget.onAddToCart != null) ...[
                                OsmeaComponents.sizedBox(width: context.spacing8),
                                _buildAddToCartButton(context),
                              ],
                            ],
                          )
                        : OsmeaComponents.row(
                            crossAxisAlignment: context.crossCenter,
                            children: [
                              OsmeaComponents.expanded(
                                child: OsmeaComponents.text(
                                  PriceHelper.format(
                                      product.price,
                                      currency,
                                      Localizations.localeOf(context).toString()),
                                  textStyle: OsmeaTextStyle.titleSmall(context)
                                      .copyWith(
                                        fontSize:
                                            context.fontSizeExtraSmallMedium *
                                            context.textScaleFactor,
                                        fontWeight: FontWeight.w800,
                                        color: _getRegularPriceColor(context),
                                      ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (widget.onAddToCart != null) ...[
                                OsmeaComponents.sizedBox(width: context.spacing8),
                                _buildAddToCartButton(context),
                              ],
                            ],
                          );
                  },
                ),

                // Tight spacing between price and title
                OsmeaComponents.sizedBox(height: context.spacing2),

                // Product title (below price)
                OsmeaComponents.text(
                  product.name,
                  textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                    fontSize:
                        context.fontSizeExtraSmallMedium *
                        context.textScaleFactor,
                    fontWeight: FontWeight.w600,
                    height: 1.14,
                    color: _getProductNameColor(context),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                // Description (Supabase doesn't usually have shortDesc, skipping or using full desc truncated)
                if (product.description.isNotEmpty)
                  OsmeaComponents.text(
                    _stripHtml(product.description),
                    textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                      fontSize:
                          context.fontSizeExtraSmall * context.textScaleFactor,
                      fontWeight: FontWeight.w400,
                      height: 1.2,
                      color: _getDescriptionColor(context),
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

  Widget _buildAddToCartButton(BuildContext context) {
    return AnimatedButton(
      onPressed: _isAddingToCart
          ? null
          : () async {
              setState(() => _isAddingToCart = true);
              try {
                await widget.onAddToCart?.call();
              } finally {
                if (mounted) {
                  setState(() => _isAddingToCart = false);
                }
              }
            },
      child: OsmeaComponents.container(
        width: context.iconSizeNormal * 1.25,
        height: context.iconSizeNormal * 1.25,
        decoration: BoxDecoration(
          color: OsmeaColors.black,
          borderRadius: BorderRadius.circular(
            context.spacing24,
          ),
        ),
        child: _isAddingToCart
            ? OsmeaComponents.center(
                child: OsmeaComponents.sizedBox(
                  width: context.iconSizeExtraSmall,
                  height: context.iconSizeExtraSmall,
                  child: OsmeaComponents.loading(
                    type: LoadingType.circularFade,
                    size: 24,
                    color: OsmeaColors.white,
                  ),
                ),
              )
            : Icon(
                Icons.add_shopping_cart_outlined,
                size: context.iconSizeExtraSmall,
                color: OsmeaColors.white,
              ),
      ),
    );
  }

  /// Strips HTML tags from description
  String _stripHtml(String input) {
    return input.replaceAll(RegExp(r'<[^>]*>'), '');
  }

  Widget _buildImageArea(
    BuildContext context,
    Product product,
  ) {
    final images = product.imageUrls;
    final imageCount = images.length;

    if (imageCount == 0) {
      return Container(
        width: double.infinity,
        height: context.height160 + context.spacing10,
        color: OsmeaColors.grayMaterial[50],
        alignment: Alignment.center,
        child: Icon(
          Icons.image_outlined,
          color: OsmeaColors.grayMaterial[400],
          size: context.iconSizeExtraHigh,
        ),
      );
    }

    Widget buildNetworkImage(String url) {
      return flutter_material.Image.network(
        url,
        width: double.infinity,
        height: context.height160 + context.spacing10,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: double.infinity,
            height: context.height160 + context.spacing10,
            color: OsmeaColors.grayMaterial[50],
            alignment: Alignment.center,
            child: Icon(
              Icons.image_outlined,
              color: OsmeaColors.grayMaterial[400],
              size: context.iconSizeExtraHigh,
            ),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: double.infinity,
            height: context.height160 + context.spacing10,
            color: OsmeaColors.grayMaterial[50],
            alignment: Alignment.center,
            child: OsmeaComponents.loading(
              type: LoadingType.circularFade,
              size: 36,
              color: _getLoadingIndicatorColor(context),
            ),
          );
        },
      );
    }

    if (imageCount == 1 || _pageController == null) {
      return Hero(
        tag: 'product-image-${product.id}',
        child: buildNetworkImage(images.first),
      );
    }

    return Hero(
      tag: 'product-image-${product.id}',
      child: PageView.builder(
        controller: _pageController,
        itemCount: imageCount,
        onPageChanged: (index) {
          if (!mounted) return;
          setState(() => _currentImageIndex = index);
        },
        itemBuilder: (context, index) {
          return buildNetworkImage(images[index]);
        },
      ),
    );
  }

  // --- Configuration Colors ---

  Color _getLoadingIndicatorColor(BuildContext context) {
    final configHelper = AssetConfigHelper();
    return _parseColor(
      configHelper.getString(
        'product_list_view.product_card.loading_indicator_color',
        '#000000',
      ),
    );
  }

  Color _getDiscountBadgeBackgroundColor(BuildContext context) {
    final configHelper = AssetConfigHelper();
    return _parseColor(
      configHelper.getString(
        'product_list_view.product_card.discount_badge_background',
        '#000000',
      ),
    );
  }

  Color _getDiscountBadgeTextColor(BuildContext context) {
    final configHelper = AssetConfigHelper();
    return _parseColor(
      configHelper.getString(
        'product_list_view.product_card.discount_badge_text_color',
        '#FFFFFF',
      ),
    );
  }

  Color _getWishlistIconSavedColor(BuildContext context) {
    final configHelper = AssetConfigHelper();
    return _parseColor(
      configHelper.getString(
        'product_list_view.product_card.wishlist_icon_saved_color',
        '#000000',
      ),
    );
  }

  Color _getWishlistIconUnsavedColor(BuildContext context) {
    final configHelper = AssetConfigHelper();
    return _parseColor(
      configHelper.getString(
        'product_list_view.product_card.wishlist_icon_unsaved_color',
        '#000000',
      ),
    );
  }

  Color _getSalePriceColor(BuildContext context) {
    final configHelper = AssetConfigHelper();
    return _parseColor(
      configHelper.getString(
        'product_list_view.product_card.sale_price_color',
        '#000000',
      ),
    );
  }

  Color _getRegularPriceColor(BuildContext context) {
    final configHelper = AssetConfigHelper();
    return _parseColor(
      configHelper.getString(
        'product_list_view.product_card.regular_price_color',
        '#000000',
      ),
    );
  }

  Color _getProductNameColor(BuildContext context) {
    final configHelper = AssetConfigHelper();
    return _parseColor(
      configHelper.getString(
        'product_list_view.product_card.product_name_color',
        '#000000',
      ),
    );
  }

  Color _getDescriptionColor(BuildContext context) {
    final configHelper = AssetConfigHelper();
    return _parseColor(
      configHelper.getString(
        'product_list_view.product_card.description_color',
        '#666666',
      ),
    );
  }

  Color _parseColor(String colorString) {
    try {
      String hex = colorString.replaceAll('#', '');
      if (hex.length == 8) {
        final alpha = int.parse(hex.substring(0, 2), radix: 16);
        final red = int.parse(hex.substring(2, 4), radix: 16);
        final green = int.parse(hex.substring(4, 6), radix: 16);
        final blue = int.parse(hex.substring(6, 8), radix: 16);
        return Color.fromARGB(alpha, red, green, blue);
      }
      if (hex.length == 6) {
        final red = int.parse(hex.substring(0, 2), radix: 16);
        final green = int.parse(hex.substring(2, 4), radix: 16);
        final blue = int.parse(hex.substring(4, 6), radix: 16);
        return Color.fromRGBO(red, green, blue, 1.0);
      }
      return OsmeaColors.black;
    } catch (e) {
      debugPrint('⚠️ Error parsing color: $colorString - $e');
      return OsmeaColors.black;
    }
  }
}
