import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'info_footer_widget.dart';

/// Informational content for the home page: intro text, link cards, and footer.
class HomeContentWidget extends StatelessWidget {
  const HomeContentWidget({super.key});

  static const String _componentsUrl =
      'https://components.masterfabric.co/#/splash';
  static const String _storybookUrl =
      'https://storybook-osmea.masterfabric.co/';

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildIntro(context),
        OsmeaComponents.sizedBox(height: 32),
        _buildLinkCards(context),
        OsmeaComponents.sizedBox(height: 40),
        const InfoFooterWidget(),
      ],
    );
  }

  Widget _buildIntro(BuildContext context) {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.text(
          'MasterFabric Components is a Flutter UI library for building consistent, accessible apps. Explore the live showcase and Storybook below.',
          textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
            color: OsmeaColors.slate,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildLinkCards(BuildContext context) {
    final links = [
      {
        'title': 'Components',
        'subtitle': 'Live component showcase',
        'url': _componentsUrl,
        'icon': Icons.dashboard_outlined,
      },
      {
        'title': 'Storybook',
        'subtitle': 'Interactive documentation',
        'url': _storybookUrl,
        'icon': Icons.menu_book_outlined,
      },
    ];

    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: links.map<Widget>((link) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildLinkCard(
            context,
            title: link['title'] as String,
            subtitle: link['subtitle'] as String,
            url: link['url'] as String,
            icon: link['icon'] as IconData,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLinkCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String url,
    required IconData icon,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _launchUrl(url),
        borderRadius: BorderRadius.circular(12),
        child: OsmeaComponents.container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: OsmeaColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: OsmeaColors.silver,
              width: 1,
            ),
          ),
          child: OsmeaComponents.row(
            children: [
              OsmeaComponents.container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: OsmeaColors.black.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  size: 24,
                  color: OsmeaColors.black,
                ),
              ),
              OsmeaComponents.sizedBox(width: 16),
              OsmeaComponents.expanded(
                child: OsmeaComponents.column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OsmeaComponents.text(
                      title,
                      textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
                        fontWeight: FontWeight.w600,
                        color: OsmeaColors.black,
                      ),
                    ),
                    OsmeaComponents.sizedBox(height: 4),
                    OsmeaComponents.text(
                      subtitle,
                      textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                        color: OsmeaColors.slate,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: OsmeaColors.pewter,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
