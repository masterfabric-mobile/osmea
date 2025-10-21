/// 🎙️ OSMEA Sound Dialog Examples
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/components
///
/// Showcases all available variants and customization capabilities of the
/// OsmeaSoundDialog component through practical, scenario-based examples.
///
/// {@category Examples}
/// {@subCategory Dialog}

import 'package:flutter/material.dart';
import 'package:osmea_components/osmea_components.dart';

class SoundDialogExample extends StatelessWidget {
  const SoundDialogExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void showSnackBar(String message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: OsmeaColors.nordicBlue,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }

    // --- Data for Example Cards ---

    // 1. Default Variants: Showcasing each variant without any customization.
    final List<Map<String, dynamic>> defaultExamples = [
      {
        'label': 'Standard Dialog',
        'desc': 'The default, out-of-the-box standard dialog.',
        'icon': Icons.mic_none,
        'color': OsmeaColors.nordicBlue,
        'onPressed': () {
          OsmeaComponents.soundDialog(
            context,
            variant: SoundDialogVariant.standard,
            onCancel: () => showSnackBar('Cancelled ❌'),
            onConfirm: (path) => showSnackBar('Saved: $path ✅'),
          );
        },
      },
      {
        'label': 'Expandable Dialog',
        'desc': 'The default expandable dialog with sound wave visualization.',
        'icon': Icons.graphic_eq,
        'color': OsmeaColors.amberFlame,
        'onPressed': () {
          OsmeaComponents.soundDialog(
            context,
            variant: SoundDialogVariant.expandable,
            onCancel: () => showSnackBar('Cancelled ❌'),
            onConfirm: (path) => showSnackBar('Saved: $path ✅'),
          );
        },
      },
      {
        'label': 'Inline SearchBar',
        'desc': 'The default search bar variant for quick voice input.',
        'icon': Icons.search,
        'color': OsmeaColors.meadow,
        'onPressed': () {
          OsmeaComponents.soundDialog(
            context,
            variant: SoundDialogVariant.inlineSearchBar,
            onCancel: () => showSnackBar('Cancelled ❌'),
            onConfirm: (path) => showSnackBar('Search query: $path ✅'),
          );
        },
      },
      {
        'label': 'Feedback Recorder',
        'desc': 'The default two-step recorder for user feedback.',
        'icon': Icons.reviews_outlined,
        'color': OsmeaColors.sunsetGlow,
        'onPressed': () {
          OsmeaComponents.soundDialog(
            context,
            variant: SoundDialogVariant.feedbackRecorder,
            onCancel: () => showSnackBar('Cancelled ❌'),
            onConfirm: (path) => showSnackBar('Feedback sent: $path ✅'),
          );
        },
      },
    ];

