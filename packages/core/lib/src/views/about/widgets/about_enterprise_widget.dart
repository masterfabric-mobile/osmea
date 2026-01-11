import 'package:flutter/material.dart';
import 'package:core/src/models/about_models.dart';
import 'package:core/src/helper/web_viewer_helper.dart';
import 'package:osmea_components/osmea_components.dart';

/// 🏢 **OSMEA About Enterprise Widget**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/core
///
/// Enterprise-themed about style - Professional and structured
///
/// {@category Widgets}
/// {@subCategory AboutEnterprise}

class AboutEnterpriseWidget extends StatelessWidget {
  final AboutPageModel model;

  const AboutEnterpriseWidget({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = model.getBackgroundColor() ?? OsmeaColors.snow;
    final textColor = model.getTextColor() ?? OsmeaColors.shark;
    final primaryColor = model.getPrimaryColor() ?? OsmeaColors.deepSea;

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
      width: double.infinity,
      padding: EdgeInsets.all(context.spacing24),
      decoration: BoxDecoration(
        color: OsmeaColors.white,
        border: Border(
          bottom: BorderSide(
            color: OsmeaColors.silver,
            width: 1,
          ),
        ),
      ),
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OsmeaComponents.text(
            model.title,
            variant: OsmeaTextVariant.titleLarge,
            color: textColor,
            fontWeight: FontWeight.w600,
          ),
          if (model.description != null) ...[
            OsmeaComponents.sizedBox(height: context.spacing8),
            OsmeaComponents.text(
              model.description!,
              variant: OsmeaTextVariant.bodyMedium,
              color: textColor.withOpacity(0.7),
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
        decoration: BoxDecoration(
          color: OsmeaColors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: OsmeaColors.silver,
            width: 1,
          ),
        ),
        margin: EdgeInsets.all(context.spacing24),
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
      width: double.infinity,
      padding: EdgeInsets.all(context.spacing24),
      decoration: BoxDecoration(
        color: OsmeaColors.white,
        border: Border(
          top: BorderSide(
            color: OsmeaColors.silver,
            width: 1,
          ),
        ),
      ),
      child: OsmeaComponents.column(
        children: [
          if (model.showVersion && model.version != null) ...[
            Row(
              children: [
                OsmeaComponents.text(
                  'Version',
                  variant: OsmeaTextVariant.bodySmall,
                  color: textColor.withOpacity(0.6),
                ),
                const Spacer(),
                OsmeaComponents.text(
                  model.version!,
                  variant: OsmeaTextVariant.bodyMedium,
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
            if (model.buildNumber != null) ...[
              OsmeaComponents.sizedBox(height: context.spacing8),
              Row(
                children: [
                  OsmeaComponents.text(
                    'Build',
                    variant: OsmeaTextVariant.bodySmall,
                    color: textColor.withOpacity(0.6),
                  ),
                  const Spacer(),
                  OsmeaComponents.text(
                    model.buildNumber!,
                    variant: OsmeaTextVariant.bodyMedium,
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ],
            OsmeaComponents.sizedBox(height: context.spacing16),
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
