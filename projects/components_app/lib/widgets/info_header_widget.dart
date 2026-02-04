import 'package:core/core.dart';
import 'package:flutter/material.dart';
import '../utils/asset_paths.dart';

class InfoHeaderWidget extends StatelessWidget {
  final Map<String, dynamic> repoInfo;
  final int contributorsCount;

  const InfoHeaderWidget({
    super.key,
    required this.repoInfo,
    required this.contributorsCount,
  });

  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo & Title
          _buildLogoAndTitle(context),
          OsmeaComponents.sizedBox(height: 20),
          // Description
          _buildDescription(context),
          OsmeaComponents.sizedBox(height: 16),
          // Stats with Badges
          _buildStatsBadges(),
        ],
      ),
    );
  }

  Widget _buildLogoAndTitle(BuildContext context) {
    return OsmeaComponents.row(
      children: [
        OsmeaComponents.image(
          width: 48,
          height: 48,
          borderRadius: BorderRadius.circular(12),
          assetPath: AssetPaths.osmeaLogo,
          fit: BoxFit.contain,
          errorWidget: _buildLogoErrorWidget(context),
        ),
        OsmeaComponents.sizedBox(width: 16),
        Expanded(
          child: OsmeaComponents.column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OsmeaComponents.text(
                'Components App',
                textStyle: OsmeaTextStyle.headlineSmall(context).copyWith(
                  fontWeight: FontWeight.w700,
                  color: OsmeaColors.black,
                ),
              ),
              OsmeaComponents.sizedBox(height: 8),
              OsmeaComponents.text(
                'Modern UI Kit',
                textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
                  fontWeight: FontWeight.w500,
                  color: OsmeaColors.slate,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLogoErrorWidget(BuildContext context) {
    return OsmeaComponents.container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: OsmeaColors.red,
        borderRadius: BorderRadius.circular(12),
      ),
      child: OsmeaComponents.column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OsmeaComponents.text(
            'LOGO',
            textStyle: OsmeaTextStyle.labelSmall(context).copyWith(
              fontWeight: FontWeight.w700,
              color: OsmeaColors.white,
              letterSpacing: -0.5,
            ),
          ),
          OsmeaComponents.text(
            'ERROR',
            textStyle: OsmeaTextStyle.labelSmall(context).copyWith(
              fontWeight: FontWeight.w700,
              color: OsmeaColors.white,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(BuildContext context) {
    return OsmeaComponents.text(
      'Enterprise-grade Flutter UI components designed for modern applications.',
      textStyle: OsmeaTextStyle.bodyLarge(context).copyWith(
        fontWeight: FontWeight.w400,
        color: OsmeaColors.slate,
        height: 1.4,
      ),
    );
  }

  Widget _buildStatsBadges() {
    return OsmeaComponents.row(
      children: [
        _buildStatBadge('${repoInfo['stars'] ?? 17}', 'Stars'),
        OsmeaComponents.sizedBox(width: 12),
        _buildStatBadge('${repoInfo['forks'] ?? 3}', 'Forks'),
        OsmeaComponents.sizedBox(width: 12),
        _buildStatBadge('$contributorsCount', 'Contributors'),
      ],
    );
  }

  Widget _buildStatBadge(String value, String label) {
    return OsmeaComponents.badge(
      content: '$value $label',
      variant: BadgeVariant.primary,
      size: BadgeSize.medium,
      style: BadgeStyle.outlined,
      backgroundColor: OsmeaColors.white,
      textColor: OsmeaColors.black,
      borderColor: OsmeaColors.silver,
    );
  }
}
