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

class CategoriesFilterWidget extends StatefulWidget {
  final ProductListViewModel viewModel;

  const CategoriesFilterWidget({super.key, required this.viewModel});

  @override
  State<CategoriesFilterWidget> createState() => _CategoriesFilterWidgetState();
}

class _CategoriesFilterWidgetState extends State<CategoriesFilterWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductListViewModel, ProductListState>(
      bloc: widget.viewModel,
      listener: (context, state) {
        // Force rebuild when state changes (even if it's the same instance)
        // This ensures tempFilters changes are reflected immediately
        setState(() {});
      },
      builder: (context, state) {
        // Get current temp filters to ensure we have the latest selection
        final currentSelectedCategories =
            widget.viewModel.tempFilters.selectedCategories ?? [];

        // Show loading if categories are being loaded
        if (state.isLoadingFilterOptions && state.categories.isEmpty) {
          return OsmeaComponents.center(
            child: OsmeaComponents.loading(
              type: LoadingType.circularFade,
              size: 32,
              color: OsmeaColors.nordicBlue,
            ),
          );
        }

        // Show error if categories failed to load
        if (state.filterOptionsError != null && state.categories.isEmpty) {
          return OsmeaComponents.text(
            'Failed to load categories: ${state.filterOptionsError}',
            textStyle: OsmeaTextStyle.bodyMedium(
              context,
            ).copyWith(color: OsmeaColors.red),
          );
        }

        // Show empty state if no categories
        if (state.categories.isEmpty) {
          return OsmeaComponents.text(
            'No categories available',
            textStyle: OsmeaTextStyle.bodyMedium(
              context,
            ).copyWith(color: OsmeaColors.pewter),
          );
        }

        // Display categories as chips
        return OsmeaComponents.wrap(
          spacing: context.spacing8,
          runSpacing: context.spacing8,
          children: state.categories.map((category) {
            final categoryId = category.id;
            if (categoryId == null) return const SizedBox.shrink();

            final isSelected = currentSelectedCategories.contains(categoryId);
            final categoryName = category.name ?? 'Unnamed Category';

            return OsmeaComponents.chips(
              text: categoryName,
              icon: isSelected ? Icons.check_circle : null,
              iconPosition: ChipsIconPosition.start,
              variant: isSelected ? ChipsVariant.primary : ChipsVariant.neutral,
              style: isSelected ? ChipsStyle.normal : ChipsStyle.outlined,
              selected: isSelected,
              borderWidth: isSelected ? 2.0 : null,
              backgroundColor: isSelected ? OsmeaColors.nordicBlue : null,
              textColor: isSelected ? OsmeaColors.white : null,
              onTap: () {
                final newSelectedCategories = List<int>.from(
                  currentSelectedCategories,
                );
                if (isSelected) {
                  newSelectedCategories.remove(categoryId);
                } else {
                  newSelectedCategories.add(categoryId);
                }
                // Always pass the list, even if empty (use empty list instead of null)
                widget.viewModel.updateTempFilter(
                  selectedCategories: newSelectedCategories,
                );
                // Force immediate rebuild to show selection change
                setState(() {});
              },
            );
          }).toList(),
        );
      },
    );
  }
}
