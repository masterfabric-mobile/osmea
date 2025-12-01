/*
 * SortOptionWidget
 * ----------------
 * Widget for displaying a single sort option using OsmeaComponents.listItem.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:storefront_woo/app/views/view_product_list/models/product_list_view_model.dart';

class SortOptionWidget extends StatelessWidget {
  final ProductListViewModel viewModel;
  final String label;
  final String orderBy;
  final String order;
  final String selectedSortBy;
  final String selectedOrder;

  const SortOptionWidget({
    super.key,
    required this.viewModel,
    required this.label,
    required this.orderBy,
    required this.order,
    required this.selectedSortBy,
    required this.selectedOrder,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedSortBy == orderBy && selectedOrder == order;

    return OsmeaComponents.listItem(
      title: OsmeaComponents.text(
        label,
        textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
          color: isSelected ? OsmeaColors.white : OsmeaColors.thunder,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
      variant: ListItemVariant.standard,
      size: ListItemSize.medium,
      selected: isSelected,
      trailing: isSelected
          ? Icon(
              Icons.check_circle,
              color: OsmeaColors.white,
              size: context.iconSizeNormal,
            )
          : null,
      onTap: () {
        viewModel.updateTempFilter(orderBy: orderBy, order: order);
      },
      backgroundColor: isSelected ? OsmeaColors.nordicBlue : OsmeaColors.white,
      outlineColor: isSelected ? OsmeaColors.nordicBlue : OsmeaColors.silver,
      borderVariant: ListItemBorderVariant.all,
      margin: EdgeInsets.only(bottom: context.spacing8),
    );
  }
}
