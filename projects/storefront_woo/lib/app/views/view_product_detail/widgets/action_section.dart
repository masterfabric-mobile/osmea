import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:storefront_woo/gen/translations.g.dart';

// Replaced custom quantity selector with OsmeaCounter

class ActionSection extends StatelessWidget {
  final bool isInWishlist;
  final VoidCallback onToggleWishlist;

  final bool isInCart;
  final Future<void> Function() onAddToCart;

  final int selectedQuantity;
  final void Function(int) onUpdateQuantity;

  final VoidCallback? onShare;
  final VoidCallback? onAddSuccessNavigateToCart; // optional override
  final bool showWishlistAndShare;

  const ActionSection({
    super.key,
    required this.isInWishlist,
    required this.onToggleWishlist,
    required this.isInCart,
    required this.onAddToCart,
    required this.selectedQuantity,
    required this.onUpdateQuantity,
    this.onShare,
    this.onAddSuccessNavigateToCart,
    this.showWishlistAndShare = true,
  });

  /// Get color from config
  Color _getColorFromConfig(String key, Color fallback) {
    try {
      final configHelper = AssetConfigHelper();
      final colorString = configHelper.getString('product_detail_view.action_section.$key');
      if (colorString.isNotEmpty && colorString.startsWith('#')) {
        final hexString = colorString.substring(1);
        if (hexString.length == 6) {
          return Color(int.parse('FF$hexString', radix: 16));
        } else if (hexString.length == 8) {
          return Color(int.parse(hexString, radix: 16));
        }
      }
    } catch (e) {
      debugPrint('⚠️ Failed to load action_section color $key: $e');
    }
    return fallback;
  }

  /// Get double from config
  double _getDoubleFromConfig(String key, double fallback) {
    try {
      final configHelper = AssetConfigHelper();
      return configHelper.getDouble('product_detail_view.action_section.$key', fallback);
    } catch (e) {
      debugPrint('⚠️ Failed to load action_section double $key: $e');
    }
    return fallback;
  }

  /// Get popup color from config
  Color _getPopupColorFromConfig(String key, Color fallback) {
    try {
      final configHelper = AssetConfigHelper();
      final colorString = configHelper.getString('dialog_popup_configuration.$key');
      if (colorString.isNotEmpty && colorString.startsWith('#')) {
        final hexString = colorString.substring(1);
        if (hexString.length == 6) {
          return Color(int.parse('FF$hexString', radix: 16));
        } else if (hexString.length == 8) {
          return Color(int.parse(hexString, radix: 16));
        }
      }
    } catch (e) {
      debugPrint('⚠️ Failed to load popup color $key: $e');
    }
    return fallback;
  }

