import 'package:flutter/material.dart';
import 'package:core/src/models/about_models.dart';
import 'package:core/src/helper/web_viewer_helper.dart';
import 'package:osmea_components/osmea_components.dart';

/// 🚀 **OSMEA About Startup Widget**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/core
///
/// Startup-themed about style - Modern and clean design
///
/// {@category Widgets}
/// {@subCategory AboutStartup}

class AboutStartupWidget extends StatelessWidget {
  final AboutPageModel model;

  const AboutStartupWidget({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = model.getBackgroundColor() ?? OsmeaColors.white;
    final textColor = model.getTextColor() ?? OsmeaColors.shark;
    final primaryColor = model.getPrimaryColor() ?? OsmeaColors.nordicBlue;

    // If URL is provided, show only web view
    if (model.hasUrl) {
      return _buildContent(context, textColor);
    }

    return OsmeaComponents.container(
      color: bgColor,
      child: OsmeaComponents.column(
        children: [
          // Header
          _buildHeader(context, textColor, primaryColor),

          // Content
          Expanded(
            child: _buildContent(context, textColor),
          ),

          // Footer
          if (model.showVersion || model.showCompanyInfo)
            _buildFooter(context, textColor, primaryColor),
        ],
      ),
    );
  }

  /// Build header section
  Widget _buildHeader(
      BuildContext context, Color textColor, Color primaryColor) {
    return OsmeaComponents.container(
      padding: EdgeInsets.all(context.spacing24),
      child: OsmeaComponents.column(
        children: [
          // Title
          OsmeaComponents.text(
            model.title,
            variant: OsmeaTextVariant.titleLarge,
            color: textColor,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.center,
          ),

          if (model.description != null) ...[
            OsmeaComponents.sizedBox(height: context.spacing12),
            OsmeaComponents.text(
              model.description!,
              variant: OsmeaTextVariant.bodyMedium,
              color: textColor.withOpacity(0.7),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  /// Build content section
  Widget _buildContent(BuildContext context, Color textColor) {
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
        padding: EdgeInsets.all(context.spacing24),
        child: WebViewerHelper.html(
          model.htmlContent!,
          height: null,
        ),
      );
    }

    // Default empty state
    return OsmeaComponents.center(
      child: OsmeaComponents.text(
        'No content available',
        variant: OsmeaTextVariant.bodyMedium,
        color: textColor.withOpacity(0.5),
      ),
    );
  }

  /// Build footer section
  Widget _buildFooter(
      BuildContext context, Color textColor, Color primaryColor) {
    return OsmeaComponents.container(
      padding: EdgeInsets.all(context.spacing24),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: textColor.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: OsmeaComponents.column(
        children: [
          if (model.showVersion && model.version != null) ...[
            OsmeaComponents.text(
              'Version ${model.version}${model.buildNumber != null ? ' (${model.buildNumber})' : ''}',
              variant: OsmeaTextVariant.bodySmall,
              color: textColor.withOpacity(0.6),
              textAlign: TextAlign.center,
            ),
            OsmeaComponents.sizedBox(height: context.spacing8),
          ],
          if (model.showCompanyInfo && model.companyName != null) ...[
            OsmeaComponents.text(
              model.companyName!,
              variant: OsmeaTextVariant.bodySmall,
              color: textColor.withOpacity(0.6),
              textAlign: TextAlign.center,
            ),
            OsmeaComponents.sizedBox(height: context.spacing8),
          ],
          if (model.copyright != null)
            OsmeaComponents.text(
              model.copyright!,
              variant: OsmeaTextVariant.bodySmall,
              color: textColor.withOpacity(0.5),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }

}
