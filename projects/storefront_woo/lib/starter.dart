import 'package:storefront_woo/app/routes/app_routes.dart';
import 'package:storefront_woo/app/core/config/config_di.dart';
import 'package:storefront_woo/app/widgets/config_update_notifier.dart';
import 'package:storefront_woo/services/wordpress_config_service.dart';
import 'package:storefront_woo/services/wordpress_config_integration.dart';
import 'package:storefront_woo/services/config_version_helper.dart';
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
  WordPressConfigService? wordPressService;
  bool configLoaded = false;
  bool pluginVersionChanged = false;
  bool isUsingWordPressConfig = false;

  try {
    debugPrint('📡 Attempting to load configuration from WordPress...');

    wordPressService = WordPressConfigService(
      baseUrl: 'https://masterfabric.store', // WordPress site URL
    );

    wordPressConfigIntegration = WordPressConfigIntegration(
      configService: wordPressService,
      assetConfigHelper: assetConfigHelper,
    );

    // Load and merge WordPress config with local config
    final mergedConfig = await wordPressConfigIntegration.loadAndMergeConfig(
      localConfigPath: 'assets/app_config.json',
      useWordPressAsPrimary: true, // WordPress config overrides local
    );

    if (mergedConfig != null) {
      configLoaded = true;
      isUsingWordPressConfig = true;
      debugPrint('✅ Configuration loaded: WordPress + Local (merged)');

      // 🔁 Detect WordPress plugin config version changes (only when feeding from WordPress)
      final currentPluginVersion =
          mergedConfig['config_meta']?['plugin_version']?.toString();
      if (currentPluginVersion != null && currentPluginVersion.isNotEmpty) {
        final versionHelper = ConfigVersionHelper();
        pluginVersionChanged = await versionHelper.hasPluginVersionChanged(
          currentPluginVersion,
        );
      }

      // Ensure woocommerce_configuration.store_url is set
      // If WordPress config doesn't provide it, use the WordPress baseUrl as fallback
      if (!mergedConfig.containsKey('woocommerce_configuration') ||
          mergedConfig['woocommerce_configuration'] == null) {
        mergedConfig['woocommerce_configuration'] = <String, dynamic>{};
      }

      final wooConfig =
          mergedConfig['woocommerce_configuration'] as Map<String, dynamic>;

      // Set store_url if missing or invalid
      final currentStoreUrl = wooConfig['store_url'] as String?;
      if (currentStoreUrl == null ||
          currentStoreUrl.isEmpty ||
          currentStoreUrl == 'http://example.com') {
        // Use WordPress baseUrl as fallback, converting http to https
        final fallbackUrl = wordPressService.baseUrl.replaceFirst(
          'http://',
          'https://',
        );
        wooConfig['store_url'] = fallbackUrl;
        debugPrint(
          '⚠️ store_url not found in WordPress config, using baseUrl as fallback: $fallbackUrl',
        );
      } else {
        debugPrint('✅ store_url found in WordPress config: $currentStoreUrl');
      }

      // Ensure brand_name is set (required for JWT auth)
      final currentBrandName = wooConfig['brand_name'] as String?;
      if (currentBrandName == null ||
          currentBrandName.isEmpty ||
          currentBrandName == 'example') {
        // Use a default brand name if not provided
        wooConfig['brand_name'] = 'simple-jwt-login';
        debugPrint(
          '⚠️ brand_name not found in WordPress config, using default: simple-jwt-login',
        );
      } else {
        debugPrint('✅ brand_name found in WordPress config: $currentBrandName');
      }

      // Ensure version is set
      if (wooConfig['version'] == null || wooConfig['version'] == '') {
        wooConfig['version'] = 'v1';
        debugPrint(
          '⚠️ version not found in WordPress config, using default: v1',
        );
      }

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
    configLoaded = await assetConfigHelper.loadConfig('assets/app_config.json');
  }

  // Simple config source info
  final configStats = assetConfigHelper.getConfigStats();
  final configSource = configStats['config_source'] ?? 'unknown';
  debugPrint(
    '📂 Config Source: ${wordPressConfigIntegration != null && wordPressConfigIntegration.mergedConfig != null
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
        if (existing.state is AuthInitialState ||
            existing.state is AuthUnauthenticatedState) {
          debugPrint('🔄 AuthCubit: Loading tokens from storage...');
          await existing.loadTokens();
          debugPrint('✅ AuthCubit tokens loaded');
        } else if (existing.state is AuthAuthenticatedState) {
          final authState = existing.state as AuthAuthenticatedState;
          debugPrint(
            '✅ AuthCubit: Already authenticated (restored from storage)',
          );
          debugPrint(
            '🔍 AuthCubit: JWT token present: ${authState.jwtToken != null && authState.jwtToken!.isNotEmpty}',
          );
          // Verify token is still valid in storage
          final authStorage = AuthStorageHelper();
          final storageToken = await authStorage.getToken();
          if (storageToken == null ||
              storageToken.isEmpty ||
              storageToken != authState.jwtToken) {
            debugPrint(
              '⚠️ AuthCubit: Token mismatch, reloading from storage...',
            );
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
        if (authCubit.state is AuthInitialState ||
            authCubit.state is AuthUnauthenticatedState) {
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
      if (authCubit.state is AuthInitialState ||
          authCubit.state is AuthUnauthenticatedState) {
        debugPrint('🔄 AuthCubit: Loading tokens from storage...');
        await authCubit.loadTokens();
        debugPrint('✅ AuthCubit tokens loaded');
      } else if (authCubit.state is AuthAuthenticatedState) {
        final authState = authCubit.state as AuthAuthenticatedState;
        debugPrint(
          '✅ AuthCubit: Already authenticated (restored from HydratedCubit storage)',
        );
        debugPrint(
          '🔍 AuthCubit: JWT token present: ${authState.jwtToken != null && authState.jwtToken!.isNotEmpty}',
        );
        // Verify token is still valid in storage
        final authStorage = AuthStorageHelper();
        final storageToken = await authStorage.getToken();
        if (storageToken == null ||
            storageToken.isEmpty ||
            storageToken != authState.jwtToken) {
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

  if (wordPressConfigIntegration != null &&
      wordPressConfigIntegration.mergedConfig != null) {
    // Use WordPress merged config
    debugMode = configLoaded
        ? wordPressConfigIntegration.getBool(
            'app_settings.debug_mode',
            environment == 'dev',
          )
        : (environment == 'dev');

    fontScale = configLoaded
        ? wordPressConfigIntegration.getDouble(
            'ui_configuration.font_scale',
            1.0,
          )
        : 1.0;

    themeMode = configLoaded
        ? wordPressConfigIntegration.getString(
            'ui_configuration.theme_mode',
            'light',
          )
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

  // WordPress config check interval (sec): from config, used when app is in foreground
  // Varsayılanı agresif tut (4 sn) ki plugin tarafındaki değişiklikler
  // çok hızlı yakalansın. İstenirse app_config.json'dan override edilebilir.
  int configCheckIntervalSeconds = 4;
  final wpIntegration = wordPressConfigIntegration;
  if (wpIntegration != null && wpIntegration.mergedConfig != null) {
    configCheckIntervalSeconds = wpIntegration.getInt(
      'app_settings.wordpress_config_check_interval_seconds',
      4,
    );
  } else {
    configCheckIntervalSeconds = assetConfigHelper.getInt(
      'app_settings.wordpress_config_check_interval_seconds',
      4,
    );
  }
  // 4 sn ile 600 sn arasında sınırla; min'i 4 sn yaptık ki "her 4 sn" isteği
  // sağlansın.
  configCheckIntervalSeconds = configCheckIntervalSeconds.clamp(4, 600);
  final periodicCheckInterval = Duration(seconds: configCheckIntervalSeconds);

  debugPrint('🎨 Applied UI Configuration:');
  debugPrint('  - Theme Mode: $themeMode');
  debugPrint('  - Font Scale: $fontScale');
  debugPrint('  - Debug Mode: $debugMode');
  debugPrint('  - Plugin Config Version Changed: $pluginVersionChanged');
  debugPrint('  - Config check interval: ${configCheckIntervalSeconds}s');

  // Initialize locale settings
  // Force English so no Turkish strings are shown anywhere
  // (ignores device locale and any remote/local default language).
  app_translations.LocaleSettings.setLocaleSync(
    app_translations.AppLocale.en,
    listenToDeviceLocale: false,
  );

  // Run the main application. ConfigUpdateNotifier (snackbar + auto-restart)
  // exists only when feeding from WordPress; if using local config only, that
  // structure is not used.
  final masterApp = MasterApp(
    router: appRouter,
    devModeGrid: debugMode,
    devModeSpacer: debugMode,
    useConfigurationHelpers: true,
    themeMode: appThemeMode,
    fontScale: fontScale,
    localizationsDelegates: const [
      GlobalMaterialLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
    supportedLocales: app_translations.AppLocaleUtils.supportedLocales,
    locale: app_translations.LocaleSettings.currentLocale.flutterLocale,
  );

  runApp(
    app_translations.TranslationProvider(
      child: isUsingWordPressConfig
          ? ConfigUpdateNotifier(
              pluginVersionChanged: pluginVersionChanged,
              periodicCheckInterval: periodicCheckInterval,
              onResumeCheckForUpdate: () async {
                final ws = wordPressService;
                if (ws == null) return false;
                try {
                  // bypassCache so version check sees updated plugin_version
                  final cfg = await ws.fetchAppConfig(bypassCache: true);
                  final v = cfg['config_meta']?['plugin_version']?.toString();
                  if (v == null || v.isEmpty) return false;
                  return await ConfigVersionHelper().hasPluginVersionChanged(v);
                } catch (_) {
                  return false;
                }
              },
              onSoftRestart: () async {
                // 1) Yeni config/asset'leri ÖNCE çek -> Splash bile yeni stil ile açılsın
                final wp = wordPressConfigIntegration;
                if (wp != null) {
                  try {
                    final mergedConfig = await wp.loadAndMergeConfig(
                      localConfigPath: 'assets/app_config.json',
                      useWordPressAsPrimary: true,
                    );
                    if (mergedConfig != null) {
                      if (!mergedConfig.containsKey(
                            'woocommerce_configuration',
                          ) ||
                          mergedConfig['woocommerce_configuration'] == null) {
                        mergedConfig['woocommerce_configuration'] =
                            <String, dynamic>{};
                      }
                      final wooConfig =
                          mergedConfig['woocommerce_configuration']
                              as Map<String, dynamic>;
                      final baseUrl =
                          wordPressService?.baseUrl ??
                          'https://example.com';
                      if (wooConfig['store_url'] == null ||
                          wooConfig['store_url'].toString().isEmpty ||
                          wooConfig['store_url'] == 'http://example.com') {
                        wooConfig['store_url'] = baseUrl.replaceFirst(
                          'http://',
                          'https://',
                        );
                      }
                      if (wooConfig['brand_name'] == null ||
                          wooConfig['brand_name'].toString().isEmpty ||
                          wooConfig['brand_name'] == 'example') {
                        wooConfig['brand_name'] = 'simple-jwt-login';
                      }
                      if (wooConfig['version'] == null ||
                          wooConfig['version'].toString().isEmpty) {
                        wooConfig['version'] = 'v1';
                      }
                      assetConfigHelper.setConfig(
                        mergedConfig,
                        'wordpress_merged_config',
                      );
                      debugPrint(
                        '✅ Soft restart: config reloaded and set to AssetConfigHelper',
                      );
                    }
                  } catch (e) {
                    debugPrint('⚠️ Soft restart config reload error: $e');
                  }
                }

                // 2) Sonra root route'a (splash) git -> campaign/onboarding/home akışı yeni config ile çalışır
                appRouter.go('/');
              },
              child: masterApp,
            )
          : masterApp,
    ),
  );

  debugPrint('✅ Storefront WooCommerce App launched successfully');
}
