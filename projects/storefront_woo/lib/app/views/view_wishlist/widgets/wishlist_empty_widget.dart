import 'package:core/core.dart';
import 'package:flutter/material.dart';

class WishlistEmptyWidget extends StatelessWidget {
  const WishlistEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.center(
      child: OsmeaComponents.column(
        mainAxisSize: min,
        children: [
          OsmeaComponents.container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: OsmeaColors.pewter.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.favorite_border,
              size: context.iconSizeHigh,
              color: OsmeaColors.pewter,
            ),
          ),
          OsmeaComponents.sizedBox(height: context.spacing16),
          OsmeaComponents.text(
            'No Saved Items!',
            textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
              fontWeight: FontWeight.w700,
              color: OsmeaColors.thunder,
            ),
            textAlign: TextAlign.center,
          ),
          OsmeaComponents.sizedBox(height: context.spacing8),
          OsmeaComponents.text(
            "You don't have any saved items.\nGo to home and add some.",
            textStyle: OsmeaTextStyle.bodyMedium(
              context,
            ).copyWith(color: OsmeaColors.pewter),
            textAlign: TextAlign.center,
          ),
          OsmeaComponents.sizedBox(height: context.spacing16),
          OsmeaComponents.button(
            text: 'Browse products',
            variant: ButtonVariant.primary,
            onPressed: () => Navigator.of(context).maybePop(),
          ),
        ],
      ),
    );
  }
}



