import 'package:core/core.dart';
import 'package:flutter/material.dart';
import '../widgets/common_appbar.dart';

/// 🔄 **OSMEA Row Examples**
///
/// This file demonstrates various ways to use the OSMEA Row component,
/// which follows Flutter's Row API.
///
class RowExample extends StatelessWidget {
  const RowExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.scaffold(
      backgroundColor: OsmeaColors.white,
      appBar: const OsmeaComponentsAppBar(
        screenKey: 'row_example',
      ),
      body: OsmeaComponents.singleChildScrollView(
        padding: context.paddingNormal,
        child: OsmeaComponents.column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section title
            OsmeaComponents.text(
              '🔄 Basic Rows',
              textStyle: OsmeaTextStyle.titleLarge(context)
                  .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            OsmeaComponents.sizedBox(height: 16),

            // Basic row example
            OsmeaComponents.text('Simple row:'),
            OsmeaComponents.sizedBox(height: 8),
            basicRowExample(),
            OsmeaComponents.sizedBox(height: 24),

            // Row with alignment
            OsmeaComponents.text('Row with different alignments:'),
            OsmeaComponents.sizedBox(height: 8),
            alignmentRowExamples(),
            OsmeaComponents.sizedBox(height: 24),

            // Section title for spacing
            OsmeaComponents.text(
              '📏 Spacing & Distribution (Using Composition)',
              textStyle: OsmeaTextStyle.titleLarge(context)
                  .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            OsmeaComponents.sizedBox(height: 16),

            // Row with spacing
            OsmeaComponents.text('Row with spacing using SizedBox:'),
            OsmeaComponents.sizedBox(height: 8),
            spacingRowExample(),
            OsmeaComponents.sizedBox(height: 24),

            // Row with main axis distribution
            OsmeaComponents.text('Row with different distribution options:'),
            OsmeaComponents.sizedBox(height: 8),
            distributionRowExamples(),
            OsmeaComponents.sizedBox(height: 24),

            // Section title for wrapping
            OsmeaComponents.text(
              '🔀 Wrapping Rows (Using Composition)',
              textStyle: OsmeaTextStyle.titleLarge(context)
                  .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            OsmeaComponents.sizedBox(height: 16),

            // Wrapping row examples
            OsmeaComponents.text('Using Wrap instead of Row for wrapping:'),
            OsmeaComponents.sizedBox(height: 8),
            wrappingRowExample(),
            OsmeaComponents.sizedBox(height: 24),

            // Section title for styling
            OsmeaComponents.text(
              '🎨 Row Styling (Using Composition)',
              textStyle: OsmeaTextStyle.titleLarge(context)
                  .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            OsmeaComponents.sizedBox(height: 16),

            // Styled rows
            OsmeaComponents.text('Row with Container for styling:'),
            OsmeaComponents.sizedBox(height: 8),
            styledRowExample(),
            OsmeaComponents.sizedBox(height: 24),

            // Section title for interactive rows
            OsmeaComponents.text(
              '👆 Interactive Rows (Using Composition)',
              textStyle: OsmeaTextStyle.titleLarge(context)
                  .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            OsmeaComponents.sizedBox(height: 16),

            // Interactive rows
            OsmeaComponents.text('Row with GestureDetector for interaction:'),
            OsmeaComponents.sizedBox(height: 8),
            interactiveRowExamples(context),
            OsmeaComponents.sizedBox(height: 24),

            // Section title for advanced examples
            OsmeaComponents.text(
              '🚀 Advanced (Using Composition)',
              textStyle: OsmeaTextStyle.titleLarge(context)
                  .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            OsmeaComponents.sizedBox(height: 16),

            // Complex row combinations
            OsmeaComponents.text('Complex row combinations:'),
            OsmeaComponents.sizedBox(height: 8),
            complexRowExamples(context),
          ],
        ),
      ),
    );
  }

  // Basic row example
  Widget basicRowExample() {
    return OsmeaComponents.row(
      children: [
        OsmeaComponents.container(
          width: 50,
          height: 50,
          color: OsmeaColors.red,
        ),
        OsmeaComponents.container(
          width: 50,
          height: 50,
          color: OsmeaColors.forestHeart,
        ),
        OsmeaComponents.container(
          width: 50,
          height: 50,
          color: OsmeaColors.nordicBlue,
        ),
      ],
    );
  }

  // Row alignment examples
  Widget alignmentRowExamples() {
    return OsmeaComponents.column(
      children: [
        OsmeaComponents.container(
          color: OsmeaColors.ash,
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.only(bottom: 8),
          child: OsmeaComponents.row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildColorBox(OsmeaColors.red),
              _buildColorBox(OsmeaColors.forestHeart),
              _buildColorBox(OsmeaColors.nordicBlue),
            ],
          ),
        ),
        OsmeaComponents.container(
          color: OsmeaColors.ash,
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.only(bottom: 8),
          child: OsmeaComponents.row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildColorBox(OsmeaColors.sunsetGlow),
              _buildColorBox(OsmeaColors.forestHeart),
              _buildColorBox(OsmeaColors.nordicBlue),
            ],
          ),
        ),
        OsmeaComponents.container(
          color: OsmeaColors.ash,
          padding: const EdgeInsets.all(8),
          child: OsmeaComponents.row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildColorBox(OsmeaColors.sunsetGlow),
              _buildColorBox(OsmeaColors.forestHeart),
              _buildColorBox(OsmeaColors.nordicBlue),
            ],
          ),
        ),
      ],
    );
  }

  // Row with spacing example using SizedBox
  Widget spacingRowExample() {
    return OsmeaComponents.container(
      color: OsmeaColors.ash,
      padding: const EdgeInsets.all(16),
      child: OsmeaComponents.row(
        children: [
          _buildColorBox(OsmeaColors.sunsetGlow),
          OsmeaComponents.sizedBox(width: 16),
          _buildColorBox(OsmeaColors.forestHeart),
          OsmeaComponents.sizedBox(width: 16),
          _buildColorBox(OsmeaColors.nordicBlue),
          OsmeaComponents.sizedBox(width: 16),
          _buildColorBox(OsmeaColors.purple),
        ],
      ),
    );
  }

  // Row distribution examples
  Widget distributionRowExamples() {
    return OsmeaComponents.column(
      children: [
        OsmeaComponents.container(
          color: OsmeaColors.ash,
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.only(bottom: 8),
          width: double.infinity,
          child: OsmeaComponents.row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildColorBox(OsmeaColors.sunsetGlow),
              _buildColorBox(OsmeaColors.forestHeart),
              _buildColorBox(OsmeaColors.nordicBlue),
            ],
          ),
        ),
        OsmeaComponents.container(
          color: OsmeaColors.ash,
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.only(bottom: 8),
          width: double.infinity,
          child: OsmeaComponents.row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildColorBox(OsmeaColors.sunsetGlow),
              _buildColorBox(OsmeaColors.forestHeart),
              _buildColorBox(OsmeaColors.nordicBlue),
            ],
          ),
        ),
        OsmeaComponents.container(
          color: OsmeaColors.ash,
          padding: const EdgeInsets.all(8),
          width: double.infinity,
          child: OsmeaComponents.row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildColorBox(OsmeaColors.sunsetGlow),
              _buildColorBox(OsmeaColors.forestHeart),
              _buildColorBox(OsmeaColors.nordicBlue),
            ],
          ),
        ),
      ],
    );
  }

  // Wrapping row example using Wrap
  Widget wrappingRowExample() {
    return OsmeaComponents.container(
      color: OsmeaColors.ash,
      padding: const EdgeInsets.all(16),
      child: OsmeaComponents.wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          _buildColorBox(OsmeaColors.sunsetGlow),
          _buildColorBox(OsmeaColors.forestHeart),
          _buildColorBox(OsmeaColors.nordicBlue),
          _buildColorBox(OsmeaColors.purple),
          _buildColorBox(OsmeaColors.sunsetGlow),
          _buildColorBox(OsmeaColors.forestHeart),
          _buildColorBox(OsmeaColors.sunsetGlow),
          _buildColorBox(OsmeaColors.amberFlame),
        ],
      ),
    );
  }

  // Styled row example
  Widget styledRowExample() {
    return OsmeaComponents.column(
      children: [
        OsmeaComponents.container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: OsmeaColors.nordicBlue
                .withValues(red: 0, green: 122, blue: 255, alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: OsmeaColors.nordicBlue),
            boxShadow: [
              BoxShadow(
                color: OsmeaColors.nordicBlue
                    .withValues(red: 0, green: 122, blue: 255, alpha: 0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          margin: const EdgeInsets.only(bottom: 16),
          child: OsmeaComponents.row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildColorBox(OsmeaColors.sunsetGlow),
              OsmeaComponents.sizedBox(width: 16),
              _buildColorBox(OsmeaColors.forestHeart),
              OsmeaComponents.sizedBox(width: 16),
              _buildColorBox(OsmeaColors.nordicBlue),
            ],
          ),
        ),
        OsmeaComponents.container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                OsmeaColors.purple
                    .withValues(red: 156, green: 39, blue: 176, alpha: 0.3),
                OsmeaColors.sunsetGlow
                    .withValues(red: 233, green: 30, blue: 99, alpha: 0.3),
              ],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: OsmeaComponents.row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildColorBox(OsmeaColors.amberFlame),
              _buildColorBox(OsmeaColors.amberFlame),
              _buildColorBox(OsmeaColors.nordicBlue),
            ],
          ),
        ),
      ],
    );
  }

  // Interactive row examples
  Widget interactiveRowExamples(BuildContext context) {
    return OsmeaComponents.column(
      children: [
        GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: OsmeaComponents.text('Row tapped!')),
            );
          },
          child: OsmeaComponents.container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: OsmeaColors.ash,
              borderRadius: BorderRadius.circular(8),
            ),
            margin: const EdgeInsets.only(bottom: 16),
            child: OsmeaComponents.row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.touch_app),
                OsmeaComponents.sizedBox(width: 8),
                OsmeaComponents.text('Tap this row'),
                OsmeaComponents.sizedBox(width: 8),
                const Icon(Icons.touch_app),
              ],
            ),
          ),
        ),
        GestureDetector(
          onLongPress: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: OsmeaComponents.text('Row long-pressed!')),
            );
          },
          child: OsmeaComponents.container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: OsmeaColors.ash,
              borderRadius: BorderRadius.circular(8),
            ),
            child: OsmeaComponents.row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.touch_app),
                OsmeaComponents.sizedBox(width: 8),
                OsmeaComponents.text('Long press this row'),
                OsmeaComponents.sizedBox(width: 8),
                const Icon(Icons.touch_app),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Advanced row examples
  Widget complexRowExamples(BuildContext context) {
    return OsmeaComponents.container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: OsmeaColors.snow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: OsmeaColors.silver),
        boxShadow: [
          BoxShadow(
            color: OsmeaColors.black
                .withValues(red: 0, green: 0, blue: 0, alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: OsmeaComponents.column(
        children: [
          OsmeaComponents.container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: OsmeaColors.nordicBlue
                  .withValues(red: 0, green: 122, blue: 255, alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: OsmeaComponents.row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OsmeaComponents.row(
                  children: [
                    const Icon(Icons.account_circle, size: 32),
                    OsmeaComponents.sizedBox(width: 8),
                    OsmeaComponents.column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        OsmeaComponents.text(
                          'John Doe',
                          textStyle: OsmeaTextStyle.bodyLarge(context).copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        OsmeaComponents.text(
                          'Online',
                          textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                            fontSize: 12,
                            color: OsmeaColors.forestHeart,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                OsmeaComponents.row(
                  children: [
                    OsmeaComponents.iconButton(
                      icon: const Icon(Icons.call),
                      onPressed: () {},
                    ),
                    OsmeaComponents.iconButton(
                      icon: const Icon(Icons.videocam),
                      onPressed: () {},
                    ),
                    OsmeaComponents.iconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
          OsmeaComponents.container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: OsmeaColors.forestHeart
                  .withValues(red: 76, green: 175, blue: 80, alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: OsmeaComponents.row(
              children: [
                const Icon(Icons.shopping_cart, size: 24),
                OsmeaComponents.sizedBox(width: 8),
                OsmeaComponents.expanded(
                  child: OsmeaComponents.text('Your shopping cart'),
                ),
                OsmeaComponents.container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: OsmeaColors.forestHeart,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: OsmeaComponents.text(
                    '3 items',
                    textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                      color: OsmeaColors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
                OsmeaComponents.sizedBox(width: 8),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to create colored boxes
  Widget _buildColorBox(Color color) {
    return OsmeaComponents.container(
      width: 40,
      height: 40,
      color: color,
    );
  }
}
