import 'package:core/src/helper/local_storage/local_storage_helper.dart';
import 'package:core/src/resources/resources.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

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


  static Future<void> runBefore() async {
    // Check: If we are not on the web platform
    final LocalStorageHelper _localStorageHelper = LocalStorageHelper();
      await _localStorageHelper.init();
      
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
    // Try-catch block to handle potential exceptions during orientation setting
    try {
      if (shouldSetOrientation) {
        SystemChrome.setPreferredOrientations(preferredOrientations);
      } else {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp, // Default to portrait up
        ]);
      }
    } catch (e) {
      // Handle any exceptions that occur during orientation setting
      debugPrint(
          'Error setting preferred orientations: $e 📉'); // Log the error
    }

    return TranslationProvider(
      // Wrap the app in a translation provider for localization
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
