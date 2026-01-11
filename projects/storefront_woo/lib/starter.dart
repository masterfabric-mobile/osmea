import 'package:storefront_woo/app/routes/app_routes.dart';
import 'package:storefront_woo/app/core/config/config_di.dart';
import 'package:storefront_woo/services/wordpress_config_service.dart';
import 'package:storefront_woo/services/wordpress_config_integration.dart';
import 'package:get_it/get_it.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:storefront_woo/gen/translations.g.dart' as app_translations;
import 'package:flutter_localizations/flutter_localizations.dart';

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
  
  // 📡 Try to load WordPress config and merge with local config
  WordPressConfigIntegration? wordPressConfigIntegration;
  bool configLoaded = false;
  
  try {
    debugPrint('📡 Attempting to load configuration from WordPress...');
    
    final wordPressService = WordPressConfigService(
      baseUrl: 'http://example.com', // WordPress site URL
    );
    
    wordPressConfigIntegration = WordPressConfigIntegration(
      configService: wordPressService,
      assetConfigHelper: assetConfigHelper,
    );
    
    // Load and merge WordPress config with local config
    final mergedConfig = await wordPressConfigIntegration!.loadAndMergeConfig(
      localConfigPath: 'assets/app_config.json',
      useWordPressAsPrimary: true, // WordPress config overrides local
    );
    
    if (mergedConfig != null) {
      configLoaded = true;
      debugPrint('✅ Configuration loaded: WordPress + Local (merged)');
      
      // Set merged config to AssetConfigHelper so all parts of the app use it
      assetConfigHelper.setConfig(mergedConfig, 'wordpress_merged_config');
      debugPrint('✅ Merged config set to AssetConfigHelper');
    } else {
      // Fallback to local config only
      debugPrint('⚠️ WordPress config failed, falling back to local config');
      configLoaded = await assetConfigHelper.loadConfig(
        'assets/app_config.json',
      );
    }
  } catch (e) {
    debugPrint('⚠️ WordPress config integration error: $e');
    debugPrint('📦 Falling back to local config only');
    configLoaded = await assetConfigHelper.loadConfig(
      'assets/app_config.json',
    );
  }
  
  // Simple config source info
  final configStats = assetConfigHelper.getConfigStats();
  final configSource = configStats['config_source'] ?? 'unknown';
  debugPrint(
    '📂 Config Source: ${wordPressConfigIntegration != null && wordPressConfigIntegration!.mergedConfig != null
        ? '🌐 WordPress + Local (merged)'
        : configSource == 'project_specific'
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
  // NOTE: HydratedCubit automatically restores state from storage on construction
  // We only need to call loadTokens() if state is not already authenticated
  try {
    if (GetIt.instance.isRegistered<AuthCubit>()) {
      // Already registered - ensure it's the same instance everywhere
      try {
        final existing = GetIt.I<AuthCubit>();
        debugPrint('✅ AuthCubit already registered in GetIt (singleton)');
        debugPrint('🔍 AuthCubit current state: ${existing.state.runtimeType}');
        
        // Only load tokens if state is initial or unauthenticated
        // HydratedCubit may have already restored authenticated state
        if (existing.state is AuthInitialState || existing.state is AuthUnauthenticatedState) {
          debugPrint('🔄 AuthCubit: Loading tokens from storage...');
          await existing.loadTokens();
          debugPrint('✅ AuthCubit tokens loaded');
        } else if (existing.state is AuthAuthenticatedState) {
          final authState = existing.state as AuthAuthenticatedState;
          debugPrint('✅ AuthCubit: Already authenticated (restored from storage)');
          debugPrint('🔍 AuthCubit: JWT token present: ${authState.jwtToken != null && authState.jwtToken!.isNotEmpty}');
          // Verify token is still valid in storage
          final authStorage = AuthStorageHelper();
          final storageToken = await authStorage.getToken();
          if (storageToken == null || storageToken.isEmpty || storageToken != authState.jwtToken) {
            debugPrint('⚠️ AuthCubit: Token mismatch, reloading from storage...');
            await existing.loadTokens();
          }
        }
      } catch (e) {
        debugPrint('⚠️ Error accessing existing AuthCubit: $e');
        // If there's an issue, unregister and re-register as singleton
        try {
          GetIt.instance.unregister<AuthCubit>();
        } catch (_) {}
        final authCubit = AuthCubit();
        GetIt.instance.registerSingleton<AuthCubit>(authCubit);
        // HydratedCubit may have already restored state, check before loading
        if (authCubit.state is AuthInitialState || authCubit.state is AuthUnauthenticatedState) {
          await authCubit.loadTokens();
        }
        debugPrint('✅ AuthCubit re-registered as singleton');
      }
    } else {
      // AuthCubit not registered - register it now as singleton
      debugPrint('⚠️ AuthCubit not in GetIt, registering as singleton...');
      final authCubit = AuthCubit();
      GetIt.instance.registerSingleton<AuthCubit>(authCubit);
      debugPrint('🔍 AuthCubit initial state: ${authCubit.state.runtimeType}');
      
      // HydratedCubit automatically restores state from storage on construction
      // Only load tokens if state is not already authenticated
      if (authCubit.state is AuthInitialState || authCubit.state is AuthUnauthenticatedState) {
        debugPrint('🔄 AuthCubit: Loading tokens from storage...');
        await authCubit.loadTokens();
        debugPrint('✅ AuthCubit tokens loaded');
      } else if (authCubit.state is AuthAuthenticatedState) {
        final authState = authCubit.state as AuthAuthenticatedState;
        debugPrint('✅ AuthCubit: Already authenticated (restored from HydratedCubit storage)');
        debugPrint('🔍 AuthCubit: JWT token present: ${authState.jwtToken != null && authState.jwtToken!.isNotEmpty}');
        // Verify token is still valid in storage
        final authStorage = AuthStorageHelper();
        final storageToken = await authStorage.getToken();
        if (storageToken == null || storageToken.isEmpty || storageToken != authState.jwtToken) {
          debugPrint('⚠️ AuthCubit: Token mismatch, reloading from storage...');
          await authCubit.loadTokens();
        } else {
          debugPrint('✅ AuthCubit: Token verified, state is valid');
        }
      }
      debugPrint('✅ AuthCubit registered as singleton and initialized');
    }
  } catch (e) {
    debugPrint('⚠️ Error initializing AuthCubit: $e');
  }

  // 🎨 Get UI configuration from config helpers
  // Use WordPress config integration if available, otherwise fallback to AssetConfigHelper
  bool debugMode;
  double fontScale;
  String themeMode;
  
  if (wordPressConfigIntegration != null && wordPressConfigIntegration!.mergedConfig != null) {
    // Use WordPress merged config
    debugMode = configLoaded
        ? wordPressConfigIntegration!.getBool(
            'app_settings.debug_mode',
            environment == 'dev',
          )
        : (environment == 'dev');
    
    fontScale = configLoaded
        ? wordPressConfigIntegration!.getDouble('ui_configuration.font_scale', 1.0)
        : 1.0;
    
    themeMode = configLoaded
        ? wordPressConfigIntegration!.getString('ui_configuration.theme_mode', 'light')
        : 'light';
  } else {
    // Use local AssetConfigHelper
    debugMode = configLoaded
        ? assetConfigHelper.getBool(
            'app_settings.debug_mode',
            environment == 'dev',
          )
        : (environment == 'dev');
    
    fontScale = configLoaded
        ? assetConfigHelper.getDouble('ui_configuration.font_scale', 1.0)
        : 1.0;
    
    themeMode = configLoaded
        ? assetConfigHelper.getString('ui_configuration.theme_mode', 'light')
        : 'light';
  }

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

  // Initialize locale settings
  app_translations.LocaleSettings.useDeviceLocaleSync();

  // Run the main application with the specified router and configuration
  runApp(
    app_translations.TranslationProvider(
      child: MasterApp(
        router: appRouter, // The router handles navigation within the app
        devModeGrid: debugMode, // Use configuration-based debug mode
        devModeSpacer: debugMode, // Use configuration-based debug mode
        useConfigurationHelpers:
            true, // Enable configuration helpers in MasterApp
        themeMode: appThemeMode, // Apply theme mode from configuration
        fontScale: fontScale, // Apply font scale from configuration
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: app_translations.AppLocaleUtils.supportedLocales,
        locale: app_translations.LocaleSettings.currentLocale.flutterLocale,
      ),
    ),
  );

  debugPrint('✅ Storefront WooCommerce App launched successfully');
}
