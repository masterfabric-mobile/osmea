import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/src/views/splash/cubit/splash_cubit.dart';
import 'package:core/src/views/splash/cubit/splash_state.dart';
import 'package:osmea_components/osmea_components.dart';

/// 🚀 **OSMEA Splash Enterprise Widget**

/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/core
///
/// Premium enterprise splash design with modern aesthetics
/// Features: Gradient backgrounds, glassmorphism, animated elements, premium typography
///
/// {@category Widgets}
/// {@subCategory SplashEnterprise}

class SplashEnterpriseWidget extends StatefulWidget {
  final VoidCallback? onLogoTap;

  const SplashEnterpriseWidget({
    super.key,
    this.onLogoTap,
  });

  @override
  State<SplashEnterpriseWidget> createState() => _SplashEnterpriseWidgetState();
}

class _SplashEnterpriseWidgetState extends State<SplashEnterpriseWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SplashCubit, SplashState>(
      builder: (context, state) {
        if (state.config == null) {
          return const SizedBox.shrink();
        }

        return OsmeaComponents.container(
          decoration: BoxDecoration(
            gradient: _buildEnterpriseGradient(state),
          ),
          child: Stack(
            children: [
              // Decorative background elements
              _buildBackgroundDecoration(context),

              // Main content
              SafeArea(
                child: OsmeaComponents.column(
                  children: [
                    // Main content area
                    Expanded(
                      child: OsmeaComponents.center(
                        child: SingleChildScrollView(
                          child: _buildMainContent(context, state),
                        ),
                      ),
                    ),

                    // Bottom section with loading
                    _buildBottomSection(context, state),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// 🎨 Build enterprise gradient background
  LinearGradient _buildEnterpriseGradient(SplashState state) {
    final backgroundColor = _getBackgroundColor(state);

    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        backgroundColor,
        backgroundColor,
      ],
    );
  }

  /// 🎨 Background decorative elements
  Widget _buildBackgroundDecoration(BuildContext context) {
    return const SizedBox.shrink();
  }

  /// 📄 Main content area
  Widget _buildMainContent(BuildContext context, SplashState state) {
    final config = state.config!;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: OsmeaComponents.container(
          padding: EdgeInsets.symmetric(horizontal: context.spacing24),
          child: OsmeaComponents.column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Logo with glassmorphism card
              ScaleTransition(
                scale: _scaleAnimation,
                child: _buildGlassmorphicLogoCard(context, state),
              ),

              OsmeaComponents.sizedBox(height: context.spacing32),

              // App name with gradient
              if (config.appName != null) _buildGradientAppName(context, state),
            ],
          ),
        ),
      ),
    );
  }

  /// 🎨 Glassmorphic logo card
  Widget _buildGlassmorphicLogoCard(BuildContext context, SplashState state) {
    final config = state.config!;

    return GestureDetector(
      onTap: widget.onLogoTap,
      child: OsmeaComponents.container(
        width: context.dynamicWidth(0.5),
        height: context.dynamicWidth(0.5),
        child: OsmeaComponents.center(
          child: OsmeaComponents.image(
            imageUrl: config.logoUrl,
            width: config.logoWidth * 0.7,
            height: config.logoHeight * 0.7,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  /// 🎨 Gradient app name
  Widget _buildGradientAppName(BuildContext context, SplashState state) {
    final config = state.config!;
    final textColor = _getTextColor(state);

    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: [
          textColor,
          textColor.withValues(alpha: 0.8),
        ],
      ).createShader(bounds),
      child: OsmeaComponents.text(
        config.appName!,
        variant: OsmeaTextVariant.headlineLarge,
        color: OsmeaColors.white,
        fontWeight: FontWeight.w700,
        textAlign: TextAlign.center,
        letterSpacing: 1.0,
      ),
    );
  }

  /// 🔘 Bottom section with loading
  Widget _buildBottomSection(BuildContext context, SplashState state) {
    final config = state.config!;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: OsmeaComponents.container(
        padding: EdgeInsets.all(context.spacing32),
        child: OsmeaComponents.column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Loading indicator
            if (config.showLoadingIndicator)
              _buildModernLoadingIndicator(context, state),

            if (config.showLoadingIndicator)
              OsmeaComponents.sizedBox(height: context.spacing24),

            // Developed by Masterfabric
            OsmeaComponents.text(
              'Developed by Masterfabric',
              variant: OsmeaTextVariant.bodySmall,
              color: OsmeaColors.pewter,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.w400,
            ),

            OsmeaComponents.sizedBox(height: context.spacing8),

            // Version info at the bottom
            if (config.showAppVersion && config.appVersion != null)
              OsmeaComponents.text(
                'Version ${config.appVersion}',
                variant: OsmeaTextVariant.bodySmall,
                color: OsmeaColors.pewter,
                textAlign: TextAlign.center,
                fontWeight: FontWeight.w400,
              ),
          ],
        ),
      ),
    );
  }

  /// 📊 Modern loading indicator
  Widget _buildModernLoadingIndicator(
    BuildContext context,
    SplashState state,
  ) {
    final config = state.config!;
    final loadingColor =
        config.getLoadingIndicatorColor() ?? _getEnterprisePrimaryColor(state);

    return OsmeaComponents.column(
      children: [
        // Animated loading without glow effect
        OsmeaComponents.loading(
          type: LoadingType.circularFade,
          size: config.loadingIndicatorSize.toDouble(),
          color: loadingColor,
        ),

        OsmeaComponents.sizedBox(height: context.spacing16),

        // Loading text
        OsmeaComponents.text(
          config.loadingText,
          variant: OsmeaTextVariant.bodyMedium,
          color: OsmeaColors.pewter,
          textAlign: TextAlign.center,
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }

  /// 🎨 Get background color from config
  Color _getBackgroundColor(SplashState state) {
    final config = state.config;
    if (config?.backgroundColor != null) {
      try {
        String colorString = config!.backgroundColor!;
        if (colorString.startsWith('#')) {
          colorString = colorString.substring(1);
          if (colorString.length == 8) {
            return Color(
              int.parse('FF${colorString.substring(0, 6)}', radix: 16),
            );
          } else if (colorString.length == 6) {
            return Color(int.parse('FF$colorString', radix: 16));
          }
        }
      } catch (e) {
        debugPrint('⚠️ Invalid background color: ${config!.backgroundColor}');
      }
    }
    return OsmeaColors.snow;
  }

  /// 🎨 Get enterprise primary color
  Color _getEnterprisePrimaryColor(SplashState state) {
    final config = state.config;
    if (config?.primaryColor != null) {
      try {
        String colorString = config!.primaryColor!;
        if (colorString.startsWith('#')) {
          colorString = colorString.substring(1);
          if (colorString.length == 8) {
            return Color(
              int.parse('FF${colorString.substring(0, 6)}', radix: 16),
            );
          } else if (colorString.length == 6) {
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
        if (colorString.startsWith('#')) {
          colorString = colorString.substring(1);
          if (colorString.length == 8) {
            return Color(
              int.parse('FF${colorString.substring(0, 6)}', radix: 16),
            );
          } else if (colorString.length == 6) {
            return Color(int.parse('FF$colorString', radix: 16));
          }
        }
      } catch (e) {
        debugPrint('⚠️ Invalid text color: ${config!.textColor}');
      }
    }
    return OsmeaColors.thunder;
  }
}
