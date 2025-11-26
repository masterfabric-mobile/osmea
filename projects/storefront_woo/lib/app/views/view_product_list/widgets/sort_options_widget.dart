/*
 * SortOptionsWidget
 * ----------------
 * Widget for displaying sort options.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_woo/app/views/view_product_list/models/product_list_view_model.dart';
import 'package:storefront_woo/app/views/view_product_list/models/module/states.dart';
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
    return BlocBuilder<ProductListViewModel, ProductListState>(
      bloc: viewModel,
      builder: (context, state) {
        final filterOptions = state is ProductListLoadedState
            ? state.filterOptions
            : null;

        final sortOptions = filterOptions?.sortOptions;

        if (sortOptions == null || sortOptions.isEmpty) {
          if (viewModel.filterOptions == null) {
            viewModel.loadFilterOptions();
          }
          return _StaticSortOptions(
            viewModel: viewModel,
            selectedSortBy: selectedSortBy,
            selectedOrder: selectedOrder,
          );
        }

        return OsmeaComponents.column(
          children: [
            ...sortOptions
                .where((sortOption) => sortOption.enabled)
                .expand(
                  (sortOption) => sortOption.orders.map(
                    (orderOption) => SortOptionWidget(
                      viewModel: viewModel,
                      label: '${sortOption.label} (${orderOption.label})',
                      orderBy: sortOption.key,
                      order: orderOption.key,
                      selectedSortBy: selectedSortBy,
                      selectedOrder: selectedOrder,
                    ),
                  ),
                )
                .toList(),
          ],
        );
      },
    );
  }
}

class _StaticSortOptions extends StatelessWidget {
  final ProductListViewModel viewModel;
  final String selectedSortBy;
  final String selectedOrder;

  const _StaticSortOptions({
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

