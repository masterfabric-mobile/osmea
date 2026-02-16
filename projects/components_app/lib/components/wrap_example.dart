import 'package:core/core.dart';
import 'package:flutter/material.dart';
import '../widgets/common_appbar.dart';

/// 🧩 **OSMEA Wrap Examples**
///
/// This file demonstrates various ways to use the OSMEA Wrap component.
/// Each example showcases different properties and customization options.
///
class WrapExample extends StatelessWidget {
  const WrapExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.scaffold(
      backgroundColor: OsmeaColors.white,
      appBar: const OsmeaComponentsAppBar(
        screenKey: 'wrap_example',
      ),
      body: OsmeaComponents.singleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: OsmeaComponents.column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section title
            OsmeaComponents.text(
              '🧩 Basic Wrap',
              textStyle: OsmeaTextStyle.titleLarge(context)
                  .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            OsmeaComponents.sizedBox(height: 16),

            // Basic wrap example
            _buildExampleSection(
                context,
                'Basic Wrap',
                'Simple horizontal wrap that flows to the next line when out of space',
                _buildBasicWrap(context)),
            OsmeaComponents.sizedBox(height: 24),

            // Spacing example
            _buildExampleSection(
                context,
                'Wrap with Spacing',
                'Wrap with custom spacing between items and rows',
                _buildSpacingWrap(context)),
            OsmeaComponents.sizedBox(height: 24),

            // Alignment examples
            OsmeaComponents.text(
              '📏 Alignment',
              textStyle: OsmeaTextStyle.titleLarge(context)
                  .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            OsmeaComponents.sizedBox(height: 16),

            // Horizontal alignment
            _buildExampleSection(
                context,
                'Horizontal Alignment',
                'Different WrapAlignment options for horizontal alignment',
                _buildHorizontalAlignmentWrap(context)),
            OsmeaComponents.sizedBox(height: 24),

            // Run alignment
            _buildExampleSection(
                context,
                'Run Alignment',
                'Different WrapAlignment options for vertical (run) alignment',
                _buildRunAlignmentWrap(context)),
            OsmeaComponents.sizedBox(height: 24),

            // Cross-axis alignment
            _buildExampleSection(
                context,
                'Cross-Axis Alignment',
                'Different WrapCrossAlignment options for alignment within a row',
                _buildCrossAxisAlignmentWrap(context)),
            OsmeaComponents.sizedBox(height: 24),

            // Advanced examples
            OsmeaComponents.text(
              '🎨 Styled Wrap',
              textStyle: OsmeaTextStyle.titleLarge(context)
                  .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            OsmeaComponents.sizedBox(height: 16),

            // Vertical direction
            _buildExampleSection(
                context,
                'Vertical Direction',
                'Wrap with vertical direction instead of horizontal',
                _buildVerticalWrap(context)),
            OsmeaComponents.sizedBox(height: 24),

            // Practical examples
            _buildExampleSection(
                context,
                'Tag Cloud',
                'A practical use of Wrap for a tag/chip cloud',
                _buildTagCloud(context)),
            OsmeaComponents.sizedBox(height: 24),

            // Photos grid
            _buildExampleSection(context, 'Photo Grid',
                'A responsive photo grid using Wrap', _buildPhotoGrid(context)),
            OsmeaComponents.sizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildExampleSection(
      BuildContext context, String title, String description, Widget example) {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.text(
          title,
          textStyle: OsmeaTextStyle.titleMedium(context)
              .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        OsmeaComponents.sizedBox(height: 8),
        OsmeaComponents.text(
          description,
          textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(fontSize: 14),
          color: OsmeaColors.pewter,
        ),
        OsmeaComponents.sizedBox(height: 16),
        OsmeaComponents.container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: OsmeaColors.silver),
            borderRadius: BorderRadius.circular(8),
          ),
          child: example,
        ),
      ],
    );
  }

