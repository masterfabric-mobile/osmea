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

class TagsFilterWidget extends StatefulWidget {
  final ProductListViewModel viewModel;
  final List<int> selectedTags;

  const TagsFilterWidget({
    super.key,
    required this.viewModel,
    required this.selectedTags,
  });

  @override
  State<TagsFilterWidget> createState() => _TagsFilterWidgetState();
}

class _TagsFilterWidgetState extends State<TagsFilterWidget> {
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
        // Debug: Log state information
        debugPrint(
          '🏷️ TagsFilterWidget: Building with ${state.tags.length} tags',
        );
        debugPrint(
          '  - isLoadingFilterOptions: ${state.isLoadingFilterOptions}',
        );
        debugPrint('  - filterOptionsError: ${state.filterOptionsError}');

        // Get current temp filters to ensure we have the latest selection
        final currentSelectedTags =
            widget.viewModel.tempFilters.selectedTags ?? [];

        // Show loading if tags are being loaded
        if (state.isLoadingFilterOptions && state.tags.isEmpty) {
          debugPrint('🏷️ TagsFilterWidget: Showing loading indicator');
          return OsmeaComponents.center(
            child: OsmeaComponents.loading(
              type: LoadingType.circularFade,
              size: 32,
              color: OsmeaColors.nordicBlue,
            ),
          );
        }

        // Show error if tags failed to load
        if (state.filterOptionsError != null && state.tags.isEmpty) {
          debugPrint(
            '🏷️ TagsFilterWidget: Showing error: ${state.filterOptionsError}',
          );
          return OsmeaComponents.text(
            'Failed to load tags: ${state.filterOptionsError}',
            textStyle: OsmeaTextStyle.bodyMedium(
              context,
            ).copyWith(color: OsmeaColors.red),
          );
        }

        // Show empty state if no tags (only if not loading)
        if (state.tags.isEmpty && !state.isLoadingFilterOptions) {
          debugPrint(
            '🏷️ TagsFilterWidget: No tags available, returning empty widget',
          );
          // Return empty widget instead of showing message
          return const SizedBox.shrink();
        }

        debugPrint(
          '🏷️ TagsFilterWidget: Displaying ${state.tags.length} tags as chips',
        );

        // Display tags as chips
        return OsmeaComponents.wrap(
          spacing: context.spacing8,
          runSpacing: context.spacing8,
          children: state.tags.map((tag) {
            final tagId = tag.id;
            if (tagId == null) return const SizedBox.shrink();

            final isSelected = currentSelectedTags.contains(tagId);
            final tagName = tag.name ?? 'Unnamed Tag';

            return OsmeaComponents.chips(
              text: tagName,
              icon: isSelected ? Icons.check_circle : null,
              iconPosition: ChipsIconPosition.start,
              variant: isSelected ? ChipsVariant.primary : ChipsVariant.neutral,
              style: isSelected ? ChipsStyle.normal : ChipsStyle.outlined,
              selected: isSelected,
              borderWidth: isSelected ? 2.0 : null,
              backgroundColor: isSelected ? OsmeaColors.nordicBlue : null,
              textColor: isSelected ? OsmeaColors.white : null,
              onTap: () {
                final newSelectedTags = List<int>.from(currentSelectedTags);
                if (isSelected) {
                  newSelectedTags.remove(tagId);
                } else {
                  newSelectedTags.add(tagId);
                }
                // Always pass the list, even if empty (use empty list instead of null)
                widget.viewModel.updateTempFilter(
                  selectedTags: newSelectedTags,
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
