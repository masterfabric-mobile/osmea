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

  /// Get color from config
  Color _getColorFromConfig(String key, Color fallback) {
    try {
      final configHelper = AssetConfigHelper();
      final colorString = configHelper.getString('product_detail_view.quantity_selector.$key');
      if (colorString.isNotEmpty && colorString.startsWith('#')) {
        final hexString = colorString.substring(1);
        if (hexString.length == 6) {
          return Color(int.parse('FF$hexString', radix: 16));
        } else if (hexString.length == 8) {
          return Color(int.parse(hexString, radix: 16));
        }
      }
    } catch (e) {
      debugPrint('⚠️ Failed to load quantity_selector color $key: $e');
    }
    return fallback;
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = _getColorFromConfig('backgroundColor', OsmeaColors.white);
    final borderColor = _getColorFromConfig('borderColor', OsmeaColors.silver);
    final iconColor = _getColorFromConfig('iconColor', OsmeaColors.black);
    final textColor = _getColorFromConfig('textColor', OsmeaColors.black);
    
    return OsmeaComponents.container(
      height: context.dynamicHeight(0.055),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(context.radiusMedium - context.spacing8),
        border: Border.all(
          color: borderColor,
          width: context.width1,
        ),
      ),
      child: OsmeaComponents.row(
        mainAxisAlignment: context.spaceEvenly,
        children: [
          _InlineButton(icon: Icons.remove, onPressed: onDecrement, iconColor: iconColor),
          OsmeaComponents.text(
            '$quantity',
            textStyle: OsmeaTextStyle.bodySmall(context)
                .copyWith(fontWeight: FontWeight.w500, letterSpacing: 0.2, color: textColor),
          ),
          _InlineButton(icon: Icons.add, onPressed: onIncrement, iconColor: iconColor),
        ],
      ),
    );
  }
}

class _InlineButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color iconColor;

  const _InlineButton({required this.icon, required this.onPressed, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: OsmeaComponents.container(
        width: context.dynamicWidth(0.075),
        height: context.dynamicWidth(0.075),
        decoration: BoxDecoration(
          color: onPressed != null
              ? iconColor.withOpacity(context.alpha10)
              : OsmeaColors.white,
          borderRadius: BorderRadius.circular(context.radiusLow * 7),
        ),
        child: Icon(
          icon,
          color: onPressed != null
              ? iconColor.withOpacity(context.alpha80)
              : iconColor.withOpacity(context.alpha30),
          size: context.iconSizeExtraSmall,
        ),
      ),
    );
  }
}


