import 'package:flutter/material.dart';
import 'package:osmea_components/osmea_components.dart';

class VariantInfoSection extends StatelessWidget {
  final NavbarVariant variant;
  final bool isCompact;

  const VariantInfoSection({
    super.key,
    required this.variant,
    required this.isCompact,
  });

  // Helper functions to convert enums to strings
  String _enumToString(dynamic enumValue) {
    return enumValue.toString().split('.').last;
  }

  String _formatEnumName(String enumString) {
    // Convert camelCase to Title Case
    return enumString
        .replaceAllMapped(
          RegExp(r'([A-Z])'),
          (match) => ' ${match.group(0)}',
        )
        .trim()
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }

  String _getVariantDescription(NavbarVariant variant) {
    switch (variant) {
      case NavbarVariant.retailMain:
        return 'E-commerce/Retail main navigation with primary brand colors.';
      case NavbarVariant.dottedOutline:
        return 'Creative navigation with dotted border outline.';
      case NavbarVariant.healthcareMinimal:
        return 'Healthcare minimal navigation with clean borders.';
      case NavbarVariant.outlinedMinimal:
        return 'Pill-shaped navbar with light background and border.';
      case NavbarVariant.mediaOverlay:
        return 'Floating overlay navigation for media and hero sections.';
      case NavbarVariant.socialGlass:
        return 'Frosted glass effect for social and modern apps.';
      case NavbarVariant.enterpriseMain:
        return 'Enterprise/B2B main navigation with professional styling.';
      case NavbarVariant.iconGrid:
        return 'Grid-based icon navigation without text.';
      case NavbarVariant.floatingCards:
        return 'Elevated floating card navigation.';
      case NavbarVariant.pillShaped:
        return 'Solid fill pill-shaped navbar.';
      case NavbarVariant.minimal:
        return 'Minimal navbar with only icon color change.';
      case NavbarVariant.solidOutlined:
        return 'Solid background with border.';
      case NavbarVariant.minimalDot:
        return 'Minimal with dot indicator below icon.';
      case NavbarVariant.brutalist:
        return 'Bold brutalist design with sharp edges.';
      case NavbarVariant.badgeIndicator:
        return 'Navigation with badge-style indicators.';
      case NavbarVariant.neumorphic:
        return 'Soft 3D neumorphic design.';
      case NavbarVariant.cardFloating:
        return 'Floating card-style navigation.';
      case NavbarVariant.bubble:
        return 'Playful bubble-style navigation.';
      case NavbarVariant.glassyBlur:
        return 'Glassmorphism with blur effects.';
      case NavbarVariant.markerTab:
        return 'Tab-style with marker indicators.';
      case NavbarVariant.stepped:
        return 'Stepped/stair-like navigation design.';
      case NavbarVariant.ribbon:
        return 'Ribbon/banner style navigation.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: isCompact ? EdgeInsets.zero : const EdgeInsets.all(16),
      padding: EdgeInsets.all(isCompact ? 12 : 16),
      decoration: BoxDecoration(
        color: OsmeaColors.crystalBay.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            'Variant: ${_formatEnumName(_enumToString(variant))}',
            style: TextStyle(
              fontSize: isCompact ? 12 : 14,
              fontWeight: FontWeight.w600,
              color: OsmeaColors.deepSea,
            ),
          ),
          SizedBox(height: isCompact ? 4 : 8),
          Text(
            _getVariantDescription(variant),
            style: TextStyle(
              fontSize: isCompact ? 10 : 12,
              color: OsmeaColors.pewter,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
