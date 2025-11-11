import 'package:storefront_woo/app/routes/app_routes.dart';
import 'package:storefront_woo/app/core/config/config_di.dart';
import 'package:get_it/get_it.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';

/// 🚀 Launch the Storefront WooCommerce application
///
/// This function initializes all necessary components and starts the app with
/// configuration management using both local assets and Firebase Remote Config.
///
/// Parameters:
/// - [environment]: The environment mode ('dev', 'staging', 'production')
///
/// Configuration Flow:
/// 1. Load local app_config.json from @core package assets
/// 2. Initialize Firebase and Remote Config (if enabled)
/// 3. Merge remote configuration with local configuration
/// 4. Apply configuration to app settings (theme, font scale, etc.)
///
/// Usage Example:
/// ```dart
/// void main() async {
///   await launchApp(environment: 'dev');
/// }
/// ```
launchApp({String environment = 'dev'}) async {
  /// Initializes necessary components before the app starts.
  WidgetsFlutterBinding.ensureInitialized();

  // 🔧 Determine configuration settings based on environment
  bool enableRemoteConfig =
      environment != 'dev'; // Enable remote config for staging/production
  bool allowTelemetry =
      environment == 'production'; // Only collect telemetry in production

  debugPrint('🚀 Starting Storefront WooCommerce App');
  debugPrint('🔧 Environment: $environment');
  debugPrint(
    '📡 Remote Config: ${enableRemoteConfig ? 'Enabled' : 'Disabled'}',
  );
  debugPrint('📊 Telemetry: ${allowTelemetry ? 'Enabled' : 'Disabled'}');

  // Perform any necessary setup before the app starts with configuration management
  await MasterApp.runBefore(
    hydrated: true, // Enable HydratedBloc storage initialization
    allowCollectDataTelemetry: allowTelemetry,
    enableRemoteConfig: enableRemoteConfig,
    assetConfigPath:
        'assets/app_config.json', // Use project-specific config, fallback to @core package
  );

  // 🗂️ Initialize configuration helpers for app-level usage
  final AssetConfigHelper assetConfigHelper = AssetConfigHelper();
  bool configLoaded = await assetConfigHelper.loadConfig(
    'assets/app_config.json',
  );

  // Simple config source info
  final configStats = assetConfigHelper.getConfigStats();
  final configSource = configStats['config_source'] ?? 'unknown';
  debugPrint(
    '📂 Config: ${configSource == 'project_specific'
        ? '🎯 Project'
        : configSource == 'core_package_fallback'
        ? '📦 Core Package'
        : '⚠️ Default'}',
  );

  // Configure dependency injection for the application
  await configureDependencies(environment: environment);

  // Initialize AuthCubit and register in GetIt as SINGLETON (not factory!)
  // This ensures all parts of the app use the same AuthCubit instance
  // CRITICAL: AuthCubit must be singleton to avoid state desync issues
  try {
    if (GetIt.instance.isRegistered<AuthCubit>()) {
      // Already registered - ensure it's the same instance everywhere
      try {
        final existing = GetIt.I<AuthCubit>();
        debugPrint('✅ AuthCubit already registered in GetIt (singleton)');
        // Load initial tokens from storage if not already loaded
        if (existing.state is AuthInitialState) {
          await existing.loadTokens();
          debugPrint('✅ AuthCubit tokens loaded');
        }
      } catch (e) {
        debugPrint('⚠️ Error accessing existing AuthCubit: $e');
        // If there's an issue, unregister and re-register as singleton
        try {
          GetIt.instance.unregister<AuthCubit>();
        } catch (_) {}
        final authCubit = AuthCubit();
        GetIt.instance.registerSingleton<AuthCubit>(authCubit);
        await authCubit.loadTokens();
        debugPrint('✅ AuthCubit re-registered as singleton');
      }
    } else {
      // AuthCubit not registered - register it now as singleton
      debugPrint('⚠️ AuthCubit not in GetIt, registering as singleton...');
      final authCubit = AuthCubit();
      GetIt.instance.registerSingleton<AuthCubit>(authCubit);
      // Load initial tokens from storage
      await authCubit.loadTokens();
      debugPrint('✅ AuthCubit registered as singleton and initialized');
    }
  } catch (e) {
    debugPrint('⚠️ Error initializing AuthCubit: $e');
  }

  // 🎨 Get UI configuration from config helpers
  bool debugMode = configLoaded
      ? assetConfigHelper.getBool(
          'app_settings.debug_mode',
          environment == 'dev',
        )
      : (environment == 'dev');

  double fontScale = configLoaded
      ? assetConfigHelper.getDouble('ui_configuration.font_scale', 1.0)
      : 1.0;

  String themeMode = configLoaded
      ? assetConfigHelper.getString('ui_configuration.theme_mode', 'light')
      : 'light';

  // Convert theme mode string to ThemeMode enum
  ThemeMode appThemeMode;
  switch (themeMode.toLowerCase()) {
    case 'dark':
      appThemeMode = ThemeMode.dark;
      break;
    case 'system':
      appThemeMode = ThemeMode.system;
      break;
    default:
      appThemeMode = ThemeMode.light;
      break;
  }

  debugPrint('🎨 Applied UI Configuration:');
  debugPrint('  - Theme Mode: $themeMode');
  debugPrint('  - Font Scale: $fontScale');
  debugPrint('  - Debug Mode: $debugMode');

  // Run the main application with the specified router and configuration
  runApp(
    MasterApp(
      router: appRouter, // The router handles navigation within the app
      devModeGrid: debugMode, // Use configuration-based debug mode
      devModeSpacer: debugMode, // Use configuration-based debug mode
      useConfigurationHelpers:
          true, // Enable configuration helpers in MasterApp
      themeMode: appThemeMode, // Apply theme mode from configuration
      fontScale: fontScale, // Apply font scale from configuration
    ),
  );

  debugPrint('✅ Storefront WooCommerce App launched successfully');
}
