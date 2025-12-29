/*
 * SortOptionWidget
 * ----------------
 * Widget for displaying a single sort option with simple, clean design.
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

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          viewModel.updateTempFilter(orderBy: orderBy, order: order);
        },
        borderRadius: BorderRadius.circular(context.spacing12),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: context.spacing16,
            vertical: context.spacing12,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? OsmeaColors.nordicBlue.withOpacity(0.08)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(context.spacing8),
          ),
          child: OsmeaComponents.row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: OsmeaComponents.text(
                  label,
                  textStyle: OsmeaTextStyle.bodyLarge(context).copyWith(
                    color: isSelected
                        ? OsmeaColors.nordicBlue
                        : OsmeaColors.thunder,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
              if (isSelected)
                Container(
                  padding: EdgeInsets.all(context.spacing4),
                  decoration: BoxDecoration(
                    color: OsmeaColors.nordicBlue,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_rounded,
                    color: OsmeaColors.white,
                    size: context.iconSizeSmall,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
