/*
 * CategoriesFilterWidget
 * ---------------------
 * Widget for categories filtering with chips.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_supabase/app/views/view_product_list/models/product_list_view_model.dart';
import 'package:storefront_supabase/app/views/view_product_list/models/module/states.dart';

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
        setState(() {});
      },
      builder: (context, state) {
        final currentCategoryId = widget.viewModel.tempFilters.categoryId;

        if (state.isLoadingFilterOptions && state.categories.isEmpty) {
          return OsmeaComponents.center(
            child: OsmeaComponents.loading(
              type: LoadingType.circularFade,
              size: 32,
              color: OsmeaColors.black,
            ),
          );
        }

        if (state.categories.isEmpty) {
          return OsmeaComponents.padding(
            padding: EdgeInsets.symmetric(horizontal: context.spacing16),
            child: OsmeaComponents.text(
              'No categories available',
              textStyle: OsmeaTextStyle.bodyMedium(
                context,
              ).copyWith(color: OsmeaColors.pewter),
            ),
          );
        }

        return OsmeaComponents.padding(
          padding: EdgeInsets.symmetric(horizontal: context.spacing16),
          child: OsmeaComponents.wrap(
            spacing: context.spacing8,
            runSpacing: context.spacing8,
            children: state.categories.map((category) {
              final categoryId = category.id;
              final isSelected = currentCategoryId == categoryId;
              final categoryName = category.name;

              return OsmeaComponents.chips(
                text: categoryName,
                icon: isSelected ? Icons.check : null,
                iconPosition: ChipsIconPosition.start,
                variant: isSelected ? ChipsVariant.primary : ChipsVariant.neutral,
                style: isSelected ? ChipsStyle.normal : ChipsStyle.outlined,
                borderWidth: isSelected ? 2.0 : null,
                backgroundColor: isSelected ? OsmeaColors.black : null,
                textColor: isSelected ? OsmeaColors.white : null,
                onTap: () {
                  if (isSelected) {
                    // Deselect
                    widget.viewModel.updateTempFilter(
                      categoryId: null, // This should trigger clearCategory in copyWith logic if properly implemented or we pass null explicitly
                    );
                  } else {
                    // Select
                    widget.viewModel.updateTempFilter(
                      categoryId: categoryId,
                    );
                  }
                  setState(() {});
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
