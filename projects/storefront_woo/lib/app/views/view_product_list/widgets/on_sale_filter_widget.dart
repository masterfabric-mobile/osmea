/*
 * OnSaleFilterWidget
 * ------------------
 * Widget for on sale filter using chips.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:storefront_woo/app/views/view_product_list/models/product_list_view_model.dart';

class OnSaleFilterWidget extends StatelessWidget {
  final ProductListViewModel viewModel;
  final bool isOnSale;

  const OnSaleFilterWidget({
    super.key,
    required this.viewModel,
    required this.isOnSale,
  });

  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.wrap(
      spacing: context.spacing8,
      runSpacing: context.spacing8,
      children: [
        OsmeaComponents.chips(
          text: 'On sale only',
          icon: isOnSale ? Icons.check : null,
          iconPosition: ChipsIconPosition.start,
          variant: isOnSale ? ChipsVariant.primary : ChipsVariant.neutral,
          style: isOnSale ? ChipsStyle.normal : ChipsStyle.outlined,
          backgroundColor: isOnSale ? OsmeaColors.black : null,
          textColor: isOnSale ? OsmeaColors.white : null,
          borderWidth: isOnSale ? 2.0 : null,
          onTap: () {
            viewModel.updateTempFilter(onSale: isOnSale ? null : true);
          },
        ),
      ],
    );
  }
}
