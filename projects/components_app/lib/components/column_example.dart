import 'package:core/core.dart';
import 'package:flutter/material.dart';
import '../widgets/common_appbar.dart';

class _DistributionItemStyle {
  const _DistributionItemStyle({
    this.height = 36,
    this.radius = 4,
    this.leftBorder = false,
    this.withShadow = false,
  });
  final int height;
  final int radius;
  final bool leftBorder;
  final bool withShadow;
}

/// 📊 **OSMEA Column Examples**
///
/// This file demonstrates various ways to use the OSMEA Column component.
/// Each example showcases different properties and customization options.
///
class ColumnExample extends StatelessWidget {
  const ColumnExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.scaffold(
      backgroundColor: OsmeaColors.white,
      appBar: const OsmeaComponentsAppBar(
        screenKey: 'column_example',
      ),
      body: OsmeaComponents.singleChildScrollView(
        padding: context.paddingNormal,
        child: OsmeaComponents.column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section title
            OsmeaComponents.text(
              '📊 Basic Columns',
              textStyle: OsmeaTextStyle.titleLarge(context)
                  .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            OsmeaComponents.sizedBox(height: 16),

            // Basic column example
            OsmeaComponents.text('Simple column:'),
            OsmeaComponents.sizedBox(height: 8),
            basicColumnExample(),
            OsmeaComponents.sizedBox(height: 24),

            // Column with alignment
            OsmeaComponents.text('Column with different alignments:'),
            OsmeaComponents.sizedBox(height: 8),
            alignmentColumnExamples(),
            OsmeaComponents.sizedBox(height: 24),

            // Section title for spacing
            OsmeaComponents.text(
              '📏 Spacing & Distribution',
              textStyle: OsmeaTextStyle.titleLarge(context)
                  .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            OsmeaComponents.sizedBox(height: 16),

            // Column with spacing
            OsmeaComponents.text('Column with automatic spacing:'),
            OsmeaComponents.sizedBox(height: 8),
            spacingColumnExample(),
            OsmeaComponents.sizedBox(height: 24),

            // Column with main axis distribution
            OsmeaComponents.text('Column with different distribution options:'),
            OsmeaComponents.sizedBox(height: 8),
            distributionColumnExamples(),
            OsmeaComponents.sizedBox(height: 24),

            // Section title for wrapping
            OsmeaComponents.text(
              '🔀 Wrapping Columns',
              textStyle: OsmeaTextStyle.titleLarge(context)
                  .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            OsmeaComponents.sizedBox(height: 16),

            // Wrapping column examples
            OsmeaComponents.text('Column with wrapping enabled:'),
            OsmeaComponents.sizedBox(height: 8),
            wrappingColumnExample(context),
            OsmeaComponents.sizedBox(height: 24),

            // Section title for styling
            OsmeaComponents.text(
              '🎨 Column Styling',
              textStyle: OsmeaTextStyle.titleLarge(context)
                  .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            OsmeaComponents.sizedBox(height: 16),

            // Styled columns
            OsmeaComponents.text('Column with backgrounds and padding:'),
            OsmeaComponents.sizedBox(height: 8),
            styledColumnExample(context),
            OsmeaComponents.sizedBox(height: 24),

            // Section title for interactive columns
            OsmeaComponents.text(
              '👆 Interactive Columns',
              textStyle: OsmeaTextStyle.titleLarge(context)
                  .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            OsmeaComponents.sizedBox(height: 16),

            // Interactive columns
            OsmeaComponents.text('Column with tap events:'),
            OsmeaComponents.sizedBox(height: 8),
            interactiveColumnExamples(context),
            OsmeaComponents.sizedBox(height: 24),

            // Section title for advanced examples
            OsmeaComponents.text(
              '🧩 Advanced Usage',
              textStyle: OsmeaTextStyle.titleLarge(context)
                  .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            OsmeaComponents.sizedBox(height: 16),

            // Nested columns
            OsmeaComponents.text('Nested columns and mixed layouts:'),
            OsmeaComponents.sizedBox(height: 8),
            advancedColumnExample(context),
            OsmeaComponents.sizedBox(height: 32),

            // Column vs Flutter Column
            OsmeaComponents.text('OSMEA Column vs Flutter Column:'),
            OsmeaComponents.sizedBox(height: 8),
            comparisonExample(context),
          ],
        ),
      ),
    );
  }

  // Basic example of a column
  Widget basicColumnExample() {
    return OsmeaComponents.container(
      decoration: BoxDecoration(
        border: Border.all(color: OsmeaColors.platinum),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      child: OsmeaComponents.column(
        children: [
          OsmeaComponents.container(
            height: 40,
            color: OsmeaColors.nordicBlue.withValues(alpha: 0.1),
            alignment: Alignment.center,
            child: OsmeaComponents.text('Item 1'),
          ),
          OsmeaComponents.container(
            height: 40,
            color: OsmeaColors.nordicBlue.withValues(alpha: 0.2),
            alignment: Alignment.center,
            child: OsmeaComponents.text('Item 2'),
          ),
          OsmeaComponents.container(
            height: 40,
            color: OsmeaColors.nordicBlue.withValues(alpha: 0.3),
            alignment: Alignment.center,
            child: OsmeaComponents.text('Item 3'),
          ),
        ],
      ),
    );
  }

  // Example showing different alignment options
  Widget alignmentColumnExamples() {
    return OsmeaComponents.container(
      decoration: BoxDecoration(
        border: Border.all(color: OsmeaColors.platinum),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OsmeaComponents.text('Cross-axis start alignment:'),
          OsmeaComponents.sizedBox(height: 8),
          OsmeaComponents.container(
            height: 120,
            color: OsmeaColors.grey.shade100,
            padding: const EdgeInsets.all(8),
            child: OsmeaComponents.column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OsmeaComponents.container(
                  height: 30,
                  width: 150,
                  color: OsmeaColors.purple,
                  alignment: Alignment.center,
                  child: OsmeaComponents.text('Start'),
                ),
                OsmeaComponents.container(
                  height: 30,
                  width: 120,
                  color: OsmeaColors.purple,
                  alignment: Alignment.center,
                  child: OsmeaComponents.text('Start'),
                ),
                OsmeaComponents.container(
                  height: 30,
                  width: 90,
                  color: OsmeaColors.purple,
                  alignment: Alignment.center,
                  child: OsmeaComponents.text('Start'),
                ),
              ],
            ),
          ),
          OsmeaComponents.sizedBox(height: 16),
          OsmeaComponents.text('Cross-axis center alignment:'),
          OsmeaComponents.sizedBox(height: 8),
          OsmeaComponents.container(
            height: 120,
            color: OsmeaColors.grey.shade100,
            padding: const EdgeInsets.all(8),
            child: OsmeaComponents.column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                OsmeaComponents.container(
                  height: 30,
                  width: 150,
                  color: OsmeaColors.green.shade300,
                  alignment: Alignment.center,
                  child: OsmeaComponents.text('Center'),
                ),
                OsmeaComponents.container(
                  height: 30,
                  width: 120,
                  color: OsmeaColors.green.shade400,
                  alignment: Alignment.center,
                  child: OsmeaComponents.text('Center'),
                ),
                OsmeaComponents.container(
                  height: 30,
                  width: 90,
                  color: OsmeaColors.green.shade500,
                  alignment: Alignment.center,
                  child: OsmeaComponents.text('Center'),
                ),
              ],
            ),
          ),
          OsmeaComponents.sizedBox(height: 16),
          OsmeaComponents.text('Cross-axis end alignment:'),
          OsmeaComponents.sizedBox(height: 8),
          OsmeaComponents.container(
            height: 120,
            color: OsmeaColors.grey.shade100,
            padding: const EdgeInsets.all(8),
            child: OsmeaComponents.column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                OsmeaComponents.container(
                  height: 30,
                  width: 150,
                  color: OsmeaColors.orange.shade300,
                  alignment: Alignment.center,
                  child: OsmeaComponents.text('End'),
                ),
                OsmeaComponents.container(
                  height: 30,
                  width: 120,
                  color: OsmeaColors.orange.shade400,
                  alignment: Alignment.center,
                  child: OsmeaComponents.text('End'),
                ),
                OsmeaComponents.container(
                  height: 30,
                  width: 90,
                  color: OsmeaColors.orange.shade500,
                  alignment: Alignment.center,
                  child: OsmeaComponents.text('End'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Example showing automatic spacing between items
  Widget spacingColumnExample() {
    return OsmeaComponents.container(
      decoration: BoxDecoration(
        border: Border.all(color: OsmeaColors.platinum),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OsmeaComponents.text('No spacing:'),
          OsmeaComponents.sizedBox(height: 8),
          OsmeaComponents.container(
            height: 150,
            color: OsmeaColors.grey.shade100,
            padding: const EdgeInsets.all(8),
            child: OsmeaComponents.column(
              children: [
                OsmeaComponents.container(
                    height: 30, color: OsmeaColors.meadow),
                OsmeaComponents.container(
                    height: 30, color: OsmeaColors.meadow),
                OsmeaComponents.container(
                    height: 30, color: OsmeaColors.meadow),
              ],
            ),
          ),
          OsmeaComponents.sizedBox(height: 16),
          OsmeaComponents.text('With 8px spacing (using SizedBox):'),
          OsmeaComponents.sizedBox(height: 8),
          OsmeaComponents.container(
            height: 150,
            color: OsmeaColors.grey.shade100,
            padding: const EdgeInsets.all(8),
            child: OsmeaComponents.column(
              children: [
                OsmeaComponents.container(
                    height: 30,
                    color: OsmeaColors.goldenHour.withValues(alpha: 0.3)),
                OsmeaComponents.sizedBox(height: 8),
                OsmeaComponents.container(
                    height: 30,
                    color: OsmeaColors.goldenHour.withValues(alpha: 0.4)),
                OsmeaComponents.sizedBox(height: 8),
                OsmeaComponents.container(
                    height: 30,
                    color: OsmeaColors.goldenHour.withValues(alpha: 0.5)),
              ],
            ),
          ),
          OsmeaComponents.sizedBox(height: 16),
          OsmeaComponents.text('With 16px spacing (using SizedBox):'),
          OsmeaComponents.sizedBox(height: 8),
          OsmeaComponents.container(
            height: 150,
            color: OsmeaColors.grey.shade100,
            padding: const EdgeInsets.all(8),
            child: OsmeaComponents.column(
              children: [
                OsmeaComponents.container(
                    height: 30, color: OsmeaColors.orange.shade300),
                OsmeaComponents.sizedBox(height: 16),
                OsmeaComponents.container(
                    height: 30, color: OsmeaColors.orange.shade400),
                OsmeaComponents.sizedBox(height: 16),
                OsmeaComponents.container(
                    height: 30, color: OsmeaColors.orange.shade500),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Example showing different main axis distribution options
  Widget distributionColumnExamples() {
    return OsmeaComponents.container(
      decoration: BoxDecoration(
        border: Border.all(color: OsmeaColors.platinum),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildDistributionRow(
            'MainAxisAlignment.start',
            'Items aligned at top',
            MainAxisAlignment.start,
            OsmeaColors.azureWave,
            _DistributionItemStyle(height: 32, radius: 4),
          ),
          OsmeaComponents.sizedBox(height: 20),
          _buildDistributionRow(
            'MainAxisAlignment.center',
            'Items centered vertically',
            MainAxisAlignment.center,
            OsmeaColors.sunsetGlow,
            _DistributionItemStyle(height: 36, radius: 18),
          ),
          OsmeaComponents.sizedBox(height: 20),
          _buildDistributionRow(
            'MainAxisAlignment.end',
            'Items aligned at bottom',
            MainAxisAlignment.end,
            OsmeaColors.goldenHour,
            _DistributionItemStyle(height: 34, radius: 8, leftBorder: true),
          ),
          OsmeaComponents.sizedBox(height: 20),
          _buildDistributionRow(
            'MainAxisAlignment.spaceBetween',
            'Equal space between items',
            MainAxisAlignment.spaceBetween,
            OsmeaColors.forestHeart,
            _DistributionItemStyle(height: 38, radius: 12, withShadow: true),
          ),
          OsmeaComponents.sizedBox(height: 20),
          _buildDistributionRow(
            'MainAxisAlignment.spaceEvenly',
            'Space distributed evenly',
            MainAxisAlignment.spaceEvenly,
            OsmeaColors.nordicBlue,
            _DistributionItemStyle(height: 36, radius: 6),
          ),
        ],
      ),
    );
  }

  Widget _buildDistributionRow(
    String label,
    String hint,
    MainAxisAlignment alignment,
    Color baseColor,
    _DistributionItemStyle itemStyle,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: OsmeaColors.black,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          hint,
          style: TextStyle(
            fontSize: 12,
            color: OsmeaColors.pewter,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 150,
          decoration: BoxDecoration(
            color: OsmeaColors.snow,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: OsmeaColors.silver),
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: alignment,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _distributionItem(baseColor, 'A', itemStyle),
              _distributionItem(
                  baseColor.withValues(alpha: 0.85), 'B', itemStyle),
              _distributionItem(
                  baseColor.withValues(alpha: 0.7), 'C', itemStyle),
            ],
          ),
        ),
      ],
    );
  }

  Widget _distributionItem(
      Color color, String text, _DistributionItemStyle style) {
    return Container(
      height: style.height.toDouble(),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(style.radius.toDouble()),
        border: style.leftBorder
            ? Border(
                left: BorderSide(color: OsmeaColors.eclipse, width: 4),
                top: BorderSide(color: OsmeaColors.platinum),
                right: BorderSide(color: OsmeaColors.platinum),
                bottom: BorderSide(color: OsmeaColors.platinum),
              )
            : Border.all(color: OsmeaColors.platinum),
        boxShadow: style.withShadow
            ? [
                BoxShadow(
                  color: OsmeaColors.shadowLight,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: const TextStyle(
          color: OsmeaColors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  // Example showing wrapping capabilities
  Widget wrappingColumnExample(BuildContext context) {
    return OsmeaComponents.container(
      decoration: BoxDecoration(
        border: Border.all(color: OsmeaColors.platinum),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OsmeaComponents.text('Standard Column:'),
          OsmeaComponents.sizedBox(height: 8),
          OsmeaComponents.container(
            width: 200,
            height: 200,
            color: OsmeaColors.grey.shade100,
            padding: const EdgeInsets.all(8),
            child: OsmeaComponents.column(
              children: [
                for (int i = 0; i < 5; i++)
                  OsmeaComponents.container(
                    height: 30,
                    width: double.infinity,
                    color:
                        OsmeaColors.nordicBlue.withValues(alpha: 0.1 * (i + 1)),
                    alignment: Alignment.center,
                    child: OsmeaComponents.text('Item ${i + 1}'),
                  ),
              ],
            ),
          ),
          OsmeaComponents.sizedBox(height: 16),
          OsmeaComponents.text('Wrapping Column (using Flutter Wrap):'),
          OsmeaComponents.sizedBox(height: 8),
          OsmeaComponents.container(
            width: 200,
            height: 200,
            color: OsmeaColors.grey.shade100,
            padding: const EdgeInsets.all(8),
            child: OsmeaComponents.wrap(
              direction: Axis.vertical,
              spacing: 8,
              runSpacing: 8,
              children: [
                for (int i = 0; i < 12; i++)
                  OsmeaComponents.container(
                    height: 30,
                    width: 50,
                    color: OsmeaColors.purple
                        .withValues(alpha: (0.3 + (i * 0.1)).clamp(0.0, 1.0)),
                    alignment: Alignment.center,
                    child: OsmeaComponents.text(
                      '${i + 1}',
                      textStyle: OsmeaTextStyle.bodyLarge(context)
                          .copyWith(color: OsmeaColors.white),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Example showing styled columns
  Widget styledColumnExample(BuildContext context) {
    return OsmeaComponents.container(
      decoration: BoxDecoration(
        border: Border.all(color: OsmeaColors.platinum),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OsmeaComponents.text(
              'Column with background and padding (using Container):'),
          OsmeaComponents.sizedBox(height: 8),
          OsmeaComponents.container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  OsmeaColors.blue.withValues(alpha: 0.1),
                  OsmeaColors.blue.withValues(alpha: 0.3)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: OsmeaColors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: OsmeaComponents.column(
              children: [
                OsmeaComponents.container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: OsmeaColors.white.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  alignment: Alignment.center,
                  child: OsmeaComponents.text('Styled Item 1'),
                ),
                OsmeaComponents.sizedBox(height: 8),
                OsmeaComponents.container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: OsmeaColors.white.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  alignment: Alignment.center,
                  child: OsmeaComponents.text('Styled Item 2',
                      textStyle: OsmeaTextStyle.bodyLarge(context)
                          .copyWith(color: OsmeaColors.white)),
                ),
                OsmeaComponents.sizedBox(height: 8),
                OsmeaComponents.container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: OsmeaColors.white.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  alignment: Alignment.center,
                  child: OsmeaComponents.text('Styled Item 3',
                      textStyle: OsmeaTextStyle.bodyLarge(context)
                          .copyWith(color: OsmeaColors.white)),
                ),
              ],
            ),
          ),
          OsmeaComponents.sizedBox(height: 16),
          OsmeaComponents.text(
              'Column with margin and rounded corners (using Container):'),
          OsmeaComponents.sizedBox(height: 8),
          OsmeaComponents.container(
            decoration: BoxDecoration(
              color: OsmeaColors.meadow.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(8),
            child: OsmeaComponents.column(
              children: [
                OsmeaComponents.container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: OsmeaColors.meadow.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: OsmeaComponents.text('Item 1',
                      textStyle: OsmeaTextStyle.bodyLarge(context)
                          .copyWith(color: OsmeaColors.white)),
                ),
                OsmeaComponents.sizedBox(height: 12),
                OsmeaComponents.container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: OsmeaColors.meadow.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: OsmeaComponents.text('Item 2',
                      textStyle: OsmeaTextStyle.bodyLarge(context)
                          .copyWith(color: OsmeaColors.white)),
                ),
                OsmeaComponents.sizedBox(height: 12),
                OsmeaComponents.container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: OsmeaColors.meadow.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: OsmeaComponents.text('Item 3',
                      textStyle: OsmeaTextStyle.bodyLarge(context)
                          .copyWith(color: OsmeaColors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Example showing interactive columns
  Widget interactiveColumnExamples(BuildContext context) {
    return OsmeaComponents.container(
      decoration: BoxDecoration(
        border: Border.all(color: OsmeaColors.platinum),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OsmeaComponents.text('Tappable Column (using GestureDetector):'),
          OsmeaComponents.sizedBox(height: 8),
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: OsmeaComponents.text('Column tapped!')),
              );
            },
            child: OsmeaComponents.container(
              decoration: BoxDecoration(
                color: OsmeaColors.nordicBlue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(12),
              child: OsmeaComponents.column(
                children: [
                  OsmeaComponents.sizedBox(height: 8),
                  Icon(Icons.touch_app,
                      size: 32, color: OsmeaColors.nordicBlue),
                  OsmeaComponents.sizedBox(height: 8),
                  OsmeaComponents.text('Tap me!',
                      textStyle: OsmeaTextStyle.bodyLarge(context)
                          .copyWith(fontWeight: FontWeight.bold)),
                  OsmeaComponents.sizedBox(height: 8),
                  OsmeaComponents.text('This entire column is tappable',
                      textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
          OsmeaComponents.sizedBox(height: 16),
          OsmeaComponents.text(
              'Individual tappable items (using GestureDetector):'),
          OsmeaComponents.sizedBox(height: 8),
          OsmeaComponents.container(
            decoration: BoxDecoration(
              color: OsmeaColors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(8),
            child: OsmeaComponents.column(
              children: [
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: OsmeaComponents.text('Item 1 tapped!')),
                    );
                  },
                  child: OsmeaComponents.container(
                    decoration: BoxDecoration(
                      color: OsmeaColors.purple.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: OsmeaComponents.column(
                      children: [
                        OsmeaComponents.sizedBox(height: 8),
                        const Icon(Icons.touch_app, color: OsmeaColors.purple),
                        OsmeaComponents.sizedBox(height: 8),
                        OsmeaComponents.text('Tap',
                            textAlign: TextAlign.center),
                        OsmeaComponents.sizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
                OsmeaComponents.sizedBox(height: 8),
                GestureDetector(
                  onLongPress: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                              OsmeaComponents.text('Item 2 long pressed!')),
                    );
                  },
                  child: OsmeaComponents.container(
                    decoration: BoxDecoration(
                      color: OsmeaColors.blue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: OsmeaComponents.column(
                      children: [
                        OsmeaComponents.sizedBox(height: 8),
                        const Icon(Icons.push_pin, color: OsmeaColors.blue),
                        OsmeaComponents.sizedBox(height: 8),
                        OsmeaComponents.text('Long press',
                            textAlign: TextAlign.center),
                        OsmeaComponents.sizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
                OsmeaComponents.sizedBox(height: 8),
                GestureDetector(
                  onDoubleTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                              OsmeaComponents.text('Item 3 double tapped!')),
                    );
                  },
                  child: OsmeaComponents.container(
                    decoration: BoxDecoration(
                      color: OsmeaColors.meadow.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: OsmeaComponents.column(
                      children: [
                        OsmeaComponents.sizedBox(height: 8),
                        Icon(Icons.touch_app, color: OsmeaColors.meadow),
                        OsmeaComponents.sizedBox(height: 8),
                        OsmeaComponents.text('Double tap',
                            textAlign: TextAlign.center),
                        OsmeaComponents.sizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Advanced usage example
  Widget advancedColumnExample(BuildContext context) {
    return OsmeaComponents.container(
      decoration: BoxDecoration(
        border: Border.all(color: OsmeaColors.platinum),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      child: OsmeaComponents.container(
        decoration: BoxDecoration(
          color: OsmeaColors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(16),
        child: OsmeaComponents.column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            OsmeaComponents.text('Nested Layout Example',
                textStyle: OsmeaTextStyle.bodyLarge(context)
                    .copyWith(fontSize: 18, fontWeight: FontWeight.bold)),
            OsmeaComponents.sizedBox(height: 16),
            OsmeaComponents.container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: OsmeaColors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: OsmeaColors.black
                        .withValues(red: 0, green: 0, blue: 0, alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: OsmeaComponents.column(
                children: [
                  OsmeaComponents.row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OsmeaComponents.container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: OsmeaColors.goldenHour,
                          shape: BoxShape.circle,
                        ),
                        child: OsmeaComponents.center(
                          child: const Icon(Icons.person,
                              color: OsmeaColors.white),
                        ),
                      ),
                      OsmeaComponents.sizedBox(width: 12),
                      OsmeaComponents.expanded(
                        child: OsmeaComponents.column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            OsmeaComponents.text('John Doe',
                                textStyle: OsmeaTextStyle.bodyLarge(context)
                                    .copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                            OsmeaComponents.sizedBox(height: 4),
                            OsmeaComponents.text('Designer & Developer',
                                textStyle: OsmeaTextStyle.bodyLarge(context)
                                    .copyWith(color: OsmeaColors.grey)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  OsmeaComponents.sizedBox(height: 12),
                  OsmeaComponents.divider(),
                  OsmeaComponents.sizedBox(height: 8),
                  OsmeaComponents.row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      OsmeaComponents.column(
                        children: [
                          const Icon(Icons.message, color: OsmeaColors.blue),
                          OsmeaComponents.sizedBox(height: 4),
                          OsmeaComponents.text('Message',
                              textStyle: OsmeaTextStyle.bodyLarge(context)
                                  .copyWith(fontSize: 12)),
                        ],
                      ),
                      OsmeaComponents.column(
                        children: [
                          const Icon(Icons.call, color: OsmeaColors.green),
                          OsmeaComponents.sizedBox(height: 4),
                          OsmeaComponents.text('Call',
                              textStyle: OsmeaTextStyle.bodyLarge(context)
                                  .copyWith(fontSize: 12)),
                        ],
                      ),
                      OsmeaComponents.column(
                        children: [
                          const Icon(Icons.video_call,
                              color: OsmeaColors.purple),
                          OsmeaComponents.sizedBox(height: 4),
                          OsmeaComponents.text('Video',
                              textStyle: OsmeaTextStyle.bodyLarge(context)
                                  .copyWith(fontSize: 12)),
                        ],
                      ),
                      OsmeaComponents.column(
                        children: [
                          const Icon(Icons.share, color: OsmeaColors.orange),
                          OsmeaComponents.sizedBox(height: 4),
                          OsmeaComponents.text('Share'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            OsmeaComponents.sizedBox(height: 16),
            OsmeaComponents.container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: OsmeaColors.blue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: OsmeaComponents.text(
                'This example demonstrates nesting columns and rows to create complex layouts.',
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Comparison between OSMEA Column and Flutter Column
  Widget comparisonExample(BuildContext context) {
    return OsmeaComponents.container(
      decoration: BoxDecoration(
        border: Border.all(color: OsmeaColors.platinum),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OsmeaComponents.row(
            children: [
              OsmeaComponents.expanded(
                child: OsmeaComponents.column(
                  children: [
                    OsmeaComponents.text('OSMEA Column',
                        textStyle: OsmeaTextStyle.bodyLarge(context)
                            .copyWith(fontWeight: FontWeight.bold)),
                    OsmeaComponents.sizedBox(height: 8),
                    OsmeaComponents.container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: OsmeaColors.blue.withValues(alpha: 0.1),
                        border: Border.all(
                            color: OsmeaColors.blue.withValues(alpha: 0.3)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: OsmeaComponents.column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          for (int i = 1; i <= 3; i++)
                            OsmeaComponents.container(
                              height: 40,
                              color: i == 1
                                  ? OsmeaColors.blue.withValues(alpha: 0.1)
                                  : (i == 2
                                      ? OsmeaColors.blue.withValues(alpha: 0.2)
                                      : OsmeaColors.blue
                                          .withValues(alpha: 0.3)),
                              alignment: Alignment.center,
                              child: OsmeaComponents.text('Item $i',
                                  textStyle: OsmeaTextStyle.bodyLarge(context)),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              OsmeaComponents.sizedBox(width: 16),
              OsmeaComponents.expanded(
                child: OsmeaComponents.column(
                  children: [
                    OsmeaComponents.text('Flutter Column',
                        textStyle: OsmeaTextStyle.bodyLarge(context)
                            .copyWith(fontWeight: FontWeight.bold)),
                    OsmeaComponents.sizedBox(height: 8),
                    OsmeaComponents.container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: OsmeaColors.green.withValues(alpha: 0.1),
                        border: Border.all(
                            color: OsmeaColors.green.withValues(alpha: 0.3)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: OsmeaComponents.column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          for (int i = 1; i <= 3; i++)
                            OsmeaComponents.container(
                              height: 40,
                              color: i == 1
                                  ? OsmeaColors.green.withValues(alpha: 0.1)
                                  : (i == 2
                                      ? OsmeaColors.green.withValues(alpha: 0.2)
                                      : OsmeaColors.green
                                          .withValues(alpha: 0.3)),
                              alignment: Alignment.center,
                              child: OsmeaComponents.text('Item $i',
                                  textStyle: OsmeaTextStyle.bodyLarge(context)),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          OsmeaComponents.sizedBox(height: 16),
          OsmeaComponents.container(
            decoration: BoxDecoration(
              color: OsmeaColors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(12),
            child: OsmeaComponents.text(
              'OSMEA Column provides the same API as Flutter\'s Column while following the OSMEA design system.',
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
