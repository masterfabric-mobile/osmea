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

    return Container(
      color: bgColor,
      child: SingleChildScrollView(
        child: OsmeaComponents.column(
          children: [
            // Header
            _buildHeader(context, textColor, primaryColor, bgColor),

            // Content
            _buildContent(context, textColor),

            // Footer
            if (model.showVersion || model.showCompanyInfo)
              _buildFooter(context, textColor, primaryColor),
          ],
        ),
      ),
    );
  }

  /// Build header section
  Widget _buildHeader(BuildContext context, Color textColor, Color primaryColor,
      Color bgColor) {
    return Padding(
      padding: EdgeInsets.only(
        left: context.spacing24,
        right: context.spacing24,
        top: context.spacing8,
        bottom: context.spacing24,
      ),
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Accent line
          Container(
            width: 60,
            height: 4,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          OsmeaComponents.sizedBox(height: context.spacing12),
          // Title
          OsmeaComponents.text(
            model.title,
            variant: OsmeaTextVariant.headlineSmall,
            color: textColor,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
          if (model.description != null) ...[
            OsmeaComponents.sizedBox(height: context.spacing12),
            OsmeaComponents.text(
              model.description!,
              variant: OsmeaTextVariant.bodyLarge,
              color: textColor.withOpacity(0.75),
              textStyle: OsmeaTextStyle.bodyLarge(context).copyWith(
                height: 1.5,
              ),
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
        enableFullscreen: model.enableFullscreenWebView,
      );
    }

    // If HTML content is provided
    if (model.hasHtmlContent) {
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.spacing24,
          vertical: context.spacing16,
        ),
        child: WebViewerHelper.html(
          model.htmlContent!,
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
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.spacing24,
        vertical: context.spacing24,
      ),
      child: OsmeaComponents.column(
        children: [
          // Version info
          if (model.showVersion &&
              (model.version != null || model.buildNumber != null))
            OsmeaComponents.column(
              children: [
                if (model.version != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OsmeaComponents.text(
                        'Version',
                        variant: OsmeaTextVariant.bodyMedium,
                        color: textColor.withOpacity(0.7),
                        fontWeight: FontWeight.w500,
                      ),
                      OsmeaComponents.text(
                        model.version!,
                        variant: OsmeaTextVariant.bodyMedium,
                        color: primaryColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ],
                  ),
                if (model.version != null && model.buildNumber != null)
                  OsmeaComponents.sizedBox(height: context.spacing8),
                if (model.buildNumber != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OsmeaComponents.text(
                        'Build',
                        variant: OsmeaTextVariant.bodyMedium,
                        color: textColor.withOpacity(0.7),
                        fontWeight: FontWeight.w500,
                      ),
                      OsmeaComponents.text(
                        model.buildNumber!,
                        variant: OsmeaTextVariant.bodyMedium,
                        color: primaryColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ],
                  ),
              ],
            ),
          if (model.showVersion &&
              (model.version != null || model.buildNumber != null))
            OsmeaComponents.sizedBox(height: context.spacing20),
          // Company info
          if (model.showCompanyInfo && model.companyName != null) ...[
            OsmeaComponents.text(
              model.companyName!,
              variant: OsmeaTextVariant.bodyMedium,
              color: textColor.withOpacity(0.8),
              fontWeight: FontWeight.w600,
              textAlign: TextAlign.center,
            ),
            OsmeaComponents.sizedBox(height: context.spacing12),
          ],
          if (model.copyright != null)
            OsmeaComponents.text(
              model.copyright!,
              variant: OsmeaTextVariant.bodySmall,
              color: textColor.withOpacity(0.6),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }
}
