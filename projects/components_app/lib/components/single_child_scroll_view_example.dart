import 'package:core/core.dart';
import 'package:flutter/material.dart';
import '../widgets/common_appbar.dart';

/// 📜 **OSMEA SingleChildScrollView Examples**
///
/// This file demonstrates various ways to use the OSMEA SingleChildScrollView component.
/// Each example showcases different properties and customization options.
///
class SingleChildScrollViewExample extends StatelessWidget {
  const SingleChildScrollViewExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.scaffold(
      backgroundColor: OsmeaColors.white,
      appBar: const OsmeaComponentsAppBar(
        screenKey: 'single_child_scroll_view_example',
      ),
      body: OsmeaComponents.singleChildScrollView(
        child: OsmeaComponents.padding(
          padding: const EdgeInsets.all(16),
          child: OsmeaComponents.column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section title
              OsmeaComponents.text(
                '📜 Basic Scroll Views',
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              OsmeaComponents.sizedBox(height: 16),

              // Vertical scroll example
              _buildExampleCard(
                context,
                'Vertical Scrolling',
                'Standard vertical scroll view',
                _buildVerticalScrollExample(context),
              ),
              OsmeaComponents.sizedBox(height: 16),

              // Horizontal scroll example
              _buildExampleCard(
                context,
                'Horizontal Scrolling',
                'Single child scroll view with horizontal axis',
                _buildHorizontalScrollExample(context),
              ),
              OsmeaComponents.sizedBox(height: 16),

              // Nested scroll views
              _buildExampleCard(
                context,
                'Nested Scroll Views',
                'Combining horizontal and vertical scrolling',
                _buildNestedScrollExample(context),
              ),
              OsmeaComponents.sizedBox(height: 16),

              // Section title for advanced features
              OsmeaComponents.text(
                '🧰 Advanced Scroll Features',
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              OsmeaComponents.sizedBox(height: 16),

              // Custom physics example
              _buildExampleCard(
                context,
                'Custom Scroll Physics',
                'ScrollView with custom physics behavior',
                _buildCustomPhysicsScrollExample(context),
              ),
              OsmeaComponents.sizedBox(height: 16),

              // Styled scroll view
              _buildExampleCard(
                context,
                'Styled Scroll View',
                'ScrollView with custom styling and effects',
                _buildStyledScrollExample(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExampleCard(
      BuildContext context, String title, String description, Widget example) {
    return Card(
      elevation: 2,
      child: OsmeaComponents.padding(
        padding: const EdgeInsets.all(16),
        child: OsmeaComponents.column(
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
              textStyle:
                  OsmeaTextStyle.bodyMedium(context).copyWith(fontSize: 14),
              color: OsmeaColors.pewter,
            ),
            OsmeaComponents.sizedBox(height: 16),
            OsmeaComponents.container(
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(color: OsmeaColors.silver),
                borderRadius: BorderRadius.circular(8),
              ),
              child: OsmeaComponents.clipRRect(
                borderRadius: BorderRadius.circular(8),
                child: example,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Basic vertical scroll view example
  Widget _buildVerticalScrollExample(BuildContext context) {
    return OsmeaComponents.singleChildScrollView(
      child: OsmeaComponents.padding(
        padding: const EdgeInsets.all(16),
        child: OsmeaComponents.column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OsmeaComponents.text(
              'Vertical Scrolling',
              textStyle: OsmeaTextStyle.titleMedium(context)
                  .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            OsmeaComponents.sizedBox(height: 16),
            OsmeaComponents.text(
              'Vertical scrolling with SingleChildScrollView. Scroll down to see more content.',
            ),
            OsmeaComponents.sizedBox(height: 16),
            for (int i = 1; i <= 10; i++)
              OsmeaComponents.container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: i % 2 == 0
                      ? OsmeaColors.oceanMist
                      : OsmeaColors.crystalBay,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: OsmeaComponents.text('Scrollable Item #$i'),
              ),
          ],
        ),
      ),
    );
  }

  // Horizontal scroll view example
  Widget _buildHorizontalScrollExample(BuildContext context) {
    return OsmeaComponents.singleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: OsmeaComponents.padding(
        padding: const EdgeInsets.all(16),
        child: OsmeaComponents.row(
          children: [
            for (int i = 1; i <= 10; i++)
              OsmeaComponents.container(
                width: 150,
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color:
                      i % 2 == 0 ? OsmeaColors.meadow : OsmeaColors.springLeaf,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: OsmeaComponents.center(
                  child: OsmeaComponents.text(
                    'Horizontal Item #$i',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Nested scroll views example
  Widget _buildNestedScrollExample(BuildContext context) {
    return OsmeaComponents.singleChildScrollView(
      child: OsmeaComponents.padding(
        padding: const EdgeInsets.all(16),
        child: OsmeaComponents.column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OsmeaComponents.text(
              'Nested Scrolling',
              textStyle: OsmeaTextStyle.titleMedium(context)
                  .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            OsmeaComponents.sizedBox(height: 16),
            OsmeaComponents.text(
              'A vertical scroll view containing horizontal scroll views.',
            ),
            OsmeaComponents.sizedBox(height: 16),
            for (int section = 1; section <= 3; section++) ...[
              OsmeaComponents.text(
                'Section $section',
                textStyle: OsmeaTextStyle.bodyLarge(context)
                    .copyWith(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              OsmeaComponents.sizedBox(height: 8),
              OsmeaComponents.sizedBox(
                height: 100,
                child: OsmeaComponents.singleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: OsmeaComponents.row(
                    children: [
                      for (int i = 1; i <= 10; i++)
                        OsmeaComponents.container(
                          width: 100,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: section == 1
                                ? OsmeaColors.sunsetGlow
                                : section == 2
                                    ? OsmeaColors.forestHeart
                                    : OsmeaColors.nordicBlue,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: OsmeaComponents.center(
                            child: OsmeaComponents.text(
                              'Item $i',
                              textStyle: OsmeaTextStyle.bodyLarge(context)
                                  .copyWith(color: OsmeaColors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              OsmeaComponents.sizedBox(height: 16),
            ],
          ],
        ),
      ),
    );
  }

  // Example with custom physics
  Widget _buildCustomPhysicsScrollExample(BuildContext context) {
    return OsmeaComponents.singleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: OsmeaComponents.padding(
        padding: const EdgeInsets.all(16),
        child: OsmeaComponents.column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OsmeaComponents.text(
              'Custom Physics',
              textStyle: OsmeaTextStyle.titleMedium(context)
                  .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            OsmeaComponents.sizedBox(height: 16),
            OsmeaComponents.text(
              'This scroll view uses BouncingScrollPhysics for an iOS-style bouncing effect when reaching the edges.',
            ),
            OsmeaComponents.sizedBox(height: 16),
            for (int i = 1; i <= 10; i++)
              OsmeaComponents.container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: i % 2 == 0
                      ? OsmeaColors.goldenHour
                      : OsmeaColors.desertSand,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: OsmeaComponents.text('Bouncy Item #$i'),
              ),
          ],
        ),
      ),
    );
  }

  // Example with styling
  Widget _buildStyledScrollExample(BuildContext context) {
    return OsmeaComponents.container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            OsmeaColors.nordicBlue.withValues(alpha: 0.1),
            OsmeaColors.sunsetGlow.withValues(alpha: 0.1),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: OsmeaComponents.singleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: OsmeaComponents.column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OsmeaComponents.text(
              'Styled Scroll',
              textStyle: OsmeaTextStyle.titleMedium(context)
                  .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            OsmeaComponents.sizedBox(height: 16),
            OsmeaComponents.text(
              'This scroll view has custom styling with a gradient background and styled items.',
            ),
            OsmeaComponents.sizedBox(height: 16),
            for (int i = 1; i <= 10; i++)
              OsmeaComponents.container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: OsmeaColors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: OsmeaColors.shadowLight,
                      offset: Offset(0, 2),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: OsmeaComponents.row(
                  children: [
                    OsmeaComponents.container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: i % 3 == 0
                            ? OsmeaColors.nordicBlue
                            : i % 2 == 0
                                ? OsmeaColors.forestHeart
                                : OsmeaColors.sunsetGlow,
                        shape: BoxShape.circle,
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
                    OsmeaComponents.sizedBox(width: 16),
                    OsmeaComponents.expanded(
                      child: OsmeaComponents.column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          OsmeaComponents.text(
                            'Item $i Title',
                            textStyle: OsmeaTextStyle.bodyLarge(context)
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          OsmeaComponents.sizedBox(height: 4),
                          OsmeaComponents.text(
                            'This is a styled scroll item with custom design.',
                            color: OsmeaColors.pewter,
                          ),
                        ],
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
