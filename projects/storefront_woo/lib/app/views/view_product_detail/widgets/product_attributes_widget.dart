/*
 * Product Attributes Widget
 * -------------------------
 * Widget for displaying and selecting product attributes (color, size, etc.)
 * using OsmeaComponents chips.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_api/freezed_model/response/retrieve_product_response_model.dart'
    as product_models;
import 'package:storefront_woo/app/views/view_product_detail/models/product_detail_view_model.dart';
import 'package:storefront_woo/app/views/view_product_detail/models/module/states.dart';
import 'package:osmea_components/src/enums/collapse_enums.dart';

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
    final rawAttributes = state.product.attributes!;

    // Normalize attributes coming from different Woo APIs
    List<Map<String, dynamic>> normalized = [];
    for (final item in rawAttributes) {
      if (item is Map<String, dynamic>) {
        final name = (item['name'] ?? item['label'] ?? '').toString();
        List<String> options = [];
        final rawOptions = item['options'];
        final rawTerms = item['terms'];

        if (rawOptions is List && rawOptions.isNotEmpty) {
          options = rawOptions.map((e) => e.toString()).toList();
        } else if (rawTerms is List && rawTerms.isNotEmpty) {
          options = rawTerms
              .map(
                (e) => e is Map
                    ? (e['name'] ?? e['value'] ?? '').toString()
                    : e.toString(),
              )
              .where((e) => e.isNotEmpty)
              .toList();
        }

        if (options.isNotEmpty) {
          normalized.add({'name': name, 'options': options});
        }
      } else {
        try {
          final dynamic dyn = item;
          final String name = (dyn.name as String?) ?? '';
          final List<String> options =
              (dyn.options as List?)?.map((e) => e.toString()).toList() ?? [];

          if (options.isNotEmpty) {
            normalized.add({'name': name, 'options': options});
          }
        } catch (_) {
          // Skip unknown shapes gracefully
        }
      }
    }

    if (normalized.isEmpty) {
      return const SizedBox.shrink();
    }

    // All attributes are now collapsible menu items
    return OsmeaComponents.collapse(
      size: CollapseSize.medium,
      variant: CollapseVariant.ghost,
      mode: CollapseBehaviorMode.multiple,
      children: normalized.map((attr) {
        final attrName = (attr['name'] as String?) ?? '';
        final selectedValue = state.selectedAttributes[attrName];
        final displayName = attrName.capitalizeFirst();

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
                        text: selectedValue.capitalizeFirst(),
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
                for (final opt in (attr['options'] as List<String>)) ...[
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

    final isAvailable = _isOptionAvailable(
      attrName,
      opt,
      state.product,
      state.selectedAttributes,
    );


    // Elegant chip design with refined visual feedback
    return OsmeaComponents.container(
      margin: EdgeInsets.only(
        right: context.spacing6,
        bottom: context.spacing6,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: (isAvailable || isSelected)
              ? () async {
                  if (isSelected) {
                    await viewModel.clearSelectedAttribute(attrName);
                  } else {
                    await viewModel.setSelectedAttribute(attrName, opt);
                  }
                }
              : null,
          borderRadius: BorderRadius.circular(8),
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
                      : (isAvailable
                          ? OsmeaColors.white
                          : OsmeaColors.grayMaterial[50]!)),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isHighlighted
                    ? OsmeaColors.black.withValues(alpha: 0.6)
                    : (isSelected
                        ? OsmeaColors.black
                        : (isAvailable
                            ? OsmeaColors.black.withValues(alpha: 0.15)
                            : OsmeaColors.grayMaterial[300]!)),
                width: isSelected || isHighlighted ? 1.5 : 1,
              ),
            ),
            child: OsmeaComponents.row(
              mainAxisSize: MainAxisSize.min,
              children: [
                OsmeaComponents.text(
                  opt.capitalizeFirst(),
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

  /// Checks if an attribute option is available based on selected attributes and variations
  bool _isOptionAvailable(
    String attributeName,
    String optionValue,
    product_models.RetrieveProductResponseModel product,
    Map<String, String> selectedAttributes,
  ) {
    if (product.variations == null || product.variations!.isEmpty) {
      return true;
    }

    final List<Map<String, dynamic>> variations = [];
    for (final variation in product.variations!) {
      if (variation is Map<String, dynamic>) {
        variations.add(variation);
      }
    }

    if (variations.isEmpty) {
      return true;
    }

    final Map<String, String> attributeNameToTaxonomy = {};
    final Map<String, String> taxonomyToName = {};
    if (product.attributes != null) {
      for (final attr in product.attributes!) {
        if (attr is Map<String, dynamic>) {
          final name = (attr['name'] ?? attr['label'] ?? '').toString().trim();
          final taxonomy = (attr['taxonomy'] ?? attr['id'] ?? '')
              .toString()
              .trim();
          if (name.isNotEmpty) {
            attributeNameToTaxonomy[name] = taxonomy.isNotEmpty
                ? taxonomy
                : name;
            if (taxonomy.isNotEmpty) {
              taxonomyToName[taxonomy] = name;
            }
          }
        }
      }
    }

    String normalize(String str) => str.trim().toLowerCase();

    bool attributeNamesMatch(String name1, String name2) {
      final normalized1 = normalize(name1);
      final normalized2 = normalize(name2);

      if (normalized1 == normalized2) return true;

      final taxonomy1 = attributeNameToTaxonomy[name1] ?? '';
      final taxonomy2 = attributeNameToTaxonomy[name2] ?? '';
      if (taxonomy1.isNotEmpty &&
          taxonomy2.isNotEmpty &&
          normalize(taxonomy1) == normalize(taxonomy2)) {
        return true;
      }

      if (taxonomy2.isNotEmpty && normalize(name1) == normalize(taxonomy2))
        return true;
      if (taxonomy1.isNotEmpty && normalize(name2) == normalize(taxonomy1))
        return true;

      return false;
    }

    bool valuesMatch(String value1, String value2) {
      return normalize(value1) == normalize(value2);
    }

    if (selectedAttributes.isEmpty) {
      return true;
    }

    final testSelection = Map<String, String>.from(selectedAttributes);
    testSelection.remove(attributeName);

    if (testSelection.isEmpty) {
      for (final variation in variations) {
        final variationAttrs = variation['attributes'] as List<dynamic>?;
        if (variationAttrs == null) continue;

        for (final varAttr in variationAttrs) {
          if (varAttr is Map<String, dynamic>) {
            final varAttrName = (varAttr['name'] ?? varAttr['id'] ?? '')
                .toString();
            final varAttrValue = (varAttr['value'] ?? '').toString();

            if (attributeNamesMatch(varAttrName, attributeName) &&
                valuesMatch(varAttrValue, optionValue)) {
              return true;
            }
          }
        }
      }
      return false;
    }

    for (final variation in variations) {
      final variationAttrs = variation['attributes'] as List<dynamic>?;
      if (variationAttrs == null) continue;

      bool matchesOtherAttributes = true;
      for (final entry in testSelection.entries) {
        final selectedAttrName = entry.key;
        final selectedAttrValue = entry.value;

        bool foundMatch = false;
        for (final varAttr in variationAttrs) {
          if (varAttr is Map<String, dynamic>) {
            final varAttrName = (varAttr['name'] ?? varAttr['id'] ?? '')
                .toString();
            final varAttrValue = (varAttr['value'] ?? '').toString();

            if (attributeNamesMatch(varAttrName, selectedAttrName) &&
                valuesMatch(varAttrValue, selectedAttrValue)) {
              foundMatch = true;
              break;
            }
          }
        }

        if (!foundMatch) {
          matchesOtherAttributes = false;
          break;
        }
      }

      if (matchesOtherAttributes) {
        for (final varAttr in variationAttrs) {
          if (varAttr is Map<String, dynamic>) {
            final varAttrName = (varAttr['name'] ?? varAttr['id'] ?? '')
                .toString();
            final varAttrValue = (varAttr['value'] ?? '').toString();

            if (attributeNamesMatch(varAttrName, attributeName) &&
                valuesMatch(varAttrValue, optionValue)) {
              return true;
            }
          }
        }
      }
    }

    return false;
  }
}

