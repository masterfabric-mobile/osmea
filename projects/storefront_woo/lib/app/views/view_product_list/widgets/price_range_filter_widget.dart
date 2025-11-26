/*
 * PriceRangeFilterWidget
 * ----------------------
 * Widget for price range filtering with min and max inputs.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_woo/app/views/view_product_list/models/product_list_view_model.dart';
import 'package:storefront_woo/app/views/view_product_list/models/module/states.dart';

class PriceRangeFilterWidget extends StatelessWidget {
  final ProductListViewModel viewModel;

  const PriceRangeFilterWidget({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductListViewModel, ProductListState>(
      bloc: viewModel,
      builder: (context, state) {
        final filterOptions = state is ProductListLoadedState
            ? state.filterOptions
            : null;

        final priceRange = filterOptions?.priceRange;
        final currencyCode = priceRange?.currency?.toLowerCase() ?? 'usd';
        final currencyMinorUnit = priceRange?.currencyMinorUnit ?? 2;

        String? minPriceHint;
        String? maxPriceHint;
        
        if (priceRange != null) {
          minPriceHint = PriceInfoCurrencyHelper.formatPrice(
            priceRange.minPrice,
            currencyCode: currencyCode,
            decimalPlaces: currencyMinorUnit,
            removeTrailingZeros: true,
          );
          maxPriceHint = PriceInfoCurrencyHelper.formatPrice(
            priceRange.maxPrice,
            currencyCode: currencyCode,
            decimalPlaces: currencyMinorUnit,
            removeTrailingZeros: true,
          );
        }

        return OsmeaComponents.column(
          children: [
            if (priceRange != null) ...[
              OsmeaComponents.padding(
                padding: EdgeInsets.only(bottom: context.spacing8),
                child: OsmeaComponents.text(
                  'Range: $minPriceHint - $maxPriceHint',
                  textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                    color: OsmeaColors.pewter,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
            OsmeaComponents.row(
              children: [
                Expanded(
                  child: _PriceInputWidget(
                    label: 'Min price',
                    controller: viewModel.minPriceController,
                    onChanged: (value) {
                      viewModel.updateTempFilter(minPrice: value);
                    },
                    placeholder: minPriceHint,
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
                    placeholder: maxPriceHint,
                  ),
                ),
              ],
            ),
          ],
        );
      },
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
        final cleaned = value.replaceAll(RegExp(r'[^\d.]'), '');
        final parts = cleaned.split('.');
        final sanitized = parts.length > 2
            ? '${parts[0]}.${parts.sublist(1).join()}'
            : cleaned;

        if (controller.text != sanitized) {
          controller.value = TextEditingValue(
            text: sanitized,
            selection: TextSelection.collapsed(offset: sanitized.length),
          );
        }

        final finalValue = sanitized.isEmpty ? null : sanitized;
        onChanged(finalValue);
      },
    );
  }
}

