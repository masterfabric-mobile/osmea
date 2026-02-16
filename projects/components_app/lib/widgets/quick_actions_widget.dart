import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class QuickActionsWidget extends StatelessWidget {
  const QuickActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = [
      {
        'title': 'Repository',
        'subtitle': 'View on GitHub',
        'icon': Icons.code,
        'onTap': () =>
            _launchURL('https://github.com/masterfabric-mobile/osmea'),
      },
      {
        'title': 'Pull Requests',
        'subtitle': 'View PRs',
        'icon': Icons.merge_type,
        'onTap': () =>
            _launchURL('https://github.com/masterfabric-mobile/osmea/pulls'),
      },
      {
        'title': 'Issues',
        'subtitle': 'Report Issues',
        'icon': Icons.bug_report,
        'onTap': () =>
            _launchURL('https://github.com/masterfabric-mobile/osmea/issues'),
      },
      {
        'title': 'Showcase',
        'subtitle': 'View Showcase',
        'icon': Icons.auto_awesome,
        'onTap': () => _launchURL(
            'https://github.com/masterfabric-mobile/osmea/tree/dev/packages/components/example_mobile'),
      },
    ];

    return OsmeaComponents.padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.4,
        ),
        itemCount: actions.length,
        itemBuilder: (context, index) {
          final action = actions[index];
          return _buildActionItem(context, action);
        },
      ),
    );
  }

  Widget _buildActionItem(BuildContext context, Map<String, dynamic> action) {
    return InkWell(
      onTap: action['onTap'],
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
        child: OsmeaComponents.column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              action['icon'],
              color: OsmeaColors.black,
              size: 32,
            ),
            OsmeaComponents.column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OsmeaComponents.text(
                  action['title'],
                  textStyle: OsmeaTextStyle.labelLarge(context).copyWith(
                    fontWeight: FontWeight.w600,
                    color: OsmeaColors.black,
                  ),
                ),
                OsmeaComponents.sizedBox(height: 2),
                OsmeaComponents.text(
                  action['subtitle'],
                  textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                    fontWeight: FontWeight.w400,
                    color: OsmeaColors.slate,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }
}
