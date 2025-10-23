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
  debugPrint('🔥 API Explorer başlatılıyor...');
  
  // 🔧 Critical error handler - tüm hataları yakala
  try {
    if (kIsWeb) {
      // Web için hızlı başlatma
      await _initializeWebApp();
    } else {
      // Mobil için tam başlatma
      await _initializeApp();
    }
  } catch (e, stackTrace) {
    debugPrint('🚨 KRİTİK HATA - Ana başlatma başarısız: $e');
    debugPrint('Stack trace: $stackTrace');
    
    // Hata durumunda minimal app çalıştır
    runApp(_createErrorApp(e.toString()));
    return;
  }
}

/// 🌐 Web için optimize edilmiş başlatma
Future<void> _initializeWebApp() async {
  debugPrint('🌐 Web app başlatılıyor...');
  
  // 🪄🧵 Flutter bindings
  WidgetsFlutterBinding.ensureInitialized();
  
  // 🌐 Web URL strategy
  try {
    usePathUrlStrategy();
    debugPrint('✅ Web URL strategy configured');
  } catch (e) {
    debugPrint('❌ Web URL strategy failed: $e');
  }

  // 🗄️ Sadece temel storage - diğerlerini lazy load
  try {
    final localStorageHelper = LocalStorageHelper();
    await localStorageHelper.init();
    debugPrint('✅ LocalStorageHelper (web) başlatıldı');
  } catch (e) {
    debugPrint('❌ UYARI - Storage başlatılamadı (web): $e');
    // Web'de devam et
  }

  // 🚀 Minimal app başlat - servisleri lazy load et
  debugPrint('🚀 Minimal web app başlatılıyor...');
  runApp(MasterApp(
    router: AppRouter.router,
    shouldSetOrientation: false, // Web'de orientation yok
    preferredOrientations: [], // Web'de orientation yok
    showPerformanceOverlay: false,
    textDirection: TextDirection.ltr,
    fontScale: 1.0,
    themeMode: ThemeMode.light,
    devModeGrid: false,
    devModeSpacer: false,
    useConfigurationHelpers: false,
  ));
  
  // 🔄 Servisleri background'da başlat
  _initializeServicesLazy();
}

/// 🔄 Servisleri background'da lazy başlat (web için)
void _initializeServicesLazy() {
  // UI yüklendikten sonra servisleri başlat
  Future.delayed(const Duration(milliseconds: 1000), () async {
    try {
      debugPrint('🔄 Background servisler başlatılıyor...');
      
      // API Services
      try {
        ApiServiceRegistry.initialize();
        debugPrint('✅ API services (lazy) başlatıldı');
      } catch (e) {
        debugPrint('❌ API services lazy failed: $e');
      }
      
      // Dependency Injection
      try {
        await configureDependencies();
        debugPrint('✅ DI (lazy) başlatıldı');
      } catch (e) {
        debugPrint('❌ DI lazy failed: $e');
      }
      
      // WizardHelper
      try {
        await WizardHelper.init();
        debugPrint('✅ WizardHelper (lazy) başlatıldı');
      } catch (e) {
        debugPrint('❌ WizardHelper lazy failed: $e');
      }
      
      debugPrint('🎉 Background servisler tamamlandı');
    } catch (e) {
      debugPrint('❌ Background servis hatası: $e');
    }
  });
}

/// 🛠️ Ana başlatma işlemi - hataları yakalar
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
    debugPrint('❌ HATA - LocalStorageHelper başlatılamadı: $e');
    // Web'de bu kritik bir hata olabilir - devam et ama logla
    if (kIsWeb) {
      debugPrint('🌐 Web platformda storage hatası - SharedPreferences sorunu olabilir');
    }
    // Devam et - UI'da handle ederiz
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
    debugPrint('✅ API services başlatıldı');
  } catch (e) {
    debugPrint('❌ HATA - API servisleri başlatılamadı: $e');
    throw Exception('API servisleri kritik hata: $e');
  }

  // 🔗🧬 Set up dependency injection with error handling
  try {
    await configureDependencies();
    debugPrint('✅ Dependency injection başlatıldı');
  } catch (e) {
    debugPrint('❌ KRİTİK HATA - Dependency injection başarısız: $e');
    throw Exception('DI sistemi başlatılamadı: $e');
  }

  // 🔧 Initialize WizardHelper for store management
  try {
    await WizardHelper.init();
    debugPrint('✅ WizardHelper başlatıldı');
  } catch (e) {
    debugPrint('❌ UYARI - WizardHelper başlatılamadı: $e');
    // Bu kritik değil, uygulama çalışabilir
    if (kIsWeb) {
      debugPrint('🌐 Web platformda WizardHelper sorunu - storage ile ilgili olabilir');
    }
  }

  // 🍪📦 Prepare cookies storage if not running on web
  if (!kIsWeb) {
    try {
      await ApiDioClient.prepareCookiesJar();
      debugPrint('✅ Cookies jar hazırlandı');
    } catch (e) {
      debugPrint('❌ Cookies jar hazırlanamadı: $e');
    }
  } else {
    debugPrint('🌐 Web platformu - cookies jar atlandı');
  }

  // 🚀 Initialize MasterApp components
  try {
    await MasterApp.runBefore(
      allowCollectDataTelemetry: kIsWeb ? false : true, // Web'de telemetry kapalı
      enableRemoteConfig: false, // API Explorer için remote config kapalı
    );
    debugPrint('✅ MasterApp bileşenleri başlatıldı');
  } catch (e) {
    debugPrint('❌ UYARI - MasterApp başlatılamadı: $e');
    // Web'de bu bazen sorun çıkarabilir, devam et
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

/// 🚨 Hata durumunda gösterilecek minimal app
Widget _createErrorApp(String error) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      backgroundColor: Colors.red.shade50,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red.shade600,
              ),
              const SizedBox(height: 24),
              Text(
                'Uygulama Başlatma Hatası',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade800,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Text(
                  error,
                  style: const TextStyle(
                    fontFamily: 'Courier',
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // Web'de sayfayı yenile
                  if (kIsWeb) {
                    // ignore: avoid_web_libraries_in_flutter
                    // html.window.location.reload();
                  }
                },
                child: const Text('Sayfayı Yenile'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}