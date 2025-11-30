/*
 * CategoriesFilterWidget
 * ---------------------
 * Widget for categories filtering with chips.
 */

import 'package:flutter/material.dart';
import 'package:storefront_woo/app/views/view_product_list/models/product_list_view_model.dart';

class CategoriesFilterWidget extends StatelessWidget {
  final ProductListViewModel viewModel;
  final List<int> selectedCategories;

  const CategoriesFilterWidget({
    super.key,
    required this.viewModel,
    required this.selectedCategories,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

