import 'package:core/core.dart';
import 'package:flutter/material.dart';
import '../widgets/common_appbar.dart';

class TextExample extends StatefulWidget {
  const TextExample({super.key});

  @override
  State<TextExample> createState() => _TextExampleState();
}

class _TextExampleState extends State<TextExample> {
  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.scaffold(
      backgroundColor: OsmeaColors.white,
      appBar: const OsmeaComponentsAppBar(
        screenKey: 'text_example',
      ),
      body: OsmeaComponents.singleChildScrollView(
        padding: context.paddingMedium,
        child: OsmeaComponents.column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display Text Examples
            _buildSection(
              'Display Text Styles',
              [
                OsmeaComponents.text(
                  'Display Large',
                  variant: OsmeaTextVariant.displayLarge,
                  color: OsmeaColors.nordicBlue,
                ),
                OsmeaComponents.sizedBox(height: 20),
                OsmeaComponents.text(
                  'Display Medium',
                  variant: OsmeaTextVariant.displayMedium,
                  color: OsmeaColors.deepSea,
                ),
                OsmeaComponents.sizedBox(height: 20),
                OsmeaComponents.text(
                  'Display Small',
                  variant: OsmeaTextVariant.displaySmall,
                  color: OsmeaColors.atlantic,
                ),
              ],
            ),

            // Headline Text Examples
            _buildSection(
              'Headline Text Styles',
              [
                OsmeaComponents.text(
                  'Headline Large - Section Title',
                  variant: OsmeaTextVariant.headlineLarge,
                  color: OsmeaColors.eclipse,
                ),
                OsmeaComponents.sizedBox(height: 8),
                OsmeaComponents.text(
                  'Headline Medium - Page Title',
                  variant: OsmeaTextVariant.headlineMedium,
                  color: OsmeaColors.pewter,
                ),
                OsmeaComponents.sizedBox(height: 8),
                OsmeaComponents.text(
                  'Headline Small - Card Title',
                  variant: OsmeaTextVariant.headlineSmall,
                  color: OsmeaColors.slate,
                ),
              ],
            ),

            // Title Text Examples
            _buildSection(
              'Title Text Styles',
              [
                OsmeaComponents.text(
                  'Title Large - Dialog Title',
                  variant: OsmeaTextVariant.titleLarge,
                  fontWeight: FontWeight.w600,
                ),
                OsmeaComponents.sizedBox(height: 8),
                OsmeaComponents.text(
                  'Title Medium - Component Title',
                  variant: OsmeaTextVariant.titleMedium,
                  fontWeight: FontWeight.w500,
                ),
                OsmeaComponents.sizedBox(height: 8),
                OsmeaComponents.text(
                  'Title Small - Section Title',
                  variant: OsmeaTextVariant.titleSmall,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),

            // Body Text Examples
            _buildSection(
              'Body Text Styles',
              [
                OsmeaComponents.text(
                  'Body Large - This is a larger body text used for main content paragraphs.',
                  variant: OsmeaTextVariant.bodyLarge,
                ),
                OsmeaComponents.sizedBox(height: 8),
                OsmeaComponents.text(
                  'Body Medium - This is the standard body text used for most content.',
                  variant: OsmeaTextVariant.bodyMedium,
                ),
                OsmeaComponents.sizedBox(height: 8),
                OsmeaComponents.text(
                  'Body Small - This is smaller body text used for secondary information.',
                  variant: OsmeaTextVariant.bodySmall,
                ),
              ],
            ),

            // Label Text Examples
            _buildSection(
              'Label Text Styles',
              [
                OsmeaComponents.text(
                  'Label Large - Form Field Label',
                  variant: OsmeaTextVariant.labelLarge,
                  color: OsmeaColors.eclipse,
                ),
                OsmeaComponents.sizedBox(height: 8),
                OsmeaComponents.text(
                  'Label Medium - UI Element Label',
                  variant: OsmeaTextVariant.labelMedium,
                  color: OsmeaColors.pewter,
                ),
                OsmeaComponents.sizedBox(height: 8),
                OsmeaComponents.text(
                  'Label Small - Compact Label',
                  variant: OsmeaTextVariant.labelSmall,
                  color: OsmeaColors.steel,
                ),
              ],
            ),

            // Caption Text Examples
            _buildSection(
              'Caption Text Styles',
              [
                OsmeaComponents.text(
                  'Caption Large - Important supplementary information',
                  variant: OsmeaTextVariant.captionLarge,
                  color: OsmeaColors.steel,
                ),
                OsmeaComponents.sizedBox(height: 8),
                OsmeaComponents.text(
                  'Caption Medium - Standard caption text',
                  variant: OsmeaTextVariant.captionMedium,
                  color: OsmeaColors.ash,
                ),
                OsmeaComponents.sizedBox(height: 8),
                OsmeaComponents.text(
                  'Caption Small - Minimal caption',
                  variant: OsmeaTextVariant.captionSmall,
                  color: OsmeaColors.silver,
                ),
              ],
            ),

            // Link Text Examples
            _buildSection(
              'Link Text Styles',
              [
                OsmeaComponents.text(
                  'Link Large - Click here for more info',
                  variant: OsmeaTextVariant.linkLarge,
                  color: OsmeaColors.nordicBlue,
                  onTap: () => _showSnackBar('Link Large tapped!'),
                ),
                OsmeaComponents.sizedBox(height: 8),
                OsmeaComponents.text(
                  'Link Medium - Standard link',
                  variant: OsmeaTextVariant.linkMedium,
                  color: OsmeaColors.deepSea,
                  onTap: () => _showSnackBar('Link Medium tapped!'),
                ),
                OsmeaComponents.sizedBox(height: 8),
                OsmeaComponents.text(
                  'Link Small - Compact link',
                  variant: OsmeaTextVariant.linkSmall,
                  color: OsmeaColors.atlantic,
                  onTap: () => _showSnackBar('Link Small tapped!'),
                ),
              ],
            ),

            // Special Text Examples
            _buildSection(
              'Special Text Styles',
              [
                OsmeaComponents.text(
                  'OVERLINE STYLE',
                  variant: OsmeaTextVariant.overline,
                  color: OsmeaColors.pewter,
                ),
                OsmeaComponents.sizedBox(height: 8),
                OsmeaComponents.text(
                  'const greeting = "Hello, World!";',
                  variant: OsmeaTextVariant.code,
                  color: OsmeaColors.forestHeart,
                  backgroundColor: OsmeaColors.ash.withValues(alpha: 0.1),
                ),
                OsmeaComponents.sizedBox(height: 8),
                OsmeaComponents.text(
                  'UPPERCASE',
                  variant: OsmeaTextVariant.labelLarge,
                  isUppercase: true,
                  letterSpacing: 1.2,
                  color: OsmeaColors.sunsetGlow,
                ),
              ],
            ),

            // Interactive Text Examples
            _buildSection(
              'Interactive Text Features',
              [
                OsmeaComponents.text(
                  'Tap me for interaction!',
                  variant: OsmeaTextVariant.bodyLarge,
                  color: OsmeaColors.nordicBlue,
                  decoration: TextDecoration.underline,
                  onTap: () => _showSnackBar('Interactive text tapped!'),
                ),
                OsmeaComponents.sizedBox(height: 8),
                OsmeaComponents.text(
                  'This is selectable text - try selecting it!',
                  variant: OsmeaTextVariant.bodyMedium,
                  isSelectable: true,
                  color: OsmeaColors.forestHeart,
                ),
                OsmeaComponents.sizedBox(height: 8),
                OsmeaComponents.text(
                  'Long press me for context menu',
                  variant: OsmeaTextVariant.bodyMedium,
                  color: OsmeaColors.amberFlame,
                  onLongPress: () => _showSnackBar('Long press detected!'),
                ),
              ],
            ),

            // Text Styling Examples
            _buildSection(
              'Text Styling',
              [
                OsmeaComponents.text(
                  'Bold Text',
                  variant: OsmeaTextVariant.bodyLarge,
                  fontWeight: FontWeight.bold,
                  color: OsmeaColors.eclipse,
                ),
                OsmeaComponents.sizedBox(height: 8),
                OsmeaComponents.text(
                  'Italic Text',
                  variant: OsmeaTextVariant.bodyLarge,
                  fontStyle: FontStyle.italic,
                  color: OsmeaColors.pewter,
                ),
                OsmeaComponents.sizedBox(height: 8),
                OsmeaComponents.text(
                  'Underlined Text',
                  variant: OsmeaTextVariant.bodyLarge,
                  decoration: TextDecoration.underline,
                  decorationColor: OsmeaColors.nordicBlue,
                  color: OsmeaColors.deepSea,
                ),
                OsmeaComponents.sizedBox(height: 8),
                OsmeaComponents.text(
                  'Strikethrough Text',
                  variant: OsmeaTextVariant.bodyLarge,
                  decoration: TextDecoration.lineThrough,
                  decorationColor: OsmeaColors.amberFlame,
                  color: OsmeaColors.steel,
                ),
              ],
            ),

            // Color Examples
            _buildSection(
              'Colors',
              [
                OsmeaComponents.row(
                  children: [
                    OsmeaComponents.expanded(
                      child: OsmeaComponents.text(
                        'Primary',
                        variant: OsmeaTextVariant.labelMedium,
                        color: OsmeaColors.nordicBlue,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    OsmeaComponents.expanded(
                      child: OsmeaComponents.text(
                        'Success',
                        variant: OsmeaTextVariant.labelMedium,
                        color: OsmeaColors.forestHeart,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    OsmeaComponents.expanded(
                      child: OsmeaComponents.text(
                        'Warning',
                        variant: OsmeaTextVariant.labelMedium,
                        color: OsmeaColors.sunsetGlow,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    OsmeaComponents.expanded(
                      child: OsmeaComponents.text(
                        'Danger',
                        variant: OsmeaTextVariant.labelMedium,
                        color: OsmeaColors.amberFlame,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.sizedBox(height: 32),
        OsmeaComponents.container(
          padding: context.horizontalPaddingNormal,
          decoration: BoxDecoration(
            color: OsmeaColors.crystalBay.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: OsmeaComponents.text(
            title,
            variant: OsmeaTextVariant.titleMedium,
            fontWeight: context.semiBold,
            color: OsmeaColors.nordicBlue,
          ),
        ),
        OsmeaComponents.sizedBox(height: 16),
        ...children,
      ],
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: OsmeaComponents.text(message),
        backgroundColor: OsmeaColors.nordicBlue,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
