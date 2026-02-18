/*
 * Help & Support View
 * -------------------
 * Static help and support content (storefront_woo style).
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart' hide BuildContextTranslationsExtension;
import 'package:go_router/go_router.dart';
import 'package:storefront_supabase/src/resources/resources.g.dart';

class HelpSupportView extends StatelessWidget {
  final Function(String) goRoute;
  final Map<String, dynamic> arguments;

  const HelpSupportView({
    super.key,
    required this.goRoute,
    this.arguments = const {},
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final resources = context.resources;

    return Scaffold(
      backgroundColor: OsmeaColors.white,
      appBar: OsmeaComponents.appBar(
        title: Text(
          resources.helpSupport,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: OsmeaColors.thunder,
          ),
        ),
        backgroundColor: OsmeaColors.white,
        foregroundColor: OsmeaColors.thunder,
        elevation: 0,
        leading: OsmeaComponents.iconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back, color: OsmeaColors.thunder),
          backgroundColor: OsmeaColors.transparent,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(context.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSection(
              context,
              theme,
              'Contact us',
              'Email: support@masterfabric.co\nPhone: +90 212 000 00 00',
              Icons.email_outlined,
            ),
            SizedBox(height: context.spacing16),
            _buildSection(
              context,
              theme,
              'FAQ',
              'Frequently asked questions and answers will be available here.',
              Icons.help_outline,
            ),
            SizedBox(height: context.spacing16),
            _buildSection(
              context,
              theme,
              'Returns & refunds',
              'Please check our return policy in the product detail page (Cancellation & returns).',
              Icons.assignment_return_outlined,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    ThemeData theme,
    String title,
    String body,
    IconData icon,
  ) {
    return Container(
      padding: EdgeInsets.all(context.spacing12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 24, color: theme.colorScheme.primary),
              SizedBox(width: context.spacing8),
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(height: context.spacing8),
          Text(
            body,
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant, height: 1.4),
          ),
        ],
      ),
    );
  }
}
