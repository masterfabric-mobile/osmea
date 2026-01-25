import 'package:flutter/material.dart';
import 'package:core/src/models/contact_us_models.dart';
import 'package:core/src/views/contact_us/cubit/contact_us_cubit.dart';
import 'package:core/src/helper/web_viewer_helper.dart';
import 'package:core/src/helper/url_launcher_helper.dart';
import 'package:osmea_components/osmea_components.dart';

/// 🚀 **OSMEA Contact Us Startup Widget**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/core
///
/// Startup-themed contact us style - Modern and clean design
///
/// {@category Widgets}
/// {@subCategory ContactUsStartup}

class ContactUsStartupWidget extends StatefulWidget {
  final ContactUsPageModel model;
  final ContactUsViewCubit cubit;

  const ContactUsStartupWidget({
    super.key,
    required this.model,
    required this.cubit,
  });

  @override
  State<ContactUsStartupWidget> createState() => _ContactUsStartupWidgetState();
}

class _ContactUsStartupWidgetState extends State<ContactUsStartupWidget> {
  @override
  Widget build(BuildContext context) {
    final bgColor = widget.model.getBackgroundColor() ?? OsmeaColors.white;
    final textColor = widget.model.getTextColor() ?? OsmeaColors.shark;
    final primaryColor =
        widget.model.getPrimaryColor() ?? OsmeaColors.nordicBlue;

    // If URL is provided, show only web view
    if (widget.model.hasUrl) {
      return _buildContent(context, textColor);
    }

    return OsmeaComponents.container(
      color: bgColor,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(context.spacing24),
        child: OsmeaComponents.column(
          children: [
            if (widget.model.description != null) ...[
              OsmeaComponents.text(
                widget.model.description!,
                variant: OsmeaTextVariant.bodyLarge,
                color: textColor.withOpacity(0.7),
                textAlign: TextAlign.center,
              ),
              OsmeaComponents.sizedBox(height: context.spacing32),
            ],
            if (widget.model.showContactInfo)
              _buildContactInfo(context, textColor, primaryColor),
          ],
        ),
      ),
    );
  }

  /// Build contact info section - Startup style: Clean and simple
  Widget _buildContactInfo(
      BuildContext context, Color textColor, Color primaryColor) {
    final items = <Widget>[];

    if (widget.model.email != null) {
      items.add(_buildContactItem(
        context,
        Icons.email_outlined,
        widget.model.email!,
        textColor,
        primaryColor,
        'email',
      ));
    }
    if (widget.model.phone != null) {
      items.add(_buildContactItem(
        context,
        Icons.phone_outlined,
        widget.model.phone!,
        textColor,
        primaryColor,
        'phone',
      ));
    }
    if (widget.model.address != null) {
      items.add(_buildContactItem(
        context,
        Icons.location_on_outlined,
        widget.model.address!,
        textColor,
        primaryColor,
        'address',
      ));
    }

    if (items.isEmpty) return const SizedBox.shrink();

    return OsmeaComponents.column(
      children: items
          .expand((item) =>
              [item, OsmeaComponents.sizedBox(height: context.spacing20)])
          .take(items.length * 2 - 1)
          .toList(),
    );
  }

  Widget _buildContactItem(BuildContext context, IconData icon, String value,
      Color textColor, Color primaryColor, String label) {
    return InkWell(
      onTap: () => _handleContactItemTap(label, value),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: context.spacing12),
        child: Row(
          children: [
            Icon(icon, color: primaryColor, size: 22),
            OsmeaComponents.sizedBox(width: context.spacing16),
            Expanded(
              child: OsmeaComponents.text(
                value,
                variant: OsmeaTextVariant.bodyLarge,
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Handle contact item tap - launch appropriate action
  Future<void> _handleContactItemTap(String label, String value) async {
    try {
      switch (label.toLowerCase()) {
        case 'email':
          final success = await UrlLauncher.openEmail(value);
          if (!success) {
            debugPrint('❌ Failed to open email: $value');
          }
          break;
        case 'phone':
          // Clean phone number (remove spaces, dashes, parentheses)
          final cleanPhone = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');
          final success = await UrlLauncher.openPhone(cleanPhone);
          if (!success) {
            debugPrint('❌ Failed to open phone: $cleanPhone');
          }
          break;
        case 'address':
          try {
            await UrlLauncher.getLaunchMapsQuery(value);
          } catch (e) {
            debugPrint('❌ Failed to open maps: $value - $e');
          }
          break;
        default:
          debugPrint('⚠️ Unknown contact item type: $label');
      }
    } catch (e) {
      debugPrint('❌ Error launching contact item: $e');
    }
  }

  /// Build content section
  Widget _buildContent(BuildContext context, Color textColor) {
    // If URL is provided, show web view directly
    if (widget.model.hasUrl) {
      return WebViewerHelper.url(
        widget.model.url!,
        showNavigationControls: false,
        enableFullscreen: widget.model.enableFullscreenWebView,
      );
    }

    // If HTML content is provided
    if (widget.model.hasHtmlContent) {
      return OsmeaComponents.container(
        padding: EdgeInsets.all(context.spacing24),
        child: WebViewerHelper.html(
          widget.model.htmlContent!,
          height: null,
        ),
      );
    }

    // No content available
    return const SizedBox.shrink();
  }
}