    // 2. Customized Examples: Showcasing the power of customization for each variant.
    final List<Map<String, dynamic>> customizedExamples = [
      {
        'label': 'Standard (Dark Theme)',
        'desc':
            'A dark mode UI with custom colors and different English texts to show customization.',
        'icon': Icons.nightlight_round,
        'color': OsmeaColors.thunder,
        'onPressed': () {
          OsmeaComponents.soundDialog(
            context,
            variant: SoundDialogVariant.standard,
            onCancel: () => showSnackBar('Dismissed ❌'),
            onConfirm: (path) => showSnackBar('Completed: $path ✅'),
            // --- Customizations ---
            dialogBackgroundColor: OsmeaColors.eclipse,
            primaryActionColor: OsmeaColors.azureWave,
            defaultTextColor: OsmeaColors.silver,
            statusTextColor: OsmeaColors.pewter,
            promptTitleText: "Tap the mic to start",
            recordingTitleText: "Now recording...",
            pausedTitleText: "Paused",
            okButtonText: "Done",
            cancelButtonText: "Dismiss",
          );
        },
      },
      {
        'label': 'Expandable (Branded Theme)',
        'desc':
            'Demonstrates changing the primary action color (affecting waves & buttons) and icons.',
        'icon': Icons.color_lens,
        'color': OsmeaColors.sunsetGlow,
        'onPressed': () {
          OsmeaComponents.soundDialog(
            context,
            variant: SoundDialogVariant.expandable,
            onCancel: () => showSnackBar('Cancelled ❌'),
            onConfirm: (path) => showSnackBar('Saved: $path ✅'),
            // --- Customizations ---
            primaryActionColor: OsmeaColors.sunsetGlow,
            secondaryActionColor: OsmeaColors.slate,
            destructiveActionColor: OsmeaColors.red,
            startRecordingIcon:
                const Icon(Icons.record_voice_over, color: Colors.white),
            pauseRecordingIcon: const Icon(Icons.pause_circle_outline),
          );
        },
      },
      {
        'label': 'Search (Branded Colors & Icon)',
        'desc':
            'A search bar dialog styled with a unique brand color and a custom action icon.',
        'icon': Icons.mic_external_on,
        'color': OsmeaColors.pineGrove,
        'onPressed': () {
          OsmeaComponents.soundDialog(
            context,
            variant: SoundDialogVariant.inlineSearchBar,
            onCancel: () => showSnackBar('Cancelled ❌'),
            onConfirm: (path) => showSnackBar('Search query: $path ✅'),
            // --- Customizations ---
            primaryActionColor: OsmeaColors.pineGrove,
            dialogBorderRadius: BorderRadius.circular(8),
            confirmCheckIcon: Icon(
              Icons.mic_external_on,
              color: OsmeaColors.pineGrove,
              size: 28,
            ),
          );
        },
      },
      {
        'label': 'Feedback (Limited & Themed)',
        'desc':
            'A feedback recorder with a 15-second limit and a unique "golden" theme.',
        'icon': Icons.star,
        'color': OsmeaColors.goldenHour,
        'onPressed': () {
          OsmeaComponents.soundDialog(
            context,
            variant: SoundDialogVariant.feedbackRecorder,
            onCancel: () => showSnackBar('Cancelled ❌'),
            onConfirm: (path) => showSnackBar('Review sent: $path ✅'),
            // --- Customizations ---
            primaryActionColor: OsmeaColors.goldenHour,
            destructiveActionColor: OsmeaColors.slate,
            reviewTitleText: 'Confirm Your Review',
            confirmButtonText: 'Send',
            retryButtonText: 'Retry',
            maxRecordingDuration: const Duration(seconds: 15),
            autoStopOnMaxDuration: true,
          );
        },
      },
    ];

    return OsmeaComponents.scaffold(
      backgroundColor: OsmeaColors.white,
      appBar: OsmeaComponents.appBar(
        title: const Text('Sound Dialog Examples'),
      ),
      body: OsmeaComponents.padding(
        padding: const EdgeInsets.all(20),
        child: OsmeaComponents.singleChildScrollView(
          child: OsmeaComponents.column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OsmeaComponents.text(
                'OSMEA Sound Dialogs',
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              OsmeaComponents.sizedBox(height: 12),
              OsmeaComponents.text(
                'Examples showcasing the default variants and customization capabilities of the sound dialog component.',
                fontSize: 16,
                color: OsmeaColors.grey,
              ),
              const SizedBox(height: 24),

              // --- Section 1: Default Variants ---
              OsmeaComponents.text(
                'Default Variants',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              OsmeaComponents.sizedBox(height: 8),
              for (final example in defaultExamples)
                _ExampleCard(
                  label: example['label'],
                  desc: example['desc'],
                  icon: example['icon'],
                  color: example['color'],
                  onPressed: example['onPressed'],
                ),

              const SizedBox(height: 32),

              // --- Section 2: Customized Examples ---
              OsmeaComponents.text(
                'Customized Examples',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              OsmeaComponents.sizedBox(height: 8),
              for (final example in customizedExamples)
                _ExampleCard(
                  label: example['label'],
                  desc: example['desc'],
                  icon: example['icon'],
                  color: example['color'],
                  onPressed: example['onPressed'],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A reusable widget to display an example card, reducing code duplication.
class _ExampleCard extends StatelessWidget {
  final String label;
  final String desc;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _ExampleCard({
    required this.label,
    required this.desc,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: OsmeaComponents.padding(
        padding: const EdgeInsets.all(20),
        child: OsmeaComponents.column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OsmeaComponents.row(
              children: [
                Icon(icon, color: color, size: 28),
                OsmeaComponents.sizedBox(width: 12),
                Expanded(
                  child: OsmeaComponents.text(
                    label,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            OsmeaComponents.sizedBox(height: 8),
            OsmeaComponents.text(
              desc,
              fontSize: 15,
              color: OsmeaColors.pewter,
            ),
            OsmeaComponents.sizedBox(height: 20),
            Center(
              child: OsmeaComponents.button(
                text: 'Open Example',
                size: ButtonSize.medium,
                variant: ButtonVariant.primary,
                icon: Icon(icon, size: 18),
                onPressed: onPressed,
                backgroundColor: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
