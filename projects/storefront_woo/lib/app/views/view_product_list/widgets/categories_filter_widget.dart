/*
 * CategoriesFilterWidget
 * ---------------------
 * Widget for categories filtering with chips.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_woo/app/views/view_product_list/models/product_list_view_model.dart';
import 'package:storefront_woo/app/views/view_product_list/models/module/states.dart';

class CategoriesFilterWidget extends StatelessWidget {
  final ProductListViewModel viewModel;
  final List<int> selectedCategories;

  const CategoriesFilterWidget({
    super.key,
    required this.viewModel,
    required this.selectedCategories,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductListViewModel, ProductListState>(
      bloc: viewModel,
      builder: (context, state) {
        // Get filterOptions from any state that has it
        final filterOptions = state.filterOptions;

        if (filterOptions?.categories == null ||
            filterOptions!.categories!.isEmpty) {
          return OsmeaComponents.text(
            'No categories available',
            textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
              color: OsmeaColors.pewter,
              fontStyle: FontStyle.italic,
            ),
          );
        }

        return OsmeaComponents.wrap(
          spacing: context.spacing8,
          runSpacing: context.spacing8,
          children: filterOptions.categories!.map((category) {
            final isSelected = selectedCategories.contains(category.id);
            return OsmeaComponents.chips(
              text:
                  '${category.name}${category.count != null ? ' (${category.count})' : ''}',
              variant: isSelected ? ChipsVariant.primary : ChipsVariant.neutral,
              style: isSelected ? ChipsStyle.normal : ChipsStyle.outlined,
              selected: isSelected,
              onTap: () {
                final updated = List<int>.from(selectedCategories);
                if (isSelected) {
                  updated.remove(category.id);
                } else {
                  updated.add(category.id);
                }
                viewModel.updateTempFilter(selectedCategories: updated);
              },
            );
          }).toList(),
        );
      },
    );
  }
}

