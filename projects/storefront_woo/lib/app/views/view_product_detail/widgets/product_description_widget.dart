/*
 * Product Description Widget
 * --------------------------
 * Widget for displaying product description.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:storefront_woo/app/views/view_product_detail/models/product_detail_view_model.dart';
import 'package:storefront_woo/app/views/view_product_detail/models/module/states.dart';
import 'package:storefront_woo/app/views/view_product_detail/widgets/description_section.dart';
import 'package:storefront_woo/gen/translations.g.dart';

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

    return OsmeaComponents.padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.spacing16,
        vertical: context.spacing4,
      ),
      child: OsmeaComponents.column(
        crossAxisAlignment: context.crossStart,
        children: [
          OsmeaComponents.text(
            context.t.productDetailView.description.details,
            textStyle: OsmeaTextStyle.titleSmall(context).copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0,
              color: OsmeaColors.black,
            ),
          ),
          OsmeaComponents.sizedBox(height: context.spacing4),
          DescriptionSection(
            description: state.product.description!,
            viewModel: viewModel,
            state: state,
          ),
        ],
      ),
    );
  }
}

