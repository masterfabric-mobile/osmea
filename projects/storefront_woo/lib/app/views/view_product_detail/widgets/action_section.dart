import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:osmea_components/src/components/counter/counter.dart';

// Replaced custom quantity selector with OsmeaCounter

class ActionSection extends StatelessWidget {
  final bool isInWishlist;
  final VoidCallback onToggleWishlist;

  final bool isInCart;
  final VoidCallback onAddToCart;

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
          onPressed: onToggleWishlist,
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
        OsmeaCounter(
          initialValue: selectedQuantity,
          minValue: 1,
          maxValue: 99,
          // Use default counter look for consistency
          size: CounterSize.medium,
          variant: CounterVariant.filled,
          onChanged: onUpdateQuantity,
        ),
        OsmeaComponents.sizedBox(width: context.spacing8),
        OsmeaComponents.expanded(
          child: OsmeaComponents.sizedBox(
            // Use default button without extra borders or overrides
            child: OsmeaComponents.button(
              onPressed: isInCart
                  ? null
                  : () {
                      onAddToCart();
                      if (onAddSuccessNavigateToCart != null) {
                        onAddSuccessNavigateToCart!();
                      }
                    },
              text: isInCart ? 'In Cart' : 'Add to Cart',
            ),
          ),
        ),
      ],
    );
  }
}
