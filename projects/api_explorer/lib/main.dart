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
  debugPrint('🔥 API Explorer starting...');
  
  // 🔧 Critical error handler - catch all errors
  try {
    if (kIsWeb) {
      // Fast startup for web
      await _initializeWebApp();
    } else {
      // Full startup for mobile
      await _initializeApp();
    }
  } catch (e, stackTrace) {
    debugPrint('🚨 CRITICAL ERROR - Main initialization failed: $e');
    debugPrint('Stack trace: $stackTrace');

    return;
  }
}

/// 🌐 Optimized startup for web
Future<void> _initializeWebApp() async {
  debugPrint('🌐 Web app starting...');
  
  // 🪄🧵 Flutter bindings
  WidgetsFlutterBinding.ensureInitialized();
  
  // 🌐 Web URL strategy
  try {
    usePathUrlStrategy();
    debugPrint('✅ Web URL strategy configured');
  } catch (e) {
    debugPrint('❌ Web URL strategy failed: $e');
  }

  // 🗄️ Only basic storage - lazy load others
  try {
    final localStorageHelper = LocalStorageHelper();
    await localStorageHelper.init();
    debugPrint('✅ LocalStorageHelper (web) initialized');
  } catch (e) {
    debugPrint('❌ WARNING - Storage initialization failed (web): $e');
    // Continue on web
  }

  // 🚀 Start minimal app - lazy load services
  debugPrint('🚀 Minimal web app starting...');
  runApp(MasterApp(
    router: AppRouter.router,
    shouldSetOrientation: false, // No orientation on web
    preferredOrientations: [], // No orientation on web
    showPerformanceOverlay: false,
    textDirection: TextDirection.ltr,
    fontScale: 1.0,
    themeMode: ThemeMode.light,
    devModeGrid: false,
    devModeSpacer: false,
    useConfigurationHelpers: false,
  ));
  
  // 🔄 Start services in background
  _initializeServicesLazy();
}

/// 🔄 Lazy initialize services in background (for web)
void _initializeServicesLazy() {
  // Start services after UI loads
  Future.delayed(const Duration(milliseconds: 1000), () async {
    try {
      debugPrint('🔄 Background services starting...');
      
      // API Services
      try {
        ApiServiceRegistry.initialize();
        debugPrint('✅ API services (lazy) started');
      } catch (e) {
        debugPrint('❌ API services lazy failed: $e');
      }
      
      // Dependency Injection
      try {
        await configureDependencies();
        debugPrint('✅ DI (lazy) started');
      } catch (e) {
        debugPrint('❌ DI lazy failed: $e');
      }
      
      // WizardHelper
      try {
        await WizardHelper.init();
        debugPrint('✅ WizardHelper (lazy) started');
      } catch (e) {
        debugPrint('❌ WizardHelper lazy failed: $e');
      }
      
      debugPrint('🎉 Background services completed');
    } catch (e) {
      debugPrint('❌ Background service error: $e');
    }
  });
}

/// 🛠️ Main startup process - catches errors
Future<void> _initializeApp() async {
  // 🪄🧵 Ensures Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // 🌐 Configure web URL strategy to use paths instead of hash (#)
  if (kIsWeb) {
    try {
      usePathUrlStrategy();
      debugPrint('✅ Web URL strategy configured');
    } catch (e) {
      debugPrint('❌ Web URL strategy failed: $e');
    }
  }

  // 🗄️ Initialize LocalStorageHelper from core package (includes SharedPreferences)
  try {
    final localStorageHelper = LocalStorageHelper();
    await localStorageHelper.init();
    debugPrint('✅ LocalStorageHelper initialized successfully');
  } catch (e) {
    debugPrint('❌ ERROR - LocalStorageHelper initialization failed: $e');
    // This can be a critical error on web - continue but log it
    if (kIsWeb) {
      debugPrint('🌐 Web platform storage error - SharedPreferences issue possible');
    }
    // Continue - we'll handle it in UI
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
  try {
    ApiServiceRegistry.initialize();
    debugPrint('✅ API services started');
  } catch (e) {
    debugPrint('❌ ERROR - API services failed to start: $e');
    throw Exception('API services critical error: $e');
  }

  // 🔗🧬 Set up dependency injection with error handling
  try {
    await configureDependencies();
    debugPrint('✅ Dependency injection started');
  } catch (e) {
    debugPrint('❌ CRITICAL ERROR - Dependency injection failed: $e');
    throw Exception('DI system failed to start: $e');
  }

  // 🔧 Initialize WizardHelper for store management
  try {
    await WizardHelper.init();
    debugPrint('✅ WizardHelper started');
  } catch (e) {
    debugPrint('❌ WARNING - WizardHelper failed to start: $e');
    // This is not critical, app can run
    if (kIsWeb) {
      debugPrint('🌐 Web platform WizardHelper issue - storage related possible');
    }
  }

  // 🍪📦 Prepare cookies storage if not running on web
  if (!kIsWeb) {
    try {
      await ApiDioClient.prepareCookiesJar();
      debugPrint('✅ Cookies jar prepared');
    } catch (e) {
      debugPrint('❌ Cookies jar could not be prepared: $e');
    }
  } else {
    debugPrint('🌐 Web platform - cookies jar skipped');
  }

  // 🚀 Initialize MasterApp components
  try {
    await MasterApp.runBefore(
      allowCollectDataTelemetry: kIsWeb ? false : true, // Telemetry disabled on web
      enableRemoteConfig: false, // Remote config disabled for API Explorer
    );
    debugPrint('✅ MasterApp components initialized');
  } catch (e) {
    debugPrint('❌ WARNING - MasterApp initialization failed: $e');
    // This can sometimes cause issues on web, continue
  }

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