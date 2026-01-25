/*
 * CheckoutProcessingWidget
 * ------------------------
 * Same minimal loading design as other loadings (e.g. UnifiedLoadingWidget).
 * Indeterminate spinner only; no text. Keeps animating until the view model
 * emits CheckoutOrderCompletedState or CheckoutErrorState (handled by parent).
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';

class CheckoutProcessingWidget extends StatelessWidget {
  const CheckoutProcessingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color progressColor;
    try {
      final configHelper = AssetConfigHelper();
      final bgHex = configHelper.getString('loading_configuration.styles.startup.background_color');
      final progressHex = configHelper.getString('loading_configuration.styles.startup.primary_color');
      bgColor = bgHex.isNotEmpty && bgHex.startsWith('#')
          ? _hexToColor(bgHex)
          : OsmeaColors.white;
      progressColor = progressHex.isNotEmpty && progressHex.startsWith('#')
          ? _hexToColor(progressHex)
          : OsmeaColors.nordicBlue;
    } catch (_) {
      bgColor = OsmeaColors.white;
      progressColor = OsmeaColors.nordicBlue;
    }

    return SizedBox.expand(
      child: OsmeaComponents.container(
        color: bgColor,
        child: SafeArea(
          child: Center(
            child: SizedBox(
              width: 48,
              height: 48,
              child: CircularProgressIndicator(
                value: null,
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                backgroundColor: progressColor.withValues(alpha: 0.1),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _hexToColor(String hex) {
    final h = hex.replaceAll('#', '');
    if (h.length == 6) {
      return Color(int.parse('FF$h', radix: 16));
    }
    if (h.length == 8) {
      return Color(int.parse(h, radix: 16));
    }
    return OsmeaColors.black;
  }
}
