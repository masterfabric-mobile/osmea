import 'dart:io';

import 'package:core/firebase_options.dart';
import 'package:core/src/helper/device_info_helper.dart';
import 'package:core/src/helper/local_storage/local_storage_helper.dart';
import 'package:core/src/helper/package_info_helper.dart';
import 'package:core/src/helper/asset_config_helper.dart';
import 'package:core/src/helper/remote_config_helper.dart';
import 'package:core/src/resources/resources.g.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:core/src/layout/grid.dart';
import 'package:core/src/base/master_view_hydrated_cubit/hydrated/hydrated_bloc_init.dart';
import 'package:core/src/helper/permission_handler_helper/permission_handler_helper.dart';

// Global variable for dev mode spacer control
bool globalDevModeSpacer = true;

/// 🚀 MasterApp: The main entry point for the application.
/// Initializes Firebase, loads configuration (asset + remote), and wires the root router.
///
/// How to use the MasterApp:
///
/// To use the MasterApp, you need to create an instance of it and provide a router.
/// Here's a simple example:
///
/// ```dart
/// void main() {
///   final router = GoRouter(
///     routes: [
///       // Define your routes here
///     ],
///   );
///
///   MasterApp.runBefore(); // Initialize necessary components
///   runApp(MasterApp(
///     router: router,
///     shouldSetOrientation: true,
///     preferredOrientations: [
///       DeviceOrientation.portraitUp,
///       DeviceOrientation.portraitDown,
///     ],
///     showPerformanceOverlay: false,
///     textDirection: TextDirection.ltr,
///     fontScale: 1.0,
///   ));
/// }
/// ```

class MasterApp extends StatelessWidget {
  ///
  ///
  /// Initializes necessary components before running the app.
  ///
  /// Sets up Firebase, local storage, configuration sources, and analytics events.
  ///
  /// Parameters:
  /// - [allowCollectDataTelemetry]: A boolean flag that determines whether
  ///   data telemetry should be collected and sent to Firebase Analytics.
  ///   By default, this is set to true, meaning that telemetry data will be collected.
  ///   If set to false, no telemetry data will be sent, allowing users to opt-out
  ///   of data collection for privacy or other reasons.
  ///
  /// This ensures critical services are ready before the app starts and respects
  /// user preferences around telemetry.
  ///
  ///  update date 11/05/2025
  static Future<void> runBefore({
    bool allowCollectDataTelemetry = true,
    bool enableRemoteConfig = true,
    String assetConfigPath = 'assets/app_config.json',
    bool hydrated = false,
  }) async {
    // 🛠️ Initialize necessary components before running the app
    final LocalStorageHelper _localStorageHelper = LocalStorageHelper();
    final AssetConfigHelper _assetConfigHelper = AssetConfigHelper();
    final RemoteConfigHelper _remoteConfigHelper = RemoteConfigHelper();

    /// 🔥 Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // 📊 Firebase Analytics Initialization
    FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    analytics.setAnalyticsCollectionEnabled(true);

    /// ✅ Check if Firebase Analytics is supported
    await FirebaseAnalytics.instance.isSupported();

    /// Enable Firebase Analytics Collection
    await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);

    /// 🗂️ Initialize App Configuration System with Fallback Support
    /// 
    /// Configuration Loading Priority:
    /// 1. Try to load from specified assetConfigPath (project-specific config)
    /// 2. If fails, fallback to @core package's default config
    /// 3. If both fail, continue with default values
    debugPrint('🔄 Initializing app configuration system...');
    
    // Define fallback configuration path (core package default)
    const String fallbackConfigPath = 'packages/core/assets/app_config.json';
    bool assetConfigLoaded = false;
    String actualConfigPath = assetConfigPath;

