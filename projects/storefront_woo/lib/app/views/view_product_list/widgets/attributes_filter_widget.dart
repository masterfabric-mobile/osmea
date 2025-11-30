/*
 * AttributesFilterWidget
 * ----------------------
 * Widget for attributes filtering with collapsible sections.
 */

import 'package:flutter/material.dart';
import 'package:storefront_woo/app/views/view_product_list/models/product_list_view_model.dart';

class AttributesFilterWidget extends StatelessWidget {
  final ProductListViewModel viewModel;

  const AttributesFilterWidget({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

