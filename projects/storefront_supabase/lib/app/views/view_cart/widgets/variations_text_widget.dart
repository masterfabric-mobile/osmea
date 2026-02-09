/*
 * Variations Text Widget
 * ---------------------
 * Helper widget for displaying product variations with bold attribute names.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';

/// Formats variations string for better readability
String formatVariationsForDisplay(String variations) {
  // Simple format for Supabase variations if they come as "Size: M, Color: Red"
  return variations;
}

/// Widget that displays variations text with bold attribute names
class VariationsTextWidget extends StatelessWidget {
  final String variations;

  const VariationsTextWidget({super.key, required this.variations});

  @override
  Widget build(BuildContext context) {
    final parts = variations.split(',');

    final textSpans = <InlineSpan>[];
    for (int i = 0; i < parts.length; i++) {
      final part = parts[i].trim();
      if (part.isEmpty) continue;

      final colonIndex = part.indexOf(':');
      if (colonIndex > 0) {
        final attributeName = part.substring(0, colonIndex).trim();
        final value = part.substring(colonIndex + 1).trim();

        textSpans.add(
          OsmeaTextSpan(
            text: attributeName,
            style: OsmeaTextStyle.bodySmall(context).copyWith(
              color: OsmeaColors.pewter,
              fontWeight: FontWeight.w600,
              height: context.lineHeightNormal,
              fontSize: context.fontSizeExtraSmall * context.textScaleFactor,
            ),
          ),
        );
        textSpans.add(
          OsmeaTextSpan(
            text: ': $value',
            style: OsmeaTextStyle.bodySmall(context).copyWith(
              color: OsmeaColors.pewter,
              fontWeight: FontWeight.w400,
              height: context.lineHeightNormal,
              fontSize: context.fontSizeExtraSmall * context.textScaleFactor,
            ),
          ),
        );
      } else {
        textSpans.add(
          OsmeaTextSpan(
            text: part,
            style: OsmeaTextStyle.bodySmall(context).copyWith(
              color: OsmeaColors.pewter,
              fontWeight: FontWeight.w400,
              height: context.lineHeightNormal,
              fontSize: context.fontSizeExtraSmall * context.textScaleFactor,
            ),
          ),
        );
      }

      if (i < parts.length - 1) {
        textSpans.add(
          OsmeaTextSpan(
            text: ', ',
            style: OsmeaTextStyle.bodySmall(context).copyWith(
              color: OsmeaColors.pewter,
              fontWeight: FontWeight.w400,
              height: context.lineHeightNormal,
              fontSize: context.fontSizeExtraSmall * context.textScaleFactor,
            ),
          ),
        );
      }
    }

    return OsmeaComponents.richText(
      textSpans: textSpans,
      maxLines: context.maxLineTwo,
      overflow: TextOverflow.ellipsis,
    );
  }
}
