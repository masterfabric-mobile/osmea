import 'dart:io';

import 'package:core/firebase_options.dart';
import 'package:core/src/helper/device_info_helper.dart';
import 'package:core/src/helper/local_storage/local_storage_helper.dart';
import 'package:core/src/helper/package_info_helper.dart';
import 'package:core/src/resources/resources.g.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

/// 🚀 MasterApp: The main entry point for the application
/// This class initializes Firebase, sets up local storage, and manages app settings.
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
  /// This method is responsible for setting up Firebase, initializing local storage,
  /// and logging important events related to the app's startup process.
  /// 
  /// Parameters:
  /// - [allowCollectDataTelemetry]: A boolean flag that determines whether
  ///   data telemetry should be collected and sent to Firebase Analytics.
  ///   By default, this is set to true, meaning that telemetry data will be collected.
  ///   If set to false, no telemetry data will be sent, allowing users to opt-out
  ///   of data collection for privacy or other reasons.
  /// 
  /// This is a critical method as it ensures that all necessary components are
  /// properly initialized before the app starts functioning. It also respects
  /// user preferences regarding data collection, which is increasingly important
  /// in today's privacy-conscious environment.
  /// 
  ///  update date 11/05/2025 
  static Future<void> runBefore(
  {
    bool allowCollectDataTelemetry = true,
  }
  ) async {
    // 🛠️ Initialize necessary components before running the app
    final LocalStorageHelper _localStorageHelper = LocalStorageHelper();

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

    if (allowCollectDataTelemetry) {
      debugPrint("Data telemetry collection is enabled. Preparing to log initialization event...");

      try {
        /// Log the initialization status
        await FirebaseAnalytics.instance
            .logEvent(name: 'osmea_core_package_initialized', parameters: {
          'osmea_core_package_version': await PackageInfoHelper.instance.getPackageVersion().toString(),
          'osmea_core_package_build_number': await PackageInfoHelper.instance.getPackageBuildNumber().toString(),
          'osmea_core_package_app_name': await PackageInfoHelper.instance.getPackageAppName().toString(),
          'osmea_core_package_package_name': await PackageInfoHelper.instance.getAppPackageName().toString(),
          'osmea_core_package_version_and_build_number': await PackageInfoHelper.instance.getPackageVersionAndBuildNumber().toString(),
          'osmea_core_package_manufacturer': await DeviceInfoHelper.instance.platformDeviceDeviceFactory().toString(),
          'osmea_core_package_device_name': await DeviceInfoHelper.instance.platformDeviceDeviceName().toString(),
          'osmea_core_package_device_id': await DeviceInfoHelper.instance.platformDeviceDeviceID().toString(),
          'osmea_core_package_device_model': await DeviceInfoHelper.instance.platformDeviceDeviceModel().toString(),
          'osmea_core_package_device_physical': await DeviceInfoHelper.instance.platformDevicePhysical().toString(),
          'osmea_core_package_device_system_version': await DeviceInfoHelper.instance.platformDeviceSystemVersion().toString(),
          'osmea_core_package_platform': 'Flutter',
          'osmea_core_package_locale': await LocaleSettings.currentLocale.toString(),
          'osmea_core_package_timezone': await DateTime.now().timeZoneOffset.toString(),
          'osmea_core_package_device_platform': '${Platform.isIOS ? 'iOS' : Platform.isAndroid ? 'Android' : 'Web'}',
        });
        debugPrint("Initialization event logged successfully.");
      } catch (e) {
        // ❌ Handle any exceptions that occur during logging
        debugPrint('Error logging initialization event: $e 📉'); // Log the error
      }
    } else {
      debugPrint("Data telemetry collection is disabled. No event will be logged.");
    }
    
    /// Initialize Local Storage
    /// local storage is used to store the app data
    await _localStorageHelper.init();
    // set the app data to the local storage
    await _localStorageHelper.setItem('osmea_device_id', await DeviceInfoHelper.instance.platformDeviceDeviceID());
    await _localStorageHelper.setItem('osmea_package_version', await PackageInfoHelper.instance.getPackageVersion());
    await _localStorageHelper.setItem('osmea_package_build_number', await PackageInfoHelper.instance.getPackageBuildNumber());
    await _localStorageHelper.setItem('osmea_package_app_name', await PackageInfoHelper.instance.getPackageAppName());
    await _localStorageHelper.setItem('osmea_package_package_name', await PackageInfoHelper.instance.getAppPackageName());
    await _localStorageHelper.setItem('osmea_package_version_and_build_number', await PackageInfoHelper.instance.getPackageVersionAndBuildNumber());
    await _localStorageHelper.setItem('osmea_package_manufacturer', await DeviceInfoHelper.instance.platformDeviceDeviceFactory());
    await _localStorageHelper.setItem('osmea_package_device_name', await DeviceInfoHelper.instance.platformDeviceDeviceName());
    await _localStorageHelper.setItem('osmea_package_device_id', await DeviceInfoHelper.instance.platformDeviceDeviceID());
    await _localStorageHelper.setItem('osmea_package_device_model', await DeviceInfoHelper.instance.platformDeviceDeviceModel());
    await _localStorageHelper.setItem('osmea_package_device_physical', await DeviceInfoHelper.instance.platformDevicePhysical());
    await _localStorageHelper.setItem('osmea_package_device_system_version', await DeviceInfoHelper.instance.platformDeviceSystemVersion());

    // Set the locale settings to use the device's locale
    LocaleSettings.useDeviceLocale();

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
  })  : assert(router != null,
            'Router cannot be null! 🚫'), // Ensure router is provided
        assert(fontScale > 0,
            'Font scale must be greater than 0! 🔍'); // Ensure font scale is positive

  final GoRouter router; // Router for navigation
  final bool shouldSetOrientation; // Flag to manage orientation
  final List<DeviceOrientation>
      preferredOrientations; // List of preferred orientations
  final bool showPerformanceOverlay; // Flag to show performance overlay
  final TextDirection textDirection; // Text direction for the app
  final double fontScale; // Font scaling factor
  final ThemeMode themeMode; // Theme mode for the app

  @override
  Widget build(BuildContext context) {
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

    return TranslationProvider(
      // 🌍 Wrap the app in a translation provider for localization
      child: MaterialApp.router(
        themeMode: themeMode,
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
          // Create the MediaQuery data with the specified font scale
          final mediaQueryData = MediaQuery.of(context).copyWith(
            textScaler:
                TextScaler.linear(fontScale), // Apply linear text scaling
          );

          return MediaQuery(
            data: mediaQueryData, // Provide the modified MediaQuery data
            child: Directionality(
              textDirection: textDirection, // Set the text direction
              child: child!, // Ensure the child is not null
            ),
          );
        },
      ),
    );
  }

}
