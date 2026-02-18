import 'package:core/core.dart';
import 'package:flutter/material.dart';
import '../widgets/common_appbar.dart';

/// 📏 **OSMEA FittedBox Examples**
///
/// This file demonstrates various ways to use the OSMEA FittedBox component.
/// Interactive dropdown selection for different fit modes.
///
class FittedBoxExample extends StatefulWidget {
  const FittedBoxExample({Key? key}) : super(key: key);

  @override
  State<FittedBoxExample> createState() => _FittedBoxExampleState();
}

class _FittedBoxExampleState extends State<FittedBoxExample> {
  BoxFit selectedBoxFit = BoxFit.contain;

  final List<BoxFit> boxFitOptions = [
    BoxFit.contain,
    BoxFit.cover,
    BoxFit.fill,
    BoxFit.fitWidth,
    BoxFit.fitHeight,
    BoxFit.none,
    BoxFit.scaleDown,
  ];

  final Map<BoxFit, String> boxFitLabels = {
    BoxFit.contain: 'BoxFit.contain',
    BoxFit.cover: 'BoxFit.cover',
    BoxFit.fill: 'BoxFit.fill',
    BoxFit.fitWidth: 'BoxFit.fitWidth',
    BoxFit.fitHeight: 'BoxFit.fitHeight',
    BoxFit.none: 'BoxFit.none',
    BoxFit.scaleDown: 'BoxFit.scaleDown',
  };

