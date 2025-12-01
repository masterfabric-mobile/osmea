import 'package:core/core.dart';
import 'package:flutter/material.dart';

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback? onDecrement;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.container(
      height: context.dynamicHeight(0.055),
      decoration: BoxDecoration(
        color: OsmeaColors.pewter.withOpacity(context.alpha5),
        borderRadius: BorderRadius.circular(context.radiusMedium - context.spacing8),
        border: Border.all(
          color: OsmeaColors.pewter.withOpacity(context.alpha10),
          width: context.width1,
        ),
      ),
      child: OsmeaComponents.row(
        mainAxisAlignment: context.spaceEvenly,
        children: [
          _InlineButton(icon: Icons.remove, onPressed: onDecrement),
          OsmeaComponents.text(
            '$quantity',
            textStyle: OsmeaTextStyle.bodySmall(context)
                .copyWith(fontWeight: FontWeight.w500, letterSpacing: 0.2),
          ),
          _InlineButton(icon: Icons.add, onPressed: onIncrement),
        ],
      ),
    );
  }
}

class _InlineButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _InlineButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: OsmeaComponents.container(
        width: context.dynamicWidth(0.075),
        height: context.dynamicWidth(0.075),
        decoration: BoxDecoration(
          color: onPressed != null
              ? OsmeaColors.nordicBlue.withOpacity(context.alpha10)
              : OsmeaColors.pewter.withOpacity(context.alpha5),
          borderRadius: BorderRadius.circular(context.radiusLow * 7),
        ),
        child: Icon(
          icon,
          color: onPressed != null
              ? OsmeaColors.nordicBlue.withOpacity(context.alpha80)
              : OsmeaColors.pewter.withOpacity(context.alpha30),
          size: context.iconSizeExtraSmall,
        ),
      ),
    );
  }
}


