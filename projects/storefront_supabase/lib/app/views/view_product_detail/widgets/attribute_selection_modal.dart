/*
 * Attribute Selection Modal
 * -------------------------
 * Step-by-step attribute selection modal for adding products to cart
 */
// ignore_for_file: dead_code

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:storefront_supabase/app/views/view_product_detail/models/view_model.dart';
import 'package:storefront_supabase/app/views/view_product_detail/models/states.dart';

/// Step-by-step attribute selection modal
class AttributeSelectionModal extends StatefulWidget {
  final ProductDetailViewModel viewModel;
  final ProductDetailLoadedState state;
  final Set<String> missingAttributes;
  final Function(Map<String, String>) onComplete;

  const AttributeSelectionModal({
    super.key,
    required this.viewModel,
    required this.state,
    required this.missingAttributes,
    required this.onComplete,
  });

  @override
  State<AttributeSelectionModal> createState() =>
      _AttributeSelectionModalState();
}

class _AttributeSelectionModalState extends State<AttributeSelectionModal> {
  int _currentStep = 0;
  late List<Map<String, dynamic>> _attributesToSelect;
  late Map<String, String> _tempSelections;

  @override
  void initState() {
    super.initState();
    _tempSelections = Map<String, String>.from(widget.state.selectedAttributes);
    _attributesToSelect = _buildAttributesList();
  }

  List<Map<String, dynamic>> _buildAttributesList() {
    final List<Map<String, dynamic>> attributes = [];
    
    // Group variants by name (e.g. Size, Color)
    final Map<String, Set<String>> groupedAttributes = {};
    for (final variant in widget.state.product.variants) {
      groupedAttributes.putIfAbsent(variant.name, () => {}).add(variant.value);
    }

    for (final entry in groupedAttributes.entries) {
      final name = entry.key;
      // Only include missing attributes
      if (!widget.missingAttributes.contains(name)) {
        continue;
      }
      
      final options = entry.value.toList()..sort();
      if (options.isNotEmpty) {
        attributes.add({'name': name, 'options': options});
      }
    }

    return attributes;
  }

