/*
 * StockStatusFilterWidget
 * -----------------------
 * Widget for stock status filtering using chips.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:storefront_woo/app/views/view_product_list/models/product_list_view_model.dart';

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
      icon: isSelected ? Icons.check : null,
      iconPosition: ChipsIconPosition.start,
      variant: isSelected ? ChipsVariant.primary : ChipsVariant.neutral,
      style: isSelected ? ChipsStyle.normal : ChipsStyle.outlined,
      backgroundColor: isSelected ? OsmeaColors.black : null,
      textColor: isSelected ? OsmeaColors.white : null,
      borderWidth: isSelected ? 2.0 : null,
      onTap: () {
        viewModel.updateTempFilter(stockStatus: isSelected ? null : value);
      },
    );
  }
}
