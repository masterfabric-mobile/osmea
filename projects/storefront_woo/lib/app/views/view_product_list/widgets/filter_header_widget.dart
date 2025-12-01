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
    return OsmeaComponents.padding(
      padding: context.paddingNormal,
      child: OsmeaComponents.column(
        crossAxisAlignment: context.crossStart,
        children: [
          OsmeaComponents.row(
            mainAxisAlignment: context.spaceBetween,
            children: [
              Expanded(
                child: OsmeaComponents.text(
                  showOnlySort ? 'Sort Products' : 'Filter Products',
                  textStyle: OsmeaTextStyle.titleLarge(context).copyWith(
                    fontWeight: FontWeight.w600,
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
                        Navigator.pop(context);
                      },
                      variant: ButtonVariant.ghost,
                      size: ButtonSize.small,
                      icon: Icon(
                        Icons.clear_all,
                        size: context.iconSizeSmall,
                        color: OsmeaColors.nordicBlue,
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
                    variant: ButtonVariant.ghost,
                    size: ButtonSize.small,
                    icon: Icon(
                      Icons.check,
                      size: context.iconSizeSmall,
                      color: OsmeaColors.nordicBlue,
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