  @override
  Widget build(BuildContext context) {
    if (_attributesToSelect.isEmpty) {
      Navigator.of(context).pop();
      widget.onComplete(_tempSelections);
      return const SizedBox.shrink();
    }

    final currentAttribute = _attributesToSelect[_currentStep];
    final attributeName = currentAttribute['name'] as String;
    final options = currentAttribute['options'] as List<String>;
    final selectedValue = _tempSelections[attributeName];
    final isLastStep = _currentStep == _attributesToSelect.length - 1;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: context.spacing12,
        vertical: context.spacing16,
      ),
      child: OsmeaComponents.container(
        decoration: BoxDecoration(
          color: OsmeaColors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: OsmeaComponents.column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header - minimal and compact
            OsmeaComponents.container(
              padding: EdgeInsets.all(context.spacing12),
              decoration: BoxDecoration(
                color: OsmeaColors.white,
                border: Border(
                  bottom: BorderSide(
                    color: OsmeaColors.black.withValues(alpha: 0.1),
                    width: 0.5,
                  ),
                ),
              ),
              child: OsmeaComponents.row(
                children: [
                  OsmeaComponents.expanded(
                    child: OsmeaComponents.column(
                      crossAxisAlignment: context.crossStart,
                      children: [
                        OsmeaComponents.text(
                          'SELECT OPTIONS',
                          textStyle: OsmeaTextStyle.titleMedium(context)
                              .copyWith(
                                fontWeight: FontWeight.w600,
                                color: OsmeaColors.black,
                                letterSpacing: 1.0,
                              ),
                        ),
                        OsmeaComponents.sizedBox(height: context.spacing2),
                        OsmeaComponents.text(
                          'Step ${_currentStep + 1} of ${_attributesToSelect.length}',
                          textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                            color: OsmeaColors.grayMaterial[500]!,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      borderRadius: BorderRadius.circular(20),
                      child: OsmeaComponents.container(
                        width: 32,
                        height: 32,
                        child: OsmeaComponents.center(
                          child: Icon(
                            Icons.close,
                            color: OsmeaColors.black,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Progress indicator - minimal
            OsmeaComponents.container(
              padding: EdgeInsets.symmetric(
                horizontal: context.spacing12,
                vertical: context.spacing8,
              ),
              child: OsmeaComponents.row(
                children: List.generate(
                  _attributesToSelect.length,
                  (index) => OsmeaComponents.expanded(
                    child: OsmeaComponents.container(
                      height: 1.5,
                      margin: EdgeInsets.symmetric(horizontal: 1),
                      decoration: BoxDecoration(
                        color: index <= _currentStep
                            ? OsmeaColors.black
                            : OsmeaColors.grayMaterial[200]!,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Current attribute selection - minimal
            OsmeaComponents.container(
              padding: EdgeInsets.all(context.spacing12),
              child: OsmeaComponents.column(
                crossAxisAlignment: context.crossStart,
                children: [
                  OsmeaComponents.text(
                    attributeName.toUpperCase(),
                    textStyle: OsmeaTextStyle.bodyLarge(context).copyWith(
                      fontWeight: FontWeight.w600,
                      color: OsmeaColors.black,
                      letterSpacing: 0.5,
                    ),
                  ),
                  OsmeaComponents.sizedBox(height: context.spacing8),
                  Wrap(
                    spacing: context.spacing6,
                    runSpacing: context.spacing6,
                    children: options.map((option) {
                      final isSelected = selectedValue == option;
                      final isAvailable = true; // Simplified for now

                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: isAvailable
                              ? () {
                                  setState(() {
                                    _tempSelections[attributeName] = option;
                                  });
                                }
                              : null,
                          borderRadius: BorderRadius.circular(6),
                          child: OsmeaComponents.container(
                            padding: EdgeInsets.symmetric(
                              horizontal: context.spacing12,
                              vertical: context.spacing8,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? OsmeaColors.black
                                  : (isAvailable
                                        ? OsmeaColors.white
                                        : OsmeaColors.grayMaterial[50]!),
                              border: Border.all(
                                color: isSelected
                                    ? OsmeaColors.black
                                    : (isAvailable
                                          ? OsmeaColors.black.withValues(
                                              alpha: 0.15,
                                            )
                                          : OsmeaColors.grayMaterial[300]!),
                                width: isSelected ? 1.5 : 0.5,
                              ),
                            ),
                            child: OsmeaComponents.text(
                              option.toUpperCase(),
                              textStyle: OsmeaTextStyle.bodySmall(context)
                                  .copyWith(
                                    color: isSelected
                                        ? OsmeaColors.white
                                        : (isAvailable
                                              ? OsmeaColors.black
                                              : OsmeaColors.grayMaterial[400]!),
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.5,
                                  ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            // Footer buttons - minimal
            OsmeaComponents.container(
              padding: EdgeInsets.all(context.spacing12),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: OsmeaColors.black.withValues(alpha: 0.1),
                    width: 0.5,
                  ),
                ),
              ),
              child: OsmeaComponents.column(
                children: [
                  if (_currentStep > 0) ...[
                    Material(
                      color: OsmeaColors.white,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _currentStep--;
                          });
                        },
                        borderRadius: BorderRadius.circular(6),
                        child: OsmeaComponents.container(
                          width: context.infinity,
                          height: 44,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: OsmeaColors.black,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: OsmeaComponents.center(
                            child: OsmeaComponents.text(
                              'PREVIOUS',
                              textStyle: OsmeaTextStyle.bodyMedium(context)
                                  .copyWith(
                                    color: OsmeaColors.black,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    OsmeaComponents.sizedBox(height: context.spacing8),
                  ],
                  Material(
                    color: selectedValue != null && selectedValue.isNotEmpty
                        ? OsmeaColors.black
                        : OsmeaColors.grayMaterial[300]!,
                    borderRadius: BorderRadius.circular(6),
                    child: InkWell(
                      onTap: selectedValue != null && selectedValue.isNotEmpty
                          ? () async {
                              if (isLastStep) {
                                final finalSelections =
                                    Map<String, String>.from(
                                      widget.state.selectedAttributes,
                                    );
                                finalSelections.addAll(_tempSelections);
                                // Close modal first
                                Navigator.of(context).pop();
                                // Wait a bit for modal to close
                                await Future.delayed(
                                  const Duration(milliseconds: 300),
                                );
                                // Then call onComplete
                                await widget.onComplete(finalSelections);
                              } else {
                                setState(() {
                                  _currentStep++;
                                });
                              }
                            }
                          : null,
                      borderRadius: BorderRadius.circular(6),
                      child: OsmeaComponents.container(
                        width: context.infinity,
                        height: 44,
                        child: OsmeaComponents.center(
                          child: OsmeaComponents.text(
                            isLastStep ? 'ADD TO CART' : 'NEXT',
                            textStyle: OsmeaTextStyle.bodyMedium(context)
                                .copyWith(
                                  color: OsmeaColors.white,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}