/*
 * TagsFilterWidget
 * ----------------
 * Widget for tags filtering with chips.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_woo/app/views/view_product_list/models/product_list_view_model.dart';
import 'package:storefront_woo/app/views/view_product_list/models/module/states.dart';

class TagsFilterWidget extends StatelessWidget {
  final ProductListViewModel viewModel;
  final List<int> selectedTags;

  const TagsFilterWidget({
    super.key,
    required this.viewModel,
    required this.selectedTags,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductListViewModel, ProductListState>(
      bloc: viewModel,
      builder: (context, state) {
        // Get filterOptions from any state that has it
        final filterOptions = state.filterOptions;

        if (filterOptions?.tags == null || filterOptions!.tags!.isEmpty) {
          return OsmeaComponents.text(
            'No tags available',
            textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
              color: OsmeaColors.pewter,
              fontStyle: FontStyle.italic,
            ),
          );
        }

        return OsmeaComponents.wrap(
          spacing: context.spacing8,
          runSpacing: context.spacing8,
          children: filterOptions.tags!.map((tag) {
            final isSelected = selectedTags.contains(tag.id);
            return OsmeaComponents.chips(
              text: '${tag.name}${tag.count != null ? ' (${tag.count})' : ''}',
              variant: isSelected ? ChipsVariant.primary : ChipsVariant.neutral,
              style: isSelected ? ChipsStyle.normal : ChipsStyle.outlined,
              selected: isSelected,
              onTap: () {
                final updated = List<int>.from(selectedTags);
                if (isSelected) {
                  updated.remove(tag.id);
                } else {
                  updated.add(tag.id);
                }
                viewModel.updateTempFilter(selectedTags: updated);
              },
            );
          }).toList(),
        );
      },
    );
  }
}

