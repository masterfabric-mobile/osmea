import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:storefront_woo/app/views/view_product_detail/models/product_detail_view_model.dart';
import 'package:storefront_woo/app/views/view_product_detail/models/module/states.dart';

class DescriptionSection extends StatelessWidget {
  final String description;
  final ProductDetailViewModel viewModel;
  final ProductDetailLoadedState state;

  const DescriptionSection({
    super.key,
    required this.description,
    required this.viewModel,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    // WebViewerHelper now automatically decodes HTML entities
    return WebViewerHelper.html(description);
  }
}
