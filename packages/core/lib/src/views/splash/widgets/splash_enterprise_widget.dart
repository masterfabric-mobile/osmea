import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/src/views/splash/cubit/splash_cubit.dart';
import 'package:core/src/views/splash/cubit/splash_state.dart';
import 'package:osmea_components/osmea_components.dart';

/// 🚀 **OSMEA Splash Enterprise Widget**

/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/core
///
/// Professional splash style - Corporate card-based design with professional aesthetics
/// Features: Card layouts, professional typography, corporate color schemes, loading indicators
///
/// {@category Widgets}
/// {@subCategory SplashEnterprise}

class SplashEnterpriseWidget extends StatelessWidget {
  final VoidCallback? onLogoTap;

  const SplashEnterpriseWidget({
    super.key,
    this.onLogoTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SplashCubit, SplashState>(
      builder: (context, state) {
        if (state.config == null) {
          return const SizedBox.shrink();
        }

        return OsmeaComponents.container(
          color: _getBackgroundColor(state),
          child: SafeArea(
            child: OsmeaComponents.container(
              padding: EdgeInsets.symmetric(
                horizontal: context.spacing20,
                vertical: context.spacing16,
              ),
              child: OsmeaComponents.column(
                children: [
                  // 📱 Professional header with branding
                  _buildEnterpriseHeader(context, state),

                  // 📄 Main content area with card layout
                  Expanded(
                    child: _buildCardContent(context, state),
                  ),

                  // 🔘 Professional footer with loading
                  _buildEnterpriseFooter(context, state),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// 🎨 Get background color from config
  Color _getBackgroundColor(SplashState state) {
    final config = state.config;
    if (config?.backgroundColor != null) {
      try {
        String colorString = config!.backgroundColor!;
        // Handle both 6-digit (#RRGGBB) and 8-digit (#RRGGBBAA) hex colors
        if (colorString.startsWith('#')) {
          colorString = colorString.substring(1); // Remove #
          if (colorString.length == 8) {
            // 8-digit hex: RRGGBBAA - keep as is, just add FF prefix for full opacity
            return Color(
                int.parse('FF${colorString.substring(0, 6)}', radix: 16));
          } else if (colorString.length == 6) {
            // 6-digit hex: RRGGBB - add FF prefix for full opacity
            return Color(int.parse('FF$colorString', radix: 16));
          }
        }
      } catch (e) {
        debugPrint('⚠️ Invalid background color: ${config!.backgroundColor}');
      }
    }
    return OsmeaColors.paperWhite; // Default for enterprise theme
  }

  /// 🎨 Get enterprise color scheme
  Color _getEnterprisePrimaryColor(SplashState state) {
    final config = state.config;
    if (config?.primaryColor != null) {
      try {
        String colorString = config!.primaryColor!;
        // Handle both 6-digit (#RRGGBB) and 8-digit (#RRGGBBAA) hex colors
        if (colorString.startsWith('#')) {
          colorString = colorString.substring(1); // Remove #
          if (colorString.length == 8) {
            // 8-digit hex: RRGGBBAA - keep as is, just add FF prefix for full opacity
            return Color(
                int.parse('FF${colorString.substring(0, 6)}', radix: 16));
          } else if (colorString.length == 6) {
            // 6-digit hex: RRGGBB - add FF prefix for full opacity
            return Color(int.parse('FF$colorString', radix: 16));
          }
        }
      } catch (e) {
        debugPrint('⚠️ Invalid primary color: ${config!.primaryColor}');
      }
    }
    return OsmeaColors.nordicBlue;
  }

  /// 🎨 Get text color from config
  Color _getTextColor(SplashState state) {
    final config = state.config;
    if (config?.textColor != null) {
      try {
        String colorString = config!.textColor!;
        // Handle both 6-digit (#RRGGBB) and 8-digit (#RRGGBBAA) hex colors
        if (colorString.startsWith('#')) {
          colorString = colorString.substring(1); // Remove #
          if (colorString.length == 8) {
            // 8-digit hex: RRGGBBAA - keep as is, just add FF prefix for full opacity
            return Color(
                int.parse('FF${colorString.substring(0, 6)}', radix: 16));
          } else if (colorString.length == 6) {
            // 6-digit hex: RRGGBB - add FF prefix for full opacity
            return Color(int.parse('FF$colorString', radix: 16));
          }
        }
      } catch (e) {
        debugPrint('⚠️ Invalid text color: ${config!.textColor}');
      }
    }
    return OsmeaColors.thunder;
  }

  /// 📱 Professional header section
  Widget _buildEnterpriseHeader(BuildContext context, SplashState state) {
    final primaryColor = _getEnterprisePrimaryColor(state);

    return OsmeaComponents.container(
      height: context.height80,
      child: OsmeaComponents.row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // OSMEA Logo area
          OsmeaComponents.row(
            mainAxisSize: MainAxisSize.min,
            children: [
              OsmeaComponents.text(
                'OSMEA',
                variant: OsmeaTextVariant.titleLarge,
                color: primaryColor,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),

          // App version (if enabled)
          if (state.config!.showAppVersion && state.config!.appVersion != null)
            OsmeaComponents.text(
              'v${state.config!.appVersion!}',
              variant: OsmeaTextVariant.bodySmall,
              color: OsmeaColors.pewter,
              fontWeight: FontWeight.w500,
            ),
        ],
      ),
    );
  }

  /// 📄 Card-based content area
  Widget _buildCardContent(BuildContext context, SplashState state) {
    final config = state.config!;

    return OsmeaComponents.container(
      margin: EdgeInsets.symmetric(
        horizontal: context.spacing8,
        vertical: context.spacing16,
      ),
      child: OsmeaComponents.container(
        decoration: BoxDecoration(
          color: OsmeaColors.white,
          borderRadius: BorderRadius.circular(context.spacing12),
          border: Border.all(
            color: OsmeaColors.silver,
            width: context.width1,
          ),
          boxShadow: [
            BoxShadow(
              color: OsmeaColors.ash,
              blurRadius: context.blurRadius8,
              offset: context.offsetVertical2,
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: OsmeaComponents.container(
            padding: EdgeInsets.all(context.spacing24),
            child: OsmeaComponents.column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 🖼️ Professional logo area
                _buildEnterpriseLogo(context, state),

                OsmeaComponents.sizedBox(height: context.spacing24),

                // 📝 App name with enterprise typography
                if (config.appName != null)
                  OsmeaComponents.text(
                    config.appName!,
                    variant: OsmeaTextVariant.headlineMedium,
                    color: _getTextColor(state),
                    fontWeight: FontWeight.w600,
                    textAlign: TextAlign.center,
                  ),

                OsmeaComponents.sizedBox(height: context.spacing16),

                // 🎯 Feature highlights
                _buildFeatureHighlights(context, state),

                OsmeaComponents.sizedBox(height: context.spacing24),

                // 📊 Professional loading indicator
                if (config.showLoadingIndicator)
                  _buildEnterpriseLoadingIndicator(context, state),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 🖼️ Enterprise logo element
  Widget _buildEnterpriseLogo(BuildContext context, SplashState state) {
    final config = state.config!;

    return OsmeaComponents.container(
      height: context.dynamicHeight(0.15),
      child: OsmeaComponents.center(
        child: GestureDetector(
          onTap: onLogoTap,
          child: OsmeaComponents.container(
            width: config.logoWidth,
            height: config.logoHeight,
            decoration: BoxDecoration(
              color: OsmeaColors.snow,
              borderRadius: BorderRadius.circular(context.spacing16),
              border: Border.all(
                color: OsmeaColors.silver,
                width: context.width1,
              ),
              boxShadow: [
                BoxShadow(
                  color: OsmeaColors.ash,
                  blurRadius: context.blurRadius8,
                  offset: context.offsetVertical4,
                ),
              ],
            ),
            child: OsmeaComponents.center(
              child: OsmeaComponents.image(
                imageUrl: config.logoUrl,
                width: config.logoWidth * 0.8,
                height: config.logoHeight * 0.8,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 🎯 Feature highlights for professional look
  Widget _buildFeatureHighlights(BuildContext context, SplashState state) {
    final primaryColor = _getEnterprisePrimaryColor(state);

    return OsmeaComponents.container(
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: context.spacing8,
        runSpacing: context.spacing8,
        children: [
          _buildFeatureBadge(context, 'Secure', Icons.security, primaryColor),
          _buildFeatureBadge(
              context, 'Professional', Icons.business_center, primaryColor),
          _buildFeatureBadge(context, 'Reliable', Icons.verified, primaryColor),
        ],
      ),
    );
  }

  /// 🏷️ Feature badge
  Widget _buildFeatureBadge(
      BuildContext context, String label, IconData icon, Color color) {
    return OsmeaComponents.container(
      padding: EdgeInsets.symmetric(
        horizontal: context.spacing12,
        vertical: context.spacing8,
      ),
      decoration: BoxDecoration(
        color: OsmeaColors.snow,
        borderRadius: BorderRadius.circular(context.spacing8),
        border: Border.all(
          color: OsmeaColors.silver,
          width: context.width1,
        ),
      ),
      child: OsmeaComponents.row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: context.iconSizeSmall,
            color: color,
          ),
          OsmeaComponents.sizedBox(width: context.spacing6),
          OsmeaComponents.text(
            label,
            variant: OsmeaTextVariant.bodySmall,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }

  /// 📊 Professional loading indicator
  Widget _buildEnterpriseLoadingIndicator(
      BuildContext context, SplashState state) {
    final config = state.config!;
    // Get loading indicator color (prefers loadingIndicatorColor, falls back to primaryColor)
    final loadingColor = config.getLoadingIndicatorColor() ?? _getEnterprisePrimaryColor(state);

    return OsmeaComponents.container(
      child: OsmeaComponents.column(
        children: [
          // Professional loading indicator
          OsmeaComponents.loading(
            type: LoadingType.circularFade,
            size: config.loadingIndicatorSize.toDouble(),
            color: loadingColor,
          ),

          OsmeaComponents.sizedBox(height: context.spacing16),

          // Loading text with professional styling
          OsmeaComponents.text(
            config.loadingText,
            variant: OsmeaTextVariant.bodyMedium,
            color: OsmeaColors.pewter,
            textAlign: TextAlign.center,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }

  /// 🔘 Professional footer with copyright
  Widget _buildEnterpriseFooter(BuildContext context, SplashState state) {
    final config = state.config!;

    return OsmeaComponents.container(
      padding: EdgeInsets.symmetric(vertical: context.spacing24),
      child: OsmeaComponents.column(
        children: [
          // Copyright text (if enabled)
          if (config.showCopyright)
            OsmeaComponents.text(
              config.copyrightText,
              variant: OsmeaTextVariant.bodySmall,
              color: OsmeaColors.pewter,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.w400,
            ),
        ],
      ),
    );
  }
}