    // Try to load project-specific configuration first (without fallback)
    try {
      debugPrint('🔍 Attempting to load project-specific configuration: $assetConfigPath');
      assetConfigLoaded = await _assetConfigHelper.loadConfig(assetConfigPath, false); // Disable fallback
      if (assetConfigLoaded) {
        debugPrint('✅ Project-specific asset configuration loaded successfully from: $assetConfigPath');
        actualConfigPath = assetConfigPath;
      } else {
        debugPrint('⚠️ Failed to load project-specific asset configuration from: $assetConfigPath');
      }
    } catch (e) {
      debugPrint('❌ Error loading project-specific config: $e');
    }

    // If project-specific config failed, try @core package fallback
    if (!assetConfigLoaded) {
      try {
        debugPrint('🔄 Attempting to load fallback configuration from @core package: $fallbackConfigPath');
        assetConfigLoaded = await _assetConfigHelper.loadConfig(fallbackConfigPath, false); // Disable fallback for explicit path
        if (assetConfigLoaded) {
          debugPrint('✅ Fallback asset configuration loaded successfully from: $fallbackConfigPath');
          actualConfigPath = fallbackConfigPath;
        } else {
          debugPrint('⚠️ Failed to load fallback asset configuration from: $fallbackConfigPath');
        }
      } catch (e) {
        debugPrint('❌ Error loading fallback config: $e');
      }
    }

    // Final configuration status with enhanced emoji feedback
    if (assetConfigLoaded) {
      final bool isProjectConfig = actualConfigPath == assetConfigPath;
      final String sourceEmoji = isProjectConfig ? '🎯' : '📦';
      final String sourceName = isProjectConfig ? 'PROJECT-SPECIFIC' : 'CORE PACKAGE FALLBACK';
      
      debugPrint('');
      debugPrint('╔══════════════════════════════════════════════════════════╗');
      debugPrint('║                 🗂️  CONFIGURATION LOADED                 ║');
      debugPrint('╠══════════════════════════════════════════════════════════╣');
      debugPrint('║ $sourceEmoji Source: $sourceName');
      debugPrint('║ 📁 Path: $actualConfigPath');
      debugPrint('╠══════════════════════════════════════════════════════════╣');
      
      // Log key configuration values for debugging
      final appName = _assetConfigHelper.getString('app_settings.app_name', 'OSMEA App');
      final environment = _assetConfigHelper.getString('app_settings.environment', 'unknown');
      final debugMode = _assetConfigHelper.getBool('app_settings.debug_mode', false);
      final themeMode = _assetConfigHelper.getString('ui_configuration.theme_mode', 'light');
      
      debugPrint('║ 📱 App Name: $appName');
      debugPrint('║ 🔧 Environment: $environment');
      debugPrint('║ 🐛 Debug Mode: ${debugMode ? '✅ ON' : '❌ OFF'}');
      debugPrint('║ 🎨 Theme: ${themeMode.toUpperCase()}');
      debugPrint('╚══════════════════════════════════════════════════════════╝');
      debugPrint('');
      
      if (isProjectConfig) {
        debugPrint('🎯 SUCCESS: Using your project-specific configuration!');
      } else {
        debugPrint('📦 FALLBACK: Using core package configuration as fallback');
        debugPrint('💡 TIP: Create \'$assetConfigPath\' to use project-specific config');
      }
    } else {
      debugPrint('');
      debugPrint('╔══════════════════════════════════════════════════════════╗');
      debugPrint('║                ⚠️  CONFIGURATION FAILED                 ║');
      debugPrint('╠══════════════════════════════════════════════════════════╣');
      debugPrint('║ ❌ No configuration file could be loaded!');
      debugPrint('║ 🔍 Attempted paths:');
      debugPrint('║   1️⃣ $assetConfigPath (project-specific)');
      debugPrint('║   2️⃣ $fallbackConfigPath (core package fallback)');
      debugPrint('║ 💡 Using hardcoded default values only');
      debugPrint('╚══════════════════════════════════════════════════════════╝');
      debugPrint('');
    }
    
