/*
 * Product Description Widget
 * --------------------------
 * Widget for displaying product description.
 */

import 'package:flutter/material.dart';
import 'package:storefront_woo/app/views/view_product_detail/models/product_detail_view_model.dart';
import 'package:storefront_woo/app/views/view_product_detail/models/module/states.dart';
import 'package:storefront_woo/app/views/view_product_detail/widgets/description_section.dart';

/// Widget for displaying product description
class ProductDescriptionWidget extends StatelessWidget {
  final ProductDetailViewModel viewModel;
  final ProductDetailLoadedState state;

  const ProductDescriptionWidget({
    super.key,
    required this.viewModel,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    if (state.product.description?.isEmpty != false) {
      return const SizedBox.shrink();
    }

    // Just show the description section without duplicate title
    return DescriptionSection(
      description: state.product.description!,
      viewModel: viewModel,
      state: state,
    );
  }
}

