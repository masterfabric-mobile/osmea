import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:core/src/base/base_view_model_cubit.dart';
import 'package:core/src/helper/asset_config_helper.dart';
import 'package:core/src/helper/onboarding_helper.dart';
import 'package:core/src/views/splash/cubit/splash_state.dart';
import 'package:core/src/models/splash_models.dart';
import 'package:injectable/injectable.dart';

/// 🚀 **OSMEA Splash Cubit**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/core
///
/// Cubit that manages splash operations with MVVM pattern
///
/// {@category ViewModels}
/// {@subCategory SplashCubit}

@injectable
class SplashCubit extends BaseViewModelCubit<SplashState> {
  SplashCubit() : super(const SplashState());

  final AssetConfigHelper _configHelper = AssetConfigHelper();
  final OnboardingStorageHelper _onboardingHelper = OnboardingStorageHelper();

  // Logo tap counter for dev mode
  int _logoTapCount = 0;
  DateTime? _lastTapTime;

  /// 📱 Initialize splash screen
  Future<void> initializeSplash() async {
    try {
      debugPrint("🚀 Initializing splash screen...");

      stateChanger(state.copyWith(status: SplashStatus.loading));

      // Load app config
      final configLoaded =
          await _configHelper.loadConfig('assets/app_config.json');
      if (!configLoaded) {
        debugPrint("❌ Failed to load configuration file");
        stateChanger(state.copyWith(
          status: SplashStatus.error,
          errorMessage: "Configuration file could not be loaded",
        ));
        return;
      }

      // Access full configuration
      final configData = _configHelper.getAllConfig();
      if (configData == null) {
        debugPrint("❌ Configuration data not found");
        stateChanger(state.copyWith(
          status: SplashStatus.error,
          errorMessage: "Configuration data could not be loaded",
        ));
        return;
      }

      // Extract splash configuration (Map or String)
      final splashData = configData['splash_configuration'];
      if (splashData == null) {
        debugPrint("❌ Splash configuration not found");
        stateChanger(state.copyWith(
          status: SplashStatus.error,
          errorMessage: "Splash configuration not found",
        ));
        return;
      }

      Map<String, dynamic> splashConfigMap;
      if (splashData is String) {
        try {
          splashConfigMap = json.decode(splashData) as Map<String, dynamic>;
        } catch (e) {
          debugPrint("❌ Error parsing splash JSON string: $e");
          stateChanger(state.copyWith(
            status: SplashStatus.error,
            errorMessage: "Invalid splash configuration format",
          ));
          return;
        }
      } else if (splashData is Map<String, dynamic>) {
        splashConfigMap = splashData;
      } else {
        debugPrint("❌ Unsupported splash data type: ${splashData.runtimeType}");
        stateChanger(state.copyWith(
          status: SplashStatus.error,
          errorMessage: "Unsupported splash configuration format",
        ));
        return;
      }

      // Merge some top-level fields if needed
      splashConfigMap = {
        ...splashConfigMap,
        // Provide defaults if not present
        'animation_duration': splashConfigMap['animation_duration'] ?? 300,
      };

      final config = SplashConfigModel.fromJson(splashConfigMap);

      // Update state with loaded configuration
      stateChanger(state.copyWith(
        status: SplashStatus.ready,
        config: config,
      ));

      // Start splash timer
      await _startSplashTimer();
    } catch (e) {
      debugPrint("❌ Error occurred while initializing splash: $e");
      stateChanger(state.copyWith(
        status: SplashStatus.error,
        errorMessage: "Failed to initialize splash: ${e.toString()}",
      ));
    }
  }

  /// ⏱️ Start splash timer and handle navigation
  Future<void> _startSplashTimer() async {
    try {
      // Wait for configured duration
      final duration = Duration(seconds: state.config?.durationSeconds ?? 3);
      debugPrint("⏱️ Waiting ${duration.inSeconds} seconds...");

      await Future.delayed(duration);

      debugPrint("✅ Splash timer completed, determining navigation...");

      // Determine navigation target
      await _determineNavigationTarget();
    } catch (e) {
      debugPrint("❌ Error in splash timer: $e");
      stateChanger(state.copyWith(
        status: SplashStatus.error,
        errorMessage: "Splash timer error: ${e.toString()}",
      ));
    }
  }

