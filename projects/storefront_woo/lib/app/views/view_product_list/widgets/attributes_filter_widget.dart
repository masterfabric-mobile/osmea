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
  final Map<int, List<int>> selectedAttributes;

  const AttributesFilterWidget({
    super.key,
    required this.viewModel,
    required this.selectedAttributes,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductListViewModel, ProductListState>(
      bloc: viewModel,
      builder: (context, state) {
        final filterOptions = state is ProductListLoadedState
            ? state.filterOptions
            : null;

        if (filterOptions?.availableAttributes == null ||
            filterOptions!.availableAttributes!.isEmpty) {
          return CollapsibleSectionWidget(
            viewModel: viewModel,
            title: 'Attributes',
            sectionKey: 'attributes',
            child: OsmeaComponents.text(
              'No attributes available',
              textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                color: OsmeaColors.pewter,
                fontStyle: FontStyle.italic,
              ),
            ),
          );
        }

        return OsmeaComponents.column(
          children: filterOptions.availableAttributes!
              .expand((attribute) {
                final selectedTerms = selectedAttributes[attribute.id] ?? [];
                
                return [
                  CollapsibleSectionWidget(
                    viewModel: viewModel,
                    title: attribute.name,
                    sectionKey: 'attribute_${attribute.id}',
                    child: OsmeaComponents.wrap(
                      spacing: context.spacing8,
                      runSpacing: context.spacing8,
                      children: attribute.terms.map((term) {
                        final isSelected = selectedTerms.contains(term.id);
                        return OsmeaComponents.chips(
                          text:
                              '${term.name}${term.count != null ? ' (${term.count})' : ''}',
                          variant: isSelected
                              ? ChipsVariant.primary
                              : ChipsVariant.neutral,
                          style: isSelected ? ChipsStyle.normal : ChipsStyle.outlined,
                          selected: isSelected,
                          onTap: () {
                            final updated = Map<int, List<int>>.from(
                              selectedAttributes,
                            );
                            final terms = List<int>.from(updated[attribute.id] ?? []);
                            if (isSelected) {
                              terms.remove(term.id);
                            } else {
                              terms.add(term.id);
                            }
                            if (terms.isEmpty) {
                              updated.remove(attribute.id);
                            } else {
                              updated[attribute.id] = terms;
                            }
                            viewModel.updateTempFilter(selectedAttributes: updated);
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ];
              })
              .toList(),
        );
      },
    );
  }
}

