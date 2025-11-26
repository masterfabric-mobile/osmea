/*
 * StockStatusFilterWidget
 * -----------------------
 * Widget for stock status filtering using chips.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_woo/app/views/view_product_list/models/product_list_view_model.dart';
import 'package:storefront_woo/app/views/view_product_list/models/module/states.dart';

class StockStatusFilterWidget extends StatelessWidget {
  final ProductListViewModel viewModel;
  final String? selectedStatus;

  const StockStatusFilterWidget({
    super.key,
    required this.viewModel,
    required this.selectedStatus,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductListViewModel, ProductListState>(
      bloc: viewModel,
      builder: (context, state) {
        final filterOptions = state is ProductListLoadedState
            ? state.filterOptions
            : null;

        if (filterOptions?.stockStatuses == null) {
          return _StaticStockStatusFilter(
            viewModel: viewModel,
            selectedStatus: selectedStatus,
          );
        }

        return OsmeaComponents.wrap(
          spacing: context.spacing8,
          runSpacing: context.spacing8,
          children: filterOptions!.stockStatuses
              .where((stockStatus) => stockStatus.enabled)
              .map(
                (stockStatus) {
                  final isSelected = selectedStatus == stockStatus.key;
                  return OsmeaComponents.chips(
                    text: stockStatus.label,
                    variant: isSelected
                        ? ChipsVariant.primary
                        : ChipsVariant.neutral,
                    style: isSelected ? ChipsStyle.normal : ChipsStyle.outlined,
                    selected: isSelected,
                    onTap: () {
                      viewModel.updateTempFilter(
                        stockStatus: isSelected ? null : stockStatus.key,
                      );
                    },
                  );
                },
              )
              .toList(),
        );
      },
    );
  }
}

class _StaticStockStatusFilter extends StatelessWidget {
  final ProductListViewModel viewModel;
  final String? selectedStatus;

  const _StaticStockStatusFilter({
    required this.viewModel,
    required this.selectedStatus,
  });

  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.wrap(
      spacing: context.spacing8,
      runSpacing: context.spacing8,
      children: [
        _buildChip(context, 'In stock', 'instock'),
        _buildChip(context, 'Out of stock', 'outofstock'),
        _buildChip(context, 'On backorder', 'onbackorder'),
      ],
    );
  }

  Widget _buildChip(BuildContext context, String label, String value) {
    final isSelected = selectedStatus == value;
    return OsmeaComponents.chips(
      text: label,
      variant: isSelected ? ChipsVariant.primary : ChipsVariant.neutral,
      style: isSelected ? ChipsStyle.normal : ChipsStyle.outlined,
      selected: isSelected,
      onTap: () {
        viewModel.updateTempFilter(stockStatus: isSelected ? null : value);
      },
    );
  }
}
