import 'package:core/core.dart';
import 'package:flutter/material.dart';
import '../widgets/common_appbar.dart';

/// 📏 **OSMEA Spacer Examples**
///
/// This file demonstrates various ways to use the OSMEA Spacer component,
/// which enables flexible space distribution within Row and Column layouts.
///
class SpacerExample extends StatelessWidget {
  const SpacerExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.scaffold(
      backgroundColor: OsmeaColors.white,
      appBar: const OsmeaComponentsAppBar(
        screenKey: 'spacer_example',
      ),
      body: OsmeaComponents.singleChildScrollView(
        padding: context.paddingNormal,
        child: OsmeaComponents.column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section title
            OsmeaComponents.text(
              '📏 Basic Spacers in Row',
              textStyle: OsmeaTextStyle.titleLarge(context)
                  .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            OsmeaComponents.sizedBox(height: 16),

            // Basic row with spacer example
            OsmeaComponents.text('Spacer pushing items apart:'),
            OsmeaComponents.sizedBox(height: 8),
            basicRowSpacerExample(context),
            OsmeaComponents.sizedBox(height: 24),

            // Multiple spacers example
            OsmeaComponents.text('Multiple spacers with different flex:'),
            OsmeaComponents.sizedBox(height: 8),
            multipleSpacersExample(context),
            OsmeaComponents.sizedBox(height: 24),

            // Section title for column spacers
            OsmeaComponents.text(
              '📏 Spacers in Column',
              textStyle: OsmeaTextStyle.titleLarge(context)
                  .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            OsmeaComponents.sizedBox(height: 16),

            // Column with spacers example
            OsmeaComponents.text('Spacers in a column:'),
            OsmeaComponents.sizedBox(height: 8),
            columnSpacersExample(context),
            OsmeaComponents.sizedBox(height: 24),

            // Section title for practical examples
            OsmeaComponents.text(
              '💡 Practical Use Cases',
              textStyle: OsmeaTextStyle.titleLarge(context)
                  .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            OsmeaComponents.sizedBox(height: 16),

            // App bar layout example
            OsmeaComponents.text('App bar-like layout:'),
            OsmeaComponents.sizedBox(height: 8),
            appBarLayoutExample(context),
            OsmeaComponents.sizedBox(height: 24),

            // Card with actions example
            OsmeaComponents.text('Card with actions:'),
            OsmeaComponents.sizedBox(height: 8),
            cardWithActionsExample(context),
            OsmeaComponents.sizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // Basic row with spacer example
  Widget basicRowSpacerExample(BuildContext context) {
    return OsmeaComponents.container(
      height: 60,
      color: OsmeaColors.ash,
      child: OsmeaComponents.row(
        children: [
          _buildColorBox(context, OsmeaColors.sunsetGlow, 'Left'),
          OsmeaComponents.spacer(), // Pushes the right box to the end
          _buildColorBox(context, OsmeaColors.nordicBlue, 'Right'),
        ],
      ),
    );
  }

  // Multiple spacers example
  Widget multipleSpacersExample(BuildContext context) {
    return OsmeaComponents.container(
      height: 60,
      color: OsmeaColors.ash,
      child: OsmeaComponents.row(
        children: [
          _buildColorBox(context, OsmeaColors.sunsetGlow, 'Left'),
          OsmeaComponents.spacer(flex: 1), // 1 part of space
          _buildColorBox(context, OsmeaColors.forestHeart, 'Middle'),
          OsmeaComponents.spacer(flex: 2), // 2 parts of space (twice as much)
          _buildColorBox(context, OsmeaColors.nordicBlue, 'Right'),
        ],
      ),
    );
  }

  // Column with spacers example
  Widget columnSpacersExample(BuildContext context) {
    return OsmeaComponents.container(
      height: 300,
      width: double.infinity,
      color: OsmeaColors.ash,
      child: OsmeaComponents.column(
        children: [
          _buildColorBox(context, OsmeaColors.sunsetGlow, 'Top'),
          OsmeaComponents.spacer(), // Pushes middle and bottom down
          _buildColorBox(context, OsmeaColors.forestHeart, 'Middle'),
          OsmeaComponents.spacer(flex: 2), // Extra space before bottom
          _buildColorBox(context, OsmeaColors.nordicBlue, 'Bottom'),
        ],
      ),
    );
  }

  // App bar layout example using spacers
  Widget appBarLayoutExample(BuildContext context) {
    return OsmeaComponents.container(
      height: 60,
      width: double.infinity,
      color: OsmeaColors.nordicBlue,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: OsmeaComponents.row(
        children: [
          const Icon(Icons.menu, color: OsmeaColors.white),
          OsmeaComponents.sizedBox(width: 16),
          OsmeaComponents.text(
            'App Title',
            textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
              color: OsmeaColors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          OsmeaComponents.spacer(), // Pushes actions to the end
          const Icon(Icons.search, color: OsmeaColors.white),
          OsmeaComponents.sizedBox(width: 16),
          const Icon(Icons.more_vert, color: OsmeaColors.white),
        ],
      ),
    );
  }

  // Card with actions using spacers
  Widget cardWithActionsExample(BuildContext context) {
    return Card(
      child: OsmeaComponents.padding(
        padding: const EdgeInsets.all(16),
        child: OsmeaComponents.column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OsmeaComponents.text(
              'Card Title',
              textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            OsmeaComponents.sizedBox(height: 8),
            OsmeaComponents.text(
              'This is the content of the card showing how to use spacers to layout buttons.',
            ),
            OsmeaComponents.sizedBox(height: 16),
            OsmeaComponents.row(
              children: [
                OsmeaComponents.button(
                  text: 'Cancel',
                  variant: ButtonVariant.outlined,
                  onPressed: () {},
                ),
                OsmeaComponents.spacer(), // Pushes the save button to the right
                OsmeaComponents.button(
                  text: 'Save',
                  variant: ButtonVariant.primary,
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper for creating color boxes
  Widget _buildColorBox(BuildContext context, Color color, String text) {
    return OsmeaComponents.container(
      width: 80,
      height: 60,
      color: color,
      child: OsmeaComponents.center(
        child: OsmeaComponents.text(
          text,
          textStyle: OsmeaTextStyle.bodyLarge(context).copyWith(
            color: OsmeaColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
