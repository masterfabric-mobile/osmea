/*
 * FilterHeaderWidget
 * ------------------
 * Header widget for filter bottom sheet with title and action buttons.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
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
    return Container(
      padding: context.paddingNormal,
      decoration: BoxDecoration(
        color: OsmeaColors.white,
        border: Border(
          bottom: BorderSide(
            color: OsmeaColors.silver.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: OsmeaComponents.column(
        crossAxisAlignment: context.crossStart,
        children: [
          OsmeaComponents.row(
            mainAxisAlignment: context.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: OsmeaComponents.text(
                  showOnlySort ? 'Sort Products' : 'Filter Products',
                  textStyle: OsmeaTextStyle.titleLarge(context).copyWith(
                    fontWeight: FontWeight.w700,
                    color: OsmeaColors.thunder,
                  ),
                ),
              ),
              OsmeaComponents.row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (viewModel.hasTempFilters() && !showOnlySort) ...[
                    OsmeaComponents.button(
                      text: 'Clear all',
                      onPressed: () {
                        viewModel.clearFilters();
                      },
                      variant: ButtonVariant.outlined,
                      size: ButtonSize.small,
                      icon: Icon(
                        Icons.clear_all_rounded,
                        size: context.iconSizeSmall,
                        color: OsmeaColors.pewter,
                      ),
                      iconPosition: IconPosition.leading,
                    ),
                    OsmeaComponents.sizedBox(width: context.spacing8),
                  ],
                  OsmeaComponents.button(
                    text: 'Apply',
                    onPressed: () {
                      viewModel.applyFilters();
                      Navigator.pop(context);
                    },
                    variant: ButtonVariant.primary,
                    size: ButtonSize.small,
                    icon: Icon(
                      Icons.check_rounded,
                      size: context.iconSizeSmall,
                      color: OsmeaColors.white,
                    ),
                    iconPosition: IconPosition.leading,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

