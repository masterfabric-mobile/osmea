/*
 * Product Reviews Widget
 * ----------------------
 * Widget for displaying product reviews.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:storefront_woo/app/views/view_product_detail/models/module/states.dart';
import 'package:storefront_woo/app/views/view_product_detail/widgets/product_reviews_section_widget.dart';

/// Widget for displaying product reviews
class ProductReviewsWidget extends StatelessWidget {
  final ProductDetailLoadedState state;

  const ProductReviewsWidget({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.spacing16,
        vertical: context.spacing4,
      ),
      child: ProductReviewsSectionWidget(state: state),
    );
  }
}

