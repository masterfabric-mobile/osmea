/*
 * Product Detail Loading Widget
 * -----------------------------
 * Loading widget for product detail view.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';

/// Loading widget for product detail view
class ProductDetailLoadingWidget extends StatelessWidget {
  const ProductDetailLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.center(
      child: OsmeaComponents.loading(
        type: LoadingType.circularFade,
        size: context.iconSizeLarge,
        color: OsmeaColors.nordicBlue,
      ),
    );
  }
}