  @override
  Widget build(BuildContext context) {
    final wishlistIconColor = _getColorFromConfig('wishlistIconColor', OsmeaColors.black);
    final wishlistUnselectedColor = _getColorFromConfig('wishlistUnselectedColor', OsmeaColors.grayMaterial[400]!);
    final shareIconColor = _getColorFromConfig('shareIconColor', OsmeaColors.black);
    return OsmeaComponents.row(
      children: [
        if (showWishlistAndShare)
          OsmeaComponents.iconButton(
            icon: Icon(
              isInWishlist ? Icons.favorite : Icons.favorite_outline,
              color: isInWishlist
                  ? wishlistIconColor
                  : wishlistUnselectedColor,
            ),
            size: ButtonSize.small,
            variant: ButtonVariant.ghost,
            backgroundColor: isInWishlist
                ? wishlistIconColor.withOpacity(context.alpha10)
                : OsmeaColors.white,
            onPressed: () {
              final bool wasSaved = isInWishlist;
              onToggleWishlist();

              // Get popup colors from config
              final popupTitleColor = _getPopupColorFromConfig('popup.titleColor', const Color(0xFF1976D2));
              final popupSubtitleColor = _getPopupColorFromConfig('popup.subtitleColor', OsmeaColors.grayMaterial[400]!);
              final popupIconColor = _getPopupColorFromConfig('icons.primaryColor', wishlistIconColor);
              
              // Use OsmeaComponents popup for feedback with Undo support
              OsmeaComponents.showPopup(
                context: context,
                variant: PopupVariant.dialog,
                // Compact content
                child: OsmeaComponents.container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.spacing12,
                    vertical: context.spacing10,
                  ),
                  child: OsmeaComponents.row(
                    crossAxisAlignment: context.crossCenter,
                    children: [
                      Icon(
                        wasSaved ? Icons.favorite_border : Icons.favorite,
                        color: popupIconColor,
                      ),
                      OsmeaComponents.sizedBox(width: context.spacing10),
                      OsmeaComponents.expanded(
                        child: OsmeaComponents.column(
                          crossAxisAlignment: context.crossStart,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            OsmeaComponents.text(
                              wasSaved
                                  ? context.t.productDetailView.wishlist.removed.title
                                  : context.t.productDetailView.wishlist.added.title,
                              textStyle: OsmeaTextStyle.titleSmall(
                                context,
                              ).copyWith(color: popupTitleColor),
                            ),
                            OsmeaComponents.text(
                              wasSaved
                                  ? context.t.productDetailView.wishlist.removed.message
                                  : context.t.productDetailView.wishlist.added.message,
                              textStyle: OsmeaTextStyle.bodySmall(
                                context,
                              ).copyWith(color: popupSubtitleColor),
                            ),
                          ],
                        ),
                      ),
                      OsmeaComponents.sizedBox(width: context.spacing10),
                      OsmeaComponents.button(
                        text: context.t.productDetailView.wishlist.undo,
                        variant: ButtonVariant.ghost,
                        onPressed: () {
                          Navigator.of(context).maybePop();
                          onToggleWishlist();
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        if (showWishlistAndShare)
          OsmeaComponents.sizedBox(width: context.spacing8),
        if (showWishlistAndShare)
          OsmeaComponents.iconButton(
            icon: Icon(Icons.share_outlined, color: shareIconColor),
            size: ButtonSize.small,
            variant: ButtonVariant.ghost,
            backgroundColor: OsmeaColors.white,
            onPressed: onShare ?? () {},
          ),
        if (showWishlistAndShare)
          OsmeaComponents.sizedBox(width: context.spacing8),
        // Counter always visible - shows cart quantity if in cart, otherwise 1
        Builder(
          builder: (context) {
            final counterBgColor = _getColorFromConfig('counter.backgroundColor', OsmeaColors.white);
            final counterBorderColor = _getColorFromConfig('counter.borderColor', OsmeaColors.silver);
            final counterButtonColor = _getColorFromConfig('counter.buttonColor', OsmeaColors.black);
            final counterButtonIconColor = _getColorFromConfig('counter.buttonIconColor', OsmeaColors.white);
            final counterValueTextColor = _getColorFromConfig('counter.valueTextColor', OsmeaColors.black);
            final counterBorderRadius = _getDoubleFromConfig('counter.borderRadius', 8.0);

            return OsmeaComponents.counter(
              initialValue: selectedQuantity,
              minValue: 1,
              maxValue: 99,
              size: CounterSize.medium,
              variant: CounterVariant.filled,
              backgroundColor: counterBgColor,
              borderColor: counterBorderColor,
              buttonColor: counterButtonColor,
              borderRadius: BorderRadius.circular(counterBorderRadius),
              valueTextStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                color: counterValueTextColor,
              ),
              incrementIcon: Icon(
                Icons.add,
                color: counterButtonIconColor,
              ),
              decrementIcon: Icon(
                Icons.remove,
                color: counterButtonIconColor,
              ),
              onChanged: onUpdateQuantity,
            );
          },
        ),
        OsmeaComponents.sizedBox(width: context.spacing8),
        // Add to Cart button always active - adds to cart or updates quantity
        OsmeaComponents.expanded(
          child: OsmeaComponents.sizedBox(
            child: OsmeaComponents.button(
              onPressed: () async {
                await onAddToCart();
                // Popup will be shown after successful add via callback
                if (onAddSuccessNavigateToCart != null) {
                  onAddSuccessNavigateToCart!();
                }
              },
              text: context.t.productDetailView.addToCart.button,
              backgroundColor: _getColorFromConfig('addToCartButton.backgroundColor', OsmeaColors.black),
              textColor: _getColorFromConfig('addToCartButton.textColor', OsmeaColors.white),
              borderColor: _getColorFromConfig('addToCartButton.borderColor', OsmeaColors.black),
              borderRadius: _getDoubleFromConfig('addToCartButton.borderRadius', 8.0),
            ),
          ),
        ),
      ],
    );
  }
}