    // Initialize and fetch remote configuration if enabled
    if (enableRemoteConfig) {
      debugPrint('🔄 Initializing Firebase Remote Config...');
      
      // Get remote config settings from asset config if available
      int fetchTimeout = assetConfigLoaded 
          ? _assetConfigHelper.getInt('firebase_configuration.remote_config_fetch_timeout', 60)
          : 60;
      int cacheExpiration = assetConfigLoaded 
          ? _assetConfigHelper.getInt('firebase_configuration.remote_config_cache_expiration', 3600)
          : 3600;
      
      bool remoteConfigSuccess = await _remoteConfigHelper.initializeAndFetch(
        fetchTimeoutSeconds: fetchTimeout,
        minimumFetchIntervalSeconds: cacheExpiration,
      );
      
      if (remoteConfigSuccess) {
        debugPrint('✅ Firebase Remote Config initialized and fetched successfully');
        
        // Sync remote config with the actually loaded config path
        bool syncSuccess = await _remoteConfigHelper.syncWithAssetConfig(actualConfigPath);
        if (syncSuccess) {
          debugPrint('✅ Remote config synced with asset config successfully');
        } else {
          debugPrint('⚠️ Remote config sync with asset config failed');
        }
      } else {
        debugPrint('⚠️ Firebase Remote Config initialization failed, using asset config only');
      }
    } else {
      debugPrint('🔒 Remote config disabled, using asset config only');
    }
    
    // Log configuration status for debugging
    if (assetConfigLoaded) {
      final configStats = _assetConfigHelper.getConfigStats();
      debugPrint('📊 Asset Config Stats: $configStats');
    }
    
    if (enableRemoteConfig) {
      final remoteConfigStatus = _remoteConfigHelper.getConfigStatus();
      debugPrint('📊 Remote Config Status: $remoteConfigStatus');
    }

    if (allowCollectDataTelemetry) {
      debugPrint(
          "Data telemetry collection is enabled. Preparing to log initialization event...");

      try {
        /// Log the initialization status
        await FirebaseAnalytics.instance
            .logEvent(name: 'osmea_core_package_initialized', parameters: {
          'osmea_core_package_version':
              await PackageInfoHelper.instance.getPackageVersion().toString(),
          'osmea_core_package_build_number': await PackageInfoHelper.instance
              .getPackageBuildNumber()
              .toString(),
          'osmea_core_package_app_name':
              await PackageInfoHelper.instance.getPackageAppName().toString(),
          'osmea_core_package_package_name':
              await PackageInfoHelper.instance.getAppPackageName().toString(),
          'osmea_core_package_version_and_build_number': await PackageInfoHelper
              .instance
              .getPackageVersionAndBuildNumber()
              .toString(),
          'osmea_core_package_manufacturer': await DeviceInfoHelper.instance
              .platformDeviceDeviceFactory()
              .toString(),
          'osmea_core_package_device_name': await DeviceInfoHelper.instance
              .platformDeviceDeviceName()
              .toString(),
          'osmea_core_package_device_id': await DeviceInfoHelper.instance
              .platformDeviceDeviceID()
              .toString(),
          'osmea_core_package_device_model': await DeviceInfoHelper.instance
              .platformDeviceDeviceModel()
              .toString(),
          'osmea_core_package_device_physical': await DeviceInfoHelper.instance
              .platformDevicePhysical()
              .toString(),
          'osmea_core_package_device_system_version': await DeviceInfoHelper
              .instance
              .platformDeviceSystemVersion()
              .toString(),
          'osmea_core_package_platform': 'Flutter',
          'osmea_core_package_locale':
              await LocaleSettings.currentLocale.toString(),
          'osmea_core_package_timezone':
              await DateTime.now().timeZoneOffset.toString(),
                  'osmea_core_package_device_platform':
            '${Platform.isIOS ? 'iOS' : Platform.isAndroid ? 'Android' : 'Web'}',
        // Add configuration tracking metadata
        'config_loaded': assetConfigLoaded,
        'config_source': actualConfigPath == assetConfigPath ? 'project' : 'core_fallback',
        'config_path': actualConfigPath,
        });
        debugPrint(
            "Initialization event logged successfully to 🔥 Firebase Analytics.");
      } catch (e) {
        // ❌ Handle any exceptions that occur during logging
        debugPrint(
            'Error logging initialization event: $e 📉'); // Log the error
      }
    } else {
      debugPrint(
          "Data telemetry collection is disabled. No event will be logged.");
    }

