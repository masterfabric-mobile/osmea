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
        borderRadius: BorderRadius.circular(7),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: context.spacing20,
            vertical: context.spacing16,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? OsmeaColors.black.withOpacity(0.08)
                : Colors.transparent,
            border: isSelected
                ? Border.all(
                    color: OsmeaColors.black,
                    width: 1,
                  )
                : null,
            borderRadius: BorderRadius.circular(7),
          ),
          child: OsmeaComponents.row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              OsmeaComponents.text(
                label,
                textStyle: OsmeaTextStyle.bodyLarge(context).copyWith(
                  color: isSelected
                      ? OsmeaColors.black
                      : OsmeaColors.thunder,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
              if (isSelected) ...[
                SizedBox(width: context.spacing8),
                Container(
                  padding: EdgeInsets.all(context.spacing4),
                  decoration: BoxDecoration(
                    color: OsmeaColors.black,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_rounded,
                    color: OsmeaColors.white,
                    size: context.iconSizeSmall,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
