/*
 * FilterHeaderWidget
 * ------------------
 * Header widget for filter bottom sheet with title and action buttons.
 * DEPRECATED: Buttons are now in headerActions of bottom sheet.
 */

import 'package:flutter/material.dart';
import 'package:storefront_woo/app/views/view_product_list/models/product_list_view_model.dart';

class FilterHeaderWidget extends StatelessWidget {
  final ProductListViewModel viewModel;
  final bool showOnlySort;

  const FilterHeaderWidget({
    super.key,
    required this.viewModel,
    required this.showOnlySort,
  });

  @override
  Widget build(BuildContext context) {
    // This widget is deprecated - buttons are now in headerActions
    return const SizedBox.shrink();
  }
}

