/*
 * TagsFilterWidget
 * ----------------
 * Widget for tags filtering with chips.
 */

import 'package:flutter/material.dart';
import 'package:storefront_woo/app/views/view_product_list/models/product_list_view_model.dart';

class TagsFilterWidget extends StatelessWidget {
  final ProductListViewModel viewModel;
  final List<int> selectedTags;

  const TagsFilterWidget({
    super.key,
    required this.viewModel,
    required this.selectedTags,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

