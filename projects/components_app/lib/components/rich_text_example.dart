import 'package:core/core.dart';
import 'package:flutter/material.dart';
import '../widgets/common_appbar.dart';

/// 📝 **OSMEA Rich Text Examples**
///
/// This file demonstrates various ways to use the OSMEA Rich Text component,
/// which allows for multiple text spans with different styles in a single text widget.
///
class RichTextExample extends StatelessWidget {
  const RichTextExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.scaffold(
      backgroundColor: OsmeaColors.white,
      appBar: const OsmeaComponentsAppBar(
        screenKey: 'rich_text_example',
      ),
      body: OsmeaComponents.singleChildScrollView(
        padding: context.paddingNormal,
        child: OsmeaComponents.column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section title
            OsmeaComponents.text(
              '📝 Basic Rich Text',
              textStyle: OsmeaTextStyle.titleLarge(context)
                  .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            OsmeaComponents.sizedBox(height: 16),

            // Basic rich text example
            OsmeaComponents.text('Simple rich text with multiple styles:'),
            OsmeaComponents.sizedBox(height: 8),
            basicRichTextExample(context),
            OsmeaComponents.sizedBox(height: 24),

            // Rich text with links
            OsmeaComponents.text('Rich text with interactive spans:'),
            OsmeaComponents.sizedBox(height: 8),
            linkRichTextExample(context),
            OsmeaComponents.sizedBox(height: 24),

            // Section title for text variants
            OsmeaComponents.text(
              '🎨 Text Style Variants',
              textStyle: OsmeaTextStyle.titleLarge(context)
                  .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            OsmeaComponents.sizedBox(height: 16),

            // Rich text with different variants
            OsmeaComponents.text('Different text style variants:'),
            OsmeaComponents.sizedBox(height: 8),
            variantRichTextExamples(context),
            OsmeaComponents.sizedBox(height: 24),

            // Section title for alignment
            OsmeaComponents.text(
              '↔️ Text Alignment',
              textStyle: OsmeaTextStyle.titleLarge(context)
                  .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            OsmeaComponents.sizedBox(height: 16),

            // Rich text with different alignments
            OsmeaComponents.text('Different text alignments:'),
            OsmeaComponents.sizedBox(height: 8),
            alignmentRichTextExamples(context),
            OsmeaComponents.sizedBox(height: 24),

            // Section title for selectable text
            OsmeaComponents.text(
              '👆 Selectable Rich Text',
              textStyle: OsmeaTextStyle.titleLarge(context)
                  .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            OsmeaComponents.sizedBox(height: 16),

            // Selectable rich text examples
            OsmeaComponents.text('Selectable rich text (try selecting):'),
            OsmeaComponents.sizedBox(height: 8),
            selectableRichTextExample(context),
            OsmeaComponents.sizedBox(height: 24),

            // Section title for advanced examples
            OsmeaComponents.text(
              '🚀 Advanced',
              textStyle: OsmeaTextStyle.titleLarge(context)
                  .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            OsmeaComponents.sizedBox(height: 16),

            // Complex formatting examples
            OsmeaComponents.text('Complex text formatting:'),
            OsmeaComponents.sizedBox(height: 8),
            advancedRichTextExamples(context),
            OsmeaComponents.sizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // Basic rich text example
  Widget basicRichTextExample(BuildContext context) {
    return OsmeaComponents.container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: OsmeaColors.snow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: OsmeaColors.platinum),
      ),
      child: OsmeaComponents.richText(
        textSpans: [
          OsmeaTextSpan(
            text: 'This is ',
          ),
          OsmeaTextSpan(
            text: 'bold',
            style: OsmeaTextStyle.bodyLarge(context)
                .copyWith(fontWeight: FontWeight.bold),
          ),
          OsmeaTextSpan(
            text: ' and this is ',
          ),
          OsmeaTextSpan(
            text: 'italic',
            style: OsmeaTextStyle.bodyLarge(context)
                .copyWith(fontStyle: FontStyle.italic),
          ),
          OsmeaTextSpan(
            text: ' text in a ',
          ),
          OsmeaTextSpan(
            text: 'single',
            style: OsmeaTextStyle.bodyLarge(context)
                .copyWith(decoration: TextDecoration.underline),
          ),
          OsmeaTextSpan(
            text: ' rich text component.',
          ),
        ],
      ),
    );
  }

  // Rich text with links example
  Widget linkRichTextExample(BuildContext context) {
    return OsmeaComponents.container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: OsmeaColors.snow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: OsmeaColors.platinum),
      ),
      child: OsmeaComponents.richText(
        textSpans: [
          OsmeaTextSpan(text: 'Visit our '),
          OsmeaTextSpan(
            text: 'website',
            style: OsmeaTextStyle.bodyLarge(context).copyWith(
              color: OsmeaColors.nordicBlue,
              decoration: TextDecoration.underline,
            ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: OsmeaComponents.text('Website link tapped')),
              );
            },
          ),
          OsmeaTextSpan(text: ' or contact '),
          OsmeaTextSpan(
            text: 'support',
            style: OsmeaTextStyle.bodyLarge(context).copyWith(
              color: OsmeaColors.meadow,
              decoration: TextDecoration.underline,
            ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: OsmeaComponents.text('Support link tapped')),
              );
            },
          ),
          OsmeaTextSpan(text: ' for help.'),
        ],
      ),
    );
  }

  // Rich text with different variants
  Widget variantRichTextExamples(BuildContext context) {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: OsmeaColors.snow,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: OsmeaColors.platinum),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: OsmeaComponents.column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OsmeaComponents.richText(
                variant: OsmeaTextVariant.headlineMedium,
                textSpans: [
                  OsmeaTextSpan(text: 'Headline '),
                  OsmeaTextSpan(
                    text: 'Medium',
                    style: OsmeaTextStyle.bodyLarge(context)
                        .copyWith(color: OsmeaColors.nordicBlue),
                  ),
                ],
              ),
              OsmeaComponents.sizedBox(height: 12),
              OsmeaComponents.richText(
                variant: OsmeaTextVariant.titleLarge,
                textSpans: [
                  OsmeaTextSpan(text: 'Title '),
                  OsmeaTextSpan(
                    text: 'Large',
                    style: OsmeaTextStyle.bodyLarge(context)
                        .copyWith(color: OsmeaColors.meadow),
                  ),
                ],
              ),
              OsmeaComponents.sizedBox(height: 12),
              OsmeaComponents.richText(
                variant: OsmeaTextVariant.bodyLarge,
                textSpans: [
                  OsmeaTextSpan(text: 'Body '),
                  OsmeaTextSpan(
                    text: 'Large',
                    style: OsmeaTextStyle.bodyLarge(context)
                        .copyWith(color: OsmeaColors.purple),
                  ),
                  OsmeaTextSpan(
                    text:
                        ' with more text showing the larger body style.',
                  ),
                ],
              ),
              OsmeaComponents.sizedBox(height: 12),
              OsmeaComponents.richText(
                variant: OsmeaTextVariant.labelMedium,
                textSpans: [
                  OsmeaTextSpan(text: 'Label '),
                  OsmeaTextSpan(
                    text: 'Medium',
                    style: OsmeaTextStyle.bodyLarge(context)
                        .copyWith(color: OsmeaColors.sunsetGlow),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Rich text with different alignments
  Widget alignmentRichTextExamples(BuildContext context) {
    return OsmeaComponents.column(
      children: [
        OsmeaComponents.container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: OsmeaColors.snow,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: OsmeaColors.platinum),
          ),
          margin: const EdgeInsets.only(bottom: 12),
          child: OsmeaComponents.richText(
            textAlign: TextAlign.start,
            textSpans: [
              OsmeaTextSpan(
                text: 'Left aligned ',
                style: OsmeaTextStyle.bodyLarge(context)
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              OsmeaTextSpan(
                text: 'rich text with multiple spans showing proper alignment.',
              ),
            ],
          ),
        ),
        OsmeaComponents.container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: OsmeaColors.snow,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: OsmeaColors.platinum),
          ),
          margin: const EdgeInsets.only(bottom: 12),
          child: OsmeaComponents.richText(
            textAlign: TextAlign.center,
            textSpans: [
              OsmeaTextSpan(
                text: 'Center aligned ',
                style: OsmeaTextStyle.bodyLarge(context)
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              OsmeaTextSpan(
                text: 'rich text with multiple spans showing proper alignment.',
              ),
            ],
          ),
        ),
        OsmeaComponents.container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: OsmeaColors.snow,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: OsmeaColors.platinum),
          ),
          child: OsmeaComponents.richText(
            textAlign: TextAlign.end,
            textSpans: [
              OsmeaTextSpan(
                text: 'Right aligned ',
                style: OsmeaTextStyle.bodyLarge(context)
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              OsmeaTextSpan(
                text: 'rich text with multiple spans showing proper alignment.',
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Selectable rich text example
  Widget selectableRichTextExample(BuildContext context) {
    return OsmeaComponents.container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: OsmeaColors.snow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: OsmeaColors.platinum),
      ),
      child: OsmeaComponents.richText(
        selectable: true,
        textSpans: [
          OsmeaTextSpan(
            text: 'This entire text is selectable. ',
          ),
          OsmeaTextSpan(
            text: 'Try selecting this text with your finger or mouse ',
            style: OsmeaTextStyle.bodyLarge(context)
                .copyWith(color: OsmeaColors.purple),
          ),
          OsmeaTextSpan(
            text: 'to copy it to your clipboard.',
            style: OsmeaTextStyle.bodyLarge(context)
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // Advanced rich text examples
  Widget advancedRichTextExamples(BuildContext context) {
    return OsmeaComponents.column(
      children: [
        // Code snippet example
        OsmeaComponents.container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: OsmeaColors.grayMaterial[900],
            borderRadius: BorderRadius.circular(8),
          ),
          margin: const EdgeInsets.only(bottom: 16),
          child: OsmeaComponents.richText(
            textSpans: [
              OsmeaTextSpan(
                text: 'void ',
                style: OsmeaTextStyle.bodyLarge(context).copyWith(
                    color: OsmeaColors.nordicBlue, fontFamily: 'monospace'),
              ),
              OsmeaTextSpan(
                text: 'main',
                style: OsmeaTextStyle.bodyLarge(context).copyWith(
                    color: OsmeaColors.sunsetGlow, fontFamily: 'monospace'),
              ),
              OsmeaTextSpan(
                text: '() {\n  ',
                style: OsmeaTextStyle.bodyLarge(context).copyWith(
                    color: OsmeaColors.white, fontFamily: 'monospace'),
              ),
              OsmeaTextSpan(
                text: 'print',
                style: OsmeaTextStyle.bodyLarge(context).copyWith(
                    color: OsmeaColors.nordicBlue, fontFamily: 'monospace'),
              ),
              OsmeaTextSpan(
                text: '(',
                style: OsmeaTextStyle.bodyLarge(context).copyWith(
                    color: OsmeaColors.white, fontFamily: 'monospace'),
              ),
              OsmeaTextSpan(
                text: "'Hello, world!'",
                style: OsmeaTextStyle.bodyLarge(context).copyWith(
                    color: OsmeaColors.meadow, fontFamily: 'monospace'),
              ),
              OsmeaTextSpan(
                text: ');\n}',
                style: OsmeaTextStyle.bodyLarge(context).copyWith(
                    color: OsmeaColors.white, fontFamily: 'monospace'),
              ),
              OsmeaTextSpan(
                text: 'main',
                style: OsmeaTextStyle.bodyLarge(context)
                    .copyWith(color: Colors.yellow, fontFamily: 'monospace'),
              ),
              OsmeaTextSpan(
                text: '() {\n  ',
                style: OsmeaTextStyle.bodyLarge(context)
                    .copyWith(color: Colors.white, fontFamily: 'monospace'),
              ),
              OsmeaTextSpan(
                text: 'print',
                style: OsmeaTextStyle.bodyLarge(context)
                    .copyWith(color: Colors.lightBlue, fontFamily: 'monospace'),
              ),
              OsmeaTextSpan(
                text: '(',
                style: OsmeaTextStyle.bodyLarge(context)
                    .copyWith(color: Colors.white, fontFamily: 'monospace'),
              ),
              OsmeaTextSpan(
                text: "'Hello, world!'",
                style: OsmeaTextStyle.bodyLarge(context)
                    .copyWith(color: Colors.green, fontFamily: 'monospace'),
              ),
              OsmeaTextSpan(
                text: ');\n}',
                style: OsmeaTextStyle.bodyLarge(context)
                    .copyWith(color: Colors.white, fontFamily: 'monospace'),
              ),
            ],
          ),
        ),

        // Notification example
        OsmeaComponents.container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: OsmeaColors.nordicBlue),
          ),
          margin: const EdgeInsets.only(bottom: 16),
          child: OsmeaComponents.richText(
            textSpans: [
              WidgetSpan(
                child: OsmeaComponents.padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child:
                      Icon(Icons.info, color: OsmeaColors.nordicBlue, size: 20),
                ),
              ),
              OsmeaTextSpan(
                text: 'Info: ',
                style: OsmeaTextStyle.bodyLarge(context).copyWith(
                    fontWeight: FontWeight.bold, color: OsmeaColors.nordicBlue),
              ),
              OsmeaTextSpan(
                text: 'This is an information message with ',
                style: OsmeaTextStyle.bodyLarge(context)
                    .copyWith(color: OsmeaColors.nordicBlue),
              ),
              OsmeaTextSpan(
                text: 'important details',
                style: OsmeaTextStyle.bodyLarge(context).copyWith(
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    color: OsmeaColors.nordicBlue),
              ),
              OsmeaTextSpan(
                text: '.',
                style: OsmeaTextStyle.bodyLarge(context)
                    .copyWith(color: OsmeaColors.nordicBlue),
              ),
            ],
          ),
        ),

        // Price tag example
        OsmeaComponents.container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: OsmeaColors.snow,
            borderRadius: BorderRadius.circular(8),
          ),
          child: OsmeaComponents.richText(
            textSpans: [
              OsmeaTextSpan(
                text: 'The product costs ',
              ),
              OsmeaTextSpan(
                text: '\$',
                style: OsmeaTextStyle.bodyLarge(context).copyWith(
                    color: OsmeaColors.meadow, fontWeight: FontWeight.bold),
              ),
              OsmeaTextSpan(
                text: '29',
                style: OsmeaTextStyle.bodyLarge(context).copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: OsmeaColors.meadow),
              ),
              OsmeaTextSpan(
                text: '.99',
                style: OsmeaTextStyle.bodyLarge(context).copyWith(
                    color: OsmeaColors.meadow,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              OsmeaTextSpan(
                text: ' (save ',
              ),
              OsmeaTextSpan(
                text: '50%',
                style: OsmeaTextStyle.bodyLarge(context).copyWith(
                    color: OsmeaColors.sunsetGlow, fontWeight: FontWeight.bold),
              ),
              OsmeaTextSpan(
                text: ')',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
