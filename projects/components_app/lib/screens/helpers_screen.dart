import 'package:components_app/components/application_share_helper_example.dart';
import 'package:flutter/material.dart';
import 'package:core/core.dart';
import '../components/url_launcher_example.dart';
import '../components/file_download_helper_example.dart';
import '../components/viewer_helper_example.dart';
import '../components/permission_handler_example.dart';
import '../components/local_notification_helper_example.dart';

/// 🔧 **Helpers Screen**
///
/// This screen displays a list of utility helpers available in the OSMEA framework.
/// Each helper provides specific functionality that can be tested and demonstrated.
class HelpersScreen extends StatelessWidget {
  const HelpersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.scaffold(
      backgroundColor: OsmeaColors.white,
      body: SafeArea(
        child: OsmeaComponents.column(
          children: [
            // Modern header
            _buildModernHeader(),

            // Content area
            OsmeaComponents.expanded(
              child: _buildHelpersGrid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernHeader() {
    return OsmeaComponents.padding(
      padding: const EdgeInsets.all(20),
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title with progress indicator
          OsmeaComponents.row(
            children: [
              OsmeaComponents.text(
                'Helpers',
                variant: OsmeaTextVariant.headlineLarge,
                color: OsmeaColors.black,
                fontWeight: FontWeight.w600,
              ),
              const Spacer(),
              OsmeaComponents.container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: OsmeaColors.black.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: OsmeaComponents.text(
                  '5 helpers available',
                  variant: OsmeaTextVariant.bodySmall,
                  color: OsmeaColors.black.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          OsmeaComponents.sizedBox(height: 8),

          OsmeaComponents.text(
            'Utility functions and helper tools for common tasks',
            variant: OsmeaTextVariant.bodyMedium,
            color: OsmeaColors.black.withValues(alpha: 0.6),
            fontWeight: FontWeight.w400,
          ),
        ],
      ),
    );
  }

  Widget _buildHelpersGrid() {
    final helpers = [
      {
        'title': 'URL Launcher',
        'icon': Icons.launch,
        'description':
            'Test URL launching functionality with various protocols and platforms',
        'route': () => const UrlLauncherExample(),
        'isComingSoon': false,
      },
      {
        'title': 'File Download',
        'icon': Icons.file_download,
        'description': 'Test file download functionality',
        'route': () => const FileDownloadHelperExample(),
        'isComingSoon': false,
      },
      {
        'title': 'Application Share',
        'icon': Icons.share,
        'description': 'Test sharing text, URLs, and files',
        'route': () => const ApplicationShareHelperExample(),
        'isComingSoon': false,
      },
      {

        'title': 'WebViewerHelper',
        'icon': Icons.web_outlined,
        'description':
            'Unified HTML and WebView rendering with OSMEA Components',
        'route': () => const ViewerHelperExample(),
        'isComingSoon': false,
      },
      {
        'title': 'Local Notifications',
        'icon': Icons.notifications,
        'description': 'Test local notification functionality with scheduling and rich features',
        'route': () => const LocalNotificationHelperExample(),
        'isComingSoon': false,
      },
      {
        'title': 'Permissions',
        'icon': Icons.privacy_tip,
        'description': 'Request and inspect app permissions',
        'route': () => const PermissionHandlerExample(),
        'isComingSoon': false,
      },
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        int crossAxisCount = 2;
        if (width < 360) {
          crossAxisCount = 1;
        } else if (width >= 720) {
          crossAxisCount = 3;
        } else if (width >= 1024) {
          crossAxisCount = 4;
        }

        return OsmeaComponents.padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: crossAxisCount == 1 ? 3.2 : 1.1,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: helpers.length,
            itemBuilder: (context, index) {
              final helper = helpers[index];
              return _buildModernCard(context, helper);
            },
          ),
        );
      },
    );
  }

  Widget _buildModernCard(BuildContext context, Map<String, dynamic> helper) {
    final isComingSoon = helper['isComingSoon'] as bool;

    return OsmeaComponents.container(
      decoration: BoxDecoration(
        color: OsmeaColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: OsmeaColors.black.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () {
          if (isComingSoon) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${helper['title']} - Coming Soon!'),
                backgroundColor: OsmeaColors.black.withValues(alpha: 0.8),
                behavior: SnackBarBehavior.floating,
              ),
            );
          } else {
            final route = helper['route']();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => route),
            );
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: OsmeaComponents.padding(
          padding: const EdgeInsets.all(16),
          child: OsmeaComponents.column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              Icon(
                helper['icon'],
                size: 24,
                color: isComingSoon
                    ? OsmeaColors.black.withValues(alpha: 0.4)
                    : OsmeaColors.black.withValues(alpha: 0.7),
              ),

              OsmeaComponents.sizedBox(height: 12),

              // Title with coming soon badge
              OsmeaComponents.column(
                children: [
                  OsmeaComponents.text(
                    helper['title'],
                    variant: OsmeaTextVariant.bodyMedium,
                    color: isComingSoon
                        ? OsmeaColors.black.withValues(alpha: 0.5)
                        : OsmeaColors.black,
                    fontWeight: FontWeight.w500,
                    textAlign: TextAlign.center,
                  ),
                  if (isComingSoon) ...[
                    OsmeaComponents.sizedBox(height: 4),
                    OsmeaComponents.container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: OsmeaColors.black.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: OsmeaComponents.text(
                        'Coming Soon',
                        variant: OsmeaTextVariant.bodySmall,
                        color: OsmeaColors.black.withValues(alpha: 0.6),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
