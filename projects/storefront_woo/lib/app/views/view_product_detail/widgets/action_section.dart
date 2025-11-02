import 'package:core/core.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.row(
      children: [
        if (showWishlistAndShare)
          OsmeaComponents.iconButton(
            icon: Icon(
              isInWishlist ? Icons.favorite : Icons.favorite_outline,
              color: isInWishlist
                  ? OsmeaColors.red
                  : OsmeaColors.pewter.withOpacity(0.7),
            ),
            size: ButtonSize.small,
            variant: ButtonVariant.ghost,
            backgroundColor: isInWishlist
                ? OsmeaColors.red.withOpacity(0.08)
                : OsmeaColors.pewter.withOpacity(0.06),
            onPressed: () {
              final bool wasSaved = isInWishlist;
              onToggleWishlist();

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
                        color: wasSaved
                            ? OsmeaColors.red
                            : OsmeaColors.nordicBlue,
                      ),
                      OsmeaComponents.sizedBox(width: context.spacing10),
                      OsmeaComponents.expanded(
                        child: OsmeaComponents.column(
                          crossAxisAlignment: context.crossStart,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            OsmeaComponents.text(
                              wasSaved
                                  ? 'Removed from favorites'
                                  : 'Added to favorites',
                              textStyle: OsmeaTextStyle.titleSmall(
                                context,
                              ).copyWith(color: OsmeaColors.thunder),
                            ),
                            OsmeaComponents.text(
                              wasSaved
                                  ? 'Item was removed from your favorites'
                                  : 'Item was added to your favorites',
                              textStyle: OsmeaTextStyle.bodySmall(
                                context,
                              ).copyWith(color: OsmeaColors.pewter),
                            ),
                          ],
                        ),
                      ),
                      OsmeaComponents.sizedBox(width: context.spacing10),
                      OsmeaComponents.button(
                        text: 'Undo',
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
            icon: const Icon(Icons.share_outlined),
            size: ButtonSize.small,
            variant: ButtonVariant.ghost,
            backgroundColor: OsmeaColors.pewter.withOpacity(0.06),
            onPressed: onShare ?? () {},
          ),
        if (showWishlistAndShare)
          OsmeaComponents.sizedBox(width: context.spacing8),
        // Counter always visible - shows cart quantity if in cart, otherwise 1
        OsmeaComponents.counter(
          initialValue: selectedQuantity,
          minValue: 1,
          maxValue: 99,
          // Use default counter look for consistency
          size: CounterSize.medium,
          variant: CounterVariant.filled,
          onChanged: onUpdateQuantity,
        ),
        OsmeaComponents.sizedBox(width: context.spacing8),
        // Add to Cart button always active - adds to cart or updates quantity
        OsmeaComponents.expanded(
          child: OsmeaComponents.sizedBox(
            // Use default button without extra borders or overrides
            child: OsmeaComponents.button(
              onPressed: () async {
                await onAddToCart();
                // Popup will be shown after successful add via callback
                if (onAddSuccessNavigateToCart != null) {
                  onAddSuccessNavigateToCart!();
                }
              },
              text: 'Add to Cart',
            ),
          ),
        ),
      ],
    );
  }
}
