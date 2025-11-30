/*
 * SortOptionsWidget
 * ----------------
 * Widget for displaying sort options.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:storefront_woo/app/views/view_product_list/models/product_list_view_model.dart';
import 'package:storefront_woo/app/views/view_product_list/widgets/sort_option_widget.dart';

class SortOptionsWidget extends StatelessWidget {
  final ProductListViewModel viewModel;
  final String selectedSortBy;
  final String selectedOrder;

  const SortOptionsWidget({
    super.key,
    required this.viewModel,
    required this.selectedSortBy,
    required this.selectedOrder,
  });

  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.column(
      children: [
        SortOptionWidget(
          viewModel: viewModel,
          label: 'Date (Newest)',
          orderBy: 'date',
          order: 'desc',
          selectedSortBy: selectedSortBy,
          selectedOrder: selectedOrder,
        ),
        SortOptionWidget(
          viewModel: viewModel,
          label: 'Date (Oldest)',
          orderBy: 'date',
          order: 'asc',
          selectedSortBy: selectedSortBy,
          selectedOrder: selectedOrder,
        ),
        SortOptionWidget(
          viewModel: viewModel,
          label: 'Price (Low to High)',
          orderBy: 'price',
          order: 'asc',
          selectedSortBy: selectedSortBy,
          selectedOrder: selectedOrder,
        ),
        SortOptionWidget(
          viewModel: viewModel,
          label: 'Price (High to Low)',
          orderBy: 'price',
          order: 'desc',
          selectedSortBy: selectedSortBy,
          selectedOrder: selectedOrder,
        ),
        SortOptionWidget(
          viewModel: viewModel,
          label: 'Name (A-Z)',
          orderBy: 'title',
          order: 'asc',
          selectedSortBy: selectedSortBy,
          selectedOrder: selectedOrder,
        ),
        SortOptionWidget(
          viewModel: viewModel,
          label: 'Name (Z-A)',
          orderBy: 'title',
          order: 'desc',
          selectedSortBy: selectedSortBy,
          selectedOrder: selectedOrder,
        ),
      ],
    );
  }
}

