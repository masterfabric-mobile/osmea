import 'package:core/core.dart';
import 'package:core/src/base/master_view_cubit/master_view_cubit.dart';
import 'package:core/src/base/widgets/master_scaffold_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:core/src/views/splash/cubit/splash_cubit.dart';
import 'package:core/src/views/splash/cubit/splash_state.dart';
import 'package:core/src/models/splash_models.dart';
import 'package:core/src/views/splash/widgets/splash_startup_widget.dart';
import 'package:core/src/views/splash/widgets/splash_space_widget.dart';
import 'package:core/src/views/splash/widgets/splash_enterprise_widget.dart';
import 'package:core/src/helper/asset_config_helper.dart';
import 'package:core/src/views/routes.dart';

/// 🚀 **OSMEA Splash View**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/core
///
/// Main splash view - Simple timer-based navigation
/// Uses MasterViewCubit for lifecycle management
///
/// ## 🎨 Color Scheme by Style:
/// - **Startup**: 🟠 Orange status bar and background
/// - **Space**: 🔵 Blue (Nordic Blue) status bar and background
/// - **Enterprise**: 🟣 Purple (Deep Sea) status bar and background
///
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

    // Test: Apply a simple red color immediately
    debugPrint('🔴 TESTING: Setting RED status bar color');
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.red,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    debugPrint('🔴 RED color applied');

    // Apply status bar color IMMEDIATELY
    _applyStatusBarColor(SplashStyle.startup);

    // Trigger onStart callback
    onStart?.call();

    // Initialize the splash cubit with app configuration
    await viewModel.initializeSplash();

    // Get duration and navigation settings from AppConfig
    final configHelper = AssetConfigHelper();
    await configHelper.loadConfig();

    final durationMs =
        configHelper.getInt('splash_configuration.duration_milliseconds', 3000);
    final shouldAutoNavigate =
        configHelper.getBool('splash_configuration.auto_navigate', true);

    // Setup auto-navigation if enabled
    if (shouldAutoNavigate) {
      Timer(Duration(milliseconds: durationMs), () {
        // Trigger onComplete callback
        onComplete?.call();

        final currentState = viewModel.state;
        final target = currentState.navigationTarget ?? '/home';
        goRoute(target);
      });
    }
  }

  @override
  Widget viewContent(BuildContext context, viewModel, state) {
    // Test: Apply blue color immediately in viewContent
    debugPrint('🔵 TESTING: Setting BLUE status bar color in viewContent');
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.blue,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    debugPrint('🔵 BLUE color applied in viewContent');

    return FutureBuilder<SplashStyle>(
      future: _getSplashStyleFromConfig(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Apply startup color while loading
          _applyStatusBarColor(SplashStyle.startup);
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasData) {
          // Apply status bar color based on splash style
          _applyStatusBarColor(snapshot.data!);

          // Force immediate application with post frame callback
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _applyStatusBarColor(snapshot.data!);
          });

          // Use the splash style from config
          return _getSplashWidget(snapshot.data!);
        } else {
          // Default to startup style if config not available
          debugPrint(
              '⚠️ Could not get splash style from config, using default');
          _applyStatusBarColor(SplashStyle.startup);

          // Force immediate application with post frame callback
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _applyStatusBarColor(SplashStyle.startup);
          });

          return _getSplashWidget(SplashStyle.startup);
        }
      },
    );
  }

  /// 🎨 Apply status bar color based on splash style
  void _applyStatusBarColor(SplashStyle style) {
    final statusBarColor = _getStatusBarColorForStyle(style);
    final iconBrightness = _getIconBrightnessForColor(statusBarColor);

    debugPrint('🎨 Setting status bar color for $style: $statusBarColor');
    debugPrint('🎨 Icon brightness: $iconBrightness');
    debugPrint('🎨 Color hex: ${statusBarColor.value.toRadixString(16)}');

    try {
      // Force immediate application
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: statusBarColor,
          statusBarIconBrightness: iconBrightness,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
      );

      debugPrint('✅ Status bar color applied successfully');
    } catch (e) {
      debugPrint('❌ Error applying status bar color: $e');
    }
  }

  /// 🎨 Get status bar color for splash style
  Color _getStatusBarColorForStyle(SplashStyle style) {
    Color color;
    switch (style) {
      case SplashStyle.startup:
        color = OsmeaColors.orange; // 🟠 Orange for startup
        break;
      case SplashStyle.space:
        color = OsmeaColors.nordicBlue; // 🔵 Blue for space
        break;
      case SplashStyle.enterprise:
        color = OsmeaColors.deepSea; // 🟣 Purple for enterprise
        break;
    }
    debugPrint('🎨 Selected color for $style: $color');
    return color;
  }

  /// 🎨 Get appropriate icon brightness for color
  Brightness _getIconBrightnessForColor(Color color) {
    return color.computeLuminance() > 0.5 ? Brightness.dark : Brightness.light;
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
