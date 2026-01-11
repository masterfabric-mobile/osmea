import 'package:flutter/material.dart';
import 'package:core/src/models/about_models.dart';
import 'package:core/src/helper/web_viewer_helper.dart';
import 'package:osmea_components/osmea_components.dart';

/// ⚪ **OSMEA About Space Widget**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/core
///
/// Space-themed about style - Minimalist with lots of whitespace
///
/// {@category Widgets}
/// {@subCategory AboutSpace}

class AboutSpaceWidget extends StatelessWidget {
  final AboutPageModel model;

  const AboutSpaceWidget({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = model.getBackgroundColor() ?? OsmeaColors.white;
    final textColor = model.getTextColor() ?? OsmeaColors.shark;

    // If URL is provided, show only web view
    if (model.hasUrl) {
      return _buildMinimalContent(context, textColor);
    }

    return OsmeaComponents.container(
      color: bgColor,
      child: OsmeaComponents.column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Generous top spacing
          const Expanded(flex: 2, child: SizedBox()),

          // Minimalist content
          _buildMinimalContent(context, textColor),

          // Generous bottom spacing
          const Expanded(flex: 2, child: SizedBox()),

          // Minimal footer
          if (model.showVersion || model.showCompanyInfo)
            _buildMinimalFooter(context, textColor),
        ],
      ),
    );
  }

  /// Build minimalist content
  Widget _buildMinimalContent(BuildContext context, Color textColor) {
    // If URL is provided, show web view directly
    if (model.hasUrl) {
      return WebViewerHelper.url(
        model.url!,
        showNavigationControls: false,
        enableFullscreen: false,
      );
    }

    // If HTML content is provided
    if (model.hasHtmlContent) {
      return OsmeaComponents.container(
        padding: EdgeInsets.symmetric(horizontal: context.spacing32),
        child: WebViewerHelper.html(
          model.htmlContent!,
          height: null,
        ),
      );
    }

    // Default
    return OsmeaComponents.column(
      mainAxisSize: MainAxisSize.min,
      children: [
        OsmeaComponents.text(
          model.title,
          variant: OsmeaTextVariant.titleMedium,
          color: textColor,
          fontWeight: FontWeight.w300,
          textAlign: TextAlign.center,
        ),
        if (model.description != null) ...[
          OsmeaComponents.sizedBox(height: context.spacing16),
          OsmeaComponents.text(
            model.description!,
            variant: OsmeaTextVariant.bodySmall,
            color: textColor.withOpacity(0.5),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  /// Build minimal footer
  Widget _buildMinimalFooter(BuildContext context, Color textColor) {
    return OsmeaComponents.container(
      padding: EdgeInsets.all(context.spacing24),
      child: OsmeaComponents.column(
        children: [
          if (model.showVersion && model.version != null)
            OsmeaComponents.text(
              'v${model.version}',
              variant: OsmeaTextVariant.bodySmall,
              color: textColor.withOpacity(0.4),
              fontWeight: FontWeight.w300,
              textAlign: TextAlign.center,
            ),
          if (model.copyright != null) ...[
            OsmeaComponents.sizedBox(height: context.spacing8),
            OsmeaComponents.text(
              model.copyright!,
              variant: OsmeaTextVariant.bodySmall,
              color: textColor.withOpacity(0.3),
              textAlign: TextAlign.center,
            ),
          ],
          OsmeaComponents.sizedBox(height: context.spacing32),
        ],
      ),
    );
  }

}