  // Basic wrap example
  Widget _buildBasicWrap(BuildContext context) {
    return OsmeaComponents.wrap(
      children: [
        for (int i = 1; i <= 10; i++)
          OsmeaComponents.container(
            width: 60,
            height: 60,
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: OsmeaColors.nordicBlue,
              borderRadius: BorderRadius.circular(8),
            ),
            child: OsmeaComponents.center(
              child: OsmeaComponents.text(
                '$i',
                textStyle: OsmeaTextStyle.bodyLarge(context).copyWith(
                  color: OsmeaColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  // Wrap with spacing example
  Widget _buildSpacingWrap(BuildContext context) {
    return OsmeaComponents.wrap(
      spacing: 16.0, // gap between items
      runSpacing: 16.0, // gap between rows
      children: [
        for (int i = 1; i <= 10; i++)
          OsmeaComponents.container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: OsmeaColors.forestHeart,
              borderRadius: BorderRadius.circular(8),
            ),
            child: OsmeaComponents.center(
              child: OsmeaComponents.text(
                '$i',
                textStyle: OsmeaTextStyle.bodyLarge(context).copyWith(
                  color: OsmeaColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  // Horizontal alignment example
  Widget _buildHorizontalAlignmentWrap(BuildContext context) {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.text('WrapAlignment.start:'),
        OsmeaComponents.sizedBox(height: 8),
        OsmeaComponents.container(
          color: OsmeaColors.ash.withValues(alpha: 0.2),
          width: double.infinity,
          child: OsmeaComponents.wrap(
            alignment: WrapAlignment.start,
            spacing: 8.0,
            runSpacing: 8.0,
            children: _buildColorBoxes(context, 5, OsmeaColors.nordicBlue),
          ),
        ),
        OsmeaComponents.sizedBox(height: 16),
        OsmeaComponents.text('WrapAlignment.center:'),
        OsmeaComponents.sizedBox(height: 8),
        OsmeaComponents.container(
          color: OsmeaColors.ash.withValues(alpha: 0.2),
          width: double.infinity,
          child: OsmeaComponents.wrap(
            alignment: WrapAlignment.center,
            spacing: 8.0,
            runSpacing: 8.0,
            children: _buildColorBoxes(context, 5, OsmeaColors.sunsetGlow),
          ),
        ),
        OsmeaComponents.sizedBox(height: 16),
        OsmeaComponents.text('WrapAlignment.end:'),
        OsmeaComponents.sizedBox(height: 8),
        OsmeaComponents.container(
          color: OsmeaColors.ash.withValues(alpha: 0.2),
          width: double.infinity,
          child: OsmeaComponents.wrap(
            alignment: WrapAlignment.end,
            spacing: 8.0,
            runSpacing: 8.0,
            children: _buildColorBoxes(context, 5, OsmeaColors.forestHeart),
          ),
        ),
      ],
    );
  }

  // Run alignment example
  Widget _buildRunAlignmentWrap(BuildContext context) {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.text('runAlignment: WrapAlignment.start:'),
        OsmeaComponents.sizedBox(height: 8),
        OsmeaComponents.container(
          color: OsmeaColors.ash.withValues(alpha: 0.2),
          height: 150,
          width: double.infinity,
          child: OsmeaComponents.wrap(
            runAlignment: WrapAlignment.start,
            spacing: 8.0,
            runSpacing: 8.0,
            children: _buildColorBoxes(context, 6, OsmeaColors.nordicBlue),
          ),
        ),
        OsmeaComponents.sizedBox(height: 16),
        OsmeaComponents.text('runAlignment: WrapAlignment.spaceBetween:'),
        OsmeaComponents.sizedBox(height: 8),
        OsmeaComponents.container(
          color: OsmeaColors.ash.withValues(alpha: 0.2),
          height: 150,
          width: double.infinity,
          child: OsmeaComponents.wrap(
            runAlignment: WrapAlignment.spaceBetween,
            spacing: 8.0,
            runSpacing: 8.0,
            children: _buildColorBoxes(context, 6, OsmeaColors.sunsetGlow),
          ),
        ),
      ],
    );
  }

  // Cross-axis alignment example
  Widget _buildCrossAxisAlignmentWrap(BuildContext context) {
    List<Widget> getBoxesWithVaryingHeights() {
      return [
        for (int i = 0; i < 5; i++)
          OsmeaComponents.container(
            width: 60,
            height: 40.0 + (i * 15),
            decoration: BoxDecoration(
              color:
                  i % 2 == 0 ? OsmeaColors.nordicBlue : OsmeaColors.sunsetGlow,
              borderRadius: BorderRadius.circular(4),
            ),
            child: OsmeaComponents.center(
              child: OsmeaComponents.text(
                '$i',
                textStyle: OsmeaTextStyle.bodyLarge(context).copyWith(
                  color: OsmeaColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ];
    }

    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.text('WrapCrossAlignment.start:'),
        OsmeaComponents.sizedBox(height: 8),
        OsmeaComponents.container(
          color: OsmeaColors.ash.withValues(alpha: 0.2),
          width: double.infinity,
          child: OsmeaComponents.wrap(
            crossAxisAlignment: WrapCrossAlignment.start,
            spacing: 8.0,
            runSpacing: 16.0,
            children: getBoxesWithVaryingHeights(),
          ),
        ),
        OsmeaComponents.sizedBox(height: 16),
        OsmeaComponents.text('WrapCrossAlignment.center:'),
        OsmeaComponents.sizedBox(height: 8),
        OsmeaComponents.container(
          color: OsmeaColors.ash.withValues(alpha: 0.2),
          width: double.infinity,
          child: OsmeaComponents.wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8.0,
            runSpacing: 16.0,
            children: getBoxesWithVaryingHeights(),
          ),
        ),
        OsmeaComponents.sizedBox(height: 16),
        OsmeaComponents.text('WrapCrossAlignment.end:'),
        OsmeaComponents.sizedBox(height: 8),
        OsmeaComponents.container(
          color: OsmeaColors.ash.withValues(alpha: 0.2),
          width: double.infinity,
          child: OsmeaComponents.wrap(
            crossAxisAlignment: WrapCrossAlignment.end,
            spacing: 8.0,
            runSpacing: 16.0,
            children: getBoxesWithVaryingHeights(),
          ),
        ),
      ],
    );
  }

  // Vertical wrap example
  Widget _buildVerticalWrap(BuildContext context) {
    return OsmeaComponents.sizedBox(
      height: 200,
      child: OsmeaComponents.wrap(
        direction: Axis.vertical,
        spacing: 8.0,
        runSpacing: 8.0,
        children: [
          for (int i = 1; i <= 12; i++)
            OsmeaComponents.container(
              width: 60,
              height: 40,
              decoration: BoxDecoration(
                color: i % 3 == 0
                    ? OsmeaColors.nordicBlue
                    : i % 3 == 1
                        ? OsmeaColors.sunsetGlow
                        : OsmeaColors.forestHeart,
                borderRadius: BorderRadius.circular(4),
              ),
              child: OsmeaComponents.center(
                child: OsmeaComponents.text(
                  '$i',
                  textStyle: OsmeaTextStyle.bodyLarge(context).copyWith(
                    color: OsmeaColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Tag cloud example
  Widget _buildTagCloud(BuildContext context) {
    final List<String> tags = [
      'Flutter',
      'UI',
      'Components',
      'Design',
      'OSMEA',
      'Mobile',
      'App',
      'Web',
      'Development',
      'Widget',
      'Layout',
      'Flexible',
      'Responsive',
    ];

    return OsmeaComponents.wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: tags.map((tag) {
        final color = tag.length % 3 == 0
            ? OsmeaColors.nordicBlue
            : tag.length % 3 == 1
                ? OsmeaColors.sunsetGlow
                : OsmeaColors.forestHeart;

        return OsmeaComponents.container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color),
          ),
          child: OsmeaComponents.text(
            tag,
            color: color,
            textStyle: OsmeaTextStyle.bodyMedium(context)
                .copyWith(fontWeight: FontWeight.w500, color: color),
          ),
        );
      }).toList(),
    );
  }

  // Photo grid example
  Widget _buildPhotoGrid(BuildContext context) {
    // Using mock colors to represent images
    final List<Color> colors = [
      OsmeaColors.nordicBlue,
      OsmeaColors.sunsetGlow,
      OsmeaColors.forestHeart,
      OsmeaColors.azureWave,
      OsmeaColors.goldenHour,
      OsmeaColors.deepSea,
      OsmeaColors.meadow,
      OsmeaColors.amberFlame,
    ];

    return OsmeaComponents.wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: colors.map((color) {
        return OsmeaComponents.container(
          width: (MediaQuery.of(context).size.width - 64) /
              3, // 3 photos per row with spacing
          height: 100,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                color: OsmeaColors.shadowLight,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: OsmeaComponents.center(
            child: Icon(
              Icons.image,
              size: 32,
              color: OsmeaColors.white.withValues(alpha: 0.8),
            ),
          ),
        );
      }).toList(),
    );
  }

  // Helper to build color boxes
  List<Widget> _buildColorBoxes(BuildContext context, int count, Color color) {
    return List.generate(
      count,
      (index) => OsmeaComponents.container(
        width: 60,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
        ),
        child: OsmeaComponents.center(
          child: OsmeaComponents.text(
            '${index + 1}',
            textStyle: OsmeaTextStyle.bodyLarge(context).copyWith(
              color: OsmeaColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
