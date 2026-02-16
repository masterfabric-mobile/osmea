/*
 * Product Attributes Widget
 * -------------------------
 * Widget for displaying and selecting product attributes (color, size, etc.)
 * using OsmeaComponents chips. Adapted for Supabase ProductVariant model.
 */
// ignore_for_file: dead_code

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:storefront_supabase/app/views/view_product_detail/models/product_detail_view_model.dart';
import 'package:storefront_supabase/app/views/view_product_detail/models/module/states.dart';

/// Widget for displaying product attributes with chip selection
class ProductAttributesWidget extends StatelessWidget {
  final ProductDetailViewModel viewModel;
  final ProductDetailLoadedState state;

  const ProductAttributesWidget({
    super.key,
    required this.viewModel,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    // Group variants by name (e.g. Size, Color)
    final Map<String, Set<String>> attributes = {};
    for (final variant in state.product.variants) {
      attributes.putIfAbsent(variant.name, () => {}).add(variant.value);
    }

    if (attributes.isEmpty) {
      return const SizedBox.shrink();
    }

    return OsmeaComponents.collapse(
      size: CollapseSize.medium,
      variant: CollapseVariant.ghost,
      mode: CollapseBehaviorMode.multiple,
      children: attributes.entries.map((entry) {
        final attrName = entry.key;
        final options = entry.value.toList()..sort();
        final selectedValue = state.selectedAttributes[attrName];
        final displayName = attrName.capitalized;

        return OsmeaCollapsePanel(
          header: selectedValue != null
              ? RichText(
                  text: TextSpan(
                    style: OsmeaTextStyle.bodyMedium(context).copyWith(
                      color: OsmeaColors.black,
                      fontWeight: FontWeight.w600,
                    ),
                    children: [
                      TextSpan(text: '$displayName: '),
                      TextSpan(
                        text: selectedValue.capitalized,
                        style: OsmeaTextStyle.bodyMedium(context).copyWith(
                          color: OsmeaColors.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                )
              : OsmeaComponents.text(
                  displayName,
                  textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                    color: OsmeaColors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
          value: attrName.toLowerCase(),
          body: OsmeaComponents.padding(
            padding: EdgeInsets.only(
              top: context.spacing4,
              bottom: context.spacing4,
              left: context.spacing12,
              right: context.spacing12,
            ),
            child: Wrap(
              spacing: 0,
              runSpacing: 0,
              children: [
                for (final opt in options) ...[
                  _buildChip(
                    context,
                    attrName,
                    opt,
                    state,
                    viewModel,
                  ),
                ],
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  /// Builds a chip widget for attribute options
  Widget _buildChip(
    BuildContext context,
    String attrName,
    String opt,
    ProductDetailLoadedState state,
    ProductDetailViewModel viewModel,
  ) {
    final isSelected = state.selectedAttributes[attrName] == opt;
    final isHighlighted =
        state.highlightedAttributes.contains(attrName) && !isSelected;

    // Simple availability check: if variant with this option exists
    final isAvailable = true; // Simplified for now

    return OsmeaComponents.container(
      margin: EdgeInsets.only(
        right: context.spacing6,
        bottom: context.spacing6,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            if (isSelected) {
              await viewModel.clearSelectedAttribute(attrName);
            } else {
              await viewModel.setSelectedAttribute(attrName, opt);
            }
          },
          borderRadius: BorderRadius.circular(4),
          child: OsmeaComponents.container(
            padding: EdgeInsets.symmetric(
              horizontal: context.spacing10,
              vertical: context.spacing8,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? OsmeaColors.black
                  : (isHighlighted
                      ? OsmeaColors.black.withValues(alpha: 0.04)
                      : OsmeaColors.white),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: isHighlighted
                    ? OsmeaColors.black.withValues(alpha: 0.6)
                    : (isSelected
                        ? OsmeaColors.black
                        : OsmeaColors.grayMaterial[300]!),
                width: isSelected || isHighlighted ? 1.5 : 1,
              ),
            ),
            child: OsmeaComponents.row(
              mainAxisSize: MainAxisSize.min,
              children: [
                OsmeaComponents.text(
                  opt.capitalized,
                  textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected
                        ? OsmeaColors.white
                        : (isHighlighted
                            ? OsmeaColors.black
                            : (isAvailable
                                ? OsmeaColors.black
                                : OsmeaColors.grayMaterial[400]!)),
                    letterSpacing: 0.1,
                  ),
                ),
                if (isSelected) ...[
                  OsmeaComponents.sizedBox(width: context.spacing6),
                  Icon(
                    Icons.check,
                    size: 16,
                    color: OsmeaColors.white,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String get capitalized {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}