    /// Initialize Local Storage
    /// local storage is used to store the app data
    await _localStorageHelper.init();
    
    // Store configuration metadata in local storage
    await _localStorageHelper.setItem('osmea_config_loaded', assetConfigLoaded);
    await _localStorageHelper.setItem('osmea_config_source', actualConfigPath);
    await _localStorageHelper.setItem('osmea_config_is_fallback', actualConfigPath != assetConfigPath);
    
    // set the app data to the local storage
    await _localStorageHelper.setItem('osmea_device_id',
        await DeviceInfoHelper.instance.platformDeviceDeviceID());
    await _localStorageHelper.setItem('osmea_package_version',
        await PackageInfoHelper.instance.getPackageVersion());
    await _localStorageHelper.setItem('osmea_package_build_number',
        await PackageInfoHelper.instance.getPackageBuildNumber());
    await _localStorageHelper.setItem('osmea_package_app_name',
        await PackageInfoHelper.instance.getPackageAppName());
    await _localStorageHelper.setItem('osmea_package_package_name',
        await PackageInfoHelper.instance.getAppPackageName());
    await _localStorageHelper.setItem('osmea_package_version_and_build_number',
        await PackageInfoHelper.instance.getPackageVersionAndBuildNumber());
    await _localStorageHelper.setItem('osmea_package_manufacturer',
        await DeviceInfoHelper.instance.platformDeviceDeviceFactory());
    await _localStorageHelper.setItem('osmea_package_device_name',
        await DeviceInfoHelper.instance.platformDeviceDeviceName());
    await _localStorageHelper.setItem('osmea_package_device_id',
        await DeviceInfoHelper.instance.platformDeviceDeviceID());
    await _localStorageHelper.setItem('osmea_package_device_model',
        await DeviceInfoHelper.instance.platformDeviceDeviceModel());
    await _localStorageHelper.setItem('osmea_package_device_physical',
        await DeviceInfoHelper.instance.platformDevicePhysical());
    await _localStorageHelper.setItem('osmea_package_device_system_version',
        await DeviceInfoHelper.instance.platformDeviceSystemVersion());

    // Set the locale settings to use the device's locale
    LocaleSettings.useDeviceLocale();

    // Initialize HydratedBloc if requested
    if (hydrated) {
      await initializeHydratedBlocStorage();
    }

    // Initialize permission handler for real devices
    await PermissionHandlerHelper.instance.initializeForRealDevice();

