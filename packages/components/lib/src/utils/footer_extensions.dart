import 'package:flutter/material.dart';
import 'package:osmea_components/osmea_components.dart';

/// 📋 OSMEA Footer Extensions
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/components
///
/// Extensions and config classes for Footer enums, focused on real footer use cases.
///
/// {@category Utils}
/// {@subCategory Footer}

/// Footer theme configuration
class FooterThemeConfig {
  final Color backgroundColor;
  final Color textColor;
  final Color dividerColor;
  final Color borderColor;
  final double borderWidth;
  final double elevation;
  final bool glassEffect;
  const FooterThemeConfig({
    required this.backgroundColor,
    required this.textColor,
    required this.dividerColor,
    required this.borderColor,
    required this.borderWidth,
    required this.elevation,
    this.glassEffect = false,
  });
}

extension FooterSectionTypeDefaults on FooterSectionType {
  String get defaultTitle {
    switch (this) {
      case FooterSectionType.legal:
        return 'Legal';
      case FooterSectionType.navigation:
        return 'Navigation';
      case FooterSectionType.social:
        return 'Follow Us';
      case FooterSectionType.appInfo:
        return 'About';
      case FooterSectionType.custom:
        return '';
    }
  }
}

extension FooterLinkTypeDefaults on FooterLinkType {
  IconData get icon {
    switch (this) {
      case FooterLinkType.external:
        return Icons.open_in_new;
      case FooterLinkType.internal:
        return Icons.link;
      case FooterLinkType.email:
        return Icons.email;
      case FooterLinkType.phone:
        return Icons.phone;
      case FooterLinkType.custom:
        return Icons.link;
    }
  }
}

extension FooterLayoutTypeConfig on FooterLayoutType {
  /// Returns the number of columns or layout style for the footer
  int get columnCount {
    switch (this) {
      case FooterLayoutType.threeColumn:
        return 3;
      case FooterLayoutType.centered:
      case FooterLayoutType.stacked:
      case FooterLayoutType.minimal:
      case FooterLayoutType.legalBar:
        return 1;
    }
  }
  // You can add more layout-specific config here
}

extension FooterSocialTypeDefaults on FooterSocialType {
  IconData get icon {
    switch (this) {
      case FooterSocialType.twitter:
        return Icons.alternate_email; // Replace with custom icon
      case FooterSocialType.facebook:
        return Icons.facebook;
      case FooterSocialType.linkedin:
        return Icons.business_center; // Use custom icon in real app
      case FooterSocialType.github:
        return Icons.code;
      case FooterSocialType.instagram:
        return Icons.camera_alt;
      case FooterSocialType.custom:
        return Icons.link;
    }
  }
}

extension FooterVariantDefaults on FooterVariant {
  List<OsmeaFooterItem> get defaultItems {
    switch (this) {
      case FooterVariant.legal:
        return const [
          OsmeaFooterItem(label: 'Privacy', description: 'Privacy policy'),
          OsmeaFooterItem(label: 'Terms', description: 'Terms of service'),
          OsmeaFooterItem(
              label: '© OSMEA', description: 'All rights reserved.'),
        ];
      case FooterVariant.social:
        return const [
          OsmeaFooterItem(label: 'Twitter', description: '@osmea'),
          OsmeaFooterItem(label: 'LinkedIn', description: 'osmea-linkedin'),
          OsmeaFooterItem(label: 'Contact', description: 'Contact us'),
        ];
      case FooterVariant.minimal:
        return const [
          OsmeaFooterItem(label: 'Help', description: 'Get help'),
        ];
      case FooterVariant.textOnly:
        return const [];
      case FooterVariant.custom:
      case FooterVariant.defaultFooter:
        return const [
          OsmeaFooterItem(label: 'Privacy', description: 'Privacy policy'),
          OsmeaFooterItem(label: 'Terms', description: 'Terms of service'),
          OsmeaFooterItem(label: 'Contact', description: 'Contact us'),
        ];
    }
  }
}
