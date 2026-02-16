import 'package:core/core.dart';
import 'package:flutter/material.dart';
import '../widgets/common_appbar.dart';

/// 📋 **OSMEA Collapse**
///
/// Comprehensive collapse component features.
/// Shows different variants, sizes, modes, and customization options.
///
/// {@category Examples}
/// {@subCategory Collapse}

class CollapseExample extends StatefulWidget {
  const CollapseExample({super.key});

  @override
  State<CollapseExample> createState() => _CollapseExampleState();
}

class _CollapseExampleState extends State<CollapseExample> {
  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.scaffold(
      backgroundColor: OsmeaColors.white,
      appBar: const OsmeaComponentsAppBar(
        screenKey: 'collapse_example',
      ),
      body: OsmeaComponents.singleChildScrollView(
        child: OsmeaComponents.padding(
          padding: const EdgeInsets.all(16.0),
          child: OsmeaComponents.column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Basic Collapse (Block Style)'),
              OsmeaComponents.sizedBox(height: 8),
              _buildBasicCollapse(),
              OsmeaComponents.sizedBox(height: 24),
              _buildSectionTitle('Card Style Collapse'),
              OsmeaComponents.sizedBox(height: 8),
              _buildCardCollapse(),
              OsmeaComponents.sizedBox(height: 24),
              _buildSectionTitle('Accordion Mode'),
              OsmeaComponents.sizedBox(height: 8),
              _buildAccordionCollapse(),
              OsmeaComponents.sizedBox(height: 24),
              _buildSectionTitle('Ghost Style'),
              OsmeaComponents.sizedBox(height: 8),
              _buildGhostCollapse(),
              OsmeaComponents.sizedBox(height: 24),
              _buildSectionTitle('Outlined Style'),
              OsmeaComponents.sizedBox(height: 8),
              _buildOutlinedCollapse(),
              OsmeaComponents.sizedBox(height: 24),
              _buildSectionTitle('Filled Style'),
              OsmeaComponents.sizedBox(height: 8),
              _buildFilledCollapse(),
              OsmeaComponents.sizedBox(height: 24),
              _buildSectionTitle('Different Sizes'),
              OsmeaComponents.sizedBox(height: 8),
              _buildSizeExamples(),
              OsmeaComponents.sizedBox(height: 24),
              _buildSectionTitle('With Icons and Custom Content'),
              OsmeaComponents.sizedBox(height: 8),
              _buildCustomContentCollapse(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return OsmeaComponents.text(
      title,
      variant: OsmeaTextVariant.headlineSmall,
      fontWeight: FontWeight.bold,
      color: OsmeaColors.nordicBlue,
    );
  }

  Widget _buildBasicCollapse() {
    return OsmeaComponents.collapse(
      size: CollapseSize.medium,
      variant: CollapseVariant.block,
      mode: CollapseBehaviorMode.multiple,
      children: [
        OsmeaCollapsePanel(
          header: 'What is OSMEA?',
          body: OsmeaComponents.padding(
            padding: const EdgeInsets.all(16.0),
            child: OsmeaComponents.text(
              'OSMEA is a comprehensive Flutter UI component library designed specifically for e-commerce applications. It provides a complete design system with consistent styling, accessibility features, and responsive design patterns.',
              variant: OsmeaTextVariant.bodyMedium,
            ),
          ),
        ),
        OsmeaCollapsePanel(
          header: 'Key Features',
          body: OsmeaComponents.padding(
            padding: const EdgeInsets.all(16.0),
            child: OsmeaComponents.column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OsmeaComponents.text(
                  '• Design Token System',
                  variant: OsmeaTextVariant.bodyMedium,
                ),
                OsmeaComponents.text(
                  '• Accessibility Support',
                  variant: OsmeaTextVariant.bodyMedium,
                ),
                OsmeaComponents.text(
                  '• Responsive Design',
                  variant: OsmeaTextVariant.bodyMedium,
                ),
                OsmeaComponents.text(
                  '• Dark/Light Theme',
                  variant: OsmeaTextVariant.bodyMedium,
                ),
              ],
            ),
          ),
        ),
        OsmeaCollapsePanel(
          header: 'Getting Started',
          body: OsmeaComponents.padding(
            padding: const EdgeInsets.all(16.0),
            child: OsmeaComponents.text(
              'To get started with OSMEA, simply add the package to your pubspec.yaml and import the components. The library provides a comprehensive set of pre-built components that follow Material Design 3 guidelines.',
              variant: OsmeaTextVariant.bodyMedium,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCardCollapse() {
    return OsmeaComponents.collapse(
      size: CollapseSize.medium,
      variant: CollapseVariant.card,
      mode: CollapseBehaviorMode.multiple,
      elevation: 2,
      children: [
        OsmeaCollapsePanel(
          header: 'Product Information',
          body: OsmeaComponents.padding(
            padding: const EdgeInsets.all(16.0),
            child: OsmeaComponents.column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OsmeaComponents.text(
                  'Product Details',
                  variant: OsmeaTextVariant.titleMedium,
                  fontWeight: FontWeight.bold,
                ),
                OsmeaComponents.sizedBox(height: 8),
                OsmeaComponents.text(
                  'This product includes detailed information: specifications, features, and usage instructions.',
                  variant: OsmeaTextVariant.bodyMedium,
                ),
              ],
            ),
          ),
        ),
        OsmeaCollapsePanel(
          header: 'Shipping Information',
          body: OsmeaComponents.padding(
            padding: const EdgeInsets.all(16.0),
            child: OsmeaComponents.text(
              'Free shipping on orders over \$50. Standard delivery takes 3-5 business days.',
              variant: OsmeaTextVariant.bodyMedium,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAccordionCollapse() {
    return OsmeaComponents.collapse(
      size: CollapseSize.medium,
      variant: CollapseVariant.accordion,
      mode: CollapseBehaviorMode.accordion,
      children: [
        OsmeaCollapsePanel(
          header: 'FAQ 1: How to install OSMEA?',
          value: 'faq1',
          body: OsmeaComponents.padding(
            padding: const EdgeInsets.all(16.0),
            child: OsmeaComponents.text(
              'Add osmea_components to your pubspec.yaml dependencies and run flutter pub get.',
              variant: OsmeaTextVariant.bodyMedium,
            ),
          ),
        ),
        OsmeaCollapsePanel(
          header: 'FAQ 2: Is OSMEA free to use?',
          value: 'faq2',
          body: OsmeaComponents.padding(
            padding: const EdgeInsets.all(16.0),
            child: OsmeaComponents.text(
              'Yes, OSMEA is open source and free to use in both personal and commercial projects.',
              variant: OsmeaTextVariant.bodyMedium,
            ),
          ),
        ),
        OsmeaCollapsePanel(
          header: 'FAQ 3: Does OSMEA support dark mode?',
          value: 'faq3',
          body: OsmeaComponents.padding(
            padding: const EdgeInsets.all(16.0),
            child: OsmeaComponents.text(
              'Yes, OSMEA includes full support for both light and dark themes with automatic switching.',
              variant: OsmeaTextVariant.bodyMedium,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGhostCollapse() {
    return OsmeaComponents.collapse(
      size: CollapseSize.medium,
      variant: CollapseVariant.ghost,
      mode: CollapseBehaviorMode.multiple,
      children: [
        OsmeaCollapsePanel(
          header: 'Minimal Style',
          body: OsmeaComponents.padding(
            padding: const EdgeInsets.all(16.0),
            child: OsmeaComponents.text(
              'This collapse uses the ghost variant for a minimal, clean appearance.',
              variant: OsmeaTextVariant.bodyMedium,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOutlinedCollapse() {
    return OsmeaComponents.collapse(
      size: CollapseSize.medium,
      variant: CollapseVariant.outlined,
      mode: CollapseBehaviorMode.multiple,
      borderColor: OsmeaColors.nordicBlue,
      children: [
        OsmeaCollapsePanel(
          header: 'Outlined Style',
          body: OsmeaComponents.padding(
            padding: const EdgeInsets.all(16.0),
            child: OsmeaComponents.text(
              'This collapse uses the outlined variant with a custom border color.',
              variant: OsmeaTextVariant.bodyMedium,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilledCollapse() {
    return OsmeaComponents.collapse(
      size: CollapseSize.medium,
      variant: CollapseVariant.filled,
      mode: CollapseBehaviorMode.multiple,
      children: [
        OsmeaCollapsePanel(
          header: 'Filled Style',
          body: OsmeaComponents.padding(
            padding: const EdgeInsets.all(16.0),
            child: OsmeaComponents.text(
              'This collapse uses the filled variant with a solid background color.',
              variant: OsmeaTextVariant.bodyMedium,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSizeExamples() {
    return OsmeaComponents.column(
      children: [
        OsmeaComponents.text(
          'Small Size',
          variant: OsmeaTextVariant.titleSmall,
          fontWeight: FontWeight.bold,
        ),
        OsmeaComponents.sizedBox(height: 8),
        OsmeaComponents.collapse(
          size: CollapseSize.small,
          variant: CollapseVariant.block,
          mode: CollapseBehaviorMode.multiple,
          children: [
            OsmeaCollapsePanel(
              header: 'Small Collapse',
              body: OsmeaComponents.padding(
                padding: const EdgeInsets.all(12.0),
                child: OsmeaComponents.text(
                  'This is a small-sized collapse component.',
                  variant: OsmeaTextVariant.bodySmall,
                ),
              ),
            ),
          ],
        ),
        OsmeaComponents.sizedBox(height: 16),
        OsmeaComponents.text(
          'Large Size',
          variant: OsmeaTextVariant.titleSmall,
          fontWeight: FontWeight.bold,
        ),
        OsmeaComponents.sizedBox(height: 8),
        OsmeaComponents.collapse(
          size: CollapseSize.large,
          variant: CollapseVariant.block,
          mode: CollapseBehaviorMode.multiple,
          children: [
            OsmeaCollapsePanel(
              header: 'Large Collapse',
              body: OsmeaComponents.padding(
                padding: const EdgeInsets.all(20.0),
                child: OsmeaComponents.text(
                  'This is a large-sized collapse component with more padding and larger text.',
                  variant: OsmeaTextVariant.bodyLarge,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCustomContentCollapse() {
    return OsmeaComponents.collapse(
      size: CollapseSize.medium,
      variant: CollapseVariant.block,
      mode: CollapseBehaviorMode.multiple,
      children: [
        OsmeaCollapsePanel(
          header: OsmeaComponents.row(
            children: [
              Icon(Icons.info, color: OsmeaColors.nordicBlue),
              OsmeaComponents.sizedBox(width: 8),
              OsmeaComponents.text(
                'Information Panel',
                variant: OsmeaTextVariant.titleMedium,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          body: OsmeaComponents.padding(
            padding: const EdgeInsets.all(16.0),
            child: OsmeaComponents.column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OsmeaComponents.text(
                  'Custom Header with Icon',
                  variant: OsmeaTextVariant.titleSmall,
                  fontWeight: FontWeight.bold,
                ),
                OsmeaComponents.sizedBox(height: 8),
                OsmeaComponents.text(
                  'This collapse panel shows custom header content with icons and rich formatting.',
                  variant: OsmeaTextVariant.bodyMedium,
                ),
                OsmeaComponents.sizedBox(height: 16),
                OsmeaComponents.button(
                  text: 'Action Button',
                  variant: ButtonVariant.primary,
                  size: ButtonSize.small,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: OsmeaComponents.text('Button pressed!'),
                        backgroundColor: OsmeaColors.green,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        OsmeaCollapsePanel(
          header: OsmeaComponents.row(
            children: [
              Icon(Icons.settings, color: OsmeaColors.sunsetGlow),
              OsmeaComponents.sizedBox(width: 8),
              OsmeaComponents.text(
                'Settings Panel',
                variant: OsmeaTextVariant.titleMedium,
                fontWeight: FontWeight.bold,
              ),
              const Spacer(),
              OsmeaComponents.badge(
                content: 'New',
                variant: BadgeVariant.success,
                size: BadgeSize.small,
              ),
            ],
          ),
          body: OsmeaComponents.padding(
            padding: const EdgeInsets.all(16.0),
            child: OsmeaComponents.column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OsmeaComponents.text(
                  'Advanced Header',
                  variant: OsmeaTextVariant.titleSmall,
                  fontWeight: FontWeight.bold,
                ),
                OsmeaComponents.sizedBox(height: 8),
                OsmeaComponents.text(
                  'This panel shows an advanced header with icon, text, and a badge indicator.',
                  variant: OsmeaTextVariant.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