    /// Log the initialization status
    debugPrint("MasterApp at runBefore Local Storage Initialized");
    final allItems = await _localStorageHelper.getAllItems();
    debugPrint("For Run Before All items: $allItems");
  }

  static final messengerKey = GlobalKey<ScaffoldMessengerState>();

  const MasterApp({
    super.key,
    required this.router,
    this.shouldSetOrientation =
        false, // Should the app manage device orientation?
    this.preferredOrientations = const [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ], // Preferred orientations for the app
    this.showPerformanceOverlay =
        false, // Show performance overlay for debugging
    this.textDirection = TextDirection.ltr, // Text direction for localization
    this.fontScale = 1.0, // Scale factor for text size
    this.themeMode = ThemeMode.light, // Default to light theme
    this.devModeGrid = true,
    this.devModeSpacer = true,
    this.useConfigurationHelpers = true, // Enable configuration helpers
  })  : assert(fontScale > 0, 'Font scale must be greater than 0! 🔍');

  final GoRouter router; // Router for navigation
  final bool shouldSetOrientation; // Flag to manage orientation
  final List<DeviceOrientation>
      preferredOrientations; // List of preferred orientations
  final bool showPerformanceOverlay; // Flag to show performance overlay
  final TextDirection textDirection; // Text direction for the app
  final double fontScale; // Font scaling factor
  final ThemeMode themeMode; // Theme mode for the app
  final bool devModeGrid;
  final bool devModeSpacer;
  final bool useConfigurationHelpers; // Enable configuration helpers

  @override
  Widget build(BuildContext context) {
    // 🗂️ Initialize configuration helpers if enabled
    final RemoteConfigHelper? remoteConfigHelper = useConfigurationHelpers 
        ? RemoteConfigHelper() 
        : null;

    // ⚙️ Try-catch block to handle potential exceptions during orientation setting
    try {
      if (shouldSetOrientation) {
        SystemChrome.setPreferredOrientations(preferredOrientations);
      } else {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp, // Default to portrait up
        ]);
      }
    } catch (e) {
      // ❌ Handle any exceptions that occur during orientation setting
      debugPrint(
          'Error setting preferred orientations: $e 📉'); // Log the error
    }

    // 🎨 Get theme configuration from config helpers if available
    ThemeMode effectiveThemeMode = themeMode;
    double effectiveFontScale = fontScale;
    
    if (useConfigurationHelpers && remoteConfigHelper != null) {
      // Try to get theme mode from configuration
      final String themeModeConfig = remoteConfigHelper.getString('ui_configuration.theme_mode', 'light');
      switch (themeModeConfig.toLowerCase()) {
        case 'dark':
          effectiveThemeMode = ThemeMode.dark;
          break;
        case 'system':
          effectiveThemeMode = ThemeMode.system;
          break;
        default:
          effectiveThemeMode = ThemeMode.light;
          break;
      }
      
      // Try to get font scale from configuration
      effectiveFontScale = remoteConfigHelper.getDouble('ui_configuration.font_scale', fontScale);
      
      debugPrint('🎨 Using configuration: theme=$themeModeConfig, fontScale=$effectiveFontScale');
    }

    return TranslationProvider(
      // 🌍 Wrap the app in a translation provider for localization
      child: MaterialApp.router(
        themeMode: effectiveThemeMode,
        // Theme for the app our favorite color is blue always
        // We can change it to any color we want and we can use it in the app
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        title: resources.appTitle,
        scaffoldMessengerKey:
            messengerKey, // Key for showing snackbars and dialogs
        routerConfig: router, // Configuration for the router
        showPerformanceOverlay:
            showPerformanceOverlay, // Show performance overlay if enabled
        builder: (context, child) {
          debugPrint("MasterApp at build");
          // Create the MediaQuery data with the specified font scale
          final mediaQueryData = MediaQuery.of(context).copyWith(
            textScaler:
                TextScaler.linear(effectiveFontScale), // Apply linear text scaling
          );
          Widget appContent = MediaQuery(
            data: mediaQueryData, // Provide the modified MediaQuery data
            child: Directionality(
              textDirection: textDirection, // Set the text direction
              child: child!, // Remove SafeArea from here
            ),
          );

          // Set global dev mode spacer
          globalDevModeSpacer = devModeSpacer;

          // Create overlays - grid should be on top of everything
          final overlays = <Widget>[];

          // First add the app content with SafeArea
          overlays.add(SafeArea(child: appContent, bottom: true, top: false));

          // Then add grid overlay on top if enabled
          if (devModeGrid) {
            final devGridOverlay =
                const DevGridOverlay(margin: 0, columnWidth: 16);
            overlays.add(devGridOverlay);
          }

          appContent = Stack(
            fit: StackFit.expand,
            children: overlays,
          );

          return appContent;
        },
      ),
    );
  }
}