  final Map<BoxFit, String> boxFitDescriptions = {
    BoxFit.contain: 'Scale child to fit while maintaining aspect ratio',
    BoxFit.cover: 'Scale child to cover entire space',
    BoxFit.fill: 'Scale child to fill space, ignoring aspect ratio',
    BoxFit.fitWidth: 'Scale child to fit width',
    BoxFit.fitHeight: 'Scale child to fit height',
    BoxFit.none: 'No scaling, keep original size',
    BoxFit.scaleDown: 'Scale down only if needed',
  };

  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.scaffold(
      backgroundColor: OsmeaColors.white,
      appBar: const OsmeaComponentsAppBar(
        screenKey: 'fitted_box_example',
      ),
      body: OsmeaComponents.singleChildScrollView(
        child: OsmeaComponents.padding(
          padding: const EdgeInsets.all(16),
          child: OsmeaComponents.column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              OsmeaComponents.text(
                '📏 Interactive FittedBox',
                textStyle: OsmeaTextStyle.titleLarge(context)
                    .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              OsmeaComponents.sizedBox(height: 16),
              OsmeaComponents.text(
                'Select a BoxFit option to see how it affects the FittedBox.',
                textStyle:
                    OsmeaTextStyle.bodySmall(context).copyWith(fontSize: 14),
                color: OsmeaColors.pewter,
                textAlign: TextAlign.center,
              ),
              OsmeaComponents.sizedBox(height: 20),
              _buildInteractiveCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInteractiveCard() {
    return Card(
      elevation: 4,
      child: OsmeaComponents.padding(
        padding: const EdgeInsets.all(20),
        child: OsmeaComponents.column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Dropdown section
            _buildDropdownSection(),
            OsmeaComponents.sizedBox(height: 24),

            // Description
            OsmeaComponents.text(
              boxFitDescriptions[selectedBoxFit] ?? '',
              textStyle:
                  OsmeaTextStyle.bodySmall(context).copyWith(fontSize: 14),
              color: OsmeaColors.pewter,
              textAlign: TextAlign.center,
            ),
            OsmeaComponents.sizedBox(height: 24),

            // FittedBox examples
            _buildFittedBoxExamples(),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownSection() {
    return OsmeaComponents.column(
      children: [
        OsmeaComponents.text(
          'Select BoxFit Mode:',
          textStyle: OsmeaTextStyle.bodyLarge(context)
              .copyWith(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        OsmeaComponents.sizedBox(height: 12),
        OsmeaComponents.container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: OsmeaColors.silver),
            borderRadius: BorderRadius.circular(8),
            color: OsmeaColors.white,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<BoxFit>(
              value: selectedBoxFit,
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down, color: OsmeaColors.nordicBlue),
              elevation: 8,
              style: OsmeaTextStyle.bodyLarge(context).copyWith(
                color: OsmeaColors.slate,
                fontSize: 16,
              ),
              dropdownColor: OsmeaColors.white,
              onChanged: (BoxFit? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedBoxFit = newValue;
                  });
                }
              },
              items:
                  boxFitOptions.map<DropdownMenuItem<BoxFit>>((BoxFit value) {
                return DropdownMenuItem<BoxFit>(
                  value: value,
                  child: OsmeaComponents.text(
                    boxFitLabels[value] ?? '',
                    textStyle: OsmeaTextStyle.bodyMedium(context)
                        .copyWith(fontSize: 15),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFittedBoxExamples() {
    return OsmeaComponents.column(
      children: [
        OsmeaComponents.text(
          'FittedBox:',
          textStyle: OsmeaTextStyle.bodyLarge(context)
              .copyWith(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        OsmeaComponents.sizedBox(height: 16),

        // Small examples row
        OsmeaComponents.row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildFittedBoxExample('Text', _buildTextExample()),
            _buildFittedBoxExample('Icon', _buildIconExample()),
            _buildFittedBoxExample('Image', _buildImageExample()),
          ],
        ),

        OsmeaComponents.sizedBox(height: 24),

        // Large example
        _buildLargeFittedBoxExample(),
      ],
    );
  }

  Widget _buildFittedBoxExample(String label, Widget child) {
    return OsmeaComponents.column(
      children: [
        OsmeaComponents.text(
          label,
          textStyle: OsmeaTextStyle.labelMedium(context)
              .copyWith(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        OsmeaComponents.sizedBox(height: 6),
        OsmeaComponents.container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            border: Border.all(color: OsmeaColors.silver, width: 2),
            borderRadius: BorderRadius.circular(12),
            color: OsmeaColors.oceanMist.withValues(alpha: 0.3),
          ),
          child: OsmeaComponents.clipRRect(
            borderRadius: BorderRadius.circular(10),
            child: OsmeaComponents.fittedBox(
              fit: selectedBoxFit,
              child: child,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextExample() {
    return OsmeaComponents.container(
      width: 140,
      height: 70,
      decoration: BoxDecoration(
        color: OsmeaColors.sunsetGlow,
        borderRadius: BorderRadius.circular(8),
      ),
      child: OsmeaComponents.center(
        child: OsmeaComponents.text(
          'TEXT',
          textStyle: OsmeaTextStyle.bodyLarge(context).copyWith(
            color: OsmeaColors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildIconExample() {
    return OsmeaComponents.container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: OsmeaColors.forestHeart,
        borderRadius: BorderRadius.circular(8),
      ),
      child: OsmeaComponents.center(
        child: const Icon(
          Icons.star,
          color: OsmeaColors.white,
          size: 40,
        ),
      ),
    );
  }

  Widget _buildImageExample() {
    return OsmeaComponents.container(
      width: 120,
      height: 90,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [OsmeaColors.nordicBlue, OsmeaColors.crystalBay],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: OsmeaComponents.center(
        child: const Icon(
          Icons.image,
          color: OsmeaColors.white,
          size: 32,
        ),
      ),
    );
  }

  Widget _buildLargeFittedBoxExample() {
    return OsmeaComponents.column(
      children: [
        OsmeaComponents.text(
          'Large Container:',
          textStyle: OsmeaTextStyle.bodyLarge(context)
              .copyWith(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        OsmeaComponents.sizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            // Responsive dimensions based on available width
            final double containerWidth = constraints.maxWidth;
            final double containerHeight = containerWidth > 600 ? 250 : 200;

            // Child dimensions that scale with container
            final double childWidth =
                containerWidth * 0.6; // 60% of container width
            final double childHeight =
                containerHeight * 0.7; // 70% of container height

            // Responsive font and icon sizes
            final double iconSize = containerWidth > 600 ? 56 : 48;
            final double titleFontSize = containerWidth > 600 ? 28 : 24;
            final double subtitleFontSize = containerWidth > 600 ? 16 : 14;

            return OsmeaComponents.container(
              width: double.infinity,
              height: containerHeight,
              decoration: BoxDecoration(
                border: Border.all(color: OsmeaColors.silver, width: 2),
                borderRadius: BorderRadius.circular(16),
                color: OsmeaColors.crystalBay.withValues(alpha: 0.1),
              ),
              child: OsmeaComponents.clipRRect(
                borderRadius: BorderRadius.circular(14),
                child: OsmeaComponents.fittedBox(
                  fit: selectedBoxFit,
                  child: OsmeaComponents.container(
                    width: childWidth,
                    height: childHeight,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [OsmeaColors.meadow, OsmeaColors.springLeaf],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: OsmeaComponents.center(
                      child: OsmeaComponents.column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.widgets,
                            color: OsmeaColors.white,
                            size: iconSize,
                          ),
                          OsmeaComponents.sizedBox(height: 12),
                          OsmeaComponents.text(
                            'FITTED BOX',
                            textStyle:
                                OsmeaTextStyle.titleLarge(context).copyWith(
                              color: OsmeaColors.white,
                              fontSize: titleFontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          OsmeaComponents.sizedBox(height: 4),
                          OsmeaComponents.text(
                            boxFitLabels[selectedBoxFit] ?? '',
                            textStyle:
                                OsmeaTextStyle.bodyMedium(context).copyWith(
                              color: OsmeaColors.white,
                              fontSize: subtitleFontSize,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
