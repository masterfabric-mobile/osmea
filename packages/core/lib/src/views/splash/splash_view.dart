import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:core/src/views/splash/widgets/splash_startup_widget.dart';
import 'package:core/src/views/splash/widgets/splash_space_widget.dart';
import 'package:core/src/views/splash/widgets/splash_enterprise_widget.dart';

/// 🚀 **OSMEA Splash View**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/core
///
/// Main splash view - Simple timer-based navigation
/// Uses MasterViewCubit for lifecycle management
/// {@category Views}
/// {@subCategory SplashView}

class SplashView extends MasterViewCubit<SplashCubit, SplashState> {
  /// Callback triggered when splash begins
  final VoidCallback? onStart;

  /// Callback triggered when splash ends
  final VoidCallback? onComplete;

  SplashView({
    required super.goRoute,
    super.arguments = const {'splash': true},
    this.onStart,
    this.onComplete,
  }) : super(
          useSafeArea: false,
          horizontalPadding: const PaddingVisibility.disabled(),
          navbarSpacer: const SpacerVisibility.disabled(),
          footerSpacer: const SpacerVisibility.disabled(),
          backgroundColor: OsmeaColors.white, // Default background
        );

  @override
  Future<void> initialContent(viewModel, BuildContext context) async {
    debugPrint('🚀 Splash View Start!');

    // Trigger onStart callback
    onStart?.call();

    // Get auto-navigation setting from config
    final configHelper = AssetConfigHelper();
    await configHelper.loadConfig();
    final shouldAutoNavigate =
        configHelper.getBool('splash_configuration.auto_navigate', true);

    // Listen to state changes for navigation
    // This ensures we navigate when the cubit determines the target
    bool hasNavigated = false;

    // Helper function to handle navigation
    void handleNavigation(SplashState state) {
      if (shouldAutoNavigate &&
          state.status == SplashStatus.completed &&
          state.navigationTarget != null &&
          !hasNavigated) {
        hasNavigated = true;
        debugPrint('🧭 Navigating to: ${state.navigationTarget}');

        // Trigger onComplete callback
        onComplete?.call();

        // Use postFrameCallback to ensure state is fully updated before navigation
        WidgetsBinding.instance.addPostFrameCallback((_) {
          try {
            goRoute(state.navigationTarget!);
          } catch (e) {
            debugPrint('❌ Error navigating from splash: $e');
            // Fallback to home on error
            goRoute('/home');
          }
        });
      }
    }

    // Check initial state in case it's already completed
    handleNavigation(viewModel.state);

    // Listen to future state changes
    viewModel.stream.listen(handleNavigation);

    // Initialize the splash cubit with app configuration
    // This will trigger the timer and navigation target determination
    await viewModel.initializeSplash();
  }

  @override
  Widget viewContent(BuildContext context, viewModel, state) {
    return FutureBuilder<SplashStyle>(
      future: _getSplashStyleFromConfig(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasData) {
          // Use the splash style from config
          return _getSplashWidget(snapshot.data!);
        } else {
          // Default to startup style if config not available
          debugPrint(
              '⚠️ Could not get splash style from config, using default');
          return _getSplashWidget(SplashStyle.startup);
        }
      },
    );
  }

  /// Get splash style from config
  Future<SplashStyle> _getSplashStyleFromConfig() async {
    final configHelper = AssetConfigHelper();
    await configHelper.loadConfig();

    final styleString =
        configHelper.getString('splash_configuration.style', 'startup');
    final style = _parseStyleFromString(styleString);

    debugPrint('🎨 Splash style from config: $styleString -> $style');

    return style;
  }

  /// Convert string to SplashStyle enum
  SplashStyle _parseStyleFromString(String styleString) {
    switch (styleString.toLowerCase()) {
      case 'space':
        return SplashStyle.space;
      case 'enterprise':
        return SplashStyle.enterprise;
      case 'startup':
      default:
        return SplashStyle.startup;
    }
  }

  /// Get appropriate splash widget based on style
  Widget _getSplashWidget(SplashStyle style) {
    // Use the appropriate splash widget based on style
    switch (style) {
      case SplashStyle.startup:
        return SplashStartupWidget(onLogoTap: () => goRoute(Routes.home.name));
      case SplashStyle.space:
        return SplashSpaceWidget(onLogoTap: () => goRoute(Routes.home.name));
      case SplashStyle.enterprise:
        return SplashEnterpriseWidget(
            onLogoTap: () => goRoute(Routes.home.name));
    }
  }
}
