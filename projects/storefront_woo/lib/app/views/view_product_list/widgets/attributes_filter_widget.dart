/*
 * AttributesFilterWidget
 * ----------------------
 * Widget for attributes filtering with collapsible sections.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_woo/app/views/view_product_list/models/product_list_view_model.dart';
import 'package:storefront_woo/app/views/view_product_list/models/module/states.dart';
import 'package:storefront_woo/app/views/view_product_list/widgets/collapsible_section_widget.dart';

class AttributesFilterWidget extends StatelessWidget {
  final ProductListViewModel viewModel;

  const AttributesFilterWidget({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductListViewModel, ProductListState>(
      bloc: viewModel,
      builder: (context, state) {
        if (state.isLoadingFilterOptions) {
          return OsmeaComponents.padding(
            padding: EdgeInsets.all(context.spacing16),
            child: OsmeaComponents.center(
              child: CircularProgressIndicator(
                color: OsmeaColors.black,
              ),
            ),
          );
        }

        if (state.filterOptionsError != null) {
          return OsmeaComponents.padding(
            padding: EdgeInsets.all(context.spacing16),
            child: OsmeaComponents.text(
              'Failed to load attributes: ${state.filterOptionsError}',
              textStyle: OsmeaTextStyle.bodyMedium(context)
                  .copyWith(color: OsmeaColors.red),
            ),
          );
        }

        final attributesWithTerms = state.attributesWithTerms;
        if (attributesWithTerms.isEmpty) {
          return const SizedBox.shrink();
        }

        final selectedAttributes = viewModel.tempFilters.selectedAttributes ?? {};

        return OsmeaComponents.column(
          crossAxisAlignment: context.crossStart,
          mainAxisSize: MainAxisSize.min,
          children: attributesWithTerms
              .where((attributeWithTerms) {
                final attributeId = attributeWithTerms.attribute.id;
                final terms = attributeWithTerms.terms;
                return attributeId != null && terms.isNotEmpty;
              })
              .map((attributeWithTerms) {
                final attribute = attributeWithTerms.attribute;
                final terms = attributeWithTerms.terms;
                final attributeId = attribute.id!;

                final selectedTermIds = selectedAttributes[attributeId] ?? [];

                return OsmeaComponents.padding(
                  padding: EdgeInsets.only(bottom: context.spacing16),
                  child: CollapsibleSectionWidget(
                    viewModel: viewModel,
                    title: attribute.name ?? 'Attribute',
                    sectionKey: 'attribute_$attributeId',
                    child: OsmeaComponents.wrap(
                      spacing: context.spacing8,
                      runSpacing: context.spacing8,
                      children: terms.map((term) {
                        final termId = term.id;
                        if (termId == null) return const SizedBox.shrink();

                        final isSelected = selectedTermIds.contains(termId);

                        return OsmeaComponents.chips(
                          text: term.name ?? 'Term',
                          variant: isSelected
                              ? ChipsVariant.primary
                              : ChipsVariant.neutral,
                          style: isSelected
                              ? ChipsStyle.normal
                              : ChipsStyle.outlined,
                          selected: isSelected,
                          onTap: () {
                            final currentSelected =
                                Map<int, List<int>>.from(selectedAttributes);
                            final currentTermIds =
                                List<int>.from(
                                    currentSelected[attributeId] ?? []);

                            if (isSelected) {
                              // Remove term
                              currentTermIds.remove(termId);
                              if (currentTermIds.isEmpty) {
                                currentSelected.remove(attributeId);
                              } else {
                                currentSelected[attributeId] = currentTermIds;
                              }
                            } else {
                              // Add term
                              if (!currentTermIds.contains(termId)) {
                                currentTermIds.add(termId);
                                currentSelected[attributeId] = currentTermIds;
                              }
                            }

                            viewModel.updateTempFilter(
                              selectedAttributes: currentSelected.isEmpty
                                  ? {}
                                  : currentSelected,
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ),
                );
              })
              .toList(),
        );
      },
    );
  }
}

