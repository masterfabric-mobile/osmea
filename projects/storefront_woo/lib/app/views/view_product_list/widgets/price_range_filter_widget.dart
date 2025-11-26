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
        // Get filterOptions from any state that has it
        final filterOptions = state.filterOptions;

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
        // Allow digits, dot, and comma (for different decimal formats)
        // Codebase uses PriceInfoCurrencyHelper which handles both formats
        final cleaned = value.replaceAll(RegExp(r'[^\d.,]'), '');
        
        // Handle multiple decimal separators - keep only the last one
        final dotIndex = cleaned.lastIndexOf('.');
        final commaIndex = cleaned.lastIndexOf(',');
        
        String sanitized = cleaned;
        if (dotIndex != -1 && commaIndex != -1) {
          // Both present - use the one that appears later (more likely to be decimal)
          if (dotIndex > commaIndex) {
            // Dot is later - treat comma as thousand separator
            sanitized = cleaned.replaceAll(',', '');
          } else {
            // Comma is later - treat dot as thousand separator
            sanitized = cleaned.replaceAll('.', '').replaceAll(',', '.');
          }
        } else if (commaIndex != -1 && dotIndex == -1) {
          // Only comma - check if it's likely decimal (near end) or thousand separator
          if (commaIndex >= cleaned.length - 3) {
            // Comma near end - treat as decimal separator
            sanitized = cleaned.replaceAll(',', '.');
          } else {
            // Comma not near end - treat as thousand separator, remove it
            sanitized = cleaned.replaceAll(',', '');
          }
        } else if (dotIndex != -1) {
          // Only dot - ensure only one decimal point
          final parts = cleaned.split('.');
          if (parts.length > 2) {
            sanitized = '${parts[0]}.${parts.sublist(1).join()}';
          } else {
            sanitized = cleaned;
          }
        }

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

