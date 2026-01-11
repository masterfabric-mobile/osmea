import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/src/views/splash/cubit/splash_cubit.dart';
import 'package:core/src/views/splash/cubit/splash_state.dart';
import 'package:osmea_components/osmea_components.dart';

/// 🚀 **OSMEA Splash Startup Widget**

/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/core
///
/// Basic splash style - Logo centered, loading indicator below
/// Clean and simple design with app branding
///
/// {@category Widgets}
/// {@subCategory SplashStartup}

class SplashStartupWidget extends StatelessWidget {
  final VoidCallback? onLogoTap;

  const SplashStartupWidget({
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

        return SizedBox.expand(
          child: OsmeaComponents.container(
            color: _getBackgroundColor(context, state),
            child: SafeArea(
              child: OsmeaComponents.column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 🎯 Main content area
                  Expanded(
                    child: _buildMainContent(context, state),
                  ),

                  // 📊 Bottom section - Loading and info
                  _buildBottomSection(context, state),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// 🎨 Get background color from config
  Color _getBackgroundColor(BuildContext context, SplashState state) {
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
    return OsmeaColors.paperWhite;
  }

  /// 🎯 Main content area with logo and app info
  Widget _buildMainContent(BuildContext context, SplashState state) {
    final config = state.config!;

    return OsmeaComponents.container(
      padding: context.paddingNormal,
      child: OsmeaComponents.column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 🖼️ App Logo (tappable for dev mode)
          GestureDetector(
            onTap: onLogoTap,
            child: OsmeaComponents.image(
              imageUrl: config.logoUrl,
              width: config.logoWidth,
              height: config.logoHeight,
            ),
          ),

          OsmeaComponents.sizedBox(height: context.spacing24),

          // 📱 App Name
          if (config.appName != null)
            OsmeaComponents.text(
              config.appName!,
              variant: OsmeaTextVariant.headlineMedium,
              fontWeight: FontWeight.bold,
              color: _getTextColor(context, state),
              textAlign: TextAlign.center,
            ),

          // 📱 App Version (if enabled)
          if (config.showAppVersion && config.appVersion != null) ...[
            OsmeaComponents.sizedBox(height: context.spacing8),
            OsmeaComponents.text(
              'v${config.appVersion!}',
              variant: OsmeaTextVariant.bodySmall,
              color: _getTextColor(context, state).withOpacity(0.6),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  /// 📊 Bottom section with loading indicator and text
  Widget _buildBottomSection(BuildContext context, SplashState state) {
    final config = state.config!;

    return OsmeaComponents.container(
      padding: context.paddingNormal,
      child: OsmeaComponents.column(
        children: [
          // 🔄 Loading indicator and text
          if (config.showLoadingIndicator) ...[
            OsmeaComponents.loading(
              type: LoadingType.circularFade,
              size: config.loadingIndicatorSize.toDouble(),
              color: _getLoadingIndicatorColor(context, state),
            ),
            OsmeaComponents.sizedBox(height: context.spacing16),
            OsmeaComponents.text(
              config.loadingText,
              variant: OsmeaTextVariant.bodyMedium,
              color: _getTextColor(context, state).withOpacity(0.6),
              textAlign: TextAlign.center,
            ),
          ],

          // © Copyright text (if enabled)
          if (config.showCopyright) ...[
            OsmeaComponents.sizedBox(height: context.spacing32),
            OsmeaComponents.text(
              config.copyrightText,
              variant: OsmeaTextVariant.bodySmall,
              color: _getTextColor(context, state).withOpacity(0.4),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  /// 🎨 Get text color from config
  Color _getTextColor(BuildContext context, SplashState state) {
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

  /// 🎨 Get loading indicator color from config (prefers loadingIndicatorColor, falls back to primaryColor)
  Color _getLoadingIndicatorColor(BuildContext context, SplashState state) {
    final config = state.config;
    // First try loading indicator color
    final loadingColor = config?.getLoadingIndicatorColor();
    if (loadingColor != null) {
      return loadingColor;
    }
    // Fallback to primary color
    final primaryColor = config?.getPrimaryColor();
    if (primaryColor != null) {
      return primaryColor;
    }
    // Default fallback
    return OsmeaColors.black;
  }
}
