/*
 * PriceRangeFilterWidget
 * ----------------------
 * Widget for price range filtering with min and max inputs.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:storefront_supabase/app/views/view_product_list/models/product_list_view_model.dart';

class PriceRangeFilterWidget extends StatelessWidget {
  final ProductListViewModel viewModel;

  const PriceRangeFilterWidget({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.padding(
      padding: EdgeInsets.symmetric(horizontal: context.spacing16),
      child: OsmeaComponents.column(
        children: [
          OsmeaComponents.row(
            children: [
              Expanded(
                child: _PriceInputWidget(
                  label: 'Min price',
                  controller: viewModel.minPriceController,
                  onChanged: (value) {
                    viewModel.updateTempFilter(minPrice: value);
                  },
                  placeholder: 'Min',
                ),
              ),
              OsmeaComponents.sizedBox(width: context.spacing12),
              Expanded(
                child: _PriceInputWidget(
                  label: 'Max price',
                  controller: viewModel.maxPriceController,
                  onChanged: (value) {
                    viewModel.updateTempFilter(maxPrice: value);
                  },
                  placeholder: 'Max',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PriceInputWidget extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final Function(String?) onChanged;
  final String? placeholder;

  const _PriceInputWidget({
    required this.label,
    required this.controller,
    required this.onChanged,
    this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.textField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      hint: placeholder ?? (label == 'Min price' ? 'Min' : 'Max'),
      variant: TextFieldVariant.outlined,
      size: TextFieldSize.medium,
      onChanged: (value) {
        onChanged(value);
      },
    );
  }
}