  /// 🧭 Determine navigation target based on configuration and user state
  Future<void> _determineNavigationTarget() async {
    try {
      String navigationTarget;

      // Get configuration values
      final maintenanceMode =
          _configHelper.getBool('app_settings.maintenance_mode', false);
      final onboardingEnabled =
          _configHelper.getBool('feature_flags.onboarding_enabled', true);

      // Check maintenance mode first
      if (maintenanceMode) {
        navigationTarget = '/home';
      }
      // Check if onboarding is enabled
      else if (!onboardingEnabled) {
        navigationTarget = '/home';
      }
      // Check if onboarding has been seen before
      else {
        try {
          final hasSeenOnboarding = await _onboardingHelper.hasSeenOnboarding();

          if (hasSeenOnboarding) {
            navigationTarget = '/home';
          } else {
            // Onboarding config
            final onboardingConfig =
                _configHelper.getAllConfig()?['onboarding_configuration'];
            if (onboardingConfig == null) {
              navigationTarget = '/home';
            } else {
              navigationTarget = '/onboarding';
            }
          }
        } catch (e) {
          // Fallback to onboarding if we can't check status
          navigationTarget = '/onboarding';
        }
      }

      // Update state with navigation target
      stateChanger(state.copyWith(
        status: SplashStatus.completed,
        navigationTarget: navigationTarget,
      ));
    } catch (e) {
      debugPrint("❌ Error determining navigation target: $e");
      // Fallback to home instead of onboarding
      stateChanger(state.copyWith(
        status: SplashStatus.completed,
        navigationTarget: '/onboarding',
        errorMessage: "Navigation error, using fallback: ${e.toString()}",
      ));
    }
  }

  /// 👆 Handle logo tap for dev mode
  void handleLogoTap() {
    final config = state.config;
    if (config == null || !config.devModeEnabled) {
      debugPrint("🔒 Logo tap for dev mode is disabled");
      return;
    }

    final DateTime now = DateTime.now();
    const Duration timeout = Duration(milliseconds: 2000); // Default 2 seconds

    // Reset counter if timeout exceeded
    if (_lastTapTime != null && now.difference(_lastTapTime!) > timeout) {
      _logoTapCount = 0;
    }

    _logoTapCount++;
    _lastTapTime = now;

    // Update state with tap count
    stateChanger(state.copyWith(
      logoTapCount: _logoTapCount,
      isDevModeActive: _logoTapCount >= config.devModeTapCount,
    ));

    debugPrint(
        "🖱️ Logo tapped $_logoTapCount times (need ${config.devModeTapCount})");

    // Check if required taps reached
    if (_logoTapCount >= config.devModeTapCount) {
      _logoTapCount = 0;
      _showDevModeInfo();
    }
  }

  /// 🛠️ Show development mode information
  void _showDevModeInfo() {
    final bool isDevMode =
        _configHelper.getBool('app_settings.debug_mode', false);

    debugPrint(
        "🛠️ Dev mode info: ${isDevMode ? 'Development Mode' : 'Production Mode'}");

    // This will be handled by the UI layer through state listening
    // We could add a devModeInfo field to state if needed
  }

  /// 🔄 Retry initialization after error
  Future<void> retryInitialization() async {
    debugPrint("🔄 Retrying splash initialization...");
    await initializeSplash();
  }

  /// 🏠 Navigate to home (skip onboarding)
  void navigateToHome() {
    debugPrint("🏠 Force navigation to home");
    stateChanger(state.copyWith(
      status: SplashStatus.completed,
      navigationTarget: '/home',
    ));
  }

  /// 📚 Navigate to onboarding
  void navigateToOnboarding() {
    debugPrint("📚 Force navigation to onboarding");
    stateChanger(state.copyWith(
      status: SplashStatus.completed,
      navigationTarget: '/onboarding',
    ));
  }

  /// 🎨 Get primary color from hex string
  Color getPrimaryColor(BuildContext context) {
    try {
      final primaryColor = state.config?.primaryColor ?? '#2196F3';
      final cleanHex = primaryColor.replaceFirst('#', '');
      return Color(int.parse('FF$cleanHex', radix: 16));
    } catch (e) {
      final primaryColor = state.config?.primaryColor ?? 'unknown';
      debugPrint("⚠️ Error parsing color $primaryColor: $e");
      return Theme.of(context).primaryColor;
    }
  }

  /// 📊 Get current configuration status
  Map<String, dynamic> getConfigurationStatus() {
    final config = state.config;
    return {
      'configuration_loaded': state.status != SplashStatus.initial,
      'app_name': config?.appName,
      'app_version': config?.appVersion,
      'splash_duration': config?.durationSeconds,
      'onboarding_enabled':
          _configHelper.getBool('feature_flags.onboarding_enabled', true),
      'maintenance_mode':
          _configHelper.getBool('app_settings.maintenance_mode', false),
      'navigation_target': state.navigationTarget,
    };
  }
}
