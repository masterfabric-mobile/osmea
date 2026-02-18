import 'package:flutter/material.dart';
import 'package:core/core.dart';

/// Splash view for storefront app (avoids conflict with core SplashView)
class SupabaseSplashView extends StatefulWidget {
  final Function(String path) goRoute;

  const SupabaseSplashView({super.key, required this.goRoute});

  @override
  State<SupabaseSplashView> createState() => _SupabaseSplashViewState();
}

class _SupabaseSplashViewState extends State<SupabaseSplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();

    // Navigate after 2 seconds
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        widget.goRoute('/home');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final configHelper = AssetConfigHelper();

    // Get app name from storefront_supabase config only
    final appName = configHelper.getString(
      'app_settings.app_name',
      'MasterFabric S Store',
    );
    final appVersion = configHelper.getString(
      'app_settings.app_version',
      '1.0.0',
    );

    // Get splash config from storefront_supabase config only
    final logoUrl = configHelper.getString(
      'splash_configuration.logo_url',
      'https://github.com/masterfabric-mobile/osmea/blob/dev/projects/components_app/assets/images/mf_logo.png?raw=true',
    );
    final backgroundColor = _parseColor(
      configHelper.getString(
        'splash_configuration.background_color',
        '#FFFFFF',
      ),
    );
    final textColor = _parseColor(
      configHelper.getString(
        'splash_configuration.app_name_text_color',
        '#000000',
      ),
    );

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                if (logoUrl.isNotEmpty)
                  OsmeaComponents.sizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.35,
                    height: MediaQuery.sizeOf(context).width * 0.35,
                    child: OsmeaComponents.image(
                      imageUrl: logoUrl,
                      fit: BoxFit.contain,
                    ),
                  ),

                OsmeaComponents.sizedBox(height: 40),

                // App Name
                OsmeaComponents.text(
                  appName,
                  variant: OsmeaTextVariant.headlineMedium,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  textAlign: TextAlign.center,
                ),

                OsmeaComponents.sizedBox(height: 16),

                // Loading indicator
                OsmeaComponents.loading(
                  type: LoadingType.circularFade,
                  size: 36,
                  color: OsmeaColors.black,
                ),

                OsmeaComponents.sizedBox(height: 24),

                // Version
                OsmeaComponents.text(
                  'v$appVersion',
                  variant: OsmeaTextVariant.bodySmall,
                  color: textColor.withOpacity(0.6),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _parseColor(String colorString) {
    try {
      String hex = colorString.replaceAll('#', '');
      if (hex.length == 8) {
        return Color(int.parse('FF$hex', radix: 16));
      }
      if (hex.length == 6) {
        return Color(int.parse('FF$hex', radix: 16));
      }
      return Colors.white;
    } catch (e) {
      return Colors.white;
    }
  }
}
