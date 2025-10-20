import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:core/core.dart';
import 'package:api_explorer/services/api_service_registry.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:apis/apis.dart';
import 'package:apis/services/wizard_helper.dart';
import 'package:apis/dio_config/dio_client/api_dio_client.dart';
import 'package:api_explorer/routes/app_router.dart';
import 'di/config/config_di.dart';

/// 🚀 Main entry point of the API Explorer application
Future<void> main() async {
  // 🪄🧵 Ensures Flutter bindings are initialized
  usePathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();

  // 🌐 Configure web URL strategy to use paths instead of hash (#)
  if (kIsWeb) {
    // Import and use web plugins only on web platform
    try {
      // This will be handled by the web-specific code
      // usePathUrlStrategy();
    } catch (e) {
      debugPrint('Web URL strategy not available: $e');
    }
  }

  // 🗄️ Initialize LocalStorageHelper from core package (includes SharedPreferences)
  try {
    final localStorageHelper = LocalStorageHelper();
    await localStorageHelper.init();
    debugPrint(
        '✅ LocalStorageHelper initialized successfully (includes SharedPreferences)');
  } catch (e) {
    debugPrint('❌ Error initializing LocalStorageHelper: $e');
    // 🔄 Continue anyway - we'll handle errors in the UI
  }

  // 🌐 Network initialization is now handled by the wizard system
  try {
    debugPrint(
        '🔄 Network initialization will be handled by the wizard system...');
    // Networks will be initialized when users complete the setup wizard
  } catch (e) {
    debugPrint('❌ Error in network initialization setup: $e');
    // 🔄 Continue anyway - we'll handle errors in the UI
  }

  // ⚠️🔁 Initialize API services before dependency injection
  // 🔐 This ensures handlers are properly registered
  try {
    ApiServiceRegistry.initialize();
  } catch (e) {
    debugPrint('❌ Error initializing API services: $e');
    // 🔄 Continue anyway - we'll handle errors in the UI
  }

  // 🔗🧬 Set up dependency injection with error handling
  try {
    await configureDependencies();
    debugPrint('✅ Dependency injection configured successfully');
  } catch (e) {
    debugPrint('❌ Error configuring dependencies: $e');
    // 🔄 Continue anyway - we'll handle errors in the UI
  }

  // 🔧 Initialize WizardHelper for store management
  try {
    await WizardHelper.init();
    debugPrint('✅ WizardHelper initialized successfully');
  } catch (e) {
    debugPrint('❌ Error initializing WizardHelper: $e');
    // 🔄 Continue anyway - we'll handle errors in the UI
  }

  // 🍪📦 Prepare cookies storage if not running on web
  if (!kIsWeb) {
    try {
      await ApiDioClient.prepareCookiesJar();
    } catch (e) {
      debugPrint('❌ Error preparing cookies jar: $e');
    }
  }

  // 🚀 Initialize MasterApp components
  await MasterApp.runBefore(
    allowCollectDataTelemetry: true,
    enableRemoteConfig: false, // Disable remote config for API Explorer
  );

  // ⏳ Small delay to ensure proper initialization
  if (kIsWeb) {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  // 🏁 Start the app with MasterApp using centralized router
  runApp(MasterApp(
    router: AppRouter.router,
    shouldSetOrientation: true,
    preferredOrientations: [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
    showPerformanceOverlay: false,
    textDirection: TextDirection.ltr,
    fontScale: 1.0,
    themeMode: ThemeMode.light,
    devModeGrid: false,
    devModeSpacer: false,
    useConfigurationHelpers: false, // Disable config helpers for API Explorer
  ));
}
