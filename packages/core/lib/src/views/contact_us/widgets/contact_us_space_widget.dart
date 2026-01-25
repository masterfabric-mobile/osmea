import 'package:flutter/material.dart';
import 'package:core/src/models/contact_us_models.dart';
import 'package:core/src/views/contact_us/cubit/contact_us_cubit.dart';
import 'package:core/src/helper/web_viewer_helper.dart';
import 'package:core/src/helper/url_launcher_helper.dart';
import 'package:osmea_components/osmea_components.dart';

/// ⚪ **OSMEA Contact Us Space Widget**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/core
///
/// Space-themed contact us style - Minimalist with lots of whitespace
///
/// {@category Widgets}
/// {@subCategory ContactUsSpace}

class ContactUsSpaceWidget extends StatefulWidget {
  final ContactUsPageModel model;
  final ContactUsViewCubit cubit;

  const ContactUsSpaceWidget({
    super.key,
    required this.model,
    required this.cubit,
  });

  @override
  State<ContactUsSpaceWidget> createState() => _ContactUsSpaceWidgetState();
}

class _ContactUsSpaceWidgetState extends State<ContactUsSpaceWidget> {
  @override
  Widget build(BuildContext context) {
    final bgColor = widget.model.getBackgroundColor() ?? OsmeaColors.white;
    final textColor = widget.model.getTextColor() ?? OsmeaColors.shark;

    // If URL is provided, show only web view
    if (widget.model.hasUrl) {
      return _buildMinimalContent(context, textColor);
    }

    return OsmeaComponents.container(
      color: bgColor,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: context.spacing32),
        child: OsmeaComponents.column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            _buildMinimalContent(context, textColor),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
          ],
        ),
      ),
    );
  }

  /// Build minimalist content - Space style: Ultra minimal with lots of whitespace
  Widget _buildMinimalContent(BuildContext context, Color textColor) {
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
      return WebViewerHelper.html(
        widget.model.htmlContent!,
        height: null,
      );
    }

    // Show contact info only if available
    if (!widget.model.showContactInfo ||
        (widget.model.email == null &&
            widget.model.phone == null &&
            widget.model.address == null)) {
      return const SizedBox.shrink();
    }

    return OsmeaComponents.column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.model.description != null) ...[
          OsmeaComponents.text(
            widget.model.description!,
            variant: OsmeaTextVariant.bodyMedium,
            color: textColor.withOpacity(0.6),
            textAlign: TextAlign.center,
            fontWeight: FontWeight.w300,
          ),
          OsmeaComponents.sizedBox(height: context.spacing48),
        ],
        _buildMinimalContactInfo(context, textColor),
      ],
    );
  }

  /// Build minimal contact info
  Widget _buildMinimalContactInfo(BuildContext context, Color textColor) {
    final primaryColor =
        widget.model.getPrimaryColor() ?? OsmeaColors.nordicBlue;
    final items = <Widget>[];

    if (widget.model.email != null) {
      items.add(_buildMinimalContactItem(
        context,
        widget.model.email!,
        textColor,
        primaryColor,
        'email',
      ));
    }
    if (widget.model.phone != null) {
      items.add(_buildMinimalContactItem(
        context,
        widget.model.phone!,
        textColor,
        primaryColor,
        'phone',
      ));
    }
    if (widget.model.address != null) {
      items.add(_buildMinimalContactItem(
        context,
        widget.model.address!,
        textColor,
        primaryColor,
        'address',
      ));
    }

    if (items.isEmpty) return const SizedBox.shrink();

    return OsmeaComponents.column(
      mainAxisSize: MainAxisSize.min,
      children: items
          .expand((item) =>
              [item, OsmeaComponents.sizedBox(height: context.spacing32)])
          .take(items.length * 2 - 1)
          .toList(),
    );
  }

  Widget _buildMinimalContactItem(BuildContext context, String value,
      Color textColor, Color primaryColor, String label) {
    return InkWell(
      onTap: () => _handleContactItemTap(label, value),
      child: OsmeaComponents.text(
        value,
        variant: OsmeaTextVariant.bodyLarge,
        color: textColor.withOpacity(0.7),
        textAlign: TextAlign.center,
        fontWeight: FontWeight.w300,
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
}
